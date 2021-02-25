//
//  SettingViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/27.
//

import UIKit


class SettingViewController: UIViewController {
    
    // MARK: Property
    let app = App()
    let editPushNotificationDeviceRequest = EditPushNotificationDeviceRequest()
    let logoutRequest = LogoutRequest()
    let editUserPushRequest = EditUserPushRequest()
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Push
    lazy var pushTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림설정"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var pushStackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = .systemGray6
        sv.layer.cornerRadius = SPACE_XS
        sv.axis = .vertical
        sv.layoutMargins = UIEdgeInsets(top: SPACE_S, left: 0, bottom: SPACE_S, right: 0)
        sv.isLayoutMarginsRelativeArrangement = true
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_S
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var followPushView: PushView = {
        let pv = PushView()
        pv.actionMode = "FOLLOW"
        pv.label.text = "다른 사람이 나를 팔로우"
        pv.delegate = self
        return pv
    }()
    lazy var myPickCommentPushView: PushView = {
        let pv = PushView()
        pv.actionMode = "MY_PICK_COMMENT"
        pv.label.text = "새로운 댓글"
        pv.delegate = self
        return pv
    }()
    lazy var recommendedPlacePushView: PushView = {
        let pv = PushView()
        pv.actionMode = "RECOMMENDED_PLACE"
        pv.label.text = "인기 플레이스 추천"
        pv.delegate = self
        return pv
    }()
    lazy var adPushView: PushView = {
        let pv = PushView()
        pv.actionMode = "AD"
        pv.label.text = "광고 / 마케팅"
        pv.delegate = self
        return pv
    }()
    lazy var eventNoticePushView: PushView = {
        let pv = PushView()
        pv.actionMode = "EVENT_NOTICE"
        pv.label.text = "이벤트 / 공지사항"
        pv.delegate = self
        return pv
    }()
    
    // MARK: View - Service
    lazy var serviceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "고객센터"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var serviceStackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = .systemGray6
        sv.layer.cornerRadius = SPACE_XS
        sv.axis = .vertical
        sv.layoutMargins = UIEdgeInsets(top: SPACE_S, left: 0, bottom: SPACE_S, right: 0)
        sv.isLayoutMarginsRelativeArrangement = true
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_S
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var qnaButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("문의하기 / 피드백", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(qnaTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var agreementButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("서비스 이용약관", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(agreementTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("위치기반서비스 이용약관", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(locationTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var privacyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("개인정보 처리방침", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Etc
    lazy var etcTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기타"
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var etcStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.isLayoutMarginsRelativeArrangement = true
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_S
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var editUserIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "프로필 편집"
        ib.icon = "person"
        ib.addTarget(self, action: #selector(editUserTapped), for: .touchUpInside)
        return ib
    }()
    
    // MARK: View - Etc - Type
    lazy var typeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가입 유형"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Etc - Email
    lazy var emailContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Etc - Name
    lazy var nameContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 또는 닉네임"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View - Etc - Version
    lazy var versionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var versionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "버전정보"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var versionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Etc - Button
    lazy var logoutIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "로그아웃"
        ib.icon = "power"
        ib.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return ib
    }()
    lazy var leaveIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "회원탈퇴"
        ib.icon = "escape"
        ib.tintColor = .systemRed
        ib.imageView?.tintColor = .systemRed
        ib.addTarget(self, action: #selector(leaveTapped), for: .touchUpInside)
        return ib
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "설정"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        editPushNotificationDeviceRequest.delegate = self
        logoutRequest.delegate = self
        editUserPushRequest.delegate = self
        
        let user = app.getUser()
        
        if user.type == "KAKAO" { typeLabel.text = "카카오 로그인" }
        else if user.type == "APPLE" { typeLabel.text = "애플 로그인" }
        else if user.type == "NAVER" { typeLabel.text = "네이버 로그인" }
        else { typeLabel.text = "이메일 로그인" }
        
        if let email = user.email { emailLabel.text = email }
        if let name = user.name { nameLabel.text = name }
        
        let curVersionCode = app.getCurVersionCode()
        let curVersionName = app.getCurVersionName()
        let newVersionCode = app.getNewVersionCode()

        versionLabel.text = "IOS App ver. \(curVersionName)"

        if newVersionCode == curVersionCode {
            versionButton.setTitle("최신버전", for: .normal)
            versionButton.isEnabled = false
        } else {
            versionButton.setTitle("업데이트", for: .normal)
            versionButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
        }
        
        followPushView.sw.setOn((user.isAllowedFollow == "Y") ? true : false, animated: true)
        myPickCommentPushView.sw.setOn((user.isAllowedMyPickComment == "Y") ? true : false, animated: true)
        recommendedPlacePushView.sw.setOn((user.isAllowedRecommendedPlace == "Y") ? true : false, animated: true)
        adPushView.sw.setOn((user.isAllowedAd == "Y") ? true : false, animated: true)
        eventNoticePushView.sw.setOn((user.isAllowedEventNotice == "Y") ? true : false, animated: true)
        
//        let pndId = app.getPndId()
//
//        if pndId.isEmpty{
//            checkPushNotificationAvailable(allow: {
//                UIApplication.shared.registerForRemoteNotifications()
//            })
//        } else {
//            let isAllowedFollow = app.getPushNotification(key: "FOLLOW")
//            let isAllowedMyPickComment = app.getPushNotification(key: "MY_PICK_COMMENT")
//            let isAllowedRecommendedPlace = app.getPushNotification(key: "RECOMMENDED_PLACE")
//            let isAllowedAd = app.getPushNotification(key: "AD")
//            let isAllowedEventNotice = app.getPushNotification(key: "EVENT_NOTICE")
//
//            followPushView.sw.setOn((isAllowedFollow == "Y") ? true : false, animated: true)
//            myPickCommentPushView.sw.setOn((isAllowedMyPickComment == "Y") ? true : false, animated: true)
//            recommendedPlacePushView.sw.setOn((isAllowedRecommendedPlace == "Y") ? true : false, animated: true)
//            adPushView.sw.setOn((isAllowedAd == "Y") ? true : false, animated: true)
//            eventNoticePushView.sw.setOn((isAllowedEventNotice == "Y") ? true : false, animated: true)
//        }
    }
    
    // MARK: Function
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XL).isActive = true

        // MARK: ConfigureView - Push
        stackView.addArrangedSubview(pushTitleLabel)
        pushTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        pushTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        stackView.addArrangedSubview(pushStackView)
        pushStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        pushStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        pushStackView.addArrangedSubview(followPushView)
        followPushView.centerXAnchor.constraint(equalTo: pushStackView.centerXAnchor).isActive = true
        followPushView.widthAnchor.constraint(equalTo: pushStackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        pushStackView.addArrangedSubview(myPickCommentPushView)
        myPickCommentPushView.centerXAnchor.constraint(equalTo: pushStackView.centerXAnchor).isActive = true
        myPickCommentPushView.widthAnchor.constraint(equalTo: pushStackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        pushStackView.addArrangedSubview(recommendedPlacePushView)
        recommendedPlacePushView.centerXAnchor.constraint(equalTo: pushStackView.centerXAnchor).isActive = true
        recommendedPlacePushView.widthAnchor.constraint(equalTo: pushStackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        pushStackView.addArrangedSubview(adPushView)
        adPushView.centerXAnchor.constraint(equalTo: pushStackView.centerXAnchor).isActive = true
        adPushView.widthAnchor.constraint(equalTo: pushStackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        pushStackView.addArrangedSubview(eventNoticePushView)
        eventNoticePushView.centerXAnchor.constraint(equalTo: pushStackView.centerXAnchor).isActive = true
        eventNoticePushView.widthAnchor.constraint(equalTo: pushStackView.widthAnchor, multiplier: CONTENTS_RATIO_S).isActive = true
        
        // MARK: ConfigureView - Service
        stackView.addArrangedSubview(serviceTitleLabel)
        serviceTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        serviceTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        stackView.addArrangedSubview(serviceStackView)
        serviceStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        serviceStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        serviceStackView.addArrangedSubview(qnaButton)
        qnaButton.leadingAnchor.constraint(equalTo: serviceStackView.leadingAnchor).isActive = true
        qnaButton.trailingAnchor.constraint(equalTo: serviceStackView.trailingAnchor).isActive = true
        
        serviceStackView.addArrangedSubview(agreementButton)
        agreementButton.leadingAnchor.constraint(equalTo: serviceStackView.leadingAnchor).isActive = true
        agreementButton.trailingAnchor.constraint(equalTo: serviceStackView.trailingAnchor).isActive = true
        
        serviceStackView.addArrangedSubview(locationButton)
        locationButton.leadingAnchor.constraint(equalTo: serviceStackView.leadingAnchor).isActive = true
        locationButton.trailingAnchor.constraint(equalTo: serviceStackView.trailingAnchor).isActive = true
        
        serviceStackView.addArrangedSubview(privacyButton)
        privacyButton.leadingAnchor.constraint(equalTo: serviceStackView.leadingAnchor).isActive = true
        privacyButton.trailingAnchor.constraint(equalTo: serviceStackView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Etc
        stackView.addArrangedSubview(etcTitleLabel)
        etcTitleLabel.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        etcTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        stackView.addArrangedSubview(etcStackView)
        etcStackView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        etcStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        etcStackView.addArrangedSubview(editUserIconButton)
        editUserIconButton.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        editUserIconButton.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Etc - Type
        etcStackView.addArrangedSubview(typeContainerView)
        typeContainerView.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        typeContainerView.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
        
        typeContainerView.addSubview(typeTitleLabel)
        typeTitleLabel.topAnchor.constraint(equalTo: typeContainerView.topAnchor).isActive = true
        typeTitleLabel.leadingAnchor.constraint(equalTo: typeContainerView.leadingAnchor).isActive = true
        
        typeContainerView.addSubview(typeLabel)
        typeLabel.topAnchor.constraint(equalTo: typeTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        typeLabel.leadingAnchor.constraint(equalTo: typeContainerView.leadingAnchor).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: typeContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Etc - Email
        etcStackView.addArrangedSubview(emailContainerView)
        emailContainerView.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        emailContainerView.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
        
        emailContainerView.addSubview(emailTitleLabel)
        emailTitleLabel.topAnchor.constraint(equalTo: emailContainerView.topAnchor).isActive = true
        emailTitleLabel.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor).isActive = true
        
        emailContainerView.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: emailContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Etc - Name
        etcStackView.addArrangedSubview(nameContainerView)
        nameContainerView.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        nameContainerView.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
        
        nameContainerView.addSubview(nameTitleLabel)
        nameTitleLabel.topAnchor.constraint(equalTo: nameContainerView.topAnchor).isActive = true
        nameTitleLabel.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor).isActive = true
        
        nameContainerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: nameContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Etc - Version
        etcStackView.addArrangedSubview(versionContainerView)
        versionContainerView.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        versionContainerView.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
        
        versionContainerView.addSubview(versionTitleLabel)
        versionTitleLabel.topAnchor.constraint(equalTo: versionContainerView.topAnchor).isActive = true
        versionTitleLabel.leadingAnchor.constraint(equalTo: versionContainerView.leadingAnchor).isActive = true
        
        versionContainerView.addSubview(versionLabel)
        versionLabel.topAnchor.constraint(equalTo: versionTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        versionLabel.leadingAnchor.constraint(equalTo: versionContainerView.leadingAnchor).isActive = true
        versionLabel.bottomAnchor.constraint(equalTo: versionContainerView.bottomAnchor).isActive = true
        
        versionContainerView.addSubview(versionButton)
        versionButton.centerYAnchor.constraint(equalTo: versionContainerView.centerYAnchor).isActive = true
        versionButton.trailingAnchor.constraint(equalTo: versionContainerView.trailingAnchor).isActive = true
        
        // MARK: ConfigureView - Etc - Button
        etcStackView.addArrangedSubview(logoutIconButton)
        logoutIconButton.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        logoutIconButton.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
        
        etcStackView.addArrangedSubview(leaveIconButton)
        leaveIconButton.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        leaveIconButton.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func qnaTapped() {
        navigationController?.pushViewController(QnaViewController(), animated: true)
    }
    
    @objc func agreementTapped() {
        
    }
    
    @objc func locationTapped() {
        
    }
    
    @objc func privacyTapped() {
        
    }
    
    @objc func updateTapped() {
        
    }
    
    @objc func editUserTapped() {
        navigationController?.pushViewController(EditUserViewController(), animated: true)
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(title: "로그아웃", message: "'플레픽'으로부터 로그아웃을 합니다. 계속하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { (_) in
            self.logoutRequest.fetch(vc: self, paramDict: [:])
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func leaveTapped() {
        
    }
}


// MARK: PushView
extension SettingViewController: PushViewProtocol {
    func switching(actionMode: String) {
        let userDefaults = UserDefaults.standard
        
        var isAllowed = "N"
        if actionMode == "FOLLOW" {
            isAllowed = followPushView.sw.isOn ? "Y" : "N"
            userDefaults.set(isAllowed, forKey: "uIsAllowedFollow")
        }  else if actionMode == "MY_PICK_COMMENT" {
            isAllowed = myPickCommentPushView.sw.isOn ? "Y" : "N"
            userDefaults.set(isAllowed, forKey: "uIsAllowedMyPickComment")
        } else if actionMode == "RECOMMENDED_PLACE" {
            isAllowed = recommendedPlacePushView.sw.isOn ? "Y" : "N"
            userDefaults.set(isAllowed, forKey: "uIsAllowedRecommendedPlace")
        } else if actionMode == "AD" {
            isAllowed = adPushView.sw.isOn ? "Y" : "N"
            userDefaults.set(isAllowed, forKey: "uIsAllowedAd")
        } else if actionMode == "EVENT_NOTICE" {
            isAllowed = eventNoticePushView.sw.isOn ? "Y" : "N"
            userDefaults.set(isAllowed, forKey: "uIsAllowedEventNotice")
        }
        
        if isAllowed == "Y" {
            checkPushNotificationAvailable(allow: {
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
        
        editUserPushRequest.fetch(vc: self, paramDict: ["isAllowed": isAllowed, "actionMode": actionMode])
        
//        app.setPushNotification(key: actionMode, value: isAllowed)
//
//        let pndId = app.getPndId()
//        if pndId.isEmpty && isAllowed == "Y" {
//            checkPushNotificationAvailable(allow: {
//                UIApplication.shared.registerForRemoteNotifications()
//            })
//            return
//        }
//
//        editPushNotificationDeviceRequest.fetch(vc: self, paramDict: ["pndId": pndId, "isAllowed": isAllowed, "actionMode": actionMode])
    }
}

// MARK: HTTP - Logout
extension SettingViewController: LogoutRequestProtocol {
    func response(logout status: String) {
        print("[HTTP RES]", logoutRequest.apiUrl, status)
        
        if status == "OK" {
            app.logout()
            
            changeRootViewController(rootViewController: LoginViewController())
        }
    }
}

// MARK: HTTP - EditPushNotificationDevice
extension SettingViewController: EditPushNotificationDeviceRequestProtocol {
    func response(editPushNotificationDevice status: String) {
        print("[HTTP RES]", editPushNotificationDeviceRequest.apiUrl, status)
    }
}

// MARK: HTTP - EditUserPush
extension SettingViewController: EditUserPushRequestProtocol {
    func response(editUserPush status: String) {
        print("[HTTP RES]", editUserPushRequest.apiUrl, status)
    }
}
