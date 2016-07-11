//
//  IPAddressViewController.swift
//  SuperQuery
//
//  Created by Lance Blue on 16/7/8.
//  Copyright © 2016年 Lance Blue. All rights reserved.
//

import UIKit
import Alamofire

class IPAddressViewController: UIViewController {

    let ipRegex = "^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$"
    
    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func checkButton_touch(sender: AnyObject) {
        let ip = self.ipAddressTextField.text!
        if ip == "" {
            return;
        }
        let match = ip.rangeOfString(ipRegex, options: .RegularExpressionSearch)
        if match == nil {
            self.resultTextView.text = "错误的IP地址"
            return;
        }
        Alamofire.request(.POST,
            "https://apis.juhe.cn/ip/ip2addr",
            parameters: [ "key" : "8c196438d0a6628c68700e8c28ed879b", "ip" : ip ])
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .Success:
                    if response.result.value!["result"]! != nil {
                        let result: [String: AnyObject] = response.result.value!["result"] as! [String: AnyObject]
                        self.resultTextView.text = "区域：\(result["area"]!)\n位置：\(result["location"]!)"
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }

}
