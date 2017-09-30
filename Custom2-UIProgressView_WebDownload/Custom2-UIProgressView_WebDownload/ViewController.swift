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
    
    var progressView: UIProgressView!
    var webView: WKWebView!
    
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
        
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
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

    @objc func fetchWKWebViewEstimatedProgress() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
 
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
    
}
