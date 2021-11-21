# ACRT

## Requirement
- ~~Xcode Version Version 13.0 beta 3 (13A5192j) [For development only]~~
> Beta 4 will cause unkow issues!
- Xcode Version 13.0 (13A233)
- leanCloud
- iOS 15

## Install
- First install [cocoapods](https://guides.cocoapods.org/using/getting-started.html)
```shell
sudo gem install cocoapods
```

- install leanCloud

```shell
cd to/this/project/
# pod init
pod init # if Podfile exit then skip this step
```

- Edit the Podfile

  ```shell
  # Uncomment the next line to define a global platform for your project
  platform :ios, '15.0'
  
  target 'ACRT' do
    # Comment the next line if you don't want to use dynamic frameworks
    use_frameworks!
    pod 'LeanCloud'
    # Pods for ACRT
  
  end
  ```
> [reference: get started](https://cocoapods.org)

- then run the code in shell

  ```shell
  pod install
  ```

  > For Device with M1 or M1 Pro chip, there will have issue running `pod update`
  >
  > First: `sudo arch -x86_64 gem install ffi`
  >
  > Then: `arch -x86_64 pod install`
  > reference: [ISSUE10220](https://github.com/CocoaPods/CocoaPods/issues/10220)

- Open `xxx.xworkspace`

    > Use Package: [FoucusEntity](https://github.com/ZibYang/FocusEntity)

## Debug hint



## Copyright

```
        _         ____
       / \      |  __  \
      / _ \     | |   \ \      ____     _______
     / / \ \    | |___/ /    /  ___ \ / __   __ \
    / /___\ \   |  ___ \    / /          / /
   / /     \ \  | |   \ \   \ \ ___     / /
  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
```

Created by ARCT_ZJU_Lab509.

Copyright © Augmented City Reality Toolkit. All Right Reserved.

