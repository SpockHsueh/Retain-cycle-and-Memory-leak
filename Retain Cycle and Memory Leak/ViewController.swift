//
//  ViewController.swift
//  Retain Cycle and Memory Leak
//
//  Created by Spoke on 2018/8/30.
//  Copyright © 2018年 Spoke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var detailVC: DetailViewController? = DetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func pressed(_ sender: Any) {
//        self.detailVC = nil
        detailVC?.requestData()

        detailVC?.completionHandler = { (data) in
            print(data)
        }

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VC3")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = viewController
    }
    


}





