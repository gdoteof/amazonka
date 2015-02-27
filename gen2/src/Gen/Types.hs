{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveFoldable             #-}
{-# LANGUAGE DeriveFunctor              #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DeriveTraversable          #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE KindSignatures             #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TupleSections              #-}
{-# LANGUAGE ViewPatterns               #-}

{-# OPTIONS_GHC -fno-warn-orphans       #-}

-- Module      : Gen.Types
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Gen.Types where

import           Control.Applicative
import           Control.Lens
import           Data.Bifunctor
import           Data.CaseInsensitive         (CI)
import qualified Data.CaseInsensitive         as CI
import           Data.Default.Class
import           Data.Function                (on)
import           Data.Hashable                (Hashable)
import           Data.HashMap.Strict          (HashMap)
import qualified Data.HashMap.Strict          as Map
import           Data.HashSet                 (HashSet)
import           Data.Jason.Types
import           Data.Monoid
import           Data.SemVer                  (Version, fromText)
import           Data.String
import           Data.Text                    (Text)
import qualified Data.Text                    as Text
import qualified Filesystem.Path.CurrentOS    as Path
import           Gen.OrdMap                   (OrdMap)
import qualified Gen.OrdMap                   as OrdMap
import           GHC.Generics                 (Generic)
import           Language.Haskell.Exts.Syntax (Type)
import           Text.EDE                     (Template)

type Untyped (f :: * -> *) = f Text
type Typed   (f :: * -> *) = f Type

type TextMap = HashMap Text
type TextSet = HashSet Text

encode :: Path.FilePath -> Text
encode = either id id . Path.toText

-- data Pre a = Pre
--     { _preKey  :: Text
--     , _preItem :: a
--     } deriving (Eq, Show)

-- makeLenses ''Pre
--
-- data Name a = Name
--     { _nameKey  :: Text
--     , _nameItem :: a
--     } deriving (Eq, Show)

-- makeLenses ''Name

data Member = Member
    { _memPrefix   :: Maybe Text
    , _memOriginal :: Text
    , _memName     :: Text
    } deriving (Show, Generic)

member :: Text -> Member
member t = Member Nothing t t

instance Eq Member where
    (==) = on (==) _memName

instance Hashable Member

instance IsString Member where
    fromString (fromString -> t) = Member Nothing t t

instance FromJSON Member where
    parseJSON = withText "member" (pure . member)

makeLenses ''Member

data Rules = Rules
    { _ruleRenameTo   :: Maybe Text             -- ^ Rename type
    , _ruleReplacedBy :: Maybe Text             -- ^ Existing type that supplants this type
    , _ruleEnumPrefix :: Maybe Text             -- ^ Enum constructor prefix
    , _ruleEnumValues :: OrdMap Member Text     -- ^ Supplemental sum constructors.
    , _ruleRequired   :: HashSet (CI Text)      -- ^ Required fields
    , _ruleOptional   :: HashSet (CI Text)      -- ^ Optional fields
    , _ruleRenamed    :: HashMap (CI Text) Text -- ^ Rename fields
    } deriving (Eq, Show)

makeLenses ''Rules

instance FromJSON Rules where
    parseJSON = withObject "rules" $ \o -> Rules
        <$> o .:? "renameTo"
        <*> o .:? "replacedBy"
        <*> o .:? "enumPrefix"
        <*> (omap <$> o .:? "enumValues" .!= mempty)
        <*> o .:? "required"   .!= mempty
        <*> o .:? "optional"   .!= mempty
        <*> o .:? "renamed"    .!= mempty
      where
        omap = OrdMap.fromList . map (first member)

instance Default Rules where
    def = Rules Nothing Nothing Nothing mempty mempty mempty mempty

data Override = Override
    { _ovOperationImports :: [Text]
    , _ovTypeImports      :: [Text]
    , _ovIgnoredWaiters   :: HashSet (CI Text)
    , _ovOverrides        :: HashMap Text Rules
    } deriving (Eq, Show)

makeClassy ''Override

instance FromJSON Override where
    parseJSON = withObject "override" $ \o -> Override
        <$> o .:? "operationImports" .!= mempty
        <*> o .:? "typeImports"      .!= mempty
        <*> o .:? "ignoredWaiters"   .!= mempty
        <*> o .:? "overrides"        .!= mempty

data Templates a = Templates
    { _tmplCabal           :: Template
    , _tmplService         :: Template
    , _tmplWaiters         :: Template
    , _tmplReadme          :: Template
    , _tmplCabalExample    :: Template
    , _tmplMakefileExample :: Template
    , _tmplSelect          :: a -> (Template, Template)
    }

makeLenses ''Templates

tmplTypes, tmplOperation :: Getter (Templates a) (a -> Template)
tmplTypes     = to (\s -> fst . _tmplSelect s)
tmplOperation = to (\s -> snd . _tmplSelect s)

instance FromJSON (CI Text) where
    parseJSON = withText "ci" (return . CI.mk)

instance FromJSON a => FromJSON (HashMap (CI Text) a) where
    parseJSON = fmap (Map.fromList . map (first CI.mk) . Map.toList) . parseJSON

instance FromJSON Version where
    parseJSON = withText "semantic_version" $
        either fail return . fromText
