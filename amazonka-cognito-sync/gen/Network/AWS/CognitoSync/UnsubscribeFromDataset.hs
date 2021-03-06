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

-- Module      : Network.AWS.CognitoSync.UnsubscribeFromDataset
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

-- | Unsubscribes from receiving notifications when a dataset is modified by
-- another device.
--
-- <http://docs.aws.amazon.com/cognitosync/latest/APIReference/API_UnsubscribeFromDataset.html>
module Network.AWS.CognitoSync.UnsubscribeFromDataset
    (
    -- * Request
      UnsubscribeFromDataset
    -- ** Request constructor
    , unsubscribeFromDataset
    -- ** Request lenses
    , ufdDatasetName
    , ufdDeviceId
    , ufdIdentityId
    , ufdIdentityPoolId

    -- * Response
    , UnsubscribeFromDatasetResponse
    -- ** Response constructor
    , unsubscribeFromDatasetResponse
    ) where

import Network.AWS.Data (Object)
import Network.AWS.Prelude
import Network.AWS.Request.RestJSON
import Network.AWS.CognitoSync.Types
import qualified GHC.Exts

data UnsubscribeFromDataset = UnsubscribeFromDataset
    { _ufdDatasetName    :: Text
    , _ufdDeviceId       :: Text
    , _ufdIdentityId     :: Text
    , _ufdIdentityPoolId :: Text
    } deriving (Eq, Ord, Read, Show)

-- | 'UnsubscribeFromDataset' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ufdDatasetName' @::@ 'Text'
--
-- * 'ufdDeviceId' @::@ 'Text'
--
-- * 'ufdIdentityId' @::@ 'Text'
--
-- * 'ufdIdentityPoolId' @::@ 'Text'
--
unsubscribeFromDataset :: Text -- ^ 'ufdIdentityPoolId'
                       -> Text -- ^ 'ufdIdentityId'
                       -> Text -- ^ 'ufdDatasetName'
                       -> Text -- ^ 'ufdDeviceId'
                       -> UnsubscribeFromDataset
unsubscribeFromDataset p1 p2 p3 p4 = UnsubscribeFromDataset
    { _ufdIdentityPoolId = p1
    , _ufdIdentityId     = p2
    , _ufdDatasetName    = p3
    , _ufdDeviceId       = p4
    }

-- | The name of the dataset from which to unsubcribe.
ufdDatasetName :: Lens' UnsubscribeFromDataset Text
ufdDatasetName = lens _ufdDatasetName (\s a -> s { _ufdDatasetName = a })

-- | The unique ID generated for this device by Cognito.
ufdDeviceId :: Lens' UnsubscribeFromDataset Text
ufdDeviceId = lens _ufdDeviceId (\s a -> s { _ufdDeviceId = a })

-- | Unique ID for this identity.
ufdIdentityId :: Lens' UnsubscribeFromDataset Text
ufdIdentityId = lens _ufdIdentityId (\s a -> s { _ufdIdentityId = a })

-- | A name-spaced GUID (for example,
-- us-east-1:23EC4050-6AEA-7089-A2DD-08002EXAMPLE) created by Amazon Cognito.
-- The ID of the pool to which this identity belongs.
ufdIdentityPoolId :: Lens' UnsubscribeFromDataset Text
ufdIdentityPoolId =
    lens _ufdIdentityPoolId (\s a -> s { _ufdIdentityPoolId = a })

data UnsubscribeFromDatasetResponse = UnsubscribeFromDatasetResponse
    deriving (Eq, Ord, Read, Show, Generic)

-- | 'UnsubscribeFromDatasetResponse' constructor.
unsubscribeFromDatasetResponse :: UnsubscribeFromDatasetResponse
unsubscribeFromDatasetResponse = UnsubscribeFromDatasetResponse

instance ToPath UnsubscribeFromDataset where
    toPath UnsubscribeFromDataset{..} = mconcat
        [ "/identitypools/"
        , toText _ufdIdentityPoolId
        , "/identities/"
        , toText _ufdIdentityId
        , "/datasets/"
        , toText _ufdDatasetName
        , "/subscriptions/"
        , toText _ufdDeviceId
        ]

instance ToQuery UnsubscribeFromDataset where
    toQuery = const mempty

instance ToHeaders UnsubscribeFromDataset

instance ToJSON UnsubscribeFromDataset where
    toJSON = const (toJSON Empty)

instance AWSRequest UnsubscribeFromDataset where
    type Sv UnsubscribeFromDataset = CognitoSync
    type Rs UnsubscribeFromDataset = UnsubscribeFromDatasetResponse

    request  = delete
    response = nullResponse UnsubscribeFromDatasetResponse
