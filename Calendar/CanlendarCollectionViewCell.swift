//
//  CanlendarCollectionViewCell.swift
//  Calendar
//
//  Created by qmc on 16/11/1.
//  Copyright © 2016年 刘俊杰. All rights reserved.
//

import UIKit

class CanlendarCollectionViewCell: UICollectionViewCell {
    
    var dateLabel: UILabel!
    var monthModel: MonthModel? {
        didSet {
            if monthModel != nil {
                let v = monthModel!.dayValue
                dateLabel.text = String(v)
                if (monthModel!.isSelectedDay) {
                    self.dateLabel.backgroundColor = UIColor.redColor()
                    self.dateLabel.textColor = UIColor.whiteColor()
                }
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
        dateLabel.textAlignment = .Center
//        dateLabel.layer.borderColor = UIColor.redColor().CGColor
//        dateLabel.layer.borderWidth = 1
        dateLabel.font = UIFont.systemFontOfSize(17)
        self.contentView.addSubview(dateLabel)
        
        weak var weakself = self
        dateLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(weakself!.contentView)
        }
        
    }
}
