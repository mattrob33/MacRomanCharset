NAMESPACE MacRomanCharset;

INTERFACE

USES
  java.util, java.nio, java.nio.charset;

  TYPE
    CharsetProvider = PUBLIC CLASS(java.nio.charset.spi.CharsetProvider)
    PRIVATE
      CONST
        MACROMAN_NAME = "MacRoman";
        MACROMAN_ALIASES: ARRAY OF String = ["x-mac-roman"];

      VAR
        fMacRomanCharset: Charset := NEW MacRomanCharset(MACROMAN_NAME, MACROMAN_ALIASES);
        fCharsets: List;

    PUBLIC
      CONSTRUCTOR;

      FUNCTION charsetForName (name: String): Charset;
      OVERRIDE;
      FUNCTION charsets: java.util.Iterator<Charset>;
      OVERRIDE;
    END;

    MacRomanCharset = PUBLIC CLASS(Charset)
    PUBLIC
      CONSTRUCTOR (canonicalName: String;
                    aliases: ARRAY OF String);

      FUNCTION contains (cs: Charset): Boolean;
      OVERRIDE;
      FUNCTION newEncoder: CharsetEncoder;
      OVERRIDE;
      FUNCTION newDecoder: CharsetDecoder;
      OVERRIDE;
    END;

    MacRomanCharsetEncoder = PUBLIC CLASS(CharsetEncoder)
    PUBLIC
      CONSTRUCTOR (cs: MacRomanCharset);

      FUNCTION encodeLoop (inBuffer: CharBuffer;
                    outBuffer: ByteBuffer): CoderResult;
      OVERRIDE;
    END;

    MacRomanCharsetDecoder = PUBLIC CLASS(CharsetDecoder)
    PUBLIC
      CONSTRUCTOR (cs: MacRomanCharset);

      FUNCTION decodeLoop (inBuffer: ByteBuffer;
                    outBuffer: CharBuffer): CoderResult;
      OVERRIDE;
    END;

    MacRomanCharsetMapping = PUBLIC CLASS
      PRIVATE CLASS encodingMapping, decodingMapping: HashMap<Integer, Integer>;

      PRIVATE CLASS PROCEDURE Init;

      PUBLIC CLASS FUNCTION Encode (x: Integer): Integer;
      PUBLIC CLASS FUNCTION Decode (y: Integer): Integer;
    END;

IMPLEMENTATION

    CONSTRUCTOR CharsetProvider;

    VAR csArr: ARRAY OF Object := [fMacRomanCharset];

  BEGIN
    fCharsets := Arrays.asList(csArr);
  END;


  FUNCTION CharsetProvider.charsetForName (name: String): Charset;
    {OVERRIDE;}

  BEGIN
    name := name.toUpperCase(Locale.US);

    VAR iter: java.util.Iterator := fCharsets.iterator;
    VAR cs: Charset;

    WHILE iter.hasNext DO
    BEGIN
      cs := Charset(iter.next);

      IF cs.name.equals(name) THEN
        EXIT cs;

      IF cs.aliases.contains(name) THEN
        EXIT cs;
    END;

    EXIT NIL;
  END;


  FUNCTION CharsetProvider.charsets: java.util.Iterator<Charset>;
    {OVERRIDE;}

  BEGIN
    EXIT fCharsets.iterator;
  END;


  CONSTRUCTOR MacRomanCharset (canonicalName: String;
                  aliases: ARRAY OF String);

  BEGIN
    INHERITED(canonicalName, aliases);
  END;


  FUNCTION MacRomanCharset.contains (cs: Charset): BOOLEAN;
    {OVERRIDE;}

  BEGIN
    EXIT cs.name = "US-ASCII";
  END;


  FUNCTION MacRomanCharset.newEncoder: CharsetEncoder;
    {OVERRIDE;}

  BEGIN
    EXIT NEW MacRomanCharsetEncoder(SELF);
  END;


  FUNCTION MacRomanCharset.newDecoder: CharsetDecoder;
    {OVERRIDE;}

  BEGIN
    EXIT NEW MacRomanCharsetDecoder(SELF);
  END;


  CONSTRUCTOR MacRomanCharsetEncoder (cs: MacRomanCharset);
    {OVERRIDE;}

  BEGIN
    INHERITED(cs, 2.0, 2.0);
  END;


  FUNCTION MacRomanCharsetEncoder.encodeLoop (inBuffer: CharBuffer;
                    outBuffer: ByteBuffer): CoderResult;
    {OVERRIDE;}

    VAR
      aChar: Char;
      aByte: Integer;

  BEGIN
    TRY
      WHILE (inBuffer.hasRemaining) DO
      BEGIN
        aChar := inBuffer.get;
        aByte := Byte(aChar) AND $FF;
        aByte := MacRomanCharsetMapping.Encode(aByte);
        outBuffer.put(Byte(aByte));
      END;
    EXCEPT
      ON boe: BufferOverflowException DO
        EXIT CoderResult.OVERFLOW;
    END;

    EXIT CoderResult.UNDERFLOW;
  END;


  CONSTRUCTOR MacRomanCharsetDecoder (cs: MacRomanCharset);
    {OVERRIDE;}

  BEGIN
    INHERITED(cs, 1.0, 1.0);
  END;


  FUNCTION MacRomanCharsetDecoder.decodeLoop (inBuffer: ByteBuffer;
                outBuffer: CharBuffer): CoderResult;
    {OVERRIDE;}

    VAR
      aByte: Integer;

  BEGIN
    TRY
      WHILE (inBuffer.hasRemaining) DO
      BEGIN
        aByte := (inBuffer.get AND $FF);
        outBuffer.put(Char(MacRomanCharsetMapping.Decode(aByte)));
      END;
    EXCEPT
      ON boe: BufferOverflowException DO
        EXIT CoderResult.OVERFLOW;
    END;

    EXIT CoderResult.UNDERFLOW;
  END;


  CLASS PROCEDURE MacRomanCharsetMapping.Init;

    PROCEDURE AddPair (x, y: Integer);

    BEGIN
      encodingMapping.put(x, y);
      decodingMapping.put(y, x);
    END;

  BEGIN (* CLASS FUNCTION MacRomanCharsetMapping.Init *)
    encodingMapping := NEW HashMap<Integer, Integer>;
    decodingMapping := NEW HashMap<Integer, Integer>;

    AddPair(196, 128);
    AddPair(197, 129);
    AddPair(199, 130);
    AddPair(201, 131);
    AddPair(209, 132);
    AddPair(214, 133);
    AddPair(220, 134);
    AddPair(225, 135);
    AddPair(224, 136);
    AddPair(226, 137);
    AddPair(228, 138);
    AddPair(227, 139);
    AddPair(229, 140);
    AddPair(231, 141);
    AddPair(233, 142);
    AddPair(232, 143);
    AddPair(234, 144);
    AddPair(235, 145);
    AddPair(237, 146);
    AddPair(236, 147);
    AddPair(238, 148);
    AddPair(239, 149);
    AddPair(241, 150);
    AddPair(243, 151);
    AddPair(242, 152);
    AddPair(244, 153);
    AddPair(246, 154);
    AddPair(245, 155);
    AddPair(250, 156);
    AddPair(249, 157);
    AddPair(251, 158);
    AddPair(252, 159);
    AddPair(8224, 160);
    AddPair(176, 161);
    AddPair(162, 162);
    AddPair(163, 163);
    AddPair(167, 164);
    AddPair(8226, 165);
    AddPair(182, 166);
    AddPair(223, 167);
    AddPair(174, 168);
    AddPair(169, 169);
    AddPair(8482, 170);
    AddPair(180, 171);
    AddPair(168, 172);
    AddPair(8800, 173);
    AddPair(198, 174);
    AddPair(216, 175);
    AddPair(8734, 176);
    AddPair(177, 177);
    AddPair(8804, 178);
    AddPair(8805, 179);
    AddPair(165, 180);
    AddPair(181, 181);
    AddPair(8706, 182);
    AddPair(8721, 183);
    AddPair(8719, 184);
    AddPair(960, 185);
    AddPair(8747, 186);
    AddPair(170, 187);
    AddPair(186, 188);
    AddPair(937, 189);
    AddPair(230, 190);
    AddPair(248, 191);
    AddPair(191, 192);
    AddPair(161, 193);
    AddPair(172, 194);
    AddPair(8730, 195);
    AddPair(402, 196);
    AddPair(8776, 197);
    AddPair(8710, 198);
    AddPair(171, 199);
    AddPair(187, 200);
    AddPair(8230, 201);
    AddPair(160, 202);
    AddPair(192, 203);
    AddPair(195, 204);
    AddPair(213, 205);
    AddPair(338, 206);
    AddPair(339, 207);
    AddPair(8211, 208);
    AddPair(8212, 209);
    AddPair(8220, 210);
    AddPair(8221, 211);
    AddPair(8216, 212);
    AddPair(8217, 213);
    AddPair(247, 214);
    AddPair(9674, 215);
    AddPair(255, 216);
    AddPair(376, 217);
    AddPair(8260, 218);
    AddPair(8364, 219);
    AddPair(8249, 220);
    AddPair(8250, 221);
    AddPair(64257, 222);
    AddPair(64258, 223);
    AddPair(8225, 224);
    AddPair(183, 225);
    AddPair(8218, 226);
    AddPair(8222, 227);
    AddPair(8240, 228);
    AddPair(194, 229);
    AddPair(202, 230);
    AddPair(193, 231);
    AddPair(203, 232);
    AddPair(200, 233);
    AddPair(205, 234);
    AddPair(206, 235);
    AddPair(207, 236);
    AddPair(204, 237);
    AddPair(211, 238);
    AddPair(212, 239);
    AddPair(63743, 240);
    AddPair(210, 241);
    AddPair(218, 242);
    AddPair(219, 243);
    AddPair(217, 244);
    AddPair(305, 245);
    AddPair(710, 246);
    AddPair(732, 247);
    AddPair(175, 248);
    AddPair(728, 249);
    AddPair(729, 250);
    AddPair(730, 251);
    AddPair(184, 252);
    AddPair(733, 253);
    AddPair(731, 254);
    AddPair(711, 255);
  END;


  CLASS FUNCTION MacRomanCharsetMapping.Encode (x: Integer): Integer;

  BEGIN
    IF encodingMapping = NIL THEN
      MacRomanCharsetMapping.Init;

    IF NOT encodingMapping.containsKey(x) THEN
      EXIT x;
    EXIT encodingMapping.get(x);
  END;


  CLASS FUNCTION MacRomanCharsetMapping.Decode (y: Integer): Integer;

  BEGIN
    IF decodingMapping = NIL THEN
      MacRomanCharsetMapping.Init;

    IF NOT decodingMapping.containsKey(y) THEN
      EXIT y;
    EXIT decodingMapping.get(y);
  END;

END.