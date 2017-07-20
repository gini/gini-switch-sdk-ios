//
//  GiniSwitchAppearance.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 25.05.17.
//
//

import UIKit

// TODO: this is just an interface. It is not yet connected to the rest of the SDK and
// changes made here, will NOT apply!
/**
 * The GiniSwitchAppearance class contains resources, texts and colors used for customizing the
 * SDKs UI to match the hosting app it is used with.
 */
public class GiniSwitchAppearance {
    
    /**
     * The primary color is a color that will show up at many places throughout the SDK.
     * It is used at times where an element branded with the main color of your app is approapriate
     * For instance, for Gini, it would be the blue color we use for our logo
     */
    public var primaryColor:UIColor? = UIColor(colorLiteralRed: 22.0 / 255.0, green: 157.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
    
    /**
     * The positive color is a color that will show up at many places throughout the SDK.
     * It is used every time a component wants to indicate a success or a positive state in
     * any way. For instance - a successful upload, analysis completion, correct extractions.
     */
    public var positiveColor:UIColor? = UIColor(colorLiteralRed: 32.0 / 255.0, green: 186.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)
    
    /**
     * The positive color is a color that will show up at many places throughout the SDK.
     * It is used every time a component wants to indicate a failure or error state in
     * any way. For instance - a failed upload, incorrect extractions.
     */
    public var negativeColor:UIColor? = UIColor(colorLiteralRed: 204.0 / 255.0, green: 33.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    
    /**
     * The background color most view controllers are going to use throughout the SDK.
     */
    public var screenBackgroundColor:UIColor? = UIColor.black {
        didSet {
            guard let color = screenBackgroundColor else {
                return
            }
            SwitchBackgroundView.appearance().backgroundColor = color
        }
    }
    
    /**
     * Image used for marking successfully analysed images.
     */
    public var pageAnalysisSuccessImage:UIImage? = nil
    
    /**
     * Image used for marking images that couldn't be analysed.
     */
    public var pageAnalysisFailureImage:UIImage? = nil
    
    /**
     * Text for the Done button in the camera screen
     */
    public var doneButtonText:String? = NSLocalizedString("Fertig", comment: "Camera screen done button text")
    
    /**
     * Text color for the Done button in the camera screen.
     */
    public var doneButtonTextColor:UIColor? = UIColor(colorLiteralRed: 22.0 / 255.0, green: 157.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
    
    /**
     * Text for the Preview screen - a successfully processed image.
     */
    public var imageProcessedText:String? = NSLocalizedString("Sehr gut, wir könnten alle Daten aus diesem Foto erfolgreich analysieren.", comment: "Preview screen title - analysed document")
    
    /**
     * Text for the Preview screen - a failed processing of the image.
     */
    public var imageProcessFailedText:String? = NSLocalizedString("Leider ist die Qualität dieser Seite nicht ausreichend. Bitte fotografiere diese Seite nochmal neu.", comment: "Preview screen title - failed document")
    
    /**
     * Image for the Analysing Completed Screen.
     */
    public var analyzedImage:UIImage? = nil
    
    /**
     * Text for the Analysing Completed Screen.
     */
    public var analyzedText:String? = NSLocalizedString("Wir haben Alles was wir für deinen Strom Anbieter Wechseln benötigen.", comment: "Text for the Analysing Completed Screen")
    
    /**
     * Text color for the Analysing Completed Screen.
     */
    public var analyzedTextColor:UIColor? = UIColor.white
    
    /**
     * Text size for the Analysing Completed Screen.
     */
    public var analyzedTextSize:CGFloat? = 21.0
    
    /**
     * Use this to set a custom title for the cancel dialog.
     */
    public var exitActionSheetTitle:String? = NSLocalizedString("Foto-Modus verlassen?", comment: "Leave SDK actionsheet title")
    
    public init () {
        
    }

}
