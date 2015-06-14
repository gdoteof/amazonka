{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE OverloadedStrings #-}

-- Module      : Network.AWS.EC2.ReplaceNetworkACLEntry
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

-- | Replaces an entry (rule) in a network ACL. For more information about
-- network ACLs, see
-- <http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_ACLs.html Network ACLs>
-- in the /Amazon Virtual Private Cloud User Guide/.
--
-- <http://docs.aws.amazon.com/AWSEC2/latest/APIReference/ApiReference-query-ReplaceNetworkACLEntry.html>
module Network.AWS.EC2.ReplaceNetworkACLEntry
    (
    -- * Request
      ReplaceNetworkACLEntry
    -- ** Request constructor
    , replaceNetworkACLEntry
    -- ** Request lenses
    , rnaeICMPTypeCode
    , rnaePortRange
    , rnaeDryRun
    , rnaeNetworkACLId
    , rnaeRuleNumber
    , rnaeProtocol
    , rnaeRuleAction
    , rnaeEgress
    , rnaeCIDRBlock

    -- * Response
    , ReplaceNetworkACLEntryResponse
    -- ** Response constructor
    , replaceNetworkACLEntryResponse
    ) where

import Network.AWS.Request
import Network.AWS.Response
import Network.AWS.Prelude
import Network.AWS.EC2.Types

-- | /See:/ 'replaceNetworkACLEntry' smart constructor.
--
-- The fields accessible through corresponding lenses are:
--
-- * 'rnaeICMPTypeCode'
--
-- * 'rnaePortRange'
--
-- * 'rnaeDryRun'
--
-- * 'rnaeNetworkACLId'
--
-- * 'rnaeRuleNumber'
--
-- * 'rnaeProtocol'
--
-- * 'rnaeRuleAction'
--
-- * 'rnaeEgress'
--
-- * 'rnaeCIDRBlock'
data ReplaceNetworkACLEntry = ReplaceNetworkACLEntry'{_rnaeICMPTypeCode :: Maybe ICMPTypeCode, _rnaePortRange :: Maybe PortRange, _rnaeDryRun :: Maybe Bool, _rnaeNetworkACLId :: Text, _rnaeRuleNumber :: Int, _rnaeProtocol :: Text, _rnaeRuleAction :: RuleAction, _rnaeEgress :: Bool, _rnaeCIDRBlock :: Text} deriving (Eq, Read, Show)

-- | 'ReplaceNetworkACLEntry' smart constructor.
replaceNetworkACLEntry :: Text -> Int -> Text -> RuleAction -> Bool -> Text -> ReplaceNetworkACLEntry
replaceNetworkACLEntry pNetworkACLId pRuleNumber pProtocol pRuleAction pEgress pCIDRBlock = ReplaceNetworkACLEntry'{_rnaeICMPTypeCode = Nothing, _rnaePortRange = Nothing, _rnaeDryRun = Nothing, _rnaeNetworkACLId = pNetworkACLId, _rnaeRuleNumber = pRuleNumber, _rnaeProtocol = pProtocol, _rnaeRuleAction = pRuleAction, _rnaeEgress = pEgress, _rnaeCIDRBlock = pCIDRBlock};

-- | ICMP protocol: The ICMP type and code. Required if specifying 1 (ICMP)
-- for the protocol.
rnaeICMPTypeCode :: Lens' ReplaceNetworkACLEntry (Maybe ICMPTypeCode)
rnaeICMPTypeCode = lens _rnaeICMPTypeCode (\ s a -> s{_rnaeICMPTypeCode = a});

-- | TCP or UDP protocols: The range of ports the rule applies to. Required
-- if specifying 6 (TCP) or 17 (UDP) for the protocol.
rnaePortRange :: Lens' ReplaceNetworkACLEntry (Maybe PortRange)
rnaePortRange = lens _rnaePortRange (\ s a -> s{_rnaePortRange = a});

-- | Checks whether you have the required permissions for the action, without
-- actually making the request, and provides an error response. If you have
-- the required permissions, the error response is @DryRunOperation@.
-- Otherwise, it is @UnauthorizedOperation@.
rnaeDryRun :: Lens' ReplaceNetworkACLEntry (Maybe Bool)
rnaeDryRun = lens _rnaeDryRun (\ s a -> s{_rnaeDryRun = a});

-- | The ID of the ACL.
rnaeNetworkACLId :: Lens' ReplaceNetworkACLEntry Text
rnaeNetworkACLId = lens _rnaeNetworkACLId (\ s a -> s{_rnaeNetworkACLId = a});

-- | The rule number of the entry to replace.
rnaeRuleNumber :: Lens' ReplaceNetworkACLEntry Int
rnaeRuleNumber = lens _rnaeRuleNumber (\ s a -> s{_rnaeRuleNumber = a});

-- | The IP protocol. You can specify @all@ or @-1@ to mean all protocols.
rnaeProtocol :: Lens' ReplaceNetworkACLEntry Text
rnaeProtocol = lens _rnaeProtocol (\ s a -> s{_rnaeProtocol = a});

-- | Indicates whether to allow or deny the traffic that matches the rule.
rnaeRuleAction :: Lens' ReplaceNetworkACLEntry RuleAction
rnaeRuleAction = lens _rnaeRuleAction (\ s a -> s{_rnaeRuleAction = a});

-- | Indicates whether to replace the egress rule.
--
-- Default: If no value is specified, we replace the ingress rule.
rnaeEgress :: Lens' ReplaceNetworkACLEntry Bool
rnaeEgress = lens _rnaeEgress (\ s a -> s{_rnaeEgress = a});

-- | The network range to allow or deny, in CIDR notation.
rnaeCIDRBlock :: Lens' ReplaceNetworkACLEntry Text
rnaeCIDRBlock = lens _rnaeCIDRBlock (\ s a -> s{_rnaeCIDRBlock = a});

instance AWSRequest ReplaceNetworkACLEntry where
        type Sv ReplaceNetworkACLEntry = EC2
        type Rs ReplaceNetworkACLEntry =
             ReplaceNetworkACLEntryResponse
        request = post
        response
          = receiveNull ReplaceNetworkACLEntryResponse'

instance ToHeaders ReplaceNetworkACLEntry where
        toHeaders = const mempty

instance ToPath ReplaceNetworkACLEntry where
        toPath = const "/"

instance ToQuery ReplaceNetworkACLEntry where
        toQuery ReplaceNetworkACLEntry'{..}
          = mconcat
              ["Action" =:
                 ("ReplaceNetworkACLEntry" :: ByteString),
               "Version" =: ("2015-04-15" :: ByteString),
               "Icmp" =: _rnaeICMPTypeCode,
               "PortRange" =: _rnaePortRange,
               "DryRun" =: _rnaeDryRun,
               "NetworkAclId" =: _rnaeNetworkACLId,
               "RuleNumber" =: _rnaeRuleNumber,
               "Protocol" =: _rnaeProtocol,
               "RuleAction" =: _rnaeRuleAction,
               "Egress" =: _rnaeEgress,
               "CidrBlock" =: _rnaeCIDRBlock]

-- | /See:/ 'replaceNetworkACLEntryResponse' smart constructor.
data ReplaceNetworkACLEntryResponse = ReplaceNetworkACLEntryResponse' deriving (Eq, Read, Show)

-- | 'ReplaceNetworkACLEntryResponse' smart constructor.
replaceNetworkACLEntryResponse :: ReplaceNetworkACLEntryResponse
replaceNetworkACLEntryResponse = ReplaceNetworkACLEntryResponse';