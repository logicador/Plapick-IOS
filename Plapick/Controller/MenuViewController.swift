//
//  MenuViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/27.
//

import UIKit


protocol MenuViewControllerProtocol {
    func editProfile()
}


class MenuViewController: UIViewController {
    
    // MARK: Property
    var delegate: MenuViewControllerProtocol?
    let app = App()
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
        sv.spacing = SPACE_XXL
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - User
    lazy var userContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var userTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사용자"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var userStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var editUserIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "프로필 편집"
        ib.icon = "person.crop.circle.fill"
        ib.addTarget(self, action: #selector(editUserTapped), for: .touchUpInside)
        return ib
    }()
    lazy var commentIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "작성한 댓글"
        ib.icon = "message.circle.fill"
        ib.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        return ib
    }()
    lazy var likeIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "좋아요"
        ib.icon = "heart.circle.fill"
        ib.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        return ib
    }()
//    lazy var blockUserIconButton: IconButton = {
//        let ib = IconButton(type: .system)
//        ib.text = "차단한 사용자"
//        ib.icon = "person.crop.circle.fill.badge.xmark"
//        ib.addTarget(self, action: #selector(blockUserTapped), for: .touchUpInside)
//        return ib
//    }()
//    lazy var blockPostsIconButton: IconButton = {
//        let ib = IconButton(type: .system)
//        ib.text = "차단한 게시물"
//        ib.icon = "xmark.bin.circle.fill"
//        ib.addTarget(self, action: #selector(blockPostsTapped), for: .touchUpInside)
//        return ib
//    }()
    
    // MARK: View - Push
    lazy var pushContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var pushTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림설정"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var pushStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var isAllowedAdPushView: PushView = {
        let pv = PushView()
        pv.actionMode = "AD"
        pv.label.text = "광고 및 이벤트"
        pv.delegate = self
        return pv
    }()
    lazy var isAllowedPostsCommentPushView: PushView = {
        let pv = PushView()
        pv.actionMode = "POSTS_COMMENT"
        pv.label.text = "내 게시물의 다른사람 댓글"
        pv.delegate = self
        return pv
    }()
    lazy var isAllowedFollowedPushView: PushView = {
        let pv = PushView()
        pv.actionMode = "FOLLOWED"
        pv.label.text = "다른사람이 나를 팔로우"
        pv.delegate = self
        return pv
    }()
    lazy var isAllowedReCommentPushView: PushView = {
        let pv = PushView()
        pv.actionMode = "RE_COMMENT"
        pv.label.text = "댓글에서 나를 언급"
        pv.delegate = self
        return pv
    }()
    
    // MARK: View - Service
    lazy var serviceContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var serviceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "고객센터"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var serviceStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    lazy var qnaIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "1:1 문의"
        ib.icon = "headphones.circle.fill"
        ib.addTarget(self, action: #selector(qnaTapped), for: .touchUpInside)
        return ib
    }()
//    lazy var reportIconButton: IconButton = {
//        let ib = IconButton(type: .system)
//        ib.text = "신고내역"
//        ib.icon = "exclamationmark.circle.fill"
//        ib.addTarget(self, action: #selector(reportTapped), for: .touchUpInside)
//        return ib
//    }()
    lazy var agreementIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "서비스 이용약관"
        ib.icon = "info.circle.fill"
        ib.addTarget(self, action: #selector(agreementTapped), for: .touchUpInside)
        return ib
    }()
    lazy var privacyIconButton: IconButton = {
        let ib = IconButton(type: .system)
        ib.text = "개인정보 처리방침"
        ib.icon = "lock.circle.fill"
        ib.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        return ib
    }()
    
    // MARK: View - Etc
    lazy var etcContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var etcTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기타"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var etcStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = SPACE_XS
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: View - Etc - UserType
    lazy var userTypeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var userTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가입 유형"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var userTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
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
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var versionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: View - Etc - Other
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
        
        navigationItem.title = "메뉴"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        configureView()
        
        setThemeColor()
        
//        editPushNotificationDeviceRequest.delegate = self
        logoutRequest.delegate = self
        editUserPushRequest.delegate = self
        
        let user = app.getUser()
        
        if user.u_type == "KAKAO" { userTypeLabel.text = "카카오 로그인" }
        else if user.u_type == "APPLE" { userTypeLabel.text = "애플 로그인" }
        else if user.u_type == "NAVER" { userTypeLabel.text = "네이버 로그인" }
        else if user.u_type == "FACEBOOK" { userTypeLabel.text = "페이스북 로그인" }
        else { userTypeLabel.text = "이메일 로그인" }
        
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
        
        isAllowedAdPushView.sw.setOn((user.u_is_allowed_push_ad == "Y") ? true : false, animated: true)
        isAllowedPostsCommentPushView.sw.setOn((user.u_is_allowed_push_posts_comment == "Y") ? true : false, animated: true)
        isAllowedFollowedPushView.sw.setOn((user.u_is_allowed_push_followed == "Y") ? true : false, animated: true)
        isAllowedReCommentPushView.sw.setOn((user.u_is_allowed_push_re_comment == "Y") ? true : false, animated: true)
    }
    
    // MARK: Function
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) { setThemeColor() }
    func setThemeColor() {
        view.backgroundColor = (traitCollection.userInterfaceStyle == .dark) ? .black : .white
    }
    
    func configureView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: SPACE_XXL).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -SPACE_XXL).isActive = true
        
        // MARK: Configure - User
        stackView.addArrangedSubview(userContainerView)
        userContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        userContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        userContainerView.addSubview(userTitleLabel)
        userTitleLabel.topAnchor.constraint(equalTo: userContainerView.topAnchor).isActive = true
        userTitleLabel.leadingAnchor.constraint(equalTo: userContainerView.leadingAnchor).isActive = true
        userTitleLabel.trailingAnchor.constraint(equalTo: userContainerView.trailingAnchor).isActive = true
        
        userContainerView.addSubview(userStackView)
        userStackView.topAnchor.constraint(equalTo: userTitleLabel.bottomAnchor, constant: SPACE_S).isActive = true
        userStackView.leadingAnchor.constraint(equalTo: userContainerView.leadingAnchor).isActive = true
        userStackView.trailingAnchor.constraint(equalTo: userContainerView.trailingAnchor).isActive = true
        userStackView.bottomAnchor.constraint(equalTo: userContainerView.bottomAnchor).isActive = true
        
        userStackView.addArrangedSubview(editUserIconButton)
        editUserIconButton.leadingAnchor.constraint(equalTo: userStackView.leadingAnchor).isActive = true
        editUserIconButton.trailingAnchor.constraint(equalTo: userStackView.trailingAnchor).isActive = true
        
        userStackView.addArrangedSubview(commentIconButton)
        commentIconButton.leadingAnchor.constraint(equalTo: userStackView.leadingAnchor).isActive = true
        commentIconButton.trailingAnchor.constraint(equalTo: userStackView.trailingAnchor).isActive = true
        
        userStackView.addArrangedSubview(likeIconButton)
        likeIconButton.leadingAnchor.constraint(equalTo: userStackView.leadingAnchor).isActive = true
        likeIconButton.trailingAnchor.constraint(equalTo: userStackView.trailingAnchor).isActive = true
        
//        userStackView.addArrangedSubview(blockUserIconButton)
//        blockUserIconButton.leadingAnchor.constraint(equalTo: userStackView.leadingAnchor).isActive = true
//        blockUserIconButton.trailingAnchor.constraint(equalTo: userStackView.trailingAnchor).isActive = true
//
//        userStackView.addArrangedSubview(blockPostsIconButton)
//        blockPostsIconButton.leadingAnchor.constraint(equalTo: userStackView.leadingAnchor).isActive = true
//        blockPostsIconButton.trailingAnchor.constraint(equalTo: userStackView.trailingAnchor).isActive = true
        
        // MARK: Configure- Push
        stackView.addArrangedSubview(pushContainerView)
        pushContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        pushContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        pushContainerView.addSubview(pushTitleLabel)
        pushTitleLabel.topAnchor.constraint(equalTo: pushContainerView.topAnchor).isActive = true
        pushTitleLabel.leadingAnchor.constraint(equalTo: pushContainerView.leadingAnchor).isActive = true
        pushTitleLabel.trailingAnchor.constraint(equalTo: pushContainerView.trailingAnchor).isActive = true
        
        pushContainerView.addSubview(pushStackView)
        pushStackView.topAnchor.constraint(equalTo: pushTitleLabel.bottomAnchor, constant: SPACE_S).isActive = true
        pushStackView.leadingAnchor.constraint(equalTo: pushContainerView.leadingAnchor).isActive = true
        pushStackView.trailingAnchor.constraint(equalTo: pushContainerView.trailingAnchor).isActive = true
        pushStackView.bottomAnchor.constraint(equalTo: pushContainerView.bottomAnchor).isActive = true
        
        pushStackView.addArrangedSubview(isAllowedAdPushView)
        isAllowedAdPushView.leadingAnchor.constraint(equalTo: pushStackView.leadingAnchor).isActive = true
        isAllowedAdPushView.trailingAnchor.constraint(equalTo: pushStackView.trailingAnchor).isActive = true
        
        pushStackView.addArrangedSubview(isAllowedPostsCommentPushView)
        isAllowedPostsCommentPushView.leadingAnchor.constraint(equalTo: pushStackView.leadingAnchor).isActive = true
        isAllowedPostsCommentPushView.trailingAnchor.constraint(equalTo: pushStackView.trailingAnchor).isActive = true
        
        pushStackView.addArrangedSubview(isAllowedFollowedPushView)
        isAllowedFollowedPushView.leadingAnchor.constraint(equalTo: pushStackView.leadingAnchor).isActive = true
        isAllowedFollowedPushView.trailingAnchor.constraint(equalTo: pushStackView.trailingAnchor).isActive = true
        
        pushStackView.addArrangedSubview(isAllowedReCommentPushView)
        isAllowedReCommentPushView.leadingAnchor.constraint(equalTo: pushStackView.leadingAnchor).isActive = true
        isAllowedReCommentPushView.trailingAnchor.constraint(equalTo: pushStackView.trailingAnchor).isActive = true
        
        // MARK: Configure - Service
        stackView.addArrangedSubview(serviceContainerView)
        serviceContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        serviceContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        serviceContainerView.addSubview(serviceTitleLabel)
        serviceTitleLabel.topAnchor.constraint(equalTo: serviceContainerView.topAnchor).isActive = true
        serviceTitleLabel.leadingAnchor.constraint(equalTo: serviceContainerView.leadingAnchor).isActive = true
        serviceTitleLabel.trailingAnchor.constraint(equalTo: serviceContainerView.trailingAnchor).isActive = true
        
        serviceContainerView.addSubview(serviceStackView)
        serviceStackView.topAnchor.constraint(equalTo: serviceTitleLabel.bottomAnchor, constant: SPACE_S).isActive = true
        serviceStackView.leadingAnchor.constraint(equalTo: serviceContainerView.leadingAnchor).isActive = true
        serviceStackView.trailingAnchor.constraint(equalTo: serviceContainerView.trailingAnchor).isActive = true
        serviceStackView.bottomAnchor.constraint(equalTo: serviceContainerView.bottomAnchor).isActive = true
        
        serviceStackView.addArrangedSubview(qnaIconButton)
        qnaIconButton.leadingAnchor.constraint(equalTo: serviceStackView.leadingAnchor).isActive = true
        qnaIconButton.trailingAnchor.constraint(equalTo: serviceStackView.trailingAnchor).isActive = true
        
//        serviceStackView.addArrangedSubview(reportIconButton)
//        reportIconButton.leadingAnchor.constraint(equalTo: serviceStackView.leadingAnchor).isActive = true
//        reportIconButton.trailingAnchor.constraint(equalTo: serviceStackView.trailingAnchor).isActive = true
        
        serviceStackView.addArrangedSubview(agreementIconButton)
        agreementIconButton.leadingAnchor.constraint(equalTo: serviceStackView.leadingAnchor).isActive = true
        agreementIconButton.trailingAnchor.constraint(equalTo: serviceStackView.trailingAnchor).isActive = true
        
        serviceStackView.addArrangedSubview(privacyIconButton)
        privacyIconButton.leadingAnchor.constraint(equalTo: serviceStackView.leadingAnchor).isActive = true
        privacyIconButton.trailingAnchor.constraint(equalTo: serviceStackView.trailingAnchor).isActive = true
        
        // MARK: Configure - Etc
        stackView.addArrangedSubview(etcContainerView)
        etcContainerView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        etcContainerView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: CONTENTS_RATIO_XS).isActive = true
        
        etcContainerView.addSubview(etcTitleLabel)
        etcTitleLabel.topAnchor.constraint(equalTo: etcContainerView.topAnchor).isActive = true
        etcTitleLabel.leadingAnchor.constraint(equalTo: etcContainerView.leadingAnchor).isActive = true
        etcTitleLabel.trailingAnchor.constraint(equalTo: etcContainerView.trailingAnchor).isActive = true
        
        etcContainerView.addSubview(etcStackView)
        etcStackView.topAnchor.constraint(equalTo: etcTitleLabel.bottomAnchor, constant: SPACE_S).isActive = true
        etcStackView.leadingAnchor.constraint(equalTo: etcContainerView.leadingAnchor).isActive = true
        etcStackView.trailingAnchor.constraint(equalTo: etcContainerView.trailingAnchor).isActive = true
        etcStackView.bottomAnchor.constraint(equalTo: etcContainerView.bottomAnchor).isActive = true
        
        // MARK: Configure - Etc - UserType
        etcStackView.addArrangedSubview(userTypeContainerView)
        userTypeContainerView.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        userTypeContainerView.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
        
        userTypeContainerView.addSubview(userTypeTitleLabel)
        userTypeTitleLabel.topAnchor.constraint(equalTo: userTypeContainerView.topAnchor).isActive = true
        userTypeTitleLabel.leadingAnchor.constraint(equalTo: userTypeContainerView.leadingAnchor).isActive = true
        
        userTypeContainerView.addSubview(userTypeLabel)
        userTypeLabel.topAnchor.constraint(equalTo: userTypeTitleLabel.bottomAnchor, constant: SPACE_XXXXXS).isActive = true
        userTypeLabel.leadingAnchor.constraint(equalTo: userTypeContainerView.leadingAnchor).isActive = true
        userTypeLabel.bottomAnchor.constraint(equalTo: userTypeContainerView.bottomAnchor).isActive = true
        
        // MARK: Configure - Etc - Version
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
        versionButton.centerYAnchor.constraint(equalTo: versionLabel.centerYAnchor).isActive = true
        versionButton.trailingAnchor.constraint(equalTo: versionContainerView.trailingAnchor).isActive = true
        
        // MARK: Configure - Etc - Other
        etcStackView.addArrangedSubview(logoutIconButton)
        logoutIconButton.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        logoutIconButton.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
        
        etcStackView.addArrangedSubview(leaveIconButton)
        leaveIconButton.leadingAnchor.constraint(equalTo: etcStackView.leadingAnchor).isActive = true
        leaveIconButton.trailingAnchor.constraint(equalTo: etcStackView.trailingAnchor).isActive = true
    }
    
    // MARK: Function - @OBJC
    @objc func editUserTapped() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.delegate = self
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc func commentTapped() {
        navigationController?.pushViewController(CommentViewController(), animated: true)
    }
    
    @objc func likeTapped() {
        navigationController?.pushViewController(LikeViewController(), animated: true)
    }
    
//    @objc func blockUserTapped() {
//        print("blockUserTapped")
//    }
//
//    @objc func blockPostsTapped() {
//        print("blockPostsTapped")
//    }
    
    @objc func qnaTapped() {
        let qnaListNavVC = UINavigationController(rootViewController: QnaListViewController())
        qnaListNavVC.modalPresentationStyle = .fullScreen
        present(qnaListNavVC, animated: true, completion: nil)
    }
    
//    @objc func reportTapped() {
//        print("reportTapped")
//    }
    
    @objc func agreementTapped() {
        let termsVC = TermsViewController()
        termsVC.path = "agreement"
        navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @objc func privacyTapped() {
        let termsVC = TermsViewController()
        termsVC.path = "privacy"
        navigationController?.pushViewController(termsVC, animated: true)
    }
    
    @objc func updateTapped() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/1548230910") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func logoutTapped() {
        let alert = UIAlertController(title: nil, message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { (_) in
            self.logoutRequest.fetch(vc: self, paramDict: [:])
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func leaveTapped() {
        let leaveNavVC = UINavigationController(rootViewController: LeaveViewController())
        leaveNavVC.modalPresentationStyle = .fullScreen
        present(leaveNavVC, animated: true, completion: nil)
    }
}


// MARK: PushView
extension MenuViewController: PushViewProtocol {
    func switching(actionMode: String) {
        let userDefaults = UserDefaults.standard
        
        var isAllowed = "N"
        if actionMode == "AD" {
            isAllowed = isAllowedAdPushView.sw.isOn ? "Y" : "N"
            userDefaults.set(isAllowed, forKey: "u_is_allowed_push_ad")
        }  else if actionMode == "POSTS_COMMENT" {
            isAllowed = isAllowedPostsCommentPushView.sw.isOn ? "Y" : "N"
            userDefaults.set(isAllowed, forKey: "u_is_allowed_push_posts_comment")
        } else if actionMode == "FOLLOWED" {
            isAllowed = isAllowedFollowedPushView.sw.isOn ? "Y" : "N"
            userDefaults.set(isAllowed, forKey: "u_is_allowed_push_followed")
        } else if actionMode == "RE_COMMENT" {
            isAllowed = isAllowedReCommentPushView.sw.isOn ? "Y" : "N"
            userDefaults.set(isAllowed, forKey: "u_is_allowed_push_re_comment")
        }
        
        if isAllowed == "Y" {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (isAllowed, error) in DispatchQueue.main.async {
                self.app.setIsDontLookAgainAccessAlarm(isDontLookAgain: false)
                
                if let _ = error {
                    if actionMode == "AD" {
                        self.isAllowedAdPushView.sw.setOn(false, animated: true)
                        userDefaults.set("N", forKey: "u_is_allowed_push_ad")
                    } else if actionMode == "POSTS_COMMENT" {
                        self.isAllowedPostsCommentPushView.sw.setOn(false, animated: true)
                        userDefaults.set("N", forKey: "u_is_allowed_push_posts_comment")
                    } else if actionMode == "FOLLOWED" {
                        self.isAllowedFollowedPushView.sw.setOn(false, animated: true)
                        userDefaults.set("N", forKey: "u_is_allowed_push_followed")
                    } else if actionMode == "RE_COMMENT" {
                        self.isAllowedReCommentPushView.sw.setOn(false, animated: true)
                        userDefaults.set("N", forKey: "u_is_allowed_push_re_comment")
                    }
                    
                    let alert = UIAlertController(title: "알림 액세스 허용하기", message: "앱 사용시 중요한 정보를 알려드립니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
                    alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { (_) in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                if !isAllowed {
                    if actionMode == "AD" {
                        self.isAllowedAdPushView.sw.setOn(false, animated: true)
                        userDefaults.set("N", forKey: "u_is_allowed_push_ad")
                    } else if actionMode == "POSTS_COMMENT" {
                        self.isAllowedPostsCommentPushView.sw.setOn(false, animated: true)
                        userDefaults.set("N", forKey: "u_is_allowed_push_posts_comment")
                    } else if actionMode == "FOLLOWED" {
                        self.isAllowedFollowedPushView.sw.setOn(false, animated: true)
                        userDefaults.set("N", forKey: "u_is_allowed_push_followed")
                    } else if actionMode == "RE_COMMENT" {
                        self.isAllowedReCommentPushView.sw.setOn(false, animated: true)
                        userDefaults.set("N", forKey: "u_is_allowed_push_re_comment")
                    }
                    
                    let alert = UIAlertController(title: "알림 액세스 허용하기", message: "앱 사용시 중요한 정보를 알려드립니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
                    alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { (_) in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                UIApplication.shared.registerForRemoteNotifications()
                self.editUserPushRequest.fetch(vc: self, paramDict: ["isAllowed": "Y", "actionMode": actionMode])
            }})
            
        } else {
            editUserPushRequest.fetch(vc: self, paramDict: ["isAllowed": "N", "actionMode": actionMode])
        }
    }
}

// MARK: EditProfileVC
extension MenuViewController: EditProfileViewControllerProtocol {
    func editProfile() {
        delegate?.editProfile()
    }
}

// MARK: HTTP - Logout
extension MenuViewController: LogoutRequestProtocol {
    func response(logout status: String) {
        print("[HTTP RES]", logoutRequest.apiUrl, status)
        
        if status == "OK" {
            app.logout()
            
            changeRootViewController(rootViewController: UINavigationController(rootViewController: LoginViewController()))
        }
    }
}

// MARK: HTTP - EditUserPush
extension MenuViewController: EditUserPushRequestProtocol {
    func response(editUserPush status: String) {
        print("[HTTP RES]", editUserPushRequest.apiUrl, status)
    }
}
