//
//  UIHostingController+.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import SwiftUI

// Disables automatic keyboard avoidance on ios 14+
// https://steipete.com/posts/disabling-keyboard-avoidance-in-swiftui-uihostingcontroller/
extension UIHostingController {
  convenience public init(rootView: Content, ignoreSafeArea: Bool) {
    self.init(rootView: rootView)

    if ignoreSafeArea {
      if #available(iOS 14.0, *) {
        disableSafeArea()
      }
    }
  }

  func disableSafeArea() {
    #if swift(>=5.6)
    #warning("Check disableSafeArea method in UIHostingController+.swift")
    #endif
    guard let viewClass = object_getClass(view) else { return }

    let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
    if let viewSubclass = NSClassFromString(viewSubclassName) {
      object_setClass(view, viewSubclass)
    }
    else {
      guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
      guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }

      if let method = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)) {
        let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in
          return .zero
        }
        class_addMethod(viewSubclass, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
      }

      if let method2 = class_getInstanceMethod(viewClass, NSSelectorFromString("keyboardWillShowWithNotification:")) {
        let keyboardWillShow: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }
        class_addMethod(viewSubclass, NSSelectorFromString("keyboardWillShowWithNotification:"), imp_implementationWithBlock(keyboardWillShow), method_getTypeEncoding(method2))
      }

      objc_registerClassPair(viewSubclass)
      object_setClass(view, viewSubclass)
    }
  }
}
