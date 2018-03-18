//
//  NewsCellStyle2.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/16.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCellStyle2: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension NewsCellStyle2: NewsCellProtocol {
    func bindData(model: News) {
        print(model.source)
        titleLabel.text = model.title
        sourceLabel.text = model.source
        commentLabel.text = String(model.comment_count)+"评论"
        timeLabel.text = model.publishTimeString
        if let urlString = model.middle_image?.url, let url = URL(with: urlString)  {
            newsImageView.kf.setImage(with: url)
        }
        
        self.layoutIfNeeded()
    }
    
    static func reuseIdentify() -> String {
        return "NewsCellStyle2"
    }
}
