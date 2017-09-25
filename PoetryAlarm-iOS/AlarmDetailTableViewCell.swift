//
//  AlarmDetailTableViewCell.swift
//  PoetryAlarm-iOS
//
//  Created by apple on 2017/9/21.
//  Copyright © 2017年 this. All rights reserved.
//

import UIKit

class AlarmDetailTableViewCell: UITableViewCell {
    
    var promptLabel: UILabel!//!<提示
    
    var mainView:UIView?//!<内容视图
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //初始化单元格
        
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        //背景视图
        let backView = UIView.init()
        backView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
        self.backgroundView = backView
        
        promptLabel = UILabel.init()
        promptLabel.textColor = UIColor.black
        self.contentView.addSubview(promptLabel)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        
        //每次修改尺寸都计算子视图
        
        if(backgroundView == nil){
            return
        }
        var subviewRect = self.contentView.bounds.insetBy(dx: 13.0, dy: 13.0)
        backgroundView?.frame = subviewRect
        
        promptLabel.sizeToFit()
        subviewRect.size = promptLabel.frame.size
        subviewRect.origin.x = 13.0 * 2
        subviewRect.origin.y = (backgroundView!.frame.size.height - subviewRect.size.height) / 2 + 13.0
        promptLabel.frame = subviewRect
        
        if(mainView != nil){
            subviewRect.origin.x = promptLabel.frame.maxX + 13
            subviewRect.origin.y = 13.0
            subviewRect.size.width = backgroundView!.frame.size.width - subviewRect.origin.x - 13.0
            subviewRect.size.height = backgroundView!.frame.size.height
            mainView?.frame = subviewRect
            
            if(mainView?.superview != nil){
                mainView?.removeFromSuperview()
            }
            
            self.contentView.addSubview(mainView!)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


