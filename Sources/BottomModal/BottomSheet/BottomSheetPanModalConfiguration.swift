//
//  BottomSheetPanModalConfiguration.swift
//  
//
//  Created by Roman Baev on 20.07.2021.
//

import Foundation
import UIKit
import PanModal

public struct BottomSheetPanModalConfiguration: PanModalConfiguration {
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
  public var additionalTopOffset: CGFloat

  public init(configuration: BottomSheetConfiguration) {
    self.cornerRadius = configuration.cornerRadius
    self.springDamping = configuration.springDamping
    self.transitionDuration = configuration.transitionDuration
    self.transitionAnimationOptions = configuration.transitionAnimationOptions
    self.panModalBackgroundColor = configuration.panModalBackgroundColor
    self.panModalPanelColor = configuration.panModalPanelColor
    self.anchorModalToLongForm = configuration.anchorModalToLongForm
    self.allowsExtendedPanScrolling = configuration.allowsTapToDismiss
    self.allowsDragToDismiss = configuration.allowsDragToDismiss
    self.allowsTapToDismiss = configuration.allowsTapToDismiss
    self.backgroundInteraction = configuration.backgroundInteraction
    self.topDismissInset = configuration.topDismissInset
    self.additionalTopOffset = configuration.additionalTopOffset
  }
}
