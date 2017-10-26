//
//  ViewController.swift
//  CITextFeature
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 nsquare. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var navH:CGFloat = 0
    //MARK:you can access AppDelegate.swift's  variable
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var navigationBarH:CGFloat = 0.0
    
    var imageViewWidth:CGFloat = 0.0
    var imageViewHeight:CGFloat = 0.0
    
    var imageOriginX:CGFloat = 0.0
    var imageOriginY:CGFloat = 0.0
    
    @IBOutlet weak var imageView: UIImageView!
    //MARK:识别图中文本
    func analyseText(action: UIAlertAction) {
        let qrcodeImage = CIImage(image: imageView.image!)
        let handler = VNImageRequestHandler(ciImage:qrcodeImage!, orientation:CGImagePropertyOrientation.up)
        let request = VNDetectTextRectanglesRequest(completionHandler: { (request, error) in
            DispatchQueue.main.async {
                if let result = request.results {
                    let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.imageView!.frame.size.height)
                    let translate = CGAffineTransform.identity.scaledBy(x: self.imageView!.frame.size.width, y: self.imageView!.frame.size.height)
                    
                    //遍历所有识别结果
                    for item in result {
                        //绿色标注框
                        let textRect = UIView(frame: CGRect.zero)
                        textRect.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 0.5)
                        self.imageView!.addSubview(textRect)
                        
                        if let textObservation = item as? VNTextObservation {
                            let finalRect = textObservation.boundingBox.applying(translate).applying(transform)
                            textRect.frame = finalRect
                            //MARK:获取文本的CGRect值？？？？
                            let t = VNDetectedObjectObservation(boundingBox: finalRect)
                            print("t:\(t.boundingBox)")
                            
                        }
                    }
                }
            }
        })
        //MARK: handler 的 perform 方法要在一个独立的 DispatchQueue 中调用，否则会阻塞 UI 线程渲染
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                //MARK:VNImageRequestHandler 提供了一个 perform 方法，这个方法用来执行具体的图片识别功能
                try handler.perform([request])
            } catch {
            }
        }
    }
    
    //MARK:识别图中二维码
    func analyseTag(action: UIAlertAction) {
        let qrcodeImage = CIImage(image: imageView.image!)
        let handler = VNImageRequestHandler(ciImage:qrcodeImage!, orientation:CGImagePropertyOrientation.up)
        let request = VNDetectBarcodesRequest(completionHandler: { (request, error) in
            DispatchQueue.main.async {
                if let result = request.results {
                    for item in result {
                        if let qrcodeObservation = item as? VNBarcodeObservation{
                            if let loadString = qrcodeObservation.payloadStringValue {
                                print(loadString)
                            }
                            if let qrcode = qrcodeObservation.barcodeDescriptor {
                                print(qrcode)
                            }
                        }
                    }
                }
            }
        })
        //MARK: handler 的 perform 方法要在一个独立的 DispatchQueue 中调用，否则会阻塞 UI 线程渲染
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                //MARK:VNImageRequestHandler 提供了一个 perform 方法，这个方法用来执行具体的图片识别功能
                try handler.perform([request])
            } catch {
            }
        }
    }
    
   //MARK:面部识别
   func recognizeFace(action: UIAlertAction) {
        let faceImage = CIImage(image: imageView.image!)
        let handler = VNImageRequestHandler(ciImage:faceImage!, orientation:CGImagePropertyOrientation.up)
        
        let request = VNDetectFaceRectanglesRequest(completionHandler: { (request, error) in
            
            DispatchQueue.main.async {
                if let result = request.results {
                    print(self.imageView.image!.size.width)
                    print(self.imageView.image!.size.height)
                    let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.imageView!.frame.size.height)
                    let translate = CGAffineTransform.identity.scaledBy(x: self.imageView!.frame.size.width, y: self.imageView!.frame.size.height)

                    //遍历所有识别结果
                    for item in result {
                        //绿色标注框
                        let faceRect = UIView(frame: CGRect.zero)
                        faceRect.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 0.5)
                        self.imageView!.addSubview(faceRect)
                        
                        if let faceObservation = item as? VNFaceObservation {
                            let finalRect = faceObservation.boundingBox.applying(translate).applying(transform)
                            faceRect.frame = finalRect
                        }
                    }
                }
            }
        })
        
        //MARK: handler 的 perform 方法要在一个独立的 DispatchQueue 中调用，否则会阻塞 UI 线程渲染
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                //MARK:VNImageRequestHandler 提供了一个 perform 方法，这个方法用来执行具体的图片识别功能
                try handler.perform([request])
            } catch {
            }
        }

    }
    
    //MARK:获取面部特征
    func recognizeFaceandmarks(action: UIAlertAction) {
        let faceImage = CIImage(image: imageView.image!)
        let handler = VNImageRequestHandler(ciImage:faceImage!, orientation:CGImagePropertyOrientation.up)

        let request = VNDetectFaceLandmarksRequest(completionHandler: { (request, error) in
            DispatchQueue.main.async {
                if let result = request.results {
                    //MARK:imageViewWidth = self.imageView!.frame.size.width, imageViewHeight = self.imageView!.frame.size.height
                    let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y:-self.imageViewHeight)
                    let translate = CGAffineTransform.identity.scaledBy(x: self.imageViewWidth, y: self.imageViewHeight )
                    //遍历所有识别结果
                    for item in result {
                        if let faceObservation = item as? VNFaceObservation {
                            //MARK:finalRect这个位置是相对于view的坐标位置来定义的
                            var finalRect = faceObservation.boundingBox.applying(translate).applying(transform)
                            //MARK:imageView's image 居中 中心位置变化,则取值也要随之变化
                            finalRect.origin.x = finalRect.origin.x + self.imageOriginX
                            finalRect.origin.y = finalRect.origin.y + self.imageOriginY - self.appDelegate.statusBarHeight - self.navigationBarH
                            
                            if let allPoints = faceObservation.landmarks?.allPoints?.normalizedPoints  {
                                drawPoints(finalRect:finalRect,landmark:allPoints,translate:translate,transform:transform)
                            }
                        }
                    }
                }
            }
        })

        func drawPoints(finalRect:CGRect,landmark: [CGPoint],translate: CGAffineTransform,transform:CGAffineTransform) {
            for facePoints in landmark {
                //MARK:这个layer的框定义frame为finalRect即x,y,width,height都与这个finalRect相同
                //故下面的pointX只需要facePoints.x*finalRect.width取得相对的宽度即可，pointX是相对于layer的x,y的位置
                let layer = CAShapeLayer()
                layer.frame = finalRect
                layer.setAffineTransform(CGAffineTransform(scaleX: 1, y: -1))
                
                //MARK:这个facePoints的坐标是相对于finalRect（即面部识别区域）来定义的
                let pointX = facePoints.x * finalRect.width
                //MARK:相对于finalRect坐标，-64 ？？？ 状态栏高度+导航条高度 = 64
                let pointY = facePoints.y * finalRect.height - 64

                let circularPath = UIBezierPath(arcCenter: CGPoint.init(x: pointX,y: pointY), radius: 1, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)//定义一个圆形
                layer.path = circularPath.cgPath
                layer.fillColor = UIColor.green.cgColor
                layer.strokeColor = UIColor.green.cgColor
                self.view.layer.addSublayer(layer)
            }
        }

        //MARK: handler 的 perform 方法要在一个独立的 DispatchQueue 中调用，否则会阻塞 UI 线程渲染
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                //MARK:VNImageRequestHandler 提供了一个 perform 方法，这个方法用来执行具体的图片识别功能
                try handler.perform([request])
            } catch {
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "select", style: .plain, target: self, action:#selector(selectMenu))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        //MARK: navigationBar's height
        navigationBarH = (navigationController?.navigationBar.frame.height)!
    }

    @objc func addNewPerson() {
        self.loadView()
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            try? jpegData.write(to: imagePath)
        }
        dismiss(animated: true)
        self.imageView.image = UIImage(contentsOfFile: imagePath.path)

        //MARK:resize the UIImageView's size
        resizeImageViewSize()
    }
    
    func resizeImageViewSize() {
        let imgW = CGFloat((self.imageView.image?.size.width)!)
        let imgH = CGFloat((self.imageView.image?.size.height)!)
        let imageViewW = CGFloat(self.imageView!.frame.size.width)
        let imageViewH = CGFloat(self.imageView!.frame.size.height)
        let guide = view.safeAreaLayoutGuide
        let guideW = guide.layoutFrame.width
        let guideH = guide.layoutFrame.height
        print("width:\(imgW)")
        print("height:\(imgH)")
        print(imageViewW)
        print(imageViewH)
        print("guide:\(guide)")
        print("guideW:\(guideW)")
        print("guideH:\(guideH)")
        
        if self.imageView.image != nil {
            let ratio = imgW / imgH
            if imgW > imgH {
                let newHeight = imageViewW / ratio
                self.imageView.frame.size = CGSize(width: imageViewW, height: newHeight)
                self.imageView.frame.origin.x = CGFloat(guideW / 2) - imageViewW / 2
                self.imageView.frame.origin.y = CGFloat(guideH / 2) - newHeight / 2 + appDelegate.statusBarHeight + navigationBarH
                imageViewHeight = newHeight
                imageViewWidth = imageViewW
                
                imageOriginX = self.imageView.frame.origin.x
                imageOriginY = self.imageView.frame.origin.y
            }else{
                let newWidth = imageViewH * ratio
                self.imageView.frame.size = CGSize(width: newWidth, height: imageViewH)
                self.imageView.frame.origin.x = CGFloat(guideW / 2) - newWidth / 2
                self.imageView.frame.origin.y = CGFloat(guideH / 2) - imageViewH / 2 + appDelegate.statusBarHeight + navigationBarH
                imageViewHeight = imageViewH
                imageViewWidth = newWidth
                
                imageOriginX = self.imageView.frame.origin.x
                imageOriginY = self.imageView.frame.origin.y
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        let documentsDirectory = paths[0]
        print(documentsDirectory.absoluteURL)
        return documentsDirectory
    }

    @objc func selectMenu() {
        let uiAlertSheet = UIAlertController(title: "select a item", message: "please select a menu to execute", preferredStyle: .actionSheet)
        //MARK:Show the actionSheet, and use closure in the handler
        uiAlertSheet.addAction(UIAlertAction(title: "识别二维码", style: .default, handler:analyseTag ))
        uiAlertSheet.addAction(UIAlertAction(title: "脸部识别", style: .default, handler:recognizeFace ))
        uiAlertSheet.addAction(UIAlertAction(title: "脸部特征识别", style: .default, handler:recognizeFaceandmarks ))
        uiAlertSheet.addAction(UIAlertAction(title: "识别文本", style: .default, handler:analyseText))
        uiAlertSheet.addAction(UIAlertAction(title: "还原", style: .default, handler:reset))
        uiAlertSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler:reset))
        present(uiAlertSheet, animated: true, completion: nil)
    }

    func reset(action: UIAlertAction) {
       self.loadView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

