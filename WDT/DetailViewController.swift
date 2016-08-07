//
//  DetailViewController.swift
//  WDT
//
//  Created by sunxh396145270 on 16/8/5.
//  Copyright © 2016年 sunxh396145270. All rights reserved.
//

import UIKit
import Alamofire
import RESideMenu
import AsyncDisplayKit

class DetailViewController: ASViewController,ASTableDataSource,ASTableDelegate {

    var _baseUrl = ""
    var _imageCount = 10
   
    
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    
    
    init() {
        super.init(node: ASTableNode())
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
    
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if 0 == section {
            return _imageCount
        }else{
            return 1
        }
        
    }
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        if 0 == indexPath.section{
            return {
                
                return ImageNode(String(format: "%@%02ld.jpg",self._baseUrl,indexPath.row+1))
            }
        }else{
            return {
                
                let textNode = ASTextCellNode()
                
                textNode.text = "点击加载更多..."
                textNode.textAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(13),
                                           NSForegroundColorAttributeName:UIColor.grayColor()]
            
                
                
                textNode.selectionStyle = .None
                
                return textNode
            }
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if 1 == indexPath.section{
            
            let oldImageCount = _imageCount
            _imageCount += 5
            
            tableView.beginUpdates()
            
            let indexPaths = (oldImageCount..<_imageCount).map { index in
                NSIndexPath(forRow: index, inSection: 0)
            }
            
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            
            
            tableView.endUpdates()
        }
    }

    
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
