//
//  TariffAppearance.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 25.05.17.
//
//

import UIKit

// TODO: this is just an interface. It is not yet connected to the rest of the SDK and
// changes made here, will NOT apply!
/**
 * The TariffAppearance class contains resources, texts and colors used for customizing the
 * SDKs UI to match the hosting app it is used with.
 */
public class TariffAppearance {
    
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
            TariffBackgroundView.appearance().backgroundColor = color
        }
    }
    
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
    public var exitActionSheetTitle:String? = NSLocalizedString("Gini Switch verlassen", comment: "Leave SDK actionsheet title")
    
    /**
     * Text for the button in the extractions screen
     */
    public var extractionsButtonText:String? = NSLocalizedString("Jetzt Stromanbieter wechseln", comment: "Extraction screen switch provider title")
    
    /**
     * The background for text fields used in the extractions screen
     */
    public var extractionsTextFieldBackgroundColor:UIColor? = UIColor.gray
    
    /**
     * The text color used for text fields in the extractions screen
     */
    public var extractionsTextFieldTextColor:UIColor? = UIColor.white
    
    /**
     * The color used for the borders if the text fields in the extractions screen
     */
    public var extractionsTextFieldBorderColor:UIColor? = nil
    
    /**
     * The text color used for the labels that appear above each text field in the extractions
     * screen indicating the extracted field's name
     */
    public var extractionTitleTextColor:UIColor? = UIColor.white
    
    /**
     * The text showing on top of the extractions table in the extractions screen.
     * @note The title doesn't appear in a navigation bar so it can be longer - even several lines
     */
    public var extractionsScreenTitleText:String? = NSLocalizedString("Fast geschafft. Bitte prüfe noch kurz ob alle Deine Daten korrekt ausgelesen wurden.", comment: "Extraction screen title")
    
    public init () {
        
    }

}
