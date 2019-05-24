//
//  Menu.swift
//  HGSlideUpMenu
//
//  Created by hesham ghalaab on 5/24/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import Foundation
struct Menu {
    
    let title: String
    let imageName: String
    
    static func initData() -> [Menu]{
        var menuData = [Menu]()
        menuData.append(Menu(title: "Download", imageName: "Download"))
        menuData.append(Menu(title: "Save", imageName: "Save"))
        menuData.append(Menu(title: "Share", imageName: "Share"))
        menuData.append(Menu(title: "Report", imageName: "Report"))
        menuData.append(Menu(title: "Not Interested", imageName: "NotInterested"))
        return menuData
    }
}
