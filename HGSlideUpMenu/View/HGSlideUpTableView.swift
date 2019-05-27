//
//  HGSlideUpTableView.swift
//  HGSlideUpMenu
//
//  Created by hesham ghalaab on 5/27/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class HGSlideUpTableView: UITableView {

    override var contentSize: CGSize{
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        return CGSize.init(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}
