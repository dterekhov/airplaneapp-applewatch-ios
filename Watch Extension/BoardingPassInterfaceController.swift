//
//  BoardingPassInterfaceController.swift
//  AirAber
//
//  Created by Dmitry Terekhov on 11/21/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

extension BoardingPassInterfaceController: WCSessionDelegate {
    private func showBoardingPass() {
        boardingPassImage.stopAnimating()
        boardingPassImage.setWidth(120)
        boardingPassImage.setHeight(120)
        boardingPassImage.setImage(flight?.boardingPass)
    }
}

class BoardingPassInterfaceController: WKInterfaceController {
    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    @IBOutlet var boardingPassImage: WKInterfaceImage!
    
    var flight: Flight? {
        didSet {
            guard let flight = flight else { return }
            originLabel.setText(flight.origin)
            destinationLabel.setText(flight.destination)
            
            if flight.boardingPass != nil {
                showBoardingPass()
            }
        }
    }
    
    var session: WCSession? {
        didSet {
            guard let session = session else { return }
            session.delegate = self
            session.activateSession()
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let flight = context as? Flight { self.flight = flight }
    }
    
    override func didAppear() {
        super.didAppear()
        
        guard let flight = flight where flight.boardingPass == nil && WCSession.isSupported()
            else { return }
        
        session = WCSession.defaultSession()
        session?.sendMessage(["reference" : flight.reference], replyHandler: { response -> Void in
            if let boardingPassData = response["boardingPassData"] as? NSData, boardingPass = UIImage(data: boardingPassData) {
                flight.boardingPass = boardingPass
                dispatch_async(dispatch_get_main_queue()) { self.showBoardingPass() }
            }
            }, errorHandler: { error -> Void in
                print(error)
        })
    }
}