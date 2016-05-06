//
//  ViewController.swift
//  WebWrapper
//
//  Created by Vijay Tholpadi on 5/6/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var hostnameTextField: UITextField!
    @IBOutlet weak var webViewTypeSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func renderButtonPressed(sender: AnyObject) {
        switch webViewTypeSwitch.on {
        case true:
            let wkwebViewRenderController =  storyboard?.instantiateViewControllerWithIdentifier("WKWebViewRenderController") as! WKWebViewRenderController
            wkwebViewRenderController.urlToLoad = hostnameTextField.text
            self.navigationController?.pushViewController(wkwebViewRenderController, animated: true);
            break
        case false:
            let uiwebViewRenderController =  storyboard?.instantiateViewControllerWithIdentifier("UIWebViewRenderController") as! UIWebViewRenderController
            uiwebViewRenderController.urlToLoad = hostnameTextField.text
            self.navigationController?.pushViewController(uiwebViewRenderController, animated: true);
            break
        }
    }
}

