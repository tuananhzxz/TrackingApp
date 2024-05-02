//
//  Extension.swift
//  TrackingApp
//
//  Created by tuananhdo on 16/4/24.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    
    static let hud = JGProgressHUD(style: .dark)
    
    func configureGradientLayer() {
        let gardent = CAGradientLayer()
        gardent.colors = [UIColor.systemBlue.cgColor, UIColor.systemMint.cgColor]
        gardent.locations = [0,1]
        view.layer.addSublayer(gardent)
        gardent.frame = view.frame
    }
    
    func atributeStringSet(first : String, last : String) -> NSAttributedString {
        let atts : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(.black), .font : UIFont.systemFont(ofSize: 20)]
        let attributesTitle = NSMutableAttributedString(string: "\(first) ", attributes: atts)
        
        let boldAts : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(.black), .font : UIFont.boldSystemFont(ofSize: 20)]
        
        attributesTitle.append(NSAttributedString(string: last, attributes: boldAts))
        return attributesTitle
    }
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        if show {
            UIViewController.hud.textLabel.text = "Loading"
            UIViewController.hud.show(in: view)
            UIViewController.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
}
extension UICollectionViewCell {
    
    static let hud = JGProgressHUD(style: .dark)
    
    func atributeStringSet(first : String, last : String) -> NSAttributedString {
        let atts : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(.black), .font : UIFont.systemFont(ofSize: 20)]
        let attributesTitle = NSMutableAttributedString(string: "\(first) ", attributes: atts)
        
        let boldAts : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(.black), .font : UIFont.boldSystemFont(ofSize: 20)]
        
        attributesTitle.append(NSAttributedString(string: last, attributes: boldAts))
        return attributesTitle
    }
    
    func showLoader(_ show: Bool) {
        endEditing(true)
        if show {
            UICollectionViewCell.hud.textLabel.text = "Loading"
            UICollectionViewCell.hud.show(in: self)
            UICollectionViewCell.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        } else {
            UICollectionViewCell.hud.dismiss()
        }
    }
    
    func makeAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

extension UICollectionReusableView {
    static let hudd = JGProgressHUD(style: .dark)

    func showLoaderr(_ show: Bool) {
        endEditing(true)
        if show {
            UICollectionReusableView.hudd.textLabel.text = "Loading"
            UICollectionReusableView.hudd.show(in: self)
            UICollectionReusableView.hudd.indicatorView = JGProgressHUDSuccessIndicatorView()
        } else {
            UICollectionReusableView.hudd.dismiss()
        }
    }
}

extension UIButton {
    func atributeStringSet(first : String, last : String) {
            let atts : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(white: 1, alpha: 0.87), .font : UIFont.systemFont(ofSize: 16)]
            let attributesTitle = NSMutableAttributedString(string: "\(first) ", attributes: atts)
            
            let boldAts : [NSAttributedString.Key : Any] = [.foregroundColor : UIColor(white: 1, alpha: 0.87), .font : UIFont.boldSystemFont(ofSize: 16)]
            
            attributesTitle.append(NSAttributedString(string: last, attributes: boldAts))
            setAttributedTitle(attributesTitle, for: .normal)
        }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, rightAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, paddingRight : CGFloat = 0,constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
        
        if let right = rightAnchor {
            anchor(right: right, paddingRight: paddingRight)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
