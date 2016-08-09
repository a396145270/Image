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
import MJRefresh
import Async
import JTSImageViewController
import SVProgressHUD

class DetailViewController: ASViewController,ASTableDataSource,ASTableDelegate ,JTSImageViewControllerInteractionsDelegate{
    
    var _baseUrl = ""
    var _imageCount = 10
    var _isShowed = false
   
    
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    
    
    init() {
        super.init(node: ASTableNode())
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.separatorStyle = .None
        tableNode.backgroundColor = UIColor.lightGrayColor()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return _imageCount
        
        
    }
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        
        
        return {
            
            return ImageNode(String(format: "%@%02ld.jpg",self._baseUrl,indexPath.row+1))
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let imgNodeCell = tableNode.view.nodeForRowAtIndexPath(indexPath) as! ImageNode
        
        let imgInfo = JTSImageInfo()
        imgInfo.image = imgNodeCell._image.image
        imgInfo.referenceRect = self.view.frame
        imgInfo.referenceView = tableView
        
        
        let jtsvc = JTSImageViewController(imageInfo: imgInfo,
                                           mode: .Image,
                                           backgroundStyle: .Blurred)
        
        jtsvc.interactionsDelegate = self
        
        jtsvc.showFromViewController(self, transition: .FromOriginalPosition)
        
        
    }
    
    func imageViewerDidLongPress(imageViewer: JTSImageViewController!, atRect rect: CGRect) {
        
        UIImageWriteToSavedPhotosAlbum(imageViewer.image, self, #selector(DetailViewController.didFinish(_:err:cont:)), nil)
    }
    
    func didFinish(image:UIImage, err:NSError? ,cont:AnyObject){
        
        if err == nil {
            SVProgressHUD.showSuccessWithStatus("图片已保存至相册")
        }else{
            SVProgressHUD.showErrorWithStatus("保存图片失败")
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if _internetState == NetworkStatusS.ReachableViaWiFi{
            self.tableNode.view.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
               
                Async.main(block: {
                    
                    let tableView = self.tableNode.view
                    
                    let oldImageCount = self._imageCount
                    
                    self._imageCount += 10
                    
                    tableView.beginUpdates()
                    
                    let indexPaths = (oldImageCount..<self._imageCount).map { index in
                        NSIndexPath(forRow: index, inSection: 0)
                    }
                    
                    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                    
                    
                    tableView.endUpdates()
                    
                    tableView.mj_footer.endRefreshing()
                })
                
            })
        }else if _internetState == NetworkStatusS.ReachableViaWWAN{
            
            self.tableNode.view.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
                
                Async.main(after: 0.5, block: {
                    
                    let tableView = self.tableNode.view
                    
                    let oldImageCount = self._imageCount
                    
                    self._imageCount += 5
                    
                    tableView.beginUpdates()
                    
                    let indexPaths = (oldImageCount..<self._imageCount).map { index in
                        NSIndexPath(forRow: index, inSection: 0)
                    }
                    
                    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                    
                    
                    tableView.endUpdates()
                    
                    tableView.mj_footer.endRefreshing()
                })
                
            })
        }else{
            self.tableNode.view.mj_footer = nil
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
