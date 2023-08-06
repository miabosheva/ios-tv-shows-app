//
//  TopRatedController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 6.8.23.
//

import Foundation
import UIKit
import Alamofire
import MBProgressHUD

final class TopRatedController: UIViewController, CAAnimationDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var topRatedNavButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var authInfo: AuthInfo?
    var userResponse: UserResponse?
    var shows: [Show] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureRefreshControl()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout), name: NSNotification.Name(rawValue: "didLogout"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        topRatedNavButton.isEnabled = false
    }
    
    // MARK: - Actions
    
    @IBAction func showsTap(_ sender: Any) {
        
        DispatchQueue.main.async {

            self.navigationController?.popViewController(animated: true)
        }
        
        topRatedNavButton.isEnabled = true
    }
    
}

private extension TopRatedController {
    
    // MARK: - Helper Methods
    
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
        navigationItem.setHidesBackButton(true, animated: true)
        topRatedNavButton.setImage(UIImage(named: "ic-top-rated-deselected"), for: .disabled)
        topRatedNavButton.isEnabled = false
    }
}

// MARK: - GET Request for Shows

private extension TopRatedController {
    
    @objc func listShows() {
        
        guard let authInfo = authInfo else { return }
        
        AF
            .request(
                "https://tv-shows.infinum.academy/shows/top_rated",
                method: .get,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: TopRatedResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let showsResponse):
                    self.shows.append(contentsOf: showsResponse.shows)
                    tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension TopRatedController: UITableViewDelegate {
    
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

extension TopRatedController: UITableViewDataSource {
    
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
}

// MARK: - Private

private extension TopRatedController {
    
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
