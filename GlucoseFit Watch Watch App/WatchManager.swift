//
//  WatchManager.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/16/25.
//
import WatchConnectivity
import SwiftData
import SwiftUI

class WatchManager: NSObject, WCSessionDelegate {
    static let shared = WatchManager()
    
    var modelContext: ModelContext?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("Activation state: \(activationState.rawValue)")
        
        print("Reachable: \(session.isReachable)")
    }
    
    func activateSession() {
        guard WCSession.isSupported() else {
            print("❌ WCSession not supported")
            return
        }
        print("Reachable: \(WCSession.default.isReachable)")
        
        WCSession.default.delegate = self
        WCSession.default.activate()
        
        print("Activation State: \(WCSession.default.activationState.rawValue)")
    }
    
    func checkStatus() {
        print("Installed: \(WCSession.default.isCompanionAppInstalled)")
        print("Reachable: \(WCSession.default.isReachable)")
        print("Activation: \(WCSession.default.activationState.rawValue)")
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private override init() {
        super.init()
    }
}
