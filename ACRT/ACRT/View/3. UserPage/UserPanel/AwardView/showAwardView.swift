//
//  showAwardView.swift
//  ACRT
//
//  Created by Lab509 on 2021/11/26.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import SwiftUI

struct showAwardView: View {
    @Environment(\.dismiss) var dismissSheet
    let awardName: String
    let awardDetail: String
    
    var body: some View {
        ZStack {
            VStack {
                Text("Congradulations!")
                    .font(.largeTitle)
                    .bold()
                ZStack {
                    Image(systemName: "circle.fill")
                                    .resizable()
                                    .angularGradientGlow(colors: [Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1))])
                                    .frame(width: 250, height: 250)
                                    .blur(radius: 10)
                    Image(awardName+"_granted")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                }
                Text(awardDetail)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            VStack{
                Spacer()
                Button(action: {
                    dismissSheet()
                }, label: {
                    Text("Oh Yes!")
                        .frame(width: 200, height: 45)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                })
            }
        }
    }
}

struct showAwardView_Previews: PreviewProvider {
    static var previews: some View {
        showAwardView(awardName: "Hangzhou", awardDetail: "Hangzhou, also romanized as Hangchow, is the capital and most populous city of Zhejiang, People's Republic of China. It is located in the northwestern part of the province, sitting at the head of Hangzhou Bay, which separates Shanghai and Ningbo. Its West Lake, a UNESCO World Heritage Site immediately west of the city, is among its best-known attractions. Welcome to HangZhou! ")
    }
}
