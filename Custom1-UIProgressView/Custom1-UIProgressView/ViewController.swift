//
//  ViewController.swift
//  Custom1-UIProgressView
//
//  Created by apple on 2017/9/29.
//  Copyright © 2017年 Project10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBarView: UIProgressView!
    var progressBarTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progressBarTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(updateProgressBar), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateProgressBar(){
        //MARK:下面把progressBarView从父视图删除掉后，就不存在了，这里必须确定在progressBarView存在的情况下执行
        //否则为报错:unexpectedly found nil while unwrapping an Optional value
        if (progressBarView != nil) {
            progressBarView.progress += 0.1
            if(progressBarView.progress == 1.0)
            {
                if (progressBarView.superview != nil) {
                    //MARK:Unlinks the receiver from its superview and its window, and removes it from the responder chain.
                    progressBarView.removeFromSuperview()
                }
            }
        }
    }
    
}

