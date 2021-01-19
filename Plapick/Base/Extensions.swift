//
//  Extensions.swift
//  Plapick
//
//  Created by 서원영 on 2020/12/28.
//

import UIKit
import SystemConfiguration


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
    
    func requestErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
        self.present(alert, animated: true, completion: nil)
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


// MARK: UIImage
extension UIImage {
    func resizeImage(size: CGSize) -> UIImage {
        let originalSize = self.size
        let ratio: CGFloat = {
            return originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) : 1 / (size.height / originalSize.height)
        }()
        return UIImage(cgImage: self.cgImage!, scale: self.scale * ratio, orientation: self.imageOrientation)
    }
}
