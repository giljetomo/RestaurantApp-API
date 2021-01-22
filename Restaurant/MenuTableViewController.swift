//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Macbook Pro on 2021-01-21.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    let category: String
//    let menuController = MenuController()
    var menuItems = [MenuItem]()
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter
    }()
    
    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuController.shared.fetchMenuItems(forCategory: category)
        { (result) in
            switch result {
            case .success(let menuItems):
                self.updateUI(with: menuItems!)
            case .failure(let error):
                self.displayError(error, title: "Failed to Fetch Menu Items for \(self.category)")
            }
        }
    }
    
    @IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath =
               tableView.indexPath(for: cell) else {
                return nil
            }
        
            let menuItem = menuItems[indexPath.row]
            return MenuItemDetailViewController(coder: coder, menuItem:
               menuItem)
    }
    
        func updateUI(with menuItems: [MenuItem]) {
            DispatchQueue.main.async {
                self.menuItems = menuItems
                self.tableView.reloadData()
            }
        }
        
        func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message:
                                                error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style:
                                                .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return menuItems.count
        }
    override func tableView(_ tableView: UITableView,
       cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
           "MenuItem", for: indexPath)
        configure(cell, forItemAt: indexPath)
        cell.detailTextLabel?.text = priceFormatter.string(from: NSNumber(value: menuItems[indexPath.row].price))
        return cell
    }

    func configure(_ cell: UITableViewCell, forItemAt indexPath:
       IndexPath) {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = "$\(menuItem.price)"
    }
        /*
         override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
         
         // Configure the cell...
         
         return cell
         }
         */
        
        /*
         // Override to support conditional editing of the table view.
         override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
         }
         */
        
        /*
         // Override to support editing the table view.
         override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
         // Delete the row from the data source
         tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
         }
         */
        
        /*
         // Override to support rearranging the table view.
         override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
         
         }
         */
        
        /*
         // Override to support conditional rearranging of the table view.
         override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
         }
         */
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }