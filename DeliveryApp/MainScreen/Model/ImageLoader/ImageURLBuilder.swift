import Foundation

protocol ImageURLBuilderProtocol {
    func url(from imageString: String) -> URL?
}

final class ImageURLBuilder: ImageURLBuilderProtocol {
    func url(from imageString: String) -> URL? {
        return URL(string: imageString)
    }
}
