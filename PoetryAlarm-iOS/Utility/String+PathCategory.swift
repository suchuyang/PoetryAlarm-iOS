//
//  String+PathCategory.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/25.
//  Copyright © 2017年 this. All rights reserved.
//

import Foundation

/*  String:添加Path相关的分类，实现获取路径的直属目录，
 因为每次app运行，路径中的/4185B5EE-F231-48D1-8B03-C6FEFC75FBE4/部分都会改变，所以我们需要排除掉这部分因素
 */
extension String{
    
    /* lastlastDirectoryForPath: 获取路径的直属目录
     
     */
    func lastDirectoryForPath() -> String{
        
        if let subPaths = FileManager.default.subpaths(atPath: self){
            if subPaths.count >= 2 {
                return subPaths[subPaths.count - 2]
            }
        }
        
        return ""
    }
    
    /* frontPathWithLastDirectory: 获取路径里除直属目录以外的部分。
     比方说/var/containers/Bundle/Application/4185B5EE-F231-48D1-8B03-C6FEFC75FBE4/PoetryAlarm-iOS.app/\U94a2\U7434.mp3，
     返回的就是/var/containers/Bundle/Application/4185B5EE-F231-48D1-8B03-C6FEFC75FBE4
     
     
     */
    func frontPathWithLastDirectory(path:String) -> String{
        return ""
    }
    
    
    
}
