//
//  PageViewController.swift
//  PageViewController
//
//  Created by 杨方明 on 2018/3/16.
//  Copyright © 2018年 杨方明. All rights reserved.
//
//  横向重用的翻页控件，实现原理参考UITableView
//  TODO: 代理命名改为和tableviewDelgate的一样，重用的时候根据标识符重用VC，防止类型错误
//

import UIKit

enum PageViewScrollDiretion {
    case left
    case right
}

// 数据源代理
protocol PageViewDatasource: class {
    func pageViewController() -> UIViewController
}

protocol PageViewDelegate: class {
    // 页面切换完成
    func pageViewControllerDidChange(currentVC: UIViewController, page: Int)

    // 预加载viewController
    func pageViewControllerPreLoad(viewController: UIViewController, page: Int)

    // scrollView滑动代理
    func pageViewControllerScrollDidScroller(_ scrollView: UIScrollView, page: Int)
}

class PageViewController: UIViewController {

    weak var datasource: PageViewDatasource?
    weak var delegate: PageViewDelegate?
    var direction: PageViewScrollDiretion = .right
    var reuseViewControllers = [UIViewController]()
    var visibleViewController = [UIViewController]()
    var currentPage: Int = -1
    var viewFrame: CGRect = .zero

    var totalPages = 10 {
        willSet {
            pageScrollView.contentSize = CGSize(width: CGFloat(newValue) * viewFrame.size.width, height: viewFrame.size.height)
        }
    }

    lazy var pageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .lightGray
        view.isPagingEnabled = true
        view.delegate = self
        return view
    }()

    convenience init(frame: CGRect) {
        self.init()
        viewFrame = frame
    }

    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = []

        self.view.frame = viewFrame
        pageScrollView.frame = CGRect(x: 0, y: 0, width: viewFrame.size.width, height: viewFrame.size.height)
        pageScrollView.contentSize = CGSize(width: CGFloat(totalPages) * viewFrame.size.width, height: viewFrame.size.height)
        self.view.addSubview(pageScrollView)
        self.loadPage(page: 0)

        // 首次加载，预加载第二页的内容
        if self.currentPage == 0 {
            self.pageDidChange(page: 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadPage(page: Int) {
        assert(datasource != nil, "datasource can not be nil")

        if self.currentPage == page { return }
        self.currentPage = page

        // 当前屏幕显示的Frame集合
        var pagesFrames = [viewFrame.size.width * CGFloat(page), viewFrame.size.width * CGFloat(page-1),  viewFrame.size.width * CGFloat(page+1)]

        // 记录滑出屏幕的VC，加入队列，稍后删除
        var vcsToEnqueue = [UIViewController]()

        // 遍历当前容器可用的vc
        for vc in visibleViewController {
            // 如果vc是第一次创建的，或者移出当前屏幕
            if vc.view.frame.origin.x == 0 || !pagesFrames.contains(vc.view.frame.origin.x) {
                // 找到离开屏幕的vc
                vcsToEnqueue.append(vc)
            } else {
                // 保留不在容器显示vc
                pagesFrames.remove(vc.view.frame.origin.x)
            }
        }

        // 将离开屏幕的vc从父视图移除，并加入重用池
        for vc in vcsToEnqueue {
            // 将要移除
            vc.view.removeFromSuperview()
            visibleViewController.remove(vc)
            reuseViewControllers.append(vc)
        }

        // 不在容器VC，添加到容器
        for originX in pagesFrames {
            self.addChildViewController(page: Int(originX/viewFrame.size.width))
        }
    }

    // 加入容器并设置frame
    func addChildViewController(page: Int) {
        if page < 0 || page > totalPages-1 { return }
        let vc = self.dequeueReuseViewController(page: page)
        vc.view.frame = CGRect(x: viewFrame.size.width * CGFloat(page), y: 0, width: viewFrame.size.width, height: viewFrame.size.height)

        // 视图将要显示
        pageScrollView.addSubview(vc.view)
        visibleViewController.append(vc)
    }

    // 重用VC
    func dequeueReuseViewController(page: Int) -> UIViewController {
        // 获取重用池的第一个VC
        if let vc = reuseViewControllers.first {
            reuseViewControllers.remove(vc)
            return vc
        }

        // 没有可重用的VC就调用Datasource方法创建一个新的VC
        let vc = datasource!.pageViewController()

        vc.willMove(toParentViewController: self)
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)

        return vc
    }
}

extension PageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var page = Int(roundf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
        page = max(page, 0)
        page = min(page, totalPages-1)
        delegate?.pageViewControllerScrollDidScroller(scrollView, page: page)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == pageScrollView {
            if scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width {
                return
            }
            var page = Int(roundf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
            page = max(page, 0)
            page = min(page, totalPages-1)
            self.loadPage(page: page)

            self.pageDidChange(page: page)
        }
    }

    // 跳页和快速滑动情况处理
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == pageScrollView {
            if scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width {
                return
            }
            var page = Int(roundf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
            page = max(page, 0)
            page = min(page, totalPages-1)
            self.loadPage(page: page)

            self.pageDidChange(page: page)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x > 0 {
            direction = .right
        } else {
            direction = .left
        }
    }

    // 获取容器中的VC，前一个、当前、后一个VC
    func pageDidChange(page: Int) {
        for vc in visibleViewController {
            if vc.view.frame.origin.x == pageScrollView.contentOffset.x {
                let (beforeVC, afterVC) = self.getBeforAndAfterVC(currentVC: vc)
                if direction == .left {
                    if let vc = beforeVC {
                        let page = Int(vc.view.frame.origin.x / viewFrame.size.width)
                        delegate?.pageViewControllerPreLoad(viewController: vc, page: page)
                    }
                } else {
                    if let vc = afterVC {
                        let page = Int(vc.view.frame.origin.x / viewFrame.size.width)
                        delegate?.pageViewControllerPreLoad(viewController: vc, page: page)
                    }
                }
                delegate?.pageViewControllerDidChange(currentVC: vc, page: page)
                break
            }
        }
    }

    // 获取前面和后面的VC
    func getBeforAndAfterVC(currentVC: UIViewController) -> (UIViewController?, UIViewController?) {
        var beforeVC: UIViewController?
        var afterVC: UIViewController?

        for vc in visibleViewController {
            if currentVC.view.frame.origin.x  > vc.view.frame.origin.x  {
                beforeVC = vc
            } else if currentVC.view.frame.origin.x  < vc.view.frame.origin.x  {
                afterVC = vc
            }
        }
        return (beforeVC, afterVC)
    }
}

extension Array where Element: Equatable {
    // 根据值从数组删除对象
    mutating func remove(_ object: Element) {
        self = self.filter() { $0 != object }
    }
}

