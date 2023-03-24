//
//  Font+Ext.swift
//  TestStorik
//
//  Created by andreydem on 22.03.2023.
//

import Foundation
import SwiftUI

extension Font {
    
    static func montserratFont(size: CGFloat) -> Font {
        return Font.custom("Montserrat-Regular", size: size)
    }
    
    static func boldMontserratFont(size: CGFloat) -> Font {
        return Font.custom("Montserrat-Bold", size: size)
    }
    
}
