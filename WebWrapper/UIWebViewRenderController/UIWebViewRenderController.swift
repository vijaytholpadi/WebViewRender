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
    var cookieStringToLoad : String!
    var timeStampsRecord: [String : AnyObject]!

    override func viewDidLoad() {
//        NSURLCache.sharedURLCache().removeAllCachedResponses()
        timeStampsRecord = Dictionary()
        setupNavigationBarButtons()
        webView.delegate = self
        let urlRequest = URLRequest.init(url: URL.init(string: urlToLoad as String)!);
        setCookie(cookieStringToLoad, request: urlRequest)
        webView.loadRequest(urlRequest)
    }

    deinit {
        webView.delegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupNavigationBarButtons() {
        let backbutton = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(WKWebViewRenderController.backButtonPressed));
        self.navigationItem.leftBarButtonItem = backbutton;
    }

    func backButtonPressed() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            _ = navigationController?.popViewController(animated: true);
        }
    }

    func setCookie(_ cookieString:String, request:URLRequest) {
        let cookieProperties : [HTTPCookiePropertyKey:AnyObject] = [HTTPCookiePropertyKey.name:"mmbn" as AnyObject, HTTPCookiePropertyKey.path:(request.url?.path)! as AnyObject, HTTPCookiePropertyKey.domain:(request.url?.host)! as AnyObject, HTTPCookiePropertyKey.value:cookieString as AnyObject]
        let httpcookie : HTTPCookie = HTTPCookie(properties:cookieProperties as! [HTTPCookiePropertyKey : AnyObject])!
        HTTPCookieStorage.shared.setCookie(httpcookie)
    }

    //Pragma mark - UIWebViewDelegate methods
    internal func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let startTime = Date()
        let urlString = request.url?.absoluteString
        timeStampsRecord[urlString!] = startTime as AnyObject?
        return true
    }

    internal func webViewDidStartLoad(_ webView: UIWebView) {

    }

    internal func webViewDidFinishLoad(_ webView: UIWebView) {
        let endTime = Date()
        if (webView.stringByEvaluatingJavaScript(from: "document.readyState") == "complete") {
            if let urlString = (webView.request?.url?.absoluteString), urlString != "" {
                let requestStartTime = timeStampsRecord[urlString] as! Date
                let elapsedSeconds = endTime.timeIntervalSince(requestStartTime)
                AppDelegate.showToastWithText((webView.request?.url?.absoluteString)! + " loaded in " + "\(elapsedSeconds)" + " secs")
            }
        }
    }
}
