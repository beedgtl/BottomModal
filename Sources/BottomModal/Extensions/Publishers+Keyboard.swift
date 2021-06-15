//
//  Publishers+Keyboard.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//
import Combine
import Foundation
import UIKit

extension Publishers {
  enum Keyboard {
    struct Animation {
      let duration: Double
      let curve: UIView.AnimationCurve
    }

    struct Frame {
      let begin: CGRect
      let end: CGRect
    }

    struct Info {
      let animation: Animation
      let frame: Frame
    }

    static var willShow: AnyPublisher<Keyboard.Info, Never> {
      NotificationCenter.default
        .publisher(for: UIApplication.keyboardWillShowNotification)
        .map(convert(notification:))
        .eraseToAnyPublisher()
    }

    static var didShow: AnyPublisher<Keyboard.Info, Never> {
      NotificationCenter.default
        .publisher(for: UIApplication.keyboardDidShowNotification)
        .map(convert(notification:))
        .eraseToAnyPublisher()
    }

    static var willHide: AnyPublisher<Keyboard.Info, Never> {
      NotificationCenter.default
        .publisher(for: UIApplication.keyboardWillHideNotification)
        .map(convert(notification:))
        .eraseToAnyPublisher()
    }

    static var didHide: AnyPublisher<Keyboard.Info, Never> {
      NotificationCenter.default
        .publisher(for: UIApplication.keyboardDidHideNotification)
        .map(convert(notification:))
        .eraseToAnyPublisher()
    }

    private static func convert(notification: Notification) -> Info {
      let animationDurationUserInfoKey = UIResponder.keyboardAnimationDurationUserInfoKey
      let animationDuration = notification.userInfo?[animationDurationUserInfoKey] as? Double
      let animationCurveUserInfoKey = UIResponder.keyboardAnimationCurveUserInfoKey
      let animationCurve = notification.userInfo?[animationCurveUserInfoKey] as? UIView.AnimationCurve
      let animation = Animation(
        duration: animationDuration ?? 0,
        curve: animationCurve ?? .easeInOut
      )
      let frameBeginUserInfoKey = UIResponder.keyboardFrameBeginUserInfoKey
      let frameBegin = notification.userInfo?[frameBeginUserInfoKey] as? CGRect
      let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
      let frameEnd = notification.userInfo?[frameEndUserInfoKey] as? CGRect
      let frame = Frame(
        begin: frameBegin ?? .zero,
        end: frameEnd ?? .zero
      )
      return Info(animation: animation, frame: frame)
    }
  }
}
