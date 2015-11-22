//
//  AppDelegate.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import UIKit
import WatchConnectivity

extension AppDelegate: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let reference = message["reference"] as? String, boardingPass = QRCode(reference) {
            replyHandler(["boardingPassData": boardingPass.PNGData])
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
        }
        
    return true
    }
    
    var session: WCSession? {
        didSet {
            guard let session = session else { return }
            session.delegate = self
            session.activateSession()
        }
    }
}