//
//  BottomSheetConfiguration.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import SwiftUI
import PanModal

// MARK: - Environment Key
extension EnvironmentValues {
  var bottomSheetConfiguration: BottomSheetConfiguration {
    get { self[BottomSheetConfigurationKey.self] }
    set { self[BottomSheetConfigurationKey.self] = newValue }
  }
}

public struct BottomSheetConfigurationKey: EnvironmentKey {
  public static let defaultValue: BottomSheetConfiguration =
    DefaultBottomSheetConfiguration()
}

// MARK: - View Extension
extension View {
  public func bottomSheetConfiguration<Configuration: BottomSheetConfiguration>(
    _ configuration: Configuration
  ) -> some View {
    return environment(\.bottomSheetConfiguration, configuration)
  }
}

// MARK: - Configuration Protocol
public protocol BottomSheetConfiguration {
  var cornerRadius: CGFloat { get }
  var springDamping: CGFloat { get }
  var transitionDuration: Double { get }
  var transitionAnimationOptions: UIView.AnimationOptions { get }
  var panModalBackgroundColor: UIColor { get }
  var panModalPanelColor: UIColor { get }
  var anchorModalToLongForm: Bool { get }
  var allowsExtendedPanScrolling: Bool { get }
  var allowsDragToDismiss: Bool { get }
  var allowsTapToDismiss: Bool { get }
  var backgroundInteraction: PanModalBackgroundInteraction { get }
  var topDismissInset: CGFloat { get }
  var onPresent: (() -> Void)? { get }
  var onDismiss: (() -> Void)? { get }
  var additionalTopOffset: CGFloat { get }
}

// MARK: - Default Configuration
public struct DefaultBottomSheetConfiguration: BottomSheetConfiguration {
  public var cornerRadius: CGFloat
  public var springDamping: CGFloat
  public var transitionDuration: Double
  public var transitionAnimationOptions: UIView.AnimationOptions
  public var panModalBackgroundColor: UIColor
  public var panModalPanelColor: UIColor
  public var anchorModalToLongForm: Bool
  public var allowsExtendedPanScrolling: Bool
  public var allowsDragToDismiss: Bool
  public var allowsTapToDismiss: Bool
  public var backgroundInteraction: PanModalBackgroundInteraction
  public var topDismissInset: CGFloat
  public var onPresent: (() -> Void)?
  public var onDismiss: (() -> Void)?
  public var additionalTopOffset: CGFloat

  public init() {
    self.cornerRadius = 8
    self.springDamping = 0.8
    self.transitionDuration = 0.5
    self.transitionAnimationOptions = [
      .curveEaseInOut,
      .allowUserInteraction,
      .beginFromCurrentState
    ]
    self.panModalBackgroundColor = .black.withAlphaComponent(0.3)
    self.panModalPanelColor = .systemBackground
    self.anchorModalToLongForm = false
    self.allowsExtendedPanScrolling = false
    self.allowsDragToDismiss = true
    self.allowsTapToDismiss = true
    self.backgroundInteraction = .dismiss
    self.topDismissInset = 64
    self.onPresent = {
      UISelectionFeedbackGenerator().selectionChanged()
    }
    self.onDismiss = nil
    self.additionalTopOffset = 21.0
  }
}
