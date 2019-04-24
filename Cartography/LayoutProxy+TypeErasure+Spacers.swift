//
//  LayoutProxy+TypeErasure+Spacers.swift
//  Cartography
//
//  Created by Chris Piro on 5/13/18.
//  Copyright © 2018 Robert Böhnke. All rights reserved.
//

import Foundation

final class AnyHorizontalDistributionWidthLayoutProxy: SupportsLeadingLayoutProxy, SupportsTrailingLayoutProxy, SupportsWidthLayoutProxy {
    let proxy: SupportsLeadingLayoutProxy & SupportsTrailingLayoutProxy & SupportsWidthLayoutProxy

    var context: Context {
        return proxy.context
    }

    var item: AnyObject {
        return proxy.item
    }

    init(_ proxy: SupportsLeadingLayoutProxy & SupportsTrailingLayoutProxy & SupportsWidthLayoutProxy) {
        self.proxy = proxy
    }
}
