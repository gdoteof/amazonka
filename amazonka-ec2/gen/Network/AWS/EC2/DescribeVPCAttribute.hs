{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.EC2.DescribeVPCAttribute
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

-- | Describes the specified attribute of the specified VPC. You can specify
-- only one attribute at a time.
--
-- <http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeVPCAttribute.html>
module Network.AWS.EC2.DescribeVPCAttribute
    (
    -- * Request
      DescribeVPCAttribute
    -- ** Request constructor
    , describeVPCAttribute
    -- ** Request lenses
    , dvpcaAttribute
    , dvpcaDryRun
    , dvpcaVPCId

    -- * Response
    , DescribeVPCAttributeResponse
    -- ** Response constructor
    , describeVPCAttributeResponse
    -- ** Response lenses
    , dvarEnableDNSHostnames
    , dvarEnableDNSSupport
    , dvarVPCId
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.EC2.Types

-- | /See:/ 'describeVPCAttribute' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dvpcaAttribute'
--
-- * 'dvpcaDryRun'
--
-- * 'dvpcaVPCId'
data DescribeVPCAttribute = DescribeVPCAttribute'{_dvpcaAttribute :: Maybe VPCAttributeName, _dvpcaDryRun :: Maybe Bool, _dvpcaVPCId :: Text} deriving (Eq, Read, Show)

-- | 'DescribeVPCAttribute' smart constructor.
describeVPCAttribute :: Text -> DescribeVPCAttribute
describeVPCAttribute pVPCId = DescribeVPCAttribute'{_dvpcaAttribute = Nothing, _dvpcaDryRun = Nothing, _dvpcaVPCId = pVPCId};

-- | The VPC attribute.
dvpcaAttribute :: Lens' DescribeVPCAttribute (Maybe VPCAttributeName)
dvpcaAttribute = lens _dvpcaAttribute (\ s a -> s{_dvpcaAttribute = a});

-- | Checks whether you have the required permissions for the action, without
-- actually making the request, and provides an error response. If you have
-- the required permissions, the error response is @DryRunOperation@.
-- Otherwise, it is @UnauthorizedOperation@.
dvpcaDryRun :: Lens' DescribeVPCAttribute (Maybe Bool)
dvpcaDryRun = lens _dvpcaDryRun (\ s a -> s{_dvpcaDryRun = a});

-- | The ID of the VPC.
dvpcaVPCId :: Lens' DescribeVPCAttribute Text
dvpcaVPCId = lens _dvpcaVPCId (\ s a -> s{_dvpcaVPCId = a});

instance AWSRequest DescribeVPCAttribute where
        type Sv DescribeVPCAttribute = EC2
        type Rs DescribeVPCAttribute =
             DescribeVPCAttributeResponse
        request = post
        response
          = receiveXML
              (\ s h x ->
                 DescribeVPCAttributeResponse' <$>
                   x .@? "enableDnsHostnames" <*>
                     x .@? "enableDnsSupport"
                     <*> x .@? "vpcId")

instance ToHeaders DescribeVPCAttribute where
        toHeaders = const mempty

instance ToPath DescribeVPCAttribute where
        toPath = const "/"

instance ToQuery DescribeVPCAttribute where
        toQuery DescribeVPCAttribute'{..}
          = mconcat
              ["Action" =: ("DescribeVPCAttribute" :: ByteString),
               "Version" =: ("2015-04-15" :: ByteString),
               "Attribute" =: _dvpcaAttribute,
               "DryRun" =: _dvpcaDryRun, "VpcId" =: _dvpcaVPCId]

-- | /See:/ 'describeVPCAttributeResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dvarEnableDNSHostnames'
--
-- * 'dvarEnableDNSSupport'
--
-- * 'dvarVPCId'
data DescribeVPCAttributeResponse = DescribeVPCAttributeResponse'{_dvarEnableDNSHostnames :: Maybe AttributeBooleanValue, _dvarEnableDNSSupport :: Maybe AttributeBooleanValue, _dvarVPCId :: Maybe Text} deriving (Eq, Read, Show)

-- | 'DescribeVPCAttributeResponse' smart constructor.
describeVPCAttributeResponse :: DescribeVPCAttributeResponse
describeVPCAttributeResponse = DescribeVPCAttributeResponse'{_dvarEnableDNSHostnames = Nothing, _dvarEnableDNSSupport = Nothing, _dvarVPCId = Nothing};

-- | Indicates whether the instances launched in the VPC get DNS hostnames.
-- If this attribute is @true@, instances in the VPC get DNS hostnames;
-- otherwise, they do not.
dvarEnableDNSHostnames :: Lens' DescribeVPCAttributeResponse (Maybe AttributeBooleanValue)
dvarEnableDNSHostnames = lens _dvarEnableDNSHostnames (\ s a -> s{_dvarEnableDNSHostnames = a});

-- | Indicates whether DNS resolution is enabled for the VPC. If this
-- attribute is @true@, the Amazon DNS server resolves DNS hostnames for
-- your instances to their corresponding IP addresses; otherwise, it does
-- not.
dvarEnableDNSSupport :: Lens' DescribeVPCAttributeResponse (Maybe AttributeBooleanValue)
dvarEnableDNSSupport = lens _dvarEnableDNSSupport (\ s a -> s{_dvarEnableDNSSupport = a});

-- | The ID of the VPC.
dvarVPCId :: Lens' DescribeVPCAttributeResponse (Maybe Text)
dvarVPCId = lens _dvarVPCId (\ s a -> s{_dvarVPCId = a});