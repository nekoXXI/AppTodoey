import UIKit
import RealmSwift

class NotesViewController: UIViewController {
    private var toDoNotes: Results<Note>?
    private let realm = try! Realm()
    var selectedItems : Item? {
        didSet {
            loadNotes()
        }
    }
    
    var textFild: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        loadNotes()
    }
    
    private func setup() {
        
        view.backgroundColor = .white
        
        view.addSubview(textFild)
        textFild.delegate = self
        
        textFild.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        textFild.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        textFild.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        textFild.heightAnchor.constraint(equalToConstant: 500).isActive = true
        textFild.layer.borderWidth = 1
        textFild.contentVerticalAlignment = .top
        configureTextFieldText()
        
    }

    private func configureTextFieldText() {
        if selectedItems?.notes != nil {
            textFild.text = selectedItems?.notes.last?.textNote
        } 
    }
    
    private func loadNotes() {
        toDoNotes = selectedItems?.notes.sorted(byKeyPath: "textNote", ascending: true)
        toDoNotes = realm.objects(Note.self)
    }
}

extension NotesViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let currentItems = self.selectedItems {
            do {
                try! self.realm.write {
                    let newNote = Note()
                    newNote.textNote = textField.text!
                    currentItems.notes.append(newNote)
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
