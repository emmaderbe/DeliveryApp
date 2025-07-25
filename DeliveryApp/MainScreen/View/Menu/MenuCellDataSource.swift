import UIKit

final class MenuCellDataSource: NSObject, UICollectionViewDataSource {
    private var menuItems: [MenuItemModel] = []
}

extension MenuCellDataSource {
    func updateMenuItems(_ newItems: [MenuItemModel]) {
        self.menuItems = newItems
    }
}

extension MenuCellDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MenuCell.identifier,
            for: indexPath
        ) as? MenuCell else {
            return UICollectionViewCell()
        }
        
        let item = menuItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}
