//
//  ViewController.swift
//  OpenTokDemo
//
//  Created by ahmed gado on 9/27/20.
//  Copyright © 2020 ahmed gado. All rights reserved.
//

import UIKit
import OpenTok

class ViewController: UIViewController {
    // Replace with your OpenTok API key
    var kApiKey = "46933924"
    // Replace with your generated session ID
    var kSessionId = "1_MX40NjkzMzkyNH5-MTYwMTI2NTYxNTk3OX4yNmxmUCt4Q3BXY3M2U0c5SmJyRjc5dVZ-fg"
    // Replace with your generated token
    var kToken = "T1==cGFydG5lcl9pZD00NjkzMzkyNCZzaWc9YjQ3Mzk3ZmJjODE0N2Y5MTkzMWY0MjQ0YjdiYWZhYTdkM2JlNGY3YjpzZXNzaW9uX2lkPTFfTVg0ME5qa3pNemt5Tkg1LU1UWXdNVEkyTlRZeE5UazNPWDR5Tm14bVVDdDRRM0JYWTNNMlUwYzVTbUp5UmpjNWRWWi1mZyZjcmVhdGVfdGltZT0xNjAxMjY1NjE2Jm5vbmNlPTAuNjM5MjY1Mzg2NTgyNjA0OCZyb2xlPW1vZGVyYXRvciZleHBpcmVfdGltZT0xNjAxMjY3NDE2JmNvbm5lY3Rpb25fZGF0YT1EYXRhJTIwdGVzdCZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ=="
    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        connectToAnOpenTokSession()

    }
    
    func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
        }
    }
    



}

// MARK: - OTSessionDelegate callbacks
extension ViewController: OTSessionDelegate {
     func sessionDidConnect(_ session: OTSession) {
       print("The client connected to the OpenTok session.")

       let settings = OTPublisherSettings()
       settings.name = UIDevice.current.name
       guard let publisher = OTPublisher(delegate: self, settings: settings) else {
           return
       }

       var error: OTError?
       session.publish(publisher, error: &error)
       guard error == nil else {
           print(error!)
           return
       }

       guard let publisherView = publisher.view else {
           return
       }
       let screenBounds = UIScreen.main.bounds
       publisherView.frame = CGRect(x: screenBounds.width - 150 - 20, y: screenBounds.height - 150 - 20, width: 150, height: 150)
       view.addSubview(publisherView)
   }


   func sessionDidDisconnect(_ session: OTSession) {
       print("The client disconnected from the OpenTok session.")
   }

   func session(_ session: OTSession, didFailWithError error: OTError) {
       print("The client failed to connect to the OpenTok session: \(error).")
   }

  
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        subscriber = OTSubscriber(stream: stream, delegate: self)
        guard let subscriber = subscriber else {
            return
        }

        var error: OTError?
        session.subscribe(subscriber, error: &error)
        guard error == nil else {
            print(error!)
            return
        }

        guard let subscriberView = subscriber.view else {
            return
        }
        subscriberView.frame = UIScreen.main.bounds
        view.insertSubview(subscriberView, at: 0)
    }


   func session(_ session: OTSession, streamDestroyed stream: OTStream) {
       print("A stream was destroyed in the session.")
   }
}
// MARK: - OTPublisherDelegate callbacks
extension ViewController: OTPublisherDelegate {
   func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
       print("The publisher failed: \(error)")
   }
}
// MARK: - OTSubscriberDelegate callbacks
extension ViewController: OTSubscriberDelegate {
   public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
       print("The subscriber did connect to the stream.")
   }

   public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
       print("The subscriber failed to connect to the stream.")
   }
}
