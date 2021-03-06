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

-- Module      : Network.AWS.SQS.CreateQueue
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

-- | Creates a new queue, or returns the URL of an existing one. When you request 'CreateQueue', you provide a name for the queue. To successfully create a new queue, you
-- must provide a name that is unique within the scope of your own queues.
--
-- If you delete a queue, you must wait at least 60 seconds before creating a
-- queue with the same name.
--
-- You may pass one or more attributes in the request. If you do not provide a
-- value for any attribute, the queue will have the default value for that
-- attribute. Permitted attributes are the same that can be set using 'SetQueueAttributes'.
--
-- Use 'GetQueueUrl' to get a queue's URL. 'GetQueueUrl' requires only the 'QueueName'
-- parameter.
--
-- If you provide the name of an existing queue, along with the exact names and
-- values of all the queue's attributes, 'CreateQueue' returns the queue URL for
-- the existing queue. If the queue name, attribute names, or attribute values
-- do not match an existing queue, 'CreateQueue' returns an error.
--
-- Some API actions take lists of parameters. These lists are specified using
-- the 'param.n' notation. Values of 'n' are integers starting from 1. For example,
-- a parameter list with two elements looks like this:  '&Attribute.1=this'
--
-- '&Attribute.2=that'
--
-- <http://docs.aws.amazon.com/AWSSimpleQueueService/latest/APIReference/API_CreateQueue.html>
module Network.AWS.SQS.CreateQueue
    (
    -- * Request
      CreateQueue
    -- ** Request constructor
    , createQueue
    -- ** Request lenses
    , cqAttributes
    , cqQueueName

    -- * Response
    , CreateQueueResponse
    -- ** Response constructor
    , createQueueResponse
    -- ** Response lenses
    , cqrQueueUrl
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.SQS.Types
import qualified GHC.Exts

data CreateQueue = CreateQueue
    { _cqAttributes :: EMap "entry" "Name" "Value" Text Text
    , _cqQueueName  :: Text
    } deriving (Eq, Read, Show)

-- | 'CreateQueue' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'cqAttributes' @::@ 'HashMap' 'Text' 'Text'
--
-- * 'cqQueueName' @::@ 'Text'
--
createQueue :: Text -- ^ 'cqQueueName'
            -> CreateQueue
createQueue p1 = CreateQueue
    { _cqQueueName  = p1
    , _cqAttributes = mempty
    }

-- | A map of attributes with their corresponding values.
--
-- The following lists the names, descriptions, and values of the special
-- request parameters the 'CreateQueue' action uses:
--
-- 'DelaySeconds' - The time in seconds that the delivery of all messages in
-- the queue will be delayed. An integer from 0 to 900 (15 minutes). The default
-- for this attribute is 0 (zero).  'MaximumMessageSize' - The limit of how many
-- bytes a message can contain before Amazon SQS rejects it. An integer from
-- 1024 bytes (1 KiB) up to 262144 bytes (256 KiB). The default for this
-- attribute is 262144 (256 KiB).  'MessageRetentionPeriod' - The number of
-- seconds Amazon SQS retains a message. Integer representing seconds, from 60
-- (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4
-- days).  'Policy' - The queue's policy. A valid AWS policy. For more information
-- about policy structure, see <http://docs.aws.amazon.com/IAM/latest/UserGuide/PoliciesOverview.html Overview of AWS IAM Policies> in the /Amazon IAMUser Guide/.  'ReceiveMessageWaitTimeSeconds' - The time for which a 'ReceiveMessage' call will wait for a message to arrive. An integer from 0 to 20 (seconds).
-- The default for this attribute is 0.   'VisibilityTimeout' - The visibility
-- timeout for the queue. An integer from 0 to 43200 (12 hours). The default for
-- this attribute is 30. For more information about visibility timeout, see <http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/AboutVT.html Visibility Timeout> in the /Amazon SQS Developer Guide/.
cqAttributes :: Lens' CreateQueue (HashMap Text Text)
cqAttributes = lens _cqAttributes (\s a -> s { _cqAttributes = a }) . _EMap

-- | The name for the queue to be created.
cqQueueName :: Lens' CreateQueue Text
cqQueueName = lens _cqQueueName (\s a -> s { _cqQueueName = a })

newtype CreateQueueResponse = CreateQueueResponse
    { _cqrQueueUrl :: Maybe Text
    } deriving (Eq, Ord, Read, Show, Monoid)

-- | 'CreateQueueResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'cqrQueueUrl' @::@ 'Maybe' 'Text'
--
createQueueResponse :: CreateQueueResponse
createQueueResponse = CreateQueueResponse
    { _cqrQueueUrl = Nothing
    }

-- | The URL for the created Amazon SQS queue.
cqrQueueUrl :: Lens' CreateQueueResponse (Maybe Text)
cqrQueueUrl = lens _cqrQueueUrl (\s a -> s { _cqrQueueUrl = a })

instance ToPath CreateQueue where
    toPath = const "/"

instance ToQuery CreateQueue where
    toQuery CreateQueue{..} = mconcat
        [ toQuery    _cqAttributes
        , "QueueName" =? _cqQueueName
        ]

instance ToHeaders CreateQueue

instance AWSRequest CreateQueue where
    type Sv CreateQueue = SQS
    type Rs CreateQueue = CreateQueueResponse

    request  = post "CreateQueue"
    response = xmlResponse

instance FromXML CreateQueueResponse where
    parseXML = withElement "CreateQueueResult" $ \x -> CreateQueueResponse
        <$> x .@? "QueueUrl"
