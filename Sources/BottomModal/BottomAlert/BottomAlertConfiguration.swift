//
//  BottomAlertConfiguration.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import SwiftUI
import PanModal

// MARK: - Environment Key
extension EnvironmentValues {
  var bottomAlertConfiguration: BottomAlertConfiguration {
    get { self[BottomAlertConfigurationKey.self] }
    set { self[BottomAlertConfigurationKey.self] = newValue }
  }
}

public struct BottomAlertConfigurationKey: EnvironmentKey {
  public static let defaultValue: BottomAlertConfiguration =
    DefaultBottomAlertConfiguration()
}

// MARK: - View Extension
extension View {
  public func bottomAlertConfiguration<Configuration: BottomAlertConfiguration>(
    _ configuration: Configuration
  ) -> some View {
    return environment(\.bottomAlertConfiguration, configuration)
  }
}

// MARK: - Configuration Protocol
public protocol BottomAlertConfiguration {
  var springDamping: CGFloat { get }
  var transitionDuration: Double { get }
  var transitionAnimationOptions: UIView.AnimationOptions { get }
  var backgroundColor: UIColor { get }
  var allowsExtendedPanScrolling: Bool { get }
  var allowsDragToDismiss: Bool { get }
  var allowsTapToDismiss: Bool { get }
  var backgroundInteraction: PanModalBackgroundInteraction { get }
  var onPresent: (() -> Void)? { get }
  var onDismiss: (() -> Void)? { get }
}

// MARK: - Default Configuration
public struct DefaultBottomAlertConfiguration: BottomAlertConfiguration {
  public var springDamping: CGFloat
  public var transitionDuration: Double
  public var transitionAnimationOptions: UIView.AnimationOptions
  public var backgroundColor: UIColor
  public var allowsExtendedPanScrolling: Bool
  public var allowsDragToDismiss: Bool
  public var allowsTapToDismiss: Bool
  public var backgroundInteraction: PanModalBackgroundInteraction
  public var onPresent: (() -> Void)?
  public var onDismiss: (() -> Void)?

  public init() {
    self.springDamping = 0.8
    self.transitionDuration = 0.5
    self.transitionAnimationOptions = [
      .curveEaseInOut,
      .allowUserInteraction,
      .beginFromCurrentState
    ]
    self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    self.allowsExtendedPanScrolling = false
    self.allowsDragToDismiss = true
    self.allowsTapToDismiss = true
    self.backgroundInteraction = .dismiss
    self.onPresent = {
      UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    self.onDismiss = nil
  }
}
