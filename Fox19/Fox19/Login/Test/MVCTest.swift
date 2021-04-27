//
//  MVCTest.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 10.11.2020.
//

import UIKit

class MVCTest: UIViewController {
    var myview = TestView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view = myview
    }
}
