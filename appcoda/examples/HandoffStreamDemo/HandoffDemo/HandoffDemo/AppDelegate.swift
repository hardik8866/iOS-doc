//
//  AppDelegate.swift
//  HandoffDemo
//
//  Created by Gabriel Theodoropoulos on 17/11/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NSStreamDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        println(userActivityType)
        
        return false
    }
    
    
    
    var inputStream: NSInputStream!
    
    var receivedData: NSMutableData!
    
    var currentActivityType: String!
    
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]!) -> Void) -> Bool {
        if let win = window {
            let navController = win.rootViewController as UINavigationController
            let viewController = navController.topViewController as ViewController
            
            viewController.restoreUserActivityState(userActivity)
        }
        
        
        if userActivity.supportsContinuationStreams {
            
            userActivity.getContinuationStreamsWithCompletionHandler({ (inputStream: NSInputStream!, outputStream: NSOutputStream!, error: NSError!) -> Void in
                if let someError = error{
                    println(someError.localizedDescription)
                }
                else{
                    if let inStream = inputStream{
                        self.receivedData = NSMutableData()
                        
                        self.currentActivityType = userActivity.activityType
                        
                        self.inputStream = inStream
                        self.inputStream.delegate = self
                        self.inputStream.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                        self.inputStream.open()
                    }
                }
            })
        }
        
        
        return true
    }

    
    func application(application: UIApplication, didUpdateUserActivity userActivity: NSUserActivity) {
        println(userActivity)
        println(userActivity.userInfo)
    }
    
    
    func application(application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: NSError) {
        println(error.localizedDescription)
        println(userActivityType)
    }

    
    // MARK: NSStreamDelegate method implementation
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if aStream == inputStream{
            if eventCode == NSStreamEvent.HasBytesAvailable{
                var buffer = Array<UInt8>(count: 1024, repeatedValue: 0)
                
                var len = 0
                
                len = inputStream.read(UnsafeMutablePointer(buffer), maxLength: 1024)
                
                if len > 0{
                    receivedData.appendBytes(buffer, length: len)
                }
            }
            
            if eventCode == NSStreamEvent.EndEncountered{
                if let activityType = currentActivityType{
                    if activityType == "com.appcoda.handoffdemo.list-contacts"{
                        NSNotificationCenter.defaultCenter().postNotificationName("receivedContactsDataNotification", object:receivedData)
                    }
                }
                
                inputStream.close()
                inputStream.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                inputStream = nil
            }
        }
    }
    
}
