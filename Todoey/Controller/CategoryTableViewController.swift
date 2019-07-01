//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Joseph Ray on 6/30/19.
//  Copyright © 2019 Joseph Ray. All rights reserved.
//

import UIKit
// import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController
{
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    // context is part of CoreData
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        loadCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
//        let item = categories[indexPath.row]
//        cell.textLabel?.text = item.categoryName
        
        // same as above but simpler
        cell.textLabel?.text = categories?[indexPath.row].categoryName ?? "No Categories Added Yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    // with CoreData, this did not have parameters
    func saveCategories(Category: Category)
    {
        do
        {
            try realm.write
            {
                realm.add(Category)
            }
            // this is previous CoreData method
//            try context.save()
        }
        catch
        {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
 

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default)
        { (action) in
            // what will happen once user clicks the Add Item button on our UIalert
            print(textField.text!)
            
            let newCategory = Category()
            
            // this line is the previous way of implementing CoreData
            //let newCategory = Category(context: self.context)
            
            newCategory.categoryName = textField.text!
            
            // old CoreData type, Realm (results) will autoupdate
//            self.categories.append(newCategory)
            
            self.saveCategories(Category: newCategory)
            
            // previous implementation of CoreData
            //self.saveCategories()
            
        }
        
        alert.addTextField
            { (alertTextField) in
                alertTextField.placeholder = "Enter New Category"
                textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // this function previously had option parameter: with request : NSFetchRequest<Category> = Category.fetchRequest()
    func loadCategories()
    {
        // changed global categories to be results-type
         categories = realm.objects(Category.self)
        
        // this was the previous implementation of CoreData
//        do
//        {
//            categories = try context.fetch(request)
//        }
//        catch
//        {
//            print("There was an error retrieving data: \(error)")
//        }
        
        tableView.reloadData()
    }
    
}
