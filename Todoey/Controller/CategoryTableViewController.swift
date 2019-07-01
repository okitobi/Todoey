//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Joseph Ray on 6/30/19.
//  Copyright © 2019 Joseph Ray. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController
{
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        loadCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
//        let item = categories[indexPath.row]
//        cell.textLabel?.text = item.categoryName
        
        // same as above but simpler
        cell.textLabel?.text = categories[indexPath.row].categoryName
        
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    func saveCategories()
    {
        do
        {
            try context.save()
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
            
            
            
            let newCategory = Category(context: self.context)
            newCategory.categoryName = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
        }
        
        alert.addTextField
            { (alertTextField) in
                alertTextField.placeholder = "Enter New Category"
                textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest())
    {
        
        do
        {
            categories = try context.fetch(request)
        }
        catch
        {
            print("There was an error retrieving data: \(error)")
        }
        
    }
    
}
