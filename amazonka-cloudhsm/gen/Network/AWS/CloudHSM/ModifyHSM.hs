{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.CloudHSM.ModifyHSM
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

-- | Modifies an HSM.
--
-- <http://docs.aws.amazon.com/cloudhsm/latest/dg/API_ModifyHSM.html>
module Network.AWS.CloudHSM.ModifyHSM
    (
    -- * Request
      ModifyHSM
    -- ** Request constructor
    , modifyHSM
    -- ** Request lenses
    , mhIAMRoleARN
    , mhSubnetId
    , mhSyslogIP
    , mhExternalId
    , mhEniIP
    , mhHSMARN

    -- * Response
    , ModifyHSMResponse
    -- ** Response constructor
    , modifyHSMResponse
    -- ** Response lenses
    , mhrHSMARN
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.CloudHSM.Types

-- | /See:/ 'modifyHSM' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'mhIAMRoleARN'
--
-- * 'mhSubnetId'
--
-- * 'mhSyslogIP'
--
-- * 'mhExternalId'
--
-- * 'mhEniIP'
--
-- * 'mhHSMARN'
data ModifyHSM = ModifyHSM'{_mhIAMRoleARN :: Maybe Text, _mhSubnetId :: Maybe Text, _mhSyslogIP :: Maybe Text, _mhExternalId :: Maybe Text, _mhEniIP :: Maybe Text, _mhHSMARN :: Text} deriving (Eq, Read, Show)

-- | 'ModifyHSM' smart constructor.
modifyHSM :: Text -> ModifyHSM
modifyHSM pHSMARN = ModifyHSM'{_mhIAMRoleARN = Nothing, _mhSubnetId = Nothing, _mhSyslogIP = Nothing, _mhExternalId = Nothing, _mhEniIP = Nothing, _mhHSMARN = pHSMARN};

-- | The new IAM role ARN.
mhIAMRoleARN :: Lens' ModifyHSM (Maybe Text)
mhIAMRoleARN = lens _mhIAMRoleARN (\ s a -> s{_mhIAMRoleARN = a});

-- | The new identifier of the subnet that the HSM is in.
mhSubnetId :: Lens' ModifyHSM (Maybe Text)
mhSubnetId = lens _mhSubnetId (\ s a -> s{_mhSubnetId = a});

-- | The new IP address for the syslog monitoring server.
mhSyslogIP :: Lens' ModifyHSM (Maybe Text)
mhSyslogIP = lens _mhSyslogIP (\ s a -> s{_mhSyslogIP = a});

-- | The new external ID.
mhExternalId :: Lens' ModifyHSM (Maybe Text)
mhExternalId = lens _mhExternalId (\ s a -> s{_mhExternalId = a});

-- | The new IP address for the elastic network interface attached to the
-- HSM.
mhEniIP :: Lens' ModifyHSM (Maybe Text)
mhEniIP = lens _mhEniIP (\ s a -> s{_mhEniIP = a});

-- | The ARN of the HSM to modify.
mhHSMARN :: Lens' ModifyHSM Text
mhHSMARN = lens _mhHSMARN (\ s a -> s{_mhHSMARN = a});

instance AWSRequest ModifyHSM where
        type Sv ModifyHSM = CloudHSM
        type Rs ModifyHSM = ModifyHSMResponse
        request = postJSON
        response
          = receiveJSON
              (\ s h x -> ModifyHSMResponse' <$> x .?> "HsmArn")

instance ToHeaders ModifyHSM where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("CloudHsmFrontendService.ModifyHSM" :: ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON ModifyHSM where
        toJSON ModifyHSM'{..}
          = object
              ["IamRoleArn" .= _mhIAMRoleARN,
               "SubnetId" .= _mhSubnetId, "SyslogIp" .= _mhSyslogIP,
               "ExternalId" .= _mhExternalId, "EniIp" .= _mhEniIP,
               "HsmArn" .= _mhHSMARN]

instance ToPath ModifyHSM where
        toPath = const "/"

instance ToQuery ModifyHSM where
        toQuery = const mempty

-- | /See:/ 'modifyHSMResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'mhrHSMARN'
newtype ModifyHSMResponse = ModifyHSMResponse'{_mhrHSMARN :: Maybe Text} deriving (Eq, Read, Show)

-- | 'ModifyHSMResponse' smart constructor.
modifyHSMResponse :: ModifyHSMResponse
modifyHSMResponse = ModifyHSMResponse'{_mhrHSMARN = Nothing};

-- | The ARN of the HSM.
mhrHSMARN :: Lens' ModifyHSMResponse (Maybe Text)
mhrHSMARN = lens _mhrHSMARN (\ s a -> s{_mhrHSMARN = a});