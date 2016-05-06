//
//  WKWebViewRenderController.swift
//  WebWrapper
//
//  Created by Vijay Tholpadi on 5/6/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WKWebViewRenderController: UIViewController {
    var urlToLoad : NSString!
    var webView : WKWebView!
    var progressView : UIProgressView!
    
    override func viewDidLoad() {
        setupWebView()
        addProgressView()
        let urlReqest = NSURLRequest.init(URL: NSURL.init(string: urlToLoad as String)!);
        webView.loadRequest(urlReqest)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(progressView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.removeFromSuperview()
    }
    
    func setupWebView() {
        webView = WKWebView.init(frame: CGRectZero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        //Setting up the constraints
        let heightConstaint = NSLayoutConstraint.init(item: webView, attribute:.Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let widthConstaint = NSLayoutConstraint.init(item: webView, attribute:.Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0)
        view.addConstraints([heightConstaint,widthConstaint])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
    //KVO callback
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            progressView.hidden = Bool(webView.estimatedProgress)
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func addProgressView() {
        progressView = UIProgressView.init(progressViewStyle: .Default)
        progressView.trackTintColor = UIColor.init(white: 1.0, alpha: 0.0)
        progressView.progressTintColor = UIColor.blueColor()
        progressView.frame = CGRectMake(0, navigationController!.navigationBar.frame.size.height - progressView.frame.size.height, view.frame.size.width, progressView.frame.size.height)
        progressView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
    }
}