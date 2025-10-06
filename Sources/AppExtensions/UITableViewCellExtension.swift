//
//  TableViewCell+.swift
//  Avtobot
//
//  Created by Alexei on 21/04/2020.
//  Copyright © 2020 Alexei. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    class func registerNib(to tableView: UITableView) {
        let name = String(describing: self)
        tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    class func registerCell(to tableView: UITableView) {
        let name = String(describing: self)
        tableView.register(self, forCellReuseIdentifier: name)
    }
    
    class func cell(for tableView: UITableView, indexPath: IndexPath) -> Self? {
        let name = String(describing: self)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as? Self else {
            return nil
        }
        return cell
    }
}
