//
//  SettingViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/27.
//

import UIKit


protocol SettingViewControllerProtocol {
    func closeSettingVC()
}


class SettingViewController: UIViewController {
    
    // MARK: Property
    var delegate: SettingViewControllerProtocol?
    let app = App()
    let editPushNotificationDeviceRequest = EditPushNotificationDeviceRequest()
    let logoutRequest = LogoutRequest()
//    var authAccountVC: AccountViewController?
    var isOpenedChildVC: Bool = false
    
    
    // MARK: View
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Push
    lazy var pushTitleView: TitleView = {
        let tv = TitleView(text: "알림설정", style: .medium)
        return tv
    }()
    lazy var pushContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    lazy var serviceTitleView: TitleView = {
        let tv = TitleView(text: "고객센터", style: .medium)
        return tv
    }()
    lazy var serviceContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var qaButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("문의하기 / 피드백", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(qaTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var agreementButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("서비스 이용약관", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(agreementTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var locationButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("위치기반서비스 이용약관", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(locationTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var privacyButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("개인정보 처리방침", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(privacyTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Etc
    lazy var etcTitleView: TitleView = {
        let tv = TitleView(text: "기타", style: .medium)
        return tv
    }()
    lazy var etcContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: View - Etc - Personal
    lazy var personalContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가입 유형"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이름 또는 닉네임"
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // TODO: 이메일 회원이라면 비밀번호 변경도 (변경시 현재 비밀번호 인증 필요)
    
    // MARK: View - Etc - Version
    lazy var versionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var versionButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Etc - Other
    lazy var editUserButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("프로필 편집", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(editUserTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("로그아웃", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(logoutTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var leaveButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("회원탈퇴", for: UIControl.State.normal)
        button.tintColor = .systemRed
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.contentEdgeInsets = UIEdgeInsets(top: SPACE_XS, left: 0, bottom: SPACE_XS, right: 0)
        button.addTarget(self, action: #selector(leaveTapped), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "설정"
        
        isModalInPresentation = true // 후....
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
        editPushNotificationDeviceRequest.delegate = self
        logoutRequest.delegate = self
        
        let user = app.getUser()
        if let type = user.type {
            if type == "KAKAO" {
                typeLabel.text = "카카오 로그인"
            } else if type == "APPLE" {
                typeLabel.text = "애플 로그인"
            } else if type == "NAVER" {
                typeLabel.text = "네이버 로그인"
            } else {
                typeLabel.text = "이메일 로그인"
            }
        }
        if let email = user.email {
            emailLabel.text = email
        }
        if let name = user.name {
            nameLabel.text = name
        }
        
        let curVersionCode = app.getCurVersionCode()
        let curVersionName = app.getCurVersionName()
        let newVersionCode = app.getNewVersionCode()
        
        versionLabel.text = "IOS App ver. \(curVersionName)"
        
        if newVersionCode == curVersionCode {
            versionButton.setTitle("최신버전", for: UIControl.State.normal)
            versionButton.isEnabled = false
        } else {
            versionButton.setTitle("업데이트", for: UIControl.State.normal)
            versionButton.addTarget(self, action: #selector(updateTapped), for: UIControl.Event.touchUpInside)
        }
        
        let pndId = app.getPndId()
        
        if pndId.isEmpty {
            app.checkPushNotificationAvailable(vc: self)
            
        } else {
            let isAllowedFollow = app.getPushNotification(key: "FOLLOW")
            let isAllowedMyPickComment = app.getPushNotification(key: "MY_PICK_COMMENT")
            let isAllowedRecommendedPlace = app.getPushNotification(key: "RECOMMENDED_PLACE")
            let isAllowedAd = app.getPushNotification(key: "AD")
            let isAllowedEventNotice = app.getPushNotification(key: "EVENT_NOTICE")
            
            followPushView.push.setOn((isAllowedFollow == "Y") ? true : false, animated: true)
            myPickCommentPushView.push.setOn((isAllowedMyPickComment == "Y") ? true : false, animated: true)
            recommendedPlacePushView.push.setOn((isAllowedRecommendedPlace == "Y") ? true : false, animated: true)
            adPushView.push.setOn((isAllowedAd == "Y") ? true : false, animated: true)
            eventNoticePushView.push.setOn((isAllowedEventNotice == "Y") ? true : false, animated: true)
        }
    }
    
    
    // MARK: ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isOpenedChildVC {
            delegate?.closeSettingVC()
        }
    }
    
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        // MARK: ConfigureView - Push
        contentView.addSubview(pushTitleView)
        pushTitleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        pushTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pushTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(pushContainerView)
        pushContainerView.topAnchor.constraint(equalTo: pushTitleView.bottomAnchor).isActive = true
        pushContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        pushContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        pushContainerView.addSubview(followPushView)
        followPushView.topAnchor.constraint(equalTo: pushContainerView.topAnchor, constant: SPACE_XS).isActive = true
        followPushView.leadingAnchor.constraint(equalTo: pushContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        followPushView.trailingAnchor.constraint(equalTo: pushContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        
        pushContainerView.addSubview(myPickCommentPushView)
        myPickCommentPushView.topAnchor.constraint(equalTo: followPushView.bottomAnchor).isActive = true
        myPickCommentPushView.leadingAnchor.constraint(equalTo: pushContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        myPickCommentPushView.trailingAnchor.constraint(equalTo: pushContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        
        contentView.addSubview(recommendedPlacePushView)
        recommendedPlacePushView.topAnchor.constraint(equalTo: myPickCommentPushView.bottomAnchor).isActive = true
        recommendedPlacePushView.leadingAnchor.constraint(equalTo: pushContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        recommendedPlacePushView.trailingAnchor.constraint(equalTo: pushContainerView.trailingAnchor, constant: -SPACE_S).isActive = true

        contentView.addSubview(adPushView)
        adPushView.topAnchor.constraint(equalTo: recommendedPlacePushView.bottomAnchor).isActive = true
        adPushView.leadingAnchor.constraint(equalTo: pushContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        adPushView.trailingAnchor.constraint(equalTo: pushContainerView.trailingAnchor, constant: -SPACE_S).isActive = true

        contentView.addSubview(eventNoticePushView)
        eventNoticePushView.topAnchor.constraint(equalTo: adPushView.bottomAnchor).isActive = true
        eventNoticePushView.leadingAnchor.constraint(equalTo: pushContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        eventNoticePushView.trailingAnchor.constraint(equalTo: pushContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        eventNoticePushView.bottomAnchor.constraint(equalTo: pushContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        // MARK: ConfigureView - Service
        contentView.addSubview(serviceTitleView)
        serviceTitleView.topAnchor.constraint(equalTo: pushContainerView.bottomAnchor).isActive = true
        serviceTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        serviceTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(serviceContainerView)
        serviceContainerView.topAnchor.constraint(equalTo: serviceTitleView.bottomAnchor).isActive = true
        serviceContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        serviceContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        
        serviceContainerView.addSubview(qaButton)
        qaButton.topAnchor.constraint(equalTo: serviceContainerView.topAnchor, constant: SPACE_XS).isActive = true
        qaButton.leadingAnchor.constraint(equalTo: serviceContainerView.leadingAnchor).isActive = true
        qaButton.trailingAnchor.constraint(equalTo: serviceContainerView.trailingAnchor).isActive = true
        
        serviceContainerView.addSubview(agreementButton)
        agreementButton.topAnchor.constraint(equalTo: qaButton.bottomAnchor).isActive = true
        agreementButton.leadingAnchor.constraint(equalTo: serviceContainerView.leadingAnchor).isActive = true
        agreementButton.trailingAnchor.constraint(equalTo: serviceContainerView.trailingAnchor).isActive = true

        serviceContainerView.addSubview(locationButton)
        locationButton.topAnchor.constraint(equalTo: agreementButton.bottomAnchor).isActive = true
        locationButton.leadingAnchor.constraint(equalTo: serviceContainerView.leadingAnchor).isActive = true
        locationButton.trailingAnchor.constraint(equalTo: serviceContainerView.trailingAnchor).isActive = true

        serviceContainerView.addSubview(privacyButton)
        privacyButton.topAnchor.constraint(equalTo: locationButton.bottomAnchor).isActive = true
        privacyButton.leadingAnchor.constraint(equalTo: serviceContainerView.leadingAnchor).isActive = true
        privacyButton.trailingAnchor.constraint(equalTo: serviceContainerView.trailingAnchor).isActive = true
        privacyButton.bottomAnchor.constraint(equalTo: serviceContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
        
        // MARK: ConfigureView - Etc
        contentView.addSubview(etcTitleView)
        etcTitleView.topAnchor.constraint(equalTo: serviceContainerView.bottomAnchor).isActive = true
        etcTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        etcTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(etcContainerView)
        etcContainerView.topAnchor.constraint(equalTo: etcTitleView.bottomAnchor).isActive = true
        etcContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        etcContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: CONTENTS_RATIO).isActive = true
        etcContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Etc - Personal
        etcContainerView.addSubview(personalContainerView)
        personalContainerView.topAnchor.constraint(equalTo: etcContainerView.topAnchor, constant: SPACE_XS).isActive = true
        personalContainerView.leadingAnchor.constraint(equalTo: etcContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        personalContainerView.trailingAnchor.constraint(equalTo: etcContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        
        personalContainerView.addSubview(typeTitleLabel)
        typeTitleLabel.topAnchor.constraint(equalTo: personalContainerView.topAnchor, constant: SPACE_XS).isActive = true
        typeTitleLabel.leadingAnchor.constraint(equalTo: personalContainerView.leadingAnchor).isActive = true
        typeTitleLabel.trailingAnchor.constraint(equalTo: personalContainerView.trailingAnchor).isActive = true
        
        personalContainerView.addSubview(typeLabel)
        typeLabel.topAnchor.constraint(equalTo: typeTitleLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        typeLabel.leadingAnchor.constraint(equalTo: personalContainerView.leadingAnchor).isActive = true
        typeLabel.trailingAnchor.constraint(equalTo: personalContainerView.trailingAnchor).isActive = true
        
        personalContainerView.addSubview(emailTitleLabel)
        emailTitleLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: SPACE).isActive = true
        emailTitleLabel.leadingAnchor.constraint(equalTo: personalContainerView.leadingAnchor).isActive = true
        emailTitleLabel.trailingAnchor.constraint(equalTo: personalContainerView.trailingAnchor).isActive = true
        
        personalContainerView.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: personalContainerView.leadingAnchor).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: personalContainerView.trailingAnchor).isActive = true
        
        personalContainerView.addSubview(nameTitleLabel)
        nameTitleLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: SPACE).isActive = true
        nameTitleLabel.leadingAnchor.constraint(equalTo: personalContainerView.leadingAnchor).isActive = true
        nameTitleLabel.trailingAnchor.constraint(equalTo: personalContainerView.trailingAnchor).isActive = true
        
        personalContainerView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: SPACE_XXXS).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: personalContainerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: personalContainerView.trailingAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: personalContainerView.bottomAnchor).isActive = true
        
        // MARK: ConfigureView - Etc - Version
        etcContainerView.addSubview(versionContainerView)
        versionContainerView.topAnchor.constraint(equalTo: personalContainerView.bottomAnchor, constant: SPACE_XS).isActive = true
        versionContainerView.leadingAnchor.constraint(equalTo: etcContainerView.leadingAnchor, constant: SPACE_S).isActive = true
        versionContainerView.trailingAnchor.constraint(equalTo: etcContainerView.trailingAnchor, constant: -SPACE_S).isActive = true
        
        versionContainerView.addSubview(versionButton)
        versionButton.topAnchor.constraint(equalTo: versionContainerView.topAnchor).isActive = true
        versionButton.trailingAnchor.constraint(equalTo: versionContainerView.trailingAnchor).isActive = true
        versionButton.bottomAnchor.constraint(equalTo: versionContainerView.bottomAnchor).isActive = true
        
        versionContainerView.addSubview(versionLabel)
        versionLabel.leadingAnchor.constraint(equalTo: versionContainerView.leadingAnchor).isActive = true
        versionLabel.centerYAnchor.constraint(equalTo: versionContainerView.centerYAnchor).isActive = true
        
        // MARK: ConfigureView - Etc - Other
        etcContainerView.addSubview(editUserButton)
        editUserButton.topAnchor.constraint(equalTo: versionContainerView.bottomAnchor).isActive = true
        editUserButton.leadingAnchor.constraint(equalTo: etcContainerView.leadingAnchor).isActive = true
        editUserButton.trailingAnchor.constraint(equalTo: etcContainerView.trailingAnchor).isActive = true
        
        etcContainerView.addSubview(logoutButton)
        logoutButton.topAnchor.constraint(equalTo: editUserButton.bottomAnchor).isActive = true
        logoutButton.leadingAnchor.constraint(equalTo: etcContainerView.leadingAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: etcContainerView.trailingAnchor).isActive = true

        etcContainerView.addSubview(leaveButton)
        leaveButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor).isActive = true
        leaveButton.leadingAnchor.constraint(equalTo: etcContainerView.leadingAnchor).isActive = true
        leaveButton.trailingAnchor.constraint(equalTo: etcContainerView.trailingAnchor).isActive = true
        leaveButton.bottomAnchor.constraint(equalTo: etcContainerView.bottomAnchor, constant: -SPACE_XS).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func qaTapped() {
        
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
        isOpenedChildVC = true
        let editUserVC = EditUserViewController()
//        editUserVC.authAccountVC = authAccountVC
        editUserVC.delegate = self
        navigationController?.pushViewController(editUserVC, animated: true)
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(title: "로그아웃", message: "'플레픽'으로부터 로그아웃을 합니다. 계속하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: UIAlertAction.Style.destructive, handler: { (_) in
            self.logoutRequest.fetch(vc: self, paramDict: [:])
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func leaveTapped() {
        
    }
}

// MARK: Extension - PushView
extension SettingViewController: PushViewProtocol {
    func switching(actionMode: String) {
        var isAllowed = "N"
        if actionMode == "FOLLOW" {
            isAllowed = followPushView.push.isOn ? "Y" : "N"
        } else if actionMode == "MY_PICK_COMMENT" {
            isAllowed = myPickCommentPushView.push.isOn ? "Y" : "N"
        } else if actionMode == "RECOMMENDED_PLACE" {
            isAllowed = recommendedPlacePushView.push.isOn ? "Y" : "N"
        } else if actionMode == "AD" {
            isAllowed = adPushView.push.isOn ? "Y" : "N"
        } else if actionMode == "EVENT_NOTICE" {
            isAllowed = eventNoticePushView.push.isOn ? "Y" : "N"
        }
        
        app.setPushNotification(key: actionMode, value: isAllowed)
        
        let pndId = app.getPndId()
        if pndId.isEmpty && isAllowed == "Y" {
            app.checkPushNotificationAvailable(vc: self)
            return
        }
        
        editPushNotificationDeviceRequest.fetch(vc: self, paramDict: ["pndId": pndId, "isAllowed": isAllowed, "actionMode": actionMode])
    }
}

// MARK: Extension - EditPushNotificationDevice
extension SettingViewController: EditPushNotificationDeviceRequestProtocol {
    func response(editPushNotificationDevice status: String) {
        // nothing to do...
    }
}

// MARK: Extension - Logout
extension SettingViewController: LogoutRequestProtocol {
    func response(logout status: String) {
        if status == "OK" {
            changeRootViewController(rootViewController: LoginViewController())
        }
    }
}

// MARK: Extension - EditUserVC
extension SettingViewController: EditUserViewControllerProtocol {
    func closeEditUserVC() {
        isOpenedChildVC = false
    }
}
