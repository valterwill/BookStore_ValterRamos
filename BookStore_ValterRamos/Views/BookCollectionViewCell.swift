//
//  BookCollectionViewCell.swift
//  BookStore_ValterRamos
//
//  Created by Valter Wellington Ramos Junior on 07/07/21.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel?
    var imageView: UIImageView?
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}

extension BookCollectionViewCell {
    func setUpLayout(){
      self.imageView = {
        let imageView = UIImageView()
          imageView.backgroundColor = UIColor.white
          return imageView
      }()
      
      self.titleLabel = {
          let label = UILabel(frame:CGRect())
          label.font = UIFont.systemFont(ofSize: 14)
          label.lineBreakMode = NSLineBreakMode.byWordWrapping
          label.numberOfLines = 0
          label.textColor = UIColor.darkGray
          return label
      }()
      addSubview(self.titleLabel!)
      addSubview(self.imageView!)
      addConstraints()
    }
  
    func addConstraints() {
      self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
      self.titleLabel?.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
      self.titleLabel?.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
      self.titleLabel?.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
      self.titleLabel?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
      self.imageView?.translatesAutoresizingMaskIntoConstraints = false
      self.imageView?.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
      self.imageView?.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
      self.imageView?.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
      self.imageView?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
