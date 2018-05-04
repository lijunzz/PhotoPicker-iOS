//===--- ImagePicker.swift -----------------------------------------------===//
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

import AVFoundation
import MobileCoreServices

// https://developer.apple.com/library/content/samplecode/PhotoPicker/Introduction/Intro.html
// https://developer.apple.com/library/content/documentation/AudioVideo/Conceptual/CameraAndPhotoLib_TopicsForIOS/Introduction/Introduction.html
/// 选取相册或相机中的照片。
public class ImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// 图片选择后通过闭包返回
    public typealias ImagePickerClosure = (UIImage) -> Void
    private typealias AuthorizationClosure = (Bool) -> Void
    
    private let picker = UIImagePickerController()
    private var imageClosure: ImagePickerClosure?
    
    public override init() {
        super.init()
        picker.modalPresentationStyle = .currentContext
        picker.delegate = self
    }
    
    /// 检查是否授权
    ///
    /// - Parameters:
    ///   - vc: UIViewController
    ///   - closure: 授权结果
    private func authorizationStatus(_ vc: UIViewController, closure: @escaping AuthorizationClosure) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .denied:
            // Denied access to camera, alert the user.
            // The user has previously denied access. Remind the user that we need camera access to be useful.
            let settingsAction = UIAlertAction(title: "Settings".language(), style: .default, handler: { _ in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                // Take the user to Settings app to possibly change permission.
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl)
                    } else {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            })
            Alert.show(vc, title: "PhotoPickerActionSheetTitle".language(), body: "PhotoPickerActionSheetMessage".language(), style: .dialog, actions: [settingsAction])
        case .notDetermined:
            // The user has not yet been presented with the option to grant access to the camera hardware.
            // Ask for permission.
            //
            // (Note: you can test for this case by deleting the app on the device, if already installed).
            // (Note: we need a usage description in our Info.plist to request access.
            //
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
                if granted {
                    DispatchQueue.main.async {
                        closure(true)
                    }
                }
            })
        default:
            // Allowed access to camera, go ahead and present the UIImagePickerController.
            closure(true)
            break
        }
    }
    
    private func showImagePicker(_ vc: UIViewController, sourceType: UIImagePickerControllerSourceType) {
        picker.sourceType = sourceType
        picker.mediaTypes = [kUTTypeImage as String]
        picker.modalPresentationStyle = (sourceType == .camera) ? .fullScreen : .popover
        
        vc.present(picker, animated: true)
    }
    
    /// 显示图片选择器
    ///
    /// - Parameter vc: UIViewController
    private func showImageSelector(_ vc: UIViewController) {
        let alert = UIAlertController()
        let actions = [
            UIAlertAction(title: "PhotoPickerAlertPhoto".language(), style: .default) { _ in
                DispatchQueue.main.async {
                    self.showImagePicker(vc, sourceType: .savedPhotosAlbum)
                }
            },
            UIAlertAction(title: "PhotoPickerAlertCamera".language(), style: .default) { _ in
                DispatchQueue.main.async {
                    self.showImagePicker(vc, sourceType: .camera)
                }
            },
            UIAlertAction(title: "Cancel".language(), style: .cancel)
        ]
        actions.forEach { alert.addAction($0) }
        vc.present(alert, animated: true)
    }
    
    /// 选择图片后，系统在此方法返回图片
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        "UIImagePickerController finishPickingMedia".log()
        
        picker.dismiss(animated: true)
        
        guard let imageClosure = imageClosure else {
            return
        }
        
        let any = info[UIImagePickerControllerOriginalImage]
        guard let image = any as? UIImage else {
            return
        }
        
        imageClosure(image)
    }
    
    /// 获取图片
    ///
    /// - Parameters:
    ///   - vc: UIViewController
    ///   - closure: 图片选择结果
    public func showSelector(_ vc: UIViewController, closure: @escaping ImagePickerClosure) {
        authorizationStatus(vc) {
            if $0 {
                self.showImageSelector(vc)
            }
            
            self.imageClosure = closure
        }
    }
    
}
