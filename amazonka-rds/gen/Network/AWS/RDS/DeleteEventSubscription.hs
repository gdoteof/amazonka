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

-- Module      : Network.AWS.RDS.DeleteEventSubscription
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

-- | Deletes an RDS event notification subscription.
--
-- <http://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_DeleteEventSubscription.html>
module Network.AWS.RDS.DeleteEventSubscription
    (
    -- * Request
      DeleteEventSubscription
    -- ** Request constructor
    , deleteEventSubscription
    -- ** Request lenses
    , desSubscriptionName

    -- * Response
    , DeleteEventSubscriptionResponse
    -- ** Response constructor
    , deleteEventSubscriptionResponse
    -- ** Response lenses
    , desrEventSubscription
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.RDS.Types
import qualified GHC.Exts

newtype DeleteEventSubscription = DeleteEventSubscription
    { _desSubscriptionName :: Text
    } deriving (Eq, Ord, Read, Show, Monoid, IsString)

-- | 'DeleteEventSubscription' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'desSubscriptionName' @::@ 'Text'
--
deleteEventSubscription :: Text -- ^ 'desSubscriptionName'
                        -> DeleteEventSubscription
deleteEventSubscription p1 = DeleteEventSubscription
    { _desSubscriptionName = p1
    }

-- | The name of the RDS event notification subscription you want to delete.
desSubscriptionName :: Lens' DeleteEventSubscription Text
desSubscriptionName =
    lens _desSubscriptionName (\s a -> s { _desSubscriptionName = a })

newtype DeleteEventSubscriptionResponse = DeleteEventSubscriptionResponse
    { _desrEventSubscription :: Maybe EventSubscription
    } deriving (Eq, Read, Show)

-- | 'DeleteEventSubscriptionResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'desrEventSubscription' @::@ 'Maybe' 'EventSubscription'
--
deleteEventSubscriptionResponse :: DeleteEventSubscriptionResponse
deleteEventSubscriptionResponse = DeleteEventSubscriptionResponse
    { _desrEventSubscription = Nothing
    }

desrEventSubscription :: Lens' DeleteEventSubscriptionResponse (Maybe EventSubscription)
desrEventSubscription =
    lens _desrEventSubscription (\s a -> s { _desrEventSubscription = a })

instance ToPath DeleteEventSubscription where
    toPath = const "/"

instance ToQuery DeleteEventSubscription where
    toQuery DeleteEventSubscription{..} = mconcat
        [ "SubscriptionName" =? _desSubscriptionName
        ]

instance ToHeaders DeleteEventSubscription

instance AWSRequest DeleteEventSubscription where
    type Sv DeleteEventSubscription = RDS
    type Rs DeleteEventSubscription = DeleteEventSubscriptionResponse

    request  = post "DeleteEventSubscription"
    response = xmlResponse

instance FromXML DeleteEventSubscriptionResponse where
    parseXML = withElement "DeleteEventSubscriptionResult" $ \x -> DeleteEventSubscriptionResponse
        <$> x .@? "EventSubscription"
