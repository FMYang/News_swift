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

class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        ChannelViewModel().getChannel()

        viewModel.getNewsList(channel: "news_hot", count: 0)
            .subscribe(onNext: { (status) in
                switch status {
                case .success:
                    print("success")
                case .emptyData:
                    print("emptyData")
                case .serviceError:
                    print("serviceError")
                case .networkLost:
                    print("networkLost")
                }
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

