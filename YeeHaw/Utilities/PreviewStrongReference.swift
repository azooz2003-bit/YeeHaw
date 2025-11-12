//
//  PreviewStrongReference.swift
//  Cards
//
//  Created by Abdulaziz Albahar on 10/4/25.
//

import Foundation

class PreviewStrongReference {
    static var objects: [Any] = []

    static func add(_ object: Any) {
        objects.append(object)
    }
}
