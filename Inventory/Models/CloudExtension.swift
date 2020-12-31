//
//  CloudExtension.swift
//  Inventory
//
//  Created by Vincent Spitale on 12/21/20.
//  Copyright © 2020 Vincent Spitale. All rights reserved.
//

import Foundation

extension Cloud {
    
    public func setID() -> Cloud {
        self.id = UUID()
        return self
    }
}
