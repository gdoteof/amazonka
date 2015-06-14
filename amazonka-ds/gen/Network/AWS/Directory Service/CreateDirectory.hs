{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.Directory Service.CreateDirectory
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

-- | Creates a Simple AD directory.
--
-- <http://docs.aws.amazon.com/directoryservice/latest/devguide/API_CreateDirectory.html>
module Network.AWS.Directory Service.CreateDirectory
    (
    -- * Request
      CreateDirectory
    -- ** Request constructor
    , createDirectory
    -- ** Request lenses
    , creShortName
    , creVPCSettings
    , creDescription
    , creName
    , crePassword
    , creSize

    -- * Response
    , CreateDirectoryResponse
    -- ** Response constructor
    , createDirectoryResponse
    -- ** Response lenses
    , creDirectoryId
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.Directory Service.Types

-- | /See:/ 'createDirectory' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'creShortName'
--
-- * 'creVPCSettings'
--
-- * 'creDescription'
--
-- * 'creName'
--
-- * 'crePassword'
--
-- * 'creSize'
data CreateDirectory = CreateDirectory'{_creShortName :: Maybe Text, _creVPCSettings :: Maybe DirectoryVPCSettings, _creDescription :: Maybe Text, _creName :: Text, _crePassword :: Sensitive Text, _creSize :: DirectorySize} deriving (Eq, Read, Show)

-- | 'CreateDirectory' smart constructor.
createDirectory :: Text -> Text -> DirectorySize -> CreateDirectory
createDirectory pName pPassword pSize = CreateDirectory'{_creShortName = Nothing, _creVPCSettings = Nothing, _creDescription = Nothing, _creName = pName, _crePassword = _Sensitive # pPassword, _creSize = pSize};

-- | The short name of the directory, such as @CORP@.
creShortName :: Lens' CreateDirectory (Maybe Text)
creShortName = lens _creShortName (\ s a -> s{_creShortName = a});

-- | A DirectoryVpcSettings object that contains additional information for
-- the operation.
creVPCSettings :: Lens' CreateDirectory (Maybe DirectoryVPCSettings)
creVPCSettings = lens _creVPCSettings (\ s a -> s{_creVPCSettings = a});

-- | A textual description for the directory.
creDescription :: Lens' CreateDirectory (Maybe Text)
creDescription = lens _creDescription (\ s a -> s{_creDescription = a});

-- | The fully qualified name for the directory, such as @corp.example.com@.
creName :: Lens' CreateDirectory Text
creName = lens _creName (\ s a -> s{_creName = a});

-- | The password for the directory administrator. The directory creation
-- process creates a directory administrator account with the username
-- @Administrator@ and this password.
crePassword :: Lens' CreateDirectory Text
crePassword = lens _crePassword (\ s a -> s{_crePassword = a}) . _Sensitive;

-- | The size of the directory.
creSize :: Lens' CreateDirectory DirectorySize
creSize = lens _creSize (\ s a -> s{_creSize = a});

instance AWSRequest CreateDirectory where
        type Sv CreateDirectory = Directory Service
        type Rs CreateDirectory = CreateDirectoryResponse
        request = postJSON
        response
          = receiveJSON
              (\ s h x ->
                 CreateDirectoryResponse' <$> x .?> "DirectoryId")

instance ToHeaders CreateDirectory where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("DirectoryService_20150416.CreateDirectory" ::
                       ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON CreateDirectory where
        toJSON CreateDirectory'{..}
          = object
              ["ShortName" .= _creShortName,
               "VpcSettings" .= _creVPCSettings,
               "Description" .= _creDescription, "Name" .= _creName,
               "Password" .= _crePassword, "Size" .= _creSize]

instance ToPath CreateDirectory where
        toPath = const "/"

instance ToQuery CreateDirectory where
        toQuery = const mempty

-- | /See:/ 'createDirectoryResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'creDirectoryId'
newtype CreateDirectoryResponse = CreateDirectoryResponse'{_creDirectoryId :: Maybe Text} deriving (Eq, Read, Show)

-- | 'CreateDirectoryResponse' smart constructor.
createDirectoryResponse :: CreateDirectoryResponse
createDirectoryResponse = CreateDirectoryResponse'{_creDirectoryId = Nothing};

-- | The identifier of the directory that was created.
creDirectoryId :: Lens' CreateDirectoryResponse (Maybe Text)
creDirectoryId = lens _creDirectoryId (\ s a -> s{_creDirectoryId = a});