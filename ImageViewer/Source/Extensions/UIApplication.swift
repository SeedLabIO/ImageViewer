//
//  UIApplication.swift
//  ImageViewer
//
//  Created by Kristian Angyal on 19/07/2016.
//  Copyright © 2016 MailOnline. All rights reserved.
//

import UIKit

extension UIApplication {

    static var applicationWindow: UIWindow? {
        if (isExtension()) {
            return nil
        }
        return (UIApplication.shared.delegate?.window?.flatMap { $0 })!
    }

    static var isPortraitOnly: Bool {
        if (isExtension()) {
            return true // todo: or??
        }

        let orientations = UIApplication.shared.supportedInterfaceOrientations(for: nil)

        return !(orientations.contains(.landscapeLeft) || orientations.contains(.landscapeRight) || orientations.contains(.landscape))
    }
}
