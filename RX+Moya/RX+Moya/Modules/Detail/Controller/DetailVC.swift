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

    var htmlTitle: String = ""
    
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
    convenience init(itemId: Int, title: String) {
        self.init()
        newId = itemId
        htmlTitle = title
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
        let title = "<h3 text-align:left;font-size:18;font-weight:bold;color:#333333;margin-bottom:5px>\(htmlTitle)</h3>"
        var html = "<html>" + "<body style=font-size:18px;letter-spacing:2px;word-spacing:5px;text-align:justify;overflow:hidden;margin:10px 10px;word-break:break-all>" + title + content +  "</body>" + "</html>"
        self.replaceAllImgTag(html: &html)
        detailWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }

    func replaceAllImgTag(html: inout String) {
        do {
            if let start = html.range(of: "<header>"), let end = html.range(of: "</header>") {                html = html.replacingCharacters(in: start.lowerBound..<end.lowerBound, with: "")
            }
            
            // 获取所有a标签
            let regularExpression = "<a\\b[^>]*\\bhref\\s*=\\s*(\"[^\"]*\"|'[^']*')[^>]*>((?:(?!</a).)*)</a\\s*>"
            let regular = try NSRegularExpression(pattern: regularExpression, options: [])
            let result: [NSTextCheckingResult] = regular.matches(in: html, options: [], range: NSRange(location: 0, length: html.count))

            var aTags: [String] = []
            for x in result {
                let startIndex = html.index(html.startIndex, offsetBy: x.range.location)
                let endIndex = html.index(startIndex, offsetBy: x.range.length)
                let aTag = html[startIndex..<endIndex]
                aTags.append(String(aTag))
            }
            
            // 占位图替换为可显示的<img>标签
            if let images = viewModel.detail?.image_detail {
                for image in images {
                    for tag in aTags {
                        let src = image.uri.replacingOccurrences(of: "/", with: "%2F")

                        if tag.contains(src) {
                            let newTag = "<p style=\"text-align:center\"><img src=\(image.url) width = \(image.width) height = \(image.height)></p>"
                            html = html.replacingOccurrences(of: tag, with: newTag)
                        }
                    }
                }
            }
            
        } catch {
            print(error)
        }
    }
}
