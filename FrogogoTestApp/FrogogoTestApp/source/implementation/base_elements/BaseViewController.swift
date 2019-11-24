//
//  BaseViewController.swift
//  FrogogoTestApp
//
//  Created by User on 11/22/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

//Base class for all ViewControllers
class BaseViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBInspectable private var canEndEditingByTap: Bool = true
    
    private var endEditingTapGestoreRecognizer: UITapGestureRecognizer?
    private var contentSize = CGSize()
    private var isKeyboardShowed = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEndEditingState()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name:  UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
    
    private func updateEndEditingState() {
        if canEndEditingByTap {
            endEditingTapGestoreRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
            endEditingTapGestoreRecognizer?.cancelsTouchesInView = false
            view.addGestureRecognizer(endEditingTapGestoreRecognizer!)
        } else {
            guard let tapGestore = endEditingTapGestoreRecognizer else { return }
            view.removeGestureRecognizer(tapGestore)
        }
    }
    
    //The method determines the state of the keyboard and makes a change for the scrollview to work correctly.
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if !isKeyboardShowed {
            contentSize = scrollView?.contentSize ?? CGSize.zero
        }
        if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
            isKeyboardShowed = false
            self.scrollView?.contentSize = self.contentSize
        } else {
            isKeyboardShowed = true
            self.scrollView?.contentSize = CGSize(width: self.contentSize.width,
                                                 height: self.contentSize.height + (endFrame?.size.height ?? 0))
        }
        
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }

}
