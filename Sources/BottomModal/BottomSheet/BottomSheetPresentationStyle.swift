//
//  BottomSheetPresentationStyle.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import SwiftUI
import PanModal

public protocol BottomSheetPresentationStyle {
  typealias PanModalController = UIViewController
    & PanModalPresentable
    & PanModalDismissable
  func makePanModalController(
    rootViewController: UIViewController,
    configuration: PanModalConfiguration
  ) -> PanModalController
}

public struct BottomSheetIntrinsicPresentationStyle: BottomSheetPresentationStyle {
  public init() {}

  public func makePanModalController(
    rootViewController: UIViewController,
    configuration: PanModalConfiguration
  ) -> PanModalController {
    return IntrinsicPanModalController(
      rootViewController: rootViewController,
      configuration: configuration
    )
  }
}

public struct BottomSheetFixedPresentationStyle: BottomSheetPresentationStyle {
  public let height: BottomSheetHeight

  public init(height: BottomSheetHeight) {
    self.height = height
  }

  public func makePanModalController(
    rootViewController: UIViewController,
    configuration: PanModalConfiguration
  ) -> PanModalController {
    return FixedPanModalController(
      rootViewController: rootViewController,
      configuration: configuration,
      height: height
    )
  }
}

public struct BottomSheetFullPresentationStyle: BottomSheetPresentationStyle {
  public init() {}
  
  public func makePanModalController(
    rootViewController: UIViewController,
    configuration: PanModalConfiguration
  ) -> PanModalController {
    return FullPanModalController(
      rootViewController: rootViewController,
      configuration: configuration
    )
  }
}

public struct BottomSheetDynamicPresentationStyle: BottomSheetPresentationStyle {
  let anchorHeight: BottomSheetHeight

  public init(anchorHeight: BottomSheetHeight) {
    self.anchorHeight = anchorHeight
  }

  public func makePanModalController(
    rootViewController: UIViewController,
    configuration: PanModalConfiguration
  ) -> PanModalController {
    return DynamicPanModalController(
      rootViewController: rootViewController,
      configuration: configuration,
      anchorHeight: anchorHeight
    )
  }
}

struct BottomSheetPresentationPreferenceKey: PreferenceKey {
  static var defaultValue: BottomSheetIntrinsicPresentationStyle =
    BottomSheetIntrinsicPresentationStyle()

  static func reduce(
    value: inout BottomSheetIntrinsicPresentationStyle,
    nextValue: () -> BottomSheetIntrinsicPresentationStyle
  ) {
    value = nextValue()
  }
}
