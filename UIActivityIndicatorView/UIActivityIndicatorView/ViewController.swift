//
//  ViewController.swift
//  UIActivityIndicatorView
//
//  Created by apple on 2017/9/29.
//  Copyright © 2017年 Project10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        showActivityIndicatory(uiView: view)
    }
    
    func showActivityIndicatory(uiView: UIView) {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x:0.0, y:0.0, width:40.0, height:40.0))
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }

}

