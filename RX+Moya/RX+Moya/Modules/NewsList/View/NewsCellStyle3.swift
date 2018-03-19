//
//  NewsCellStyle3.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/16.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit

class NewsCellStyle3: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var middleImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension NewsCellStyle3: NewsCellProtocol {
    func bindData(model: News) {
        titleLabel.text = model.title
        sourceLabel.text = model.source
        commentLabel.text = String(model.comment_count)+"评论"
        timeLabel.text = model.publishTimeString
        
        if let urlString = model.image_list?[0].url, let url = URL(with: urlString)  {
            leftImageView.kf.setImage(with: url)
        }
        
        if let urlString = model.image_list?[1].url, let url = URL(with: urlString)  {
            middleImageView.kf.setImage(with: url)
        }
        
        if let urlString = model.image_list?[2].url, let url = URL(with: urlString)  {
            rightImageView.kf.setImage(with: url)
        }
    }
    
    static func reuseIdentify() -> String {
        return "NewsCellStyle3"
    }
}
