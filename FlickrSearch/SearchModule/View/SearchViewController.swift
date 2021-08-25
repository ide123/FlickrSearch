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
    
    /// Temp Buffer stores Results for a given Search term
    /// Cleared and re-used for each Term.
    var imageBuffer   = [ImageSearchResult]()
    /// Used to communicate new results for a given Term - same of different to original term
    var imageBufferPS = PublishSubject<[ImageSearchResult]>()
    /// Current Page of Search with Search Term
    var page: Int = 1
    var term: String?
    /// Last row Index of page
    var lastIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set Title - NB see coment below - this is not part of DI as a shortcut.
        setControllerTitle(title: controllerTitle)
        
        /// Register a Collection View Cell and Set the Rx delegate
        self.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        /// Concise way of binding UICollectionView to its DataSource (as an Observable)
        /// which is returned by the Search.
        self.imageBufferPS.subscribeOn(MainScheduler.instance).subscribe { evt in
                if let results = evt.element {
                    self.collectionView.dataSource = nil
                    _ = Observable.from(optional: results).bind(to: (self.collectionView.rx.items(cellIdentifier: self.reuseIdentifier))) { _, imageSearchResult, cell in
                        if let imageView = imageSearchResult.image {
                            self.configCell(cell: cell, imageView: imageView)
                        }
                    }
                }
        }.disposed(by: disposeBag)
        
        /// Use this to move the Page  Cursor on re-load
        _ = imageBufferPS.subscribe { _ in
            self.collectionView.scrollToItem(at: IndexPath(item: self.lastIndex-1, section: 0), at: .bottom, animated: false)
        }.disposed(by: disposeBag)

        /// Fire a search request when user hits search button
        let searchEventObs = searchBar.rx.searchButtonClicked.asObservable()
        let searchTermObs  = searchBar.rx.text.asObservable()
        _ = searchEventObs.withLatestFrom(searchTermObs).subscribe { [weak self] evt in
            if let term = evt.element {
                /// Store  Search Term
                self?.term = term
                /// Clear Image Buffer for a new Search
                self?.imageBuffer.removeAll()
                /// Do New Search - page 1
                self?.search(term: term!, page: 1)
            }
        }.disposed(by: disposeBag)
  
    }
    
    /// Main Search Function
    func search(term: String, page: Int) {
       
        if let viewModel = self.viewModel {
            
            /// Hide Spinner
            _ = viewModel.searchSpinnerViewBS.bind(to: self.spinnerView.rx.isHidden)
            
            /// Check Term is "valid" i.e. has content
            if !(viewModel.searchTermValidation(term: term)) {
                return
            }
            
            /// Show spinner - not very obvious - could change to enum & convert to bool
            /// binds BS direct to isHidden propertty of the UIView displaying the spinner
            viewModel.searchSpinnerViewBS.onNext(false)
            
            /// Search for Term
            /// Appends Results to Buffer and publishes update shown by CollectionView
            _ = viewModel.search(for: term, page: self.page).observeOn(MainScheduler.instance).subscribe({ evt in
                if let results = evt.element {
                    /// Append
                    let count = self.imageBuffer.count
                    self.imageBuffer += results
                    /// Recalculate the Last Index so we can move directly to it
                    if !self.imageBuffer.isEmpty {
                        self.lastIndex = (self.imageBuffer.count - count ) * (self.page - 1)
                    }
                    self.imageBufferPS.onNext(self.imageBuffer)
                    print("images count: \(self.imageBuffer.count) page: \(self.page) Last Index: \(self.lastIndex) term: \(term)")
                    
                }
            }).disposed(by: disposeBag)
            
            /// Temp Store the Term and Page Number
            self.term = term
            self.page = page
            
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
   
    /// Call back used to detect end of Scroll and fire off a new Search with new Page number
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.imageBuffer.count - 1 {
            /// Update Page - we then load the next page with same term
            self.page += 1
            self.search(term: self.term!, page: self.page)
            viewModel?.searchSpinnerViewBS.onNext(false)
         }
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
