//
//  Extensions.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import SystemConfiguration
import SDWebImage
import Photos


// MARK: UIColor
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    var inverted: UIColor {
        var a: CGFloat = 0.0, r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0
        return getRed(&r, green: &g, blue: &b, alpha: &a) ? UIColor(red: 1.0-r, green: 1.0-g, blue: 1.0-b, alpha: a) : .black
    }
    
    static let mainColor = UIColor(hexString: "#F8A13F")
}


// MARK: UIImageView
extension UIImageView {
    func setProfileImage(uId: Int, profileImage: String) {
        if profileImage.isEmpty { image = nil }
        else {
            let urlString = ((profileImage.contains(String(uId))) ? (PLAPICK_URL + profileImage) : profileImage)
            if urlString.isEmpty { image = nil }
            else {
                guard let url = URL(string: urlString) else { return }
                sd_setImage(with: url, completed: nil)
            }
        }
    }
}


// MARK: UIScrollView
extension UIScrollView {
    func resize() {
        var contentRect = CGRect.zero
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}


// MARK: UIView
extension UIView {
    func removeAllChildView() {
        for view in self.subviews {
            NSLayoutConstraint.deactivate(view.constraints)
            view.removeFromSuperview()
        }
    }
    
    func removeView() {
        NSLayoutConstraint.deactivate(self.constraints)
        self.removeFromSuperview()
    }
}


// MARK: UIViewController
extension UIViewController {
    func changeRootViewController(rootViewController: UIViewController, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.type = .fade
        transition.duration = duration
        view.window?.layer.add(transition, forKey: kCATransition)
        self.view.window?.rootViewController = rootViewController
        view.window?.makeKeyAndVisible()
    }
    
    func checkPushNotificationAvailable(allow: (() -> Void)?) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (isAllowed, error) in DispatchQueue.main.async {
            if let _ = error {
                self.requestSettingAlert(title: "알림 액세스 허용하기", message: "'플레픽'에서 알림을 보내고자 합니다.")
                return
            }
            
            if isAllowed {
                allow?()
            } else {
                self.requestSettingAlert(title: "알림 액세스 허용하기", message: "'플레픽'에서 알림을 보내고자 합니다.")
            }
        }})
    }
    
    func checkPhotoGallaryAvailable(allow: (() -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined || status == .denied {
            PHPhotoLibrary.requestAuthorization({ (status) in DispatchQueue.main.async {
                if status == .notDetermined || status == .denied {
                    self.requestSettingAlert(title: "앨범 액세스 허용하기", message: "'플레픽'에서 앨범에 접근하고자 합니다.")
                    return
                }
                allow?()
            }})
            return
        }
        allow?()
    }
    
    func hideKeyboardWhenTappedAround() {
//        // onClick 이벤트 추가하기
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        // 이거 해주면 버튼같은 component 눌러도 실행됨
//        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        if let _ = navigationItem.searchController?.searchBar.isFirstResponder {
            navigationItem.searchController?.searchBar.resignFirstResponder()
        }
        view.endEditing(true)
    }
    
    func requestSettingAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { (_) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestErrorAlert(title: String?, message: String? = "오류가 발생했습니다. 오류코드와 함께 고객센터에 문의해주세요.\n\n문의메일\ninfo.plapick@gmail.com", buttonText: String = "확인", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .cancel, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNetworkAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "네트워크 오류", message: "네트워크가 연결중인지 확인해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
            alert.addAction(UIAlertAction(title: "다시시도", style: .default, handler: { (_) in
                self.changeRootViewController(rootViewController: LaunchViewController())
            }))
            self.present(alert, animated: true)
        }
    }
    
    func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showIndicator(idv: UIActivityIndicatorView, bov: UIVisualEffectView) {
        view.addSubview(bov)
        bov.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bov.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bov.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bov.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        view.addSubview(idv)
        idv.centerXAnchor.constraint(equalTo: bov.centerXAnchor).isActive = true
        idv.centerYAnchor.constraint(equalTo: bov.centerYAnchor).isActive = true
        idv.startAnimating()
    }
    func hideIndicator(idv: UIActivityIndicatorView, bov: UIVisualEffectView) {
        idv.stopAnimating()
        idv.removeFromSuperview()
        bov.removeFromSuperview()
    }
    
    func showToast(tv: UIView, tcl: UILabel, text: String) {
        if !tv.isHidden { return }
        
        tcl.text = text
        
        view.addSubview(tv)
        tv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tv.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(SCREEN_WIDTH / 4)).isActive = true
        
        tv.addSubview(tcl)
        tcl.topAnchor.constraint(equalTo: tv.topAnchor, constant: SPACE_S).isActive = true
        tcl.leadingAnchor.constraint(equalTo: tv.leadingAnchor, constant: SPACE_S).isActive = true
        tcl.trailingAnchor.constraint(equalTo: tv.trailingAnchor, constant: -SPACE_S).isActive = true
        tcl.bottomAnchor.constraint(equalTo: tv.bottomAnchor, constant: -SPACE_S).isActive = true
        
        tv.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            tv.alpha = 1
        }, completion: { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
                self.hideToast(tv: tv, tcl: tcl)
            }
        })
    }
    func hideToast(tv: UIView, tcl: UILabel) {
        if tv.isHidden { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            tv.alpha = 0
        }, completion: { (_) in
            tv.isHidden = true
            tcl.removeFromSuperview()
            tv.removeFromSuperview()
        })
    }
}


extension UIViewController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}


// MARK: UILabel
extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
    func getHeight() -> CGFloat {
        return ("1" as NSString).size(withAttributes: [.font : font!]).height
    }
    
    func getLineCnt() -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = text! as NSString

        let rect = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil)

        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }
}


// MARK: NSMutableAttributedString
extension NSMutableAttributedString {
    func bold(_ text: String, size: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
        var attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: size)]
        if let color = color { attrs[.foregroundColor] = color }
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }

    func normal(_ text: String, size: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
        var attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size)]
        if let color = color { attrs[.foregroundColor] = color }
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
    
    func thin(_ text: String, size: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
        var attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: size, weight: .thin)]
        if let color = color { attrs[.foregroundColor] = color }
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
}


// MARK: String
extension String {
    func toCategory() -> String {
        if trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "-" }
        if let splittedCategoryName = split(separator: ">").last {
            let str = String(splittedCategoryName).trimmingCharacters(in: .whitespacesAndNewlines)
            if str.isEmpty { return "-" }
            else { return str }
        }
        return "-"
    }
}
