//===--- Alert.swift -------------------------------------------------------===//
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

public struct Alert {
    
    /// 显示警告框。
    ///
    /// - Parameters:
    ///   - vc: UIViewController
    ///   - title: 标题
    ///   - body: 内容
    ///   - style: 类型
    ///   - actions: Actions
    ///   - delay: 延时关闭警告框
    public static func show(_ vc: UIViewController,
                            title: String? = nil,
                            body: String,
                            style: AlertType,
                            actions: [UIAlertAction] = [],
                            delay:TimeInterval = 0) {
        // 确定 Alert 类型。
        var alertStyle: UIAlertControllerStyle
        switch style {
        case .actionSheet:
            alertStyle = .actionSheet
        case .alert:
            alertStyle = .alert
        case .dialog:
            alertStyle = .alert
        }
        
        let alertController = UIAlertController(title: title, message: body, preferredStyle: alertStyle)
        
        // Dialog 类型默认带一个取消操作。
        if style == .dialog {
            alertController.addAction(UIAlertAction(title: "Cancel".language(), style: .cancel))
        }
        
        actions.forEach {
            alertController.addAction($0)
        }
        
        vc.present(alertController, animated: true)
        
        // 延时关闭。
        if (delay > 0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                alertController.dismiss(animated: true)
            })
        }
    }
    
}
