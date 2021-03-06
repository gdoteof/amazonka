{-# LANGUAGE OverloadedStrings #-}

-- Module      : Gen.Names
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Gen.Names where

import qualified Data.CaseInsensitive as CI
import           Data.Char
import qualified Data.HashSet         as Set
import           Data.Maybe
import           Data.Monoid
import           Data.Text            (Text)
import qualified Data.Text            as Text
import           Data.Text.Manipulate
import           Text.Parsec.Language
import           Text.Parsec.Token    (reservedNames)

operationName :: Text -> Text
operationName t = fromMaybe t (Text.stripSuffix "Request" t)

enumName :: Text -> Bool -> Text -> Text -> Text
enumName t u k1 v1
    | t == "InstanceType" = instanceType v1
    | t == "RecordType"   = Text.toUpper v1
    | otherwise           = k2 <> reserved (toPascal v3)
  where
    k2 | u         = Text.toUpper k1
       | otherwise = k1

    v3 | Text.all f v2 = Text.toLower v2
       | otherwise     = v2

    v2 = Text.replace ":" "-" v1

    f c = isUpper c || c `elem` ("-_/" :: String)

instanceType :: Text -> Text
instanceType v
    | Just (x, _) <- Text.uncons v
    , isUpper x = v
    | otherwise = Text.toUpper pre <> "_" <> suf
  where
    suf = upperHead . Text.replace "xl" "XL" $ Text.dropWhile (== '.') s

    (pre, s) = Text.break (== '.') v

lensName :: Text -> Text
lensName = stripText "_"

typeName :: Text -> Text
typeName = upperHead

fieldName :: Text -> Text
fieldName = mappend "_" . lensName

keyPython :: Text -> Text
keyPython = toSnake . keyName . Text.replace "." "_"

keyName :: Text -> Text
keyName t
    | "_" `Text.isPrefixOf` t = lowerHead (dropLower t)
    | otherwise               = t

ctor :: Text -> Text -> Text
ctor p = toCamel . stripText p

ctorName :: Text -> Text
ctorName = toSpinal . Text.dropWhileEnd (== '\'')

dropLower :: Text -> Text
dropLower = Text.dropWhile (not . isUpper)

stripAWS :: Text -> Text
stripAWS = Text.strip
    . stripText "Amazon"
    . Text.strip
    . stripText "AWS"
    . Text.strip

stripText :: Text -> Text -> Text
stripText p t = fromMaybe t (p `Text.stripPrefix` t)

numericSuffix :: Text -> Text
numericSuffix t
    | Text.null t                 = Text.singleton '1'
    | x <- Text.last t, isDigit x = Text.init t `Text.snoc` succ x
    | otherwise                   = t `Text.snoc` '1'

reserved :: Text -> Text
reserved x
    | CI.mk x `Set.member` xs = x <> "'"
    | otherwise               = x
  where
    xs = Set.fromList $
        prelude ++ map (CI.mk . Text.pack) (reservedNames haskellDef)

    prelude =
        [ "head"
        , "tail"
        , "delete"
        , "filter"
        , "true"
        , "false"
        , "map"
        , "mape"
        , "object"
        , "list"
        , "list1"
        ]
