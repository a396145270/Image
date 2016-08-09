//
//  ImageNode.swift
//  WDT
//
//  Created by sxh on 16/8/4.
//  Copyright © 2016年 sunxh396145270. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import PINCache
import Async

class ImageNode: ASCellNode,ASNetworkImageNodeDelegate {
    
    let _image = ASNetworkImageNode()
    
    var _ratio:CGFloat = 1.0
    
    init(_ url:String){
        super.init()
        
        _image.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        _image.delegate = self
        _image.URL =  NSURL(string: url)
        
        addSubnode(_image)
        
    }
    
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(4, 0, 4, 0), child: ASRatioLayoutSpec(ratio: _ratio, child: _image))
        
        // return ASRatioLayoutSpec(ratio: _ratio, child: _image)
        
    }
    func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage) {
        
        _ratio = image.size.height/image.size.width
        
        setNeedsLayout()
        
        imageNode.setNeedsLayout()
        
        Async.background {
            
            let dt = UIImagePNGRepresentation(image)
            
            
            if dt!.isEqualToData(_defImageData!){
                
                let key = PINRemoteImageManager.sharedImageManager().cacheKeyForURL(self._image.URL!, processorKey: nil)
                
                PINRemoteImageManager.sharedImageManager().defaultImageCache().removeObjectForKey(key)
                
            }
        }
        
    }
    
}
