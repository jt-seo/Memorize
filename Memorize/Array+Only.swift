//
//  Array+Only.swift
//  Memorize
//
//  Created by JT3 on 2020/08/18.
//  Copyright © 2020 JT2. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
