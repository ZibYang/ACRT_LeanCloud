//
//  USDZModelManagerViewModel.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/5.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation


class USDZManagerViewModel: ObservableObject {
    var exploreModelList = USDZModelList(usdzModelNameList:  ["qs_AppleLogo_left.usdz", //1
                                                              "qs_AppleLogo_right.usdz", //2
                                                              "qs_AppleMusic.usdz", //3
                                                              "qs_AppStore.usdz", //4
                                                              "qs_Calendar.usdz", //5
                                                              "qs_Camera.usdz", //5
                                                              "qs_Facetime.usdz", //6
                                                              "qs_Health.usdz", //7
                                                              "qs_Hello.usdz", //8
                                                              "qs_Home.usdz", //9
                                                              "qs_iBook.usdz", //10
                                                              "qs_iMessage.usdz", //11
                                                              "qs_Phone.usdz", //12
                                                              "qs_Safari.usdz", //13
                                                              "qs_Setting.usdz", //14
                                                              "qs_Swift.usdz", //15
                                                              "qs_SwiftChangeTheWorld.usdz", //16
                                                              "qs_Weather.usdz", //17
                                                              "yt_BugerKing.usdz", //18
                                                              "yt_BugerKing.usdz", //19
                                                              "yt_Cocacola.usdz", //20
                                                              "yt_Coffee.usdz", // 21
                                                              "yt_FrenchFires.usdz", //22
                                                              "yt_KFC.usdz", //23
                                                              "yt_McDonald's.usdz",//24
                                                              "qs_findMy.usdz", //25
                                                              "qs_Title.usdz", //26
                                                              "qs_contact.usdz" //27
                                                             ],
                                                         categoryList: [.special, //1
                                                                        .special, //2
                                                                        .special, //3
                                                                        .special, //4
                                                                        .special, //5
                                                                        .special, //5
                                                                        .special, //6
                                                                        .special, //7
                                                                        .special, //8
                                                                        .special, //9
                                                                        .special, //10
                                                                        .special, //11
                                                                        .special, //12
                                                                        .special, //13
                                                                        .special, //14
                                                                        .special, //15
                                                                        .special, //16
                                                                        .special, //17
                                                                        .special, //18
                                                                        .special, //19
                                                                        .special, //20
                                                                        .special, // 21
                                                                        .special, //22
                                                                        .special, //23
                                                                        .special, //24
                                                                        .special, //25
                                                                        .special, //26
                                                                        .special //27
                                                                       ])
    
    var createModelList = USDZModelList(usdzModelNameList:["user_like_blue.reality", //1
                                                           "user_like_red.reality", //2
                                                           "user_love_red.reality", //3
                                                           "user_love_white.usdz", //4
                                                           
                                                            "user_letter_A.usdz", //1
                                                            "user_letter_B.usdz", //2
                                                            "user_letter_C.usdz", //3
                                                            "user_letter_D.usdz", //4
                                                            "user_letter_E.usdz", //5
                                                            "user_letter_F.usdz", //6
                                                            "user_letter_H.usdz", //7
                                                            "user_letter_L.usdz", //8
                                                            "user_letter_O.usdz", //9
                                                            "user_letter_P.usdz", //10
                                                           
//                                                           "user_message_HELLO!.usdz", //1
//                                                           "user_message_LOL.usdz", //2
//                                                           "user_message_OHNO!.usdz", //3
                                                           "user_message_OMG!.usdz", //4
//                                                           "user_message_OOPS!.usdz", //5
//                                                           "user_message_OUCH!.usdz", //6
//                                                           "user_message_ZZZ...usdz", //7
//                                                           "user_message_POP!.usdz", //8
//                                                           "user_message_POW!.usdz", //9
//                                                           "user_message_SHH!.usdz", //10
//                                                           "user_message_WTF.usdz", //11
//                                                           "user_message_YEAH!.usdz", //12
                                                           "user_message_YES!.usdz", //13
//                                                           "user_message_YES!2.usdz", //14
//                                                           "user_message_DAMN!.usdz", //15
//                                                           "user_message_ZAP!.usdz", //16
                                                           "user_message_BANG!.usdz", //17
                                                           "user_message_BOOM!.usdz", //18
                                                           "user_message_COOL.usdz", //19
//                                                           "user_message_CRASH!" //20
                                                           
                                                           "user_emoji_smileWithSweat.usdz", //1
                                                           "user_emoji_smile.usdz", //2
                                                           
                                                           "user_special_pumpkin.usdz", //1
                                                           "user_special_witchHat.usdz", //2
                                                           "user_special_skull.usdz", //3
                                                           "user_special_candy.usdz", //4
                                                           "user_special_bat.usdz", //5
                                                           "user_special_deadHand.usdz", //6
                                                           "user_special_ghost.usdz", //7
                                                           "fanfare.reality"
                                                          ],
                                        categoryList:[.foundmental, //1
                                                      .foundmental, //2
                                                      .foundmental, //3
                                                      .foundmental, //4

                                                       .letter, //1
                                                       .letter, //2
                                                       .letter, //3
                                                       .letter, //4
                                                       .letter, //5
                                                       .letter, //6
                                                       .letter, //7
                                                       .letter, //8
                                                       .letter, //9
                                                       .letter, //10
                                                      
                                                      
//                                                      .message, //1
//                                                      .message, //2
//                                                      .message, //3
                                                      .message, //4
//                                                      .message, //5
//                                                      .message, //6
//                                                      .message, //7
//                                                      .message, //8
//                                                      .message, //9
//                                                      .message, //10
//                                                      .message, //11
//                                                      .message, //12
                                                      .message, //13
//                                                      .message, //14
//                                                      .message, //15
//                                                      .message, //16
                                                      .message, //17
                                                      .message, //18
                                                      .message, //19
//                                                      .message //20
                                                      
                                                      .emoji, //1 
                                                      .emoji, //2
                                                      .special, //1
                                                      .special, //2
                                                      .special, //3
                                                      .special, //4
                                                      .special, //5
                                                      .special, //6
                                                      .special, //7
                                                    .special
                                                     ])
    
//    func AreModelLibrariesLoaded() -> Bool {
//        return exploreModelList.AreModelsLoaded() && createModelList.AreModelsLoaded()
//    }
    
    init() {
        for model in self.exploreModelList.usdzModelList {
            model.asyncLoadModelEntity(){ completed, error in
                if completed {
                    print("DEBUG(BCH): explore load \(model.modelName) sucessfully")
                }
            }
        }
    }
    
    func getModel(modelName: String) -> USDZModel? {
        if let usdzModel = getCreateModel(modelName: modelName) {
            return usdzModel
        } else if let usdzModel = getExploreModel(modelName: modelName) {
            return usdzModel
        }
        return nil
    }
    
    func getCreateModel(modelName: String) -> USDZModel? {
        return createModelList.getUSDZModel(modelName: modelName)
    }
    
    func getExploreModel(modelName: String) -> USDZModel? {
        return exploreModelList.getUSDZModel(modelName: modelName)
    }
    
    func AreExploreModelLibrariesLoaded() -> Bool {
        return exploreModelList.AreModelsLoaded()
    }
    
}
