//
//  PinLayout+Extended.swift
//  PinLayout
//
//  Created by  Denis on 17.08.22.
//  Copyright © 2022 mcswiftlayyout.mirego.com. All rights reserved.
//

import Foundation

extension PinLayout {
  @discardableResult
  public func layoutVisibleSubviews(first: (UIView) -> Void, next: (UIView, UIView) -> Void) -> PinLayout {
    guard let views: [UIView] = view.subviews as? [UIView] else { return self }
    returnSubviews(views: views.filter { !$0.isHidden }, first: first, next: next)
    
    return self
  }
 
  @discardableResult
  public func layoutSubviews(first: (UIView) -> Void, next: (UIView, UIView) -> Void) -> PinLayout {
    guard let views: [UIView] = view.subviews as? [UIView] else { return self }
    returnSubviews(views: views, first: first, next: next)
    
    return self
  }

  @discardableResult
  public func beforeVisible(of relativeViews: [PinView], aligned: VerticalAlign = .none) -> PinLayout {
    return before(of: getVisibleViews(relativeViews), aligned: aligned)
  }

  @discardableResult
  public func afterVisible(of relativeViews: [PinView], aligned: VerticalAlign = .none) -> PinLayout {
    return after(of: getVisibleViews(relativeViews), aligned: aligned)
  }
  
  @discardableResult
  public func aboveVisible(of relativeViews: [PinView], aligned: HorizontalAlign = .none) -> PinLayout {
    return above(of: getVisibleViews(relativeViews), aligned: aligned)
  }

  @discardableResult
  public func belowVisible(of relativeViews: [PinView], aligned: HorizontalAlign = .none) -> PinLayout {
    return below(of: getVisibleViews(relativeViews), aligned: aligned)
  }
  
  @discardableResult
  func wrapVisibleContent(_ type: WrapType) -> PinLayout {
    wrapVisibleContent(type, padding: .zero)
  }
  
  @discardableResult
  func wrapVisibleContent(_ type: WrapType, padding: PEdgeInsets) -> PinLayout {
    if let subviews = view.subviews.filter({ !$0.isHiddenView }) as? [PinView] {
      return wrapContent(type, padding: padding, { return "setWidth" }, subviews: subviews)
    }
    
    return self
  }
}

// MARK: - Helpers

extension PinLayout {
  private func getVisibleViews(_ relativeViews: [PinView]) -> [PinView] {
    return relativeViews.filter { !$0.isHiddenView }
  }
  
  private func returnSubviews(views: [UIView], first: (UIView) -> Void, next: (UIView, UIView) -> Void) {
    for i in 0..<views.count {
      let view: UIView = views[i]
      
      if i == 0 {
        first(view)
      } else {
        let prevView: UIView = views[i - 1]
        next(view, prevView)
      }
    }
  }
}

extension CGFloat {
  static var scale: CGFloat {
    let screen: UIScreen = UIScreen.main
    return screen.scale / screen.nativeScale
  }
  
  var scaled: CGFloat {
    return CGFloat(self) * CGFloat.scale
  }
}

extension Double {
  var scaled: CGFloat {
    return CGFloat(self) * CGFloat.scale
  }
  
  func rounded(toPlaces places: Int) -> Double {
    let divisor: Double = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

extension CGSize {
  var scaled: CGSize {
    return CGSize(width: self.width.scaled, height: self.height.scaled)
  }
}

extension Int {
  var scaled: CGFloat {
    return CGFloat(self) * CGFloat.scale
  }
  
  static func maximum(_ x: Int, _ y: Int) -> Int {
    Int(CGFloat.maximum(CGFloat(x), CGFloat(y)))
  }
  
  static func minimum(_ x: Int, _ y: Int) -> Int {
    Int(CGFloat.minimum(CGFloat(x), CGFloat(y)))
  }
  
  var toInt64: Int64 {
    Int64(self)
  }
  
  var toInt32: Int32 {
    Int32(self)
  }
}
