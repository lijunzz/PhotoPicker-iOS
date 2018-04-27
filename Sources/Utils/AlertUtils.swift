//===--- AlertUtils.swift ------------------------------------------------===//
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

public struct AlertUtils {
    
    /// 显示 Dialog。
    ///
    /// - Parameters:
    ///   - vc: 宿主控制器
    ///   - title: 标题
    ///   - body: 内容
    ///   - actions: Actions
    ///   - delay: 延时关闭警告框
    public static func showDialog(_ vc: UIViewController,
                                  title: String? = nil,
                                  body: String,
                                  actions: [UIAlertAction] = [],
                                  delay:TimeInterval = 0) {
        
        var actionsNew: [UIAlertAction] = []
        
        let cancelAction = UIAlertAction(title: "Cancel".language(), style: .cancel)
        
        actionsNew.append(cancelAction)
        
        actions.forEach {
            actionsNew.append($0)
        }
        
        showAlert(vc, title: title, body: body, style: .alert, actions: actionsNew, delay: delay)
    }
    
    /// 显示警告框。
    ///
    /// - Parameters:
    ///   - vc: 宿主控制器
    ///   - title: 标题
    ///   - body: 内容
    ///   - style: 警告框类型
    ///   - actions: Actions
    ///   - delay: 延时关闭警告框
    public static func showAlert(_ vc: UIViewController,
                                 title: String? = nil,
                                 body: String,
                                 style: UIAlertControllerStyle,
                                 actions: [UIAlertAction] = [],
                                 delay:TimeInterval = 0) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: style)
        
        actions.forEach {
            alert.addAction($0)
        }
        
        vc.present(alert, animated: true)
        
        if (delay > 0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                alert.dismiss(animated: true)
            })
        }
    }
    
}
