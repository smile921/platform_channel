//
//  DESUtil.m
//  zhelitou
//
//  Created by saicheng on 14-11-16.
//  Copyright (c) 2014年 www.zimore.com. All rights reserved.
//

#import "DESUtil.h"
#import <CommonCrypto/CommonCrypto.h>
//#import "ZLTBase64Util.h"
@implementation DESUtil
//const Byte iv[] = {1,2,3,4,5,6,7,8};

+ (NSString *) encryptUseDES:(NSString *)data withSalt: (NSString*) salt {
    return [DESUtil encryptUseDES:data withFirstKey:salt withSecondKey:@"zjexZJEX" withThirdKey:nil];
}

+ (NSString *) encryptUseDES:(NSString *)data withFirstKey:(NSString *)firstKey withSecondKey:(NSString *)secondKey withThirdKey:(NSString *) thirdKey {
    int len = [data length];
    NSMutableString *encData = [[NSMutableString alloc] init];
    NSArray *firstKeyBt = nil, *secondKeyBt = nil, *thirdKeyBt = nil;
    int firstKeyLength = 0, secondKeyLength = 0, thirdKeyLength = 0;
    if (firstKey != nil && ![firstKey isEqualToString:@""]) {
        firstKeyBt = [DESUtil getKeyBytes:firstKey];
        firstKeyLength = [firstKeyBt count];
    }
    
    if (secondKey != nil && ![secondKey isEqualToString:@""]) {
        secondKeyBt = [DESUtil getKeyBytes:secondKey];
        secondKeyLength = [secondKeyBt count];
    }
    
    if (thirdKey != nil && ![thirdKey isEqualToString:@""]) {
        thirdKeyBt = [DESUtil getKeyBytes:thirdKey];
        thirdKeyLength = [thirdKeyBt count];
    }
    
    if (len > 0) {
        if (len < 4) {
            NSArray *bt = [DESUtil strToBt:data];
            NSArray *encByte = nil;
            if (firstKey != nil && ![firstKey isEqualToString:@""] && secondKey != nil && ![secondKey isEqualToString:@""]  && thirdKey != nil && ![thirdKey isEqualToString:@""]) {
                NSArray *tempBt;
                int x, y, z;
                tempBt = bt;
                for (x = 0; x < firstKeyLength; x++) {
                    tempBt = [DESUtil enc:tempBt withKeyBytes:[firstKeyBt objectAtIndex:x]];
                }
                for (y = 0; y < secondKeyLength; y++) {
                    tempBt = [DESUtil enc:tempBt withKeyBytes:[secondKeyBt objectAtIndex:y]];
                }
                for (z = 0; z < thirdKeyLength; z++) {
                    tempBt = [DESUtil enc:tempBt withKeyBytes:[thirdKeyBt objectAtIndex:z]];
                }
                encByte = tempBt;
            } else {
                if (firstKey != nil && ![firstKey isEqualToString:@""] && secondKey != nil
                    && ![secondKey isEqualToString:@""]) {
                    NSArray *tempBt;
                    int x, y;
                    tempBt = bt;
                    for (x = 0; x < firstKeyLength; x++) {
                        tempBt = [DESUtil enc:tempBt withKeyBytes:[firstKeyBt objectAtIndex:x]];//enc(tempBt, (int[]) firstKeyBt.get(x));
                    }
                    for (y = 0; y < secondKeyLength; y++) {
                        tempBt = [DESUtil enc:tempBt withKeyBytes:[secondKeyBt objectAtIndex:y]];//enc(tempBt, (int[]) secondKeyBt.get(y));
                    }
                    encByte = tempBt;
                } else {
                    if (firstKey != nil && ![firstKey isEqualToString:@""]) {
                        NSArray *tempBt;
                        int x = 0;
                        tempBt = bt;
                        for (x = 0; x < firstKeyLength; x++) {
                            tempBt = [DESUtil enc:tempBt withKeyBytes:[firstKeyBt objectAtIndex:x]];
                        }
                        encByte = tempBt;
                    }
                }
            
            }
            encData = [[NSMutableString alloc] initWithString:[DESUtil bt64ToHex:encByte]];
            
        } else {
            int iterator = (len / 4);
            int remainder = len % 4;
            int i = 0;
            for (i = 0; i < iterator; i++) {
                NSString *tempData = [data substringWithRange:NSMakeRange(i * 4 + 0, (i * 4 + 4) - (i * 4 + 0))];//data.substring(i * 4 + 0, i * 4 + 4);
                NSArray  *tempByte = [DESUtil strToBt:tempData];//strToBt(tempData);
                //int[] encByte = null;
                NSArray *encByte = nil;
                if (firstKey != nil && ![firstKey isEqualToString:@""] && secondKey != nil
                    && ![secondKey isEqualToString:@""] && thirdKey != nil
                    && ![thirdKey isEqualToString:@""]) {
                   // int[] tempBt;
                    NSArray *tempBt;
                    int x, y, z;
                    tempBt = tempByte;
                    for (x = 0; x < firstKeyLength; x++) {
                        tempBt = [DESUtil enc:tempBt withKeyBytes:[firstKeyBt objectAtIndex:x]];//enc(tempBt, (int[]) firstKeyBt.get(x));
                    }
                    for (y = 0; y < secondKeyLength; y++) {
                        //tempBt = enc(tempBt, (int[]) secondKeyBt.get(y));
                        tempBt = [DESUtil enc:tempBt withKeyBytes:[secondKeyBt objectAtIndex:y]];
                    }
                    for (z = 0; z < thirdKeyLength; z++) {
                        //tempBt = enc(tempBt, (int[]) thirdKeyBt.get(z));
                        tempBt = [DESUtil enc:tempBt withKeyBytes:[thirdKeyBt objectAtIndex:z]];
                    }
                    encByte = tempBt;
                } else {
                    if (firstKey != nil && ![firstKey isEqualToString:@""]
                        && secondKey != nil && ![secondKey isEqualToString:@""]) {
                        NSArray *tempBt;
                        int x, y;
                        tempBt = tempByte;
                        for (x = 0; x < firstKeyLength; x++) {
                           // tempBt = enc(tempBt, (int[]) firstKeyBt.get(x));
                            tempBt = [DESUtil enc:tempBt withKeyBytes:[firstKeyBt objectAtIndex:x]];
                        }
                        for (y = 0; y < secondKeyLength; y++) {
                           // tempBt = enc(tempBt, (int[]) secondKeyBt.get(y));
                            tempBt = [DESUtil enc:tempBt withKeyBytes:[secondKeyBt objectAtIndex:y]];
                        }
                        encByte = tempBt;
                    } else {
                        if (firstKey != nil && ![firstKey isEqualToString:@""]) {
                            NSArray *tempBt;
                            int x;
                            tempBt = tempByte;
                            for (x = 0; x < firstKeyLength; x++) {
                                //tempBt = enc(tempBt, (int[]) firstKeyBt
                                        //     .get(x));
                                tempBt = [DESUtil enc:tempBt withKeyBytes:[firstKeyBt objectAtIndex:x]];
                            }
                            encByte = tempBt;
                            
                        }
                    }
                }
                //encData += bt64ToHex(encByte);
                [encData appendString:[DESUtil bt64ToHex:encByte]];
                
            }
            if (remainder > 0) {
                NSString *remainderData = [data substringWithRange:NSMakeRange(iterator * 4 + 0, (len - iterator * 4 + 0))];//data.substring(iterator * 4 + 0,len);
                NSArray *tempByte = [DESUtil strToBt:remainderData];//strToBt(remainderData);
                NSArray *encByte = nil;
                if (firstKey != nil && ![firstKey isEqualToString:@""] && secondKey != nil
                    && ![secondKey isEqualToString:@""] && thirdKey != nil
                    && ![thirdKey isEqualToString:@""]) {
                    NSArray *tempBt;
                    int x, y, z;
                    tempBt = tempByte;
                    for (x = 0; x < firstKeyLength; x++) {
                        tempBt = [DESUtil enc:tempBt withKeyBytes:[firstKeyBt objectAtIndex:x]];//enc(tempBt, (int[]) firstKeyBt.get(x));
                    }
                    for (y = 0; y < secondKeyLength; y++) {
                        tempBt = [DESUtil enc:tempBt withKeyBytes:[secondKeyBt objectAtIndex:y]];//enc(tempBt, (int[]) secondKeyBt.get(y));
                    }
                    for (z = 0; z < thirdKeyLength; z++) {
                        tempBt = [DESUtil enc:tempBt withKeyBytes:[thirdKeyBt objectAtIndex:z]];//enc(tempBt, (int[]) thirdKeyBt.get(z));
                    }
                    encByte = tempBt;
                } else {
                    if (firstKey != nil && ![firstKey isEqualToString:@""]
                        && secondKey != nil && ![secondKey isEqualToString:@""]) {
                        NSArray *tempBt;
                        int x, y;
                        tempBt = tempByte;
                        for (x = 0; x < firstKeyLength; x++) {
                            tempBt = [DESUtil enc:tempBt withKeyBytes:[firstKeyBt objectAtIndex:x]];//enc(tempBt, (int[]) firstKeyBt.get(x));
                        }
                        for (y = 0; y < secondKeyLength; y++) {
                            tempBt = [DESUtil enc:tempBt withKeyBytes:[secondKeyBt objectAtIndex:y]];//enc(tempBt, (int[]) secondKeyBt.get(y));
                        }
                        encByte = tempBt;
                    } else {
                        if (firstKey != nil && ![firstKey isEqualToString:@""]) {
                            NSArray *tempBt;
                            int x;
                            tempBt = tempByte;
                            for (x = 0; x < firstKeyLength; x++) {
                                tempBt = [DESUtil enc:tempBt withKeyBytes:[firstKeyBt objectAtIndex:x]];//enc(tempBt, (int[]) firstKeyBt.get(x));
                            }
                            encByte = tempBt;
                        }
                    }
                }
                //encData += bt64ToHex(encByte);
                [encData appendString:[DESUtil bt64ToHex:encByte]];
            }
        }
    
    }
    return encData;
}

+ (NSString*) bt4ToHexString: (NSString *)binary {
    NSString *hex = @"";
   // hex = [hex uppercaseString];
    if ([binary isEqualToString:@"0000"]) {
        hex = @"0";
    } else if ([binary isEqualToString:@"0001"]) {
        hex = @"1";
    } else if ([binary isEqualToString:@"0010"]) {
        hex = @"2";
    } else if ([binary isEqualToString:@"0011"]) {
        hex = @"3";
    } else if ([binary isEqualToString:@"0100"]) {
        hex = @"4";
    } else if ([binary isEqualToString:@"0101"]) {
        hex = @"5";
    } else if ([binary isEqualToString:@"0110"]) {
        hex = @"6";
    } else if ([binary isEqualToString:@"0111"]) {
        hex = @"7";
    } else if ([binary isEqualToString:@"1000"]) {
        hex = @"8";
    } else if ([binary isEqualToString:@"1001"]) {
        hex = @"9";
    } else if ([binary isEqualToString:@"1010"]) {
        hex = @"A";
    } else if ([binary isEqualToString:@"1011"]) {
        hex = @"B";
    } else if ([binary isEqualToString:@"1100"]) {
        hex = @"C";
    } else if ([binary isEqualToString:@"1101"]) {
        hex = @"D";
    } else if ([binary isEqualToString:@"1110"]) {
        hex = @"E";
    } else if ([binary isEqualToString:@"1111"]) {
        hex = @"F";
    }
    return hex;
}

+ (NSString *) hexToBt64:(NSString *)hex {
    NSMutableString *binary = [[NSMutableString alloc] init];
    for (int i = 0; i < 16; i++) {
        [binary appendString:[DESUtil hexToBt64:[hex substringWithRange:NSMakeRange(i, 1)]]];//binary += hexToBt4(hex.substring(i, i + 1));
    }
    return binary;
}

+ (NSString *)bt64ToHex:(NSArray*)byteDataArray {
    
    NSMutableString *hex = [[NSMutableString alloc] init];
    for (int i = 0; i < 16; i++) {
        NSMutableString *bt = [[NSMutableString alloc] init];
        for (int j = 0; j < 4; j++) {
            [bt appendFormat:@"%@",[byteDataArray objectAtIndex:(i * 4 +j)]];
            
        }
        //hex += bt4ToHex(bt);
        [hex appendFormat:@"%@",[DESUtil bt4ToHexString:bt]];
        
    }
    
    return hex;
}


+ (NSArray *)generateKeys:(NSArray *)keyBytes {
    int key[56];
    int keys[16][48];
    int loop[] ={ 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1 };
    
    int keyByte[[keyBytes count]];
    
    for (int i = 0; i < [keyBytes count]; i++) {
        keyByte[i] = [(NSNumber *)[keyBytes objectAtIndex:i] intValue];
    }
    
    for (int i = 0; i < 7; i++) {
        for (int j = 0, k = 7; j < 8; j++, k--) {
            key[i * 8 + j] = keyByte[8 * k + i];
        }
    }
    
    int i = 0;
    for (i = 0; i < 16; i++) {
        int tempLeft = 0;
        int tempRight = 0;
        for (int j = 0; j < loop[i]; j++) {
            tempLeft = key[0];
            tempRight = key[28];
            for (int k = 0; k < 27; k++) {
                key[k] = key[k + 1];
                key[28 + k] = key[29 + k];
            }
            key[27] = tempLeft;
            key[55] = tempRight;
        }
        // var tempKey = new Array(48);
        int tempKey[48];
        tempKey[0] = key[13];
        tempKey[1] = key[16];
        tempKey[2] = key[10];
        tempKey[3] = key[23];
        tempKey[4] = key[0];
        tempKey[5] = key[4];
        tempKey[6] = key[2];
        tempKey[7] = key[27];
        tempKey[8] = key[14];
        tempKey[9] = key[5];
        tempKey[10] = key[20];
        tempKey[11] = key[9];
        tempKey[12] = key[22];
        tempKey[13] = key[18];
        tempKey[14] = key[11];
        tempKey[15] = key[3];
        tempKey[16] = key[25];
        tempKey[17] = key[7];
        tempKey[18] = key[15];
        tempKey[19] = key[6];
        tempKey[20] = key[26];
        tempKey[21] = key[19];
        tempKey[22] = key[12];
        tempKey[23] = key[1];
        tempKey[24] = key[40];
        tempKey[25] = key[51];
        tempKey[26] = key[30];
        tempKey[27] = key[36];
        tempKey[28] = key[46];
        tempKey[29] = key[54];
        tempKey[30] = key[29];
        tempKey[31] = key[39];
        tempKey[32] = key[50];
        tempKey[33] = key[44];
        tempKey[34] = key[32];
        tempKey[35] = key[47];
        tempKey[36] = key[43];
        tempKey[37] = key[48];
        tempKey[38] = key[38];
        tempKey[39] = key[55];
        tempKey[40] = key[33];
        tempKey[41] = key[52];
        tempKey[42] = key[45];
        tempKey[43] = key[41];
        tempKey[44] = key[49];
        tempKey[45] = key[35];
        tempKey[46] = key[28];
        tempKey[47] = key[31];
        int m;
        switch (i) {
            case 0:
                for (m = 0; m < 48; m++) {
                    keys[0][m] = tempKey[m];
                }
                break;
            case 1:
                for (m = 0; m < 48; m++) {
                    keys[1][m] = tempKey[m];
                }
                break;
            case 2:
                for (m = 0; m < 48; m++) {
                    keys[2][m] = tempKey[m];
                }
                break;
            case 3:
                for (m = 0; m < 48; m++) {
                    keys[3][m] = tempKey[m];
                }
                break;
            case 4:
                for (m = 0; m < 48; m++) {
                    keys[4][m] = tempKey[m];
                }
                break;
            case 5:
                for (m = 0; m < 48; m++) {
                    keys[5][m] = tempKey[m];
                }
                break;
            case 6:
                for (m = 0; m < 48; m++) {
                    keys[6][m] = tempKey[m];
                }
                break;
            case 7:
                for (m = 0; m < 48; m++) {
                    keys[7][m] = tempKey[m];
                }
                break;
            case 8:
                for (m = 0; m < 48; m++) {
                    keys[8][m] = tempKey[m];
                }
                break;
            case 9:
                for (m = 0; m < 48; m++) {
                    keys[9][m] = tempKey[m];
                }
                break;
            case 10:
                for (m = 0; m < 48; m++) {
                    keys[10][m] = tempKey[m];
                }
                break;
            case 11:
                for (m = 0; m < 48; m++) {
                    keys[11][m] = tempKey[m];
                }
                break;
            case 12:
                for (m = 0; m < 48; m++) {
                    keys[12][m] = tempKey[m];
                }
                break;
            case 13:
                for (m = 0; m < 48; m++) {
                    keys[13][m] = tempKey[m];
                }
                break;
            case 14:
                for (m = 0; m < 48; m++) {
                    keys[14][m] = tempKey[m];
                }
                break;
            case 15:
                for (m = 0; m < 48; m++) {
                    keys[15][m] = tempKey[m];
                }
                break;
        }
    }
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 16; i++) {
        NSMutableArray *subResultArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < 48; j++) {
            [subResultArray addObject:[[NSNumber alloc] initWithInt:keys[i][j]]];
        }
        [resultArray addObject:subResultArray];
        
    }
    return resultArray;
}

+ (NSArray *)initPermute:(NSArray *)originalDatas {
    int ipByte[64];
    int originalData[[originalDatas count]];
    for (int s = 0; s < [originalDatas count]; s++) {
        originalData[s] = [(NSNumber *)[originalDatas objectAtIndex:s] intValue];
    }
    
    int i = 0, m = 1, n = 0, j, k;
    for (i = 0, m = 1, n = 0; i < 4; i++, m += 2, n += 2) {
        for (j = 7, k = 0; j >= 0; j--, k++) {
            ipByte[i * 8 + k] = originalData[j * 8 + m];
            ipByte[i * 8 + k + 32] = originalData[j * 8 + n];
        }
    }
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int j = 0; j < 64; j++) {
        [resultArray addObject:[[NSNumber alloc] initWithInt:ipByte[j]]];
    }
    return  resultArray;
}

+ (NSArray *)finallyPermute:(NSArray *) endBytes {
    int fpByte[64];
    int endByte[[endBytes count]];
    for (int i = 0; i < [endBytes count]; i++) {
        endByte[i] = [(NSNumber *)[endBytes objectAtIndex:i] intValue];
    }
    
    fpByte[0] = endByte[39];
    fpByte[1] = endByte[7];
    fpByte[2] = endByte[47];
    fpByte[3] = endByte[15];
    fpByte[4] = endByte[55];
    fpByte[5] = endByte[23];
    fpByte[6] = endByte[63];
    fpByte[7] = endByte[31];
    fpByte[8] = endByte[38];
    fpByte[9] = endByte[6];
    fpByte[10] = endByte[46];
    fpByte[11] = endByte[14];
    fpByte[12] = endByte[54];
    fpByte[13] = endByte[22];
    fpByte[14] = endByte[62];
    fpByte[15] = endByte[30];
    fpByte[16] = endByte[37];
    fpByte[17] = endByte[5];
    fpByte[18] = endByte[45];
    fpByte[19] = endByte[13];
    fpByte[20] = endByte[53];
    fpByte[21] = endByte[21];
    fpByte[22] = endByte[61];
    fpByte[23] = endByte[29];
    fpByte[24] = endByte[36];
    fpByte[25] = endByte[4];
    fpByte[26] = endByte[44];
    fpByte[27] = endByte[12];
    fpByte[28] = endByte[52];
    fpByte[29] = endByte[20];
    fpByte[30] = endByte[60];
    fpByte[31] = endByte[28];
    fpByte[32] = endByte[35];
    fpByte[33] = endByte[3];
    fpByte[34] = endByte[43];
    fpByte[35] = endByte[11];
    fpByte[36] = endByte[51];
    fpByte[37] = endByte[19];
    fpByte[38] = endByte[59];
    fpByte[39] = endByte[27];
    fpByte[40] = endByte[34];
    fpByte[41] = endByte[2];
    fpByte[42] = endByte[42];
    fpByte[43] = endByte[10];
    fpByte[44] = endByte[50];
    fpByte[45] = endByte[18];
    fpByte[46] = endByte[58];
    fpByte[47] = endByte[26];
    fpByte[48] = endByte[33];
    fpByte[49] = endByte[1];
    fpByte[50] = endByte[41];
    fpByte[51] = endByte[9];
    fpByte[52] = endByte[49];
    fpByte[53] = endByte[17];
    fpByte[54] = endByte[57];
    fpByte[55] = endByte[25];
    fpByte[56] = endByte[32];
    fpByte[57] = endByte[0];
    fpByte[58] = endByte[40];
    fpByte[59] = endByte[8];
    fpByte[60] = endByte[48];
    fpByte[61] = endByte[16];
    fpByte[62] = endByte[56];
    fpByte[63] = endByte[24];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 64; i ++) {
        [resultArray addObject:[[NSNumber alloc] initWithInt:fpByte[i]]];
    }
    return resultArray;
}

+ (NSArray *)xor: (NSArray *)byteOne withTwo:(NSArray *)byteTwo {
   /* int[] xorByte = new int[byteOne.length];
    for (int i = 0; i < byteOne.length; i++) {
        xorByte[i] = byteOne[i] ^ byteTwo[i];
    }
    return xorByte;*/
    int xorByte[[byteOne count]];
    for (int i = 0; i < [byteOne count]; i++) {
        xorByte[i] = [(NSNumber *)[byteOne objectAtIndex:i] intValue] ^ [(NSNumber *)[byteTwo objectAtIndex:i] intValue];
    }
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i =0; i < [byteOne count]; i++) {
        [resultArray addObject:[[NSNumber alloc] initWithInt:xorByte[i]]];
    }
    return resultArray;
}

+ (NSString *)getBoxBinaroy:(int) i {
    NSString *binary = @"";
    switch (i) {
        case 0:
            binary = @"0000";
            break;
        case 1:
            binary = @"0001";
            break;
        case 2:
            binary = @"0010";
            break;
        case 3:
            binary = @"0011";
            break;
        case 4:
            binary = @"0100";
            break;
        case 5:
            binary = @"0101";
            break;
        case 6:
            binary = @"0110";
            break;
        case 7:
            binary = @"0111";
            break;
        case 8:
            binary = @"1000";
            break;
        case 9:
            binary = @"1001";
            break;
        case 10:
            binary = @"1010";
            break;
        case 11:
            binary = @"1011";
            break;
        case 12:
            binary = @"1100";
            break;
        case 13:
            binary = @"1101";
            break;
        case 14:
            binary = @"1110";
            break;
        case 15:
            binary = @"1111";
            break;
    }
    return binary;

}
+ (NSArray *)sBoxPermute: (NSArray *)expandByteArray {
    int sBoxByte[32];
    int expandByte[[expandByteArray count]];
    for (int i = 0; i < [expandByteArray count]; i++) {
        expandByte[i] = [(NSNumber *)[expandByteArray objectAtIndex:i] intValue];
    }
    NSString *binary = @"";
    int s1[4][16] = {
        { 14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7 },
        { 0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8 },
        { 4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0 },
        { 15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13 } };
    
    /* Table - s2 */
    int s2[4][16] = {
        { 15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10 },
        { 3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5 },
        { 0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15 },
        { 13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9 } };
    
    /* Table - s3 */
    int s3[4][16] = {
        { 10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8 },
        { 13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1 },
        { 13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7 },
        { 1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12 } };
    /* Table - s4 */
    int s4[4][16] = {
        { 7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15 },
        { 13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9 },
        { 10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4 },
        { 3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14 } };
    
    /* Table - s5 */
    int s5[4][16] = {
        { 2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9 },
        { 14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6 },
        { 4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14 },
        { 11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3 } };
    
    /* Table - s6 */
    int s6[4][16] = {
        { 12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11 },
        { 10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8 },
        { 9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6 },
        { 4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13 } };
    
    /* Table - s7 */
    int s7[4][16] = {
        { 4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1 },
        { 13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6 },
        { 1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2 },
        { 6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12 } };
    
    /* Table - s8 */
    int s8[4][16] = {
        { 13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7 },
        { 1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2 },
        { 7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8 },
        { 2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11 } };
    
    for (int m = 0; m < 8; m++) {
        int i = 0, j = 0;
        i = expandByte[m * 6 + 0] * 2 + expandByte[m * 6 + 5];
        j = expandByte[m * 6 + 1] * 2 * 2 * 2 + expandByte[m * 6 + 2] * 2
        * 2 + expandByte[m * 6 + 3] * 2 + expandByte[m * 6 + 4];
        switch (m) {
            case 0:
                binary = [DESUtil getBoxBinaroy:s1[i][j]];
                break;
            case 1:
                binary = [DESUtil getBoxBinaroy:s2[i][j]];
                break;
            case 2:
                binary = [DESUtil getBoxBinaroy:s3[i][j]];
                break;
            case 3:
                binary = [DESUtil getBoxBinaroy:s4[i][j]];
                break;
            case 4:
                binary = [DESUtil getBoxBinaroy:s5[i][j]];
                break;
            case 5:
                binary = [DESUtil getBoxBinaroy:s6[i][j]];
                break;
            case 6:
                binary = [DESUtil getBoxBinaroy:s7[i][j]];
                break;
            case 7:
                binary = [DESUtil getBoxBinaroy:s8[i][j]];
                break;
        }
        sBoxByte[m * 4 + 0] = [(NSNumber *)[binary substringWithRange:NSMakeRange(0, 1)] intValue];//Integer.parseInt(binary.substring(0, 1));
        sBoxByte[m * 4 + 1] = [(NSNumber *)[binary substringWithRange:NSMakeRange(1, 1)] intValue];//Integer.parseInt(binary.substring(1, 2));
        sBoxByte[m * 4 + 2] = [(NSNumber *)[binary substringWithRange:NSMakeRange(2, 1)] intValue];//Integer.parseInt(binary.substring(2, 3));
        sBoxByte[m * 4 + 3] = [(NSNumber *)[binary substringWithRange:NSMakeRange(3, 1)] intValue];//Integer.parseInt(binary.substring(3, 4));
    }
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 32; i++) {
        [resultArray addObject:[[NSNumber alloc] initWithInt:sBoxByte[i]]];
    }
    return resultArray;
}


+ (NSArray *)expandPermute:(NSArray *)rightDataArray {
    int epByte[48];
    int i, j;
    int rightData[[rightDataArray count]];
    for (int s = 0; s < [rightDataArray count]; s++) {
        rightData[s] = [(NSNumber *)[rightDataArray objectAtIndex:s] intValue];
    }
    for (i = 0; i < 8; i++) {
        if (i == 0) {
            epByte[i * 6 + 0] = rightData[31];
        } else {
            epByte[i * 6 + 0] = rightData[i * 4 - 1];
        }
        epByte[i * 6 + 1] = rightData[i * 4 + 0];
        epByte[i * 6 + 2] = rightData[i * 4 + 1];
        epByte[i * 6 + 3] = rightData[i * 4 + 2];
        epByte[i * 6 + 4] = rightData[i * 4 + 3];
        if (i == 7) {
            epByte[i * 6 + 5] = rightData[0];
        } else {
            epByte[i * 6 + 5] = rightData[i * 4 + 4];
        }
    }
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (j = 0; j < 48; j++) {
        [resultArray addObject:[[NSNumber alloc] initWithInt:epByte[j]]];
    }
    return resultArray;
}

+ (NSArray*)pPermute: (NSArray *)sBoxByteArray {
    
    int pBoxPermute[32];
    int sBoxByte[[sBoxByteArray count]];
    for (int i = 0; i < [sBoxByteArray count]; i++) {
        sBoxByte[i] = [(NSNumber *)[sBoxByteArray objectAtIndex:i] intValue];
    }
    
    pBoxPermute[0] = sBoxByte[15];
    pBoxPermute[1] = sBoxByte[6];
    pBoxPermute[2] = sBoxByte[19];
    pBoxPermute[3] = sBoxByte[20];
    pBoxPermute[4] = sBoxByte[28];
    pBoxPermute[5] = sBoxByte[11];
    pBoxPermute[6] = sBoxByte[27];
    pBoxPermute[7] = sBoxByte[16];
    pBoxPermute[8] = sBoxByte[0];
    pBoxPermute[9] = sBoxByte[14];
    pBoxPermute[10] = sBoxByte[22];
    pBoxPermute[11] = sBoxByte[25];
    pBoxPermute[12] = sBoxByte[4];
    pBoxPermute[13] = sBoxByte[17];
    pBoxPermute[14] = sBoxByte[30];
    pBoxPermute[15] = sBoxByte[9];
    pBoxPermute[16] = sBoxByte[1];
    pBoxPermute[17] = sBoxByte[7];
    pBoxPermute[18] = sBoxByte[23];
    pBoxPermute[19] = sBoxByte[13];
    pBoxPermute[20] = sBoxByte[31];
    pBoxPermute[21] = sBoxByte[26];
    pBoxPermute[22] = sBoxByte[2];
    pBoxPermute[23] = sBoxByte[8];
    pBoxPermute[24] = sBoxByte[18];
    pBoxPermute[25] = sBoxByte[12];
    pBoxPermute[26] = sBoxByte[29];
    pBoxPermute[27] = sBoxByte[5];
    pBoxPermute[28] = sBoxByte[21];
    pBoxPermute[29] = sBoxByte[10];
    pBoxPermute[30] = sBoxByte[3];
    pBoxPermute[31] = sBoxByte[24];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 32; i++) {
        [resultArray addObject:[[NSNumber alloc] initWithInt:pBoxPermute[i]]];
    
    }
    return resultArray;
}


+ (NSArray *)enc:(NSArray *)dataByte withKeyBytes:(NSArray *)keyByte {
    NSArray *keysArray = [DESUtil generateKeys:keyByte];
    NSArray *ipByteArray = [DESUtil initPermute:dataByte];
    
    int keys[[keysArray count]][[[keysArray objectAtIndex:0] count]];
    int ipByte[[ipByteArray count]];
    
    for (int i = 0; i < [keysArray count]; i++) {
        NSArray *subArray = [keysArray objectAtIndex:i];
        for (int j = 0; j < [subArray count]; j++) {
            keys[i][j] = [(NSNumber *)[subArray objectAtIndex:j] intValue];
        }
    }
    
    for (int j = 0; j < [ipByteArray count]; j++) {
        ipByte[j] = [(NSNumber *)[ipByteArray objectAtIndex:j] intValue];
    }
    
    int ipLeft[32];
    int ipRight[32];
    int tempLeft[32];
    int i = 0, j = 0, k = 0, m = 0, n = 0;
    for (k = 0; k < 32; k++) {
        ipLeft[k] = ipByte[k];
        ipRight[k] = ipByte[32 + k];
    }
    for (i = 0; i < 16; i++) {
        for (j = 0; j < 32; j++) {
            tempLeft[j] = ipLeft[j];
            ipLeft[j] = ipRight[j];
        }
        int key[48];
        for (m = 0; m < 48; m++) {
            key[m] = keys[i][m];
        }
        
        NSMutableArray *ipRightArray = [[NSMutableArray alloc] init];
        for (int s = 0; s < 32; s++) {
            [ipRightArray addObject:[[NSNumber alloc] initWithInt:ipRight[s]]];
        }
        
        NSMutableArray *keyArray = [[NSMutableArray alloc] init];
        for (int s = 0; s < 48; s++) {
            [keyArray addObject:[[NSNumber alloc] initWithInt:key[s]]];
        }
        
        NSMutableArray *tempLeftArray = [[NSMutableArray alloc] init];
        for (int s = 0; s < 32; s++) {
            [tempLeftArray addObject:[[NSNumber alloc] initWithInt:tempLeft[s]]];
        }
        
        NSArray *tempRightArray = [DESUtil xor:[DESUtil pPermute:[DESUtil sBoxPermute:[DESUtil xor:[DESUtil expandPermute:ipRightArray] withTwo:keyArray]]] withTwo:tempLeftArray];
       // int[] tempRight = xor(pPermute(sBoxPermute(xor(
                                                      //expandPermute(ipRight), key))), tempLeft);
        int tempRight[[tempRightArray count]];
        for (int s = 0; s < [tempRightArray count]; s++) {
            tempRight[s] = [(NSNumber *)[tempRightArray objectAtIndex:s] intValue];
        }
        for (n = 0; n < 32; n++) {
            ipRight[n] = tempRight[n];
        }
        
    }
    
    int finalData[64];
    for (i = 0; i < 32; i++) {
        finalData[i] = ipRight[i];
        finalData[32 + i] = ipLeft[i];
    }
    NSMutableArray *finalDataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 64; i++) {
        [finalDataArray addObject:[[NSNumber alloc] initWithInt:finalData[i]]];
    }
    return [DESUtil finallyPermute:finalDataArray];

}

+ (NSArray *)getKeyBytes:(NSString *)keyStr {
    NSMutableArray *keyBytes = [[NSMutableArray alloc] init];
    int len = [keyStr length];
    int iterator = len / 4;
    int remainder = len % 4;
    int i = 0;
    for (i = 0; i < iterator; i++) {
       // [keyBytes addObject:[DESUtil strToBt:[keyStr substringWithRange:NSMakeRange(i * 4 + 0, i * 4 + 4)]]];
        [keyBytes insertObject:[DESUtil strToBt:[keyStr substringWithRange:NSMakeRange(i * 4 + 0, (i * 4 + 4) - (i * 4 + 0))]] atIndex:i];
    }
    
    if (remainder > 0) {
        [keyBytes insertObject:[DESUtil strToBt:[keyStr substringWithRange:NSMakeRange(i * 4 + 0, len - (i * 4 + 0))]] atIndex:i];
    }
  
    return keyBytes;
}
+ (NSArray *)strToBt: (NSString *)str {
    int len = [str length];
    NSMutableArray *bt = [[NSMutableArray alloc] init];
    if (len < 4) {
        int i = 0, j = 0, p = 0, q = 0;
        for (i = 0; i < len; i++) {
            int k = [str characterAtIndex:i];
            for (j = 0; j < 16; j++) {
                int pow = 1, m = 0;
                for (m = 15; m > j; m--) {
                    pow *= 2;
                }
                
               // bt[16 * i + j] = (k / pow) % 2;
                [bt insertObject:[[NSNumber alloc] initWithInt:((k / pow) % 2)] atIndex:16 * i + j];
            }
        }
        for (p = len; p < 4; p++) {
            int k = 0;
            for (q = 0; q < 16; q++) {
                int pow = 1, m = 0;
                for (m = 15; m > q; m --) {
                    pow *= 2;
                }
               // bt[16 * p + q] = (k / pow) % 2;
                [bt insertObject:[[NSNumber alloc] initWithInt:((k / pow) % 2)] atIndex:16 * p + q];
            }
        }
    } else {
        for (int i = 0; i < 4; i++) {
            int k = [str characterAtIndex:i];
            for (int j = 0; j < 16; j++) {
                int pow = 1;
                for (int m = 15; m > j; m--) {
                    pow *= 2;
                }
                //bt[16 * i + j] = (k / pow) % 2;
                [bt insertObject:[[NSNumber alloc] initWithInt:((k / pow) % 2)] atIndex:16 * i + j];
            }
        }
    }
    NSMutableString *str11 = [[NSMutableString alloc] init];
    for (int z = 0; z < 64; z++) {
        [str11 appendFormat:@"%d", [(NSNumber *)[bt objectAtIndex:z] intValue]];
    }
    
    return bt;
}
@end
