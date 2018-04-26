//===--- NotificationsUtils.swift ------------------------------------------===//
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

import UserNotifications

// App 在前台不会出现横幅。^_^
// https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/index.html
public struct NotificationsUtils {
    
    /// 检查是否授权并注册通知
    ///
    /// - Parameters:
    ///   - viewController: 宿主控制器
    ///   - granted: 收钱的闭包
    public static func register(_ vc: UIViewController, result: ((Bool) -> Void)? = nil) {
        let identifierGeneral = "GENERAL"
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .denied:
                    // 提示用户权限被拒绝
                    let settingsAction = UIAlertAction(title: "Settings".language(identifier: Constants.ToolboxIdentifier), style: .default, handler: { _ in
                        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                        // Take the user to Settings app to possibly change permission.
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    })
                    
                    AlertUtils.showDialog(vc,
                                          title: "NotificationsActionSheetTitle".language(),
                                          body: "NotificationsActionSheetMessage".language(),
                                          actions: [settingsAction])
                    
                    if let result = result {
                        result(false)
                    }
                case .notDetermined:
                    let center = UNUserNotificationCenter.current()
                    center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                        guard granted else {
                            "Unable to send notification: \(error?.localizedDescription ?? "")".log()
                            if let result = result {
                                result(false)
                            }
                            return
                        }
                        
                        let generalCategory = UNNotificationCategory(identifier: identifierGeneral,
                                                                     actions: [],
                                                                     intentIdentifiers: [],
                                                                     options: .customDismissAction)
                        
                        // Register the notification categories.
                        center.setNotificationCategories([generalCategory])
                        
                        if let result = result {
                            result(true)
                        }
                    }
                case .authorized:
                    if let result = result {
                        result(true)
                    }
                    break
                }
            }
        } else {
            // 兼容低版本
            let types: UIUserNotificationType = [.alert, .sound, .badge]
            
            let generalCategory = UIMutableUserNotificationCategory()
            generalCategory.identifier = identifierGeneral
            
            let settings = UIUserNotificationSettings(types: types, categories: [generalCategory])
            
            UIApplication.shared.registerUserNotificationSettings(settings)
            
            if let result = result {
                result(true)
            }
        }
    }
    
    /// 发送本地通知
    ///
    /// - Parameters:
    ///   - title: 通知标题
    ///   - body: 通知内容
    ///   - time: 通知时间
    ///   - categoryIdentifier: 分类标识
    ///   - requestIdentifier: 请求标识
    public static func local(title: String,
                             body: String,
                             time: DateComponents? = nil,
                             categoryIdentifier: String,
                             requestIdentifier: String) {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.categoryIdentifier = categoryIdentifier
            content.sound = UNNotificationSound.default()
            
            var trigger: UNNotificationTrigger? = nil
            if let time = time {
                trigger = UNCalendarNotificationTrigger(dateMatching: time,
                                                        repeats: false)
            }
            
            // Create the request object.
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content,
                                                trigger: trigger)
            
            // Schedule the request.
            let center = UNUserNotificationCenter.current()
            center.add(request) { error in
                if let error = error {
                    "An error occurred while displaying local notification: \(error.localizedDescription)".log(type: .error)
                }
            }
        } else {
            let notification = UILocalNotification()
            notification.alertTitle = title
            notification.alertBody = body
            notification.category = requestIdentifier
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = TimeZone.current
            
            if let time = time {
                let calendar = Calendar.current
                let date = calendar.date(from: time)
                notification.fireDate = date
                UIApplication.shared.scheduleLocalNotification(notification)
            } else {
                UIApplication.shared.presentLocalNotificationNow(notification)
            }
        }
    }
    
    /// 移除已发送的通知
    ///
    /// - Parameter identifiers: 通知的标识，空将移除所有通知。
    public static func remove(identifiers: [String] = []) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            if identifiers.isEmpty {
                center.removeAllDeliveredNotifications()
            } else {
                center.removeDeliveredNotifications(withIdentifiers: identifiers)
            }
        } else {
            let application = UIApplication.shared
            if identifiers.isEmpty {
                application.cancelAllLocalNotifications()
            } else {
                if let notifications = application.scheduledLocalNotifications {
                    notifications.forEach({ notification in
                        identifiers.forEach({ identifier in
                            if let category = notification.category {
                                if category == identifier {
                                    application.cancelLocalNotification(notification)
                                }
                            }
                        })
                    })
                }
            }
        }
    }
    
}
