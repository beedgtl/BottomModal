//
//  BottomAlertModifier.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import SwiftUI
import Combine
import PanModal

public struct BottomAlertModifier<AlertContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  public let onDismiss: (() -> Void)?
  public let alertContent: (() -> AlertContent)?
  @State private var coordinator = Coordinator()

  @Environment(\.bottomAlertStyle) var style
  @Environment(\.bottomAlertConfiguration) var configuration

  public init(
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)?,
    alertContent: (() -> AlertContent)?
  ) {
    self._isPresented = isPresented
    self.onDismiss = onDismiss
    self.alertContent = alertContent
  }

  private var presentPublisher: AnyPublisher<AnyView, Never> {
    Just(isPresented)
      .filter { $0 }
      .filter { _ in coordinator.panModalController == nil }
      .flatMap { _ in
        Just(alertContent?())
          .compactMap { $0 }
          .map { view in
            let configuration = BottomAlertStyleConfiguration(
              content: AnyView(view)
            )
            return style.makeBody(configuration: configuration)
          }
      }
      .eraseToAnyPublisher()
  }

  private var updatePublisher: AnyPublisher<AnyView, Never> {
    return Just(isPresented)
      .filter { $0 }
      .filter { _ in coordinator.panModalController != nil }
      .flatMap { _ in
        return Just(alertContent?())
          .compactMap { $0 }
          .map { view in
            let configuration = BottomAlertStyleConfiguration(
              content: AnyView(view)
            )
            return style.makeBody(configuration: configuration)
          }
      }
      .eraseToAnyPublisher()
  }

  private var dismissPublisher: AnyPublisher<Void, Never> {
    Just(isPresented)
      .filter { !$0 }
      .filter { _ in coordinator.panModalController != nil }
      .map { _ in }
      .eraseToAnyPublisher()
  }

  public func body(content: Content) -> some View {
    Group {
      content
      if isPresented {}
    }
    .onReceive(presentPublisher) { rootView in
      configuration.onPresent?()
      UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
      )
      let hostingController = UIHostingController(
        rootView: rootView,
        ignoreSafeArea: true
      )
      coordinator.alertContentController = hostingController
      guard
        let rootViewController = coordinator.alertContentController,
        coordinator.panModalController == nil
      else { return }

      var panModalConfiguration = DefaultPanModalConfiguration()
      panModalConfiguration.springDamping = configuration.springDamping
      panModalConfiguration.transitionDuration = configuration.transitionDuration
      panModalConfiguration.transitionAnimationOptions = configuration.transitionAnimationOptions
      panModalConfiguration.panModalBackgroundColor = configuration.backgroundColor
      panModalConfiguration.allowsExtendedPanScrolling = configuration.allowsExtendedPanScrolling
      panModalConfiguration.allowsDragToDismiss = configuration.allowsDragToDismiss
      panModalConfiguration.allowsTapToDismiss = configuration.allowsTapToDismiss
      panModalConfiguration.cornerRadius = 0
      panModalConfiguration.panModalPanelColor = .clear
      panModalConfiguration.backgroundInteraction = configuration.backgroundInteraction

      let panModalController = IntrinsicPanModalController(
        rootViewController: rootViewController,
        configuration: panModalConfiguration
      )

      panModalController.modalPresentationStyle = .custom
      panModalController.modalPresentationCapturesStatusBarAppearance = true
      panModalController.transitioningDelegate = PanModalPresentationDelegate.default
      panModalController.onDismiss = {
        isPresented = false
        coordinator.invalidate()
        onDismiss?()
      }

      coordinator.panModalController = panModalController
      let windowScene = UIApplication.shared.connectedScenes.first
      if let windowScene = windowScene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
        coordinator.window = window
        let windowRootViewController = UIViewController()
        window.windowLevel = UIWindow.Level.alert
        window.rootViewController = windowRootViewController
        window.makeKeyAndVisible()
        windowRootViewController.view.backgroundColor = .clear
        // fix unbalance calls warning
        DispatchQueue.main.async {
          windowRootViewController.present(panModalController, animated: true)
        }
      }
    }
    .onReceive(updatePublisher) { rootView in
      coordinator.alertContentController?.rootView = rootView
      coordinator.alertContentController?.view.invalidateIntrinsicContentSize()
    }
    .onReceive(dismissPublisher) {
      configuration.onDismiss?()
      coordinator.panModalController?.dismiss(animated: true) {
        coordinator.invalidate()
      }
    }
  }

  class Coordinator: ObservableObject {
    var window: UIWindow?
    var alertContentController: UIHostingController<AnyView>?
    var panModalController: UIViewController?

    func invalidate() {
      window?.isHidden = true
      window = nil
      panModalController = nil
      alertContentController = nil
    }
  }
}
