import UIKit

final class CategoryCellDataSource: NSObject, UICollectionViewDataSource {
    private var categories: [String] = []
    private var selectedIndex: Int = 0
}

extension CategoryCellDataSource {
    func updateCategories(_ new: [String], selectedIndex: Int) {
        self.categories = new
    }
    
    private func category(at index: Int) -> String? {
        guard index < categories.count else { return nil }
        return categories[index]
    }
}

extension CategoryCellDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        
        let title = categories[indexPath.item]
        let selectedIndex = (collectionView.delegate as? CategoryCollectionDelegate)?.selectedIndex ?? 0
        cell.configure(title: title, isSelected: indexPath.item == selectedIndex)
        return cell
    }
}

