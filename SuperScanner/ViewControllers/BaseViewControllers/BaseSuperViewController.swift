//
//  BaseSuperViewController.swift
//  SuperScanner
//
//  Created by Mino on 2021/5/6.
//

import Foundation
import UIKit
import SnapKit

class BaseSuperViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sLog.debug("ViewController: \(self) start init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        sLog.debug("ViewController: \(self) start deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
}
