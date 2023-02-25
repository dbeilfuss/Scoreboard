//
//  BackgroundCenterPoint.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 2/24/23.
//

import Foundation

//
//  BackgroundCenterPoints.swift
//  ScoreBoard
//
//  Created by Daniel Beilfuss on 2/24/23.
//

import Foundation

// Use BackgroundCenterPoint to define where on a background you wish to center your scoreboard around.
// Consider the bellow diagram to be a screen of 16:9 aspect ratio.
// | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12| 13| 14| 15| 16|

// | 1 |

// | 2 |

// | 3 |

// | 4 |

// | 5 |

// | 6 |

// | 7 |

// | 8 |

// | 9 |

// Record your center point below as x:y coordinates

struct BackgroundCenterPoint {
    let x: Double
    let y: Double
    let maxZoom: Double // MaxZoom Level, 2.0 will double the size of the background image when appropriate
}
