//
//  ImageViewController.swift
//  TestFlickr
//
//  Created by Ihar Moroz on 8.06.21.
//

import UIKit
import MBProgressHUD

class ImageViewController: UIViewController {
    var currentPage: Int = 1
    let presenter = ImageViewPresenter()
    var hasMore: Bool = true
    
    private var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: view, animated: true)
        presenter.getPhotos { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)

            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        setupCollectionViewLayout()
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        updateCollectionViewItemSize()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      coordinator.animate(alongsideTransition: { (_) in
        self.updateCollectionViewItemSize()
      }, completion: nil)
      super.viewWillTransition(to: size, with: coordinator)
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoViewController = segue.destination as? PhotoViewController,
            let indexPath = collectionView.indexPathsForSelectedItems?.first {
            photoViewController.photo = presenter.photos[indexPath.row]
        }
    }
    
    private func setupCollectionViewLayout() {
      collectionViewFlowLayout = UICollectionViewFlowLayout()
      collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
    }
    
    private func updateCollectionViewItemSize() {
        let width = collectionView.frame.width
        let height = width
        
        collectionView.isPagingEnabled = true
        
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (presenter.photos.count - 1), hasMore {
            currentPage += 1
            searchMorePhotos(completion: nil)
        }
    }
    func searchMorePhotos(completion: ((_ success: Bool) -> Void)?) -> Void {
        presenter.getPhotos(page: currentPage, searchText: searchBar.text, completion: { [weak self] photos in
            guard let self = self else { return }
            self.hasMore = !photos.isEmpty
            let newCount = self.presenter.photos.count
            let prevCount = newCount - photos.count
            self.insertPhotos(at: prevCount, count: photos.count)
            
            completion?(true)
        })
    }
    func insertPhotos(at index: Int, count: Int)  {
        guard count > 0 else { return }
        let indicies = Array(index ..< index + count)
        let indexPaths = indicies.compactMap({ IndexPath(item: $0, section: 0) })
        collectionView?.insertItems(at: indexPaths)
        
    }
}
//MARK: - Empty Message Extension
extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}

//MARK: - CollectionViewDataSource, CollectionViewDelegate
extension ImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.presenter.photos.isEmpty {
            self.collectionView.setEmptyMessage("Nothing to show :(")
        } else {
            self.collectionView.restore()
        }
        return self.presenter.photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = presenter.photos[indexPath.row]
        cell.imageURL = photo.imageURL
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? PhotoCell
        cell?.cancelImageLoading()
    }
}

// MARK: - SearchBar
extension ImageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentPage = 1
        presenter.getPhotos(page: currentPage, searchText: searchBar.text, completion: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(at:IndexPath(item: 0, section: 0), at: .right, animated: false)
            }
        })
    }
}
