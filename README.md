# **Numeris Romanis:**
## A *mildly absurd* Swift IV Structure for Roman Numerals.

Many say the Romans had no concept of negative numbers, or numbers larger than 3,999 they definitely had sophisticated financial systems, and clearly understood the concept of debits and credits, and debt owed. [(See this wikipedia page for more information on it's history.)](https://en.wikipedia.org/wiki/Roman_finance). To this end, I created a robust integer type to give this old world system the attention and credit it deserves today. Enjoy!

### Intro to RInt()

This isn't some little conversion function. It's a full blown type with all the Initializers, arithmetic overloads, and on the fly string conversions required.

On 64 bit machines, it will handle numbers between negative nine quintillion two hundred twenty three quadrillion three hundred seventy two trillion thirty six billion eight hundred fifty four million seven hundred seventy five thousand eight hundred eight, and positive 9,223,372,036,854,775,807. We've coded all preconditions to work with the native size of an Int, The software has not been tested on any 32 bit platforms because -- well -- I don't own an Apple Watch. On the watch, and other 32 bit devices you'll be limited to the old +/- 2,147,483,647.

### A Quick Review Of "Traditional" Basic Roman Numbers

Roman Numbers, at a minimum, ***contain*** the natural counting numbers from 1 to 3,999.

| Roman      | Decimal      | Comments                         |
|:----------:| ------------:| -------------------------------- |
|     I      |            1 | One                              |
|     V      |            5 | Five                             |
|     X      |           10 | Ten                              |
|     L      |           50 | Fifty                            |
|     C      |          100 | One Hundred                      |
|     D      |          500 | Five Hundred                     |
|     M      |        1,000 | One Thousand                     |
| MMMCMXLIX  |        3,999 | Largest Traditional Roman number |

The processing rules are as follows:

| No  | Rule                                                                                                                           |
|:---:| ------------------------------------------------------------------------------------------------------------------------------ |
| I   | Roman numbers are read from left to right, highest order to lowest and summed together.                                          |
| II   | Repeated numbers which can be represented by a larger digit are reduced to the higher digit. V L D, or 5, 50, and 500 are never repeated because a Ten's digit exists VV would be X, LL would be C, and DD would be M. |
| III   | A Tens digit may only be repeated 3 times.                                                                                     |
| IV   | Add like numerals until you reach a different number.                                                                          |
| V   | Negation: If a lesser number is in front of a larger number, subtract the lesser number from the next number.                            |
| VI   | Negation: Only one lesser number can be written before a larger number.                                                                  |

### We're in the grey / gray area now:

From here on out things get a little fuzzy and subject to interpretation. The Ancient romans weren't really known as math scholars. There are multiple systems out there for supporting the "Big" numbers. I think we've struck a solid compromise which should satisfy most of the people out there. If you are a purist and don't want to take part in any of the Tom foolery that's about to unfold, hop on down to the Reference section. RInt() follows the VI golden rules above out of the box. Just don't ever enter a number less than I or greater than MMMCMXLIX, and go on living your happy life. No worries, you won't sail off the edge of the planet.

### Zero

If we're going to support negative numbers we have to deal with Zero so we can cross over into the nether region. During my intensive II hour study of Ancient Rome, while they may not of had a number for Zero, they had a concept of nothing, or "Nulla." While tempted to use nil, we chose to use the word Nulla instead for compatibility. No need to bring unwrapping into every calculation we're going to do. When importing numbers RInt also supports N for zero, however it's displayed as Nulla. I found one vague reference to it, and it was easy enough to include.

**Extended rule VII: Nulla equals Zero.**

### Negative Numbers:

In the practical sense, negative numbers represent the opposite of what ever the number represents. They had the sense of debits and credits in financial systems and being short. To denote negative numbers as in debitum, credit or Debt Owed, we've decided to follow modern day Accounting Practices and denote them with "cr" as a default. Because I haven't found any references to this being a common practice, I've added a static default to the struct. If you ever run across historical evidence of a specific symbol being used, ***PLEASE*** let me know.

    RInt.defautNegativeSign = "cr"

If you prefer "-", "Nons", "Debt", or whatever you desire to denote  negative numbers, just change it in your loaded event or at the beginning of your code, just set it and all RInts will use it instead of the default. Note this is a "global" setting and all RInt instances currently initialized will use it too.

**Extended rule VIII: Negative numbers will be denoted with a sign of some sort, the default is "cr".**

### Big Numbers

There are several competing methods to denote a big number.

Option 1: just put as many Ms as you need. MMMMMMMMMM would be 10,000. You can quickly see the problem. MMMMMMMMMM MMMMMMMMMM MMMMMMMMMM MMMMMMMMMM MMMMMMMMMM MMMMMMMMMM MMMMMMMMMM MMMMMMMMMM MMMMMMMMMM MMMMMMMMMM MMMMMMMMMM is only 100,000.

Option 2: use the C and latin character Ɔ characters instead of lines. While this was used for a while, My problem with this is who wants to go pull up your emoji map out every time to add Ɔ? Some systems used the symbols to mean multiply by 100 or 1,000.

Option 4: Using an over-score or a line above the number to represent that the digit is to be multiplied by 1,000  an M̄ with one line on top would be 1 million, 2 lines, 1 billion. The problem with this is trying to represent text like this in a string can be difficult. We'd need to be able to draw 6 lines to get to 1 quintillion.

Option 4: Use parens or brackets to denote over-scores. They're readily available on your keyboard. (M) is one million ((((((M)))))) 1,000,0000,0000,0000,0000,0000, one quintillion.

Okay great, now we've got a way to represent Big numbers. However, should (I) be allowed? Because M exists and it's part of the base Roman numerals, I say no. Like the base rule # 2 about the "5s" (I) would be equal to M and should not be allowed to avoid confusion. That said, it was a widely adopted method. To that end, we support it on import, however, it's modified to M.

| Roman |   Decimal | Comments       |
|:-----:| ---------:| -------------- |
|  (I)  |     1,000 | on import only |
|  (V)  |     5,000 |                |
|  (X)  |    10,000 |                |
|  (L)  |    50,000 |                |
|  (C)  |   100,000 |                |
|  (D)  |   500,000 |                |
|  (M)  | 1,000,000 | one million    |

In keeping with over-score tradition we consolidate like magnitudes, for example:((M)MMCM)ILII 1,002,900,042.

**Extended rule IX: Numerals inside parens are multiplied by 1,000 for each paren.**

**Extended rule X: (I), (II), (III) are supported on input only**

### Installation:

Numerus Romanus is a pure Swift type and has no dependancies other than the Swift Foundation. The recommended way to install is to just import the RInt.swift source file into your project.

### Reference:

#### struct RInt: Int
    struct RInt:
        SignedInteger,
        ExpressibleByStringLiteral,
        ExpressibleByFloatLiteral,
        ExpressibleByIntegerLiteral {

A Roman Numeral Integer type compatible with Int.

#### Static Properties

**public static var defaultNegativeSign = "cr"**

Returns or sets the default value for the negative sign.

**public static var Nulla = "Nulla"**

returns or sets the default value for zero.

#### Instance Properties

**public var value: Int**

Exposed Int value of the RInt.

**public var description: String**

The Roman Numeral description of value.

#### Convenience Instance Functions

**asInt: Int**

returns the current value cast as an Int.

**asDouble: Double**

Returns the current value cast as a Double.

**asHexString: String**

Returns the current value as a hex string.

**asBinaryString: String**

Returns the current value as a binary string.

**asRomanString: String**

Returns the current value asa a roman number string.

#### Initializers:

Literal Initializers exist for all numeric types.

**init( ):**

Initializes the variable and sets the value to Nulla.

**init( _ value: Int)**

Initializes the variable and sets the value to the Int value supplied.

**init(_ value: String)?**

Initializes the variable and attempts to convert the value to a number. The following formats are supported:

| Format                | Numerals                     | Comments                                                                   |
| --------------------- | ---------------------------- | -------------------------------------------------------------------------- |
| Hindu–Arabic numerals | 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 | If a decimal number is supplied it is reduced to the nearest whole number. |
| Roman                 | Nulla, I, V, X, L, C, D, M   | Supports Shortening Nulla to N, and will convert (I) to M if encountered.  |
| Empty String          | ""                           | Converts to Nulla                                                          |

### Math:
Operators supported: + - * / % &= |= ^= >>= <<= ~

RInts allow direct use of Int types in calculations. For example:

    var r: RInt = "c"
    let x: Int = 23

    r = r + x

    print(r) // CXXIII (123)

The reasoning behind this is RInts are for all intents and purposes interchangeable with Ints, and I wanted direct support.

#### Static conversion Functions:

RInt() has two static conversion functions which can be called directly.

**RInt.convertToRoman(_ value: Int) -> String**

Converts the Int Value to a Roman Numeral String.

**RInt.convertStringToInt(_ value: String) -> Int**

Converts a String to an Int following the rules of initialization by String.

#### Examples:

    var year =  RInt(2018)
    print(year) // MMXVIII

    year += 1

    print(year) // MMXIX

    year = RInt("MM") + RInt(18)
    print(year) // MMXVIII

This one is Or even better:

      modelNumber RInt: = 10

      print("Wow, how do you like your iPhone\(modelNumber)?")

Now to blow your mind try:

     let year: RInt = "M" + 1000 + 1.0 + 0xF | 0b0010
     print(year) // MMXVIII

**Yep that's Roman Literal Integer Double Hex Binary :]**

# Version Updates:

## Nulla . II . Nulla

Added support for Roman Unicode characters.

added:

**New:** A default to select if the returned strings are in normal alpha characters or in Roman Unicode:

    public static var defaultUseRomanUnicodeChars: Bool

**New:** An enumeration for Text Case.

    public enum TextCase: String { case Upper, Lower }

**Updated:** description to return either alpha characters or the extended Roman unicode characters based on default selections.

    public var description: String

**Updated:** The property asRomanString is always returned as an alpha string.

    public var asRomanString

**New:** The property asRomanUnicodeChars is aways returned as RomanUnicode.

    public asRomanUnicodeChars: string

**Updated:** Added support for Roman Unicode characters for input from string literals, etc. Added the ability to override the default case.

    public static func convertToRoman(_ value: Int,
           useRomanUnicode: Bool = defaultUseRomanUnicodeChars,
           textCase: TextCase = defaultCase ) -> String

**New:** Added Unit test for Roman Unicode support.

    func testRomanUnicodeCharacterSupport()

**Updated:** Updated the conversion unit test to include Roman Unicode testing.

    func testConversion()

## Nulla . I . Nulla

Initial release
