//
//  NewsCellStyle1.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/15.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit

class NewsCellStyle1: UITableViewCell{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension NewsCellStyle1: NewsCellProtocol {
    func bindData(model: News) {
        titleLabel.text = model.title
        sourceLabel.text = model.source
        commentLabel.text = String(model.comment_count)+"评论"
        timeLabel.text = model.publishTimeString
    }
    
    static func reuseIdentify() -> String {
        return "NewsCellStyle1"
    }
}
