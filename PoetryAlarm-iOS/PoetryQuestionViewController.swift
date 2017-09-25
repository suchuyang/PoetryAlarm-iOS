//
//  PoetryQuestionViewController.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/22.
//  Copyright © 2017年 this. All rights reserved.
//

import UIKit
import AVFoundation

class PoetryQuestionViewController: UIViewController, UITextFieldDelegate {
    
    //诗名
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    //!<作者
    lazy var writerLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    //问题第一部分
    var bodyLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    //答案输入框
    var answerTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = NSTextAlignment.center
        textField.placeholder = "在这里输入答案"
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    //问题第二部分
    var bodyLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        return label
    }()
    
    
    var avaudio:AVAudioPlayer?
    
    var poetry: Poetry? //!<问题数据模型
    
    var istest = false //!<是否是测试，不是测试的时候需要把返回按钮屏蔽
    
    var ringtoneDirectory = ""//!<铃声所在的目录
    var ringtoneName = ""//铃声名字
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = colorViewBackground
        
        poetry = DataManager.instance.getPoetryAsQuestion()
        
        poetry?.buildQuestion()
        
        initElements()
        initNavigationBar()
        initRingtonePlayer()
        
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
    
    // MARK: - navigation
    func initNavigationBar(){
        
        if !istest {
            //左侧菜单
            let leftButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 30.0))
            leftButton.setTitle("休息10分钟", for: UIControlState.normal)
            leftButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            leftButton.addTarget(self, action: #selector(haveARestForTenMinutes), for: UIControlEvents.touchUpInside)
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        }
        else{
            //左侧菜单
            let leftButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 30.0))
            leftButton.setImage(#imageLiteral(resourceName: "back"), for: UIControlState.normal)
            leftButton.addTarget(self, action: #selector(backAction(button:)), for: UIControlEvents.touchUpInside)
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        }
    }
    
    @objc func backAction(button:UIView){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    /* showRightCloseBarItem:显示右边的关闭按钮
             这个按钮只会在非测试模式下，回答正确只会才会显示。
     */
    func showRightCloseBarItem(){
        
        if !istest {
            let rightButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 40.0, height: 30.0))
            rightButton.setImage(#imageLiteral(resourceName: "close"), for: UIControlState.normal)
            rightButton.addTarget(self, action: #selector(backAction(button:)), for: UIControlEvents.touchUpInside)
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
        }
        
    }
    
    // MARK: - init
    
    /*
     *  初始化页面的元素
     */
    func initElements() {
        
        let sWidth = UIScreen.main.bounds.size.width
        
        var tempRect = CGRect.zero
        
        //诗名
        tempRect.origin.y = 150.0
        tempRect.size.width = sWidth
        tempRect.size.height = 24.0
        nameLabel.frame = tempRect
        nameLabel.text = poetry?.name
        self.view.addSubview(nameLabel)
        
        //作者
        tempRect.origin.y = nameLabel.frame.maxY + 13.0
        writerLabel.frame = tempRect
        writerLabel.text = poetry?.writer
        self.view.addSubview(writerLabel)
        
        
        //正文第一部分
        tempRect.origin.y = writerLabel.frame.maxY + 13.0
        bodyLabel1.text = poetry?.bodyPart1
        bodyLabel1.sizeToFit()
        tempRect.size.height = bodyLabel1.frame.size.height
        bodyLabel1.frame = tempRect
        self.view.addSubview(bodyLabel1)
        
        //问题输入框
        tempRect.origin.y = bodyLabel1.frame.maxY
        tempRect.size.height = 40.0
        answerTextField.frame = tempRect
        answerTextField.delegate = self
        self.view.addSubview(answerTextField)
        
        //正文第一部分
        tempRect.origin.y = answerTextField.frame.maxY
        bodyLabel2.text = poetry?.bodyPart2
        bodyLabel2.sizeToFit()
        tempRect.size.height = bodyLabel2.frame.size.height
        bodyLabel2.frame = tempRect
        self.view.addSubview(bodyLabel2)
        
    }
    
    /* initRingtonePlayer:初始化铃声播放
     */
    func initRingtonePlayer(){
        
        var ringtoneUrl = ""
        
        //先取设定的铃声
        if !ringtoneName.isEmpty && !ringtoneDirectory.isEmpty{
            //
            
            var dir = ""
            
            if ringtoneDirectory == "PoetryAlarm-iOS" {
                dir = Bundle.main.bundlePath
            }
            else{
                dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
            }
            
            ringtoneUrl = dir+"/"+ringtoneName
            
        }
        
        //如果没取到，取最后一次选择的铃声
        if ringtoneUrl.isEmpty{
            ringtoneUrl = DataManager.instance.lastSelectRingtoneForTest
        }
        
        //然后取app自带的铃声
        if ringtoneUrl.isEmpty{
            //取默认的铃声
            let localRings = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")
            
            for v in localRings{
                
                ringtoneUrl = v
                
                if !ringtoneUrl.isEmpty{
                    break
                }
            }
        }
        
        do{
            self.avaudio = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: ringtoneUrl))
            self.avaudio?.play()
        }
        catch let error as NSError {
            print("error\(error)")
        }
        
    }
    
    // MARK: - action
    
    @objc func haveARestForTenMinutes(){
        print("休息十分钟")
        //推送一个十分钟间隔的通知
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == poetry?.answer {
            
            
            //提示用户回答正确，然后退出页面
            
            DispatchQueue.global().async {
                
                DispatchQueue.main.async {
                    
                    //提示用户本闹钟已经打开
                    let _ = WIndicator.showMsgInView(self.view, text: "回答正确", timeOut: 1.0)
                }
                
            }
            //播放
            if let audioplayer = avaudio{
                if audioplayer.isPlaying{
                    audioplayer.stop()
                }
            }
            
            showRightCloseBarItem()
            
            return true
        }
        else{
            DispatchQueue.global().async {
                
                DispatchQueue.main.async {
                    
                    //提示用户本闹钟已经打开
                    let _ = WIndicator.showMsgInView(self.view, text: "回答错误", timeOut: 1.0)
                }
                
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == poetry?.answer {
            
            
            //提示用户回答正确，然后退出页面
            
            DispatchQueue.global().async {
                
                DispatchQueue.main.async {
                    
                    //提示用户本闹钟已经打开
                    let _ = WIndicator.showMsgInView(self.view, text: "回答正确", timeOut: 1.0)
                }
                
            }
            //播放
            if let audioplayer = avaudio{
                if audioplayer.isPlaying{
                    audioplayer.stop()
                }
            }
            
            showRightCloseBarItem()
            
            
        }
        else{
            DispatchQueue.global().async {
                
                DispatchQueue.main.async {
                    
                    //提示用户本闹钟已经打开
                    let _ = WIndicator.showMsgInView(self.view, text: "回答错误", timeOut: 1.0)
                }
                
            }
        }
    }//end of textFieldDidEndEditing

}
