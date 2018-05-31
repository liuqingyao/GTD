//
//  PeerToPeer.swift
//  GettingThingsDone
//
//  Created by Jannik Straube on 22/5/18.
//  Copyright © 2018 Jannik Straube. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol PeerToPeerDelegate : AnyObject {
    func ptpmanager(_ manager : PeerToPeer, didReceive data: Data)
}

class PeerToPeer : NSObject {
    static var serviceType = "todo-exchange"
    var delegate : PeerToPeerDelegate?
    
    var peerList = [MCPeerID]()
    
    let peerId = MCPeerID(displayName: "Jannik")
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    override init() {
        let service = PeerToPeer.serviceType
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: [ peerId.displayName : UIDevice.current.name ], serviceType: service)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: service)
        super.init()
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    lazy var session: MCSession = {
        let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    func invite(peer: MCPeerID, timeout t: TimeInterval = 10) {
        print("inviting \(peer.displayName)")
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: t)
        //Add peer to peers array
        peerList.append(peer)
        
        let center = NotificationCenter.default
        center.post(name: NSNotification.Name(rawValue: "NewPeer"), object: nil)
    }
  
    
    func send(data: Data, peers: [MCPeerID]) {
        print("Sending data to peers")
        guard !session.connectedPeers.isEmpty else { return }
        do {
            var peerc = peers
            print(peerc)
            //Remove own peer id from peers
            let i = peerc.index(of: peerId)
            if(i != nil){
                peerc.remove(at: i!)
            }
            try session.send(data, toPeers: peerc, with: .reliable)
        } catch {
            print("Error sending \(data.count) bytes: \(error)")
        }
    }
}


extension PeerToPeer: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, session)
    }
}

extension PeerToPeer: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("foundPeer: \(peerID) - \(info?.description ?? "<no info>")")
        invite(peer: peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lostPeer: \(peerID)")
        //Removing peer from peer list
        if let index = peerList.index(of: peerID){
            peerList.remove(at: index)
            print("Removed lost peer from peer list")
        }
        let center = NotificationCenter.default
        center.post(name: NSNotification.Name(rawValue: "LostPeer"), object: nil, userInfo : ["peer" : peerID])
    }
}


extension PeerToPeer: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peer \(peerID) didChangeState: \(state)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("didReceiveData: \(data)")
        DispatchQueue.main.async {
            print("Calling dispatch")
            self.delegate?.ptpmanager(self, didReceive: data)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("didFinishReceivingResourceWithName")
    }
}

