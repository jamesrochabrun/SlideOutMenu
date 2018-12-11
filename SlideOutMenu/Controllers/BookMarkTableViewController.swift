//
//  BookMarkTableViewController.swift
//  SlideOutMenu
//
//  Created by James Rochabrun on 12/10/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

class BookMarkTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "BookMark \(indexPath.row)"
        return cell
    }
    
}
