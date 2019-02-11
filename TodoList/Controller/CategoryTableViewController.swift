//
//  CategoryTableViewController.swift
//  TodoList
//
//  Created by Bradley Yin on 2/9/19.
//  Copyright © 2019 Bradley Yin. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadcategories()
        
        
    }
 
    
    //MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
     return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
      
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added Yet"
        
        return cell
       
    }
    //MARK: - Data Manipulation Method
    
    //MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories? [indexPath.row]
        }
    }
    
    
    //MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
             self.save(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextfield) in
           alertTextfield.placeholder = "Create New Category"
            textField = alertTextfield
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    func save (category : Category) {
        do{
            try realm.write {
            realm.add(category)
            }
        }catch{
            print("error in saving, \(error)")
        }
        tableView.reloadData()
    }
    func loadcategories (){
        categories = realm.objects(Category.self)
        
        
        tableView.reloadData()
    }
    
  
    
}
