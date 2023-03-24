//
//  Double+Ext.swift
//  TestStorik
//
//  Created by andreydem on 18.03.2023.
//

import Foundation

extension Double {
    
    var removeZerosInTheFractionPart: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let formattedNumber = formatter.string(from: NSNumber(value: self)) ?? ""
        let components = formattedNumber.components(separatedBy: ".")
        guard components.count == 2 else { return formattedNumber }
        var fractionalPart = components[1]
        while fractionalPart.hasSuffix("0") {
            fractionalPart.removeLast()
        }
        if fractionalPart.isEmpty {
            return (components[0])
        } else {
            return "\(components[0]).\(fractionalPart)"
        }
    }
    
}
 
