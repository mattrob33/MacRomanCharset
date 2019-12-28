# MacRomanCharset
A Java Charset for MacRoman encoding, written in Oxygene.

## Why?
MacRoman is listed as [a supported encoding by Oracle](https://docs.oracle.com/javase/8/docs/technotes/guides/intl/encoding.doc.html) (`x-MacRoman`) but [JVMs are not required to support it](https://docs.oracle.com/javase/8/docs/api/java/nio/charset/Charset.html#iana) so MacRoman support cannot be assumed.

## Use
To get MacRoman bytes from a String:

```string.getBytes("MacRoman");```

To create a String from MacRoman bytes:

```new String(bytes, "MacRoman");```

## Credit
Based on [noophq/java-charset](https://github.com/noophq/java-charset).
