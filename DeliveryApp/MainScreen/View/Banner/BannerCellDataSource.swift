import UIKit

final class BannerCellDataSource:  NSObject, UICollectionViewDataSource {
    private var banners: [UIImage] = []
}

extension BannerCellDataSource {
    func updateBanners(_ new: [UIImage]) {
        self.banners = new
    }
}

extension BannerCellDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell
        else { return UICollectionViewCell() }
        let banner = banners[indexPath.row]
        cell.configure(with: banner)
        return cell
    }
    
}
