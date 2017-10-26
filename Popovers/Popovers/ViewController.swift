//
//  ViewController.swift
//  Popovers
//
//  Created by apple on 2017/10/2.
//  Copyright © 2017年 Project10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(displayOptionsForSelectedItem))
    }
    
    @objc func displayOptionsForSelectedItem() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let optionsVC = storyboard.instantiateViewController(
            withIdentifier: "itemOptionsViewController")
        optionsVC.modalPresentationStyle = .popover
        optionsVC.preferredContentSize = CGSize(width: 200, height: 400)

        let popoverPresentationController = optionsVC.popoverPresentationController
        //????
        popoverPresentationController?.sourceView = view
        popoverPresentationController?.sourceRect = CGRect(x: view.frame.width - 105, y: 0, width: 100, height: 100)
        //????
        popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
         present(optionsVC, animated: true, completion: nil)
    }
    
    @objc func t() {
        NSLog("close")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

