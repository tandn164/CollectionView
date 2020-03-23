//
//  ViewController.swift
//  CollectionView
//
//  Created by Nguyễn Đức Tân on 3/23/20.
//  Copyright © 2020 Nguyễn Đức Tân. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "FlickrCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var searches: [FlickrSearchResults] = []
    private let flickr = Flickr()
    private let itemsPerRow: CGFloat = 3
    @IBOutlet weak var SearchField: UITextField!
    @IBOutlet weak var SearchButton: UIBarButtonItem!
    @IBOutlet weak var ViewFlowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchField.delegate = self
        collectionView.delegate = self
    }
}
// MARK: - Private
private extension CollectionViewController{
    func photo(for indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
}

// MARK: - Text Field Delegate
extension CollectionViewController : UITextFieldDelegate {
    @IBAction func ButtonPressed(_ sender: Any) {
        SearchField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchField.endEditing(true)
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {
            return true
        }
        else{
            SearchField.placeholder = "Type something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil{
            print("Here")
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            textField.addSubview(activityIndicator)
            activityIndicator.frame = textField.bounds
            activityIndicator.startAnimating()

            flickr.searchFlickr(for: textField.text!) { searchResults in
                activityIndicator.removeFromSuperview()

                switch searchResults {
                case .error(let error) :
                    print("Error Searching: \(error)")
                case .results(let results):
                    print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                    self.searches.insert(results, at: 0)

                
                    self.collectionView?.reloadData()
                }
            }

            textField.text = nil
            textField.resignFirstResponder()
        }
        SearchField.text = ""
    }

    
}

// MARK: - UICollectionViewDataSource
extension CollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! FlickrPhotoCell
        let flickrPhoto = photo(for: indexPath)
        cell.backgroundColor = .white
        cell.ImageView.image = flickrPhoto.thumbnail
        
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


