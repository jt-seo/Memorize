//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by JT3 on 2020/08/18.
//  Copyright © 2020 JT2. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(of item: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == item.id {
                return index
            }
        }
        return nil
    }
}
