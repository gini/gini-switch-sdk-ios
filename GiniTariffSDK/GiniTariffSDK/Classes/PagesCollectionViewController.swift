//
//  PagesCollectionViewController.swift
//  Pods
//
//  Created by Nikola Sobadjiev on 11.05.17.
//
//

import UIKit

class PagesCollectionViewController: UIViewController {
    
    @IBOutlet var optionsButton:UIButton! = nil
    @IBOutlet var pagesCollection:UICollectionView! = nil {
        didSet {
            pagesCollection.delegate = self
            pagesCollection.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PagesCollectionViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionViewCell", for: indexPath)
        // TODO: configure
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension PagesCollectionViewController: UICollectionViewDelegate {
    
}
