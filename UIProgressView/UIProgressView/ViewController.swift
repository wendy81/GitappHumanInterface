//
//  ViewController.swift
//  UIProgressView
//
//  Created by apple on 2017/9/29.
//  Copyright © 2017年 Project10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var progressView: UIProgressView?
    var progressLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
//        let progressView = UIProgressView(progressViewStyle: .default)
//        progressView.center = view.center
//        progressView.progress = 0.5 //默认进度50%
//        progressView.setProgress(0.8, animated:true)
//
//        progressView.progressTintColor = UIColor.blue  //已有进度颜色
//        progressView.trackTintColor = UIColor.gray  //剩余进度颜色（即进度槽颜色）
//
//        view.addSubview(progressView)
        addControls()
    }

    //MARK:- Controls
    func addControls() {
        // Create Progress View Control
        //MARK:progressViewStyle(.default or .bar)
        progressView = UIProgressView(progressViewStyle: .default)

        progressView?.center = view.center
        
        //MARK:setProgress, progress:Float   animated(true or false)
        progressView?.setProgress(0.8, animated: true)
        
        //MARK:progressView's progressImage
//        progressView?.progressImage = UIImage(named: "adventure")
        
        //MARK:progressView's trackImage
//        progressView?.trackImage = UIImage(named: "ally")
        
        view.addSubview(progressView!)
        
        // Add Label
        progressLabel = UILabel()
        let frame = CGRect(x:view.center.x - 50, y:view.center.y - 100, width:100, height:50)
        progressLabel?.frame = frame
        progressLabel?.text = "label"
        
        //MARK:progressLabel'S textAlignment
        progressLabel?.textAlignment = NSTextAlignment.center
        
        //MARK:progressLabel'S borderWidth
        progressLabel?.layer.borderWidth = 1
        
        //MARK:progressLabel'S borderColor
        progressLabel?.layer.borderColor = UIColor.red.cgColor
        
        view.addSubview(progressLabel!)
    }
}

