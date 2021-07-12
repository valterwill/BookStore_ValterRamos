//
//  BookDetailViewController.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 06/07/21.
//

import UIKit
import SafariServices

class BookDetailViewController: UIViewController, CoordinatedViewControllerProtocol {
    //
    // MARK: - Variables
    var coreCoordinator: CoreCoordinator?
    var viewModel: BookDetailViewModel
    var titleLabel: UILabel!
    var authorsLabel: UILabel!
    var descriptionTextView: UITextView!
    var favoriteButton: UIButton!
    var buyButton: UIButton!
    var buttonsStackView: UIStackView!
  
  
    /// Init
    /// - Parameters:
    ///   - viewModel: ViewModel
    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }

}


extension BookDetailViewController {
    func setUpLayout() {
       let stackView = buildStackView(orientation: .vertical, distribution: .equalSpacing)
       self.favoriteButton = buildButton(withoutBorder: true)
       self.favoriteButton.addTarget(self, action: #selector(self.toogleFavorite), for: .touchUpInside)
       self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
       self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
      
       self.buyButton = buildButton()
       if let price = self.viewModel.volume?.saleInfo?.normalize() {
         self.buyButton.setTitle("\(price)", for: .normal)
       } else {
         self.buyButton.setTitle("Grátis", for: .normal)
       }
       self.buyButton.addTarget(self, action: #selector(self.buyVolume), for: .touchUpInside)
      
       self.titleLabel = buildLabelView(fontSize: 18, withBold: true)
       self.titleLabel.text = self.viewModel.volume?.volumeInfo?.title
      
       self.authorsLabel = buildLabelView(fontSize: 14)
       self.authorsLabel.text = self.viewModel.volume?.volumeInfo?.authors.joined(separator: ", ")
      
       self.descriptionTextView = buildTextView()
       self.descriptionTextView.text = self.viewModel.volume?.volumeInfo?.desc
      
       stackView.addArrangedSubview(self.titleLabel)
       stackView.addArrangedSubview(self.authorsLabel)
       stackView.addSubview(self.buyButton)
       stackView.addArrangedSubview(self.descriptionTextView)
       self.view.backgroundColor = UIColor.white
       view.addSubview(stackView)
       view.addSubview(self.buyButton)
       addConstraints()
       setUpNavigationController()
    }
  
    func setUpNavigationController() {
      let titleLabel = buildLabelView(fontSize: 16)
      titleLabel.text = viewModel.volume?.volumeInfo?.title
      self.navigationItem.titleView = titleLabel
      
      let favoriteBarButtonItem = UIBarButtonItem(customView: favoriteButton)
      self.favoriteButton.isSelected = viewModel.isFavorite()
      self.navigationItem.rightBarButtonItem = favoriteBarButtonItem
    }
    
    func buildStackView(orientation: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution) -> UIStackView {
      return {
        let stackView = UIStackView()
        stackView.axis = orientation
        stackView.distribution = distribution
        stackView.backgroundColor = UIColor.white
        stackView.isUserInteractionEnabled = true
        return stackView
      }()
    }
    
    func buildButton(withoutBorder: Bool = false) -> UIButton {
        return {
          let button = UIButton()
          button.backgroundColor = UIColor.white
          if(!withoutBorder) {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blue.cgColor
          }
          button.setTitleColor(UIColor.blue, for: .normal)
          button.isUserInteractionEnabled = true
          button.isEnabled = true
          return button
        }()
    }
  
    func buildLabelView(fontSize: Int, withBold: Bool = false) -> UILabel {
        return {
          let label = UILabel()
          if withBold {
            label.font = UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
          }else{
            label.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
          }
          label.lineBreakMode = NSLineBreakMode.byWordWrapping
          label.numberOfLines = 0
          label.backgroundColor = UIColor.white
          label.textColor = UIColor.black
          return label
      }()
    }
  
    func buildTextView() -> UITextView {
      return {
          let textView = UITextView()
          textView.center = self.view.center
          textView.textAlignment = NSTextAlignment.justified
          textView.font = UIFont.systemFont(ofSize: 14)
          textView.backgroundColor = UIColor.white
          textView.isScrollEnabled = true
          return textView
      }()
    }
    
    func addConstraints() {
      self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
      self.titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
      self.titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
      self.titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
      
      self.authorsLabel.translatesAutoresizingMaskIntoConstraints = false
      self.authorsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
      self.authorsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
      self.authorsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
      
      self.buyButton.topAnchor.constraint(equalTo: authorsLabel.bottomAnchor, constant: 10).isActive = true
      self.buyButton.translatesAutoresizingMaskIntoConstraints = false
      self.buyButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
      self.buyButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
      self.buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      
      self.descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
      self.descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
      self.descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
      self.descriptionTextView.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 10).isActive = true
      self.descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
    }
  
    @objc func toogleFavorite() {
      let resultToggle = viewModel.toogleFavorite()
      self.favoriteButton.isSelected = resultToggle
    }
  
    @objc func buyVolume() {
      if let buyLink = viewModel.volume?.saleInfo?.buyLink, let url = URL(string: buyLink)  {
          let vc = SFSafariViewController(url: url)
          present(vc, animated: true)
      }
    }
}
