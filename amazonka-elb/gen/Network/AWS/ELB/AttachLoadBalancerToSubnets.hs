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

-- Module      : Network.AWS.ELB.AttachLoadBalancerToSubnets
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

-- | Adds one or more subnets to the set of configured subnets for the specified
-- load balancer.
--
-- The load balancer evenly distributes requests across all registered subnets.
-- For more information, see <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/UserScenariosForVPC.html Elastic Load Balancing in Amazon VPC> in the /ElasticLoad Balancing Developer Guide/.
--
-- <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_AttachLoadBalancerToSubnets.html>
module Network.AWS.ELB.AttachLoadBalancerToSubnets
    (
    -- * Request
      AttachLoadBalancerToSubnets
    -- ** Request constructor
    , attachLoadBalancerToSubnets
    -- ** Request lenses
    , albtsLoadBalancerName
    , albtsSubnets

    -- * Response
    , AttachLoadBalancerToSubnetsResponse
    -- ** Response constructor
    , attachLoadBalancerToSubnetsResponse
    -- ** Response lenses
    , albtsrSubnets
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.ELB.Types
import qualified GHC.Exts

data AttachLoadBalancerToSubnets = AttachLoadBalancerToSubnets
    { _albtsLoadBalancerName :: Text
    , _albtsSubnets          :: List "member" Text
    } deriving (Eq, Ord, Read, Show)

-- | 'AttachLoadBalancerToSubnets' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'albtsLoadBalancerName' @::@ 'Text'
--
-- * 'albtsSubnets' @::@ ['Text']
--
attachLoadBalancerToSubnets :: Text -- ^ 'albtsLoadBalancerName'
                            -> AttachLoadBalancerToSubnets
attachLoadBalancerToSubnets p1 = AttachLoadBalancerToSubnets
    { _albtsLoadBalancerName = p1
    , _albtsSubnets          = mempty
    }

-- | The name of the load balancer.
albtsLoadBalancerName :: Lens' AttachLoadBalancerToSubnets Text
albtsLoadBalancerName =
    lens _albtsLoadBalancerName (\s a -> s { _albtsLoadBalancerName = a })

-- | The IDs of the subnets to add for the load balancer. You can add only one
-- subnet per Availability Zone.
albtsSubnets :: Lens' AttachLoadBalancerToSubnets [Text]
albtsSubnets = lens _albtsSubnets (\s a -> s { _albtsSubnets = a }) . _List

newtype AttachLoadBalancerToSubnetsResponse = AttachLoadBalancerToSubnetsResponse
    { _albtsrSubnets :: List "member" Text
    } deriving (Eq, Ord, Read, Show, Monoid, Semigroup)

instance GHC.Exts.IsList AttachLoadBalancerToSubnetsResponse where
    type Item AttachLoadBalancerToSubnetsResponse = Text

    fromList = AttachLoadBalancerToSubnetsResponse . GHC.Exts.fromList
    toList   = GHC.Exts.toList . _albtsrSubnets

-- | 'AttachLoadBalancerToSubnetsResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'albtsrSubnets' @::@ ['Text']
--
attachLoadBalancerToSubnetsResponse :: AttachLoadBalancerToSubnetsResponse
attachLoadBalancerToSubnetsResponse = AttachLoadBalancerToSubnetsResponse
    { _albtsrSubnets = mempty
    }

-- | The IDs of the subnets attached to the load balancer.
albtsrSubnets :: Lens' AttachLoadBalancerToSubnetsResponse [Text]
albtsrSubnets = lens _albtsrSubnets (\s a -> s { _albtsrSubnets = a }) . _List

instance ToPath AttachLoadBalancerToSubnets where
    toPath = const "/"

instance ToQuery AttachLoadBalancerToSubnets where
    toQuery AttachLoadBalancerToSubnets{..} = mconcat
        [ "LoadBalancerName" =? _albtsLoadBalancerName
        , "Subnets"          =? _albtsSubnets
        ]

instance ToHeaders AttachLoadBalancerToSubnets

instance AWSRequest AttachLoadBalancerToSubnets where
    type Sv AttachLoadBalancerToSubnets = ELB
    type Rs AttachLoadBalancerToSubnets = AttachLoadBalancerToSubnetsResponse

    request  = post "AttachLoadBalancerToSubnets"
    response = xmlResponse

instance FromXML AttachLoadBalancerToSubnetsResponse where
    parseXML = withElement "AttachLoadBalancerToSubnetsResult" $ \x -> AttachLoadBalancerToSubnetsResponse
        <$> x .@? "Subnets" .!@ mempty
