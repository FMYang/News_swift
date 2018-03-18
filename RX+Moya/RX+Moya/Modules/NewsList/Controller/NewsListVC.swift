//
//  ViewController.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/1/7.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class NewsListVC: UIViewController {
    
    // MARK: - 属性
    let viewModel = NewsListViewModel()
    
    let disposeBag = DisposeBag()
    
    var channelName: String = ""
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.tableFooterView = UIView()
        view.estimatedRowHeight = 100
        view.register(UINib(nibName: "NewsCellStyle1", bundle: nil), forCellReuseIdentifier: NewsCellStyle1.reuseIdentify())
        view.register(UINib(nibName: "NewsCellStyle2", bundle: nil), forCellReuseIdentifier: NewsCellStyle2.reuseIdentify())
        view.register(UINib(nibName: "NewsCellStyle3", bundle: nil), forCellReuseIdentifier: NewsCellStyle3.reuseIdentify())
        return view
    }()

    // MARK: - 生命周期
    convenience init(channel: String) {
        self.init()
        channelName = channel
    }
    
    func loadData(channel: String) {
        channelName = channel
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("\(channelName) viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("\(channelName) viewWillDisappear")
        
        // 页面离开的时候保存数据
        NewsListDB.deleteAll(by: channelName) { [weak self] in
            if let strongSelf = self {
                for news in strongSelf.viewModel.news {
                    news.category = strongSelf.channelName
                }
                NewsListDB.insert(objects: strongSelf.viewModel.news)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "列表"
        
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 布局子视图
    func setupUI() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - 网络请求
    func loadData() {
        NewsListDB.getObjects(by: channelName) { [weak self] (news) in
            guard let strongSelf = self else {
                return
            }
            if let news = news {
                strongSelf.viewModel.news = news
                strongSelf.tableView.reloadData()
            }
            
            if news == nil || news?.count == 0 {
                strongSelf.viewModel.getNewsList(channel: strongSelf.channelName, count: 10)
                    .subscribe(onNext: { [weak self] (status) in
                        switch status {
                        case .success:
                            self?.tableView.reloadData()
                        case .emptyData:
                            print("emptyData")
                        case .serviceError:
                            print("serviceError")
                        case .networkLost:
                            print("networkLost")
                        case .clientError:
                            print("clientError")
                        }
                    }).disposed(by: strongSelf.disposeBag)
            }
        }
    }
}

extension NewsListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > viewModel.news.count - 1 {
            return UITableViewCell()
        }
        let news = viewModel.news[indexPath.row]
        let cell = NewsCell.tableView(tableView, cellForRowAt: indexPath, model: news)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = viewModel.news[indexPath.row]
        let detailVC = DetailVC(itemId: news.item_id, title: news.title)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

