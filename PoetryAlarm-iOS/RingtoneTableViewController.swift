//
//  RingtoneTableViewController.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 this. All rights reserved.
//

import UIKit
import AVFoundation

class RingtoneTableViewController: UITableViewController {
    
    let ringtoneUrl = "ringtoneUrl"//定义两个常量，用来当字典的key
    let ringtoneName = "ringtoneName"
    
    let localRingtoneArray = NSMutableArray()//!<铃声数组
    
    let documentRingtoneArray = NSMutableArray()//!<导入的铃声
    
    var alarm:Alarm? //!<闹钟指针
    
    var lastSelectIndexPath:IndexPath?//!< 最后选中的项。当选中了新的项之后，先把之前的取消，然后选择新的。
    
    var avaudio:AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
        
        //读取Document里的文件，和自带的文件
        readMusicList()
        
        self.tableView.reloadData()
        
        initNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - navigation
    
    /* initNavigationBar:初始化导航栏
     
     */
    func initNavigationBar() {
        //左侧菜单
        let leftButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 30.0))
        leftButton.setImage(#imageLiteral(resourceName: "back"), for: UIControlState.normal)
        leftButton.addTarget(self, action: #selector(backAction(button:)), for: UIControlEvents.touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
    }
    
    @objc func backAction(button:UIView){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - data
    
    /* readMusicList:读取铃声列表
     
     */
    func readMusicList(){
        
        let localRings = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")
        
        //把工程里的铃声转换成字典，放到数组中去。
        
        for (_,v) in localRings.enumerated(){
            
            let ringDic = NSMutableDictionary()
            ringDic.setValue(v, forKey: ringtoneUrl)
            
            let name = FileManager.default.displayName(atPath: v)
            
            ringDic.setValue(name, forKey: ringtoneName)
            
            localRingtoneArray.add(ringDic)
        }
        
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        print("applicationSupportDirectory path:\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true))")
        
        do{
            let documentRings = try FileManager.default.contentsOfDirectory(atPath: documentPath[0])
            
            print("document ringtone:\(documentRings)")
            
            
            for ringName in documentRings{
                
                //暂时只添加mp3 文件
                if ringName.hasSuffix(".mp3") {
                    let ringUrl = String.init(format: "%@/%@", documentPath[0],ringName)
                    
                    let ringDic = NSMutableDictionary()
                    ringDic.setValue(ringUrl, forKey: ringtoneUrl)
                    
                    ringDic.setValue(ringName, forKey: ringtoneName)
                    
                    documentRingtoneArray.add(ringDic)
                }// end of if
                
            }
        }// end of do
        catch{
            
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return localRingtoneArray.count
        }
        else if section == 1{
            return documentRingtoneArray.count
        }
        
        return 0
            
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        var tempRingName = ""
        var tempRingUrl = ""
        
        if indexPath.section == 0{
            let ring:NSDictionary = localRingtoneArray[indexPath.row] as! NSDictionary
            tempRingName = ring.value(forKey: ringtoneName) as! String
            tempRingUrl = ring.value(forKey: ringtoneUrl) as! String
        }
        else if indexPath.section == 1{
            let ring:NSDictionary = documentRingtoneArray[indexPath.row] as! NSDictionary
            tempRingName = ring.value(forKey: ringtoneName) as! String
            tempRingUrl = ring.value(forKey: ringtoneUrl) as! String
        }
        
        cell.textLabel?.text = tempRingName
        
        //如果铃声名字相同
        if tempRingName == alarm?.ringtoneName{
            cell.accessoryView = UIImageView.init(image: #imageLiteral(resourceName: "selectRight"))
            cell.textLabel?.textColor = UIColor.orange
            
            self.lastSelectIndexPath = indexPath
        }
        else{
            cell.accessoryView = nil
            cell.textLabel?.textColor = UIColor.black
        }

        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //更新选中状态
        let tempIndexPath = lastSelectIndexPath
        var updatePaths: Array<IndexPath> = []
        
        if tempIndexPath != nil {
            updatePaths.append(tempIndexPath!)
        }
        
        self.lastSelectIndexPath = indexPath
        updatePaths.append(indexPath)
        
        //设置闹钟
        var tempRingName = ""
        var tempRingUrl = ""
        
        if indexPath.section == 0{
            let ring:NSDictionary = localRingtoneArray[indexPath.row] as! NSDictionary
            tempRingName = ring.value(forKey: ringtoneName) as! String
            tempRingUrl = ring.value(forKey: ringtoneUrl) as! String
            
            alarm?.ringtoneDierctory = "PoetryAlarm-iOS"
        }
        else if indexPath.section == 1{
            let ring:NSDictionary = documentRingtoneArray[indexPath.row] as! NSDictionary
            tempRingName = ring.value(forKey: ringtoneName) as! String
            tempRingUrl = ring.value(forKey: ringtoneUrl) as! String
            
            alarm?.ringtoneDierctory = "Documents"
        }
        
        DataManager.instance.lastSelectRingtoneForTest = tempRingUrl
        
        alarm?.ringtoneName = tempRingName
        
        //更新单元格
        tableView.reloadRows(at: updatePaths , with: UITableViewRowAnimation.none)
        
        //停止旧的播放
        if let audioplayer = avaudio{
            if audioplayer.isPlaying{
                audioplayer.stop()
            }
        }
        
        //开始新的播放
        do{
            self.avaudio = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: tempRingUrl))
            self.avaudio?.play()
        }
        catch{
            
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
