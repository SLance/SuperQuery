//
//  PostcodeViewController.swift
//  SuperQuery
//
//  Created by Lance Blue on 16/7/15.
//  Copyright © 2016年 Lance Blue. All rights reserved.
//

import UIKit
import Alamofire

class PostcodeViewController: UIViewController {
    
    let postcodeRegex = "^[0-9]{6}$"
    
    @IBOutlet weak var postcodeTextField: UITextField!
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
        let postcode = self.postcodeTextField.text!
        if postcode == "" {
            return;
        }
        let match = postcode.rangeOfString(postcodeRegex, options: .RegularExpressionSearch)
        if match == nil {
            self.resultTextView.text = "错误的邮编号码"
            return;
        }
        Alamofire.request(.POST,
            "https://v.juhe.cn/postcode/query",
            parameters: [ "key" : "eeaa47d81c9f866142a957b4fe84cb6c", "postcode" : postcode ])
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .Success:
                    if let result = response.result.value!["result"]! {
                        if let list: [AnyObject] = result["list"]! as? [AnyObject] {
                            for data in list {
                                self.resultTextView.text! += "邮编号码：\(data["PostNumber"]!!)\n省份：\(data["Province"]!!)\n城市：\(data["City"]!!)\n区/县/乡：\(data["District"]!!)\n地址：\(data["Address"]!!)\n\n"
                            
                            }
                        }
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }

}
