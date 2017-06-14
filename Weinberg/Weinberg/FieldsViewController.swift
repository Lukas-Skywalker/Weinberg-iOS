//
//  FieldsTableViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class FieldsViewController: UIViewController {

    var fields:[Field] = [Field]()
    
}

extension FieldsViewController : UITableViewDataSource, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}

struct Field {
    var name : String
    var fruit : String
    var treatment : String
    var size : Int
}
