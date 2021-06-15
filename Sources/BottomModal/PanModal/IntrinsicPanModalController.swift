//
//  IntrinsicPanModalController.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import Combine
import SwiftUI
import PanModal

class IntrinsicPanModalController: BasePanModalController {
  override var anchorModalToLongForm: Bool { false }
  override var followScrollView: Bool { false }
  override var longFormHeight: PanModalHeight { .intrinsicHeight }

  private var bottomConstraint: NSLayoutConstraint?

  override func viewDidLoad() {
    super.viewDidLoad()
    let constraint = view.bottomAnchor.constraint(
      greaterThanOrEqualTo: contentView.bottomAnchor
    )
    bottomConstraint = constraint

    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: view.topAnchor),
      constraint
    ])
  }

  override func keyboardHeightWillChange(to height: CGFloat) {
    bottomConstraint?.constant = max(0, height - bottomSafeArea)
    panModalSetNeedsLayoutUpdate()
    panModalTransition(to: .longForm)
  }

  override func contentViewSizeDidChange(to size: CGSize) {
    panModalSetNeedsLayoutUpdate()
    panModalTransition(to: .longForm)
  }
}
