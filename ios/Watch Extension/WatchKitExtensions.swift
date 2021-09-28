//
//  WatchKitExtensions.swift
//  BGTest WatchKit Extension
//
//  Created by SONGKIWON on 2020/07/30.
//  Copyright © 2020 intosharp. All rights reserved.
//

import ClockKit

extension CLKComplicationFamily: CustomStringConvertible {
    public var description: String {
        switch self {
        case .modularSmall:             return "modularSmall"
        case .modularLarge:             return "modularLarge"
        case .utilitarianSmall:         return "utilitarianSmall"
        case .utilitarianSmallFlat:     return "utilitarianSmallFlat"
        case .utilitarianLarge:         return "utilitarianLarge"
        case .circularSmall:            return "circularSmall"
        case .extraLarge:               return "extraLarge"
        case .graphicCorner:            return "graphicCorner"
        case .graphicBezel:             return "graphicBezel"
        case .graphicCircular:          return "graphicCircular"
        case .graphicRectangular:       return "graphicRectangular"
        case .graphicExtraLarge:        return "graphicExtraLarge"
        @unknown default:
            return "None"
        }
    }
}
