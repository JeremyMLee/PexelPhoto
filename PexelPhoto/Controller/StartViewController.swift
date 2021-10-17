//
//  StartViewController.swift
//  PexelPhoto
//
//  Created by Jeremy Lee on 10/17/21.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTitle.alpha = 0.0
        background.alpha = 0.0
        startButton.alpha = 0.0
        mainTitle.layer.masksToBounds = true
        mainTitle.layer.cornerRadius = 30.0
        setUp()
    }
    
    @objc func setUp() {
        print("Setting up app")
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: {
            self.background.alpha = 1.0
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIView.AnimationOptions(), animations: {
            self.mainTitle.alpha = 1.0
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 1.0, options: UIView.AnimationOptions(), animations: {
            self.startButton.alpha = 1.0
        }, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions(), animations: {
            self.mainTitle.alpha = 0.0
            self.background.alpha = 0.0
            self.startButton.alpha = 0.0
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: "startSegue", sender: nil)
        }
    }

}
