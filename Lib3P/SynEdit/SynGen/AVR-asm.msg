TSynAvrAsmSyn {first Identifier is considered to be the Class Name }

tk {second Identifier is considered to be the Identifier Prefix }

IdentStart '_', 'a'..'z', 'A'..'Z':: '_', '0'..'9', 'a'..'z', 'A'..'Z'::


TOKENTYPES

Identifier

Comment

Space

String

Key

Register { ß Add the new token type here }

|><|


KEYS { all between KEYS and |><| is considered to be a keyword }
mov
movw
ld
ldi
lds
st
sts
|><|


KEYS Register { ß Create a new KEYS section, and specify the token type }
r0
r1
r2
r3
r4
r5
r6
r7
r8
r9
r10
r11
r12
r13
r14
r15
r16
r17
r18
r19
r20
r21
r22
r23
r24
r25
r26
r27
r28
r29
r30
r31
|><|

CHARS

'A'..'Z', 'a'..'z', '_':: Ident


BeginProc

fTokenID := IdentKind((fLine + Run));

inc(Run, fStringLen);

while Identifiers[fLine[Run]] do

Inc(Run);

EndProc

|><|


ENCLOSEDBY

Comment,BraceComment,{,},MultiLine

Comment,CStyleComment,/*,*/,MultiLine

String,String,","

|><|
