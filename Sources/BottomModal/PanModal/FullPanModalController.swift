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

public final class FullPanModalController: BasePanModalController {
  public override var anchorModalToLongForm: Bool { panScrollable != nil }
  public override var longFormHeight: PanModalHeight { .maxHeight }
  public override var shortFormHeight: PanModalHeight { longFormHeight }

  public override func viewDidLoad() {
    super.viewDidLoad()
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: view.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  override func keyboardHeightWillChange(to height: CGFloat) {
    guard let scrollView = panScrollable else { return }
    scrollView.contentInset.bottom = max(height, bottomLayoutOffset)
    scrollView.verticalScrollIndicatorInsets.bottom = max(
      height - bottomLayoutOffset,
      0
    )
  }
}
