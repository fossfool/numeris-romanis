/*********************************************************************/
//  NumerisRomanisTests.swift
//  NumerisRomanis
//
//  Copyright © 2018 Wylder Media Group, LLC. All rights reserved.
//  Please refer to the license in the Docs Directory for more info
//
/*********************************************************************/
import CryptoTokenKit
import XCTest
@testable import NumerisRomanis

struct TestResults {
    var passed: Bool
    var group: String
    var test: String
    var result: String
    
    init() {
        passed = true
        group = ""
        test =  ""
        result = ""
    }
    
    init(_ passed: Bool, _ group: String,_ test: String,_ result: String) {
        self.passed = passed
        self.group = group
        self.test = test
        self.result = result
    }
}

class NumerisRomanisTests: XCTestCase {

    private let docHashes = [
        ("LICENSE", "md", "-3359061485464795844"),
        ("LICENSE", "html", "2204883064120204797"),
        ("README", "md", "-8636833594603812845"),
        ("README", "html", "2718529898568463416"),
    ]
   

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put tear down code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRIntStaticProperties() {

        XCTAssert(RInt.isSigned == true, "Must be true")
        XCTAssert(RInt.defaultNegativeSign == "cr", "Must be cr on start")
        XCTAssert(RInt.defaultValueForNulla == "Nulla", "Must be Nulla on start")
    }

    func testRIntInstanceProperties() {

        let t = RInt(20)

        var o = RInt(30)
        o.negate()

        XCTAssert(t.value == 20, "t was set to 20 - Unexpected Value." )
        XCTAssert(t.asInt == 20, "t was set to 20 - Unexpected Value." )
        XCTAssert(t.asDouble == 20.0, "t was set to 20 - Unexpected Value." )
        XCTAssert(t.asHexString == "0x14", "t was set to 20 - Unexpected Value." )
        XCTAssert(t.asBinaryString == "0b10100", "t was set to 20 - Unexpected Value." )
        XCTAssert(t.asRomanString == "XX", "t was set to 20 - Unexpected Value." )
        XCTAssert(t.description == "XX", "t was set to 20 - Unexpected Value." )
        //XCTAssert(t.words == 20 , "t was set to 20 - Unexpected Value." )
        XCTAssert(t.magnitude == 20 , "t was set to 20 - Unexpected Value." )
        XCTAssert(t.bitWidth == 64 , "t was set to 20 - Unexpected Value." )
        XCTAssert(t.trailingZeroBitCount == 2 , "t was set to 20 - Unexpected Value." )
        XCTAssert(t.hashValue == 20 , "t was set to 20 - Unexpected Value." )
        XCTAssert(o.value == -30 , "t was set to -30 - Unexpected Value.\(o.value)" )
        XCTAssert(o.signum() == -1 , "t was set to -30 - Unexpected Value." )

        o.negate()

        let (q, r) = o.quotientAndRemainder(dividingBy: t)

        XCTAssert(q.value == 1 , "q was set to 1 - Unexpected Value." )
        XCTAssert(r.value == 10 , "r was set to 10 - Unexpected Value." )
    }

    func testInitializers() {

        do {
            let n = 40
            let r = RInt(n)
            XCTAssert(n == r.value, "public init(_ value: Int) failed "  )
        }

        do {
            let n = "40"
            let r = RInt(n)
            XCTAssert(n == r.asInt.description , "init(_ value: String)   failed"  )
        }

        do {
            let n = "MCXLV"
            let r = RInt(n)
            XCTAssert(n == r.asRomanString , "init(_ value: String)   failed"  )
        }

        do {
            let n = 40.0
            let r = RInt(n)
            XCTAssert(n == r.asDouble, "init(_ value: Double) failed"  )
        }

        do {
            let r: RInt = "2018"
            XCTAssert(r.value == 2018, "init String Literal failed"  )
        }

        do {
           let r: RInt = "Nulla"
            XCTAssert(r.value == 0, "init String Literal failed"  )
        }

        do {
            let r: RInt = "MMXVIII"
            XCTAssert(r.value == 2018, "init String Literal failed"  )
        }

        do {
            let r: RInt = 20.18
            XCTAssert(r.value == 20, "init Float Literal failed"  )
        }

        do {
           let r: RInt = 20
            XCTAssert(r.value == 20, "init Integer Literal failed"  )
        }

        do {
            let r: RInt = 0x14
            XCTAssert(r.value == 20, "init Binary Integer Literal failed"  )
        }

        do {
            let r: RInt = 0b111
            XCTAssert(r.value == 7, "init Binary Integer Literal failed"  )
        }

    }

    func testMath() {

        var a: RInt = 50
        var b: RInt = 12
        var c: RInt = 0
        var i = 8

        // +
        c = a + b
        XCTAssertEqual(c.value, 62, "addition test failed"  )
        c += b
        XCTAssertEqual(c.value, 74, "addition test failed"  )
        c = b + i
        XCTAssertEqual(c.value, 20, "addition test failed"  )
        c = i + b
        XCTAssertEqual(c.value, 20, "addition test failed"  )
        c += i
        XCTAssertEqual(c.value, 28, "addition test failed"  )

        // -
        c = a - b
        XCTAssertEqual(c.value, 38, "addition test failed"  )
        c -= b
        XCTAssertEqual(c.value, 26, "addition test failed"  )
        c = b - i
        XCTAssertEqual(c.value, 4, "addition test failed"  )
        c = i - b
        XCTAssertEqual(c.value, -4, "addition test failed"  )
        c -= i
        XCTAssertEqual(c.value, -12, "addition test failed"  )

        // *
        a = 50
        b = 100
        i = 20
        c = 0

        c = a * b
        XCTAssertEqual(c.value, 5_000, "addition test failed"  )
        c *= b
        XCTAssertEqual(c.value, 500_000, "addition test failed"  )
        c = b * i
        XCTAssertEqual(c.value, 2_000, "addition test failed"  )
        c = i * b
        XCTAssertEqual(c.value, 2_000, "addition test failed"  )
        c *= i
        XCTAssertEqual(c.value, 40_000, "addition test failed"  )

        // /
        a = 600
        b = 100
        i = 200
        c = 0

        c = a / b
        XCTAssertEqual(c.value, 6, "addition test failed"  )
        c = 1000
        c /= b
        XCTAssertEqual(c.value, 10, "addition test failed"  )
        c = a / i
        XCTAssertEqual(c.value, 3, "addition test failed"  )
        c = i / b
        XCTAssertEqual(c.value, 2, "addition test failed"  )
        a /= i
        XCTAssertEqual(c.value, 2,"addition test failed"  )

    }

    func testConversion() {
        // deepTest will exhaustively test conversion when it's true,
        // for faster testing set it to false

        let deepTest = false

        //Traditional values

        for n in 0...4_000 {
            let r = RInt.convertToRoman(n)
            let i = RInt.convertStringToInt(r)!

            XCTAssertEqual(n, i, "Conversion failed")
        }

        do {
            let step = deepTest ? 1 : 97
            var n = 4001

            while n < 100_097 {

                let r = RInt.convertToRoman(n)
                let i = RInt.convertStringToInt(r)!

                XCTAssertEqual(n, i, "Conversion failed")

                n += step
            }

            do {
                let step = deepTest ? 1 : 97
                var n = 950_000

                while n < 1_050_097 {

                    let r = RInt.convertToRoman(n)
                    let i = RInt.convertStringToInt(r)!

                    XCTAssertEqual(n, i, "Conversion failed")

                    n += step
                }
            }

        }

    }

    // Alerts if documentation has been altered or is missing. Because we have
    // txt md and html versions, they need to be regenerated for all types if
    // modifications are made. This warning alerts us to run the transformations.
    // I use atom to maintain documentation and highly recommend it.
    func testDocVersions() {

        var results: [[String]] = []
        
        var allPassed = true
        
        for (flname, ext, hash) in docHashes {
            
            let curHash = hashFile(flname, ext)
            
            if curHash.hasPrefix("Error:") || curHash != hash {
                allPassed = false
            }
            
            results.append([(curHash == hash ? "PASSED" : "FAILED"), flname, ext, hash, curHash])
        }

        if !allPassed {
            print("Document Tests Failed")
            for r in results {
                print(r)
            }
            print("New results if needed.....")
            for r in results {
                print("        (\"\(r[1])\", \"\(r[2])\", \"\(r[4])\"),")
            }
            XCTAssert(allPassed, "Document Tests failed")
        }
    }
    
    func hashFile(_ fileName: String, _ ext: String ) -> String  {
        do {
            guard let filePath = Bundle.main.path(forResource: fileName, ofType: ext)
                else {
                    // File Error
                    return "Error getting the file"
            }
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
      
            return String(contents.hashValue ^ (fileName + ext).hashValue)
        }
        catch {
            return "Error: couldn't process the file."
        }
    }




}
