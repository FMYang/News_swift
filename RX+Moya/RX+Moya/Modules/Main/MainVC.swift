//
//  MainVC.swift
//  RX+Moya
//
//  Created by 杨方明 on 2018/3/12.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class MainVC: UIViewController {
    
    // MARK: - 属性
    let viewModel = ChannelViewModel()
    let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.tableFooterView = UIView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()

    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "头条"
        
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
        viewModel.getChannel()
            .subscribe(onNext: { [weak self] (status) in
                switch status {
                case .success:
                    self?.tableView.reloadData()
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let channel = viewModel.channels[indexPath.row]
        cell.textLabel?.text = channel.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = viewModel.channels[indexPath.row]
        let vc = NewsListVC(channel: channel.category)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
