//
//  SearchViewController.swift
//
//  FlickrSearch
//
//  A lightweight View Controller that manages its views and thats all.
//
//  Created by jonathan ide on 21/8/21.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class SearchViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    /// Views managed by VC
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinnerView: UIView!
  
    var images = [ImageSearchResult]()

    /// Required for Protocol Conformance
    var viewModel: SearchViewModelProtocol?
    var coordinator: CoordinatorProtocol?
    let reuseIdentifier = "FlickrCell"

    /// Dispose of Subscriptions
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// bind in VM
        self.navigationController?.navigationBar.topItem?.title = "Flickr Search"
        
        /// Register a Collection View Cell and Set the Rx delegate
        self.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        /// View Model is loaded when View Controller is instantiated
        if let viewModel = self.viewModel {

            /// Hide Spinner
            _ = viewModel.searchSpinnerViewBS.bind(to: self.spinnerView.rx.isHidden)

            /// Fire a search request when user hits search button
            let searchEventObs = searchBar.rx.searchButtonClicked.asObservable()
            let searchTermObs  = searchBar.rx.text.asObservable()
            _ = searchEventObs.withLatestFrom(searchTermObs).subscribe { [weak self] evt in
                if let term = evt.element {

                    /// Check Term is "valid" i.e. has content
                    if !(viewModel.searchTermValidation(term: term!)) {
                        return
                    }
                    /// Binding sets the datasource directly so we only want this done once per search
                    self?.collectionView.dataSource = nil

                    /// Show spinner - not very obvious - could change to enum & convert to bool
                    /// binds BS direct to isHidden propertty of the UIView displaying the spinner
                    viewModel.searchSpinnerViewBS.onNext(false)
                    
                    /// Concise way of binding UICollectionView to its DataSource (as an Observable)
                    /// which is returned by the Search. This may seem a bit obfuscated but it eliminates
                    /// a lot of boiler plate code.
                    _ = viewModel.search(for: term!).bind(to: (self?.collectionView.rx.items(cellIdentifier: self!.reuseIdentifier))!) { _, imageSearchResult, cell in
                        if let imageView = imageSearchResult.image {
                            ///
                            cell.contentView.addSubview(imageView)
                            cell.contentView.backgroundColor = .white
                            ///
                            imageView.contentMode = .scaleAspectFit
                            imageView.translatesAutoresizingMaskIntoConstraints = false
                            imageView.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 0).isActive = true
                            imageView.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 0).isActive = true
                            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0).isActive = true
                            imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0).isActive = true
                        }
                    }
                    /// Cancel the Keyboard
                    self?.searchBar.resignFirstResponder()
                }

            }.disposed(by: disposeBag)

        }

    }

    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    let itemsPerRow = CGFloat(4)

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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let view = self.collectionView else {
            return
        }
        view.collectionViewLayout.invalidateLayout()
    }

}
