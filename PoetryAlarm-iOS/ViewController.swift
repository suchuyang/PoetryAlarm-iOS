//
//  ViewController.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 this. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var alarmTableView: UITableView = UITableView()//!<闹钟的列表

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //让单例对象初始化一次
        DataManager.instance.getPoetryAsQuestion()
        
        alarmTableView = UITableView.init(frame: self.view.bounds)
        alarmTableView.register(AlarmListTableViewCell().classForCoder, forCellReuseIdentifier: "AlarmListCell")
        alarmTableView.backgroundColor = UIColor.clear
        alarmTableView.bounces = false
        alarmTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        alarmTableView.tableFooterView = UIView.init()
        
        alarmTableView.dataSource = self
        alarmTableView.delegate = self
        alarmTableView.backgroundView = UIImageView.init(image: #imageLiteral(resourceName: "mainViewBack"))
        self.view.addSubview(alarmTableView)
        self.view.backgroundColor = colorViewBackground
        
        self.initNavigationItems()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        alarmTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     *  初始化导航栏的元素
     */
    func initNavigationItems() {
        
        //设置导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        self.navigationItem.title = "诗词闹钟"
        
        //左侧菜单
        let leftButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 30.0))
        leftButton.setTitle("测试", for: UIControlState.normal)
        leftButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        leftButton.addTarget(self, action: #selector(testAlarm), for: UIControlEvents.touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        
        //添加右边的菜单项
        let rightButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 30.0))
        rightButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rightButton.setImage(#imageLiteral(resourceName: "add"), for: UIControlState.normal)
        
//        rightButton.frame = CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 30.0)
        rightButton.addTarget(self, action: #selector(addNewAlarm), for: UIControlEvents.touchUpInside)
        print("button frame:\(NSStringFromCGRect(rightButton.frame))")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
        
    }
    
    //MARK:- actions
    
    /*
     * testAlarm:测试闹钟
     */
    @objc func testAlarm(){
        
        //测试
        let pqvc = PoetryQuestionViewController()
        pqvc.istest = true
        self.navigationController?.pushViewController(pqvc, animated: true)
    }
    
    
    @objc func addNewAlarm()  {
        print("添加一个闹钟")
        
        let newAlarmVC = AlarmDetailViewController()
        newAlarmVC.isNewAlarm = true
        
        self.navigationController?.pushViewController(newAlarmVC, animated: true)
    }
    
    /*
     * 状态改变时执行的动作
     */
    @objc func switchStateChanged(switchButton: UISwitch){
        let alarm = DataManager.instance.alarmList.object(at: switchButton.tag) as! Alarm
        
        alarm.isopen = switchButton.isOn
        
        if(alarm.isopen){
            //开启闹钟
            
            alarm.postTheAlarmToNotificationCenter()
        }
        else{
            alarm.closeAlarmInNotification()
        }
        
        DataManager.instance.saveData()
    }
    
    
    //MARK:- UITableViewDataSource
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.instance.alarmList.count
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmListCell", for: indexPath) as! AlarmListTableViewCell
        
        let alarm = DataManager.instance.alarmList.object(at: indexPath.row) as! Alarm
        
        cell.stateSwitch.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        
        cell.timeLabel.text = alarm.timeString
        cell.remarkLabel.text = alarm.remarkString
        
        cell.stateSwitch.isOn = alarm.isopen
        cell.stateSwitch.addTarget(self, action: #selector(switchStateChanged(switchButton:)), for: UIControlEvents.valueChanged)
        
        cell.repeatLabel.text = alarm.repeatString()
        
        return cell
    }
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newAlarmVC = AlarmDetailViewController()
        newAlarmVC.alarm = DataManager.instance.getAlarmAtIndex(index: indexPath.row)
        
        self.navigationController?.pushViewController(newAlarmVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    

}

