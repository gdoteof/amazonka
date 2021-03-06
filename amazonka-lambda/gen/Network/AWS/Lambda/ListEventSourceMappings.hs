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

-- Module      : Network.AWS.Lambda.ListEventSourceMappings
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

-- | Returns a list of event source mappings you created using the 'CreateEventSourceMapping' (see 'CreateEventSourceMapping'), where you identify a stream as an event
-- source. This list does not include Amazon S3 event sources.
--
-- For each mapping, the API returns configuration information. You can
-- optionally specify filters to retrieve specific event source mappings.
--
-- This operation requires permission for the 'lambda:ListEventSourceMappings'
-- action.
--
-- <http://docs.aws.amazon.com/lambda/latest/dg/API_ListEventSourceMappings.html>
module Network.AWS.Lambda.ListEventSourceMappings
    (
    -- * Request
      ListEventSourceMappings
    -- ** Request constructor
    , listEventSourceMappings
    -- ** Request lenses
    , lesmEventSourceArn
    , lesmFunctionName
    , lesmMarker
    , lesmMaxItems

    -- * Response
    , ListEventSourceMappingsResponse
    -- ** Response constructor
    , listEventSourceMappingsResponse
    -- ** Response lenses
    , lesmrEventSourceMappings
    , lesmrNextMarker
    ) where

import Network.AWS.Data (Object)
import Network.AWS.Prelude
import Network.AWS.Request.RestJSON
import Network.AWS.Lambda.Types
import qualified GHC.Exts

data ListEventSourceMappings = ListEventSourceMappings
    { _lesmEventSourceArn :: Maybe Text
    , _lesmFunctionName   :: Maybe Text
    , _lesmMarker         :: Maybe Text
    , _lesmMaxItems       :: Maybe Nat
    } deriving (Eq, Ord, Read, Show)

-- | 'ListEventSourceMappings' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lesmEventSourceArn' @::@ 'Maybe' 'Text'
--
-- * 'lesmFunctionName' @::@ 'Maybe' 'Text'
--
-- * 'lesmMarker' @::@ 'Maybe' 'Text'
--
-- * 'lesmMaxItems' @::@ 'Maybe' 'Natural'
--
listEventSourceMappings :: ListEventSourceMappings
listEventSourceMappings = ListEventSourceMappings
    { _lesmEventSourceArn = Nothing
    , _lesmFunctionName   = Nothing
    , _lesmMarker         = Nothing
    , _lesmMaxItems       = Nothing
    }

-- | The Amazon Resource Name (ARN) of the Amazon Kinesis stream.
lesmEventSourceArn :: Lens' ListEventSourceMappings (Maybe Text)
lesmEventSourceArn =
    lens _lesmEventSourceArn (\s a -> s { _lesmEventSourceArn = a })

-- | The name of the Lambda function.
--
-- You can specify an unqualified function name (for example, "Thumbnail") or
-- you can specify Amazon Resource Name (ARN) of the function (for example,
-- "arn:aws:lambda:us-west-2:account-id:function:ThumbNail"). AWS Lambda also
-- allows you to specify only the account ID qualifier (for example,
-- "account-id:Thumbnail"). Note that the length constraint applies only to the
-- ARN. If you specify only the function name, it is limited to 64 character in
-- length.
lesmFunctionName :: Lens' ListEventSourceMappings (Maybe Text)
lesmFunctionName = lens _lesmFunctionName (\s a -> s { _lesmFunctionName = a })

-- | Optional string. An opaque pagination token returned from a previous 'ListEventSourceMappings' operation. If present, specifies to continue the list from where the
-- returning call left off.
lesmMarker :: Lens' ListEventSourceMappings (Maybe Text)
lesmMarker = lens _lesmMarker (\s a -> s { _lesmMarker = a })

-- | Optional integer. Specifies the maximum number of event sources to return in
-- response. This value must be greater than 0.
lesmMaxItems :: Lens' ListEventSourceMappings (Maybe Natural)
lesmMaxItems = lens _lesmMaxItems (\s a -> s { _lesmMaxItems = a }) . mapping _Nat

data ListEventSourceMappingsResponse = ListEventSourceMappingsResponse
    { _lesmrEventSourceMappings :: List "EventSourceMappings" EventSourceMappingConfiguration
    , _lesmrNextMarker          :: Maybe Text
    } deriving (Eq, Read, Show)

-- | 'ListEventSourceMappingsResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lesmrEventSourceMappings' @::@ ['EventSourceMappingConfiguration']
--
-- * 'lesmrNextMarker' @::@ 'Maybe' 'Text'
--
listEventSourceMappingsResponse :: ListEventSourceMappingsResponse
listEventSourceMappingsResponse = ListEventSourceMappingsResponse
    { _lesmrNextMarker          = Nothing
    , _lesmrEventSourceMappings = mempty
    }

-- | An array of 'EventSourceMappingConfiguration' objects.
lesmrEventSourceMappings :: Lens' ListEventSourceMappingsResponse [EventSourceMappingConfiguration]
lesmrEventSourceMappings =
    lens _lesmrEventSourceMappings
        (\s a -> s { _lesmrEventSourceMappings = a })
            . _List

-- | A string, present if there are more event source mappings.
lesmrNextMarker :: Lens' ListEventSourceMappingsResponse (Maybe Text)
lesmrNextMarker = lens _lesmrNextMarker (\s a -> s { _lesmrNextMarker = a })

instance ToPath ListEventSourceMappings where
    toPath = const "/2015-03-31/event-source-mappings/"

instance ToQuery ListEventSourceMappings where
    toQuery ListEventSourceMappings{..} = mconcat
        [ "EventSourceArn" =? _lesmEventSourceArn
        , "FunctionName"   =? _lesmFunctionName
        , "Marker"         =? _lesmMarker
        , "MaxItems"       =? _lesmMaxItems
        ]

instance ToHeaders ListEventSourceMappings

instance ToJSON ListEventSourceMappings where
    toJSON = const (toJSON Empty)

instance AWSRequest ListEventSourceMappings where
    type Sv ListEventSourceMappings = Lambda
    type Rs ListEventSourceMappings = ListEventSourceMappingsResponse

    request  = get
    response = jsonResponse

instance FromJSON ListEventSourceMappingsResponse where
    parseJSON = withObject "ListEventSourceMappingsResponse" $ \o -> ListEventSourceMappingsResponse
        <$> o .:? "EventSourceMappings" .!= mempty
        <*> o .:? "NextMarker"

instance AWSPager ListEventSourceMappings where
    page rq rs
        | stop (rs ^. lesmrNextMarker) = Nothing
        | otherwise = (\x -> rq & lesmMarker ?~ x)
            <$> (rs ^. lesmrNextMarker)
