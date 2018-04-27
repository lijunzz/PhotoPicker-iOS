//===--- String+Extensions.swift ------------------------------------------===//
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

import os

extension String {
    
    //===--- 多语言 --------------------------------------------------------===//
    // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html
    
    /// 本地化语言
    ///
    /// - Parameters:
    ///   - identifier: 套装 ID，以加载不同模块的语言文件。
    /// - Returns: 本地语言对应的字符串
    public func language(identifier: AnyClass = ImagePickerUtils.self) -> String {
        let bundle = Bundle(for: ImagePickerUtils.self)
        return NSLocalizedString(self, bundle: bundle, comment: self)
    }
    
    //===--- Base64 --------------------------------------------------------===//
    
    /// 将文本使用 Base64 编码。
    ///
    /// - Returns: Base64
    public func base64() -> String {
        guard let base64Data = data(using: .utf8), !isEmpty else {
            return self
        }
        
        return base64Data.base64EncodedString()
    }
    
    //===--- 日志打印 ---------------------------------------------------------===//
    
    /// 打印日志。
    ///
    /// - Parameters:
    ///   - type: 日志类型
    ///   - file: 调用方的文件名
    ///   - line: 调用方所在行数
    public func log(type: LogType = .debug, file: String = #file, line: Int = #line) {
        // 过滤空字符串
        guard !isEmpty else {
            return
        }
        
        let threadName = Thread.isMainThread ? "main" : "worker"
        
        let fileName = file.contains("/") ? String(describing: file.split(separator: "/").last) : file
        
        if #available(iOS 10.0, *) {
            var logType: OSLogType
            switch type {
            case .default:
                logType = .default
            case .info:
                logType = .info
            case .debug:
                logType = .debug
            case .error:
                logType = .error
            case .fault:
                logType = .fault
            }
            
            os_log("[%@] [%@] [%@:%d] \n\t%@", log: (Log.enabled ? .default : .disabled), type: logType, type.rawValue, threadName, fileName, line, self)
        } else {
            guard Log.enabled else {
                return
            }
            
            NSLog("[%@] [%@] [%@:%d] \n\t%@", type.rawValue, threadName, fileName, line, self)
        }
    }
    
}
