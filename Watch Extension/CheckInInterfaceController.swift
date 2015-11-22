//
//  CheckInInterfaceController.swift
//  AirAber
//
//  Created by Dmitry Terekhov on 11/21/15.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation


class CheckInInterfaceController: WKInterfaceController {
    @IBOutlet var backgroundGroup: WKInterfaceGroup!
    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    @IBOutlet var checkInButton: WKInterfaceButton!
    
    var flight: Flight? {
        didSet {
            guard let flight = flight else { return }
            originLabel.setText(flight.origin)
            destinationLabel.setText(flight.destination)
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let flight = context as? Flight {
            self.flight = flight
        }
    }
    
    @IBAction func checkInButtonTap() {
        checkInButton.setEnabled(false)
        
        let duration = 0.35
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64((duration + 0.15) * Double(NSEC_PER_SEC)))
        backgroundGroup.setBackgroundImageNamed("Progress")
        backgroundGroup.startAnimatingWithImagesInRange(NSRange(location: 0, length: 10), duration: duration, repeatCount: 1)
        dispatch_after(delay, dispatch_get_main_queue()) { () -> Void in
            self.flight?.checkedIn = true
            self.dismissController()
        }
    }
}
