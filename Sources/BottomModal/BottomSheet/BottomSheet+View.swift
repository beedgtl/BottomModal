//
//  BottomSheet+View.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import SwiftUI

extension View {
  public func bottomSheet<Item, Content>(
    item: Binding<Item?>,
    presentationStyle: BottomSheetPresentationStyle? = nil,
    presentationTarget: BottomSheetPresentationTarget = .controller,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> Content
  ) -> some View where Item: Identifiable, Content: View {
    let isPresented = Binding<Bool>(
      get: { item.wrappedValue != nil },
      set: { item.wrappedValue = $0 ? item.wrappedValue : nil }
    )
    let presentationStyle = presentationStyle ?? BottomSheetIntrinsicPresentationStyle()
    guard let value = item.wrappedValue else {
      let bottomSheetModifier = BottomSheetModifier<Content>(
        isPresented: isPresented,
        presentationStyle: presentationStyle,
        presentationTarget: presentationTarget,
        onDismiss: onDismiss,
        sheetContent: nil
      )
      return modifier(bottomSheetModifier)
    }

    let bottomSheetModifier = BottomSheetModifier<Content>(
      isPresented: isPresented,
      presentationStyle: presentationStyle,
      presentationTarget: presentationTarget,
      onDismiss: onDismiss
    ) {
      content(value)
    }
    return modifier(bottomSheetModifier)
  }

  public func bottomSheet<Content>(
    isPresented: Binding<Bool>,
    presentationStyle: BottomSheetPresentationStyle? = nil,
    presentationTarget: BottomSheetPresentationTarget = .controller,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View where Content: View {
    let bottomSheetModifier = BottomSheetModifier(
      isPresented: isPresented,
      presentationStyle: presentationStyle ?? BottomSheetIntrinsicPresentationStyle(),
      presentationTarget: presentationTarget,
      onDismiss: onDismiss,
      sheetContent: content
    )
    return modifier(bottomSheetModifier)
  }
}
