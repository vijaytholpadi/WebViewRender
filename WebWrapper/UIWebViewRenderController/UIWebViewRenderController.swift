//
//  UIWebViewRenderController.swift
//  WebWrapper
//
//  Created by Vijay Tholpadi on 5/6/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation
import UIKit

class UIWebViewRenderController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var urlToLoad : NSString!
    
    override func viewDidLoad() {
        let urlReqest = NSURLRequest.init(URL: NSURL.init(string: urlToLoad as String)!);
        webView.loadRequest(urlReqest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
