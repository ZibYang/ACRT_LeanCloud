//
//  SecurityInfomation.swift
//  ACRT
//
//  Created by Lab509 on 2021/11/21.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct SecurityInfomation: View {
    @Environment(\.dismiss) var dismissSheet
    
    var body: some View {
        ZStack{
            Text("Hello, World!")
            
            VStack {
                HStack {
                    Spacer()
                    Button("Understand") {
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

struct SecurityInfomation_Previews: PreviewProvider {
    static var previews: some View {
        SecurityInfomation()
    }
}
