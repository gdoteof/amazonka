{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TupleSections     #-}
{-# LANGUAGE TypeOperators     #-}

-- Module      : Compiler.AST.Solve
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Compiler.AST.Solve
    ( solve
    ) where

import           Compiler.AST.Cofree
import           Compiler.Protocol
import           Compiler.Types
import           Control.Arrow          ((&&&))
import           Control.Comonad.Cofree
import           Control.Lens           hiding (enum, mapping, (??))
import           Control.Monad.State
import           Data.Foldable          (foldr')
import qualified Data.HashMap.Strict    as Map
import qualified Data.HashSet           as Set
import           Data.List              (intersect, nub, sort)
import           Data.Monoid            hiding (Product, Sum)

solve :: (Traversable t, HasId a)
      => Config
      -> Protocol
      -> t (Shape (a ::: Direction))
      -> t (Shape (a ::: Direction ::: Solved))
solve cfg proto = (`evalState` env) . traverse (assoc . annotate id (pure . ann))
 where
    assoc :: (Functor f, Functor g)
          => f (g ((a ::: b) ::: c))
          -> f (g (a ::: b ::: c))
    assoc = fmap (fmap rassoc)

    env :: Map Id Solved
    env = replaced def cfg
      where
        def x = x ^. replaceName . typeId . to TType
            ::: x ^. replaceDeriving . to Set.toList
            ::: instances proto mempty

    ann :: HasId a => Shape (a ::: Direction) -> Solved
    ann x@((_ ::: d) :< _) = typeOf x ::: derive x ::: instances proto d

typeOf :: HasId a => Shape a -> TType
typeOf (x :< s) =
    let n = identifier x
     in sensitive s $
        case s of
            Struct {}    -> TType (n ^. typeId)
            Enum   {}    -> TType (n ^. typeId)
            List   i e
                | nonEmpty i -> TList1 t
                | otherwise  -> TList  t
              where
                t = typeOf (e ^. refAnn)
            Map    _ k v -> TMap (typeOf (k ^. refAnn)) (typeOf (v ^. refAnn))
            Lit    i l   ->
                case l of
                    Int  -> natural i (TLit l)
                    Long -> natural i (TLit l)
                    _    -> TLit l

natural :: HasInfo a => a -> (TType -> TType)
natural x
    | Just i <- x ^. infoMin
    , i >= 0    = const TNatural
    | otherwise = id

sensitive :: HasInfo a => a -> (TType -> TType)
sensitive x
    | x ^. infoSensitive = TSensitive
    | otherwise          = id

optional :: Bool -> TType -> TType
optional True  t = t
optional False t =
    case t of
        TMaybe {} -> t
        TList  {} -> t
        TList1 {} -> t
        TMap   {} -> t
        _         -> TMaybe t

-- FIXME: Filter constraints based on info like min/max of lists etc.
derive :: Shape a -> [Derive]
derive (_ :< s) = nub . sort $ shape s
  where
    shape :: ShapeF (Shape a) -> [Derive]
    shape = \case
        Struct _ ms -> foldr' (intersect . derive) base ms
        List   {}   -> base <> monoid
        Map    {}   -> base <> monoid
        Enum   {}   -> base <> enum
        Lit    _ l  -> lit l

    lit :: Lit -> [Derive]
    lit = \case
        Int    -> base <> num
        Long   -> base <> num
        Double -> base <> frac
        Text   -> base <> string
        Blob   -> [DShow]
        Time   -> base <> enum
        Bool   -> base <> enum

    string = [DIsString]
    num    = [DEnum, DNum, DIntegral, DReal]
    frac   = [DRealFrac, DRealFloat]
    monoid = [DMonoid, DSemigroup]
    enum   = [DEnum]
    base   = [DEq, DOrd, DRead, DShow]

replaced :: (Replace -> a) -> Config -> Map Id a
replaced f =
      Map.fromList
    . map (_replaceName &&& f)
    . Map.elems
    . vMapMaybe _replacedBy
    . _typeOverrides