//
//  ViewController.swift
//  DropInPP
//
//  Created by Orcun on 15/06/2017.
//  Copyright © 2017 Orcun. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn


class ViewController: UIViewController {

    var myTokenizationKey = "sandbox_tpt8mgp5_26qns4ycnjgrr6cv"
    var price: Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func launchDropIn(_ sender: Any) {
        
        
        showDropIn()
        
    }
    
    
    func showDropIn() {
        
        let request =  BTDropInRequest()
        request.amount = "$10"
        request.applePayDisabled = true
        
        let dropInController = BTDropInController(authorization: myTokenizationKey, request: request) { (dropController, dropInResult, error) in
            
            if(error != nil) {
                
                print("ERROR")
                dropController.dismiss(animated: true, completion: nil)
            }
            else if(dropInResult?.isCancelled == true) {
                
                print("Canceled")
                dropController.dismiss(animated: true, completion: nil)
            }
            else if let result = dropInResult {
                
                let selectedPaymentOption = result.paymentOptionType
                let selectedPaymentMethod = result.paymentMethod
                let selectedPaymentMethodIcon = result.paymentIcon
                let selectedPaymentMethodDescription = result.paymentDescription
                
                dropController.dismiss(animated: true, completion: nil)
                
                self.postNonceToServer(paymentMethodNonce: selectedPaymentMethod!.nonce)
            }
            
        }
        
        self.present(dropInController!, animated: true, completion: nil)
    }
    
    func postNonceToServer(paymentMethodNonce : String) {
        
        price = 10
        let paymentURL = NSURL(string: "http://orcodevbox.co.uk/BTOrcun/iosPayment.php")!
        let request = NSMutableURLRequest(url: paymentURL as URL)
        request.httpBody = "amount=\(Double(price))&payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8);
        request.httpMethod = "POST"
        
        
        
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            let responseData = String(data: data!, encoding: String.Encoding.utf8)
            // Log the response in console
            print(responseData);
            
            // Display the result in an alert view
            DispatchQueue.main.async(execute: {
                let alertResponse = UIAlertController(title: "Result", message: "\(responseData)", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action to the alert (button)
                alertResponse.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alertResponse, animated: true, completion: nil)
                
            })
            
            }.resume()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

