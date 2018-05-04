//===--- Share.swift -------------------------------------------------------===//
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

/// 分享
public struct Share {
    
    /// 分享到其它平台。
    ///
    /// - Parameters:
    ///   - viewController: UIViewController
    ///   - content: 内容（在 QQ 平台，有 URL 将不会显示内容）
    ///   - image: 图片
    ///   - url: 链接
    public static func fire(_ viewController: UIViewController, content: String, image: UIImage? = nil, url: URL? = nil) {
        var items:[Any] = []
        items.append(content)
        if let image = image {
            items.append(image)
        }
        if let url = url {
            items.append(url)
        }
        
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        viewController.present(vc, animated: true)
    }
    
}
