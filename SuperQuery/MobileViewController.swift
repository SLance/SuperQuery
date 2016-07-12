//
//  MobileViewController.swift
//  SuperQuery
//
//  Created by Lance Blue on 16/7/12.
//  Copyright © 2016年 Lance Blue. All rights reserved.
//

import UIKit
import Alamofire

class MobileViewController: UIViewController {
    
    let mobileRegex = "^1\\d{6,10}$"
    
    @IBOutlet weak var mobileTextField: UITextField!
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
        let mobile = self.mobileTextField.text!
        if mobile == "" {
            return;
        }
        let match = mobile.rangeOfString(mobileRegex, options: .RegularExpressionSearch)
        if match == nil {
            self.resultTextView.text = "错误的手机号"
            return;
        }
        Alamofire.request(.POST,
            "https://apis.juhe.cn/mobile/get",
            parameters: [ "key" : "b4b3e0391e9ac008a50cbcc9ccdeba86", "phone" : mobile ])
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .Success:
                    if response.result.value!["result"] != nil {
                        let result: [String: AnyObject] = response.result.value!["result"] as! [String: AnyObject]
                        self.resultTextView.text = "省份：\(result["province"]!)\n城市：\(result["city"]!)\n区号：\(result["areacode"]!)\n邮编：\(result["zip"]!)\n运营商：\(result["company"]!)\n卡类型：\(result["card"]!)"
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }

}
