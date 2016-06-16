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
        let requestStartTime = timeStampsRecord[(webView.request?.URL?.absoluteString)!] as! NSDate
        let elapsedSeconds = endTime.timeIntervalSinceDate(requestStartTime)
        print((webView.request?.URL?.absoluteString)! + " loaded in " + "\(elapsedSeconds)" + "\n")
    }
}
