//
//  View+.swift
//  BottomModal
//
//  Created by Roman Baev on 9.06.2021.
//

import Foundation
import UIKit

private struct Queue<T> {
  var array: [T] = []

  var isEmpty: Bool {
    return array.isEmpty
  }

  var count: Int {
    return array.count
  }

  mutating func enqueue(_ element: T) {
    array.append(element)
  }

  mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }

  var front: T? {
    return array.first
  }
}

extension UIView {
  func firstSubview<T: UIView>(of _: T.Type) -> T? {
    var queue = Queue<[UIView]>()
    queue.enqueue(subviews)

    while let subviews = queue.dequeue() {
      for subview in subviews {
        if let firstSubview = subview as? T {
          return firstSubview
        } else {
          queue.enqueue(subview.subviews)
        }
      }
    }

    return nil
  }
}
