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

class WKWebViewRenderController: UIViewController, WKNavigationDelegate {
    var urlToLoad : String!
    var webView : WKWebView!
    var progressView : UIProgressView!
    var timeStampsRecord: [String : AnyObject]!

    override func viewDidLoad() {
        setupWebView()
        addProgressView()
        setupNavigationBarButtons()
        timeStampsRecord = Dictionary()
        let urlRequest = NSURLRequest.init(URL: NSURL.init(string: urlToLoad as String)!);
        webView.loadRequest(urlRequest)
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
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
        webView.navigationDelegate = self;
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        //Setting up the constraints
        let heightConstaint = NSLayoutConstraint.init(item: webView, attribute:.Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0.0)
        let widthConstaint = NSLayoutConstraint.init(item: webView, attribute:.Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0)
        view.addConstraints([heightConstaint,widthConstaint])
    }
    
    func setupNavigationBarButtons() {
        let backbutton = UIBarButtonItem.init(title: "Back", style: .Plain, target: self, action: #selector(WKWebViewRenderController.backButtonPressed));
        self.navigationItem.leftBarButtonItem = backbutton;
    }
    
    func backButtonPressed() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        webView.navigationDelegate = nil
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

//pragma mark - WKNavigationDelegate methods
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let startTime = NSDate()
        let urlString = navigationAction.request.URL?.absoluteString
        timeStampsRecord[urlString!] = startTime
        decisionHandler(.Allow)
    }

    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        let endTime = NSDate()
        let requestStartTime = timeStampsRecord[(navigationResponse.response.URL?.absoluteString)!] as! NSDate
        let elapsedSeconds = endTime.timeIntervalSinceDate(requestStartTime)
        print((navigationResponse.response.URL?.absoluteString)! + " loaded in " + "\(elapsedSeconds)" + "\n")
        decisionHandler(.Allow)
    }
}