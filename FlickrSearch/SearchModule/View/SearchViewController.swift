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
    /// View Model & Coordinator  are loaded when View Controller is instantiated
    var viewModel: SearchViewModelProtocol?
    var coordinator: CoordinatorProtocol?
    
    /// Local constants used to manage the view's appearance - its possible the itemsPerRow may be changed by a user
    /// but this is not a requirement as such so its a constant.
    private let reuseIdentifier = "FlickrCell"
    private let controllerTitle = "Flickr Search"
    private let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    private var itemsPerRow: CGFloat = CGFloat(4)
    
    /// Dispose of Subscriptions
    var disposeBag = DisposeBag()
    ///
    var page: Int = 1
    var term: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set Title - NB see coment below - this is not part of DI as a shortcut.
        setControllerTitle(title: controllerTitle)
        
        /// Register a Collection View Cell and Set the Rx delegate
        self.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        /// Fire a search request when user hits search button
        let searchEventObs = searchBar.rx.searchButtonClicked.asObservable()
        let searchTermObs  = searchBar.rx.text.asObservable()
        _ = searchEventObs.withLatestFrom(searchTermObs).subscribe { [weak self] evt in
            if let term = evt.element, let page = self?.page {
                self?.term = term
                self?.search(term: term!, page: page)
            }
        }.disposed(by: disposeBag)
  
    }
    /// Main Search Function
    func search(term: String, page: Int) {
        
        print("Search: \(term) Page: \(page)")
        
        if let viewModel = self.viewModel {
            
            /// Hide Spinner
            _ = viewModel.searchSpinnerViewBS.bind(to: self.spinnerView.rx.isHidden)
            
            /// Check Term is "valid" i.e. has content
            if !(viewModel.searchTermValidation(term: term)) {
                return
            }
            /// Binding sets the datasource directly so we only want this done once per search
            self.collectionView.dataSource = nil
            
            /// Show spinner - not very obvious - could change to enum & convert to bool
            /// binds BS direct to isHidden propertty of the UIView displaying the spinner
            viewModel.searchSpinnerViewBS.onNext(false)
            
            /// Concise way of binding UICollectionView to its DataSource (as an Observable)
            /// which is returned by the Search. This may seem a bit obfuscated but it eliminates
            /// a lot of boiler plate code.
            _ = viewModel.search(for: term, page: self.page).bind(to: (self.collectionView.rx.items(cellIdentifier: self.reuseIdentifier))) { _, imageSearchResult, cell in
                if let imageView = imageSearchResult.image {
                    self.configCell(cell: cell, imageView: imageView)
                }
            }
            /// Cancel the Keyboard
            self.searchBar.resignFirstResponder()
            
        }
    }
    
    /// Configure a cell and image view
    func configCell(cell: UICollectionViewCell, imageView: UIImageView) {
        
        /// Add the image as a subview of the Cell Content View
        _ = Util.configure(cell.contentView) {
            $0.addSubview(imageView)
            $0.backgroundColor = .white
        }
        /// Configure the ImageView within the Collection Cell
        _ = Util.configure(imageView) {
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor, constant: 0).isActive = true
            $0.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: 0).isActive = true
            $0.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 0).isActive = true
            $0.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 0).isActive = true
        }
    }
    
}
/// Extension on Search View Controller - provides some call backs for rotation and spacing + setting the title
extension SearchViewController {
    
    /// Calculate Cell spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    /// Shortcut - title could be injected to Controller
    func setControllerTitle(title: String) {
        self.navigationController?.navigationBar.topItem?.title = title
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("did end scrolling")
        self.page += 1
        self.search(term: self.term ?? "", page: self.page)
        //viewModel?.searchSpinnerViewBS.onNext(false)
    }
    
    /// Manage the Rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let view = self.collectionView else {
            return
        }
        view.collectionViewLayout.invalidateLayout()
    }

}
