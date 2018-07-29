/**********************************************************************************
 RInt.swift

 Genus Numeris Romanis: A mildly absurd Swift IV Structure for Roman Numerals.
 
 Version: Nulla I for Swift IV.I
 
 Copyright © MMXVIII Wylder Media Group, LLC.
 
 We use an MIT style license. Leaving this header intact in your source code
 satisfies requirements:
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

************************************************************************************

 The test stub is actually a very light web reader for the docs or you can view
 them online at: https://github.com/wyldermedia/NumerisRomanis/
 
************************************************************************************/

import Foundation

public struct RInt:
    SignedInteger,
    ExpressibleByStringLiteral,
    ExpressibleByFloatLiteral,
    ExpressibleByIntegerLiteral,
    Strideable
{
    public typealias Words = Int.Words
    public typealias Magnitude = UInt

    public enum TextCase: String { case Upper, Lower }
    
    /************************
        Static Properties
     ************************/

    // Required by binaryInteger protocol
    public static let isSigned  = true
    
    // The default negative sign
    private static var defNegSign = "cr"
    public static var defaultNegativeSign: String  {
        set {
            precondition(newValue != "", "default Negative sign cannot be blank.")
            self.defNegSign = newValue
        }
        get { return self.defNegSign }
    }
    
    // The default symbol for Zero
    private static var nulla = "Nulla"
    public static var defaultValueForNulla: String {
        set {
            precondition(newValue != "", "Default Value cannot be empty.")
            self.nulla = newValue
        }
        get { return nulla }
    }

    // default text case
    public static var defaultCase: TextCase = .Upper
    
    // If true String returns use RomanUnicode Characters
    // If false String returns use standeard "ascii" text
    public static var defaultUseRomanUnicodeChars = false
    
    /**************************
        Instance Properties
     **************************/
    
    // The value as an Int
    public var value: Int

    // convenience property returns Int for use in equations
    public var asInt: Int {
        return value
    }
    // convenience property, returns Double for use in equations
    public var asDouble: Double {
        return Double(value)
    }

    // Hex representation in a String
    public var asHexString: String {
        return "0x"+String(value, radix: 16).uppercased()
    }
    // Binary representation in a String
    public var asBinaryString: String {
        return "0b"+String(value, radix: 2)
    }
    // Roman representation in a String
    public var asRomanString: String {
        return RInt.convertToRoman(value)
    }
    
    public var asRomanUnicode: String {
        return RInt.convertToRoman(value, useRomanUnicode: true)
    }
    
    // Protocol Properties

    // Required by CustomStringConvertible
    public var description: String {
        if RInt.defaultUseRomanUnicodeChars {
            return self.asRomanUnicode
            
        } else {
            return self.asRomanString
        }
    }

    // required by binaryInteger Protocol
    public var words: Int.Words {
        return value.words
    }
    // required by binaryInteger Protocol
    public var magnitude: RInt.Magnitude {
        return UInt(value)
    }
    // Required by binaryInteger protocol
    public var bitWidth: Int {
        return value.bitWidth
    }
    // Required by binaryInteger protocol
    public var trailingZeroBitCount: Int {
        return value.trailingZeroBitCount
    }

    // Required by Swift.Hashable
    public var hashValue: Int {
        return value.hashValue
    }

    // Required by Swift.Strideable
    public func distance(to other: RInt) -> Stride {
        return abs(other.value - value)
    }

    public func advanced(by n: Int) -> RInt {
        return RInt(value + n)
    }

    // Required by SignedNumeric
    public mutating func negate() {
        value = -1 * value
    }

    // Required by BinaryInteger
    public func quotientAndRemainder(dividingBy rhs: RInt) -> (quotient: RInt, remainder: RInt) {
        return ( RInt(value / rhs.value), RInt(value % rhs.value))
    }

    // Required by BinaryInteger
    public func signum() -> RInt {
        if value == Int.min { return RInt(-1)}
        else { return RInt(self.value / abs(self.value)) }
    }

    /********************
        Initializers
     ********************/

    public init(_ value: String) {
        let i = RInt.convertStringToInt(value)
        
        precondition(i != nil, "Could not convert value to Int")
        
        self.value = i!
    }

    public init(_ value: Int) {
        self.value = value
    }

    public init(_ value: Double){
        precondition( value <= Double(Int.max) &&
                      value >= Double(Int.min), "value out of range")
        self.value = Int(value)
    }

    // required by protocol ExpressibleByStringLiteral
    public init(stringLiteral value: StringLiteralType) {
        let i = RInt.convertStringToInt(value)
        precondition(i != nil, "Could not convert value \"\(value)\" to Int")
        self.value = i!
    }

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        let i = RInt.convertStringToInt(value)
        precondition(i != nil, "Could not convert value \"\(value)\" to Int")
        self.value = i!
    }

    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        let i = RInt.convertStringToInt(value)
        precondition(i != nil, "Could not convert value \"\(value)\" to Int")
        self.value = i!
    }

    // Required by protocol ExpressibleByFloatLiteral.
    public init(floatLiteral value: FloatLiteralType) {
        precondition( value <= Double(Int.max) &&
                value >= Double(Int.min), "value out of range")
        self.value = Int(value)
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.value = Int(value)
    }

    // Required by protocol Numeric
    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        self.value = Int(source)
    }
    // Required by protocol Numeric
    public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        self.value = Int(source)
    }
    // Required by protocol Numeric
    public init<T>(_ source: T) where T : BinaryInteger {
        self.value = Int(source)
    }
    // Required by protocol Numeric
    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.value = Int(source)
    }
    // Required by protocol Numeric
    public init<T>(clamping source: T) where T : BinaryInteger {
        self.value = Int(source)
    }
    // Required by protocol Numeric
    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        self.value = Int(source)
    }


    /**************************
        Static Math Functions
     **************************/
    
    public static func + (lhs: RInt, rhs: RInt) -> RInt {
        return RInt(Int(lhs.value + rhs.value))
    }
    public static func += (lhs: inout RInt, rhs: RInt) {
        lhs.value += rhs.value
    }

    public static func - (lhs: RInt, rhs: RInt) -> RInt {
        return RInt(Int(lhs.value - rhs.value))
    }
    public static func -= (lhs: inout RInt, rhs: RInt) {
        lhs.value -= rhs.value
    }
    
    public static func / (lhs: RInt, rhs: RInt) -> RInt {
        return RInt(Int(lhs.value / rhs.value))
    }
    public static func /= (lhs: inout RInt, rhs: RInt) {
        lhs.value /= rhs.value
    }
    
    public static func % (lhs: RInt, rhs: RInt) -> RInt {
        return RInt(Int(lhs.value % rhs.value))
    }
    public static func %= (lhs: inout RInt, rhs: RInt) {
        lhs.value %= rhs.value
    }
    
    public static func * (lhs: RInt, rhs: RInt) -> RInt {
        return RInt(Int(lhs.value * rhs.value))
   }
    public static func *= (lhs: inout RInt, rhs: RInt) {
        lhs.value *= rhs.value
    }
    
    public static func &= (lhs: inout RInt, rhs: RInt) {
        lhs.value &= rhs.value
    }
    
    public static func |= (lhs: inout RInt, rhs: RInt) {
        lhs.value |= rhs.value
    }
    
    public static func ^= (lhs: inout RInt, rhs: RInt) {
        lhs.value ^= rhs.value
    }
    
    public static func >>= <RHS>(lhs: inout RInt, rhs: RHS) where RHS : BinaryInteger {
        lhs.value = lhs.value >> rhs
    }
    public static func <<= <RHS>(lhs: inout RInt, rhs: RHS) where RHS : BinaryInteger {
        lhs.value = lhs.value << rhs
    }

    public static func &(lhs: RInt, rhs: RInt) -> RInt {
        return RInt(Int(lhs.value & rhs.value))
    }
    public static func |(lhs: RInt, rhs: RInt) -> RInt {
        return RInt(Int(lhs.value | rhs.value))
    }
    public static func ^(lhs: RInt, rhs: RInt) -> RInt {
        return RInt(Int(lhs.value ^ rhs.value))
    }
    public static func >><RHS>(lhs: RInt, rhs: RHS) -> RInt where RHS: BinaryInteger {
        return RInt(Int(lhs.value >> rhs))
    }
    public static func <<<RHS>(lhs: RInt, rhs: RHS) -> RInt where RHS: BinaryInteger {
        return RInt(Int(lhs.value << rhs))
    }

    public static func ==(lhs: RInt, rhs: RInt) -> Bool {
        return (lhs.value == rhs.value)
    }
    public static prefix func -(operand: RInt) -> RInt {
        return RInt(-operand.value)
    }

    public static prefix func ~ (x: RInt) -> RInt {
        return RInt( ~Int(x.value ))
    }

    public static func <=(lhs: RInt, rhs: RInt) -> Bool {
        return lhs.value <= rhs.value
    }

    public static func >=(lhs: RInt, rhs: RInt) -> Bool {
        return lhs.value >= rhs.value
    }

    public static func >(lhs: RInt, rhs: RInt) -> Bool {
        return lhs.value > rhs.value
    }

    public static func <(lhs: RInt, rhs: RInt) -> Bool {
        return lhs.value < rhs.value
    }

    /*********************************************
        Direct support of Math with Ints. Strip
        these out if you don't want it.
     *********************************************/

    public static func + (lhs: RInt, rhs: Int) -> RInt {
        return RInt(lhs.value + rhs)
    }
    public static func + (lhs: Int, rhs: RInt) -> RInt {
        return RInt(lhs + rhs.value)
    }
    public static func += (lhs: inout RInt, rhs: Int) {
        lhs.value += rhs
    }
    
    public static func - (lhs: RInt, rhs: Int) -> RInt {
        return RInt(Int(lhs.value - rhs))
    }
    public static func - (lhs: Int, rhs: RInt) -> RInt {
        return RInt(Int(lhs - rhs.value))
    }
    public static func -= (lhs: inout RInt, rhs: Int) {
        lhs.value -= rhs
    }
    
    public static func / (lhs: RInt, rhs: Int) -> RInt {
        return RInt(Int(lhs.value / rhs))
    }
    public static func / (lhs: Int, rhs: RInt) -> RInt {
        return RInt(Int(lhs / rhs.value))
    }
    public static func /= (lhs: inout RInt, rhs: Int) {
        lhs.value /= rhs
    }
    
    public static func % (lhs: RInt, rhs: Int) -> RInt {
        return RInt(Int(lhs.value % rhs))
    }
    public static func % (lhs: Int, rhs: RInt) -> RInt {
        return RInt(Int(lhs % rhs.value))
    }
    public static func %= (lhs: inout RInt, rhs: Int) {
        lhs.value %= rhs
    }
    
    public static func * (lhs: RInt, rhs: Int) -> RInt {
        return RInt(Int(lhs.value * rhs))
    }
    public static func * (lhs: Int, rhs: RInt) -> RInt {
        return RInt(Int(lhs * rhs.value))
    }
    public static func *= (lhs: inout RInt, rhs: Int) {
        lhs.value *= rhs
    }

    public static func &= (lhs: inout RInt, rhs: Int) {
        lhs.value &= rhs
    }
    
    public static func |= (lhs: inout RInt, rhs: Int) {
        lhs.value |= rhs
    }
    
    public static func ^= (lhs: inout RInt, rhs: Int) {
        lhs.value ^= rhs
    }

    public static func <=(lhs: RInt, rhs: Int) -> Bool {
        return lhs.value <= rhs
    }
    public static func <=(lhs: Int, rhs: RInt) -> Bool {
        return lhs <= rhs.value
    }

    public static func >=(lhs: RInt, rhs: Int) -> Bool {
        return lhs.value >= rhs
    }
    public static func >=(lhs: Int, rhs: RInt) -> Bool {
        return lhs >= rhs.value
    }

    public static func >(lhs: RInt, rhs: Int) -> Bool {
        return lhs.value > rhs
    }
    public static func >(lhs: Int, rhs: RInt) -> Bool {
        return lhs > rhs.value
    }

    public static func <(lhs: RInt, rhs: Int) -> Bool {
        return lhs.value < rhs
    }
    public static func <(lhs: Int, rhs: RInt) -> Bool {
        return lhs < rhs.value
    }

    /**********************************
        Static Conversion Functions
     **********************************/

    // This sort is used to maximize compression of
    // numbers in the string. 
    private static let romanUnicode = [
        ("Ⅿ","M"), ("Ⅾ","D"), ("Ⅽ","C"), ("Ⅼ","L"),
        ("Ⅻ","XII"), ("Ⅺ","XI"), ("Ⅸ","IX"), ("Ⅹ","X"),
	    ("Ⅷ","VIII"), ("Ⅶ","VII"), ("Ⅵ","VI"), ("Ⅳ","IV"), ("Ⅴ","V"),
        ("Ⅲ","III"), ("Ⅱ","II"), ("Ⅰ","I"),
        ("ⅿ", "M"), ("ⅾ","D"), ("ⅽ", "C"), ("ⅼ", "L"),
        ("ⅻ","XII"), ("ⅺ","XI"), ("ⅸ","IX"), ("ⅹ", "X"),
        ("ⅷ", "VII"), ("ⅶ", "VII"), ("ⅵ", "VI"), ("ⅳ", "IV"), ("ⅴ", "V"),
        ("ⅲ", "III"), ("ⅱ","II"), ("ⅰ","I")]

    // converts or uncoverts a String of Roman numerals characters to or from
    // Roman Unicode Characters depedning on UseRomanUnicode flag
    private static func convertRomanUnicodeCharacters(_ romanString: String, UseRomanUnicode: Bool) -> String {
        var rtn = romanString
        
        // replacingOccurrences has an issue with releasing memory
        autoreleasepool {
            for (u, c) in romanUnicode {
                if UseRomanUnicode {
                    rtn = rtn.replacingOccurrences(of: c, with: u)
                } else
                {
                    rtn = rtn.replacingOccurrences(of: u, with: c)
                }
            }
        }
        return rtn
    }
    
    //converts a string to Int. Supports all Int literal types plus
    //Roman Numerals.
    public static func convertStringToInt(_ value: String) -> Int? {
        
        // Let Int have a go at conversion
        // this covert All other numeric thpes
        if let i = Int(value) {
            return i
        }

        var text = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if text.hasPrefix("N") {
            return 0
        }
        
        var sign = 1
        var multiplier = 1
        var sum = 0
        var lastVal = 0
        
        if text.hasPrefix(RInt.defaultNegativeSign.uppercased()) {
            sign = -1
            text = String(text.dropFirst(RInt.defaultNegativeSign.count))
        }
        
        //check for RomanUnicode characters
        
        text = convertRomanUnicodeCharacters(text, UseRomanUnicode: false)
        
        for t in text.uppercased() {
            var curVal = 0
            switch t {
            case "(":
                multiplier *= 1_000
            case ")":
                if multiplier >= 1_000 {
                    multiplier /= 1_000
                }
                else {
                    //Unbalanced parens
                    return nil
                }
            case "I":
                curVal = 1 * multiplier
                
            case "V":
                curVal = 5 * multiplier
                
            case "X":
                curVal = 10 * multiplier
                
            case "L":
                curVal = 50 * multiplier
            case "C":
                curVal = 100 * multiplier
            case "D":
                curVal = 500 * multiplier
            case "M":
                curVal = 1_000 * multiplier
            case " ":
                continue
            case "_":
                continue
            
            default:
                //Unkown character
                return nil
            }

            sum += curVal
            
            if lastVal < curVal {
                sum -= (2 * lastVal)
            }
            
            lastVal = curVal
        }
        
        if multiplier != 1 {
            //parens were not balanced, return nil
            return nil
        }
        
        sum *= sign
        
        return sum

    }

    // A template array used to convert integers to Roman Numbers.
    private static let conversionArray = [
        [ "i", "ii", "iii", "IV", "V", "VI", "VII", "VIII", "IX" ],
        [ "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC" ],
        [ "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM" ]]

    public static func convertToRoman(_ value: Int,
                                      useRomanUnicode: Bool = defaultUseRomanUnicodeChars,
                                      textCase: TextCase = defaultCase ) -> String {

        precondition((value <= Int.max  &&
                  value >= Int.min), "Value out of range")

        var rtn = ""

        let isNegative = value < 0
        
        // Special cases for Int.min because you can't ABS them
        if isNegative && value == Int.min {
            // check 32 bit Int first to avoid overflow
            if value == Int(Int32.min) {
                rtn = "(MMCXLVII)CDLXXX)MMMDCXLVIII"
            }
            else {
                rtn = "((((((IX)CCXX)MMMCCCLXX)MMXXXVI)DCCCLIV)DCCLXXV)DCCCVIII"
            }
        } else
        {
            let val = String(abs(value)).description.reversed()
        
            var pos = 0
            var openParens = ""
            var iCheckPos = 0
            
            for d in val {
                let digit = Int(String(d))!
                if digit > 0 {
                    
                    let row = (pos) % 3
                    let conversionRow = RInt.conversionArray[row]
                    let romanNumeral = conversionRow[digit - 1]
                    var mOrI = "I"

                    if pos >= 3 {
                        let parens = pos / 3
                        
                        
                        mOrI = "M"
                        
                        // this block ignores the magnitude change in paren if
                        // the value is i,ii, or iii.

                        if iCheckPos < parens && ( romanNumeral == "i" || romanNumeral == "ii" || romanNumeral == "iii")  {
                            if parens - 1 > 0 {
                                let parensRequired = (parens - 1) - openParens.count
                                rtn = "\(String(repeating: ")", count: parensRequired))\(rtn)"
                                openParens += String(repeating: "(", count: parensRequired)
                            }
                            iCheckPos = parens
                        }
                        else if openParens.count < parens {

                            let parensRequired = parens - openParens.count
                            rtn = "\(String(repeating: ")", count: parensRequired))\(rtn)"
                            openParens += String(repeating: "(", count: parensRequired)
                            iCheckPos = parens
                        }
                    }
                    
                        // Auto Release pool was implemented because
                        // replacingOccurrences retains memory after
                        // call.
                    // implemented due to memory consumption of replacingOccurrances(Of:)
                    autoreleasepool {
                        rtn = "\(romanNumeral.replacingOccurrences(of: "i", with: mOrI))\(rtn)"
                    }

                }
                else
                {
                    rtn = "" + rtn
                }
                pos += 1
            }
        
            rtn = "\(rtn.count > 0 ? openParens + rtn : nulla)"
            
        } // else value wan't Int.min
    
        // rtn currently in Uppercase ascii
        // set to unicode if necessary and set case ix and Unicode and case

        if useRomanUnicode {
            rtn = convertRomanUnicodeCharacters(rtn, UseRomanUnicode: true)
        }
        
        if textCase == .Lower {
           rtn = rtn.lowercased()
        }
        
        rtn = isNegative ? defNegSign + rtn : rtn
        
        return rtn
    }

 
}

