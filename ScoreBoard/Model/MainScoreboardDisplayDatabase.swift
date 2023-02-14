//
//  MainScoreboardDisplayDatabase.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 2/7/23.
//

import UIKit

/// Look for the arrangement of which team views to actually use, based on how many active teams there are
struct MainScoreboardDisplayDatabase {
    let iPadArrangement: [Int: [Bool]] = [0: [false, // 1
                                              false, // 2
                                              false, // 3
                                              false, // 4
                                              false, // 5
                                              false, // 6
                                              false, // 7
                                              false // 8
                                             ],
                                          1: [true, // 1
                                              false, // 2
                                              false, // 3
                                              false, // 4
                                              false, // 5
                                              false, // 6
                                              false, // 7
                                              false // 8
                                             ],
                                          2: [true, // 1
                                              true, // 2
                                              false, // 3
                                              false, // 4
                                              false, // 5
                                              false, // 6
                                              false, // 7
                                              false // 8
                                             ],
                                          3: [true, // 1
                                              true, // 2
                                              true, // 3
                                              false, // 4
                                              false, // 5
                                              false, // 6
                                              false, // 7
                                              false // 8
                                             ],
                                          4: [true, // 1
                                              true, // 2
                                              false, // 3
                                              false, // 4
                                              true, // 5
                                              true, // 6
                                              false, // 7
                                              false // 8
                                             ],
                                          5: [true, // 1
                                              true, // 2
                                              false, // 3
                                              false, // 4
                                              true, // 5
                                              true, // 6
                                              true, // 7
                                              false // 8
                                             ],
                                          6: [true, // 1
                                              true, // 2
                                              true, // 3
                                              false, // 4
                                              true, // 5
                                              true, // 6
                                              true, // 7
                                              false // 8
                                             ],
                                          7: [true, // 1
                                              true, // 2
                                              true, // 3
                                              true, // 4
                                              true, // 5
                                              true, // 6
                                              true, // 7
                                              false // 8
                                             ],
                                          8: [true, // 1
                                              true, // 2
                                              true, // 3
                                              true, // 4
                                              true, // 5
                                              true, // 6
                                              true, // 7
                                              true // 8
                                             ]
    ]
    let iPhoneArrangement: [Int: [Bool]] = [0: [false, // 1
                                                false, // 2
                                                false, // 3
                                                false, // 4
                                                false, // 5
                                                false, // 6
                                                false, // 7
                                                false // 8
                                               ],
                                            1: [true, // 1
                                                false, // 2
                                                false, // 3
                                                false, // 4
                                                false, // 5
                                                false, // 6
                                                false, // 7
                                                false // 8
                                               ],
                                            2: [true, // 1
                                                true, // 2
                                                false, // 3
                                                false, // 4
                                                false, // 5
                                                false, // 6
                                                false, // 7
                                                false // 8
                                               ],
                                            3: [true, // 1
                                                true, // 2
                                                true, // 3
                                                false, // 4
                                                false, // 5
                                                false, // 6
                                                false, // 7
                                                false // 8
                                               ],
                                            4: [true, // 1
                                                true, // 2
                                                true, // 3
                                                true, // 4
                                                false, // 5
                                                false, // 6
                                                false, // 7
                                                false // 8
                                               ],
                                            5: [true, // 1
                                                true, // 2
                                                false, // 3
                                                false, // 4
                                                true, // 5
                                                true, // 6
                                                true, // 7
                                                false // 8
                                               ],
                                            6: [true, // 1
                                                true, // 2
                                                true, // 3
                                                false, // 4
                                                true, // 5
                                                true, // 6
                                                true, // 7
                                                false // 8
                                               ],
                                            7: [true, // 1
                                                true, // 2
                                                true, // 3
                                                true, // 4
                                                true, // 5
                                                true, // 6
                                                true, // 7
                                                false // 8
                                               ],
                                            8: [true, // 1
                                                true, // 2
                                                true, // 3
                                                true, // 4
                                                true, // 5
                                                true, // 6
                                                true, // 7
                                                true // 8
                                               ]
    ]
}
