//
//  AnchorIdentifierHelper.swift
//  ACRT
//
//  Created by baochong on 2021/11/12.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation

private let anchorIdentifierDelimiter : String = "|"
class AnchorIdentifierHelper {
    class func encode(userName: String, modelName :String) -> String {
        return userName + anchorIdentifierDelimiter + modelName + anchorIdentifierDelimiter + randomString(length: 2)
    }
    
    class func decode(identifier : String) -> [String] {
        return identifier.components(separatedBy: anchorIdentifierDelimiter)
    }
}
