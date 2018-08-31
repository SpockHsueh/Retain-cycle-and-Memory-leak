//
//  DetailViewController.swift
//  Retain Cycle and Memory Leak
//
//  Created by Spoke on 2018/8/30.
//  Copyright © 2018年 Spoke. All rights reserved.
//

import UIKit

//protocol DataModelDelegate: class {
//    func didPassData(data: String)
//}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
//       weak var delegate: DataModelDelegate? {
//        didSet {
//            print("Ya")
//            print(self.delegate)
//        }
//    }
    
    var completionHandler: ((_ data: String) -> Void)?
    

    deinit {
        print("----------------------")
        print("VC2 is bring removed from memory")
    }
    
    func requestData() {
        let data = "Data from VC2"
        completionHandler?(data)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

}
