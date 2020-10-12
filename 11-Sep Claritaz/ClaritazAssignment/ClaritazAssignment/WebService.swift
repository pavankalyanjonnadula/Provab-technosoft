//
//  WebService.swift
//  MovieFlix
//
//  Created by Pavan Kalyan Jonnadula on 17/05/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import Foundation
import UIKit
typealias HttpRequestCompletionBlock = (Data?, URLResponse?, Error?) -> Void

public class WebService : NSObject {
    static let shared = WebService()
    func getRequest(urlString : String ,requestCompletion: HttpRequestCompletionBlock?) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            if let jsonData = data{
                DispatchQueue.main.async {
                    requestCompletion!(jsonData, response, error)
                }
            }
        }
        task.resume()
    }
}
    
extension UIView {

    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

extension UIStackView {
    func addBorder(color: UIColor, backgroundColor: UIColor, thickness: CGFloat) {
        let insetView = UIView(frame: bounds)
        insetView.backgroundColor = backgroundColor
        insetView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(insetView, at: 0)

        let borderBounds = CGRect(
            x: thickness,
            y: thickness,
            width: frame.size.width - thickness * 2,
            height: frame.size.height - thickness * 2)

        let borderView = UIView(frame: borderBounds)
        borderView.backgroundColor = color
        borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(borderView, at: 0)
    }
}
