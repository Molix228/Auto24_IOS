import UIKit

extension UITextField {
    override open var inputAssistantItem: UITextInputAssistantItem {
        let item = super.inputAssistantItem
        item.leadingBarButtonGroups = []
        item.trailingBarButtonGroups = []
        return item
    }
}
