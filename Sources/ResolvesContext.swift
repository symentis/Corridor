//
//  ResolveContext.swift
//  Multiversal
//
//  Created by Elmar Kretzer on 06.08.17.
//  Copyright © 2017 Elmar Kretzer. All rights reserved.
//

import Foundation

public protocol ResolvesContext {

  associatedtype Context

  associatedtype Source: HasContext

  subscript<D>(_ k: KeyPath<Context, D>) -> D { get }

}
