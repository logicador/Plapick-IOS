//
//  UploadViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/01/08.
//

import UIKit
import Alamofire


protocol UploadViewControllerProtocol {
    func closeViewController()
}


class UploadViewController: UIViewController {
    
    // MARK: Properties
    var app = App()
    var delegate: UploadViewControllerProtocol?
    var image: UIImage?
    var place: Place?
    
    
    // MARK: Views
    
    lazy var placeTitleView: TitleView = {
        let tv = TitleView(titleText: "선택한 플레이스", actionText: nil, actionMode: nil)
        return tv
    }()
    
    var placeSmallView: PlaceSmallView?
    
    lazy var imageTitleView: TitleView = {
        let tv = TitleView(titleText: "선택한 사진", actionText: nil, actionMode: nil)
        return tv
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .tertiarySystemGroupedBackground
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var placeTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var placeBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var imageBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: Init
    init(image: UIImage, place: Place) {
        super.init(nibName: nil, bundle: nil)
        
        self.image = image
        self.place = place
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "픽 업로드"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(backTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(upload))
        
        placeSmallView = PlaceSmallView(place: self.place!)
        imageView.image = self.image
        
        // safeAreaLayoutGuide는 indicatorView가 들어가면서 필요해졌다.
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        contentView.addSubview(placeTitleView)
        placeTitleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        placeTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        placeTitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(placeSmallView!)
        placeSmallView?.topAnchor.constraint(equalTo: placeTitleView.bottomAnchor, constant: 20).isActive = true
        placeSmallView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        placeSmallView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        placeSmallView?.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(imageTitleView)
        imageTitleView.topAnchor.constraint(equalTo: placeSmallView!.bottomAnchor, constant: 40).isActive = true
        imageTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageTitleView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: imageTitleView.bottomAnchor, constant: 20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        view.addSubview(placeTopLineView)
        placeTopLineView.topAnchor.constraint(equalTo: placeSmallView!.topAnchor).isActive = true
        placeTopLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        placeTopLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        placeTopLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        view.addSubview(placeBottomLineView)
        placeBottomLineView.bottomAnchor.constraint(equalTo: placeSmallView!.bottomAnchor).isActive = true
        placeBottomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        placeBottomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        placeBottomLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        view.addSubview(imageTopLineView)
        imageTopLineView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        imageTopLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageTopLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageTopLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        view.addSubview(imageBottomLineView)
        imageBottomLineView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        imageBottomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageBottomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageBottomLineView.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        adjustColors()
        
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
    }
    
    
    // MARK: Functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .systemBackground
            imageView.backgroundColor = .systemGray6
        } else {
            view.backgroundColor = .tertiarySystemGroupedBackground
            imageView.backgroundColor = .systemBackground
        }
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func upload() {
        if !app.isNetworkAvailable() {
            app.showNetworkAlert(parentViewController: self)
            return
        }
        
        guard let image = self.image else { return }
        guard let place = self.place else { return }
//        let user = app.getUser()
        
        view.addSubview(overlayView)
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        overlayView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        view.addSubview(indicatorView)
        indicatorView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true
        indicatorView.startAnimating()
        
        let url = API_URL + "/posting"
        let imageData = image.jpegData(compressionQuality: 1)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(String(place.id).utf8), withName: "pId")
            multipartFormData.append(Data(String(place.kId).utf8), withName: "pkId")
            multipartFormData.append(Data(String(place.name).utf8), withName: "pName")
            multipartFormData.append(Data(String(place.address).utf8), withName: "pAddress")
            multipartFormData.append(Data(String(place.roadAddress).utf8), withName: "pRoadAddress")
            multipartFormData.append(Data(String(place.categoryName).utf8), withName: "pCategoryName")
            multipartFormData.append(Data(String(place.categoryGroupName).utf8), withName: "pCategoryGroupName")
            multipartFormData.append(Data(String(place.categoryGroupCode).utf8), withName: "pCategoryGroupCode")
            multipartFormData.append(Data(String(place.phone).utf8), withName: "pPhone")
            multipartFormData.append(Data(String(place.lat).utf8), withName: "pLat")
            multipartFormData.append(Data(String(place.lng).utf8), withName: "pLng")
            multipartFormData.append(imageData!, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
        }, to: url).responseJSON { response in
            self.indicatorView.stopAnimating()
            self.indicatorView.removeView()
            self.overlayView.removeView()
            
            switch response.result {
            case .success:
                let dataDict: [String: Any] = try! JSONSerialization.jsonObject(with: response.data!, options: []) as! [String: Any]
                let status = dataDict["status"] as! String
                
                if status != "OK" {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: status, message: "에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                        self.present(alert, animated: true)
                    }
                    return
                }
                
                let alert = UIAlertController(title: "픽 업로드", message: "새로운 픽이 게시되었습니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (_) in
                    self.delegate?.closeViewController()
                }))
                self.present(alert, animated: true)
                
            case .failure:
                let alert = UIAlertController(title: "픽 업로드", message: "업로드 중 에러가 발생했습니다.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel))
                self.present(alert, animated: true)
            }
        }
    }
}
