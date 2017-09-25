//
//  DataManager.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 this. All rights reserved.
//  数据管理器，使用单例模式

import UIKit
import HandyJSON

class DataManager: NSObject {
    
    //单例模式
    static let instance:DataManager = DataManager()
    
    let alarmFileName = "alarmlist.plist"
    
    var alarmList: NSMutableArray = NSMutableArray.init()
    
    var alarmFullPath = ""//闹铃文件的完整路径
    
    var lastSelectRingtoneForTest = ""//!<记录最后一次选择的闹铃，用于测试。
    
    override required init() {
        super.init()
        
        readAlarmList()
    }
    
    /*
     * 增加一个新的alarm
     */
    func addNewAlarm(newAlarm: Alarm){
        alarmList.add(newAlarm)
        
        //存储alarm到本地
        saveData()
    }
    
    func getAlarmAtIndex(index:Int) -> Alarm? {
        
        if(index < alarmList.count){
            return alarmList.object(at: index) as? Alarm
        }
        
        return nil
    }
    
    
    /*
     *读取数据
     */
    func readAlarmList() {
        //获取文件路径
        let alarmPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        alarmFullPath = alarmPath[0] + "/" + alarmFileName
        
        print("alarm file full path is :" + alarmFullPath)
        
        if(FileManager.default.fileExists(atPath: alarmFullPath)){
            let instance = NSKeyedUnarchiver.unarchiveObject(withFile: alarmFullPath) as! [Alarm]
            
            print("instance:\(instance)")
            
            
            alarmList.setArray(instance)
        }
        
    }
    
    /*
     *保存数据
     */
    func saveData() {
        let writeResult = NSKeyedArchiver.archiveRootObject(alarmList, toFile: alarmFullPath)
        print("write result:\(writeResult)")
    }
    
    //从文件中读取诗词列表，然后随机一个做问题
    func getPoetryAsQuestion() -> Poetry?{
        
        if let jsonpath = Bundle.main.path(forResource: "poetrys", ofType: "json"){
            
            do{
                let jsonStr = try String.init(contentsOfFile: jsonpath)
                
                if let poes = [Poetry].deserialize(from: jsonStr) {
                    
                    print("poes:\(poes)")
                    let count = UInt32(poes.count)
                    let randomIndex = Int(arc4random()%count)
                    
                    return poes[randomIndex]
                }
            }
            catch let error as NSError {
                print("get poetrys error:\(error)")
            }
        }
        
        return nil
        
    }
}
