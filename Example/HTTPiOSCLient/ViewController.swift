//
//  ViewController.swift
//  HTTPiOSCLient
//
//  Created by caggiulio on 11/14/2020.
//  Copyright (c) 2020 caggiulio. All rights reserved.
//

import UIKit
import HTTPiOSCLient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Falcon.request(url: "todos/1", method: .get) { (result) in
            switch result {
            case let .success(response): print(response.json)
                case let .error(response, error): break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

