import UIKit

struct ImageFactory {
   static func makeLogoImageView() -> UIImageView {
       let imageView = UIImageView()
       imageView.image = UIImage(named: "logo")
       imageView.contentMode = .scaleAspectFit
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }
    
    static func createSnackBarImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
