//
//  TitleSliderView.swift
//  PrivateEquity
//
//  Created by 杨方明 on 2017/9/13.
//  Copyright © 2017年 TDW.CN. All rights reserved.
//

import UIKit
import SnapKit

let titleNormalFont = UIFont.systemFont(ofSize: 16)
let titleSelectFont = UIFont.systemFont(ofSize: 18)

protocol ChannelViewDelegate: class {
    func didTitleButtonClick(button: UIButton)
}

class ChannelView: UIView {

    weak var delegate: ChannelViewDelegate?

    var titleButtons: Array = [UIButton]()
    var lastButton = UIButton()

    lazy var titleScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    lazy var containView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var bottomLine: UIImageView = {
        let view = UIImageView()
        view.image = UIColor.createImageFromColor(color: UIColor(valueRGB: 0xc8c7cc))
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createTitleItems(titles: [String]) {
        for i in 0..<titles.count {
            let title = titles[i]
            let titleWidth = title.sizeWithString(size: CGSize.init(width: CGFloat(MAXFLOAT), height: self.height), font: titleNormalFont).width + 20
            let btn = UIButton()
            btn.setTitle(title, for: .normal)
            btn.tag = i
            btn.titleLabel?.font = titleNormalFont
            titleButtons.append(btn)
            btn.addTarget(self, action: #selector(didBtnClick(button:)), for: .touchUpInside)
            self.titleScrollView.addSubview(btn)

            btn.snp.makeConstraints({ (make) in
                make.top.equalTo(containView)
                make.width.equalTo(titleWidth)
                make.height.equalTo(self.height)

                if i == 0 {
                    make.left.equalTo(containView).offset(10)
                } else if 0 < i && i < titles.count - 1 {
                    make.left.equalTo(lastButton.snp.right)
                } else if i == titles.count - 1 {
                    make.left.equalTo(lastButton.snp.right)
                    make.right.equalTo(containView.snp.right)
                }
            })

            lastButton = btn
            self.selectItem(index: 0)
        }
    }

    @objc func didBtnClick(button: UIButton) {
        delegate?.didTitleButtonClick(button: button)
        self.selectItem(index: button.tag)
    }

    // 设置选中按钮的样式
    func selectItem(index: Int) {
        let btn = titleButtons[index]
        for btn in titleButtons {
            btn.setTitleColor(UIColor(valueRGB: 0x333333), for: .normal)
            btn.titleLabel?.font = titleNormalFont
        }

        btn.setTitleColor(UIColor.red, for: .normal)
        btn.titleLabel?.font = titleSelectFont

        self.scrollToRect(selectedIndex: index)
    }

    // 改变scrollview的contensize，让选中按钮的位置正确显示
    func scrollToRect(selectedIndex: Int) {
        let btn = titleButtons[selectedIndex]

        if btn.centerX < self.width*0.5 {
            self.titleScrollView.setContentOffset(.zero, animated: true)
        } else if btn.centerX > self.width*0.5 {
            if self.titleScrollView.contentSize.width - btn.centerX < 0.5*self.width {
                self.titleScrollView.setContentOffset(CGPoint.init(x: self.titleScrollView.contentSize.width - self.width, y: 0.0), animated: true)
            } else {
                self.titleScrollView.setContentOffset(CGPoint.init(x: btn.centerX - self.width * 0.5, y: 0.0), animated: true)
            }
        }
    }

    //添加子视图
    func setupSubViews() {
        self.addSubview(titleScrollView)
        self.titleScrollView.addSubview(containView)
        self.addSubview(bottomLine)

        titleScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

        containView.snp.makeConstraints { (make) in
            make.edges.equalTo(titleScrollView)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
