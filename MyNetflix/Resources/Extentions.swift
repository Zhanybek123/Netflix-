//
//  Extentions.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/31/22.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        self.prefix(1).uppercased() + self.lowercased().dropFirst(1)
    }
}
