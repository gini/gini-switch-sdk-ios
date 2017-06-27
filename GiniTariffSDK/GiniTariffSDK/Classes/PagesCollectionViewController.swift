//
//  PagesCollectionViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 11.05.17.
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
        }
    }
    var selectedIndexPath = IndexPath(row: 0, section: 1)   // the add page cell
    
    var shouldShowAddIcon = false
    weak var delegate:PagesCollectionViewControllerDelegate? = nil
    
    @IBAction func onOptionsTapped() {
        self.delegate?.pageCollectionControllerDidRequestOptions(self)
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
        cell.isSelected = (indexPath == selectedIndexPath)
        
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // one for the actual pages and one for the add page button
        return 2
    }
    
    private func setupPageCell(_ cell:PageCollectionViewCell, index:Int) {
        cell.page = self.pages.pages[index]
    }
    
    private func setupAddCell(_ cell:PageCollectionViewCell) {
        cell.pagePreview.image = nil
        cell.pageStatusUnderlineView.image = nil
        cell.pageStatusUnderlineView.backgroundColor = UIColor.clear
        cell.pageStatusView.image = nil
        cell.addPageLabel.isHidden = !shouldShowAddIcon
    }
    
}

extension PagesCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // move the element to the center
        if let cell = collectionView.cellForItem(at: indexPath) {
            let offset = cell.center.x - collectionView.frame.width / 2.0
            collectionView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
        
        selectedIndexPath = indexPath
        
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
}

// Content insets
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
}
