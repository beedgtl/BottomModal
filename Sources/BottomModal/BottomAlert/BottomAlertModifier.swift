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

      let panModalConfiguration = BottomAlertPanModalConfiguration(
        configuration: configuration
      )

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
        let rootViewController = WindorRootViewController { [unowned panModalController] viewController in
          viewController.present(panModalController, animated: true)
        }
        rootViewController.view.backgroundColor = .clear

        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = UIWindow.Level.alert
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        coordinator.window = window

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700)) {
          if rootViewController.presentedViewController == nil {
            assertionFailure("BottomAlertModifier: PanModalController not presented from \(rootViewController) \(rootViewController.view.frame)")
          }
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
