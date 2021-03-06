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

-- Module      : Network.AWS.ELB.DescribeLoadBalancerPolicyTypes
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

-- | Describes the specified load balancer policy types.
--
-- You can use these policy types with 'CreateLoadBalancerPolicy' to create
-- policy configurations for a load balancer.
--
-- <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_DescribeLoadBalancerPolicyTypes.html>
module Network.AWS.ELB.DescribeLoadBalancerPolicyTypes
    (
    -- * Request
      DescribeLoadBalancerPolicyTypes
    -- ** Request constructor
    , describeLoadBalancerPolicyTypes
    -- ** Request lenses
    , dlbptPolicyTypeNames

    -- * Response
    , DescribeLoadBalancerPolicyTypesResponse
    -- ** Response constructor
    , describeLoadBalancerPolicyTypesResponse
    -- ** Response lenses
    , dlbptrPolicyTypeDescriptions
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.ELB.Types
import qualified GHC.Exts

newtype DescribeLoadBalancerPolicyTypes = DescribeLoadBalancerPolicyTypes
    { _dlbptPolicyTypeNames :: List "member" Text
    } deriving (Eq, Ord, Read, Show, Monoid, Semigroup)

instance GHC.Exts.IsList DescribeLoadBalancerPolicyTypes where
    type Item DescribeLoadBalancerPolicyTypes = Text

    fromList = DescribeLoadBalancerPolicyTypes . GHC.Exts.fromList
    toList   = GHC.Exts.toList . _dlbptPolicyTypeNames

-- | 'DescribeLoadBalancerPolicyTypes' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dlbptPolicyTypeNames' @::@ ['Text']
--
describeLoadBalancerPolicyTypes :: DescribeLoadBalancerPolicyTypes
describeLoadBalancerPolicyTypes = DescribeLoadBalancerPolicyTypes
    { _dlbptPolicyTypeNames = mempty
    }

-- | The names of the policy types. If no names are specified, describes all
-- policy types defined by Elastic Load Balancing.
dlbptPolicyTypeNames :: Lens' DescribeLoadBalancerPolicyTypes [Text]
dlbptPolicyTypeNames =
    lens _dlbptPolicyTypeNames (\s a -> s { _dlbptPolicyTypeNames = a })
        . _List

newtype DescribeLoadBalancerPolicyTypesResponse = DescribeLoadBalancerPolicyTypesResponse
    { _dlbptrPolicyTypeDescriptions :: List "member" PolicyTypeDescription
    } deriving (Eq, Read, Show, Monoid, Semigroup)

instance GHC.Exts.IsList DescribeLoadBalancerPolicyTypesResponse where
    type Item DescribeLoadBalancerPolicyTypesResponse = PolicyTypeDescription

    fromList = DescribeLoadBalancerPolicyTypesResponse . GHC.Exts.fromList
    toList   = GHC.Exts.toList . _dlbptrPolicyTypeDescriptions

-- | 'DescribeLoadBalancerPolicyTypesResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dlbptrPolicyTypeDescriptions' @::@ ['PolicyTypeDescription']
--
describeLoadBalancerPolicyTypesResponse :: DescribeLoadBalancerPolicyTypesResponse
describeLoadBalancerPolicyTypesResponse = DescribeLoadBalancerPolicyTypesResponse
    { _dlbptrPolicyTypeDescriptions = mempty
    }

-- | Information about the policy types.
dlbptrPolicyTypeDescriptions :: Lens' DescribeLoadBalancerPolicyTypesResponse [PolicyTypeDescription]
dlbptrPolicyTypeDescriptions =
    lens _dlbptrPolicyTypeDescriptions
        (\s a -> s { _dlbptrPolicyTypeDescriptions = a })
            . _List

instance ToPath DescribeLoadBalancerPolicyTypes where
    toPath = const "/"

instance ToQuery DescribeLoadBalancerPolicyTypes where
    toQuery DescribeLoadBalancerPolicyTypes{..} = mconcat
        [ "PolicyTypeNames" =? _dlbptPolicyTypeNames
        ]

instance ToHeaders DescribeLoadBalancerPolicyTypes

instance AWSRequest DescribeLoadBalancerPolicyTypes where
    type Sv DescribeLoadBalancerPolicyTypes = ELB
    type Rs DescribeLoadBalancerPolicyTypes = DescribeLoadBalancerPolicyTypesResponse

    request  = post "DescribeLoadBalancerPolicyTypes"
    response = xmlResponse

instance FromXML DescribeLoadBalancerPolicyTypesResponse where
    parseXML = withElement "DescribeLoadBalancerPolicyTypesResult" $ \x -> DescribeLoadBalancerPolicyTypesResponse
        <$> x .@? "PolicyTypeDescriptions" .!@ mempty
