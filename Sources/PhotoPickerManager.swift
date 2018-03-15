//===--- PhotoPickerManager.swift ----------------------------------------===//
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

public class PhotoPickerManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// 选中的图片的回调
    public typealias PhotoPickerClosure = (UIImage) -> Void
    
    private let picker = UIImagePickerController()
    private var imageClosure: PhotoPickerClosure?
    
    public override init() {
        super.init()
        picker.modalPresentationStyle = .currentContext
        picker.delegate = self
    }
    
    public func show(_ viewController: UIViewController, closure: @escaping PhotoPickerClosure) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .denied:
            // Denied access to camera, alert the user.
            // The user has previously denied access. Remind the user that we need camera access to be useful.
            let alert = UIAlertController(title: "PhotoPickerActionSheetTitle".Localized(),
                                          message: "PhotoPickerActionSheetMessage".Localized(),
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "PhotoPickerActionSheetOK".Localized(default: "OK"), style: .cancel)
            alert.addAction(okAction)
            
            let settingsAction = UIAlertAction(title: "PhotoPickerActionSheetSettings".Localized(default: "Settings"), style: .default, handler: { _ in
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
            alert.addAction(settingsAction)
            
            viewController.present(alert, animated: true)
        case .notDetermined:
            // The user has not yet been presented with the option to grant access to the camera hardware.
            // Ask for permission.
            //
            // (Note: you can test for this case by deleting the app on the device, if already installed).
            // (Note: we need a usage description in our Info.plist to request access.
            //
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.showImageAlert(viewController)
                    }
                }
            })
        default:
            // Allowed access to camera, go ahead and present the UIImagePickerController.
            showImageAlert(viewController)
            break
        }
        
        imageClosure = closure
    }
    
    /// 选择照片的方式
    ///
    /// - Parameter viewController: UIViewController
    private func showImageAlert(_ viewController: UIViewController) {
        let alert = UIAlertController()
        let actions = [
            UIAlertAction(title: "PhotoPickerAlertPhoto".Localized(), style: .default) { _ in
                DispatchQueue.main.async {
                    self.showImagePicker(viewController, sourceType: .savedPhotosAlbum)
                }
            },
            UIAlertAction(title: "PhotoPickerAlertCamera".Localized(), style: .default) { _ in
                DispatchQueue.main.async {
                    self.showImagePicker(viewController, sourceType: .camera)
                }
            },
            UIAlertAction(title: "PhotoPickerAlertCancel".Localized(), style: .cancel)
        ]
        actions.forEach { alert.addAction($0) }
        viewController.present(alert, animated: true)
    }
    
    private func showImagePicker(_ viewController: UIViewController, sourceType: UIImagePickerControllerSourceType) {
        picker.sourceType = sourceType
        picker.mediaTypes = [kUTTypeImage as String]
        picker.modalPresentationStyle = (sourceType == .camera) ? .fullScreen : .popover
        
        viewController.present(picker, animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
    
}
