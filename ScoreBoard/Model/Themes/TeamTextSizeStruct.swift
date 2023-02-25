//
//  TeamTextSizeStruct.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 2/9/23.
//

import UIKit

/// Use this to determine font sizes for labels, based on how many scores are on the screen
/// [numberOfScores: fontSizeMultiplyer]

let sizeMap: [String: CGFloat] = ["FullSize": 1,
                                  "Large": 0.7,
                                  "Medium": 0.6,
                                  "MediumSmall": 0.5,
                                  "Small": 0.45,
                                  "VerySmall": 0.3
]

struct TeamTextSizeStruct {
    
    let iPhoneSizes: [Int: CGFloat] = [0: sizeMap["Medium"]!,
                                      1: sizeMap["Medium"]!,
                                      2: sizeMap["Medium"]!,
                                      3: sizeMap["Small"]!,
                                      4: sizeMap["VerySmall"]!,
                                      5: sizeMap["VerySmall"]!,
                                      6: sizeMap["VerySmall"]!,
                                      7: sizeMap["VerySmall"]!,
                                      8: sizeMap["VerySmall"]!,
    ]
    
    let iPadSizes: [Int: CGFloat] = [0: sizeMap["FullSize"]!,
                                    1: sizeMap["FullSize"]!,
                                    2: sizeMap["Large"]!,
                                    3: sizeMap["Medium"]!,
                                    4: sizeMap["Medium"]!,
                                    5: sizeMap["Medium"]!,
                                    6: sizeMap["Medium"]!,
                                    7: sizeMap["MediumSmall"]!,
                                    8: sizeMap["MediumSmall"]!,
    ]
    
}
