//
//  BottomAlertStyle.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import SwiftUI

// MARK: - Environment Key
extension EnvironmentValues {
  var bottomAlertStyle: AnyBottomAlertStyle {
    get { self[BottomAlertStyleKey.self] }
    set { self[BottomAlertStyleKey.self] = newValue }
  }
}

public struct BottomAlertStyleKey: EnvironmentKey {
  public static let defaultValue = AnyBottomAlertStyle(
    DefaultBottomAlertStyle()
  )
}

// MARK: - View Extension
extension View {
  public func bottomAlertStyle<Style: BottomAlertStyle>(
    _ style: Style
  ) -> some View {
    return environment(\.bottomAlertStyle, AnyBottomAlertStyle(style))
  }
}

// MARK: - Style Protocol
public protocol BottomAlertStyle {
  associatedtype Body: View

  func makeBody(configuration: Self.Configuration) -> Self.Body

  typealias Configuration = BottomAlertStyleConfiguration
}

extension BottomAlertStyle {
  public func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
    AnyView(makeBody(configuration: configuration))
  }
}

public struct BottomAlertStyleConfiguration {
  public let content: AnyView

  public init(content: AnyView) {
    self.content = content
  }
}

// MARK: - Type Erased Style
public struct AnyBottomAlertStyle: BottomAlertStyle {
  private let makeBody: (BottomAlertStyle.Configuration) -> AnyView

  public init<Style: BottomAlertStyle>(_ style: Style) {
    makeBody = style.makeBodyTypeErased
  }

  public func makeBody(
    configuration: BottomAlertStyle.Configuration
  ) -> AnyView {
    return makeBody(configuration)
  }
}

// MARK: - Default Style
public struct DefaultBottomAlertStyle: BottomAlertStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    BottomAlert(content: configuration.content)
  }

  public struct BottomAlert<Content: View>: View {
    let content: Content

    public var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .foregroundColor(Color(.secondarySystemBackground))
        content
          .padding()
      }
      .padding(20)
    }
  }
}
