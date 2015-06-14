{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.DirectoryService.CreateComputer
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

-- | Creates a computer account in the specified directory, and joins the
-- computer to the directory.
--
-- <http://docs.aws.amazon.com/directoryservice/latest/devguide/API_CreateComputer.html>
module Network.AWS.DirectoryService.CreateComputer
    (
    -- * Request
      CreateComputer
    -- ** Request constructor
    , createComputer
    -- ** Request lenses
    , ccComputerAttributes
    , ccDirectoryId
    , ccComputerName
    , ccPassword
    , ccOrganizationalUnitDistinguishedName

    -- * Response
    , CreateComputerResponse
    -- ** Response constructor
    , createComputerResponse
    -- ** Response lenses
    , ccrComputer
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.DirectoryService.Types

-- | /See:/ 'createComputer' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ccComputerAttributes'
--
-- * 'ccDirectoryId'
--
-- * 'ccComputerName'
--
-- * 'ccPassword'
--
-- * 'ccOrganizationalUnitDistinguishedName'
data CreateComputer = CreateComputer'{_ccComputerAttributes :: [Attribute], _ccDirectoryId :: Text, _ccComputerName :: Text, _ccPassword :: Sensitive Text, _ccOrganizationalUnitDistinguishedName :: Text} deriving (Eq, Read, Show)

-- | 'CreateComputer' smart constructor.
createComputer :: Text -> Text -> Text -> Text -> CreateComputer
createComputer pDirectoryId pComputerName pPassword pOrganizationalUnitDistinguishedName = CreateComputer'{_ccComputerAttributes = mempty, _ccDirectoryId = pDirectoryId, _ccComputerName = pComputerName, _ccPassword = _Sensitive # pPassword, _ccOrganizationalUnitDistinguishedName = pOrganizationalUnitDistinguishedName};

-- | An array of Attribute objects that contain any LDAP attributes to apply
-- to the computer account.
ccComputerAttributes :: Lens' CreateComputer [Attribute]
ccComputerAttributes = lens _ccComputerAttributes (\ s a -> s{_ccComputerAttributes = a});

-- | The identifier of the directory to create the computer account in.
ccDirectoryId :: Lens' CreateComputer Text
ccDirectoryId = lens _ccDirectoryId (\ s a -> s{_ccDirectoryId = a});

-- | The name of the computer account.
ccComputerName :: Lens' CreateComputer Text
ccComputerName = lens _ccComputerName (\ s a -> s{_ccComputerName = a});

-- | A one-time password that is used to join the computer to the directory.
-- You should generate a random, strong password to use for this parameter.
ccPassword :: Lens' CreateComputer Text
ccPassword = lens _ccPassword (\ s a -> s{_ccPassword = a}) . _Sensitive;

-- | The fully-qualified distinguished name of the organizational unit to
-- place the computer account in.
ccOrganizationalUnitDistinguishedName :: Lens' CreateComputer Text
ccOrganizationalUnitDistinguishedName = lens _ccOrganizationalUnitDistinguishedName (\ s a -> s{_ccOrganizationalUnitDistinguishedName = a});

instance AWSRequest CreateComputer where
        type Sv CreateComputer = DirectoryService
        type Rs CreateComputer = CreateComputerResponse
        request = postJSON
        response
          = receiveJSON
              (\ s h x ->
                 CreateComputerResponse' <$> x .?> "Computer")

instance ToHeaders CreateComputer where
        toHeaders
          = const
              (mconcat
                 ["X-Amz-Target" =#
                    ("DirectoryService_20150416.CreateComputer" ::
                       ByteString),
                  "Content-Type" =#
                    ("application/x-amz-json-1.1" :: ByteString)])

instance ToJSON CreateComputer where
        toJSON CreateComputer'{..}
          = object
              ["ComputerAttributes" .= _ccComputerAttributes,
               "DirectoryId" .= _ccDirectoryId,
               "ComputerName" .= _ccComputerName,
               "Password" .= _ccPassword,
               "OrganizationalUnitDistinguishedName" .=
                 _ccOrganizationalUnitDistinguishedName]

instance ToPath CreateComputer where
        toPath = const "/"

instance ToQuery CreateComputer where
        toQuery = const mempty

-- | /See:/ 'createComputerResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'ccrComputer'
newtype CreateComputerResponse = CreateComputerResponse'{_ccrComputer :: Maybe Computer} deriving (Eq, Read, Show)

-- | 'CreateComputerResponse' smart constructor.
createComputerResponse :: CreateComputerResponse
createComputerResponse = CreateComputerResponse'{_ccrComputer = Nothing};

-- | A Computer object the represents the computer account.
ccrComputer :: Lens' CreateComputerResponse (Maybe Computer)
ccrComputer = lens _ccrComputer (\ s a -> s{_ccrComputer = a});