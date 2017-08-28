//
//  PagesCollectionViewController.swift
//  Gini Switch SDK
//
//  Created by Gini GmbH on 11.05.17.
//
//

import UIKit

protocol PagesCollectionViewControllerDelegate:class {
    
    func pageCollectionControllerDidRequestOptions(_ pageController:PagesCollectionViewController)
    func pageCollectionControllerDidRequestAddPage(_ pageController:PagesCollectionViewController)
    func pageCollectionController(_ pageController:PagesCollectionViewController, didSelectPage:ScanPage)
    
}

class PagesCollectionViewController: UIViewController {
    
    @IBOutlet var optionsButton:UIButton! = nil
    @IBOutlet var pagesCollection:UICollectionView? = nil {
        didSet {
            pagesCollection?.delegate = self
            pagesCollection?.dataSource = self
            (pagesCollection?.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing = 5.0
            setupContentInsets()
        }
    }
    
    var pages:PageCollection = PageCollection() {
        didSet {
            setupContentInsets()
            scrollToSeletedCell()
        }
    }
    var selectedIndexPath = IndexPath(row: 0, section: 1)   // the add page cell
    
    var shouldShowAddIcon = false
    var themeColor:UIColor?
    weak var delegate:PagesCollectionViewControllerDelegate? = nil
    
    @IBAction func onOptionsTapped() {
        self.delegate?.pageCollectionControllerDidRequestOptions(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOptionsButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupContentInsets()
    }
    
    fileprivate func setupOptionsButton() {
        // change the color of the button's image to make it reflect the
        // app's theme
        guard let buttonImage = optionsButton.image(for: .normal) else {
            Logger().logError(message: "Options button didn't have an image")
            return
        }
        optionsButton.setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .normal)
        optionsButton.tintColor = themeColor
    }

}

extension PagesCollectionViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return pages.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionViewCell", for: indexPath) as! PageCollectionViewCell
        switch indexPath.section {
        case 0:
            // page cell
            setupPageCell(cell, index:indexPath.row)
        case 1:
            // add picture button
            setupAddCell(cell)
        default:
            assert(false, "Unknown section encountered \(indexPath.section)")
        }
        if let themeColor = themeColor {
            cell.pageSelectionColor = themeColor
        }
        cell.isSelected = (indexPath == selectedIndexPath)
        cell.pageNumber = pageNumberFor(indexPath:indexPath)
        
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // one for the actual pages and one for the add page button
        return 2
    }
    
    fileprivate func setupPageCell(_ cell:PageCollectionViewCell, index:Int) {
        cell.page = self.pages.pages[index]
    }
    
    fileprivate func setupAddCell(_ cell:PageCollectionViewCell) {
        cell.setupForAddButton()
        cell.shouldShowPlus = shouldShowAddIcon
    }
    
    fileprivate func pageNumberFor(indexPath:IndexPath) -> UInt? {
        switch indexPath.section {
        case 0:
            return UInt(indexPath.row + NSInteger(1))
        case 1:
            return UInt(pages.count + 1)
        default:
            return nil
        }
    }
    
}

extension PagesCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        scrollToSeletedCell()
        
        switch indexPath.section {
        case 0:
            // a page has been selected
            self.delegate?.pageCollectionController(self, didSelectPage: self.pages.pages[indexPath.row])
        case 1:
            // the add page button is selected
            self.delegate?.pageCollectionControllerDidRequestAddPage(self)
            break
        default: break
            
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate == false else {
            // if the scroll view is still decelerating, the scrollViewDidEndDecelerating will
            // handle the snapping at the end
            return
        }
        snapToClosestCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToClosestCell()
    }
}

// Scrolling positions
extension PagesCollectionViewController {
    
    fileprivate func setupContentInsets() {
        guard let layout = pagesCollection?.collectionViewLayout as? UICollectionViewFlowLayout else {
            assertionFailure("The page collection view controller's layout needs to be a UICollectionViewFlowLayout")
            return
        }
        
        // the width taken by just one page (including spacings)
        let onePageWidth = (layout.itemSize.width + layout.minimumInteritemSpacing)
        
        // the width taken by all pages (including the static add page cell)
        let pageWidth = onePageWidth * CGFloat(pages.count + 1)
        
        // Inset to the left so that if there are 1-2 pages, they start from the center, but if there's
        // more pages than can be fitten in half the view (negative inset), allow them to disappear
        // to the left
        let leftInset = max(0, pagesCollection!.frame.width / 2.0 - (pageWidth - (onePageWidth / 2.0)))
        
        // The right inset of always enough to let the last cell float to the center of the view
        let rightInset = pagesCollection!.frame.width / 2.0 - onePageWidth / 2.0
        pagesCollection?.contentInset = UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
    
    fileprivate func scrollToSeletedCell() {
        if let collectionView = pagesCollection,
            let cell = collectionView.cellForItem(at: selectedIndexPath) {
            let offset = cell.center.x - collectionView.frame.width / 2.0
            collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    fileprivate func scrollTo(cell:UICollectionViewCell) {
        if let collectionView = pagesCollection {
            let offset = cell.center.x - collectionView.frame.width / 2.0
            collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    fileprivate func snapToClosestCell() {
        guard let collectionView = pagesCollection else {
            return
        }
        let cells = collectionView.visibleCells
        var minDistance = collectionView.contentSize.width
        let closestCell = cells.reduce(nil, { (closestCell, currentCell) -> UICollectionViewCell? in
            
            let cellCenter = currentCell.convert(CGPoint(x:currentCell.frame.width / 2.0, y:currentCell.frame.height / 2.0), to: self.view).x
            let deltaDistance = abs((cellCenter - (collectionView.frame.width / 2.0)))
            if deltaDistance < minDistance {
                minDistance = deltaDistance
                return currentCell
            }
            else {
                return closestCell
            }
        })
        guard let targetCell = closestCell else {
            return
        }
        scrollTo(cell: targetCell)
    }
}
