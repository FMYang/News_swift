//
//  MainContainVC.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/17.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit
import RxSwift

class MainContainVC: UIViewController {
    
    // MARK: - 属性
    let viewModel = ChannelViewModel()
    let disposeBag = DisposeBag()
    
    lazy var channelView: ChannelView = {
        let view = ChannelView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        view.delegate = self
        return view
    }()
    
    lazy var pageVC: PageViewController = {
        let vc = PageViewController(frame: CGRect(x: 0, y: 30, width: screenWidth, height: self.view.frame.size.height-30))
        vc.datasource = self
        vc.delegate = self
        return vc
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.createImageFromColor(color: UIColor(valueRGB: 0xd43d3c)), for: UIBarMetrics.default)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.createImageFromColor(color: UIColor.white), for: UIBarMetrics.default)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "今日头条"

        self.edgesForExtendedLayout = []
        
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        let titles = viewModel.channels.flatMap() { $0.name } as [String]
        pageVC.totalPages = titles.count
        channelView.createTitleItems(titles: titles)
        view.addSubview(channelView)
        addChildViewController(pageVC)
        view.addSubview(pageVC.view)
        pageVC.didMove(toParentViewController: self)
    }
    
    // MARK: - 网络请求
    func loadData() {
        viewModel.getChannel()
            .subscribe(onNext: { [weak self] (status) in
                switch status {
                case .success:
                    self?.setupUI()
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
}

extension MainContainVC: PageViewDelegate, PageViewDatasource {
    // TODO：优化：左滑加载after 优化加载before，判断滑动方向
    func pageViewControllerDidChange(currentVC: UIViewController, beforeVC: UIViewController?, afterVC: UIViewController?, page: Int) {
        
        channelView.selectItem(index: page)

        if page < 0 || page > viewModel.channels.count {
            return
        }

        // 加载当前页
        let category = viewModel.channels[page].category
        let vc = currentVC as! NewsListVC
        vc.loadData(channel: category)

        // 预加载上一页
        if page > 0 {
            let beforeCategory = viewModel.channels[page-1].category

            if let before = beforeVC as? NewsListVC {
                before.loadData(channel: beforeCategory)
            }
        }
        
        // 预加载下一页
        let afterCategory = viewModel.channels[page+1].category
        if let after = afterVC as? NewsListVC {
            after.loadData(channel: afterCategory)
        }
    }
    
    func pageViewController() -> UIViewController {
        let vc = NewsListVC()
        return vc
    }
}

extension MainContainVC: ChannelViewDelegate {
    func didTitleButtonClick(button: UIButton) {
        pageVC.pageScrollView.setContentOffset(CGPoint(x: CGFloat(button.tag)*self.view.width, y: 0.0), animated: true)
    }
}



