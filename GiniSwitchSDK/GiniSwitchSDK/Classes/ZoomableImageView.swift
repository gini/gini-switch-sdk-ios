//
//  ZoomableImageView.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 30.08.17.
//
//

import UIKit

class ZoomableImageView: UIScrollView {
    
    var imageView:UIImageView! = nil
    var image:UIImage? = nil {
        didSet {
            guard imageView != nil else {
                return
            }
            imageView?.image = image
        }
    }
    
    // constraints
    var imageViewTopConstraint:NSLayoutConstraint! = nil
    var imageViewBottomConstraint:NSLayoutConstraint! = nil
    var imageViewLeftConstraint:NSLayoutConstraint! = nil
    var imageViewRightConstraint:NSLayoutConstraint! = nil
    
    override func awakeFromNib() {
        addImageView()
        setupZooming()
    }
    
    fileprivate func addImageView() {
        self.contentSize = bounds.size
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.image = image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewTopConstraint = NSLayoutConstraint(item: imageView,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .top,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        imageViewBottomConstraint = NSLayoutConstraint(item: imageView,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .bottom,
                                                       multiplier: 1.0,
                                                       constant: 0.0)
        imageViewRightConstraint = NSLayoutConstraint(item: imageView,
                                                      attribute: .left,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .left,
                                                      multiplier: 1.0,
                                                      constant: 0.0)
        imageViewLeftConstraint = NSLayoutConstraint(item: imageView,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: self,
                                                     attribute: .right,
                                                     multiplier: 1.0,
                                                     constant: 0.0)
        imageViewTopConstraint.isActive = true
        imageViewBottomConstraint.isActive = true
        imageViewRightConstraint.isActive = true
        imageViewLeftConstraint.isActive = true
        layoutIfNeeded()
    }
    
    fileprivate func setupZooming() {
        delegate = self
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }

}

// Zooming
extension ZoomableImageView {
    
    @objc fileprivate func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if zoomScale > minimumZoomScale {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            setZoomScale(maximumZoomScale, animated: true)
        }
    }
    
    func updateMinZoomScaleForSize(_ size: CGSize) {
        guard let view = imageView,
            let image = view.image else {
                return
        }
        let widthScale = size.width / image.size.width
        let heightScale = size.height / image.size.height
        let minScale = min(widthScale, heightScale)
        minimumZoomScale = minScale
        zoomScale = minScale
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeftConstraint.constant = xOffset
        imageViewRightConstraint.constant = xOffset
        
        layoutIfNeeded()
    }
    
}

extension ZoomableImageView: UIScrollViewDelegate {
    
    /**
     Asks the delegate for the view to scale when zooming is about to occur in the scroll view.
     
     - parameter scrollView: The scroll view object displaying the content view.
     - returns: A `UIView` object that will be scaled as a result of the zooming gesture.
     */
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
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
