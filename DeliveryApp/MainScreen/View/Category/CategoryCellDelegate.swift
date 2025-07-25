import UIKit

protocol CategoryCollectionDelegateProtocol: AnyObject {
    func didSelectCategory(at index: Int)
}

final class CategoryCollectionDelegate: NSObject, UICollectionViewDelegate {
    private var categoriesCount: Int = 0
    private(set) var selectedIndex: Int = 0
    
    weak var delegate: CategoryCollectionDelegateProtocol?

    func update(categoriesCount: Int, selectedIndex: Int) {
        self.categoriesCount = categoriesCount
        self.selectedIndex = selectedIndex
    }
}

extension CategoryCollectionDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < categoriesCount else {
            print("Index out of range")
            return
        }

        guard selectedIndex != indexPath.item else { return }

        let previousIndex = selectedIndex
        selectedIndex = indexPath.item

        collectionView.reloadItems(at: [
            IndexPath(item: previousIndex, section: 0),
            IndexPath(item: selectedIndex, section: 0)
        ])

        delegate?.didSelectCategory(at: selectedIndex)
    }
}
