//
//  FullPanModalController.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import Combine
import SwiftUI
import PanModal

final class FullPanModalController: BasePanModalController {
  override var anchorModalToLongForm: Bool { panScrollable != nil }
  override var longFormHeight: PanModalHeight { .maxHeight }
  override var shortFormHeight: PanModalHeight { longFormHeight }

  override func viewDidLoad() {
    super.viewDidLoad()
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      view.topAnchor.constraint(equalTo: contentView.topAnchor),
      view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  override func keyboardHeightWillChange(to height: CGFloat) {
    guard let scrollView = panScrollable else { return }
    scrollView.contentInset.bottom = max(height, bottomSafeArea)
    scrollView.verticalScrollIndicatorInsets.bottom = max(
      height - bottomSafeArea,
      0
    )
  }
}
