//
//  File.swift
//  
//
//  Created by Roman Baev on 09.09.2021.
//

import Foundation
import UIKit

final class WindorRootViewController: UIViewController {
  let onReadyToPresent: (UIViewController) -> Void
  var isPresented = false

  init(
    onDidLoad: @escaping (UIViewController) -> Void
  ) {
    self.onReadyToPresent = onDidLoad
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard !isPresented else { return }
    onReadyToPresent(self)
    isPresented = true
  }
}
