{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.EC2.DescribeVPCEndpoints
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

-- | Describes one or more of your VPC endpoints.
--
-- <http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-DescribeVPCEndpoints.html>
module Network.AWS.EC2.DescribeVPCEndpoints
    (
    -- * Request
      DescribeVPCEndpoints
    -- ** Request constructor
    , describeVPCEndpoints
    -- ** Request lenses
    , dvpceFilters
    , dvpceNextToken
    , dvpceVPCEndpointIds
    , dvpceDryRun
    , dvpceMaxResults

    -- * Response
    , DescribeVPCEndpointsResponse
    -- ** Response constructor
    , describeVPCEndpointsResponse
    -- ** Response lenses
    , dverNextToken
    , dverVPCEndpoints
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.EC2.Types

-- | /See:/ 'describeVPCEndpoints' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dvpceFilters'
--
-- * 'dvpceNextToken'
--
-- * 'dvpceVPCEndpointIds'
--
-- * 'dvpceDryRun'
--
-- * 'dvpceMaxResults'
data DescribeVPCEndpoints = DescribeVPCEndpoints'{_dvpceFilters :: Maybe [Filter], _dvpceNextToken :: Maybe Text, _dvpceVPCEndpointIds :: Maybe [Text], _dvpceDryRun :: Maybe Bool, _dvpceMaxResults :: Maybe Int} deriving (Eq, Read, Show)

-- | 'DescribeVPCEndpoints' smart constructor.
describeVPCEndpoints :: DescribeVPCEndpoints
describeVPCEndpoints = DescribeVPCEndpoints'{_dvpceFilters = Nothing, _dvpceNextToken = Nothing, _dvpceVPCEndpointIds = Nothing, _dvpceDryRun = Nothing, _dvpceMaxResults = Nothing};

-- | One or more filters.
--
-- -   @service-name@: The name of the AWS service.
--
-- -   @vpc-id@: The ID of the VPC in which the endpoint resides.
--
-- -   @vpc-endpoint-id@: The ID of the endpoint.
--
-- -   @vpc-endpoint-state@: The state of the endpoint. (@pending@ |
--     @available@ | @deleting@ | @deleted@)
--
dvpceFilters :: Lens' DescribeVPCEndpoints (Maybe [Filter])
dvpceFilters = lens _dvpceFilters (\ s a -> s{_dvpceFilters = a});

-- | The token for the next set of items to return. (You received this token
-- from a prior call.)
dvpceNextToken :: Lens' DescribeVPCEndpoints (Maybe Text)
dvpceNextToken = lens _dvpceNextToken (\ s a -> s{_dvpceNextToken = a});

-- | One or more endpoint IDs.
dvpceVPCEndpointIds :: Lens' DescribeVPCEndpoints (Maybe [Text])
dvpceVPCEndpointIds = lens _dvpceVPCEndpointIds (\ s a -> s{_dvpceVPCEndpointIds = a});

-- | Checks whether you have the required permissions for the action, without
-- actually making the request, and provides an error response. If you have
-- the required permissions, the error response is @DryRunOperation@.
-- Otherwise, it is @UnauthorizedOperation@.
dvpceDryRun :: Lens' DescribeVPCEndpoints (Maybe Bool)
dvpceDryRun = lens _dvpceDryRun (\ s a -> s{_dvpceDryRun = a});

-- | The maximum number of items to return for this request. The request
-- returns a token that you can specify in a subsequent call to get the
-- next set of results.
--
-- Constraint: If the value is greater than 1000, we return only 1000
-- items.
dvpceMaxResults :: Lens' DescribeVPCEndpoints (Maybe Int)
dvpceMaxResults = lens _dvpceMaxResults (\ s a -> s{_dvpceMaxResults = a});

instance AWSRequest DescribeVPCEndpoints where
        type Sv DescribeVPCEndpoints = EC2
        type Rs DescribeVPCEndpoints =
             DescribeVPCEndpointsResponse
        request = post
        response
          = receiveXML
              (\ s h x ->
                 DescribeVPCEndpointsResponse' <$>
                   x .@? "nextToken" <*> parseXMLList "item" x)

instance ToHeaders DescribeVPCEndpoints where
        toHeaders = const mempty

instance ToPath DescribeVPCEndpoints where
        toPath = const "/"

instance ToQuery DescribeVPCEndpoints where
        toQuery DescribeVPCEndpoints'{..}
          = mconcat
              ["Action" =: ("DescribeVPCEndpoints" :: ByteString),
               "Version" =: ("2015-04-15" :: ByteString),
               "Filter" =: _dvpceFilters,
               "NextToken" =: _dvpceNextToken,
               "item" =: _dvpceVPCEndpointIds,
               "DryRun" =: _dvpceDryRun,
               "MaxResults" =: _dvpceMaxResults]

-- | /See:/ 'describeVPCEndpointsResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dverNextToken'
--
-- * 'dverVPCEndpoints'
data DescribeVPCEndpointsResponse = DescribeVPCEndpointsResponse'{_dverNextToken :: Maybe Text, _dverVPCEndpoints :: Maybe [VPCEndpoint]} deriving (Eq, Read, Show)

-- | 'DescribeVPCEndpointsResponse' smart constructor.
describeVPCEndpointsResponse :: DescribeVPCEndpointsResponse
describeVPCEndpointsResponse = DescribeVPCEndpointsResponse'{_dverNextToken = Nothing, _dverVPCEndpoints = Nothing};

-- | The token to use when requesting the next set of items. If there are no
-- additional items to return, the string is empty.
dverNextToken :: Lens' DescribeVPCEndpointsResponse (Maybe Text)
dverNextToken = lens _dverNextToken (\ s a -> s{_dverNextToken = a});

-- | Information about the endpoints.
dverVPCEndpoints :: Lens' DescribeVPCEndpointsResponse (Maybe [VPCEndpoint])
dverVPCEndpoints = lens _dverVPCEndpoints (\ s a -> s{_dverVPCEndpoints = a});