//
//  Distribute+Spacers.swift
//  Cartography
//
//  Created by Chris Piro on 5/13/18.
//  Copyright © 2018 Robert Böhnke. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    #else
    import AppKit
#endif

class Spacer: UIView {
}

@discardableResult private func reduce<T: LayoutProxy, S: LayoutProxy>(
    _ items: [T],
    withSpacers spacers: [S],
    combine: (T, S, T) -> [NSLayoutConstraint])
    -> [NSLayoutConstraint]
{
    if let last = items.last as? AutoresizingMaskLayoutProxy {
        last.translatesAutoresizingMaskIntoConstraints = false
    }

    if let first = items.first {
        let rest = items.dropFirst()
        var ii = 0
        return rest.reduce(([], first)) { (acc, current) -> ([NSLayoutConstraint], T) in
            let (constraints, previous) = acc
            let spacer = spacers[ii]
            ii += 1
            return (constraints + combine(previous, spacer, current), current)
        }.0
    } else {
        return []
    }
}

// distribute fixed-width elements by a variable amount. inserts spacers between
@discardableResult public func distribute(spacedHorizontally items: [SupportsLeadingLayoutProxy & SupportsTrailingLayoutProxy]) -> [NSLayoutConstraint]
{
    let itemsP: [AnyHorizontalDistributionLayoutProxy] = items.map(AnyHorizontalDistributionLayoutProxy.init)
    let spacersP: [AnyHorizontalDistributionWidthLayoutProxy] = items.enumerated().dropFirst().map { (ii, item) in
        let spacer = Spacer()
        let spacerP = AnyHorizontalDistributionWidthLayoutProxy(spacer.asProxy(context: itemsP[ii].context))
        let superview = (item.item as! UIView).superview!
        superview.addSubview(spacer)
        spacer.isHidden = true
        return spacerP
    }
    assert(spacersP.count == itemsP.count - 1)
    return reduce(itemsP, withSpacers: spacersP) { (prev, spacer, cur) -> [NSLayoutConstraint] in
        return [
            prev.trailing >= spacer.leading,
            spacer.trailing >= cur.leading,
            spacer.width == spacersP.first!.width,
        ]
    }
}
