//
//  ViewController.swift
//  Custom1-UIActivityIndicatorView
//
//  Created by apple on 2017/9/29.
//  Copyright © 2017年 Project10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicatory(uiView: view)
    }

    func showActivityIndicatory(uiView: UIView) {
        let container: UIView = UIView()
        
        //MARK:describes the view’s location and size in its superview’s coordinate system.
        container.frame = uiView.frame
        
        //MARK:The center point of the view's frame rectangle.
        container.center = uiView.center
        
        container.backgroundColor = UIColor(red:0.0,green: 0.0, blue: 0.0,alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x:0, y:0, width:80, height:80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red:0.0,green: 0.0, blue: 0.0,alpha: 0.7)
        
        //MARK:all subviews of the loadingView which is clipped
        loadingView.clipsToBounds = true
        
        //MARK:loadingView's corners are 10
        loadingView.layer.cornerRadius = 10
        
        //MARK:A view that shows that a task is in progress.
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        
        actInd.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x:loadingView.frame.size.width / 2,
                                y:loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }


}

