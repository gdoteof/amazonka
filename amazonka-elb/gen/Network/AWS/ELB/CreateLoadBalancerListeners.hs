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

-- Module      : Network.AWS.ELB.CreateLoadBalancerListeners
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

-- | Creates one or more listeners for the specified load balancer. If a listener
-- with the specified port does not already exist, it is created; otherwise, the
-- properties of the new listener must match the properties of the existing
-- listener.
--
-- For more information, see <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/us-add-listener.html Add a Listener to Your Load Balancer> in the /Elastic Load Balancing Developer Guide/.
--
-- <http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_CreateLoadBalancerListeners.html>
module Network.AWS.ELB.CreateLoadBalancerListeners
    (
    -- * Request
      CreateLoadBalancerListeners
    -- ** Request constructor
    , createLoadBalancerListeners
    -- ** Request lenses
    , clblListeners
    , clblLoadBalancerName

    -- * Response
    , CreateLoadBalancerListenersResponse
    -- ** Response constructor
    , createLoadBalancerListenersResponse
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.ELB.Types
import qualified GHC.Exts

data CreateLoadBalancerListeners = CreateLoadBalancerListeners
    { _clblListeners        :: List "member" Listener
    , _clblLoadBalancerName :: Text
    } deriving (Eq, Read, Show)

-- | 'CreateLoadBalancerListeners' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'clblListeners' @::@ ['Listener']
--
-- * 'clblLoadBalancerName' @::@ 'Text'
--
createLoadBalancerListeners :: Text -- ^ 'clblLoadBalancerName'
                            -> CreateLoadBalancerListeners
createLoadBalancerListeners p1 = CreateLoadBalancerListeners
    { _clblLoadBalancerName = p1
    , _clblListeners        = mempty
    }

-- | The listeners.
clblListeners :: Lens' CreateLoadBalancerListeners [Listener]
clblListeners = lens _clblListeners (\s a -> s { _clblListeners = a }) . _List

-- | The name of the load balancer.
clblLoadBalancerName :: Lens' CreateLoadBalancerListeners Text
clblLoadBalancerName =
    lens _clblLoadBalancerName (\s a -> s { _clblLoadBalancerName = a })

data CreateLoadBalancerListenersResponse = CreateLoadBalancerListenersResponse
    deriving (Eq, Ord, Read, Show, Generic)

-- | 'CreateLoadBalancerListenersResponse' constructor.
createLoadBalancerListenersResponse :: CreateLoadBalancerListenersResponse
createLoadBalancerListenersResponse = CreateLoadBalancerListenersResponse

instance ToPath CreateLoadBalancerListeners where
    toPath = const "/"

instance ToQuery CreateLoadBalancerListeners where
    toQuery CreateLoadBalancerListeners{..} = mconcat
        [ "Listeners"        =? _clblListeners
        , "LoadBalancerName" =? _clblLoadBalancerName
        ]

instance ToHeaders CreateLoadBalancerListeners

instance AWSRequest CreateLoadBalancerListeners where
    type Sv CreateLoadBalancerListeners = ELB
    type Rs CreateLoadBalancerListeners = CreateLoadBalancerListenersResponse

    request  = post "CreateLoadBalancerListeners"
    response = nullResponse CreateLoadBalancerListenersResponse
