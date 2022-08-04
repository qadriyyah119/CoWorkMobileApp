//
//  NotificationBanner.swift
//  CoWorkMobileApp
//
//  Created by Qadriyyah Thomas on 8/3/22.
//

import UIKit
import NotificationBannerSwift

class Banner: NotificationBanner {
    
    static func showBanner(withTitle title: String, subtitle: String, style: BannerStyle) {
        let banner: NotificationBanner = NotificationBanner(title: title, subtitle: subtitle, style: style)
        banner.show()
    }
}
