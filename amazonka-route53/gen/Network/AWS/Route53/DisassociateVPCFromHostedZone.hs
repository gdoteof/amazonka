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

-- Module      : Network.AWS.Route53.DisassociateVPCFromHostedZone
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

-- | This action disassociates a VPC from an hosted zone.
--
-- To disassociate a VPC to a hosted zone, send a 'POST' request to the '2013-04-01/hostedzone//hosted zone ID//disassociatevpc resource. The request body must include an XML
-- document with a 'DisassociateVPCFromHostedZoneRequest' element. The response
-- returns the 'DisassociateVPCFromHostedZoneResponse' element that contains 'ChangeInfo' for you to track the progress of the 'DisassociateVPCFromHostedZoneRequest'
-- you made. See 'GetChange' operation for how to track the progress of your
-- change.
--
-- <http://docs.aws.amazon.com/Route53/latest/APIReference/API_DisassociateVPCFromHostedZone.html>
module Network.AWS.Route53.DisassociateVPCFromHostedZone
    (
    -- * Request
      DisassociateVPCFromHostedZone
    -- ** Request constructor
    , disassociateVPCFromHostedZone
    -- ** Request lenses
    , dvpcfhzComment
    , dvpcfhzHostedZoneId
    , dvpcfhzVPC

    -- * Response
    , DisassociateVPCFromHostedZoneResponse
    -- ** Response constructor
    , disassociateVPCFromHostedZoneResponse
    -- ** Response lenses
    , dvpcfhzrChangeInfo
    ) where

import Network.AWS.Prelude
import Network.AWS.Request.RestXML
import Network.AWS.Route53.Types
import qualified GHC.Exts

data DisassociateVPCFromHostedZone = DisassociateVPCFromHostedZone
    { _dvpcfhzComment      :: Maybe Text
    , _dvpcfhzHostedZoneId :: Text
    , _dvpcfhzVPC          :: VPC
    } deriving (Eq, Read, Show)

-- | 'DisassociateVPCFromHostedZone' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dvpcfhzComment' @::@ 'Maybe' 'Text'
--
-- * 'dvpcfhzHostedZoneId' @::@ 'Text'
--
-- * 'dvpcfhzVPC' @::@ 'VPC'
--
disassociateVPCFromHostedZone :: Text -- ^ 'dvpcfhzHostedZoneId'
                              -> VPC -- ^ 'dvpcfhzVPC'
                              -> DisassociateVPCFromHostedZone
disassociateVPCFromHostedZone p1 p2 = DisassociateVPCFromHostedZone
    { _dvpcfhzHostedZoneId = p1
    , _dvpcfhzVPC          = p2
    , _dvpcfhzComment      = Nothing
    }

-- | /Optional:/ Any comments you want to include about a 'DisassociateVPCFromHostedZoneRequest'.
dvpcfhzComment :: Lens' DisassociateVPCFromHostedZone (Maybe Text)
dvpcfhzComment = lens _dvpcfhzComment (\s a -> s { _dvpcfhzComment = a })

-- | The ID of the hosted zone you want to disassociate your VPC from.
--
-- Note that you cannot disassociate the last VPC from a hosted zone.
dvpcfhzHostedZoneId :: Lens' DisassociateVPCFromHostedZone Text
dvpcfhzHostedZoneId =
    lens _dvpcfhzHostedZoneId (\s a -> s { _dvpcfhzHostedZoneId = a })

-- | The VPC that you want your hosted zone to be disassociated from.
dvpcfhzVPC :: Lens' DisassociateVPCFromHostedZone VPC
dvpcfhzVPC = lens _dvpcfhzVPC (\s a -> s { _dvpcfhzVPC = a })

newtype DisassociateVPCFromHostedZoneResponse = DisassociateVPCFromHostedZoneResponse
    { _dvpcfhzrChangeInfo :: ChangeInfo
    } deriving (Eq, Read, Show)

-- | 'DisassociateVPCFromHostedZoneResponse' constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'dvpcfhzrChangeInfo' @::@ 'ChangeInfo'
--
disassociateVPCFromHostedZoneResponse :: ChangeInfo -- ^ 'dvpcfhzrChangeInfo'
                                      -> DisassociateVPCFromHostedZoneResponse
disassociateVPCFromHostedZoneResponse p1 = DisassociateVPCFromHostedZoneResponse
    { _dvpcfhzrChangeInfo = p1
    }

-- | A complex type that contains the ID, the status, and the date and time of
-- your 'DisassociateVPCFromHostedZoneRequest'.
dvpcfhzrChangeInfo :: Lens' DisassociateVPCFromHostedZoneResponse ChangeInfo
dvpcfhzrChangeInfo =
    lens _dvpcfhzrChangeInfo (\s a -> s { _dvpcfhzrChangeInfo = a })

instance ToPath DisassociateVPCFromHostedZone where
    toPath DisassociateVPCFromHostedZone{..} = mconcat
        [ "/2013-04-01/hostedzone/"
        , toText _dvpcfhzHostedZoneId
        , "/disassociatevpc"
        ]

instance ToQuery DisassociateVPCFromHostedZone where
    toQuery = const mempty

instance ToHeaders DisassociateVPCFromHostedZone

instance ToXMLRoot DisassociateVPCFromHostedZone where
    toXMLRoot DisassociateVPCFromHostedZone{..} = namespaced ns "DisassociateVPCFromHostedZone"
        [ "VPC"     =@ _dvpcfhzVPC
        , "Comment" =@ _dvpcfhzComment
        ]

instance ToXML DisassociateVPCFromHostedZone

instance AWSRequest DisassociateVPCFromHostedZone where
    type Sv DisassociateVPCFromHostedZone = Route53
    type Rs DisassociateVPCFromHostedZone = DisassociateVPCFromHostedZoneResponse

    request  = post
    response = xmlResponse

instance FromXML DisassociateVPCFromHostedZoneResponse where
    parseXML x = DisassociateVPCFromHostedZoneResponse
        <$> x .@  "ChangeInfo"
