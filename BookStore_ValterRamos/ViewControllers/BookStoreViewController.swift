//
//  BookStoreViewController.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 07/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class BookStoreViewController: UIViewController, CoordinatedViewControllerProtocol, UICollectionViewDelegate {
    //
    // MARK: - Variables
    var coreCoordinator: CoreCoordinator?
    var collectionView: UICollectionView?
    var activityIndicator: UIActivityIndicatorView?
    var currentIndex: Int = 0
    var volumes:[Volume] = []
    var filteredVolumes:[Volume] = []
    private var disposeBag = DisposeBag()
    var viewModel: BookStoreViewModel
    var cellId: String = "BookCell"
    var favoriteButton: UIButton!
  
    /// Init
    /// - Parameters:
    ///   - viewModel: ViewModel
    init(viewModel: BookStoreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setupObservers()
    }
  
    override func viewWillAppear(_ animated: Bool) {
      self.activityIndicator?.isHidden = false
      if(self.favoriteButton.isSelected) {
        filteredVolumes = viewModel.fetchStoredVolumes()
        reloadData()
      } else {
        fetchBooks()
      }
    }
}

extension BookStoreViewController {
    func setUpLayout() {
       self.collectionView = buildCollectionView()
       self.activityIndicator = UIActivityIndicatorView()
       self.activityIndicator?.startAnimating()
       self.view.addSubview(self.collectionView!)
       self.view.addSubview(self.activityIndicator!)
       self.favoriteButton = buildButton()
       self.favoriteButton.addTarget(self, action: #selector(self.filterFavorite), for: .touchUpInside)
       self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
       self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
       addConstraints()
       setUpNavigationController()
    }
  
    func setupObservers() {
        let booksObserver = self.viewModel.books
        let errorObserver = self.viewModel.errorRelay

        
        booksObserver
          .observe(on: MainScheduler.instance)
              .subscribe(onNext: { [weak self] (volumes) in
                self?.volumes.append(contentsOf: volumes)
                self?.reloadData()
              }, onError: { [weak self] (error) in
                  self?.showError(message: error.localizedDescription)
              })
             .disposed(by: self.disposeBag)
        
        
        errorObserver
          .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (error) in
              self?.showError(message: error.localizedDescription)
            })
            .disposed(by: self.disposeBag)
    }
  
    func setUpNavigationController() {
      let titleLabel = buildLabelView()
      titleLabel.text = "BookStore"
      self.navigationController?.setToolbarHidden(false, animated: false)
      self.navigationItem.titleView = titleLabel
      
      let favoriteBarButtonItem = UIBarButtonItem(customView: favoriteButton)
      self.navigationItem.rightBarButtonItem = favoriteBarButtonItem
    }
  
    func buildLabelView() -> UILabel {
        return {
          let label = UILabel()
          label.font = UIFont.boldSystemFont(ofSize: CGFloat(16))
          label.numberOfLines = 1
          label.backgroundColor = UIColor.white
          label.textColor = UIColor.black
          label.textAlignment = .center
          return label
      }()
    }
  
    func buildCollectionView() -> UICollectionView {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        let noOfCellsInRow = 2
        let totalSpace = flowLayout.sectionInset.left
          + flowLayout.sectionInset.right
          + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((view.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        flowLayout.itemSize = CGSize(width: size, height: 200)
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        return collectionView
    }
  
    func buildButton() -> UIButton {
        return {
          let button = UIButton()
          button.backgroundColor = UIColor.white
          button.isUserInteractionEnabled = true
          button.isEnabled = true
          return button
        }()
    }
    
    func addConstraints() {
      self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
      self.collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      self.collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      self.collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      self.collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
      
      self.activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
      self.activityIndicator?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      self.activityIndicator?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
  
    @objc func filterFavorite() {
      self.activityIndicator?.isHidden = false
      self.favoriteButton.isSelected = !self.favoriteButton.isSelected
      if(self.favoriteButton.isSelected) {
        filteredVolumes = viewModel.fetchStoredVolumes()
      }
      reloadData()
    }
  
    func reloadData() {
      DispatchQueue.main.async {
          self.activityIndicator?.isHidden = true
          self.collectionView?.reloadData()
          self.collectionView?.setContentOffset(.zero, animated: false)
      }
    }
  
    public func showError(message: String) {
        let alertController = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
            // Do nothing...
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - BookStoreViewModel -> FetchBooks
extension BookStoreViewController {
    func fetchBooks() {
      self.viewModel.fetchBooks(query: BookStore.query, maxResults: BookStore.maxResult, startIndex: currentIndex)
    }
}

// MARK: - UICollectionViewDataSource
extension BookStoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      if(favoriteButton.isSelected) {
        return self.filteredVolumes.count
      }
      return self.volumes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookCollectionViewCell
      if(favoriteButton.isSelected) {
        cell.titleLabel?.text = self.filteredVolumes[indexPath.row].volumeInfo?.title
        if let url = self.filteredVolumes[indexPath.row].volumeInfo?.thumbnail {
          cell.imageView?.af_setImage(withURL: URL(string: url)!)
        }
      } else {
        cell.titleLabel?.text = self.volumes[indexPath.row].volumeInfo?.title
        if let url = self.volumes[indexPath.row].volumeInfo?.thumbnail {
          cell.imageView?.af_setImage(withURL: URL(string: url)!)
        }
      }
      return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if(favoriteButton.isSelected) {
        coreCoordinator?.showDetailOf(withVolume: self.filteredVolumes[indexPath.row])
      } else {
        coreCoordinator?.showDetailOf(withVolume: self.volumes[indexPath.row])
      }
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension BookStoreViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
      let count = self.volumes.count
      if (count > 0 && !favoriteButton.isSelected) {
        let ifNeedsFetch = indexPaths.contains {$0.row >= count  - 1 }
        if ifNeedsFetch {
            currentIndex = count + 1
            fetchBooks()
        }
      }
    }
}
