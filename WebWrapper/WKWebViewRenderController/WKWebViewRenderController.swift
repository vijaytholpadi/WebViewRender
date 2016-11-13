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
        let urlRequest = URLRequest.init(url: URL.init(string: urlToLoad as String)!);
        webView.load(urlRequest)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(progressView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        progressView.removeFromSuperview()
    }

    func setupWebView() {
        webView = WKWebView.init(frame: CGRect.zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
        webView.navigationDelegate = self;
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        //Setting up the constraints
        let heightConstaint = NSLayoutConstraint.init(item: webView, attribute:.height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0)
        let widthConstaint = NSLayoutConstraint.init(item: webView, attribute:.width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0)
        view.addConstraints([heightConstaint,widthConstaint])
    }

    func setupNavigationBarButtons() {
        let backbutton = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(WKWebViewRenderController.backButtonPressed));
        self.navigationItem.leftBarButtonItem = backbutton;
    }

    func backButtonPressed() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            _ = navigationController?.popViewController(animated: true)
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
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            progressView.isHidden = Bool(webView.estimatedProgress == 1.0)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func addProgressView() {
        progressView = UIProgressView.init(progressViewStyle: .default)
        progressView.trackTintColor = UIColor.init(white: 1.0, alpha: 0.0)
        progressView.progressTintColor = UIColor.blue
        progressView.frame = CGRect(x: 0, y: navigationController!.navigationBar.frame.size.height - progressView.frame.size.height, width: view.frame.size.width, height: progressView.frame.size.height)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    }

    //pragma mark - WKNavigationDelegate methods
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let startTime = Date()
        let urlString = navigationAction.request.url?.absoluteString
        timeStampsRecord[urlString!] = startTime as AnyObject?
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    internal func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }

    internal func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

    }

    internal func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

    }

    internal func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }

    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let endTime = Date()
        let requestStartTime = timeStampsRecord[(webView.url?.absoluteString)!] as! Date
        let elapsedSeconds = endTime.timeIntervalSince(requestStartTime)
        print((webView.url?.absoluteString)! + " loaded in " + "\(elapsedSeconds)" + "\n")
        AppDelegate.showToastWithText((webView.url?.absoluteString)! + " rendered in " + "\(elapsedSeconds)" + " secs")
    }
}
