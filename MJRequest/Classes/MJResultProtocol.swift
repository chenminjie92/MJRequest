//
//  MJResultProtocol.swift
//  MJRequest
//
//  Created by chenminjie on 2021/3/10.
//

import Foundation

public protocol MJResultProtocol {
    associatedtype Value
    associatedtype Error: Swift.Error

    init(value: Value)
    init(error: Error)
    
    var result: MJResult<Value, Error> { get }
}


public enum MJResult<Value, Error: Swift.Error>: MJResultProtocol {

    case success(Value)
    
    case failure(Error)


    public typealias Success = Value

    public typealias Failure = Error


    public init(value: Value) {
        self = .success(value)
    }

    public init(error: Error) {
        self = .failure(error)
    }
    
    public var description: String {
        switch self {
        case let .success(value): return ".success(\(value))"
        case let .failure(error): return ".failure(\(error))"
        }
    }


    // MARK: CustomDebugStringConvertible

    public var debugDescription: String {
        return description
    }

    // MARK: ResultProtocol
    public var result: MJResult<Value, Error> {
        return self
    }
}
