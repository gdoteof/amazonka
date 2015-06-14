{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.EC2.DetachClassicLinkVPC
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- | Unlinks (detaches) a linked EC2-Classic instance from a VPC. After the
-- instance has been unlinked, the VPC security groups are no longer
-- associated with it. An instance is automatically unlinked from a VPC
-- when it\'s stopped.
--
-- <http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DetachClassicLinkVPC.html>
module Network.AWS.EC2.DetachClassicLinkVPC
    (
    -- * Request
      DetachClassicLinkVPC
    -- ** Request constructor
    , detachClassicLinkVPC
    -- ** Request lenses
    , dclvDryRun
    , dclvInstanceId
    , dclvVPCId

    -- * Response
    , DetachClassicLinkVPCResponse
    -- ** Response constructor
    , detachClassicLinkVPCResponse
    -- ** Response lenses
    , dclvrReturn
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.EC2.Types

-- | /See:/ 'detachClassicLinkVPC' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dclvDryRun'
--
-- * 'dclvInstanceId'
--
-- * 'dclvVPCId'
data DetachClassicLinkVPC = DetachClassicLinkVPC'{_dclvDryRun :: Maybe Bool, _dclvInstanceId :: Text, _dclvVPCId :: Text} deriving (Eq, Read, Show)

-- | 'DetachClassicLinkVPC' smart constructor.
detachClassicLinkVPC :: Text -> Text -> DetachClassicLinkVPC
detachClassicLinkVPC pInstanceId pVPCId = DetachClassicLinkVPC'{_dclvDryRun = Nothing, _dclvInstanceId = pInstanceId, _dclvVPCId = pVPCId};

-- | Checks whether you have the required permissions for the action, without
-- actually making the request, and provides an error response. If you have
-- the required permissions, the error response is @DryRunOperation@.
-- Otherwise, it is @UnauthorizedOperation@.
dclvDryRun :: Lens' DetachClassicLinkVPC (Maybe Bool)
dclvDryRun = lens _dclvDryRun (\ s a -> s{_dclvDryRun = a});

-- | The ID of the instance to unlink from the VPC.
dclvInstanceId :: Lens' DetachClassicLinkVPC Text
dclvInstanceId = lens _dclvInstanceId (\ s a -> s{_dclvInstanceId = a});

-- | The ID of the VPC to which the instance is linked.
dclvVPCId :: Lens' DetachClassicLinkVPC Text
dclvVPCId = lens _dclvVPCId (\ s a -> s{_dclvVPCId = a});

instance AWSRequest DetachClassicLinkVPC where
        type Sv DetachClassicLinkVPC = EC2
        type Rs DetachClassicLinkVPC =
             DetachClassicLinkVPCResponse
        request = post
        response
          = receiveXML
              (\ s h x ->
                 DetachClassicLinkVPCResponse' <$> x .@? "return")

instance ToHeaders DetachClassicLinkVPC where
        toHeaders = const mempty

instance ToPath DetachClassicLinkVPC where
        toPath = const "/"

instance ToQuery DetachClassicLinkVPC where
        toQuery DetachClassicLinkVPC'{..}
          = mconcat
              ["Action" =: ("DetachClassicLinkVPC" :: ByteString),
               "Version" =: ("2015-04-15" :: ByteString),
               "DryRun" =: _dclvDryRun,
               "InstanceId" =: _dclvInstanceId,
               "VpcId" =: _dclvVPCId]

-- | /See:/ 'detachClassicLinkVPCResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dclvrReturn'
newtype DetachClassicLinkVPCResponse = DetachClassicLinkVPCResponse'{_dclvrReturn :: Maybe Bool} deriving (Eq, Read, Show)

-- | 'DetachClassicLinkVPCResponse' smart constructor.
detachClassicLinkVPCResponse :: DetachClassicLinkVPCResponse
detachClassicLinkVPCResponse = DetachClassicLinkVPCResponse'{_dclvrReturn = Nothing};

-- | Returns @true@ if the request succeeds; otherwise, it returns an error.
dclvrReturn :: Lens' DetachClassicLinkVPCResponse (Maybe Bool)
dclvrReturn = lens _dclvrReturn (\ s a -> s{_dclvrReturn = a});