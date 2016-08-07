//
//  LeftViewController.swift
//  WDT
//
//  Created by sunxh396145270 on 16/8/5.
//  Copyright © 2016年 sunxh396145270. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Async


let strInd = "CellIndetify"
let mmkaoUrl = "http://img.mmkao.net/photo/"

class LeftViewController: UITableViewController,MGSwipeTableCellDelegate {
    
    weak var detailView:ViewController?
    
    dynamic var _dt:[[String:NSObject]]!
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dt.count
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard detailView != nil else{
            
            return
        }
        
        detailView?.changeColumn(_dt[indexPath.row]["url"] as? String ?? "",
                                 _dt[indexPath.row]["subUrl"] as? Int ?? 0,
                                 _dt[indexPath.row]["width"] as? Int ?? 0,
                                 _dt[indexPath.row]["name"] as? String ?? "")
    }
    
    deinit{
        
        self.detailView = nil
    }
    
  
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier(strInd) as! MGSwipeTableCell!
        
        if cell == nil{
            
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: strInd)
        }
        
        
        cell.leftButtons = [MGSwipeButton(title: "More",  backgroundColor: UIColor.greenColor()),
                            MGSwipeButton(title: "Delete",  backgroundColor: UIColor.blueColor())]
        cell.leftSwipeSettings.transition = MGSwipeTransition.ClipCenter
        
        cell.delegate = self
        
        cell.textLabel?.text = _dt[indexPath.row]["name"] as? String ?? ""
        
        cell.imageView?.image = UIImage.as_resizableRoundedImageWithCornerRadius(8.0, cornerColor: UIColor.blueColor(), fillColor: UIColor.blueColor())
        
        
        return cell
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        
        guard let indexRow = self.tableView.indexPathForCell(cell) else{
            
            return false
        }
        
        let val = _dt[indexRow.row]["subUrl"] as? Int ?? 0
        
        guard val > 0 else {
            
            return false
        }
        
        if 0 == index {
            _dt[indexRow.row]["subUrl"] = val + 1
        }else {
            _dt[indexRow.row]["subUrl"] = val - 1
        }
        
        NSUserDefaults().setObject(_dt, forKey: "AllData")
        
        
        detailView?.changeColumn(_dt[indexRow.row]["url"] as? String ?? "",
                                 _dt[indexRow.row]["subUrl"] as? Int ?? 0,
                                 _dt[indexRow.row]["width"] as? Int ?? 0,
                                 _dt[indexRow.row]["name"] as? String ?? "")
        
        
        return true
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self._dt = NSUserDefaults().objectForKey("AllData") as! [[String:NSObject]]
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if _dt.count == 0{
            return
        }
        
        detailView?.changeColumn(_dt[0]["url"] as? String ?? "",
                                 _dt[0]["subUrl"] as? Int ?? 0,
                                 _dt[0]["width"] as? Int ?? 0,
                                 _dt[0]["name"] as? String ?? "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
