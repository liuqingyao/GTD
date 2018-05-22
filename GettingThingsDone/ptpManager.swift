//
//  ptpManager.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 22/5/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ptpManagerDelegate {
    func foundPeer()
    func lostPeer()
}

class ptpManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    
    var session : MCSession!
    var peer : MCPeerID!
    var browser : MCNearbyServiceBrowser!
    var advertiser : MCNearbyServiceAdvertiser!
    
    var foundPeers = [MCPeerID]()
    
    var invitationHandler : ((Bool, MCSession?) -> Void)!
    
    var delegate : ptpManagerDelegate?
    
    override init(){
        super.init()
        
        peer = MCPeerID(displayName : UIDevice.currentDevice.name)
        
        session = MCSession(peer : peer)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer : peer, serviceType : "todo-exchange")
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer:peer, discoveryInfo:nil, serviceType : "todo-exchange")
        advertiser.delegate = self
        
        
    }
    
    //Found Peer
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        foundPeers.append(peerID)
        
        delegate?.foundPeer()
    }
    
    //Lost Peer
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        for (index, aPeer) in enumerate(foundPeers){
            if aPeer == peerID {
                foundPeers.removeAtIndex(index)
                break
            }
        }
        
        delegate?.lostPeer()
    }
    
    //Print Errors during Browsing
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        println(error.localizedDescription)
    }
    
    
    
    
    
    
}

