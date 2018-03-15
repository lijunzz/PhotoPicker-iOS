//===--- ViewController.swift --------------------------------------------===//
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

import PhotoPicker

class ViewController: UIViewController {
    
    @IBOutlet private var previewImage: UIImageView?
    private let pickerManager = PhotoPickerManager()
    
    @IBAction private func clickPickerPhoto() {
        pickerManager.show(self) { image in
            // 压缩照片再显示
            let image = image.compress()
            self.previewImage?.image = image
        }
    }
    
}

