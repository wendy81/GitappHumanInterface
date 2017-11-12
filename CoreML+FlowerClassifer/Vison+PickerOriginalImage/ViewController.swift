//
//  ViewController.swift
//  CITextFeature
//
//  Created by apple on 2017/10/14.
//  Copyright © 2017年 nsquare. All rights reserved.
//

import UIKit
import Vision
import PromiseKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var navH:CGFloat = 0
    //MARK:you can access AppDelegate.swift's  variable
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var navigationBarH:CGFloat = 0.0
    
    var imageViewWidth:CGFloat = 0.0
    var imageViewHeight:CGFloat = 0.0
    
    var imageOriginX:CGFloat = 0.0
    var imageOriginY:CGFloat = 0.0
    //MARK:设置var sourceType: UIImagePickerControllerSourceType实例变量为摄像头
    var sourceType: UIImagePickerControllerSourceType = .camera
    
    var hasText:Bool = false
    var hasBarcodes:Bool = false
    var hasFace:Bool = false
    var hasFaceandmarks:Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    //MARK:识别图中文本
    
//    var gifView:UIImageView = nil
    
    func analyseText(from selectMenu:Bool) -> Promise<String> {
        
        return  Promise { fulfill, reject in
            
        let qrcodeImage = CIImage(image: imageView.image!)
        let handler = VNImageRequestHandler(ciImage:qrcodeImage!, orientation:CGImagePropertyOrientation.up)
        let request = VNDetectTextRectanglesRequest(completionHandler: { (request, error) in
            DispatchQueue.main.async {
                if let result = request.results {
                    
                    //MARK: if image has text, the var hasText's value is true
                    self.observeResult(result:result, target: &self.hasText)
                    //MARK: once the detection execute, then fulfill
                    fulfill("hasText")

                    let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.imageView!.frame.size.height)
                    let translate = CGAffineTransform.identity.scaledBy(x: self.imageView!.frame.size.width, y: self.imageView!.frame.size.height)
                    
                    //遍历所有识别结果
                    for item in result {
                        //绿色标注框
                        if selectMenu {
                            let maskRect = UIView(frame: CGRect.zero)
                            maskRect.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 0.5)
                            self.imageView!.addSubview(maskRect)
                        

                            if let textObservation = item as? VNTextObservation {
                                let finalRect = textObservation.boundingBox.applying(translate).applying(transform)
                                maskRect.frame = finalRect
                                //MARK:获取文本的CGRect值？？？？
                                let t = VNDetectedObjectObservation(boundingBox: finalRect)
                                print("t:\(t.boundingBox)")
                            }
                            
                        }
                    }
                }
                
                if let error = error {
                    reject(error)
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
        

    }
    
    enum IntParsingError: Error {
        case reject
    }
    
    //MARK:识别图中二维码
    func analyseTag(from selectMenu:Bool) -> Promise<String> {
        
        return  Promise { fulfill, reject in
        let qrcodeImage = CIImage(image: imageView.image!)
        let handler = VNImageRequestHandler(ciImage:qrcodeImage!, orientation:CGImagePropertyOrientation.up)
        let request = VNDetectBarcodesRequest(completionHandler: { (request, error) in
            DispatchQueue.main.async {
                if let result = request.results {
                    
                    self.observeResult(result:result, target: &self.hasBarcodes)
                    //MARK: once the detection execute, then fulfill
                    fulfill("hasBarcodes")
                    
                    for item in result {
                        if selectMenu {
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
                
                if let error = error {
                    reject(error)
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
    }
    
   //MARK:面部识别
    func recognizeFace(from selectMenu:Bool) -> Promise<String> {
        
        return  Promise { fulfill, reject in
            
        let faceImage = CIImage(image: imageView.image!)
        let handler = VNImageRequestHandler(ciImage:faceImage!, orientation:CGImagePropertyOrientation.up)
        
        let request = VNDetectFaceRectanglesRequest(completionHandler: { (request, error) in
            
            DispatchQueue.main.async {
                if let result = request.results {
                    self.observeResult(result:result, target: &self.hasFace)
                    //MARK: once the detection execute, then fulfill
                    fulfill("hasFace")
                    
                    print(self.imageView.image!.size.width)
                    print(self.imageView.image!.size.height)
                    let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -self.imageView!.frame.size.height)
                    let translate = CGAffineTransform.identity.scaledBy(x: self.imageView!.frame.size.width, y: self.imageView!.frame.size.height)

                    //遍历所有识别结果
                    for item in result {
                        if selectMenu {
                            //绿色标注框
                            let maskRect = UIView(frame: CGRect.zero)
                            maskRect.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 0.5)
                            self.imageView!.addSubview(maskRect)
                            
                            if let faceObservation = item as? VNFaceObservation {
                                let finalRect = faceObservation.boundingBox.applying(translate).applying(transform)
                                maskRect.frame = finalRect
                            }
                        }
                    }
                }
                
                if let error = error {
                    reject(error)
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

    }
    
    //MARK:获取面部特征
    func recognizeFaceandmarks(from selectMenu:Bool) -> Promise<String> {
        
        return  Promise { fulfill, reject in
            
        let faceImage = CIImage(image: imageView.image!)
        let handler = VNImageRequestHandler(ciImage:faceImage!, orientation:CGImagePropertyOrientation.up)

        let request = VNDetectFaceLandmarksRequest(completionHandler: { (request, error) in
            DispatchQueue.main.async {
                if let result = request.results {
                    self.observeResult(result:result, target: &self.hasFaceandmarks)
                    //MARK: once the detection execute, then fulfill
                    fulfill("hasFaceandmarks")
                    
                    //MARK:imageViewWidth = self.imageView!.frame.size.width, imageViewHeight = self.imageView!.frame.size.height
                    let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y:-self.imageViewHeight)
                    let translate = CGAffineTransform.identity.scaledBy(x: self.imageViewWidth, y: self.imageViewHeight )
                    //遍历所有识别结果
                    for item in result {
                        if selectMenu {
                            if let faceObservation = item as? VNFaceObservation {
                                //MARK:finalRect这个位置是相对于view的坐标位置来定义的
                                var finalRect = faceObservation.boundingBox.applying(translate).applying(transform)
                                //MARK:imageView's image 居中 中心位置变化,则取值也要随之变化
                                finalRect.origin.x = finalRect.origin.x
                                finalRect.origin.y = finalRect.origin.y
                                
                                if let allPoints = faceObservation.landmarks?.allPoints?.normalizedPoints  {
                                    drawPoints(finalRect:finalRect,landmark:allPoints,translate:translate,transform:transform)
                                }
                            }
                        }
                    }
                }
                
                if let error = error {
                    reject(error)
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
                let pointY = facePoints.y * finalRect.height

                let circularPath = UIBezierPath(arcCenter: CGPoint.init(x: pointX,y: pointY), radius: 1, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)//定义一个圆形
                layer.path = circularPath.cgPath
                layer.fillColor = UIColor.green.cgColor
                layer.strokeColor = UIColor.green.cgColor
                self.imageView.layer.addSublayer(layer)
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
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        //MARK: navigationBar's height
        navigationBarH = (navigationController?.navigationBar.frame.height)!
    }
    
    @objc func addNewPerson() {
        reset()
        let uiAlertSheet = UIAlertController(title: "select a item", message: "please select a menu to execute", preferredStyle: .actionSheet)
        //MARK:Show the actionSheet, and use closure in the handler
        uiAlertSheet.addAction(UIAlertAction(title: "照片库", style: .default, handler: { _ in
            self.addPhoto(type:UIImagePickerControllerSourceType.photoLibrary)
        }))
        uiAlertSheet.addAction(UIAlertAction(title: "相机", style: .default, handler: { _ in
            self.addPhoto(type:UIImagePickerControllerSourceType.camera)
        }))
        uiAlertSheet.addAction(UIAlertAction(title: "照片专辑", style: .default, handler: { _ in
            self.addPhoto(type:UIImagePickerControllerSourceType.savedPhotosAlbum)
        }))
        uiAlertSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        present(uiAlertSheet, animated: true, completion: nil)
    }
    
    func addPhoto(type:UIImagePickerControllerSourceType){
        self.loadView()
        let picker = UIImagePickerController()
        picker.delegate = self
        //MARK:make sure that the camera is available
        if type == UIImagePickerControllerSourceType.camera {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
            }else{
                NSLog("No Camera.")
            }
        }else if type == UIImagePickerControllerSourceType.photoLibrary{
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }else {
            picker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        }
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        //MARK:when you pick image,you should init the rightBarButtonItem,make it empty
        initRightBarButtonItem(title:"")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            try? jpegData.write(to: imagePath)
        }
        //MARK:present picker,later you should dismiss
        dismiss(animated: true)
        self.imageView.image = UIImage(contentsOfFile: imagePath.path)

        //MARK:if imageView.image has image,then show the rightBarButtonItem
        if imageView.image !== nil {
            
            //MARK:when you pick image,you should init the rightBarButtonItem,make it empty
            initRightBarButtonItem(title:"检测图片...")
            
            let picker:Bool = false
            //MARK:init
            self.hasText = false
            self.hasBarcodes = false
            self.hasFace = false
            self.hasFaceandmarks = false
            
            //MARK:auto exec all detections, when all detections have finished(either fulfilled or reject),subsequently the rightBarButtonItem "select" will show,you can select the appropriate menu to apply it.
            let promises = [analyseText(from:picker),analyseTag(from:picker),recognizeFace(from:picker),recognizeFaceandmarks(from:picker)]
            //MARK: all promises fulfilled, then you can get the result(it's a array,the value is fulfill's result) ["success","success",....]
            when(fulfilled:promises).then { result -> () in
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "选择", style: .plain, target: self, action:#selector(self.selectMenu))
            }
        }
        //MARK:resize the UIImageView's size
        resizeImageViewSize()
    }
    
    func initRightBarButtonItem(title:String) {
        //MARK:when you pick image,you should init the rightBarButtonItem,make it empty
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action:nil)
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
        //MARK: if imageview has maskRect or layer,you select menu to remove them, then show the new effect
        self.reset()

        let uiAlertSheet = UIAlertController(title: "select a item", message: "please select a menu to execute", preferredStyle: .actionSheet)
        //MARK:Show the actionSheet, and use closure in the handler
        let selectMenu:Bool = true
        if self.hasFace {
            uiAlertSheet.addAction(UIAlertAction(title: "脸部识别", style: .default, handler: { _ in
                let type = "face"
                self.addEvent(type: type, selectMenu:selectMenu)
            }))
        }
        if self.hasFaceandmarks {
            uiAlertSheet.addAction(UIAlertAction(title: "脸部特征识别", style: .default, handler: { _ in
                let type = "faceandmarks"
                self.addEvent(type: type, selectMenu:selectMenu)
            }))
        }
        if self.hasBarcodes {
            uiAlertSheet.addAction(UIAlertAction(title: "识别二维码", style: .default, handler: { _ in
                let type = "barCode"
                self.addEvent(type: type, selectMenu:selectMenu)
            }))
        }
  
        if self.hasText {
            uiAlertSheet.addAction(UIAlertAction(title: "识别文本", style: .default, handler: { _ in
                let type = "text"
                self.addEvent(type: type, selectMenu:selectMenu)
            }))
        }

        uiAlertSheet.addAction(UIAlertAction(title: "取消", style: .cancel,  handler: nil))
        present(uiAlertSheet, animated: true, completion: nil)
    }
    
    func addEvent(type:String, selectMenu:Bool) {
        switch type {
        case "barCode":
            self.analyseTag(from:selectMenu).then{ result -> () in }
        case "face":
            self.recognizeFace(from:selectMenu).then{ result -> () in }
        case "faceandmarks":
            self.recognizeFaceandmarks(from:selectMenu).then{ result -> () in }
        case "text":
            self.analyseText(from:selectMenu).then{ result -> () in }
        default: break
        }
    }

    func reset() {
        //MARK: if imageview has maskRect or layer,you select menu to remove them, then show the new effect
        let subviews = self.imageView.subviews
        for subview in subviews {
            if subview.superview !== nil {
                subview.removeFromSuperview()
            }
        }
        if let sublayers = self.imageView.layer.sublayers {
            for sublayer in sublayers {
                if sublayer.superlayer !== nil {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func observeResult(result:[Any],target: inout Bool){
        let resultCount = result.count
        if resultCount > 0 {
            target = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

