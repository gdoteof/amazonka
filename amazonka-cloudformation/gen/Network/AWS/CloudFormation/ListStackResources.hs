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

-- Module      : Network.AWS.CloudFormation.ListStackResources
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

-- | Returns descriptions of all resources of the specified stack.
--
-- For deleted stacks, ListStackResources returns resource information for up
-- to 90 days after the stack has been deleted.
--
-- <http://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_ListStackResources.html>
module Network.AWS.CloudFormation.ListStackResources
    (
    -- * Request
      ListStackResources
    -- ** Request constructor
    , listStackResources
    -- ** Request lenses
    , lsrNextToken
    , lsrStackName

    -- * Response
    , ListStackResourcesResponse
    -- ** Response constructor
    , listStackResourcesResponse
    -- ** Response lenses
    , lsrrNextToken
    , lsrrStackResourceSummaries
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.Query
import Network.AWS.CloudFormation.Types
import qualified GHC.Exts

data ListStackResources = ListStackResources
    { _lsrNextToken :: Maybe Text
    , _lsrStackName :: Text
    } deriving (Eq, Ord, Read, Show)

-- | 'ListStackResources' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lsrNextToken' @::@ 'Maybe' 'Text'
--
-- * 'lsrStackName' @::@ 'Text'
--
listStackResources :: Text -- ^ 'lsrStackName'
                   -> ListStackResources
listStackResources p1 = ListStackResources
    { _lsrStackName = p1
    , _lsrNextToken = Nothing
    }

-- | String that identifies the start of the next list of stack resource
-- summaries, if there is one.
--
-- Default: There is no default value.
lsrNextToken :: Lens' ListStackResources (Maybe Text)
lsrNextToken = lens _lsrNextToken (\s a -> s { _lsrNextToken = a })

-- | The name or the unique stack ID that is associated with the stack, which are
-- not always interchangeable:
--
-- Running stacks: You can specify either the stack's name or its unique stack
-- ID. Deleted stacks: You must specify the unique stack ID.  Default: There is
-- no default value.
lsrStackName :: Lens' ListStackResources Text
lsrStackName = lens _lsrStackName (\s a -> s { _lsrStackName = a })

data ListStackResourcesResponse = ListStackResourcesResponse
    { _lsrrNextToken              :: Maybe Text
    , _lsrrStackResourceSummaries :: List "member" StackResourceSummary
    } deriving (Eq, Read, Show)

-- | 'ListStackResourcesResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'lsrrNextToken' @::@ 'Maybe' 'Text'
--
-- * 'lsrrStackResourceSummaries' @::@ ['StackResourceSummary']
--
listStackResourcesResponse :: ListStackResourcesResponse
listStackResourcesResponse = ListStackResourcesResponse
    { _lsrrStackResourceSummaries = mempty
    , _lsrrNextToken              = Nothing
    }

-- | String that identifies the start of the next list of stack resources, if
-- there is one.
lsrrNextToken :: Lens' ListStackResourcesResponse (Maybe Text)
lsrrNextToken = lens _lsrrNextToken (\s a -> s { _lsrrNextToken = a })

-- | A list of 'StackResourceSummary' structures.
lsrrStackResourceSummaries :: Lens' ListStackResourcesResponse [StackResourceSummary]
lsrrStackResourceSummaries =
    lens _lsrrStackResourceSummaries
        (\s a -> s { _lsrrStackResourceSummaries = a })
            . _List

instance ToPath ListStackResources where
    toPath = const "/"

instance ToQuery ListStackResources where
    toQuery ListStackResources{..} = mconcat
        [ "NextToken" =? _lsrNextToken
        , "StackName" =? _lsrStackName
        ]

instance ToHeaders ListStackResources

instance AWSRequest ListStackResources where
    type Sv ListStackResources = CloudFormation
    type Rs ListStackResources = ListStackResourcesResponse

    request  = post "ListStackResources"
    response = xmlResponse

instance FromXML ListStackResourcesResponse where
    parseXML = withElement "ListStackResourcesResult" $ \x -> ListStackResourcesResponse
        <$> x .@? "NextToken"
        <*> x .@? "StackResourceSummaries" .!@ mempty

instance AWSPager ListStackResources where
    page rq rs
        | stop (rs ^. lsrrNextToken) = Nothing
        | otherwise = (\x -> rq & lsrNextToken ?~ x)
            <$> (rs ^. lsrrNextToken)
