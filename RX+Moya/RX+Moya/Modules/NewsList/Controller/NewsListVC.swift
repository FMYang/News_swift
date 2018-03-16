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
        return view
    }()

    // MARK: - 生命周期
    convenience init(channel: String) {
        self.init()
        channelName = channel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "列表"
        
        self.setupUI()
        
        self.loadData()
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
        viewModel.getNewsList(channel: channelName, count: 10)
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
            }).disposed(by: disposeBag)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCellStyle1.reuseIdentify()) as! NewsCellStyle1
        let news = viewModel.news[indexPath.row]
        cell.bindData(model: news)        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = viewModel.news[indexPath.row]
        let detailVC = DetailVC(itemId: news.item_id, title: news.title)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

