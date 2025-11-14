//
//  String+Ext.swift
//  YeeHaw
//
//  Created by Abdulaziz Albahar on 11/13/25.
//

import Foundation

extension String {
    func splitIntoChunks(ofLength length: Int) -> [String] {
        guard length > 0 else { return [] }
        var result: [String] = []
        var currentIndex = startIndex
        while currentIndex < endIndex {
            let nextIndex = index(currentIndex, offsetBy: length, limitedBy: endIndex) ?? endIndex
            let substring = self[currentIndex..<nextIndex]
            result.append(String(substring))
            currentIndex = nextIndex
        }
        return result
    }
}
