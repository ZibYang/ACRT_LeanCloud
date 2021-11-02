//
//  WhatMeansCreateView.swift
//  ACRT
//
//  Created by 章子飏 on 2021/11/2.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct WhatMeansCreateView: View {
    @Environment(\.dismiss) var dismissSheet
    
    var body: some View {
        ZStack {
            Text("Expore and Create")
            
            VStack {
                HStack {
                    Spacer()
                    Button("Understand") {
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(true, forKey: "LaunchedBefore")
                        dismissSheet()
                    }
                    .padding(.trailing)
                }
                Spacer()
            }
        }
        .padding(.vertical)
        
    }
}

struct WhatMeansCreateView_Previews: PreviewProvider {
    static var previews: some View {
        WhatMeansCreateView()
    }
}
