//
//  PanModalDismissable.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//
import Foundation

public protocol PanModalDismissable {
  var onDismiss: (() -> Void)? { get set }
}
