//
//  AlarmDetailViewController.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/18.
//  Copyright © 2017年 this. All rights reserved.
//  闹钟的详细页面

import UIKit

class AlarmDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var timeBackImage: UIImageView?//!<时间的背景图片
    
    var timeButton:UIButton?//!<时间
    
    //星期的选择按钮
    var monButton:UIButton = UIButton.init()
    var tuesButton:UIButton = UIButton.init()
    var wedButton:UIButton = UIButton.init()
    var thurButton:UIButton = UIButton.init()
    var friButton:UIButton = UIButton.init()
    var satButton:UIButton = UIButton.init()
    var sunButton:UIButton = UIButton.init()
    
    let timePicker = UIDatePicker.init()//!<时间选择器
    
    //设置详情的表格，
    let detailSetTable = UITableView.init()
    
    let remarkTextField = UITextField.init()
    
    let ringtoneSelectButton = UIButton.init()
    
    //数据变量
    var isNew = false//!<是否是新建的闹钟
    var isNewAlarm: Bool{
        get{
            return isNew
        }
        set{
            isNew = newValue
        }
    }
    
    var alarm :Alarm?//当前的闹钟
    
    // MARK: - view load
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        print("is new alarm :\(isNewAlarm)")
        initNavigationBar()
        initElements()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailSetTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // MARK: - init
    
    /*
     * 初始化导航栏
     */
    func initNavigationBar(){
        self.navigationItem.title = "设置闹钟"
        
        //添加右边的菜单项
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: UIBarButtonItemStyle.done, target: self, action: #selector(saveButtonAction))
        
        //左侧菜单
        let leftButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 30.0))
        leftButton.setImage(#imageLiteral(resourceName: "back"), for: UIControlState.normal)
        leftButton.addTarget(self, action: #selector(backAction(button:)), for: UIControlEvents.touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        
    }
    
    /*
     * 初始化页面元素
     */
    func initElements() {
        
        let swidth = UIScreen.main.bounds.size.width
        let sheight = UIScreen.main.bounds.size.height
        
        var tempRect = CGRect.zero
        
        tempRect.size.width = swidth
        tempRect.size.height = sheight / 2 //屏幕长度的一般
        
        //时间的背景图片
        timeBackImage = UIImageView.init(frame: tempRect)
        timeBackImage?.image = #imageLiteral(resourceName: "timeBack")
        
        self.view.addSubview(timeBackImage!)
        
        //时间
        tempRect.size.height = sheight / 4 //时间的高度是背景图片的一半。
        tempRect.origin.y = 64.0//从导航栏下面开始布局
        timeButton = UIButton.init(frame: tempRect)
        timeButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        timeButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: tempRect.size.height * 0.618)
        timeButton?.titleLabel?.textAlignment = NSTextAlignment.center
        timeButton?.setTitle("00:00", for: UIControlState.normal)
        timeButton?.backgroundColor = UIColor.clear
        timeButton?.addTarget(self, action: #selector(timeButtonAction(button:)), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(timeButton!)
        
        //添加星期的按钮
        let buttonWidth = swidth / 10
        let buttonPadding = (swidth - buttonWidth * 7) / 8 //8个间隔
        var buttonRect = CGRect.init(x: buttonPadding, y: (timeButton?.frame.maxY)!, width: buttonWidth, height: buttonWidth)
        var loopIndex: NSInteger = 0
        
        while loopIndex < 7 {
            //
            var currentButton:UIButton?
            
            switch loopIndex{
            case 0:
                currentButton = monButton
            case 1:
                currentButton = tuesButton
            case 2:
                currentButton = wedButton
            case 3:
                currentButton = thurButton
            case 4:
                currentButton = friButton
            case 5:
                currentButton = satButton
            case 6:
                currentButton = sunButton
            default:
                print("按钮索引错误")
            }
            
            buttonRect.origin.x = buttonPadding + (buttonPadding + buttonWidth) * CGFloat(loopIndex)
            currentButton?.frame = buttonRect
            
            currentButton?.layer.cornerRadius = buttonWidth / 2
            currentButton?.layer.borderWidth = 1.0
            currentButton?.layer.borderColor = UIColor.gray.cgColor
            
            currentButton?.setTitle("\(loopIndex + 1)", for: UIControlState.normal)
            currentButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonWidth * 0.618)
            
            //设置选中状态下的显示
            currentButton?.setTitleColor(UIColor.white, for: UIControlState.selected)
            
            //记录按钮的tag，用于索引按钮
            currentButton?.tag = loopIndex + 10
            
            currentButton?.addTarget(self, action: #selector(weekdayButtonAction(button:)), for: UIControlEvents.touchUpInside)
            
            self.view.addSubview(currentButton!)
            
            loopIndex += 1
        }// end of while
        
        //设置其他的table
        tempRect.origin.y = (timeBackImage?.frame.maxY)!
        tempRect.size.height = sheight - tempRect.origin.y
        detailSetTable.frame = tempRect
        detailSetTable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        detailSetTable.backgroundColor = colorViewBackground
        detailSetTable.allowsSelection = false
        detailSetTable.bounces = false
        detailSetTable.tableFooterView = UIView.init()
        //注册cell
        detailSetTable.register(AlarmDetailTableViewCell.classForCoder(), forCellReuseIdentifier: "AlarmDetailCell")
        detailSetTable.dataSource = self
        detailSetTable.delegate = self
        
        self.view.addSubview(detailSetTable)
        
        remarkTextField.placeholder = "请输入标签"
        
        ringtoneSelectButton.setTitle("默认", for: UIControlState.normal)
        ringtoneSelectButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        ringtoneSelectButton.addTarget(self, action: #selector(ringtoneButtonAction), for: UIControlEvents.touchUpInside)
        ringtoneSelectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        //时间选择器
        var pickerRect = UIScreen.main.bounds
        pickerRect.size.height = pickerRect.size.width * 0.618
        pickerRect.origin.y = self.view.bounds.size.height - pickerRect.size.height
        timePicker.frame = pickerRect
        timePicker.datePickerMode = UIDatePickerMode.time
        timePicker.addTarget(self, action: #selector(timeDidChangedAction(picker:)), for: UIControlEvents.valueChanged)
        timePicker.backgroundColor = UIColor.init(white: 1.0, alpha: 1.0)
    }
    
    /*
     * 初始化数据
     */
    func initData() {
        
        
        if(alarm != nil){
            //加载指定的闹钟
            timeButton!.setTitle(alarm!.timeString, for: UIControlState.normal)
            
            remarkTextField.text = alarm!.remarkString
            
        }
        else{
            //新建一个闹钟
            alarm = Alarm()
            
            let now = Date()
            let calendar = Calendar.current
            
            let dateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute,.weekday], from: now)
            
            let timeString = String.init(format: "%02i:%02i", arguments: [dateComponents.hour!,dateComponents.minute!])
            
            timeButton?.setTitle(timeString, for: UIControlState.normal)
            
            alarm?.timeString = timeString
        }
        
        setWeekdayButtonState(isSelect: alarm!.monday, button: monButton)
        setWeekdayButtonState(isSelect: alarm!.tuesday, button: tuesButton)
        setWeekdayButtonState(isSelect: alarm!.wednesday, button: wedButton)
        setWeekdayButtonState(isSelect: alarm!.thursday, button: thurButton)
        setWeekdayButtonState(isSelect: alarm!.friday, button: friButton)
        setWeekdayButtonState(isSelect: alarm!.saturday, button: satButton)
        setWeekdayButtonState(isSelect: alarm!.sunday, button: sunButton)
        
        
    }
    
    func setWeekdayButtonState(isSelect: Bool, button: UIButton) {
        button.isSelected = isSelect
        
        if(button.isSelected){
            button.backgroundColor = weekdayButtonSelectedBack
        }
        else{
            button.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - actions
    
    @objc func timeButtonAction(button:UIButton){
        
        var tempRect = CGRect.zero
        tempRect.size = CGSize.init(width: timePicker.frame.size.width, height: 40.0)
        tempRect.origin.y = timePicker.frame.origin.y - tempRect.size.height
        
        let timeConfirmButton = UIButton.init(frame: tempRect)
        timeConfirmButton.setTitle("完成", for: UIControlState.normal)
        timeConfirmButton.addTarget(self, action: #selector(timePickerConfirmButtonAction(button:)), for: UIControlEvents.touchUpInside)
        timeConfirmButton.backgroundColor = UIColor.init(white: 1.0, alpha: 1.0)
        timeConfirmButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        timeConfirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        
        UIView.animate(withDuration: 0.3) {
            self.view.addSubview(self.timePicker)
            self.view.addSubview(timeConfirmButton)
        }
    }
    
    @objc func timePickerConfirmButtonAction(button:UIButton){
        
        UIView.animate(withDuration: 0.3) {
            self.timePicker.removeFromSuperview()
            button.removeFromSuperview()
        }
    }
    
    @objc func timeDidChangedAction(picker:UIDatePicker){
        
        let dateComponents = picker.calendar.dateComponents([.year,.month,.day,.hour,.minute,.weekday], from: picker.date)
        
        let timeString = String.init(format: "%02i:%02i", arguments: [dateComponents.hour!,dateComponents.minute!])
        
        timeButton?.setTitle(timeString, for: UIControlState.normal)
        
    }
    
    @objc func weekdayButtonAction(button:UIButton) {
        
        print("selece weekday :\(button.tag)")
        button.isSelected = !button.isSelected
        
        if(button.isSelected){
            button.backgroundColor = weekdayButtonSelectedBack
        }
        else{
            button.backgroundColor = UIColor.clear
        }
        
        //
        switch button.tag {
        case 10:
            alarm?.monday = button.isSelected
        case 11:
            alarm?.tuesday = button.isSelected
        case 12:
            alarm?.wednesday = button.isSelected
        case 13:
            alarm?.thursday = button.isSelected
        case 14:
            alarm?.friday = button.isSelected
        case 15:
            alarm?.saturday = button.isSelected
        case 16:
            alarm?.sunday = button.isSelected
            
        default:
            print("weekday button tag error")
        }
    }
    
    @objc func ringtoneButtonAction() {
        print("选择铃声")
        
        let ringtoneView = RingtoneTableViewController()
        ringtoneView.alarm = alarm
        self.navigationController?.pushViewController(ringtoneView, animated: true)
    }
    
    @objc func saveButtonAction(){
        print("保存")
        
        if(remarkTextField.text != nil){
            alarm!.remarkString = remarkTextField.text!
        }
        
        alarm!.timeString = timeButton!.titleLabel!.text!
        
        if(isNew){
            DataManager.instance.addNewAlarm(newAlarm: alarm!)
        }
        
        self.navigationController?.popViewController(animated: true)
        
        DataManager.instance.saveData()
        
        //如果是打开状态就推送通知
        if alarm!.isopen {
            alarm?.postTheAlarmToNotificationCenter()
        }
        
    }
    
    @objc func backAction(button:UIView){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmDetailCell", for: indexPath) as! AlarmDetailTableViewCell
        
        if(indexPath.row == 0){
            //第一行展示标签
            cell.promptLabel.text = "标签:"
            
            //输入框
            cell.mainView = remarkTextField
            
        }
        else if(indexPath.row == 1){
            //第二行展示铃声
            cell.promptLabel.text = "铃声:"
            
            //按钮
            cell.mainView = ringtoneSelectButton
            
        }
        else{
            cell.mainView = nil
        }
        
        remarkTextField.text = alarm!.remarkString
        
        if alarm?.ringtoneName != nil && !(alarm!.ringtoneName.isEmpty){
            ringtoneSelectButton.setTitle(alarm!.ringtoneName, for: UIControlState.normal)

        }
        return cell
    }
    
    
    
    //MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
