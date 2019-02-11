//
//  ViewController.swift
//  TodoList
//
//  Created by Bradley Yin on 2/7/19.
//  Copyright © 2019 Bradley Yin. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try!Realm()
    var items : Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
           
           loadItems()
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }

        //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
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
