//
//  BottomSheetStyle.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//
import Foundation
import SwiftUI

// MARK: - Environment Key
extension EnvironmentValues {
  var bottomSheetStyle: AnyBottomSheetStyle {
    get { self[BottomSheetStyleKey.self] }
    set { self[BottomSheetStyleKey.self] = newValue }
  }
}

public struct BottomSheetStyleKey: EnvironmentKey {
  public static let defaultValue = AnyBottomSheetStyle(DefaultBottomSheetStyle())
}

// MARK: - View Extension
extension View {
  public func bottomSheetStyle<Style: BottomSheetStyle>(
    _ style: Style
  ) -> some View {
    return environment(\.bottomSheetStyle, AnyBottomSheetStyle(style))
  }
}

// MARK: - Style Protocol
public protocol BottomSheetStyle {
  associatedtype Body: View

  func makeBody(configuration: Self.Configuration) -> Self.Body

  typealias Configuration = BottomSheetStyleConfiguration
}

extension BottomSheetStyle {
  func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
    AnyView(makeBody(configuration: configuration))
  }
}

public struct BottomSheetStyleConfiguration {
  public let content: AnyView

  public init(content: AnyView) {
    self.content = content
  }
}

// MARK: - Type Erased Style
public struct AnyBottomSheetStyle: BottomSheetStyle {
  private let makeBody: (BottomSheetStyle.Configuration) -> AnyView

  init<Style: BottomSheetStyle>(_ style: Style) {
    makeBody = style.makeBodyTypeErased
  }

  public func makeBody(
    configuration: BottomSheetStyle.Configuration
  ) -> AnyView {
    return makeBody(configuration)
  }
}

// MARK: - Default Style
public struct DefaultBottomSheetStyle: BottomSheetStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    BottomSheet(content: configuration.content)
  }

  public struct BottomSheet<Content: View>: View {
    let content: Content

    public var body: some View {
      content
        .padding()
    }
  }
}

