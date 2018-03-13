//
//  DetailVC.swift
//  RX+Moya
//
//  Created by yfm on 2018/3/13.
//  Copyright © 2018年 杨方明. All rights reserved.
//

import UIKit
import RxSwift
import WebKit

class DetailVC: UIViewController {

    // MARK: - 属性
    let viewModel = DetailViewModel()

    let disposeBag = DisposeBag()

    var newId: Int = 0

    lazy var detailWebView: WKWebView = {
        // 解决wk字体太小问题，通过设置configuration参数，适应css字体大小
        let jsScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUScript = WKUserScript(source: jsScript, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        let config = WKWebViewConfiguration()
        config.userContentController = wkUController

        let view = WKWebView.init(frame: .zero, configuration: config)
        view.backgroundColor = .white

        return view
    }()

    // MARK: - 生命周期
    convenience init(itemId: Int) {
        self.init()
        newId = itemId
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.setupUI()

        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - 功能
    func setupUI() {
        self.view.addSubview(detailWebView)
        detailWebView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func loadData() {
        viewModel.getDetail(newId: newId)
            .subscribe(onNext: { [weak self] (status) in
                switch status {
                case .success:
                    self?.loadHtml(content: self?.viewModel.detail?.content ?? "")
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

    func loadHtml(content: String) {
        let html = "<html>" + content + "</html>"
        self.replaceAllImgMark(html: html)
        detailWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }

    func replaceAllImgMark(html: String) {
        do {
            let regularExpression = "<a\\b[^>]*\\bhref\\s*=\\s*(\"[^\"]*\"|'[^']*')[^>]*>((?:(?!</a).)*)</a\\s*>"
            let regular = try NSRegularExpression(pattern: regularExpression, options: [])
            let result: [NSTextCheckingResult] = regular.matches(in: html, options: [], range: NSRange(location: 0, length: html.count))

            for x in result {
                let startIndex = html.index(html.startIndex, offsetBy: x.range.location)
                let endIndex = html.index(startIndex, offsetBy: x.range.length)
                print(html[startIndex..<endIndex])
            }
        } catch {
            print(error)
        }
    }
}
