//
//  BottomSheetModifier.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Combine
import Foundation
import PanModal
import SwiftUI

public struct BottomSheetModifier<SheetContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  public let presentationStyle: BottomSheetPresentationStyle
  public let presentationTarget: BottomSheetPresentationTarget
  public let onDismiss: (() -> Void)?
  public let sheetContent: (() -> SheetContent)?
  @State private var coordinator = Coordinator<SheetContent>()

  @Environment(\.bottomSheetStyle) var style
  @Environment(\.bottomSheetConfiguration) var configuration

  public init(
    isPresented: Binding<Bool>,
    presentationStyle: BottomSheetPresentationStyle,
    presentationTarget: BottomSheetPresentationTarget,
    onDismiss: (() -> Void)?,
    sheetContent: (() -> SheetContent)?
  ) {
    self._isPresented = isPresented
    self.presentationStyle = presentationStyle
    self.presentationTarget = presentationTarget
    self.onDismiss = onDismiss
    self.sheetContent = sheetContent
  }

  private var presentPublisher: AnyPublisher<AnyView, Never> {
    Just(isPresented)
      .filter { $0 }
      .filter { _ in coordinator.panModalController == nil }
      .flatMap { _ in
        Just(sheetContent?())
          .compactMap { $0 }
          .map { view in
            let configuration = BottomSheetStyleConfiguration(
              content: AnyView(view)
            )
            return style.makeBody(configuration: configuration)
          }
      }
      .eraseToAnyPublisher()
  }

  private var updatePublisher: AnyPublisher<AnyView, Never> {
    Just(isPresented)
      .filter { $0 }
      .filter { _ in coordinator.panModalController != nil }
      .flatMap { _ in
        Just(sheetContent?())
          .compactMap { $0 }
          .map { view in
            let configuration = BottomSheetStyleConfiguration(
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
        .background(
          PresentingViewController(
            viewController: coordinator.presentingViewController
          )
        )
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
      let hostingController = UIHostingController(rootView: rootView)
      coordinator.sheetContentController = hostingController
      guard
        let rootViewController = coordinator.sheetContentController,
        coordinator.panModalController == nil
      else { return }

      let panModalConfiguration = BottomSheetPanModalConfiguration(
        configuration: configuration
      )

      var panModalController = presentationStyle.makePanModalController(
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

      switch presentationTarget {
      case .controller:
        let controller = coordinator.presentingViewController
        controller.present(panModalController, animated: true)
      case .window:
        let windowScene = UIApplication.shared.connectedScenes.first
        if let windowScene = windowScene as? UIWindowScene {
          let window = UIWindow(windowScene: windowScene)
          coordinator.window = window
          let windowRootViewController = UIViewController()
          windowRootViewController.view.backgroundColor = .clear
          window.rootViewController = windowRootViewController
          window.windowLevel = UIWindow.Level.statusBar - 1
          window.makeKeyAndVisible()
          // fix unbalance calls warning
          DispatchQueue.main.async {
            windowRootViewController.present(panModalController, animated: true)
          }
        }
      }
    }
    .onReceive(updatePublisher) { rootView in
      coordinator.sheetContentController?.rootView = rootView
      coordinator.sheetContentController?.view.invalidateIntrinsicContentSize()
    }
    .onReceive(dismissPublisher) {
      configuration.onDismiss?()
      coordinator.panModalController?.dismiss(animated: true) {
        coordinator.invalidate()
      }
    }
  }

  class Coordinator<Content>: ObservableObject where Content: View {
    var window: UIWindow?
    let presentingViewController: UIViewController = UIViewController()
    var sheetContentController: UIHostingController<AnyView>?
    var panModalController: UIViewController?

    func invalidate() {
      window?.isHidden = true
      window = nil
      panModalController = nil
      sheetContentController = nil
    }
  }
}

private struct PresentingViewController: UIViewControllerRepresentable {
  let viewController: UIViewController

  func makeUIViewController(context: Context) -> some UIViewController {
    return viewController
  }

  func updateUIViewController(
    _ uiViewController: UIViewControllerType,
    context: Context
  ) {}
}
