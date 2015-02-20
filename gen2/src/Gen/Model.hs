{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TupleSections     #-}

-- Module      : Gen.Model
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Gen.Model
   ( module Gen.Model
   , module Model
   ) where

import           Control.Applicative
import           Control.Lens
import           Control.Monad
import           Data.Bifunctor
import           Data.CaseInsensitive (CI)
import           Data.HashMap.Strict  (HashMap)
import qualified Data.HashMap.Strict  as Map
import           Data.HashSet         (HashSet)
import           Data.Jason
import           Data.Monoid
import           Data.Text            (Text)
import qualified Data.Text            as Text
import           Gen.Documentation
-- import           Gen.Model.Index      as Model
import           Gen.Model.Paginator  as Model
import           Gen.Model.Retrier    as Model
import           Gen.Model.URI        as Model
import           Gen.Model.Waiter     as Model
import           Gen.OrdMap           (OrdMap)
import qualified Gen.OrdMap           as OrdMap
import           Gen.Text
import           Gen.TH
import           Gen.Types
import           Prelude              hiding (Enum)

data Method
    = GET
    | POST
    | HEAD
    | PUT
    | DELETE
      deriving (Eq, Show)

deriveFromJSON upper ''Method

data Signature
    = V2
    | V3
    | V3HTTPS
    | V4
    | S3
      deriving (Eq, Show)

deriveFromJSON lower ''Signature

data Protocol
    = JSON
    | RestJSON
    | XML
    | RestXML
    | Query
    | EC2
      deriving (Eq, Show)

deriveFromJSON spinal ''Protocol

data Timestamp
    = RFC822
    | ISO8601
    | POSIX
      deriving (Eq, Show)

instance FromJSON Timestamp where
    parseJSON = withText "timestamp" $ \case
        "rfc822"        -> pure RFC822
        "iso8601"       -> pure ISO8601
        "unixTimestamp" -> pure POSIX
        e               -> fail ("Unknown Timestamp: " ++ Text.unpack e)

data Checksum
    = MD5
    | SHA256
      deriving (Eq, Show)

deriveFromJSON lower ''Checksum

data Location
    = Headers
    | Header
    | Uri
    | Querystring
    | StatusCode
    | Body
      deriving (Eq, Show)

deriveFromJSON camel ''Location

data XMLNS = XMLNS
    { _xnsPrefix :: !Text
    , _xnsUri    :: !Text
    } deriving (Eq, Show)

makeLenses ''XMLNS
deriveFromJSON camel ''XMLNS

-- | A reference to a 'Shape', plus any additional annotations
-- specific to the point at which the type is de/serialised.
data Ref a = Ref
    { _refShape         :: !Text
    , _refDocumentation :: Maybe Doc
    , _refLocation      :: Maybe Location
    , _refLocationName  :: Maybe Text
    , _refStreaming     :: !Bool
    , _refResultWrapper :: Maybe Text
    , _refWrapper       :: !Bool
    , _refFlattened     :: !Bool
    , _refException     :: !Bool
    , _refFault         :: !Bool
    } deriving (Eq, Show)

makeLenses ''Ref

instance FromJSON (Ref Text) where
    parseJSON = withObject "ref" $ \o -> Ref
        <$> o .:  "shape"
        <*> o .:? "documentation"
        <*> o .:? "location"
        <*> o .:? "locationName"
        <*> o .:? "streaming" .!= False
        <*> o .:? "resultWrapper"
        <*> o .:? "wrapper"   .!= False
        <*> o .:? "flattened" .!= False
        <*> o .:? "exception" .!= False
        <*> o .:? "fault"     .!= False

data List a = List
    { _listDocumentation :: Maybe Doc
    , _listMember        :: Ref a
    , _listMin           :: Maybe Int
    , _listMax           :: Maybe Int
    , _listFlattened     :: Maybe Bool
    , _listLocationName  :: Maybe Text
    } deriving (Eq, Show)

instance FromJSON (List Text) where
    parseJSON = withObject "list" $ \o -> List
        <$> o .:? "documentation"
        <*> o .:  "member"
        <*> o .:? "min"
        <*> o .:? "max"
        <*> o .:? "flattened"
        <*> o .:? "locationName"

data Map a = Map
    { _mapDocumentation :: Maybe Doc
    , _mapKey           :: Ref a
    , _mapValue         :: Ref a
    , _mapMin           :: Maybe Int
    , _mapMax           :: Maybe Int
    , _mapFlattened     :: Maybe Bool
    } deriving (Eq, Show)

instance FromJSON (Map Text) where
    parseJSON = withObject "map" $ \o -> Map
        <$> o .:? "documentation"
        <*> o .:  "key"
        <*> o .:  "value"
        <*> o .:? "min"
        <*> o .:? "max"
        <*> o .:? "flattened"

data Struct a = Struct
    { _structDocumentation :: Maybe Doc
    , _structRequired      :: HashSet (CI Text)
    , _structPayload       :: Maybe Text
    , _structXmlNamespace  :: Maybe XMLNS
    , _structException     :: Maybe Bool
    , _structFault         :: Maybe Bool
    , _structMembers       :: OrdMap Member (Ref a)
    } deriving (Eq, Show)

instance FromJSON (Struct Text) where
    parseJSON = withObject "structure" $ \o -> Struct
        <$> o .:? "documentation"
        <*> o .:? "required" .!= mempty
        <*> o .:? "payload"
        <*> o .:? "xmlNamespace"
        <*> o .:? "exception"
        <*> o .:? "fault"
        <*> (keys <$> o .:? "members" .!= mempty)
      where
        keys = OrdMap.mapWithKey (\k -> (Member k k,))

data Chars = Chars
    { _charsDocumentation :: Maybe Doc
    , _charsMin           :: Maybe Int
    , _charsMax           :: Maybe Int
    , _charsPattern       :: Maybe Text
    , _charsXmlAttribute  :: Maybe Bool
    , _charsLocationName  :: Maybe Text
    , _charsSensitive     :: Maybe Bool
    } deriving (Eq, Show)

data Enum = Enum
    { _enumDocumentation :: Maybe Doc
    , _enumLocationName  :: Maybe Text
    , _enumValues        :: HashMap Text Text
    } deriving (Eq, Show)

instance FromJSON Enum where
    parseJSON = withObject "enum" $ \o -> Enum
        <$> o .:? "documentation"
        <*> o .:? "locationName"
        <*> (hmap <$> o .: "enum")
      where
        hmap = Map.fromList . map (first constructor . join (,))

data Blob = Blob
    { _blobDocumentation :: Maybe Doc
    , _blobSensitive     :: Maybe Bool
    , _blobStreaming     :: Maybe Bool
    } deriving (Eq, Show)

data Boolean = Boolean
    { _boolDocumentation :: Maybe Doc
    , _boolBox           :: Maybe Bool
    } deriving (Eq, Show)

data Time = Time
    { _timeDocumentation   :: Maybe Doc
    , _timeTimestampFormat :: Maybe Timestamp
    } deriving (Eq, Show)

data Number a = Number
    { _numDocumentation :: Maybe Doc
    , _numMin           :: Maybe a
    , _numMax           :: Maybe a
    , _numBox           :: Maybe Bool
    } deriving (Eq, Show)

deriveFromJSON defaults ''Chars
deriveFromJSON defaults ''Blob
deriveFromJSON defaults ''Boolean
deriveFromJSON defaults ''Time
deriveFromJSON defaults ''Number

makeLenses ''List
makeLenses ''Map
makeLenses ''Struct
makeLenses ''Chars
makeLenses ''Enum
makeLenses ''Blob
makeLenses ''Boolean
makeLenses ''Time
makeLenses ''Number

-- | The sum of all possible types.
data Shape a
    = SList   (List   a)
    | SMap    (Map    a)
    | SStruct (Struct a)
    | SString Chars
    | SEnum   Enum
    | SBlob   Blob
    | SBool   Boolean
    | STime   Time
    | SInt    (Number Int)
    | SDouble (Number Double)
    | SLong   (Number Integer)
      deriving (Eq, Show)

makePrisms ''Shape

instance FromJSON (Shape Text) where
    parseJSON = withObject "shape" $ \o -> do
        let f g = g <$> parseJSON (Object o)
        o .: "type" >>= \case
            "list"      -> f SList
            "map"       -> f SMap
            "structure" -> f SStruct
            "string"    -> f SEnum <|> f SString
            "blob"      -> f SBlob
            "boolean"   -> f SBool
            "timestamp" -> f STime
            "integer"   -> f SInt
            "float"     -> f SDouble
            "double"    -> f SDouble
            "long"      -> f SLong
            e           -> fail ("Unknown Shape type: " ++ Text.unpack e)

references  :: Traversal' (Shape a) (Ref a)
references f = \case
    SList   s -> (\m -> SList (s & listMember .~ m))
        <$> f (_listMember s)
    SMap    s -> (\k v -> SMap (s & mapKey .~ k & mapValue .~ v))
        <$> f (_mapKey s) <*> f (_mapValue s)
    SStruct s -> (\ms -> SStruct (s & structMembers .~ ms))
        <$> traverse f (_structMembers s)
    s         -> pure s

-- | Applicable HTTP components for an operation.
data HTTP = HTTP
    { _httpMethod     :: !Method
    , _httpRequestUri :: !URI
    , _httpStatus     :: Maybe Int
    } deriving (Eq, Show)

deriveFromJSON camel ''HTTP

-- | An individual service opereration.
data Operation a = Operation
    { _operName             :: !Text
    , _operDocumentation    :: Maybe Doc
    , _operDocumentationUrl :: Maybe Text
    , _operHttp             :: !HTTP
    , _operInput            :: Maybe a
    , _operOutput           :: Maybe a
    , _operErrors           :: [a]
    } deriving (Eq, Show)

makeLenses ''Operation

instance FromJSON (Operation (Ref Text)) where
    parseJSON = withObject "operation" $ \o -> Operation
        <$> o .:  "name"
        <*> o .:? "documentation"
        <*> o .:? "documentationUrl"
        <*> o .:  "http"
        <*> o .:? "input"
        <*> o .:? "output"
        <*> o .:? "errors" .!= mempty

newtype Name = Name { nameToText :: Text }
    deriving (Eq, Show)

instance FromJSON Name where
    parseJSON = withText "name" (pure . Name . f)
      where
        f = ("Amazon " <>)
          . (<> " Service")
          . stripPrefix "Amazon"
          . stripPrefix "AWS"
          . stripSuffix "Service"

newtype Abbrev = Abbrev { abbrevToText :: Text }
    deriving (Eq, Show)

instance FromJSON Abbrev where
    parseJSON = withText "abbrev" (pure . Abbrev)

-- | Top-level service metadata.
data Metadata = Metadata
    { _metaServiceFullName     :: !Name
    , _metaServiceAbbreviation :: !Abbrev
    , _metaApiVersion          :: !Text
    , _metaEndpointPrefix      :: !Text
    , _metaGlobalEndpoint      :: Maybe Text
    , _metaSignatureVersion    :: !Signature
    , _metaXmlNamespace        :: Maybe Text
    , _metaTargetPrefix        :: Maybe Text
    , _metaJsonVersion         :: Maybe Text
    , _metaTimestampFormat     :: Maybe Timestamp
    , _metaChecksumFormat      :: Maybe Checksum
    , _metaProtocol            :: !Protocol
    } deriving (Eq, Show)

makeClassy ''Metadata
deriveFromJSON camel ''Metadata

data Service a b = Service
    { _svcMetadata         :: !Metadata
    , _svcLibrary          :: !Text
    , _svcDocumentation    :: !Doc
    , _svcDocumentationUrl :: !Text
    , _svcOperations       :: HashMap Text (Operation b)
    , _svcShapes           :: HashMap Text a
    , _svcOverride         :: !Override
    } deriving (Eq, Show)

makeLenses ''Service

instance HasMetadata (Service a b) where metadata = svcMetadata
instance HasOverride (Service a b) where override = svcOverride

svcName, svcAbbrev :: Getter (Service a b) Text
svcName   = metaServiceFullName     . to nameToText
svcAbbrev = metaServiceAbbreviation . to abbrevToText

instance FromJSON (Service (Shape Text) (Ref Text)) where
    parseJSON = withObject "service" $ \o -> Service
        <$> o .:  "metadata"
        <*> o .:  "library"
        <*> o .:  "documentation"
        <*> o .:? "documentationUrl" .!= mempty -- FIXME: temporarily defaulted
        <*> o .:  "operations"
        <*> o .:  "shapes"
        <*> parseJSON (Object o)