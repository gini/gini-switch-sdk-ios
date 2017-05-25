//
//  TariffAppearance.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 25.05.17.
//
//

import UIKit

// TODO: this is just an interface. It is not yet connected to the rest of the SDK and
// changes made here, will NOT apply!
/**
 * The TariffAppearance class contains resources, texts and colors used for customizing the
 * SDKs UI to match the hosting app it is used with.
 */
class TariffAppearance {
    
    /**
     * The positive color is a color that will show up at many places throughout the SDK.
     * It is used every time a component wants to indicate a succes or a positive state in
     * any way. For instance - a successful upload, analysis completion, correct extractions.
     */
    var positiveColor:UIColor? = nil
    
    /**
     * The positive color is a color that will show up at many places throughout the SDK.
     * It is used every time a component wants to indicate a failure or error state in
     * any way. For instance - a failed upload, incorrect extractions.
     */
    var negativeColor:UIColor? = nil
    
    /**
     * The background color most view controllers are going to use throughout the SDK.
     */
    var screenBackgroundColor:UIColor? = nil
    
    /**
     * Image for the Analysing Completed Screen.
     */
    var analyzedImage:UIImage? = nil
    
    /**
     * Text for the Analysing Completed Screen.
     */
    var analyzedText:String? = nil
    
    /**
     * Text color for the Analysing Completed Screen.
     */
    var analyzedTextColor:UIColor? = nil
    
    /**
     * Text size for the Analysing Completed Screen.
     */
    var analyzedTextSize:CGFloat? = nil
    
    /**
     * Use this to set a custom title for the cancel dialog.
     */
    var exitActionSheetTitle:String? = nil
    
    /**
     * Text for the button in the extractions screen
     */
    var extractionsButtonText:String? = nil
    
    /**
     * The background for text fields used in the extractions screen
     */
    var extractionsTextFieldBackgroundColor:UIColor? = nil
    
    /**
     * The text color used for text fields in the extractions screen
     */
    var extractionsTextFieldTextColor:UIColor? = nil
    
    /**
     * The color used for the borders if the text fields in the extractions screen
     */
    var extractionsTextFieldBorderColor:UIColor? = nil
    
    /**
     * The text color used for the labels that appear above each text field in the extractions
     * screen indicating the extracted field's name
     */
    var extractionTitleTextColor:UIColor? = nil
    
    /**
     * The text showing on top of the extractions table in the extractions screen.
     * @note The title doesn't appear in a navigation bar so it can be longer - even several lines
     */
    var extractionsScreenTitleText:String? = nil
    
    init () {
        
    }

}
