{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.OpsWorks.UpdateRDSDBInstance
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

-- | Updates an Amazon RDS instance.
--
-- __Required Permissions__: To use this action, an IAM user must have a
-- Manage permissions level for the stack, or an attached policy that
-- explicitly grants permissions. For more information on user permissions,
-- see
-- <http://docs.aws.amazon.com/opsworks/latest/userguide/opsworks-security-users.html Managing User Permissions>.
--
-- <http://docs.aws.amazon.com/opsworks/latest/APIReference/API_UpdateRDSDBInstance.html>
module Network.AWS.OpsWorks.UpdateRDSDBInstance
    (
    -- * Request
      UpdateRDSDBInstance
    -- ** Request constructor
    , updateRDSDBInstance
    -- ** Request lenses
    , urdiDBUser
    , urdiDBPassword
    , urdiRDSDBInstanceARN

    -- * Response
    , UpdateRDSDBInstanceResponse
    -- ** Response constructor
    , updateRDSDBInstanceResponse
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.OpsWorks.Types

-- | /See:/ 'updateRDSDBInstance' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'urdiDBUser'
--
-- * 'urdiDBPassword'
--
-- * 'urdiRDSDBInstanceARN'
data UpdateRDSDBInstance = UpdateRDSDBInstance'{_urdiDBUser :: Maybe Text, _urdiDBPassword :: Maybe Text, _urdiRDSDBInstanceARN :: Text} deriving (Eq, Read, Show)

-- | 'UpdateRDSDBInstance' smart constructor.
updateRDSDBInstance :: Text -> UpdateRDSDBInstance
updateRDSDBInstance pRDSDBInstanceARN = UpdateRDSDBInstance'{_urdiDBUser = Nothing, _urdiDBPassword = Nothing, _urdiRDSDBInstanceARN = pRDSDBInstanceARN};

-- | The master user name.
urdiDBUser :: Lens' UpdateRDSDBInstance (Maybe Text)
urdiDBUser = lens _urdiDBUser (\ s a -> s{_urdiDBUser = a});

-- | The database password.
urdiDBPassword :: Lens' UpdateRDSDBInstance (Maybe Text)
urdiDBPassword = lens _urdiDBPassword (\ s a -> s{_urdiDBPassword = a});

-- | The Amazon RDS instance\'s ARN.
urdiRDSDBInstanceARN :: Lens' UpdateRDSDBInstance Text
urdiRDSDBInstanceARN = lens _urdiRDSDBInstanceARN (\ s a -> s{_urdiRDSDBInstanceARN = a});

instance AWSRequest UpdateRDSDBInstance where
        type Sv UpdateRDSDBInstance = OpsWorks
        type Rs UpdateRDSDBInstance =
             UpdateRDSDBInstanceResponse
        request = postJSON
        response = receiveNull UpdateRDSDBInstanceResponse'

instance ToHeaders UpdateRDSDBInstance where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("OpsWorks_20130218.UpdateRDSDBInstance" ::
                       ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON UpdateRDSDBInstance where
        toJSON UpdateRDSDBInstance'{..}
          = object
              ["DbUser" .= _urdiDBUser,
               "DbPassword" .= _urdiDBPassword,
               "RdsDbInstanceArn" .= _urdiRDSDBInstanceARN]

instance ToPath UpdateRDSDBInstance where
        toPath = const "/"

instance ToQuery UpdateRDSDBInstance where
        toQuery = const mempty

-- | /See:/ 'updateRDSDBInstanceResponse' smart constructor.
data UpdateRDSDBInstanceResponse = UpdateRDSDBInstanceResponse' deriving (Eq, Read, Show)

-- | 'UpdateRDSDBInstanceResponse' smart constructor.
updateRDSDBInstanceResponse :: UpdateRDSDBInstanceResponse
updateRDSDBInstanceResponse = UpdateRDSDBInstanceResponse';