//
//  ViewController.swift
//  Custom2-UIProgressView_WebDownload
//
//  Created by apple on 2017/9/30.
//  Copyright © 2017年 Project10. All rights reserved.
//

import UIKit
import WebKit

//MARK:WKUIDelegate protocol to track the loading of web content
//MARK:WKNavigationDelegate protocol to track the navigation of web
class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    //declare this property where it won't go out of scope relative to your listener
    let reachability = Reachability()!
    
    var progressView: UIProgressView!
    var webView: WKWebView!
    var networdState:Reachability.Connection = .wifi
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self

        //MARK:means "when any web page navigation happens, please tell me."
        webView.navigationDelegate = self
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Apple"
        
        //MARK:load the url request
        self.reachabilityState()

        //MARK:horizontal swipe gestures will trigger back-forward list navigations.
        webView.allowsBackForwardNavigationGestures = true
        
        //MARK:we want to set progress to match our webView's estimatedProgress value
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.tag = 10
        progressView.frame = CGRect(x:0.0,y:self.navigationController!.navigationBar.frame.height - 2,width:self.navigationController!.navigationBar.frame.width,height:2)
        navigationController?.navigationBar.addSubview(progressView)
        
        //MARK:inBackground Load WKWebView estimatedProgress
         performSelector(inBackground: #selector(fetchWKWebViewUrlIsChanged), with: nil)
         performSelector(inBackground: #selector(fetchWKWebViewEstimatedProgress), with: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            networdState = .wifi
        case .cellular:
            print("Reachable via Cellular")
            //self.reachabilityCellular()
            networdState = .cellular
        case .none:
            print("Network not reachable")
            networdState = .none
            self.reachabilityNone()
        }
    }
    
    //MARK:load the url request
    func loadRequest() {
        let hostName:String? = "https://www.apple.com"
        let myURL = URL(string: hostName!)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
      //MARK:networdState = .cellular, click on the "ok" button,invoke loadData
//    func loadData(action:UIAlertAction) {
//        loadRequest()
//    }

    //MARK:the reachability isn't  none, then app invoke loadRequest
    func reachabilityState() {
        if (networdState != .none) {
            loadRequest()
        }
    }
    
    //MARK:webView addObserver  to get the estimatedProgress
    @objc func fetchWKWebViewEstimatedProgress() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    //MARK:webView addObserver  to get the current url address, init page is not this url value,if you click on some "new link" ,it works! that's,if you click on "current link",it doesn't work!
    @objc func fetchWKWebViewUrlIsChanged() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "URL" {
            //MARK:只有url更新后，keyPath的值才会变成"URL",如果当前的url链接没有改变，则不会observe到keyPath == "URL"
            //let progressUrl = webView.url!
            navigationController?.navigationBar.addSubview(progressView)
        }
        if keyPath == "estimatedProgress" {
            let progressValue:Float = Float(webView.estimatedProgress)
            progressView.setProgress(progressValue, animated: false)
            
            //MARK:removeProgressView from superview when progress loaded
            removeProgressView(when:progressValue)
        }
    }
    

    //MARK:removeProgressView from superview when progress loaded
    func removeProgressView(when finishedVal:Float) {
        if (progressView != nil) {
            if(finishedVal == 1.0) {
                if (progressView.superview != nil) {
                    //MARK:Unlinks the receiver from its superview and its window, and removes it from the responder chain.
                    progressView.removeFromSuperview()
                }
            }
        }
    }
    
    //MARKS:ERROR  When the navigation occured.
//    func reachabilityCellular() {
//        let alert = UIAlertController(title: "网络不是WIFI", message: "网络不是WIFI,确定继续吗？", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: loadData))
//        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
    
    
//    prefs:root=ACCOUNT_SETTINGS
    
    func reachabilityNone() {
        let alert = UIAlertController(title: "网络没有连接", message: "请设置网络连接,重新运行app", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "去设置", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alert.addAction(settingsAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARKS:Release the memory.
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}
