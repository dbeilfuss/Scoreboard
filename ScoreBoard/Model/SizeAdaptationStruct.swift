//
//  TeamTextSizeStruct.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 2/9/23.
//

import UIKit

/// Use this to determine font sizes for labels, based on how many scores are on the screen
/// [numberOfScores: fontSizeMultiplyer]

let fontSizeRatio: [String: CGFloat] = ["FullSize": 1,
                                  "Large": 0.7,
                                  "Medium": 0.6,
                                  "MediumSmall": 0.5,
                                  "Small": 0.45,
                                  "VerySmall": 0.3
]

let backgroundZoomRatio: [String: CGFloat] = ["FullSize": 0.0,
                                              "Large": 0.25,
                                              "Medium": 0.75,
                                              "MediumSmall": 1,
                                              "Small": 1,
                                              "VerySmall": 1
]

struct SizeAdaptationStruct {
    
    let iPhoneSizes: [Int: CGFloat] = [0: fontSizeRatio["Medium"]!,
                                      1: fontSizeRatio["Medium"]!,
                                      2: fontSizeRatio["Medium"]!,
                                      3: fontSizeRatio["Small"]!,
                                      4: fontSizeRatio["VerySmall"]!,
                                      5: fontSizeRatio["VerySmall"]!,
                                      6: fontSizeRatio["VerySmall"]!,
                                      7: fontSizeRatio["VerySmall"]!,
                                      8: fontSizeRatio["VerySmall"]!,
    ]
    
    let iPadSizes: [Int: CGFloat] = [0: fontSizeRatio["FullSize"]!,
                                    1: fontSizeRatio["FullSize"]!,
                                    2: fontSizeRatio["Large"]!,
                                    3: fontSizeRatio["Medium"]!,
                                    4: fontSizeRatio["Medium"]!,
                                    5: fontSizeRatio["Medium"]!,
                                    6: fontSizeRatio["Medium"]!,
                                    7: fontSizeRatio["MediumSmall"]!,
                                    8: fontSizeRatio["MediumSmall"]!,
    ]
    
}
