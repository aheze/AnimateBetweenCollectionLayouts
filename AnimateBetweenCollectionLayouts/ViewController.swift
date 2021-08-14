//
//  ViewController.swift
//  AnimateBetweenCollectionLayouts
//
//  Created by Zheng on 6/20/21.
//

import UIKit

class ViewController: UIViewController {

    var isExpanded = false
    lazy var listLayout = FlowLayout(layoutType: .list)
    lazy var stripLayout = FlowLayout(layoutType: .strip)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBAction func toggleExpandPressed(_ sender: Any) {
        
        print("contentOffset before setting layout: \(collectionView.contentOffset)")
        
        isExpanded.toggle()
        if isExpanded {
            collectionView.setCollectionViewLayout(listLayout, animated: true)
            collectionViewHeightConstraint.constant = 300
        } else {
            collectionView.setCollectionViewLayout(stripLayout, animated: true)
            collectionViewHeightConstraint.constant = 60
        }
        UIView.animate(withDuration: 0.6, delay: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = stripLayout
        collectionView.dataSource = self
        
        /// use these instead of `UICollectionViewDelegateFlowLayout`
        listLayout.sizeForListItemAt = { [weak self] indexPath in
            return CGSize(width: self?.collectionView.frame.width ?? 100, height: 50)
        }
        stripLayout.sizeForStripItemAt = { indexPath in
            return CGSize(width: 100, height: 50)
        }
    }
}

/// sample data source
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ID", for: indexPath)
        cell.contentView.layer.borderWidth = 5
        cell.contentView.layer.borderColor = UIColor.red.cgColor
        return cell
    }
}

