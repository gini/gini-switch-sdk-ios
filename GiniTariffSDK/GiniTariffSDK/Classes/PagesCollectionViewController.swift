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
        }
    }
    
    var pages:PageCollection? = PageCollection()
    weak var delegate:PagesCollectionViewControllerDelegate? = nil
    
    @IBAction func onOptionsTapped() {
        self.delegate?.pageCollectionControllerDidRequestOptions(self)
    }

}

extension PagesCollectionViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return pages?.count ?? 0
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
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // one for the actual pages and one for the add page button
        return 2
    }
    
    private func setupPageCell(_ cell:PageCollectionViewCell, index:Int) {
        cell.page = self.pages?.pages[index]
    }
    
    private func setupAddCell(_ cell:PageCollectionViewCell) {
        cell.pagePreview.image = nil
        cell.pageStatusUnderlineView.image = nil
        cell.pageStatusUnderlineView.backgroundColor = UIColor.clear
        cell.addPageLabel.isHidden = false
    }
    
}

extension PagesCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            // a page has been selected
            if let selectedPage = self.pages?.pages[indexPath.row] {
                self.delegate?.pageCollectionController(self, didSelectPage: selectedPage)
            }
        case 1:
            // the add page button is selected
            self.delegate?.pageCollectionControllerDidRequestAddPage(self)
            break
        default: break
            
        }
    }
}
