//===--- UIImage+Extensions.swift -----------------------------------------===//
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

// https://github.com/hucool/WXImageCompress
extension UIImage {
    
    /// 压缩图片
    ///
    /// - Returns: 压缩后的图片
    public func compress() -> UIImage {
        let rawImage = resize()
        guard rawImage != nil else {
            return self
        }
        
        // 压缩图片质量
        let imageData = UIImageJPEGRepresentation(rawImage!, 0.5)
        guard imageData != nil else {
            return self
        }
        
        return UIImage(data: imageData!) ?? self
    }
    
    /// 压缩图片尺寸
    ///
    /// - Returns: 压缩后的图片
    private func resize() -> UIImage? {
        let size = calculateCompressSize()
        
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage
    }
    
    /// 计算图片压缩后的大小
    ///
    /// - Returns: 压缩大小
    private func calculateCompressSize() -> CGSize {
        var width = size.width
        var height = size.width
        let boundary: CGFloat = 1280
        
        // 宽高比
        let ratio = max(width, height) / min(width, height)
        if width <= boundary && height <= boundary {
            if ratio > 2 {
                let boundary: CGFloat = 800
                // 缩放比
                let scale = min(width, height) / boundary
                if width > height {
                    width = width / scale
                    height = boundary
                } else {
                    width = boundary
                    height = height / scale
                }
            }
        } else if width > boundary && height > boundary {
            if ratio > 2 {
                let scale = min(width, height) / boundary
                if width > height {
                    width = width / scale
                    height = boundary
                } else {
                    width = boundary
                    height = height / scale
                }
            }
        } else {
            if ratio <= 2 {
                let scale = max(width, height) / boundary
                if width > height {
                    width = boundary
                    height = height / scale
                } else {
                    width = width / scale
                    height = boundary
                }
            }
        }
        
        return CGSize(width: width, height: height)
    }
    
}
