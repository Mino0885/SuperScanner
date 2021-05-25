//
//  TestAlbmViewController.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/24.
//

import Foundation
import UIKit
import TZImagePickerController
import WeScan
import LBXPermission

class TestAlbmViewController: BaseSuperViewController {
    lazy var imgView: UIImageView = {
        let imgView = UIImageView.init()
        imgView.contentMode = .scaleAspectFit
        imgView.isHidden = true
        let tap = UILongPressGestureRecognizer.init()
        tap.minimumPressDuration = 0.5
        tap.addTarget(self, action: #selector(imgLongTap))
        imgView.addGestureRecognizer(tap)
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    func initUI() {
        self.view.addSubview(imgView)
        self.imgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.selectPhoto()
    }
    
    @objc func imgLongTap() {
        LBXPermission.authorize(with: .photos) { granted, isFirst in
            if granted {
                sLog.verbose("photos is granted")
                self.imgView.image?.saveImage(completionHandler: nil)
            }
        }
    }
    
    func selectPhoto() {
        let imgPicker = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
        imgPicker?.allowTakePicture = false
        imgPicker?.allowTakeVideo = false
        imgPicker?.allowPickingOriginalPhoto = false
        imgPicker?.allowPickingVideo = false
        imgPicker?.showPhotoCannotSelectLayer = true
        //        imgPicker?.cannotSelectLayerColor = UIColor.init(hex: "#FFFFFF", alpha: 0.8)
        
        imgPicker?.photoDefImage = UIImage.init(named: "photoDef")
        imgPicker?.photoSelImage = UIImage.init(named: "photoSelect")
        imgPicker?.allowCrop = false
        
        let widthHeight = Int(UIScreen.main.bounds.width - 30)
        let left = (Int(self.view.tz_width) - widthHeight) / 2
        let top = (Int(UIScreen.main.bounds.height) - widthHeight) / 2
        imgPicker?.cropRect = CGRect.init(x: Int(left), y: top, width: widthHeight, height: widthHeight)
        imgPicker?.scaleAspectFillCrop = true
        
        imgPicker?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        imgPicker?.navigationBar.tintColor = UIColor.black
        imgPicker?.naviBgColor = UIColor.white
        imgPicker?.barItemTextColor = UIColor.black
        imgPicker?.navigationBar.isTranslucent = false
        if let imgPicker = imgPicker {
            imgPicker.modalPresentationStyle = .fullScreen
            self.present(imgPicker, animated: true, completion: nil)
        }
    }
}

extension TestAlbmViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        picker.dismiss(animated: true, completion: nil)
        guard let photo = photos.first, let data = photo.pngData() else {
            sLog.error("did not get photo data")
            return
        }
        let scaner = ImageScannerController.init(image: photo, delegate: self)
        scaner.modalPresentationStyle = .fullScreen
        self.present(scaner, animated: true, completion: nil)
        //        OCRModel.default.ocrByBase64(dataBase64: data.base64EncodedString())
    }
}

extension TestAlbmViewController: ImageScannerControllerDelegate {
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
