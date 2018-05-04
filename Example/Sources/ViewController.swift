//===--- ViewController.swift -----------------------------------------------===//
//
// Copyright (C) 2018 LiJun
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//===----------------------------------------------------------------------===//

import UIKit
import Toolbox

class ViewController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView?
    
    // 需声明成成员变量，否则将无法收到图片。
    private let imagePicker = ImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Log.enabled = true
        
        Notifications.register(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showImage() {
        guard let imagePreview = imagePreview else {
            return
        }
        
        imagePicker.showSelector(self) { image in
            let image = image.compress()
            "showImage".log()
            imagePreview.image = image
        }
    }
    
    @IBAction func showLocalNotification() {
        /*
         var time = DateComponents()
         time.hour = 13
         time.minute = 51
         */
        
        Notifications.local(title: "测试", body: "测试内容", time: nil, categoryIdentifier: "Test", requestIdentifier: "Test-Identifier")
    }
    
    @IBAction func removeLocalNotification() {
        Notifications.remove()
    }
    
    @IBAction func share() {
        Share.fire(self, content: "Junzz http://junzz.net/")
    }
    
    @IBAction func loadContact() {
        Contact.allPeoples(self) {
            $0.forEach({
                "contacts name: \($0.familyName)\($0.givenName)".log()
            })
        }
    }
    
}

