//
//  Alarm.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 this. All rights reserved.
//  闹钟的数据模型

import Foundation
import UserNotifications
import UIKit

let alarmTime = "alarmTime"
let alarmRemark = "alarmRemark"
let alarmRingtoneName = "alarmRingtoneName"
let alarmRingtoneDierctory = "alarmRingtoneDierctory"
let alarmState = "alarmState"//!<闹钟的状态,打开或关闭
let alarmMonday = "alarmMonday"//!<
let alarmTuesday = "alarmTuesday"
let alarmWednesday = "alarmWednesday"
let alarmThurday = "alarmThurday"
let alarmFriday = "alarmFriday"
let alarmSaturday = "alarmSaturday"
let alarmSunday = "alarmSunday"


let poetryAlarmIdentifier = "poetry alarm identifier"

//
class Alarm: NSObject, NSCoding {
    
    var timeString:String = "00:00"//!<闹钟的时间,注意这个是24小时制的。
    
    var remarkString:String = ""//!<备注
    
    var ringtoneName:String = ""//!<铃声名
    
    var ringtoneDierctory:String = ""//!<铃声所在的目录
    
    var isopen:Bool = false//默认关闭状态
    
    //星期的重复，默认是每天重复
    var sunday = true
    var monday = true
    var tuesday = true
    var wednesday = true
    var thursday = true
    var friday = true
    var saturday = true
    
    /*这些属性是从kotlin直接复制过来的。哈哈*/
    
    //MARK: - init and code
    
    override init() {
        super.init()
    }
    
    
    func encode(with aCoder: NSCoder) {
        /*
         let alarmTime = "alarmTime"
         let alarmRemark = "alarmRemark"
         let alarmRingtoneName = "alarmRingtoneName"
         let alarmRingtoneUrl = "alarmRingtoneUrl"
         let alarmState = "alarmState"//!<闹钟的状态,打开或关闭
         let alarmMonday = "alarmMonday"//!<
         let alarmTuesday = "alarmTuesday"
         let alarmWensday = "alarmWensday"
         let alarmThurday = "alarmThurday"
         let alarmFriday = "alarmFriday"
         let alarmSaturday = "alarmSaturday"
         let alarmSunday = "alarmSunday"
         */
        aCoder.encode(timeString, forKey: alarmTime)
        aCoder.encode(remarkString, forKey: alarmRemark)
        aCoder.encode(ringtoneName, forKey: alarmRingtoneName)
        aCoder.encode(ringtoneDierctory, forKey: alarmRingtoneDierctory)
        aCoder.encode(isopen, forKey: alarmState)
        aCoder.encode(monday, forKey: alarmMonday)
        aCoder.encode(tuesday, forKey: alarmTuesday)
        aCoder.encode(wednesday, forKey: alarmWednesday)
        aCoder.encode(thursday, forKey: alarmThurday)
        aCoder.encode(friday, forKey: alarmFriday)
        aCoder.encode(saturday, forKey: alarmSaturday)
        aCoder.encode(sunday, forKey: alarmSunday)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        timeString = aDecoder.decodeObject(forKey: alarmTime) as! String
        remarkString = aDecoder.decodeObject(forKey: alarmRemark) as! String
        ringtoneName = aDecoder.decodeObject(forKey: alarmRingtoneName) as! String
        ringtoneDierctory = aDecoder.decodeObject(forKey: alarmRingtoneDierctory) as! String
        isopen = aDecoder.decodeBool(forKey: alarmState)
        monday = aDecoder.decodeBool(forKey: alarmMonday)
        tuesday = aDecoder.decodeBool(forKey: alarmTuesday)
        wednesday = aDecoder.decodeBool(forKey: alarmWednesday)
        thursday = aDecoder.decodeBool(forKey: alarmThurday)
        friday = aDecoder.decodeBool(forKey: alarmFriday)
        saturday = aDecoder.decodeBool(forKey: alarmSaturday)
        sunday = aDecoder.decodeBool(forKey: alarmSunday)
        
    }
    
    // MARK: - string

    
    override var description: String{
        return "timeString:" + timeString + "\tremarkString:" + remarkString
    }
    
    func repeatString() -> String {
        
        var repeatString = ""
        
        if monday {
            repeatString.append("一、")
        }
        if tuesday {
            repeatString.append("二、")
        }
        if wednesday {
            repeatString.append("三、")
        }
        if thursday {
            repeatString.append("四、")
        }
        if friday {
            repeatString.append("五、")
        }
        if saturday {
            repeatString.append("六、")
        }
        if sunday {
            repeatString.append("日、")
        }
        
        return repeatString
        
    }
    
    // MARK: - notification
    
    /*
     *  postTheAlarmToNotificationCenter：推送一个通知
     */
    func postTheAlarmToNotificationCenter(){
        
        //移除当前通知
        closeAlarmInNotification()
        
        //1、设置推送内容
        let content = UNMutableNotificationContent()
        content.title = "古诗闹钟"
        content.subtitle = self.remarkString
        content.sound = UNNotificationSound.default()
        
        if !ringtoneDierctory.isEmpty && !ringtoneName.isEmpty {
            content.userInfo = [alarmRingtoneDierctory:ringtoneDierctory,alarmRingtoneName:ringtoneName]
            
            print("userinfo:\(content.userInfo)")

        }
        
        //2、通知触发器
        let timeArray = timeString.components(separatedBy: ":")
        
        var components = DateComponents()
//        components.weekday = 7//周
        components.hour = Int(timeArray[0])
        components.minute = Int(timeArray[1])
        let triggerDateComponents = UNCalendarNotificationTrigger.init(dateMatching: components, repeats: true)
        
        
        //3、添加通知
        let request = UNNotificationRequest.init(identifier: poetryAlarmIdentifier, content: content, trigger: triggerDateComponents)
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil{
                print("Time Interval Notification scheduled: \(poetryAlarmIdentifier)")
                
                
                DispatchQueue.global().async {
                    
                    DispatchQueue.main.async {
                        
                        //提示用户本闹钟已经打开
                        WIndicator.showMsgInView(UIApplication.shared.keyWindow!, text: "已经设置\(self.timeString)的闹钟，敬请期待", timeOut: 2.0)
                    }
                    
                }
                
            }
        }
    }
    
    /*
     *  closeAlarmInNotification:关闭通知
     */
    func closeAlarmInNotification(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [poetryAlarmIdentifier])
    }
    
}
