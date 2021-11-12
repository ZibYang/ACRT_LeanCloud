//
//  TestView.swift
//  ACRT
//
//  Created by Lab509 on 2021/11/11.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State var showIt = false
    var body: some View {
        Button(action: {
            showIt.toggle()
        }, label: {
            Text("Tap Me")
        })
            .halfSheet(showSheet: $showIt){
                Text("Hello")
            }
            
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
