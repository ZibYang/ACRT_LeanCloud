//
//  AnchorIdentifierHelper.swift
//  ACRT
//
//  Created by baochong on 2021/11/12.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation

private let anchorIdentifierDelimiter : String = "|"
public let rootUserName = "admin"
class AnchorIdentifierHelper {
    
    class func encode(userName: String, modelName :String) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd.HH.mm.ss.SSSS"

        return userName + anchorIdentifierDelimiter + modelName + anchorIdentifierDelimiter + formatter.string(from: date)

    }
    
    class func decode(identifier : String) -> [String] {
        return identifier.components(separatedBy: anchorIdentifierDelimiter)
    }
}
