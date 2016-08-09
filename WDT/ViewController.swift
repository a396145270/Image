//
//  ViewController.swift
//  WDT
//
//  Created by sunxh396145270 on 16/7/30.
//  Copyright © 2016年 sunxh396145270. All rights reserved.
//

import UIKit
import Alamofire
import AsyncDisplayKit
import Async
import ReachabilitySwift


enum NetworkStatusS {
    case NotReachable, ReachableViaWiFi, ReachableViaWWAN
}

let _defImageData = UIImagePNGRepresentation(UIImage(named: "1.jpg")!)
var _internetState:NetworkStatusS = .ReachableViaWWAN


class ViewController: ASViewController,ASTableDataSource,ASTableDelegate {
    
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
   
    var _itemCount = 10
    
    var _reachability:Reachability!
    
    var _baseUrl = ""
    
    var _subUrl = 0
    
    var _urlwidth = 0
    
    
    init() {
        super.init(node: ASTableNode())
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.separatorStyle = .None
        tableNode.backgroundColor = UIColor.lightGrayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func changeColumn(url:String,_ subUrl:Int,_ urlWidth:Int = 0,_ title:String = "") {
        
        _baseUrl = mmkaoUrl + url
        _subUrl = subUrl
        _urlwidth = urlWidth
        
        self.title = title
        self.tableNode.view.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.checkInternet()
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return _itemCount
    }
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        return ImageNode(self.getUrlString(_subUrl-indexPath.row) + "01.jpg" )
    }
    
  
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vd = DetailViewController()
        
        vd._baseUrl =  self.getUrlString(_subUrl-indexPath.row)
        
   
        self.navigationController?.showViewController(vd, sender: nil)
    }
    
    func getUrlString(index:Int) -> String {
      
            return String(format: "%@%0\(_urlwidth)ld/", _baseUrl,index)
        
    }
    // 网路状态
    func checkInternet(){
        
        do {
            _reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        
        _reachability.whenReachable = { reachability in
            
            Async.main(block: {
                
                if reachability.isReachableViaWiFi() {
                    
                    _internetState = .ReachableViaWiFi
                    
                    self.tableNode.view.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                        
                        Async.main( block: {
                            
                            let tableView = self.tableNode.view
                            
                            let oldImageCount = self._itemCount
                            
                            self._itemCount += 20
                            
                            tableView.beginUpdates()
                            
                            let indexPaths = (oldImageCount..<self._itemCount).map { index in
                                NSIndexPath(forRow: index, inSection: 0)
                            }
                            
                            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                            
                            
                            tableView.endUpdates()
                            
                            tableView.mj_footer.endRefreshing()
                        })
                        
                    })
                    
                    
                } else {
                    
             
                    _internetState = .ReachableViaWWAN
                    
                    self.tableNode.view.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
                        
                        Async.main(after: 0.5, block: {
                            
                            let tableView = self.tableNode.view
                            
                            let oldImageCount = self._itemCount
                            
                            self._itemCount += 10
                            
                            tableView.beginUpdates()
                            
                            let indexPaths = (oldImageCount..<self._itemCount).map { index in
                                NSIndexPath(forRow: index, inSection: 0)
                            }
                            
                            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                            
                            
                            tableView.endUpdates()
                            
                            tableView.mj_footer.endRefreshing()
                        })
                        
                    })
                  
                }
            })
            
            
        }
        _reachability.whenUnreachable = { reachability in
            
            Async.main(block: {
                
                self.tableNode.view.mj_footer = nil
                
                _internetState = .NotReachable
            })
            
        }
        
        do {
            try _reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

