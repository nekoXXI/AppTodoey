import UIKit
import SwipeCellKit
import RealmSwift

struct Constants {
    static let swipeCellReuseID = "Cell"
    static let goToItemsSegue = "goToItems"
}

final class CategoryViewController: SwipeTableViewController {
    
    private var categories: Results<Category>?
    private var realm: Realm {
        do {
            return try! Realm()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: Constants.swipeCellReuseID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        return cell
    }
    
    private func save(category: Category) {
        do {
            try! realm.write {
                realm.add(category)
            }
        }
        tableView.reloadData()
    }
    
    private func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try! self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }
        }
    }
    
    @IBAction private func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New Cateogry", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text?.count != 0 {
                let newCategory = Category()
                if !textField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                    newCategory.name = textField.text!
                    self.save(category: newCategory)
                }
            }
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.goToItemsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
