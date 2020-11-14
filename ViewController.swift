//
//  ViewController.swift
//  Demo-App
//
//  Created by Apple on 12/11/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import UIKit
import SinchVerification

class ViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var otpButton: UIButton!
    
    //Variables
    var verification:Verification!
    var applicationKey = "77bb4943-cc40-430d-9667-6f41fe565df1";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpVc()
    }

    override func viewWillAppear(_ animated: Bool) {
            phoneNumber.becomeFirstResponder();
            disableUI(false);
    }
    
    func setUpVc()
    {
        self.otpButton.layer.cornerRadius = 8.0
        self.otpButton.layer.borderWidth = 1.0
        self.otpButton.layer.borderColor = UIColor.systemIndigo.cgColor
    }
    
    @IBAction func smsVerification(_ sender: UIButton) {
        self.disableUI(true);
        verification = SMSVerification(applicationKey, phoneNumber: phoneNumber.text!)

        verification.initiate { (result: InitiationResult, error:Error?) -> Void in
            self.disableUI(false);
            if (true){
                self.performSegue(withIdentifier: "enterPin", sender: sender)

            } else {
                self.status.text = error?.localizedDescription
            }
        }
    }
    
    func disableUI(_ disable: Bool){
        var alpha:CGFloat = 1.0;
        if (disable) {
            alpha = 0.5;
            phoneNumber.resignFirstResponder();
            spinner.startAnimating();
            self.status.text="";
            let delayTime =
                        DispatchTime.now() +
                        Double(Int64(30 * Double(NSEC_PER_SEC)))
                        / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(
            deadline: delayTime, execute:
            { () -> Void in
                self.disableUI(false);
            });
        }
        else{
            self.phoneNumber.becomeFirstResponder();
            self.spinner.stopAnimating();

        }
        self.phoneNumber.isEnabled = !disable;
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "enterPin") {
            let enterCodeVC = segue.destination as! EnterCodeViewController;
            enterCodeVC.verification = self.verification;
        }
    }

}
