//
//  ReviewViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 17.05.17.
//
//

import UIKit

protocol ReviewViewControllerDelegate {
    
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
    @IBOutlet var previewImageView:UIImageView! = nil
    @IBOutlet var imageContainerScrollView:UIScrollView! = nil
    
    // constraints
    @IBOutlet var imageViewTopConstraint:NSLayoutConstraint! = nil
    @IBOutlet var imageViewBottomConstraint:NSLayoutConstraint! = nil
    @IBOutlet var imageViewLeftConstraint:NSLayoutConstraint! = nil
    @IBOutlet var imageViewRightConstraint:NSLayoutConstraint! = nil
    
    fileprivate var metaInformationManager: ImageMetaInformationManager? = nil
    
    var page:ScanPage? = nil {
        didSet {
            populateWith(page:page)
            if let data = page?.imageData {
                metaInformationManager = ImageMetaInformationManager(imageData:data)
            }
        }
    }

    var delegate:ReviewViewControllerDelegate? = nil
    
    @IBAction func useButtonTapped() {
        guard let image = metaInformationManager?.imageData() else {
            return
        }
        page?.imageData = image
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
        setupZooming()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScaleForSize(imageContainerScrollView.bounds.size)
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
    
    private func setupZooming() {
        imageContainerScrollView.delegate = self
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        imageContainerScrollView.addGestureRecognizer(doubleTapGesture)
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

// Zooming
extension ReviewViewController {
    
    @objc fileprivate func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if imageContainerScrollView.zoomScale > imageContainerScrollView.minimumZoomScale {
            imageContainerScrollView.setZoomScale(imageContainerScrollView.minimumZoomScale, animated: true)
        } else {
            imageContainerScrollView.setZoomScale(imageContainerScrollView.maximumZoomScale, animated: true)
        }
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        guard let image = previewImageView.image else { return }
        let widthScale = size.width / image.size.width
        let heightScale = size.height / image.size.height
        let minScale = min(widthScale, heightScale)
        imageContainerScrollView.minimumZoomScale = minScale
        imageContainerScrollView.zoomScale = minScale
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - previewImageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        let xOffset = max(0, (size.width - previewImageView.frame.width) / 2)
        imageViewLeftConstraint.constant = xOffset
        imageViewRightConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
}

extension ReviewViewController: UIScrollViewDelegate {
    
    /**
     Asks the delegate for the view to scale when zooming is about to occur in the scroll view.
     
     - parameter scrollView: The scroll view object displaying the content view.
     - returns: A `UIView` object that will be scaled as a result of the zooming gesture.
     */
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return previewImageView
    }
    
    /**
     Informs the delegate that the scroll view’s zoom factor has changed.
     
     - parameter scrollView: The scroll-view object whose zoom factor has changed.
     */
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.updateConstraintsForSize(scrollView.bounds.size)
        }
    }
    
}
