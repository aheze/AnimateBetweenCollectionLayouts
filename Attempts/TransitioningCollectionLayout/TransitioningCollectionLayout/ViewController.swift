//
//  ViewController.swift
//  TransitioningCollectionLayout
//
//  Created by Zheng on 6/20/21.
//

import UIKit

class ViewController: UIViewController {

    var isExpanded = false
    var verticalFlowLayout = UICollectionViewFlowLayout()
    var horizontalFlowLayout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBAction func toggleExpandPressed(_ sender: Any) {
        
        isExpanded.toggle()
        if isExpanded {
            collectionView.setCollectionViewLayout(verticalFlowLayout, animated: true) /// set vertical scroll
            collectionViewHeightConstraint.constant = 300 /// make collection view height taller
        } else {
            collectionView.setCollectionViewLayout(horizontalFlowLayout, animated: true) /// set horizontal scroll
            collectionViewHeightConstraint.constant = 50 /// make collection view height shorter
        }
        
        /// animate the collection view's height
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        
        /// Bonus points:
        /// This makes the animation way more worse, but I would like to be able to scroll to a specific IndexPath during the transition.
        //  collectionView.scrollToItem(at: IndexPath(item: 9, section: 0), at: .bottom, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verticalFlowLayout.scrollDirection = .vertical
        horizontalFlowLayout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = horizontalFlowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        /// if expanded, cells should be full-width
        /// if not expanded, cells should have a width of 50
        return isExpanded ? CGSize(width: collectionView.frame.width, height: 50) : CGSize(width: 100, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 /// no spacing needed for now
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

