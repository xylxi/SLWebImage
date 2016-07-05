//
//  UIImageView+SLImage.swift
//  SLImageCache
//
//  Created by DMW_W on 16/7/4.
//  Copyright © 2016年 XYLXI. All rights reserved.
//

import UIKit

private var slAssociatedObject: Void?

extension UIImageView {
    
    var sl_url: NSURL? {
        get {
            return objc_getAssociatedObject(self, &slAssociatedObject) as? NSURL;
        }
    }
    
    private func sl_setUrl(URL: NSURL) {
        objc_setAssociatedObject(self, &slAssociatedObject, URL, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


extension UIImageView {
    func sl_setImageWithURL(URL: NSURL, placeholderImage: UIImage? = nil) {
        self.sl_setUrl(URL)
        let resource = Resource(downloadURL: URL)
        self.image   = placeholderImage;
        SLImageManager.shareInstance.downloadAndCacheWithSource(resource) {
            [weak self]
            finished, image, cacheType, imageURL in
            guard let strongSelf = self  where strongSelf.sl_url == URL else {
                return ;
            }
            UIView.transitionWithView(strongSelf, duration: 0.25, options: [.TransitionCrossDissolve , .AllowUserInteraction], animations: { 
                strongSelf.image = image;
                }, completion: { (finish) in
                    
            })
        }
    }
}





