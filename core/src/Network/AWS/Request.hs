{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.Request
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)

module Network.AWS.Request
    (
    -- * Requests
      head'
    , delete
    , get
    , postJSON
    , postQuery
    , putXML
    , putBody

    , defaultRequest
    , contentSHA256

    -- * Lenses
    , method
    , host
    , path
    , queryString
    , requestBody
    , requestHeaders
    ) where

import           Control.Lens
import           Data.Default.Class
import           Data.Monoid
import qualified Data.Text.Encoding           as Text
import           Network.AWS.Data.Body
import           Network.AWS.Data.ByteString
import           Network.AWS.Data.Header
import           Network.AWS.Data.JSON
import           Network.AWS.Data.Path
import           Network.AWS.Data.Query
import           Network.AWS.Data.XML
import           Network.AWS.Types
import qualified Network.HTTP.Client.Internal as HTTP
import           Network.HTTP.Types           (StdMethod (..))
import qualified Network.HTTP.Types           as HTTP

head' :: (ToPath a, ToQuery a, ToHeaders a) => a -> Request a
head' x = get x & rqMethod .~ HEAD

delete :: (ToPath a, ToQuery a, ToHeaders a) => a -> Request a
delete x = get x & rqMethod .~ DELETE

get :: (ToPath a, ToQuery a, ToHeaders a) => a -> Request a
get = contentSHA256 . defaultRequest

postJSON :: (ToQuery a, ToPath a, ToHeaders a, ToJSON a) => a -> Request a
postJSON x = defaultRequest x
    & rqMethod .~ POST
    & rqBody    .~ toBody (toJSON x)
    & contentSHA256

postQuery :: (ToQuery a, ToPath a, ToHeaders a) => a -> Request a
postQuery x = defaultRequest x
    & rqMethod .~ POST
    & rqQuery <>~ toQuery x
    & contentSHA256

putXML :: (ToPath a, ToQuery a, ToHeaders a, ToElement a) => a -> Request a
putXML x = defaultRequest x
    & rqMethod .~ PUT
    & rqBody   .~ toBody (encodeXML x)
    & contentSHA256

putBody :: (ToPath a, ToQuery a, ToHeaders a, ToBody a) => a -> Request a
putBody x = defaultRequest x
    & rqMethod .~ PUT
    & rqBody   .~ toBody x
    & contentSHA256

defaultRequest :: (ToPath a, ToQuery a, ToHeaders a) => a -> Request a
defaultRequest x = def
    & rqPath    .~ Text.encodeUtf8 (toPath x)
    & rqQuery   .~ toQuery x
    & rqHeaders .~ toHeaders x

contentSHA256 :: Request a -> Request a
contentSHA256 rq = rq
    & rqHeaders %~ hdr hAMZContentSHA256 (bodyHash (rq ^. rqBody))

method :: Lens' HTTP.Request HTTP.Method
method f x = f (HTTP.method x) <&> \y -> x { HTTP.method = y }

host :: Lens' HTTP.Request ByteString
host f x = f (HTTP.host x) <&> \y -> x { HTTP.host = y }

path :: Lens' HTTP.Request ByteString
path f x = f (HTTP.path x) <&> \y -> x { HTTP.path = y }

queryString :: Lens' HTTP.Request ByteString
queryString f x = f (HTTP.queryString x) <&> \y -> x { HTTP.queryString = y }

requestBody :: Lens' HTTP.Request HTTP.RequestBody
requestBody f x = f (HTTP.requestBody x) <&> \y -> x { HTTP.requestBody = y }

requestHeaders :: Lens' HTTP.Request HTTP.RequestHeaders
requestHeaders f x =
    f (HTTP.requestHeaders x) <&> \y -> x { HTTP.requestHeaders = y }