{-# LANGUAGE DataKinds                   #-}
{-# LANGUAGE DeriveGeneric               #-}
{-# LANGUAGE FlexibleInstances           #-}
{-# LANGUAGE GeneralizedNewtypeDeriving  #-}
{-# LANGUAGE LambdaCase                  #-}
{-# LANGUAGE NoImplicitPrelude           #-}
{-# LANGUAGE OverloadedStrings           #-}
{-# LANGUAGE RecordWildCards             #-}
{-# LANGUAGE TypeFamilies                #-}

{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Module      : Network.AWS.StorageGateway.DescribeUploadBuffer
-- Copyright   : (c) 2013-2014 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- | This operation returns information about the upload buffer of a gateway. This
-- operation is supported for both the gateway-stored and gateway-cached volume
-- architectures.
--
-- The response includes disk IDs that are configured as upload buffer space,
-- and it includes the amount of upload buffer space allocated and used.
--
-- <http://docs.aws.amazon.com/storagegateway/latest/APIReference/API_DescribeUploadBuffer.html>
module Network.AWS.StorageGateway.DescribeUploadBuffer
    (
    -- * Request
      DescribeUploadBuffer
    -- ** Request constructor
    , describeUploadBuffer
    -- ** Request lenses
    , dubGatewayARN

    -- * Response
    , DescribeUploadBufferResponse
    -- ** Response constructor
    , describeUploadBufferResponse
    -- ** Response lenses
    , dubrDiskIds
    , dubrGatewayARN
    , dubrUploadBufferAllocatedInBytes
    , dubrUploadBufferUsedInBytes
    ) where

import Network.AWS.Data (Object)
import Network.AWS.Prelude
import Network.AWS.Request.JSON
import Network.AWS.StorageGateway.Types
import qualified GHC.Exts

newtype DescribeUploadBuffer = DescribeUploadBuffer
    { _dubGatewayARN :: Text
    } deriving (Eq, Ord, Read, Show, Monoid, IsString)

-- | 'DescribeUploadBuffer' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dubGatewayARN' @::@ 'Text'
--
describeUploadBuffer :: Text -- ^ 'dubGatewayARN'
                     -> DescribeUploadBuffer
describeUploadBuffer p1 = DescribeUploadBuffer
    { _dubGatewayARN = p1
    }

dubGatewayARN :: Lens' DescribeUploadBuffer Text
dubGatewayARN = lens _dubGatewayARN (\s a -> s { _dubGatewayARN = a })

data DescribeUploadBufferResponse = DescribeUploadBufferResponse
    { _dubrDiskIds                      :: List "DiskIds" Text
    , _dubrGatewayARN                   :: Maybe Text
    , _dubrUploadBufferAllocatedInBytes :: Maybe Integer
    , _dubrUploadBufferUsedInBytes      :: Maybe Integer
    } deriving (Eq, Ord, Read, Show)

-- | 'DescribeUploadBufferResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dubrDiskIds' @::@ ['Text']
--
-- * 'dubrGatewayARN' @::@ 'Maybe' 'Text'
--
-- * 'dubrUploadBufferAllocatedInBytes' @::@ 'Maybe' 'Integer'
--
-- * 'dubrUploadBufferUsedInBytes' @::@ 'Maybe' 'Integer'
--
describeUploadBufferResponse :: DescribeUploadBufferResponse
describeUploadBufferResponse = DescribeUploadBufferResponse
    { _dubrGatewayARN                   = Nothing
    , _dubrDiskIds                      = mempty
    , _dubrUploadBufferUsedInBytes      = Nothing
    , _dubrUploadBufferAllocatedInBytes = Nothing
    }

dubrDiskIds :: Lens' DescribeUploadBufferResponse [Text]
dubrDiskIds = lens _dubrDiskIds (\s a -> s { _dubrDiskIds = a }) . _List

dubrGatewayARN :: Lens' DescribeUploadBufferResponse (Maybe Text)
dubrGatewayARN = lens _dubrGatewayARN (\s a -> s { _dubrGatewayARN = a })

dubrUploadBufferAllocatedInBytes :: Lens' DescribeUploadBufferResponse (Maybe Integer)
dubrUploadBufferAllocatedInBytes =
    lens _dubrUploadBufferAllocatedInBytes
        (\s a -> s { _dubrUploadBufferAllocatedInBytes = a })

dubrUploadBufferUsedInBytes :: Lens' DescribeUploadBufferResponse (Maybe Integer)
dubrUploadBufferUsedInBytes =
    lens _dubrUploadBufferUsedInBytes
        (\s a -> s { _dubrUploadBufferUsedInBytes = a })

instance ToPath DescribeUploadBuffer where
    toPath = const "/"

instance ToQuery DescribeUploadBuffer where
    toQuery = const mempty

instance ToHeaders DescribeUploadBuffer

instance ToJSON DescribeUploadBuffer where
    toJSON DescribeUploadBuffer{..} = object
        [ "GatewayARN" .= _dubGatewayARN
        ]

instance AWSRequest DescribeUploadBuffer where
    type Sv DescribeUploadBuffer = StorageGateway
    type Rs DescribeUploadBuffer = DescribeUploadBufferResponse

    request  = post "DescribeUploadBuffer"
    response = jsonResponse

instance FromJSON DescribeUploadBufferResponse where
    parseJSON = withObject "DescribeUploadBufferResponse" $ \o -> DescribeUploadBufferResponse
        <$> o .:? "DiskIds" .!= mempty
        <*> o .:? "GatewayARN"
        <*> o .:? "UploadBufferAllocatedInBytes"
        <*> o .:? "UploadBufferUsedInBytes"
