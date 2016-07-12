//
//  IdCardViewController.swift
//  SuperQuery
//
//  Created by Lance Blue on 16/7/12.
//  Copyright © 2016年 Lance Blue. All rights reserved.
//

import UIKit
import Alamofire

class IdCardViewController: UIViewController {
    
    let idCardRegex = "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X|x)$"
    
    @IBOutlet weak var idCardTextField: UITextField!
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
        let cardno = self.idCardTextField.text!
        if cardno == "" {
            return;
        }
        let match = cardno.rangeOfString(idCardRegex, options: .RegularExpressionSearch)
        if match == nil {
            self.resultTextView.text = "错误的身份证号"
            return;
        }
        Alamofire.request(.GET,
            "https://apis.juhe.cn/idcard/index",
            parameters: [ "key" : "0cdc122fc90501c7bc163b54cf44a017", "cardno" : cardno ])
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .Success:
                    if response.result.value!["result"]! != nil {
                        let result: [String: AnyObject] = response.result.value!["result"] as! [String: AnyObject]
                        self.resultTextView.text = "地区：\(result["area"]!)\n性别：\(result["sex"]!)\n出生日期：\(result["birthday"]!)"
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }

}
