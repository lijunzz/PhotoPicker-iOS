//===--- StringTests.swift ------------------------------------------------===//
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

import XCTest
@testable import Toolbox

class StringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Log.enabled = true
    }
    
    override func tearDown() {
        Log.enabled = false
        super.tearDown()
    }
    
    /// 测试日志
    func testLog() {
        XCTAssertNoThrow("测试中文".log())
        DispatchQueue.global().async {
            XCTAssertNoThrow("测试异步".log())
        }
        XCTAssertNoThrow("Test".log())
        XCTAssertNoThrow("Test default".log(type: .default))
        XCTAssertNoThrow("Test info".log(type: .info))
        XCTAssertNoThrow("Test debug".log(type: .debug))
        XCTAssertNoThrow("Test error".log(type: .error))
        XCTAssertNoThrow("Test fault".log(type: .fault))
    }
    
    /// 测试Base64转换
    func testBase64() {
        XCTAssertEqual("".base64(), "")
        XCTAssertEqual("Base64".base64(), "QmFzZTY0")
        XCTAssertNotEqual("Base64".base64(), "Base64")
    }
    
}
