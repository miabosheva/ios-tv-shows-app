//
//  DetailsViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 27.7.23.
//

import Foundation
import UIKit
import Alamofire

final class DetailsViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properites
    
    var authInfo: AuthInfo?
    var show: Show?
    var reviews: [Review]?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShowDetails()
    }
    
    
    // MARK: - Actions
    @IBAction func addAReviewButtonTap() {
        let storyboard = UIStoryboard(name: "WriteReview", bundle: nil)
        
        let writeReviewController = storyboard.instantiateViewController(withIdentifier: "writeReviewController") as! WriteReviewController
        
        writeReviewController.authInfo = self.authInfo
        writeReviewController.show = self.show
        writeReviewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: writeReviewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Helper Methods
    
    func listReviews(){
        guard let authInfo = authInfo,
              let show = show else { return }
        
        AF
            .request(
                "https://tv-shows.infinum.academy/shows/\(show.id)/reviews",
                method: .get,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ReviewResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                switch dataResponse.result {
                case .success(let review):
                    print(review.reviews)
                    self.reviews = review.reviews
                    tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
}

// MARK: - Delegate pattern method

extension DetailsViewController: WriteReviewControllerDelegate {
    func submitReview() {
        listReviews()
    }
}

extension DetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            guard let reviews = reviews else {
                return 0 }
            return reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let showCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: DetailsShowTableViewCell.self),
                for: indexPath
            ) as! DetailsShowTableViewCell
            
            guard let show = show else { return UITableViewCell()}
            showCell.configure(with: show)
            
            return showCell
        }
        else {
            let reviewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewTableViewCell.self),
                                                           for: indexPath
            ) as! ReviewTableViewCell
            
            guard let reviews = reviews else { return UITableViewCell()}
            reviewCell.configure(with: reviews[indexPath.row])
            
            return reviewCell
        }
    }
}

// MARK: - Helper Methods

private extension DetailsViewController {
    func loadShowDetails() {
        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        
        guard let show = show else { return }
        titleLabel.text = show.title
        listReviews()
    }
    
    func modifyBackButton() {
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "primary-color")
    }
}
