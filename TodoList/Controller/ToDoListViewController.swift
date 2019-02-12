//
//  ViewController.swift
//  TodoList
//
//  Created by Bradley Yin on 2/7/19.
//  Copyright © 2019 Bradley Yin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class ToDoListViewController: SwipeTableViewController {
    
    let realm = try!Realm()
    var items : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category? {
        didSet {
           
           loadItems()
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool ) {
        guard let navBarColor = UIColor(hexString: selectedCategory?.color) else{fatalError()}
        navBarSetup(barColor: navBarColor, titleColor: UIColor.init(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true), tintColor: UIColor.init(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true))
        
            title = selectedCategory!.name
            searchBar.barTintColor = navBarColor
        
    }
    
    override func viewWillDisappear(_ animated: Bool ) {
       navBarSetup(barColor: UIColor.flatBlack(), titleColor: UIColor.flatWhite(), tintColor: UIColor.flatWhite())
    }
    
    //MARK: - Nav Bar Setup
    func navBarSetup (barColor : UIColor, titleColor : UIColor, tintColor: UIColor){
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = barColor
        navBar?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : titleColor]
        navBar?.tintColor = titleColor
        
    }

        //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory?.color).darken(byPercentage: CGFloat(indexPath.row) / CGFloat((items?.count)!) ){
            cell.backgroundColor = color
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
            
        }else {
            cell.textLabel?.text = "No Item Added"
        }
        return cell
    }
    
    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do{ try realm.write {
                item.done = !item.done
                }}catch {
                print("error updating done status, \(error)")
            }
            loadItems()
        }
      
      
        tableView.deselectRow(at: indexPath, animated: true)
        
       
    }
    //MARK - delete with swipe
    override func updateModel(at indexpath: IndexPath) {
        if let itemForDeletion = self.items?[indexpath.row] {
                do{
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                }catch {
                    print("deletion error, \(error)")
                }

            }

    }
    //MARK - Add New Items
 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField ()
        
        let alert = UIAlertController (title: "Add New MinimaList Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            // what will happen once the user click on action alert
            if let currentCategory = self.selectedCategory {
               let date = Date()
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = date
                        currentCategory.items.append(newItem)
                    }}catch{
                        print("error saving, \(error)")
                }
            }
            self.tableView.reloadData()
           
            
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
            
            
        }
        
        present(alert, animated: true, completion: nil)
    }

    func loadItems () {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
}
//MARK: - search bar method

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }
    }
}

