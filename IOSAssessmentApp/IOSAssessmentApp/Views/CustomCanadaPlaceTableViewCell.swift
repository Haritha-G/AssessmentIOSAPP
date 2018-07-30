//
//  CustomCanadaPlaceTableViewCell.swift
//  IOSAssessmentApp
//
//  Created by HarithaReddy on 24/07/18.
//  Copyright © 2018 administrator. All rights reserved.
//

import UIKit

class CustomCanadaPlaceTableViewCell: UITableViewCell {


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    var place : Place? {
        didSet{
            updateUI()
        }
    
    }
    // To set the values to the cell attributes
    func updateUI()
    {
        if let title = place?.title
        {
            titleLabel.text = title
        }else{
            titleLabel.text = ""
        }
        if let description = place?.description
        {
            descriptionLabel.text = description
        }else
        {
            descriptionLabel.text = ""
        }
        if let imageRef = place?.imageHref
        {
            DispatchQueue.global(qos: .default).async {
                self.PlaceImageView.loadImageViewWithTheUrlString(urlString: imageRef)
           }

        }else
        {
            PlaceImageView.image = UIImage(named: "defaultPlace")
        }
    
    }
    
    let PlaceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(PlaceImageView)
        
        let views: [String: Any] = [
        "titleLabel": titleLabel,
        "descriptionLabel": descriptionLabel,
        "PlaceImageView": PlaceImageView]
        
        //adding constraints using visual layout format
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[PlaceImageView(100)]-10-[titleLabel]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[PlaceImageView]-10-[descriptionLabel]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[PlaceImageView(100)]", options: [.alignAllCenterY], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLabel]-10-[descriptionLabel(>=100)]|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
    
    
    }

}

// used NSCache to cache the the image data , for smooth scrolling
let placeImageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView
{
    // To download the data from the image url and loding the imageview with the image
    func loadImageViewWithTheUrlString(urlString : String)
    {
        guard let url = URL(string: urlString) else {
            return
        }
        // checking the existance of data for the specific urlstring in Cache
        if let cachedImage = placeImageCache.object(forKey: urlString as AnyObject) as? UIImage
        {
             DispatchQueue.main.async {
                // if it exists , no need to get data . We can use the cached dataa
                self.image = cachedImage
                return
            }
         
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data) else{
                    // displaying the default image, if the image data is not found
                    self.image = UIImage(named: "defaultPlace")
                    print("image not found")
                    return
                    
                }
                // setting downloaded image to the cache for future use..
                placeImageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self.image = imageToCache
            }
            
            }.resume()
    }
}
