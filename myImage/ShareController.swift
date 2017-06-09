//
//  ShareController.swift
//  myImage
//
//  Created by Damir Kazbekov on 5/28/17.
//  Copyright © 2017 damirkazbekov. All rights reserved.
//

import UIKit
import Social

final class ShareController {
    static func shareFacebookPost(vc:UIViewController) {
        SwiftNotice.wait()
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("Get this amazing app on bit.ly/wowpaperapp")
            facebookSheet.add(UIImage(named: "AppIcon"))
            SwiftNotice.clear()
            vc.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            SwiftNotice.clear()
            vc.present(alert, animated: true, completion: nil)
        }
    }
    static func shareTwitterPost(vc:UIViewController) {
        SwiftNotice.wait()
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            facebookSheet.setInitialText("Get this amazing app on bit.ly/wowpaperapp")
            facebookSheet.add(UIImage(named: "AppIcon"))
            SwiftNotice.clear()
            vc.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            SwiftNotice.clear()
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
