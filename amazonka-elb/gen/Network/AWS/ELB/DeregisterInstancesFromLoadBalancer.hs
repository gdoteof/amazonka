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

-- Module      : Network.AWS.ELB.DeregisterInstancesFromLoadBalancer
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

-- | Deregisters the specified instances from the specified load balancer. After
-- the instance is deregistered, it no longer receives traffic from the load
-- balancer.
--
-- You can use 'DescribeLoadBalancers' to verify that the instance is
-- deregistered from the load balancer.
--
-- For more information, see <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/US_DeReg_Reg_Instances.html Deregister and Register Amazon EC2 Instances> in
-- the /Elastic Load Balancing Developer Guide/.
--
-- <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_DeregisterInstancesFromLoadBalancer.html>
module Network.AWS.ELB.DeregisterInstancesFromLoadBalancer
    (
    -- * Request
      DeregisterInstancesFromLoadBalancer
    -- ** Request constructor
    , deregisterInstancesFromLoadBalancer
    -- ** Request lenses
    , diflbInstances
    , diflbLoadBalancerName

    -- * Response
    , DeregisterInstancesFromLoadBalancerResponse
    -- ** Response constructor
    , deregisterInstancesFromLoadBalancerResponse
    -- ** Response lenses
    , diflbrInstances
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.ELB.Types
import qualified GHC.Exts

data DeregisterInstancesFromLoadBalancer = DeregisterInstancesFromLoadBalancer
    { _diflbInstances        :: List "member" Instance
    , _diflbLoadBalancerName :: Text
    } deriving (Eq, Read, Show)

-- | 'DeregisterInstancesFromLoadBalancer' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'diflbInstances' @::@ ['Instance']
--
-- * 'diflbLoadBalancerName' @::@ 'Text'
--
deregisterInstancesFromLoadBalancer :: Text -- ^ 'diflbLoadBalancerName'
                                    -> DeregisterInstancesFromLoadBalancer
deregisterInstancesFromLoadBalancer p1 = DeregisterInstancesFromLoadBalancer
    { _diflbLoadBalancerName = p1
    , _diflbInstances        = mempty
    }

-- | The IDs of the instances.
diflbInstances :: Lens' DeregisterInstancesFromLoadBalancer [Instance]
diflbInstances = lens _diflbInstances (\s a -> s { _diflbInstances = a }) . _List

-- | The name of the load balancer.
diflbLoadBalancerName :: Lens' DeregisterInstancesFromLoadBalancer Text
diflbLoadBalancerName =
    lens _diflbLoadBalancerName (\s a -> s { _diflbLoadBalancerName = a })

newtype DeregisterInstancesFromLoadBalancerResponse = DeregisterInstancesFromLoadBalancerResponse
    { _diflbrInstances :: List "member" Instance
    } deriving (Eq, Read, Show, Monoid, Semigroup)

instance GHC.Exts.IsList DeregisterInstancesFromLoadBalancerResponse where
    type Item DeregisterInstancesFromLoadBalancerResponse = Instance

    fromList = DeregisterInstancesFromLoadBalancerResponse . GHC.Exts.fromList
    toList   = GHC.Exts.toList . _diflbrInstances

-- | 'DeregisterInstancesFromLoadBalancerResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'diflbrInstances' @::@ ['Instance']
--
deregisterInstancesFromLoadBalancerResponse :: DeregisterInstancesFromLoadBalancerResponse
deregisterInstancesFromLoadBalancerResponse = DeregisterInstancesFromLoadBalancerResponse
    { _diflbrInstances = mempty
    }

-- | The remaining instances registered with the load balancer.
diflbrInstances :: Lens' DeregisterInstancesFromLoadBalancerResponse [Instance]
diflbrInstances = lens _diflbrInstances (\s a -> s { _diflbrInstances = a }) . _List

instance ToPath DeregisterInstancesFromLoadBalancer where
    toPath = const "/"

instance ToQuery DeregisterInstancesFromLoadBalancer where
    toQuery DeregisterInstancesFromLoadBalancer{..} = mconcat
        [ "Instances"        =? _diflbInstances
        , "LoadBalancerName" =? _diflbLoadBalancerName
        ]

instance ToHeaders DeregisterInstancesFromLoadBalancer

instance AWSRequest DeregisterInstancesFromLoadBalancer where
    type Sv DeregisterInstancesFromLoadBalancer = ELB
    type Rs DeregisterInstancesFromLoadBalancer = DeregisterInstancesFromLoadBalancerResponse

    request  = post "DeregisterInstancesFromLoadBalancer"
    response = xmlResponse

instance FromXML DeregisterInstancesFromLoadBalancerResponse where
    parseXML = withElement "DeregisterInstancesFromLoadBalancerResult" $ \x -> DeregisterInstancesFromLoadBalancerResponse
        <$> x .@? "Instances" .!@ mempty
