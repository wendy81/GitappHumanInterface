//
//  ViewController.swift
//  UIAlertController
//
//  Created by apple on 2017/10/2.
//  Copyright © 2017年 Project10. All rights reserved.
//

import UIKit
//UIAlertController var actions: [UIAlertAction] property:
//sheet.actions   show all UIAlertActions
//[ <UIAlertAction: 0x1c0302640 Title = "Common" Descriptive = "(null)" Image = 0x0>, <UIAlertAction: 0x1c0302520 Title = "Custom" Descriptive = "(null)" Image = 0x0>, <UIAlertAction: 0x1c0302880 Title = "Closure1" Descriptive = "(null)" Image = 0x0>, <UIAlertAction: 0x1c0302490 Title = "Closure2" Descriptive = "(null)" Image = 0x0>, <UIAlertAction: 0x1c03027f0 Title = "Cancle" Descriptive = "(null)" Image = 0x0>]

class ViewController: UIViewController {

    @IBOutlet weak var showInfo: UILabel!
    
    @IBAction func showAlertButton(_ sender: UIButton) {
        alert()
    }
    
    @IBAction func showSheetButton(_ sender: UIButton) {
        sheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func alert() {
        let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
        
        //MARK:Show the alert, and use closure in the handler
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancle", comment: "Default action"), style: .cancel, handler: { _ in
            self.showInfo.text = "The \"Cancle\" alert occured."
            NSLog("The \"Cancle\" alert occured.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            self.showInfo.text = "The \"OK\" alert occured."
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func sheet() {
        let sheet = UIAlertController(title: "My Sheet", message: "This is a sheet.", preferredStyle:.actionSheet)
        
        //MARK:Show the actionSheet, and use closure in the handler
        sheet.addAction(UIAlertAction(title: "Common", style: .default, handler: { _ in
            self.showInfo.text = "The \"Common\" sheet occured."
            NSLog("The \"Sheet 1\" sheet occured.")
        }))
        
        //MARK:Show the actionSheet, and use custom func in the handler
        sheet.addAction(UIAlertAction(title: NSLocalizedString("Custom", comment: "Custom action"), style: .`default`, handler:customSheet))
        
        //MARK:Show the actionSheet, and use closure in the handler
        let actionClosure1 = UIAlertAction(title: NSLocalizedString("Closure1", comment: "Custom action"), style: .`default`, handler:{ _ in
            self.showInfo.text = "The \"Closure1\" sheet occured."
        })
        sheet.addAction(actionClosure1)
        
        //MARK:Show the actionSheet, and use tailing closure in the handler
        let actionClosure2 = UIAlertAction(title: NSLocalizedString("Closure2", comment: "Custom action"), style: .`default`){ _ in
            self.showInfo.text = "The \"Closure2\" sheet occured."
        }
        sheet.addAction(actionClosure2)
    
        sheet.addAction(UIAlertAction(title: NSLocalizedString("Cancle", comment: "Default action"), style: .cancel, handler: { _ in
            self.showInfo.text = "The \"Cancle\" sheet occured."
            NSLog("The \"Cancle\" sheet occured.")
        }))
        self.present(sheet, animated: true, completion: nil)
    }
    
    
    func customSheet(action:UIAlertAction) {
        self.showInfo.text = "The \"Custom\" sheet occured."
        NSLog("The \"Custom\" sheet occured.")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

