//
//  TestCameraViewController.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/21.
//

import Foundation
import UIKit
import CropView
import WeScan

class TestCameraViewController: BaseSuperViewController {
    lazy var imagePicker: UIImagePickerController = {
        let imgPicker = UIImagePickerController.init()
        imgPicker.sourceType = .camera
        imgPicker.delegate = self
        imgPicker.allowsEditing = false
        return imgPicker
    }()
    
    lazy var backBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("返回", for: .normal)
        btn.addTarget(self, action: #selector(backBtnTap), for: .touchUpInside)
        return btn
    }()
    
    lazy var flashLigthBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("闪光灯", for: .normal)
        btn.addTarget(self, action: #selector(onFlashTap), for: .touchUpInside)
        return btn
    }()
    
    lazy var snapshotBtn: UIButton = {
        let btn = UIButton.init()
        btn.setTitle("拍照", for: .normal)
        return btn
    }()
    
    lazy var focusIndicator: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer.init()
        return tap
    }()
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.contentMode = .scaleAspectFit
        imgView.isHidden = true
        return imgView
    }()
    
    func initUI() {
        //        self.view.addSubview(backBtn)
        //        self.view.addSubview(flashLigthBtn)
        //        self.view.addSubview(snapshotBtn)
        //        self.view.addSubview(focusIndicator)
        //        self.view.addSubview(<#T##view: UIView##UIView#>)
        self.view.addSubview(imgView)
        self.imgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    lazy var scanner: ImageScannerController = {
        let scanner = ImageScannerController.init()
        scanner.imageScannerDelegate = self
        scanner.modalPresentationStyle = .fullScreen
        return scanner
    }()
    
    @objc func backBtnTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onFlashTap() {
        
    }
    
    /// CIImage转UIImage相对简单，直接使用UIImage的初始化方法即可
    func convertCIImageToUIImage(ciImage:CIImage) -> UIImage {
        let uiImage = UIImage.init(ciImage: ciImage)
        // 注意！！！这里的uiImage的uiImage.cgImage 是nil
        let cgImage = uiImage.cgImage
        // 注意！！！上面的cgImage是nil，原因如下，官方解释
        // returns underlying CGImageRef or nil if CIImage based
        return uiImage
    }
    // CGImage转UIImage相对简单，直接使用UIImage的初始化方法即可
    // 原理同上
    func convertCIImageToUIImage(cgImage:CGImage) -> UIImage {
        let uiImage = UIImage.init(cgImage: cgImage)
        // 注意！！！这里的uiImage的uiImage.ciImage 是nil
        let ciImage = uiImage.ciImage
        // 注意！！！上面的ciImage是nil，原因如下，官方解释
        // returns underlying CIImage or nil if CGImageRef based
        return uiImage
    }
    // MARK:- convert the CGImageToCIImage
    /// convertCGImageToCIImage
    ///
    /// - Parameter cgImage: input cgImage
    /// - Returns: output CIImage
    func convertCGImageToCIImage(cgImage:CGImage) -> CIImage{
        return CIImage.init(cgImage: cgImage)
    }
    
    // MARK:- convert the CIImageToCGImage
    /// convertCIImageToCGImage
    ///
    /// - Parameter ciImage: input ciImage
    /// - Returns: output CGImage
    func convertCIImageToCGImage(ciImage:CIImage) -> CGImage{
        
        
        let ciContext = CIContext.init()
        let cgImage:CGImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        return cgImage
    }
    
    /// UIImage转为CIImage
    /// UIImage转CIImage有时候不能直接采用uiImage.ciImage获取
    /// 当uiImage.ciImage为nil的时候需要先通过uiImage.cgImage得到
    /// cgImage, 然后通过convertCGImageToCIImage将cgImage装换为ciImage
    func convertUIImageToCIImage(uiImage:UIImage) -> CIImage {
        
        var ciImage = uiImage.ciImage
        if ciImage == nil {
            let cgImage = uiImage.cgImage
            ciImage = self.convertCGImageToCIImage(cgImage: cgImage!)
        }
        return ciImage!
    }
    /// UIImage转为CGImage
    /// UIImage转CGImage有时候不能直接采用uiImage.cgImage获取
    /// 当uiImage.cgImage为nil的时候需要先通过uiImage.ciImage得到
    /// ciImage, 然后通过convertCIImageToCGImage将ciImage装换为cgImage
    func convertUIImageToCGImage(uiImage:UIImage) -> CGImage {
        var cgImage = uiImage.cgImage
        
        if cgImage == nil {
            let ciImage = uiImage.ciImage
            cgImage = self.convertCIImageToCGImage(ciImage: ciImage!)
        }
        return cgImage!
    }
    
    func doDetector(image: UIImage) {
        let image = image.fixOrientation()
        let ciImage = convertUIImageToCIImage(uiImage: image)
        
        let context = CIContext.init(options: nil)
        guard let detector = CIDetector.init(ofType: CIDetectorTypeRectangle, context: context, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else {
            sLog.error("do detector error: CIDetector error")
            return
        }
        
        let resArray = detector.features(in: ciImage)
        guard let rectangleArray = resArray as? [CIRectangleFeature] else {
            sLog.error("do detector error: CIDetector CIFeature to CIRectangleFeature error")
            return
        }
        
        guard let biggestRectangleFeature = getBiggestRectangleInRectangles(res: rectangleArray) else {
            sLog.error("do detector error: CIDetector get biggest error")
            return
        }
        
        
        
        guard let enhancedImage = correctPerspectiveForImage(image: ciImage, features: biggestRectangleFeature) else {
            sLog.error("do detector error: CIDetector correctPerspective error")
            return
        }
        
        self.imgView.isHidden = false
        self.imgView.image = image
        self.doCrop(image: image, rectangleFeature: biggestRectangleFeature, ciImage: enhancedImage)
    }
    
    func doCrop(image: UIImage, rectangleFeature: CIRectangleFeature, ciImage: CIImage) {
        let cropView = SECropView.init()
        let rect = MADCGTransfromHelper.transfromRealCIRect(inPreviewRect: self.imgView.frame, imageRect: ciImage.extent, topLeft: rectangleFeature.topLeft, topRight: rectangleFeature.topRight, bottomLeft: rectangleFeature.bottomLeft, bottomRight: rectangleFeature.bottomRight)
        cropView.configureWithCorners(corners: [rect.topLeft,rect.topRight,rect.bottomLeft,rect.bottomRight], on: self.imgView)
        
    }
    
    func getBiggestRectangleInRectangles(res: [CIRectangleFeature]) -> CIRectangleFeature? {
        if res.count <= 0 {
            return nil
        }
        
        var halfPerimiterValue: Float = 0
        var biggestRectangle = res.first
        for featur in res {
            let p1 = featur.topLeft
            let p2 = featur.topRight
            let width = hypotf(Float(p1.x - p2.x), Float(p1.y - p2.y))
            
            let p3 = featur.topLeft
            let p4 = featur.bottomLeft
            let height = hypotf(Float(p3.x - p4.x), Float(p3.y - p4.y))
            
            let currentHalfPerimiterValue = height + width
            
            if halfPerimiterValue < currentHalfPerimiterValue {
                halfPerimiterValue = currentHalfPerimiterValue
                biggestRectangle = featur
            }
        }
        return biggestRectangle
    }
    
    func correctPerspectiveForImage(image: CIImage, features: CIRectangleFeature) -> CIImage? {
        var rectangleCoordinates = [String: Any].init()
        rectangleCoordinates["inputTopLeft"] = CIVector.init(cgPoint:features.topLeft)
        rectangleCoordinates["inputTopRight"] = CIVector.init(cgPoint:features.topRight)
        rectangleCoordinates["inputBottomLeft"] = CIVector.init(cgPoint:features.bottomLeft)
        rectangleCoordinates["inputBottomRight"] = CIVector.init(cgPoint:features.bottomRight)
        
        return image.applyingFilter("CIPerspectiveCorrection", parameters: rectangleCoordinates)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.present(self.scanner, animated: true, completion: nil)
    }
}

extension TestCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = info[UIImagePickerController.InfoKey.originalImage], let img = img as? UIImage else {
            return
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
        self.doDetector(image: img)
        //        self.imgView.isHidden = false
        //        self.imgView.image = img
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let img = info[UIImagePickerController.InfoKey.originalImage.rawValue], let img = img as? UIImage else {
            return
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
        self.doDetector(image: img)
        //        self.imgView.isHidden = false
        //        self.imgView.image = img
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension TestCameraViewController: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        self.imgView.image = results.enhancedScan?.image
        self.imgView.isHidden = false
        scanner.dismiss(animated: true, completion: nil)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
    
}
