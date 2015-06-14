{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.S3.GetBucketCORS
-- Copyright   : (c) 2013-2015 Brendan Hay <brendan.g.hay@gmail.com>
-- License     : This Source Code Form is subject to the terms of
--               the Mozilla Public License, v. 2.0.
--               A copy of the MPL can be found in the LICENSE file or
--               you can obtain it at http://mozilla.org/MPL/2.0/.
-- Maintainer  : Brendan Hay <brendan.g.hay@gmail.com>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Derived from AWS service descriptions, licensed under Apache 2.0.

-- | Returns the cors configuration for the bucket.
--
-- <http://docs.aws.amazon.com/AmazonS3/latest/API/GetBucketCORS.html>
module Network.AWS.S3.GetBucketCORS
    (
    -- * Request
      GetBucketCORS
    -- ** Request constructor
    , getBucketCORS
    -- ** Request lenses
    , gbcBucket

    -- * Response
    , GetBucketCORSResponse
    -- ** Response constructor
    , getBucketCORSResponse
    -- ** Response lenses
    , gbcrCORSRules
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.S3.Types

-- | /See:/ 'getBucketCORS' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'gbcBucket'
newtype GetBucketCORS = GetBucketCORS'{_gbcBucket :: BucketName} deriving (Eq, Read, Show)

-- | 'GetBucketCORS' smart constructor.
getBucketCORS :: BucketName -> GetBucketCORS
getBucketCORS pBucket = GetBucketCORS'{_gbcBucket = pBucket};

-- | FIXME: Undocumented member.
gbcBucket :: Lens' GetBucketCORS BucketName
gbcBucket = lens _gbcBucket (\ s a -> s{_gbcBucket = a});

instance AWSRequest GetBucketCORS where
        type Sv GetBucketCORS = S3
        type Rs GetBucketCORS = GetBucketCORSResponse
        request = get
        response
          = receiveXML
              (\ s h x ->
                 GetBucketCORSResponse' <$> parseXMLList "CORSRule" x)

instance ToHeaders GetBucketCORS where
        toHeaders = const mempty

instance ToPath GetBucketCORS where
        toPath GetBucketCORS'{..}
          = mconcat ["/", toText _gbcBucket]

instance ToQuery GetBucketCORS where
        toQuery = const (mconcat ["cors"])

-- | /See:/ 'getBucketCORSResponse' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'gbcrCORSRules'
newtype GetBucketCORSResponse = GetBucketCORSResponse'{_gbcrCORSRules :: Maybe [CORSRule]} deriving (Eq, Read, Show)

-- | 'GetBucketCORSResponse' smart constructor.
getBucketCORSResponse :: GetBucketCORSResponse
getBucketCORSResponse = GetBucketCORSResponse'{_gbcrCORSRules = Nothing};

-- | FIXME: Undocumented member.
gbcrCORSRules :: Lens' GetBucketCORSResponse (Maybe [CORSRule])
gbcrCORSRules = lens _gbcrCORSRules (\ s a -> s{_gbcrCORSRules = a});