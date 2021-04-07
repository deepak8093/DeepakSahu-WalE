//
//  StringExten.swift
//  WalEAstroApp
//
//  Created by Deepak Sahu on 07/04/21.
//

import Foundation
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
