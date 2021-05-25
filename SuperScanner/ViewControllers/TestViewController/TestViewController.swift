//
//  TestViewController.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/6.
//

import Foundation
import UIKit
import TZImagePickerController

class TestViewController: BaseSuperViewController {
    var dataSourceList = ["拍照", "相册", "扫描手写签名"]
    lazy var testTable: UITableView = {
        let table = UITableView.init()
        table.delegate = self
        table.dataSource = self
        //        table
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI() {
        self.view.addSubview(testTable)
        self.testTable.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func selectPhoto() {
        let vc = TestAlbmViewController.init()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func toCamera() {
        let vc = TestCameraViewController.init()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.dataSourceList[indexPath.row]
        let cell = UITableViewCell.init()
        cell.textLabel?.text = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.toCamera()
        case 1:
            self.selectPhoto()
        default:
            break
        }
    }
}

extension TestViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        guard let photo = photos.first, let data = photo.pngData() else {
            sLog.error("did not get photo data")
            return
        }
        
        OCRModel.default.ocrByBase64(dataBase64: data.base64EncodedString())
    }
}
