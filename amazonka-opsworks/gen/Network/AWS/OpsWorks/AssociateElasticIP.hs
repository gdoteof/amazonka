{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.OpsWorks.AssociateElasticIP
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

-- | Associates one of the stack\'s registered Elastic IP addresses with a
-- specified instance. The address must first be registered with the stack
-- by calling RegisterElasticIp. For more information, see
-- <http://docs.aws.amazon.com/opsworks/latest/userguide/resources.html Resource Management>.
--
-- __Required Permissions__: To use this action, an IAM user must have a
-- Manage permissions level for the stack, or an attached policy that
-- explicitly grants permissions. For more information on user permissions,
-- see
-- <http://docs.aws.amazon.com/opsworks/latest/userguide/opsworks-security-users.html Managing User Permissions>.
--
-- <http://docs.aws.amazon.com/opsworks/latest/APIReference/API_AssociateElasticIP.html>
module Network.AWS.OpsWorks.AssociateElasticIP
    (
    -- * Request
      AssociateElasticIP
    -- ** Request constructor
    , associateElasticIP
    -- ** Request lenses
    , aeiInstanceId
    , aeiElasticIP

    -- * Response
    , AssociateElasticIPResponse
    -- ** Response constructor
    , associateElasticIPResponse
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.OpsWorks.Types

-- | /See:/ 'associateElasticIP' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'aeiInstanceId'
--
-- * 'aeiElasticIP'
data AssociateElasticIP = AssociateElasticIP'{_aeiInstanceId :: Maybe Text, _aeiElasticIP :: Text} deriving (Eq, Read, Show)

-- | 'AssociateElasticIP' smart constructor.
associateElasticIP :: Text -> AssociateElasticIP
associateElasticIP pElasticIP = AssociateElasticIP'{_aeiInstanceId = Nothing, _aeiElasticIP = pElasticIP};

-- | The instance ID.
aeiInstanceId :: Lens' AssociateElasticIP (Maybe Text)
aeiInstanceId = lens _aeiInstanceId (\ s a -> s{_aeiInstanceId = a});

-- | The Elastic IP address.
aeiElasticIP :: Lens' AssociateElasticIP Text
aeiElasticIP = lens _aeiElasticIP (\ s a -> s{_aeiElasticIP = a});

instance AWSRequest AssociateElasticIP where
        type Sv AssociateElasticIP = OpsWorks
        type Rs AssociateElasticIP =
             AssociateElasticIPResponse
        request = postJSON
        response = receiveNull AssociateElasticIPResponse'

instance ToHeaders AssociateElasticIP where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("OpsWorks_20130218.AssociateElasticIP" ::
                       ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON AssociateElasticIP where
        toJSON AssociateElasticIP'{..}
          = object
              ["InstanceId" .= _aeiInstanceId,
               "ElasticIp" .= _aeiElasticIP]

instance ToPath AssociateElasticIP where
        toPath = const "/"

instance ToQuery AssociateElasticIP where
        toQuery = const mempty

-- | /See:/ 'associateElasticIPResponse' smart constructor.
data AssociateElasticIPResponse = AssociateElasticIPResponse' deriving (Eq, Read, Show)

-- | 'AssociateElasticIPResponse' smart constructor.
associateElasticIPResponse :: AssociateElasticIPResponse
associateElasticIPResponse = AssociateElasticIPResponse';