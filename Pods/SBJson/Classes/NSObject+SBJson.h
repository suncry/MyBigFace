/*
 Copyright (C) 2009 Stig Brautaset. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

 * Neither the name of the author nor the names of its contributors may be used
   to endorse or promote products derived from this software without specific
   prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF M/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/NSObject+SBJson.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/NSObject+SBJson.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJson.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonParser.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonParser.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamParser.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamParser.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamParserAccumulator.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamParserAccumulator.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamParserAdapter.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamParserAdapter.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamParserState.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamParserState.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamWriter.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamWriter.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamWriterAccumulator.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamWriterAccumulator.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamWriterState.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonStreamWriterState.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonTokeniser.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonTokeniser.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonUTF8Stream.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonUTF8Stream.m
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonWriter.h
/Users/cy/Desktop/MyBigFace/Pods/SBJson/Classes/SBJsonWriter.mERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

#pragma mark JSON Writing

/// Adds JSON generation to NSObject
@interface NSObject (NSObject_SBJsonWriting)

/**
 Encodes the receiver into a JSON string

 Although defined as a category on NSObject it is only defined for NSArray and NSDictionary.

 @return the receiver encoded in JSON, or nil on error.

 @warning Deprecated in Version 3.2; will be removed in 4.0

 */
- (NSString *)JSONRepresentation __attribute__ ((deprecated));

@end


#pragma mark JSON Parsing

/// Adds JSON parsing methods to NSString
@interface NSString (NSString_SBJsonParsing)

/**
 Decodes the receiver's JSON text

 @return the NSDictionary or NSArray represented by the receiver, or nil on error.

 @warning Deprecated in Version 3.2; will be removed in 4.0

 */
- (id)JSONValue __attribute__ ((deprecated));

@end

/// Adds JSON parsing methods to NSData
@interface NSData (NSData_SBJsonParsing)

/**
 Decodes the receiver's JSON data

 @return the NSDictionary or NSArray represented by the receiver, or nil on error.

 @warning Deprecated in Version 3.2; will be removed in 4.0

 */
- (id)JSONValue __attribute__ ((deprecated));

@end
