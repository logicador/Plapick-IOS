//
//  AppDelegate.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import KakaoSDKCommon


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let addUserDeviceRequest = AddUserDeviceRequest()
    let addPushNotificationDeviceRequest = AddPushNotificationDeviceRequest()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        KakaoSDKCommon.initSDK(appKey: KAKAO_NATIVE_APP_KEY)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02x", $1)})
        
//        let app = App()
//        app.setPndId(pndId: deviceTokenString)
//        addPushNotificationDeviceRequest.delegate = self
//        addPushNotificationDeviceRequest.fetch(isShowAlert: false, paramDict: ["device" : deviceTokenString])
        
        addUserDeviceRequest.delegate = self
        addUserDeviceRequest.fetch(paramDict: ["device": deviceTokenString])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}


// MARK: HTTP - AddUserDevice
extension AppDelegate: AddUserDeviceRequestProtocol {
    func response(addUserDevice status: String) {
        print("[HTTP RES]", addUserDeviceRequest.apiUrl, status)
    }
}
