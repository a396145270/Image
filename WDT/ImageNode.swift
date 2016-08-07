//
//  ImageNode.swift
//  WDT
//
//  Created by sxh on 16/8/4.
//  Copyright © 2016年 sunxh396145270. All rights reserved.
//

import UIKit
import AsyncDisplayKit


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
        
        return ASRatioLayoutSpec(ratio: _ratio, child: _image)
        
    }
    func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage) {
        
        _ratio = image.size.height/image.size.width
        
        setNeedsLayout()
        
        imageNode.setNeedsLayout()
        
    }

}
