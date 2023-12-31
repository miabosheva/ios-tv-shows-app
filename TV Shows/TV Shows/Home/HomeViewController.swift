//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 14.7.23.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD


final class HomeViewController : UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var authInfo: AuthInfo?
    var userResponse: UserResponse?
    var shows: [Show] = []
    var currentPage = 1
    var totalPages = 0
    var requestURL: String?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureRefreshControl()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: NSNotification.Name(rawValue: "didLogout"), object: nil)
    }

}

private extension HomeViewController {
    // MARK: - Helper Methods
    
    func loadData() {
        listShows()
        currentPage += 1
    }
    
    func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func setupUI() {
        let profileDetailsItem = UIBarButtonItem(
            image: UIImage(named: "ic-profile"),
            style: .plain,
            target: self,
            action: #selector(profileDetailsActionHandler)
        )
        profileDetailsItem.tintColor = UIColor(named: "primary-color")
        navigationItem.rightBarButtonItem = profileDetailsItem
    }
}

// MARK: - GET Request for Shows

private extension HomeViewController {
    
    @objc func listShows() {
        
        guard let authInfo = authInfo else { return }
        
        guard let requestURL else { return }
        
        AF
            .request(
                requestURL,
                method: .get,
                parameters: ["page": currentPage, "items": "20"], 
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let showsResponse):
                    totalPages = showsResponse.meta?.pagination.pages ?? 1
                    currentPage = showsResponse.meta?.pagination.page ?? 1
                    self.shows.append(contentsOf: showsResponse.shows)
                    tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Details", bundle: nil)
        let detailsController = storyboard.instantiateViewController(withIdentifier: "detailsController") as! DetailsViewController
        detailsController.authInfo = authInfo
        detailsController.show = shows[indexPath.row]
        navigationController?.pushViewController(detailsController, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TVShowTableViewCell.self),
            for: indexPath
        ) as! TVShowTableViewCell
        
        cell.configure(with: shows[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == shows.count - 1, currentPage < totalPages {
            loadData()
        }
    }
}

// MARK: - Private

private extension HomeViewController {
    
    func setupTableView() {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        listShows()
    }
    
    @objc func handleRefreshControl() {
        listShows()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func profileDetailsActionHandler() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let profileController = storyboard.instantiateViewController(withIdentifier: "profileController") as! ProfileController
        
        profileController.user = userResponse?.user
        
        let navigationController = UINavigationController(rootViewController: profileController)
        present(navigationController, animated: true)
    }
    
    @objc func didLogout()  {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginController = storyboard.instantiateViewController(withIdentifier: "loginController") as! LoginViewController
        
        navigationController?.setViewControllers([loginController], animated: true)
    }
}

