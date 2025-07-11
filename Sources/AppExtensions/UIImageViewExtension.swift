//
//  UIImageViewExtension.swift
//  AppExtensions
//
//  Created by Vladyslav Semenchenko on 26/10/2024.
//

import UIKit

public extension UIImageView {

    func loadImageAsync(from urlString: String, placeholder: UIImage? = nil) async {
        // Display placeholder image if provided
        self.image = placeholder

        // Ensure URL is valid
        guard let url = URL(string: urlString) else { return }

        // Check if the image data is already cached
        if let cachedData = URLCache.shared.cachedResponse(for: URLRequest(url: url))?.data {
            let downloadedImage = UIImage(data: cachedData)
            self.image = downloadedImage
            return
        }

        // Add activity indicator on the main thread
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        DispatchQueue.main.async {
            self.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
            activityIndicator.startAnimating()
        }

        
        // Asynchronously fetch image data
        let (data, response) = await fetchImageData(from: url)
        guard let data, let response, let downloadedImage = UIImage(data: data) else {
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            return
        }

        // Cache the fetched data
        let cachedData = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))

        // Update UI on the main thread
        DispatchQueue.main.async {
            self.image = downloadedImage
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }

    private func fetchImageData(from url: URL) async -> (Data?, URLResponse?) {
        do {
            return try await URLSession.shared.data(from: url)
        } catch {
            print("Failed to fetch image data: \(error)")
            return (nil, nil)
        }
    }
}

public enum ImageStyle: Int {
    case squared, rounded
}
