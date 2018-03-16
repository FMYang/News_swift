//
//  NewsCell.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/16.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import Foundation
import UIKit

enum NewsCellStyle {
    case noImage
    case oneImage
    case threeImage
}

class NewsCell {
    
   static func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath,
                          model: News) -> UITableViewCell {
    
        if model.image_list == nil, model.middle_image != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellStyle2.reuseIdentify(), for: indexPath) as! NewsCellStyle2
            cell.bindData(model: model)
            return cell
        }
    
        if let imageList = model.image_list {
            if imageList.count > 0 && imageList.count < 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellStyle2.reuseIdentify(), for: indexPath) as! NewsCellStyle2
                cell.bindData(model: model)
                return cell
            } else if imageList.count >= 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellStyle3.reuseIdentify(), for: indexPath) as! NewsCellStyle3
                cell.bindData(model: model)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellStyle1.reuseIdentify(), for: indexPath) as! NewsCellStyle1
                cell.bindData(model: model)
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellStyle1.reuseIdentify(), for: indexPath) as! NewsCellStyle1
            cell.bindData(model: model)
            return cell
        }
    }
}
