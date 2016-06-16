//
//  UIWebViewRenderController.swift
//  WebWrapper
//
//  Created by Vijay Tholpadi on 5/6/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation
import UIKit

class UIWebViewRenderController: UIViewController , UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    var urlToLoad : String!
    var timeStampsRecord: [String : AnyObject]!

    override func viewDidLoad() {
//        NSURLCache.sharedURLCache().removeAllCachedResponses()
        timeStampsRecord = Dictionary()
        setupNavigationBarButtons()
        webView.delegate = self
        let urlReqest = NSURLRequest.init(URL: NSURL.init(string: urlToLoad as String)!);
        webView.loadRequest(urlReqest)
    }

    deinit {
        webView.delegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    //Pragma mark - UIWebViewDelegate methods
    internal func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let startTime = NSDate()
        let urlString = request.URL?.absoluteString
        timeStampsRecord[urlString!] = startTime
        return true
    }

    internal func webViewDidStartLoad(webView: UIWebView) {

    }

    internal func webViewDidFinishLoad(webView: UIWebView) {
        let endTime = NSDate()
        if (webView.stringByEvaluatingJavaScriptFromString("document.readyState") == "complete") {
            if let urlString = (webView.request?.URL?.absoluteString) where urlString != "" {
                let requestStartTime = timeStampsRecord[urlString] as! NSDate
                let elapsedSeconds = endTime.timeIntervalSinceDate(requestStartTime)
                AppDelegate.showToastWithText((webView.request?.URL?.absoluteString)! + " loaded in " + "\(elapsedSeconds)" + " secs")
            }
        }
    }
}