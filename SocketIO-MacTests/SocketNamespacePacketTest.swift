//
//  SocketNamespacePacketTest.swift
//  Socket.IO-Client-Swift
//
//  Created by Erik Little on 10/11/15.
//
//

import XCTest
@testable import SocketIO

class SocketNamespacePacketTest: XCTestCase {
    let data = "test".data(using: String.Encoding.utf8)!
    let data2 = "test2".data(using: String.Encoding.utf8)!
    
    func testEmpyEmit() {
        let expectedSendString = "2/swift,[\"test\"]"
        let sendData: [Any] = ["test"]
        let packet = SocketPacket.packetFromEmit(sendData, id: -1, nsp: "/swift", ack: false)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testNullEmit() {
        let expectedSendString = "2/swift,[\"test\",null]"
        let sendData: [Any] = ["test", NSNull()]
        let packet = SocketPacket.packetFromEmit(sendData, id: -1, nsp: "/swift", ack: false)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testStringEmit() {
        let expectedSendString = "2/swift,[\"test\",\"foo bar\"]"
        let sendData: [Any] = ["test", "foo bar"]
        let packet = SocketPacket.packetFromEmit(sendData, id: -1, nsp: "/swift", ack: false)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testJSONEmit() {
        let expectedSendString = "2/swift,[\"test\",{\"foobar\":true,\"hello\":1,\"null\":null,\"test\":\"hello\"}]"
        let sendData: [Any] = ["test", ["foobar": true, "hello": 1, "test": "hello", "null": NSNull()] as NSDictionary]
        let packet = SocketPacket.packetFromEmit(sendData, id: -1, nsp: "/swift", ack: false)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testArrayEmit() {
        let expectedSendString = "2/swift,[\"test\",[\"hello\",1,{\"test\":\"test\"},true]]"
        let sendData: [Any] = ["test", ["hello", 1, ["test": "test"], true]]
        let packet = SocketPacket.packetFromEmit(sendData, id: -1, nsp: "/swift", ack: false)
        
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testBinaryEmit() {
        let expectedSendString = "51-/swift,[\"test\",{\"_placeholder\":true,\"num\":0}]"
        let sendData: [Any] = ["test", data]
        let packet = SocketPacket.packetFromEmit(sendData, id: -1, nsp: "/swift", ack: false)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
        XCTAssertEqual(packet.binary, [data])
    }
    
    func testMultipleBinaryEmit() {
        let sendData: [Any] = ["test", ["data1": data, "data2": data2] as NSDictionary]
        let packet = SocketPacket.packetFromEmit(sendData, id: -1, nsp: "/swift", ack: false)
        
        let binaryObj = packet.data[1] as! [String: Any]
        let data1Loc = (binaryObj["data1"] as! [String: Any])["num"] as! Int
        let data2Loc = (binaryObj["data2"] as! [String: Any])["num"] as! Int
        
        XCTAssertEqual(packet.type, .binaryEvent)
        XCTAssertEqual(packet.nsp, "/swift")
        XCTAssertEqual(packet.binary[data1Loc], data)
        XCTAssertEqual(packet.binary[data2Loc], data2)
    }
    
    func testEmitWithAck() {
        let expectedSendString = "2/swift,0[\"test\"]"
        let sendData = ["test"]
        let packet = SocketPacket.packetFromEmit(sendData, id: 0, nsp: "/swift", ack: false)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testEmitDataWithAck() {
        let expectedSendString = "51-/swift,0[\"test\",{\"_placeholder\":true,\"num\":0}]"
        let sendData: [Any] = ["test", data]
        let packet = SocketPacket.packetFromEmit(sendData, id: 0, nsp: "/swift", ack: false)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
        XCTAssertEqual(packet.binary, [data])
    }
    
    // Acks
    func testEmptyAck() {
        let expectedSendString = "3/swift,0[]"
        let packet = SocketPacket.packetFromEmit([], id: 0, nsp: "/swift", ack: true)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testNullAck() {
        let expectedSendString = "3/swift,0[null]"
        let sendData = [NSNull()]
        let packet = SocketPacket.packetFromEmit(sendData, id: 0, nsp: "/swift", ack: true)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testStringAck() {
        let expectedSendString = "3/swift,0[\"test\"]"
        let sendData = ["test"]
        let packet = SocketPacket.packetFromEmit(sendData, id: 0, nsp: "/swift", ack: true)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testJSONAck() {
        let expectedSendString = "3/swift,0[{\"foobar\":true,\"hello\":1,\"null\":null,\"test\":\"hello\"}]"
        let sendData = [["foobar": true, "hello": 1, "test": "hello", "null": NSNull()]]
        let packet = SocketPacket.packetFromEmit(sendData, id: 0, nsp: "/swift", ack: true)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
    }
    
    func testBinaryAck() {
        let expectedSendString = "61-/swift,0[{\"_placeholder\":true,\"num\":0}]"
        let sendData = [data]
        let packet = SocketPacket.packetFromEmit(sendData, id: 0, nsp: "/swift", ack: true)
        
        XCTAssertEqual(packet.packetString, expectedSendString)
        XCTAssertEqual(packet.binary, [data])
    }
    
    func testMultipleBinaryAck() {
        let sendData = [["data1": data, "data2": data2]]
        let packet = SocketPacket.packetFromEmit(sendData, id: 0, nsp: "/", ack: true)

        XCTAssertEqual(packet.id, 0)
        XCTAssertEqual(packet.type, .binaryAck)
        
        let binaryObj = packet.data[0] as! [String: Any]
        let data1Loc = (binaryObj["data1"] as! [String: Any])["num"] as! Int
        let data2Loc = (binaryObj["data2"] as! [String: Any])["num"] as! Int
        
        XCTAssertEqual(packet.binary[data1Loc], data)
        XCTAssertEqual(packet.binary[data2Loc], data2)
    }
}
