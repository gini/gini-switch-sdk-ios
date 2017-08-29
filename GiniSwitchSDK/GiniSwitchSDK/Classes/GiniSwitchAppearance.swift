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
     * It is used at times where an element branded with the main color of your app is appropriate
     * For instance, for Gini, it would be the blue color we use for our logo
     */
    static public var primaryColor:UIColor? = UIColor(red: 22.0 / 255.0, green: 157.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
    
    /**
     * The positive color is a color that will show up at many places throughout the SDK.
     * It is used every time a component wants to indicate a success or a positive state in
     * any way. For instance - a successful upload, analysis completion, correct extractions.
     */
    static public var positiveColor:UIColor? = UIColor(red: 32.0 / 255.0, green: 186.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0)
    
    /**
     * The positive color is a color that will show up at many places throughout the SDK.
     * It is used every time a component wants to indicate a failure or error state in
     * any way. For instance - a failed upload, incorrect extractions.
     */
    static public var negativeColor:UIColor? = UIColor(red: 204.0 / 255.0, green: 33.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    
    /**
     * The background color most view controllers are going to use throughout the SDK.
     */
    static public var screenBackgroundColor:UIColor? = UIColor.black {
        didSet {
            guard let color = screenBackgroundColor else {
                return
            }
            SwitchBackgroundView.appearance().backgroundColor = color
        }
    }
    
    /**
     * Text for the Done button in the camera screen
     */
    static public var doneButtonText:String? = NSLocalizedString("Fertig", comment: "Camera screen done button text")
    
    /**
     * Text color for the Done button in the camera screen.
     */
    static public var doneButtonTextColor:UIColor? = UIColor(red: 22.0 / 255.0, green: 157.0 / 255.0, blue: 217.0 / 255.0, alpha: 1.0)
    
    /**
     * Text for the Preview screen - a successfully processed image.
     */
    static public var imageProcessedText:String? = NSLocalizedString("Sehr gut, wir könnten alle Daten aus diesem Foto erfolgreich analysieren.", comment: "Preview screen title - analyzed document")
    
    /**
     * Text for the Preview screen - a failed processing of the image.
     */
    static public var imageProcessFailedText:String? = NSLocalizedString("Leider ist die Qualität dieser Seite nicht ausreichend. Bitte fotografiere diese Seite nochmal neu.", comment: "Preview screen title - failed document")
    
    /**
     * Image for the Analysing Completed Screen.
     */
    static public var analyzedImage:UIImage? = nil
    
    /**
     * Text for the Analysing Completed Screen.
     */
    static public var analyzedText:String? = NSLocalizedString("Wir haben Alles was wir für deinen Strom Anbieter Wechseln benötigen.", comment: "Text for the Analysing Completed Screen")
    
    /**
     * Text color for the Analysing Completed Screen.
     */
    static public var analyzedTextColor:UIColor? = UIColor.white
    
    /**
     * Text size for the Analysing Completed Screen.
     */
    static public var analyzedTextSize:CGFloat? = 21.0
    
    /**
     * Use this to set a custom title for the cancel dialog.
     */
    static public var exitActionSheetTitle:String? = NSLocalizedString("Foto-Modus verlassen?", comment: "Leave SDK actionsheet title")
    
    public init () {
        
    }

}
