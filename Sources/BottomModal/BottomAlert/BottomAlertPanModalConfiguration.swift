//
//  BottomAlertPanModalConfiguration.swift
//  BottomModal
//
//  Created by Roman Baev on 20.07.2021.
//

import Foundation
import UIKit
import PanModal

public struct BottomAlertPanModalConfiguration: PanModalConfiguration {
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

  public init(configuration: BottomAlertConfiguration) {
    let defaultPanModalConfiguration = DefaultPanModalConfiguration()

    self.springDamping = configuration.springDamping
    self.transitionDuration = configuration.transitionDuration
    self.transitionAnimationOptions = configuration.transitionAnimationOptions
    self.panModalBackgroundColor = configuration.backgroundColor
    self.allowsExtendedPanScrolling = configuration.allowsExtendedPanScrolling
    self.allowsDragToDismiss = configuration.allowsDragToDismiss
    self.allowsTapToDismiss = configuration.allowsTapToDismiss
    self.cornerRadius = 0
    self.panModalPanelColor = .clear
    self.backgroundInteraction = configuration.backgroundInteraction

    self.panModalPanelColor = defaultPanModalConfiguration.panModalPanelColor
    self.anchorModalToLongForm = defaultPanModalConfiguration.anchorModalToLongForm
    self.topDismissInset = defaultPanModalConfiguration.topDismissInset
  }
}
