//
//  CategoryTableViewController.swift
//  TodoList
//
//  Created by Bradley Yin on 2/9/19.
//  Copyright © 2019 Bradley Yin. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategorys()
        
        
    }
 
    
    //MARK: - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
     return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
      
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
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
            destinationVC.selectedCategory = categoryArray [indexPath.row]
        }
    }
    
    
    //MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text
            
            self.categoryArray.append(newCategory)
            
             self.saveCategorys()
            
            self.loadCategorys()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextfield) in
           alertTextfield.placeholder = "Create New Category"
            textField = alertTextfield
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    func saveCategorys () {
        do{
            try context.save()
        }catch{
            print("error in saving, \(error)")
        }
    }
    func loadCategorys (){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch {
           print("error loading, \(error)")
        }
        tableView.reloadData()
    }
    
  
    
}
