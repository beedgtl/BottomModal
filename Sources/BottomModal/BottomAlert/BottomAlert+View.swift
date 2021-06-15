//
//  BottomAlert+View.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import SwiftUI

extension View {
  public func bottomAlert<Item, Content>(
    item: Binding<Item?>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View where Item: Identifiable, Content: View {
    let isPresented = Binding<Bool>(
      get: { item.wrappedValue != nil },
      set: { item.wrappedValue = $0 ? item.wrappedValue : nil }
    )

    guard let value = item.wrappedValue else {
      let bottomAlertModifier = BottomAlertModifier<Content>(
        isPresented: isPresented,
        onDismiss: onDismiss,
        alertContent: nil
      )
      return modifier(bottomAlertModifier)
    }

    let bottomAlertModifier = BottomAlertModifier<Content>(
      isPresented: isPresented,
      onDismiss: onDismiss
    ) {
      content(value)
    }
    return modifier(bottomAlertModifier)
  }

  public func bottomAlert<Content>(
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View where Content: View {
    let bottomAlertModifier = BottomAlertModifier(
      isPresented: isPresented,
      onDismiss: onDismiss,
      alertContent: content
    )
    return modifier(bottomAlertModifier)
  }
}
