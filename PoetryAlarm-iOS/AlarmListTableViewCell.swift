//
//  AlarmListTableViewCell.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/21.
//  Copyright © 2017年 this. All rights reserved.
//

import UIKit

class AlarmListTableViewCell: UITableViewCell {
    
    var timeLabel = UILabel()//!<时间lable
    
    var remarkLabel = UILabel()//!<标签
    
    var stateSwitch = UISwitch()//!<切换状态
    
    var repeatLabel = UILabel()//!<重复模式
    
    var deleteButton = UIButton()//!<删除按钮

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initElements()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //每次修改尺寸都计算子视图
        
        if(backgroundView == nil){
            return
        }
        
        let paddingY:CGFloat = 5.0
        let paddingX:CGFloat = 13.0
        
        var subviewRect = self.contentView.bounds.insetBy(dx: 13.0, dy: paddingY)
        backgroundView?.frame = subviewRect
        
        //第一行
        timeLabel.sizeToFit()
        subviewRect.size = timeLabel.frame.size
        subviewRect.origin.x = 13.0 * 2
        subviewRect.origin.y = paddingY * 2
        timeLabel.frame = subviewRect
        
        //先计算第一行的状态switch
        subviewRect.size.width = subviewRect.size.height / 0.618
        subviewRect.origin.x = self.contentView.bounds.maxX - subviewRect.size.width - paddingX
        stateSwitch.frame = subviewRect
        
        //最后计算中建的remarkLabel
        subviewRect.origin.x = timeLabel.frame.maxX + 13.0
        subviewRect.size.width = stateSwitch.frame.origin.x - subviewRect.origin.x - 13.0
        remarkLabel.frame = subviewRect
        
        //第二行,同样先计算按钮
        subviewRect.size = CGSize.init(width: 30.0, height: 30.0)
        subviewRect.origin.x = backgroundView!.frame.maxX - paddingX - subviewRect.size.width
        subviewRect.origin.y = backgroundView!.frame.maxY - subviewRect.size.height
        deleteButton.frame = subviewRect
        
        subviewRect.origin.x = backgroundView!.frame.origin.x + paddingX
        subviewRect.size.width = deleteButton.frame.origin.x - subviewRect.origin.x - paddingX
        repeatLabel.frame = subviewRect
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     * 初始化单元格元素
     */
    func initElements(){
        
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        //背景视图
        let backView = UIView.init()
        backView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.1)
        self.backgroundView = backView
        
        //第一行
        timeLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        timeLabel.textColor = UIColor.black
        self.contentView.addSubview(timeLabel)
        
        remarkLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.contentView.addSubview(remarkLabel)
        
        self.contentView.addSubview(stateSwitch)
        
        repeatLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.contentView.addSubview(repeatLabel)
        
        deleteButton.setImage(#imageLiteral(resourceName: "deleteButton"), for: UIControlState.normal)
        self.contentView.addSubview(deleteButton)
    }

}
