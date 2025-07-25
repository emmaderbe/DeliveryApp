import UIKit

protocol ImageLoaderProtocol: AnyObject {
    func loadImage(from url: URL, completion: @escaping (Data?) -> Void)
}

final class ImageLoader: NSObject, ImageLoaderProtocol {
    private let cache = NSCache<NSURL, NSData>()
    private var completions: [URL: (Data?) -> Void] = [:]

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "imageLoader.background.\(UUID().uuidString)")
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
}

extension ImageLoader {
    func loadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        if let cachedData = cache.object(forKey: url as NSURL) {
            completion(cachedData as Data)
            return
        }

        completions[url] = completion
        session.downloadTask(with: url).resume()
    }
}

extension ImageLoader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url,
              let data = try? Data(contentsOf: location) else { return }

        cache.setObject(data as NSData, forKey: url as NSURL)

        DispatchQueue.main.async {
            self.completions[url]?(data)
            self.completions[url] = nil
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let url = task.originalRequest?.url, let error = error else { return }

        print("Image load failed: \(error.localizedDescription)")

        DispatchQueue.main.async {
            self.completions[url]?(nil)
            self.completions[url] = nil
        }
    }
}
