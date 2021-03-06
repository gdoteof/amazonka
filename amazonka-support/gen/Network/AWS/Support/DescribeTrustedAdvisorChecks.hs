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

-- Module      : Network.AWS.Support.DescribeTrustedAdvisorChecks
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

-- | Returns information about all available Trusted Advisor checks, including
-- name, ID, category, description, and metadata. You must specify a language
-- code; English ("en") and Japanese ("ja") are currently supported. The
-- response contains a 'TrustedAdvisorCheckDescription' for each check.
--
-- <http://docs.aws.amazon.com/awssupport/latest/APIReference/API_DescribeTrustedAdvisorChecks.html>
module Network.AWS.Support.DescribeTrustedAdvisorChecks
    (
    -- * Request
      DescribeTrustedAdvisorChecks
    -- ** Request constructor
    , describeTrustedAdvisorChecks
    -- ** Request lenses
    , dtacLanguage

    -- * Response
    , DescribeTrustedAdvisorChecksResponse
    -- ** Response constructor
    , describeTrustedAdvisorChecksResponse
    -- ** Response lenses
    , dtacrChecks
    ) where

import Network.AWS.Data (Object)
import Network.AWS.Prelude
import Network.AWS.Request.JSON
import Network.AWS.Support.Types
import qualified GHC.Exts

newtype DescribeTrustedAdvisorChecks = DescribeTrustedAdvisorChecks
    { _dtacLanguage :: Text
    } deriving (Eq, Ord, Read, Show, Monoid, IsString)

-- | 'DescribeTrustedAdvisorChecks' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dtacLanguage' @::@ 'Text'
--
describeTrustedAdvisorChecks :: Text -- ^ 'dtacLanguage'
                             -> DescribeTrustedAdvisorChecks
describeTrustedAdvisorChecks p1 = DescribeTrustedAdvisorChecks
    { _dtacLanguage = p1
    }

-- | The ISO 639-1 code for the language in which AWS provides support. AWS
-- Support currently supports English ("en") and Japanese ("ja"). Language
-- parameters must be passed explicitly for operations that take them.
dtacLanguage :: Lens' DescribeTrustedAdvisorChecks Text
dtacLanguage = lens _dtacLanguage (\s a -> s { _dtacLanguage = a })

newtype DescribeTrustedAdvisorChecksResponse = DescribeTrustedAdvisorChecksResponse
    { _dtacrChecks :: List "checks" TrustedAdvisorCheckDescription
    } deriving (Eq, Read, Show, Monoid, Semigroup)

instance GHC.Exts.IsList DescribeTrustedAdvisorChecksResponse where
    type Item DescribeTrustedAdvisorChecksResponse = TrustedAdvisorCheckDescription

    fromList = DescribeTrustedAdvisorChecksResponse . GHC.Exts.fromList
    toList   = GHC.Exts.toList . _dtacrChecks

-- | 'DescribeTrustedAdvisorChecksResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dtacrChecks' @::@ ['TrustedAdvisorCheckDescription']
--
describeTrustedAdvisorChecksResponse :: DescribeTrustedAdvisorChecksResponse
describeTrustedAdvisorChecksResponse = DescribeTrustedAdvisorChecksResponse
    { _dtacrChecks = mempty
    }

-- | Information about all available Trusted Advisor checks.
dtacrChecks :: Lens' DescribeTrustedAdvisorChecksResponse [TrustedAdvisorCheckDescription]
dtacrChecks = lens _dtacrChecks (\s a -> s { _dtacrChecks = a }) . _List

instance ToPath DescribeTrustedAdvisorChecks where
    toPath = const "/"

instance ToQuery DescribeTrustedAdvisorChecks where
    toQuery = const mempty

instance ToHeaders DescribeTrustedAdvisorChecks

instance ToJSON DescribeTrustedAdvisorChecks where
    toJSON DescribeTrustedAdvisorChecks{..} = object
        [ "language" .= _dtacLanguage
        ]

instance AWSRequest DescribeTrustedAdvisorChecks where
    type Sv DescribeTrustedAdvisorChecks = Support
    type Rs DescribeTrustedAdvisorChecks = DescribeTrustedAdvisorChecksResponse

    request  = post "DescribeTrustedAdvisorChecks"
    response = jsonResponse

instance FromJSON DescribeTrustedAdvisorChecksResponse where
    parseJSON = withObject "DescribeTrustedAdvisorChecksResponse" $ \o -> DescribeTrustedAdvisorChecksResponse
        <$> o .:? "checks" .!= mempty
