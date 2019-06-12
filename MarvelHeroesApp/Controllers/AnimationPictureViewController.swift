//
//  AnimationPictureViewController.swift
//  MarvelHeroesApp
//
//  Created by iMac on 11/06/2019.
//  Copyright © 2019 Lonely Tree Std. All rights reserved.
//

import UIKit

class AnimationPictureViewController: UIViewController {
    
    lazy var avatarFavorite: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.autoSetDimensions(to: CGSize(width: view.frame.width, height: view.frame.height))
        return imageView
    }()
    
    lazy var closingPhotoButton: UIButton = {
        let closingPhotoButton = UIButton()
        closingPhotoButton.setTitle("X", for: .normal)
        closingPhotoButton.setTitleColor(.white, for: .normal)
        closingPhotoButton.backgroundColor = UIColor.darkGray
        closingPhotoButton.titleLabel?.font = UIFont.fontHelveticaRegular(size: 14.0)
        closingPhotoButton.addTarget(self, action: #selector(closePhoto), for: .touchUpInside)
        return closingPhotoButton
    }()
    
    var photoHero: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        
        guard let photoHero = photoHero else { return }
        avatarFavorite.image = photoHero
        
    }
    
    @objc func closePhoto() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addSubviews() {
        view.addSubview(avatarFavorite)
        view.addSubview(closingPhotoButton)
    }
    
    private func setupConstraints() {
        avatarFavorite.snp.makeConstraints { image in
            image.top.equalTo(view)
        }
        closingPhotoButton.snp.makeConstraints { button in
            button.top.equalTo(view).offset(UIApplication.shared.statusBarFrame.height + 20)
            button.right.equalTo(view).offset(-20)
        }
    }
    

}
