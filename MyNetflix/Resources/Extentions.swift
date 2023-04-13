//
//  Extentions.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/31/22.
//

import Foundation
import UIKit

extension String {
    func capitalizeFirstLetter() -> String {
        self.prefix(1).uppercased() + self.lowercased().dropFirst(1)
    }
}

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { i in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return image.withRenderingMode(self.renderingMode)
    }
}
