//
//  EnterCodeViewController.swift
//  Demo-App
//
//  Created by Apple on 13/11/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import UIKit
import SinchVerification

class EnterCodeViewController: UIViewController {

    
    @IBOutlet weak var enterPin: UITextField!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    @IBOutlet weak var showGraph: UIButton!
    
    var verification:Verification!
    var applicationKey = "77bb4943-cc40-430d-9667-6f41fe565df1";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpVc()
        // Do any additional setup after loading the view.
    }
    
    func setUpVc()
    {
        self.verifyButton.layer.cornerRadius = 8.0
        self.verifyButton.layer.borderWidth = 1.0
        self.verifyButton.layer.borderColor = UIColor.systemIndigo.cgColor
        
        self.showGraph.layer.cornerRadius = 8.0
        self.showGraph.layer.borderWidth = 1.0
        self.showGraph.layer.borderColor = UIColor.systemIndigo.cgColor
    }
    
    @IBAction func verify(_ sender: UIButton) {
        
        verifyButton.isEnabled = false;
        status.text  = "";
        enterPin.isEnabled = false;
        verification.verify(
            enterPin.text!, completion:
            { (success:Bool, error:Error?) -> Void in
                self.spinner.stopAnimating();
                self.verifyButton.isEnabled = true;
                self.enterPin.isEnabled = true;
                if (success) {
                    self.status.text = "Verified";
                } else {
                    self.status.text = error?.localizedDescription;
                }
        });
        
    }
    
    
    @IBAction func viewGraphAction(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "graphvc") as! GraphViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
