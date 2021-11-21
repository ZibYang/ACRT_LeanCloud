//
//  CoachingViewModel.swift
//  ACRT
//
//  Created by baochong on 2021/11/5.
//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.
//

import Foundation


class CoachingViewModel : ObservableObject {
    @Published var isCoaching : Bool = false
    @Published var showQuitButton : Bool = false
    @Published var comeFromPrepareView : Bool = true
    @Published var isInsideQiushi: Bool = false
    var maxWaitForLoc : Double  = 3
    
    
    func StartLocalizationAndModelLoadingAsync(httpManager : HttpAuth,
                                               arViewModel: ARViewModel
                                               ) {
        
        if httpManager.statusLoc == 1 {
            return
        }
        self.showQuitButton = false
        self.isCoaching = true
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            let start = CFAbsoluteTimeGetCurrent()
            var enableQuitButton : Bool = false
            // run your work
            while(httpManager.statusLoc != 1) {
                if(httpManager.statusLoc == 0) {
                    arViewModel.RequestLocalization(manager: httpManager)
                }
                if((CFAbsoluteTimeGetCurrent() - start) > self.maxWaitForLoc && !enableQuitButton) {
                    enableQuitButton = true
                    print("DEBUG(BCH): Request takes too long")
                    DispatchQueue.main.async {
                        self.showQuitButton = true
                    }
                }
                if(!self.isCoaching) {
                    break
                }
            }
            if(self.isCoaching) {
//                while(!usdzManagerViewModel.AreExploreModelLibrariesLoaded()) {
//                    sleep(1)
//                }
                DispatchQueue.main.async {
                    print("DEBUG(BCH): arViewModel isCoaching close")
                    self.isCoaching = false
                }
            }
           
        }
    }
    
}
