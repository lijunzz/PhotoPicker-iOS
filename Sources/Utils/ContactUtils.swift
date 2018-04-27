//===--- Contacts.swift --------------------------------------------------===//
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

import Contacts

/// http://www.hangge.com/blog/cache/detail_1523.html
/// https://developer.apple.com/documentation/contacts
public struct ContactUtils {
    
    private typealias AuthorizationClosure = (Bool) -> Void
    public typealias AllPeoplesClosure = ([PeopleMO]) -> Void
    
    /// 检查是否授权
    ///
    /// - Parameters:
    ///   - vc: UIViewController
    ///   - closure: 授权结果
    private static func authorizationStatus(_ vc: UIViewController, closure: @escaping AuthorizationClosure) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .denied:
            // 通讯录访问权限被拒绝，提示用户修改权限。
            let settingsAction = UIAlertAction(title: "Settings".language(), style: .default, handler: { _ in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl)
                    } else {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            })
            AlertUtils.showDialog(vc, title: "ContactsActionSheetTitle".language(), body: "ContactsActionSheetMessage".language(), actions: [settingsAction])
        case .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (granted, error) in
                guard granted else {
                    return
                }
                closure(true)
            }
        default:
            closure(true)
            break
        }
    }
    
    private static func queryAllPeoples(_ vc: UIViewController, closure: AllPeoplesClosure) {
        let store = CNContactStore()
        var peoples: [PeopleMO] = []
        let keys: [CNKeyDescriptor] = [NSString(string: CNContactFamilyNameKey),
                                       NSString(string: CNContactGivenNameKey),
                                       NSString(string: CNContactNicknameKey),
                                       NSString(string: CNContactPhoneNumbersKey)]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try store.enumerateContacts(with: request) { (contact, stop) in
                // "allPeople enumerateContacts: \(stop.pointee.boolValue)".log()
                
                let familyName = contact.familyName
                let givenName = contact.givenName
                var phones: [String] = []
                
                for phone in contact.phoneNumbers {
                    let phone = phone.value.stringValue
                    if !phone.isEmpty {
                        phones.append(phone)
                    }
                }
                
                let people = PeopleMO(familyName: familyName, givenName: givenName, phone: phones)
                peoples.append(people)
            }
        } catch {
            "allPeople error: \(error.localizedDescription)".log()
        }
        
        closure(peoples)
    }
    
    /// 查询通讯录所有联系人
    ///
    /// - Parameters:
    ///   - vc: UIViewController
    ///   - closure: 联系人查询结果
    public static func allPeoples(_ vc: UIViewController, closure: @escaping AllPeoplesClosure) {
        authorizationStatus(vc) {
            if $0 {
                queryAllPeoples(vc, closure: {
                    closure($0)
                })
            }
        }
    }
    
}
