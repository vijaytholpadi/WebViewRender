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
    @IBOutlet weak var cookieStringTextView: UITextView!
    @IBOutlet weak var webViewTypeSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView(cookieStringTextView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTextView(targetTextView: UITextView) {
        targetTextView.layer.borderWidth = 1.0;
        targetTextView.layer.borderColor = UIColor.blackColor().CGColor
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
            uiwebViewRenderController.cookieStringToLoad = cookieStringTextView.text;
            self.navigationController?.pushViewController(uiwebViewRenderController, animated: true);
            break
        }
    }
}

