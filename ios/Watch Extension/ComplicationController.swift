//
//  ComplicationController.swift
//  Watch Extension
//
//  Created by SONGKIWON on 2020/08/24.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
import ClockKit
import os

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let dataStore = DataStore()
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    //func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    //    handler(nil)
    //}
    
    //func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    //    handler(nil)
    //}
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        debugPrint("ComplicationController - getCurrentTimelineEntry : \(complication.family.description) Date : \(Date().display)")
                 
//         if let date = dataStore.lastUpdateDate {
//            if let template = getTemplate(family: complication.family) {
//                let entry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
//                handler(entry)
//                return
//            }
//         } else {
//            if let template = getTemplate(family: complication.family) {
//                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//                handler(entry)
//                return
//            }
//         }
//
//         handler(nil)
        
        guard let template = getTemplate(family: complication.family) else {
            debugPrint("ComplicationController - getCurrentTimelineEntry : getTestTemplate is null")
            return handler(nil)
        }
        
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
        handler(entry)
        
    }
    
    // MARK: - Placeholder Templates
        
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        debugPrint("ComplicationController - getLocalizableSampleTemplate : \(complication.family.description)")
        handler(getTemplate(family: complication.family))
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////// Image

    //func getDefaultColor() -> UIColor       { return UIColor.orange }
    //func getDefaultImage() -> UIImage       { return UIImage(named: "playstore_w")! }
    //func getBackgroundImage() -> UIImage    { return UIImage(named: "Background")! }
    //func getForegroundImage() -> UIImage    { return UIImage(named: "Foreground")! }

    func getImageProvider(complication: String) -> CLKImageProvider {
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "Complication/" + complication)!)
        //imageProvider.tintColor = getDefaultColor()
        return imageProvider
    }

    func getAlphaImageProvider(complication: String) -> CLKImageProvider {
        let imageProvider = CLKImageProvider(
            onePieceImage: UIImage(named: "Complication/" + complication)!,
            twoPieceImageBackground: UIImage(named: "Transparent")!,
            twoPieceImageForeground: UIImage(named: "Complication/" + complication)!
            //twoPieceImageForeground: UIImage(named: "Foreground")!
        )
        //imageProvider.tintColor = getDefaultColor()
        return imageProvider
    }

    func getFullColorImageProvider(complication: String) -> CLKFullColorImageProvider {
        return CLKFullColorImageProvider(
            fullColorImage: UIImage(named: "Complication/" + complication)!,
            tintedImageProvider: getAlphaImageProvider(complication: complication)
        )
    }
    
    //func getGraphicBezelFullColorImageProvider() -> CLKFullColorImageProvider {
    //
    //    let imageProvider = CLKImageProvider(
    //        onePieceImage: UIImage(named: "Complication/" + "Graphic Bezel")!,
    //        twoPieceImageBackground: UIImage(named: "Graphic Bezel Background")!,
    //        twoPieceImageForeground: UIImage(named: "Graphic Bezel Foreground")!
    //    )
    //
    //    return CLKFullColorImageProvider(
    //        fullColorImage: UIImage(named: "Complication/" + "Graphic Bezel")!,
    //        tintedImageProvider: imageProvider
    //    )
    //}

    //////////////////////////////////////////////////////////////////////////////////////////////////// Text

    func getTitleTextProvider() -> CLKSimpleTextProvider {
        return CLKSimpleTextProvider(text: "한통박스")
    }

    func getSalesTodaySumText() -> CLKSimpleTextProvider {
        
        if dataStore.unlockDate == nil {
            return CLKSimpleTextProvider(text: "Locked")
        }
        
        var sum: String = "--;"
        var time: String = ""
        
        if let date = dataStore.lastUpdateDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            time = "  \(formatter.string(from: date))"
        }
        
        sum = dataStore.todaySum?.decimalType() ?? ""

        // sum 값에서 뒤에 000 자리 빼고 표시
        if sum.count > 4 {
            let index = sum.index(sum.startIndex, offsetBy: sum.count - 5)
            return CLKSimpleTextProvider(text: "\(sum[...index]) \(time)")
        }
        
        return CLKSimpleTextProvider(text: "\(sum) \(time)")
    }
    
    func getSalesMonthSumText() -> CLKSimpleTextProvider {
        if dataStore.unlockDate == nil {
            return CLKSimpleTextProvider(text: "Locked")
        }
        
        var sum: String = "--;"
        var time: String = ""
        
        if let date = dataStore.serverUpdateDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            time = " Ξ \(formatter.string(from: date))"
        }

        sum = dataStore.thisMonthSum?.decimalType() ?? ""

        // sum 값에서 뒤에 000 자리 빼고 표시
        if sum.count > 4 {
            let index = sum.index(sum.startIndex, offsetBy: sum.count - 5)
            return CLKSimpleTextProvider(text: "\(sum[...index]) \(time)")
        }
        
        return CLKSimpleTextProvider(text: "\(sum) \(time)")
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////// Template

    func getTemplate(family: CLKComplicationFamily) -> CLKComplicationTemplate? {
        switch family {
        case .modularSmall:
            //debugPrint("modularSmall")
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            template.imageProvider = getImageProvider(complication: "Modular")
            return template

        case .modularLarge:
            //debugPrint("modularLarge")
            let template = CLKComplicationTemplateModularLargeTable()
            template.headerImageProvider = getImageProvider(complication: "Modular")
            template.headerTextProvider = getTitleTextProvider()
            template.row1Column1TextProvider = CLKSimpleTextProvider(text: "금일")
            template.row1Column2TextProvider = getSalesTodaySumText()
            template.row2Column1TextProvider = CLKSimpleTextProvider(text: "당월")
            template.row2Column2TextProvider = getSalesMonthSumText()
            template.column2Alignment = CLKComplicationColumnAlignment.trailing
            return template
            
        case .utilitarianSmall:
            //debugPrint("utilitarianSmall")
            let template = CLKComplicationTemplateUtilitarianSmallSquare()
            template.imageProvider = getImageProvider(complication: "Utilitarian")
            return template
            
        case .utilitarianLarge:
            //debugPrint("utilitarianLarge")
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.imageProvider = getImageProvider(complication: "Utilitarian")
            template.textProvider = getSalesTodaySumText()
            return template
            
        case .circularSmall:
            //debugPrint("circularSmall")
            let template = CLKComplicationTemplateCircularSmallSimpleImage()
            template.imageProvider = getImageProvider(complication: "Circular")
            return template
            
        case .extraLarge:
            //debugPrint("extraLarge")
            let template = CLKComplicationTemplateExtraLargeSimpleImage()
            template.imageProvider = getImageProvider(complication: "Extra Large")
            return template
                        
        case .graphicCorner:
            //debugPrint("graphicCorner")
            let template = CLKComplicationTemplateGraphicCornerTextImage()
            template.imageProvider = getFullColorImageProvider(complication: "Graphic Corner")
            template.textProvider = getSalesTodaySumText()
            return template
            
        case .graphicBezel:
            //debugPrint("graphicBezel")
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            let imageTemplate = CLKComplicationTemplateGraphicCircularImage()
            imageTemplate.imageProvider =
                //getGraphicBezelFullColorImageProvider()
                getFullColorImageProvider(complication: "Graphic Bezel")
            template.circularTemplate = CLKComplicationTemplateGraphicCircular()
            template.textProvider = getTitleTextProvider()
            return template
            
        case .graphicCircular:
            //debugPrint("graphicCircular")
            let template = CLKComplicationTemplateGraphicCircularImage()
            template.imageProvider = getFullColorImageProvider(complication: "Graphic Circular")
            return template
                        
        //case .graphicRectangular:
        //    let template = CLKComplicationTemplateGraphicRectangularTextGauge()
        //    template.headerImageProvider = getFullColorImageProvider(complication: "Graphic Large Rectangular")
        //    template.headerTextProvider = getTitleTextProvider()
        //    template.body1TextProvider = getSalesSumText(index: 0)
        //    return template
            
        default:
            return nil
        }
    }

    func getTestTemplate(family: CLKComplicationFamily) -> CLKComplicationTemplate? {
        switch family {
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerTextImage()
            template.imageProvider = getFullColorImageProvider(complication: "Graphic Corner")
            template.textProvider = CLKSimpleTextProvider(text: Date().display)
            return template
        default:
            return nil
        }
    }
}


