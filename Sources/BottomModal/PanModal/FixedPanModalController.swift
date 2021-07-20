//
//  FixedPanModalController.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import Combine
import SwiftUI
import PanModal

public final class FixedPanModalController: BasePanModalController {
  let height: BottomSheetHeight
  public override var anchorModalToLongForm: Bool { panScrollable != nil }
  public override var longFormHeight: PanModalHeight { .contentHeight(fixedHeight + keyboardHeight) }

  var fixedHeight: CGFloat {
    switch height {
    case let .points(value):
      return value
    case let .fraction(value):
      guard let presentingViewControllerHeight = presentingViewController?.view.frame.height else {
        return view.frame.height * value
      }
      return presentingViewControllerHeight * value
    }
  }
  var keyboardHeight: CGFloat = 0

  init(
    rootViewController: UIViewController,
    configuration: PanModalConfiguration,
    height: BottomSheetHeight
  ) {
    self.height = height
    super.init(
      rootViewController: rootViewController,
      configuration: configuration
    )
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: view.topAnchor),
      contentView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
    ])
  }

  override func keyboardHeightWillChange(to height: CGFloat) {
    keyboardHeight = height
    panModalSetNeedsLayoutUpdate()
    panModalTransition(to: .longForm)
  }
}
