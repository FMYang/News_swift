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
    
    func pageViewControllerPreLoad(viewController: UIViewController?) {
        print("pageViewControllerPreLoad")
        let page = Int(viewController!.view.frame.origin.x / screenWidth)
        if let viewController = viewController as? NewsListVC {
            let channel = viewModel.channels[page]
            viewController.loadData(channel: channel.category)
        }
    }
    
    // TODO：优化：左滑加载after 优化加载before，判断滑动方向
    func pageViewControllerDidChange(currentVC: UIViewController, page: Int) {
        print("pageViewControllerDidChange")
        channelView.selectItem(index: page)

        if page < 0 || page > viewModel.channels.count {
            return
        }
        
        let category = viewModel.channels[page].category
        let vc = currentVC as! NewsListVC
        if vc.viewModel.news.count == 0 {
            vc.loadData(channel: category)
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



