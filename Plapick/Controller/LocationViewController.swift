//
//  LocationViewController.swift
//  Plapick
//
//  Created by 서원영 on 2021/02/03.
//

import UIKit


class LocationViewController: UIViewController {
    
    // MARK: Property
    var parentLocationList: [ParentLocation] = LOCATIONS
    var selectedParentLocation: ParentLocation?
    var selectedChildLocationList: [ChildLocation] = []
    
    
    // MARK: View
    lazy var parentLocationTableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tv.separatorInset.left = SPACE
        tv.tableFooterView = UIView(frame: CGRect.zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var childLocationTableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tv.separatorInset.left = SPACE
        tv.tableFooterView = UIView(frame: CGRect.zero) // 빈 셀 안보이게
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var line: LineView = {
        let lv = LineView(orientation: .vertical)
        return lv
    }()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.title = "지역으로 찾기"
        
        configureView()
    }
    
    
    // MARK: Function
    func configureView() {
        view.addSubview(parentLocationTableView)
        parentLocationTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        parentLocationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        parentLocationTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        parentLocationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(childLocationTableView)
        childLocationTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        childLocationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        childLocationTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        childLocationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(line)
        line.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: childLocationTableView.leadingAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}


// MARK: TableView
extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == parentLocationTableView { return parentLocationList.count }
        else { return selectedChildLocationList.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == parentLocationTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            let bgView = UIView()
            bgView.backgroundColor = .tertiarySystemGroupedBackground
            cell.selectedBackgroundView = bgView
            cell.textLabel?.text = parentLocationList[indexPath.row].name
            cell.textLabel?.textAlignment = .center
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel?.text = selectedChildLocationList[indexPath.row].name
            cell.textLabel?.textAlignment = .center
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == parentLocationTableView {
            if let selectedParentLocation = self.selectedParentLocation {
                if selectedParentLocation.code == parentLocationList[indexPath.row].code { return }
            }
            
            selectedParentLocation = parentLocationList[indexPath.row]
            selectedChildLocationList = parentLocationList[indexPath.row].childLocationList
            childLocationTableView.reloadData()
            
        } else {
            guard let selectedParentLocation = self.selectedParentLocation else { return }
            
            let plocCode = selectedParentLocation.code
            let clocCode = selectedChildLocationList[indexPath.row].code
            
            let searchPlaceVC = SearchPlaceViewController()
            searchPlaceVC.plocCode = plocCode
            searchPlaceVC.clocCode = clocCode
            searchPlaceVC.mode = "LOCATION"
            navigationController?.pushViewController(searchPlaceVC, animated: true)
        }
    }
}
