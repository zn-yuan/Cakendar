//
//  CanlendarCollectionViewCell.swift
//  Calendar
//
//  Created by hzf on 16/11/1.
//  Copyright © 2016年 hzf. All rights reserved.
//

import UIKit

class CanlendarCollectionViewCell: UICollectionViewCell {
    
    var dateLabel: UILabel!
    var monthModel: MonthModel? {
        
        willSet{
            guard let v = newValue else {
                return
            }
            dateLabel.text = String(v.dayValue)
            if (v.isSelectedDay) {
                self.dateLabel.backgroundColor = UIColor.red
                self.dateLabel.textColor = UIColor.white
            }
            
        }
        
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        dateLabel = UILabel()
        dateLabel.textAlignment = .center
//        dateLabel.layer.borderColor = UIColor.redColor().CGColor
//        dateLabel.layer.borderWidth = 1
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        self.contentView.addSubview(dateLabel)
        
        weak var weakself = self
        dateLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(weakself!.contentView)
        }
        
    }
}
