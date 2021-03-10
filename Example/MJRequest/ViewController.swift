//
//  ViewController.swift
//  MJRequest
//
//  Created by chenminjie92@126.com on 03/10/2021.
//  Copyright (c) 2021 chenminjie92@126.com. All rights reserved.
//

import UIKit
import MJRequest

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button: UIButton = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        view.addSubview(button)
        MJRequestManager.plugins = [MJRequetHeaderPlugin.init(headerClosure: { () -> [String : String] in
            return ["token": "123"]
        })]
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func buttonClick() {
        WeatherAPI.getJoke(for: 1, count: 2, type: "video") { (result) in
            switch result {
            case .success(let data):
                print(data as Any)
            case .failure(let error):
                print(error.msg)
            }
        }
    }
}

