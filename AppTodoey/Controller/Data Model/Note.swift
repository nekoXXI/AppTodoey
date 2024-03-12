import Foundation
import RealmSwift

final class Note: Object {
    @objc dynamic var textNote: String = ""
    var parentItem = LinkingObjects(fromType: Item.self, property: "notes")
}
