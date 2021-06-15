//
//  UIViewController+.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import UIKit

extension UIViewController {
  public func contentViewController() -> UIViewController {
    if let viewController = presentedViewController {
      return viewController.contentViewController()
    }

    if let navigationController = self as? UINavigationController {
      let contentViewController = navigationController
        .visibleViewController?
        .contentViewController()
      return contentViewController ?? navigationController
    }

    if let tabBarController = self as? UITabBarController {
      let contentViewController = tabBarController
        .selectedViewController?
        .contentViewController()
      return contentViewController ?? tabBarController
    }

    return self
  }
}
