//
//  SocketTypes.swift
//  Socket.IO-Client-Swift
//
//  Created by Erik Little on 4/8/15.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

/// A marking protocol that says a type can be represented in a socket.io packet.
///
/// Example:
///
/// ```swift
/// struct CustomData : SocketData {
///    let name: String
///    let age: Int
///
///    func socketRepresentation() -> SocketData {
///        return ["name": name, "age": age]
///    }
/// }
///
/// socket.emit("myEvent", CustomData(name: "Erik", age: 24))
/// ```
public protocol SocketDataV1 {
    // MARK: Methods

    /// A representation of self that can sent over socket.io.
    func socketRepresentation() throws -> SocketDataV1
}

public extension SocketDataV1 {
    /// Default implementation. Only works for native Swift types and a few Foundation types.
    func socketRepresentation() -> SocketDataV1 {
        return self
    }
}

extension Array : SocketDataV1 { }
extension Bool : SocketDataV1 { }
extension Dictionary : SocketDataV1 { }
extension Double : SocketDataV1 { }
extension Int : SocketDataV1 { }
extension NSArray : SocketDataV1 { }
extension Data : SocketDataV1 { }
extension NSData : SocketDataV1 { }
extension NSDictionary : SocketDataV1 { }
extension NSString : SocketDataV1 { }
extension NSNull : SocketDataV1 { }
extension String : SocketDataV1 { }

/// A typealias for an ack callback.
public typealias AckCallback = ([Any]) -> Void

/// A typealias for a normal callback.
public typealias NormalCallback = ([Any], SocketAckEmitterV1) -> Void

typealias JSON = [String: Any]
typealias Probe = (msg: String, type: SocketEnginePacketTypeV1, data: [Data])
typealias ProbeWaitQueue = [Probe]

enum Either<E, V> {
    case left(E)
    case right(V)
}
