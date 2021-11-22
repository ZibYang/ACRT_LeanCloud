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
    var exploreModelList = USDZModelList(usdzModelNameList:  ["qs_AppleLogo_left", //1
                                                              "qs_AppleLogo_right", //2
                                                              "qs_AppleMusic", //3
                                                              "qs_AppStore", //4
                                                              "qs_Calendar", //5
                                                              "qs_Camera", //5
                                                              "qs_Facetime", //6
                                                              "qs_Health", //7
                                                              "qs_Hello", //8
                                                              "qs_Home", //9
                                                              "qs_iBook", //10
                                                              "qs_iMessage", //11
                                                              "qs_Phone", //12
                                                              "qs_Safari", //13
                                                              "qs_Setting", //14
                                                              "qs_Swift", //15
                                                              "qs_SwiftChangeTheWorld", //16
                                                              "qs_Weather", //17
                                                              "yt_BugerKing", //18
                                                              "yt_BugerKing", //19
                                                              "yt_Cocacola", //20
                                                              "yt_Coffee", // 21
                                                              "yt_FrenchFires", //22
                                                              "yt_KFC", //23
                                                              "yt_McDonald's",//24
                                                              "qs_findMy", //25
                                                              "qs_Title", //26
                                                              "qs_contact" //27
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
    
    var createModelList = USDZModelList(usdzModelNameList:["user_like_blue", //1
                                                           "user_like_red", //2
                                                           "user_love_red", //3
                                                           "user_love_white", //4
                                                           
                                                            "user_letter_A", //1
                                                            "user_letter_B", //2
                                                            "user_letter_C", //3
                                                            "user_letter_D", //4
                                                            "user_letter_E", //5
                                                            "user_letter_F", //6
                                                            "user_letter_H", //7
                                                            "user_letter_L", //8
                                                            "user_letter_O", //9
                                                            "user_letter_P", //10
                                                           
//                                                           "user_message_HELLO!", //1
//                                                           "user_message_LOL", //2
//                                                           "user_message_OHNO!", //3
                                                           "user_message_OMG!", //4
//                                                           "user_message_OOPS!", //5
//                                                           "user_message_OUCH!", //6
//                                                           "user_message_ZZZ..", //7
//                                                           "user_message_POP!", //8
//                                                           "user_message_POW!", //9
//                                                           "user_message_SHH!", //10
//                                                           "user_message_WTF", //11
//                                                           "user_message_YEAH!", //12
                                                           "user_message_YES!", //13
//                                                           "user_message_YES!2", //14
//                                                           "user_message_DAMN!", //15
//                                                           "user_message_ZAP!", //16
                                                           "user_message_BANG!", //17
                                                           "user_message_BOOM!", //18
                                                           "user_message_COOL", //19
//                                                           "user_message_CRASH!" //20
                                                           
                                                           "user_emoji_smileWithSweat", //1
                                                           "user_emoji_smile", //2
                                                           
                                                           "user_special_pumpkin", //1
                                                           "user_special_witchHat", //2
                                                           "user_special_skull", //3
                                                           "user_special_candy", //4
                                                           "user_special_bat", //5
                                                           "user_special_deadHand", //6
                                                           "user_special_ghost" //7
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
                                                      .special //7
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
