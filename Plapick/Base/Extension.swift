//
//  Extensions.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import SystemConfiguration
import SDWebImage


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
        let urlString = ((profileImage.contains(String(uId))) ? (PLAPICK_URL + profileImage) : profileImage)
        if urlString.isEmpty {
            self.image = nil
        } else {
            if let url = URL(string: urlString) {
                self.sd_setImage(with: url, completed: nil)
            }
        }
    }
}


//extension UIImageView {
//    func load(urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}


//extension UIViewController {
//    
//    // 한번 dismiss로 안됨.. why?
//    func dismissWithAnim() {
//        self.dismiss(animated: true) {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//}


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
    
    func hideKeyboardWhenTappedAround() {
        // onClick 이벤트 추가하기
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // 이거 해주면 버튼같은 component 눌러도 실행됨
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        // 키보드 숨기는거
        view.endEditing(true)
    }
    
    func requestSettingAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
        alert.addAction(UIAlertAction(title: "설정", style: UIAlertAction.Style.default, handler: { (_) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestErrorAlert(title: String?, message: String? = "오류가 발생했습니다. 고객센터에 문의해주세요.\n\n평일 10:00-17:00\n15xx-xxxx", buttonText: String = "확인", handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertAction.Style.cancel, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNetworkAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "네트워크 오류", message: "네트워크가 연결중인지 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "닫기", style: UIAlertAction.Style.cancel))
            alert.addAction(UIAlertAction(title: "다시시도", style: UIAlertAction.Style.default, handler: { (_) in
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
        idv.removeView()
        bov.removeView()
    }
    
    func isValidStrLength(max: Int, kMin: Int, kMax: Int, value: String) -> Bool {
        let cnt = value.count
        let utf8Cnt = value.utf8.count
        if utf8Cnt >= (kMin * 3) && utf8Cnt <= (kMax * 3) {
            if cnt <= max {
                return true
            } else { return false }
        } else { return false }
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
}


// MARK: NSMutableAttributedString
extension NSMutableAttributedString {
    func bold(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }

    func normal(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
    
    func thin(_ text: String, fontSize: CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize, weight: .thin)]
        self.append(NSMutableAttributedString(string: text, attributes: attrs))
        return self
    }
}
