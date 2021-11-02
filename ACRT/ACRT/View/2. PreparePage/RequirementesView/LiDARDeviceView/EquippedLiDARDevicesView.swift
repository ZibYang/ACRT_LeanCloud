//
//  EquippedLiDARDevicesView.swift
//  ACRT
//
//  Created by 章子飏 on 2021/11/1.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct EquippedLiDARDevicesView: View {
    let deviceName: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(LocalizedStringKey(deviceName))
                .lineLimit(1)
        }
    }
}

struct EquippedLiDARDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 10) {
            EquippedLiDARDevicesView(deviceName: "iPhone 13", iconName: "iphone")
            EquippedLiDARDevicesView(deviceName: "iPad Pro", iconName: "ipad")
        }
    }
}
