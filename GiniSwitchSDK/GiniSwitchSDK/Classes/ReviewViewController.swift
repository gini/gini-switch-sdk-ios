//
//  ReviewViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 17.05.17.
//
//

import UIKit

protocol ReviewViewControllerDelegate:class {
    
    func reviewController(_ controller:ReviewViewController, didAcceptPage page:ScanPage)
    func reviewController(_ controller:ReviewViewController, didRejectPage page:ScanPage)
    func reviewControllerDidRequestOptions(_ controller:ReviewViewController)
    
}

class ReviewViewController: UIViewController {
    
    @IBOutlet var useButton:UIButton! = nil
    @IBOutlet var retakeButton:UIButton! = nil
    @IBOutlet var rotateButton:UIButton! = nil
    @IBOutlet var hintLabel:UILabel! = nil
    @IBOutlet var moreButton:UIButton! = nil
    @IBOutlet var previewImageView:ZoomableImageView! = nil
    
    fileprivate var metaInformationManager: ImageMetaInformationManager? = nil
    
    var page:ScanPage? = nil {
        didSet {
            populateWith(page:page)
            if let data = page?.imageData {
                metaInformationManager = ImageMetaInformationManager(imageData:data)
            }
        }
    }
    
    var confirmColor:UIColor? = nil
    var denyColor:UIColor? = nil

    weak var delegate:ReviewViewControllerDelegate? = nil
    
    @IBAction func useButtonTapped() {
        delegate?.reviewController(self, didAcceptPage: page!)
    }
    
    @IBAction func rejectButtonTapped() {
        delegate?.reviewController(self, didRejectPage: page!)
    }
    
    @IBAction func rotateTapped() {
        rotate()
    }
    
    @IBAction func optionsTapped() {
        delegate?.reviewControllerDidRequestOptions(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRotateButtonRound()
        populateWith(page: self.page)
        setupButtonColors()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewImageView.updateMinZoomScaleForSize(previewImageView.bounds.size)
    }
    
    override var prefersStatusBarHidden:Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func populateWith(page:ScanPage?) {
        guard let data = page?.imageData,
        let preview = previewImageView,
        let _ = view /* just to make sure the view is loaded */ else { return }
        preview.image = UIImage(data: data)
    }

    private func makeRotateButtonRound() {
        rotateButton.layer.cornerRadius = rotateButton.frame.size.width / 2.0
    }
    
    private func setupButtonColors() {
        if let confirmColor = confirmColor {
            useButton.backgroundColor = confirmColor
        }
        if let denyColor = denyColor {
            retakeButton.backgroundColor = denyColor
        }
    }
}

// Rotation
extension ReviewViewController {
    
    fileprivate func rotate() {
        guard let rotatedImage = rotateImage(previewImageView.image) else { return }
        previewImageView.image = rotatedImage
        guard let metaInformationManager = metaInformationManager else { return }
        metaInformationManager.rotate(degrees: 90, imageOrientation: rotatedImage.imageOrientation)
        guard let data = metaInformationManager.imageData() else { return }
        page?.imageData = data
    }
    
    fileprivate func rotateImage(_ image: UIImage?) -> UIImage? {
        guard let cgImage = image?.cgImage else { return nil }
        let rotatedOrientation = nextImageOrientationClockwise(image!.imageOrientation)
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: rotatedOrientation)
    }
    
    fileprivate func nextImageOrientationClockwise(_ orientation: UIImageOrientation) -> UIImageOrientation {
        var nextOrientation: UIImageOrientation!
        switch orientation {
        case .up, .upMirrored:
            nextOrientation = .right
        case .down, .downMirrored:
            nextOrientation = .left
        case .left, .leftMirrored:
            nextOrientation = .up
        case .right, .rightMirrored:
            nextOrientation = .down
        }
        return nextOrientation
    }
}
