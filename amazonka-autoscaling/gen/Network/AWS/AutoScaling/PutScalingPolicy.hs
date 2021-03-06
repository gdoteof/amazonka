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

-- Module      : Network.AWS.AutoScaling.PutScalingPolicy
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

-- | Creates or updates a policy for an Auto Scaling group. To update an existing
-- policy, use the existing policy name and set the parameters you want to
-- change. Any existing parameter not changed in an update to an existing policy
-- is not changed in this update request.
--
-- <http://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_PutScalingPolicy.html>
module Network.AWS.AutoScaling.PutScalingPolicy
    (
    -- * Request
      PutScalingPolicy
    -- ** Request constructor
    , putScalingPolicy
    -- ** Request lenses
    , pspAdjustmentType
    , pspAutoScalingGroupName
    , pspCooldown
    , pspMinAdjustmentStep
    , pspPolicyName
    , pspScalingAdjustment

    -- * Response
    , PutScalingPolicyResponse
    -- ** Response constructor
    , putScalingPolicyResponse
    -- ** Response lenses
    , psprPolicyARN
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.AutoScaling.Types
import qualified GHC.Exts

data PutScalingPolicy = PutScalingPolicy
    { _pspAdjustmentType       :: Text
    , _pspAutoScalingGroupName :: Text
    , _pspCooldown             :: Maybe Int
    , _pspMinAdjustmentStep    :: Maybe Int
    , _pspPolicyName           :: Text
    , _pspScalingAdjustment    :: Int
    } deriving (Eq, Ord, Read, Show)

-- | 'PutScalingPolicy' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'pspAdjustmentType' @::@ 'Text'
--
-- * 'pspAutoScalingGroupName' @::@ 'Text'
--
-- * 'pspCooldown' @::@ 'Maybe' 'Int'
--
-- * 'pspMinAdjustmentStep' @::@ 'Maybe' 'Int'
--
-- * 'pspPolicyName' @::@ 'Text'
--
-- * 'pspScalingAdjustment' @::@ 'Int'
--
putScalingPolicy :: Text -- ^ 'pspAutoScalingGroupName'
                 -> Text -- ^ 'pspPolicyName'
                 -> Int -- ^ 'pspScalingAdjustment'
                 -> Text -- ^ 'pspAdjustmentType'
                 -> PutScalingPolicy
putScalingPolicy p1 p2 p3 p4 = PutScalingPolicy
    { _pspAutoScalingGroupName = p1
    , _pspPolicyName           = p2
    , _pspScalingAdjustment    = p3
    , _pspAdjustmentType       = p4
    , _pspCooldown             = Nothing
    , _pspMinAdjustmentStep    = Nothing
    }

-- | Specifies whether the 'ScalingAdjustment' is an absolute number or a percentage
-- of the current capacity. Valid values are 'ChangeInCapacity', 'ExactCapacity',
-- and 'PercentChangeInCapacity'.
--
-- For more information, see <http://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/as-scale-based-on-demand.html Dynamic Scaling> in the /Auto Scaling Developer Guide/
-- .
pspAdjustmentType :: Lens' PutScalingPolicy Text
pspAdjustmentType =
    lens _pspAdjustmentType (\s a -> s { _pspAdjustmentType = a })

-- | The name or ARN of the group.
pspAutoScalingGroupName :: Lens' PutScalingPolicy Text
pspAutoScalingGroupName =
    lens _pspAutoScalingGroupName (\s a -> s { _pspAutoScalingGroupName = a })

-- | The amount of time, in seconds, after a scaling activity completes and before
-- the next scaling activity can start.
--
-- For more information, see <http://docs.aws.amazon.com/AutoScaling/latest/DeveloperGuide/Cooldown.html Understanding Auto Scaling Cooldowns> in the /AutoScaling Developer Guide/.
pspCooldown :: Lens' PutScalingPolicy (Maybe Int)
pspCooldown = lens _pspCooldown (\s a -> s { _pspCooldown = a })

-- | Used with 'AdjustmentType' with the value 'PercentChangeInCapacity', the scaling
-- policy changes the 'DesiredCapacity' of the Auto Scaling group by at least the
-- number of instances specified in the value.
--
-- You will get a 'ValidationError' if you use 'MinAdjustmentStep' on a policy with
-- an 'AdjustmentType' other than 'PercentChangeInCapacity'.
pspMinAdjustmentStep :: Lens' PutScalingPolicy (Maybe Int)
pspMinAdjustmentStep =
    lens _pspMinAdjustmentStep (\s a -> s { _pspMinAdjustmentStep = a })

-- | The name of the policy.
pspPolicyName :: Lens' PutScalingPolicy Text
pspPolicyName = lens _pspPolicyName (\s a -> s { _pspPolicyName = a })

-- | The number of instances by which to scale. 'AdjustmentType' determines the
-- interpretation of this number (e.g., as an absolute number or as a percentage
-- of the existing Auto Scaling group size). A positive increment adds to the
-- current capacity and a negative value removes from the current capacity.
pspScalingAdjustment :: Lens' PutScalingPolicy Int
pspScalingAdjustment =
    lens _pspScalingAdjustment (\s a -> s { _pspScalingAdjustment = a })

newtype PutScalingPolicyResponse = PutScalingPolicyResponse
    { _psprPolicyARN :: Maybe Text
    } deriving (Eq, Ord, Read, Show, Monoid)

-- | 'PutScalingPolicyResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'psprPolicyARN' @::@ 'Maybe' 'Text'
--
putScalingPolicyResponse :: PutScalingPolicyResponse
putScalingPolicyResponse = PutScalingPolicyResponse
    { _psprPolicyARN = Nothing
    }

-- | The Amazon Resource Name (ARN) of the policy.
psprPolicyARN :: Lens' PutScalingPolicyResponse (Maybe Text)
psprPolicyARN = lens _psprPolicyARN (\s a -> s { _psprPolicyARN = a })

instance ToPath PutScalingPolicy where
    toPath = const "/"

instance ToQuery PutScalingPolicy where
    toQuery PutScalingPolicy{..} = mconcat
        [ "AdjustmentType"       =? _pspAdjustmentType
        , "AutoScalingGroupName" =? _pspAutoScalingGroupName
        , "Cooldown"             =? _pspCooldown
        , "MinAdjustmentStep"    =? _pspMinAdjustmentStep
        , "PolicyName"           =? _pspPolicyName
        , "ScalingAdjustment"    =? _pspScalingAdjustment
        ]

instance ToHeaders PutScalingPolicy

instance AWSRequest PutScalingPolicy where
    type Sv PutScalingPolicy = AutoScaling
    type Rs PutScalingPolicy = PutScalingPolicyResponse

    request  = post "PutScalingPolicy"
    response = xmlResponse

instance FromXML PutScalingPolicyResponse where
    parseXML = withElement "PutScalingPolicyResult" $ \x -> PutScalingPolicyResponse
        <$> x .@? "PolicyARN"
