//
//  UIImageView+Download.swift
//  FrogogoTestApp
//
//  Created by User on 11/23/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

extension UIImageView {
    @discardableResult
    func download(
        from url: URL,
        contentMode mode: UIView.ContentMode = .scaleAspectFill,
        completion: ((Bool)->())? = nil
    ) -> URLSessionDataTask {
        contentMode = mode
        let request = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async() { completion?(false) }
                return
            }
            DispatchQueue.main.async() {
                self.image = image
                completion?(true)
            }
        }
        request.resume()
        return request
    }
    
    func download(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        download(from: url, contentMode: mode)
    }
}
