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
    var totalPages = 3
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Helper Methods
    
    func loadData(){
        listShows()
        currentPage += 1
    }
}

// MARK: - GET Request for Shows

private extension HomeViewController {
    
    @objc func listShows(){
        
        guard let authInfo = authInfo else { return }
        
        AF
          .request(
              "https://tv-shows.infinum.academy/shows",
              method: .get,
              parameters: ["page": currentPage, "items": "20"], // pagination arguments
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ShowsResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              MBProgressHUD.hide(for: self.view, animated: true)
              switch dataResponse.result {
              case .success(let showsResponse):
                  //totalPages = showsResponse.meta.pages
                  //currentPage = showsResponse.meta.page
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
       
        print("Clicking \(indexPath.row)")
        let storyboard = UIStoryboard(name: "Details", bundle: nil)
                
        let detailsController = storyboard.instantiateViewController(withIdentifier: "detailsController") as! DetailsViewController
                
        navigationController?.pushViewController(detailsController, animated: true)
            
        detailsController.showId = indexPath.row
        detailsController.authInfo = authInfo
        detailsController.show = shows[indexPath.row]
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
}

