//
//  BasePanModalController.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import Combine
import SwiftUI
import PanModal

public class BasePanModalController: UIViewController, PanModalPresentable, PanModalDismissable {
  public let rootViewController: UIViewController
  public let configuration: PanModalConfiguration
  public var onDismiss: (() -> Void)?

  public var anchorModalToLongForm: Bool { configuration.anchorModalToLongForm }
  public var cornerRadius: CGFloat { configuration.cornerRadius }
  public var shouldRoundTopCorners: Bool { configuration.cornerRadius > 0 }
  public var backgroundInteraction: PanModalBackgroundInteraction {
    configuration.backgroundInteraction
  }
  public var springDamping: CGFloat { configuration.springDamping }
  public var transitionDuration: Double { configuration.transitionDuration }
  public var transitionAnimationOptions: UIView.AnimationOptions {
    configuration.transitionAnimationOptions
  }
  public var panModalBackgroundColor: UIColor { configuration.panModalBackgroundColor }
  public var allowsExtendedPanScrolling: Bool { configuration.allowsExtendedPanScrolling }
  public var allowsDragToDismiss: Bool { configuration.allowsDragToDismiss }
  public var allowsTapToDismiss: Bool { configuration.allowsTapToDismiss }

  public var longFormHeight: PanModalHeight { .maxHeight }
  public var shortFormHeight: PanModalHeight { longFormHeight }
  public var followScrollView: Bool { true }
  public var showDragIndicator: Bool { false }
  public var isHapticFeedbackEnabled: Bool { false }
  public var scrollIndicatorInsets: UIEdgeInsets { .zero }
  public var bottomSafeArea: CGFloat {
    presentingViewController?.view.safeAreaInsets.bottom ?? 0
  }
  // swiftlint:disable:next identifier_name
  var _panScrollable: UIScrollView?
  public var panScrollable: UIScrollView? {
    guard followScrollView else { return nil }
    guard let scrollView = _panScrollable else {
      view.layoutIfNeeded()
      _panScrollable = rootViewController.view.firstSubview(of: UIScrollView.self)
      return _panScrollable
    }
    return scrollView
  }

  public var contentView: UIView {
    rootViewController.view
  }
  private var rootViewFrameObservation: NSKeyValueObservation?
  private var subscriptions = Set<AnyCancellable>()

  public init(
    rootViewController: UIViewController,
    configuration: PanModalConfiguration
  ) {
    self.rootViewController = rootViewController
    self.configuration = configuration
    super.init(nibName: nil, bundle: nil)

    Publishers.Keyboard.willShow
      .sink { [weak self] info in
        self?.keyboardHeightWillChange(to: info.frame.end.height)
      }
      .store(in: &subscriptions)

    Publishers.Keyboard.willHide
      .sink { [weak self] _ in
        self?.keyboardHeightWillChange(to: 0)
      }
      .store(in: &subscriptions)

    self.rootViewFrameObservation = rootViewController
      .observe(\.view.bounds, options: [.new, .old]) { [weak self] _, change in
        guard change.newValue != change.oldValue,
              change.oldValue != .zero
        else { return }
        guard let contentSize = change.newValue?.size else { return }
        self?.contentViewSizeDidChange(to: contentSize)
      }
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    rootViewFrameObservation?.invalidate()
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = configuration.panModalPanelColor
    view.addSubview(rootViewController.view)
    addChild(rootViewController)
    rootViewController.view.backgroundColor = .clear
    rootViewController.view.translatesAutoresizingMaskIntoConstraints = false
    rootViewController.didMove(toParent: self)
  }

  public func panModalDidDismiss() {
    onDismiss?()
  }

  public func shouldPrioritize(
    panModalGestureRecognizer: UIPanGestureRecognizer
  ) -> Bool {
    let location = panModalGestureRecognizer.location(in: view)
    let dragIndicatorFrame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.width,
      height: configuration.topDismissInset
    )
    return dragIndicatorFrame.contains(location)
  }

  func keyboardHeightWillChange(to height: CGFloat) {}

  func contentViewSizeDidChange(to size: CGSize) {}
}

