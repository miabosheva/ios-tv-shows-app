//
//  DetailsViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 6 on 27.7.23.
//

import Foundation
import UIKit

final class DetailsViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properites
    
    var showId = 0
    var authInfo: AuthInfo?
    var show: Show?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShowDetails()
    }
    
}

extension DetailsViewController: UITableViewDataSource {

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailsShowTableViewCell.self),
            for: indexPath
        ) as! DetailsShowTableViewCell

        guard let show = show else { return UITableViewCell()}
        cell.configure(with: show)
        
        return cell
    }

}

private extension DetailsViewController {
    func loadShowDetails(){
        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableView.automaticDimension

        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        
        titleLabel.text = show?.title
    }
}
