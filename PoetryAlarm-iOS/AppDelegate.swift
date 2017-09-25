//
//  AppDelegate.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 this. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        
        //注册消息通知
        UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert , UNAuthorizationOptions.badge , UNAuthorizationOptions.sound]) { (granted:Bool, error:Error?) -> Void in
            
            if(granted){
                print("允许通知")
            }
            else{
                print("不允许通知")
            }
        }
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.black], for: UIControlState.normal)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //MARK: - UNUserNotificationCenterDelegate
    
    //在应用内展示通知。点击了从顶部弹出的通知后，进入APP会执行这个函数
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let pqvc = PoetryQuestionViewController()
        
        //获取我们之前存储的userinfo
        let userinfo = response.notification.request.content.userInfo
        
        print("receive notification:\(userinfo)")
        
        //获取存储的铃声地址
        pqvc.ringtoneDirectory = userinfo[AnyHashable(alarmRingtoneDierctory)] as! String
        pqvc.ringtoneName = userinfo[AnyHashable(alarmRingtoneName)] as! String
       
        if self.window?.rootViewController is UINavigationController {
            
            DispatchQueue.global().async {
                
                DispatchQueue.main.async {
                    
                    let navi = self.window?.rootViewController as! UINavigationController
                    
                    navi.pushViewController(pqvc, animated: true)
                }
                
            }
        }
        
        completionHandler()
        
        
    }
    
    //当应用处于打开状态时，收到通知后会首先进入这个函数。
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        completionHandler([.alert,.badge,.sound])
        
    }

}

