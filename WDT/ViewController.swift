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



class ViewController: ASViewController,ASTableDataSource,ASTableDelegate {
    
    
    struct State {
        var itemCount: Int
        var fetchingMore: Bool
        static let empty = State(itemCount: 20, fetchingMore: false)
    }
    
    enum Action {
        case BeginBatchFetch
        case EndBatchFetch(resultCount: Int)
    }
    
    var tableNode: ASTableNode {
        return node as! ASTableNode
    }
    
    private(set) var state: State = .empty
    
    
    var _baseUrl = ""
    
    var _subUrl = 0
    
    var _urlwidth = 0
    
    
    init() {
        super.init(node: ASTableNode())
        tableNode.delegate = self
        tableNode.dataSource = self
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
       
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = state.itemCount
        if state.fetchingMore {
            count += 1
        }
        return count
    }
    
    func tableView(tableView: ASTableView, nodeForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNode {
        
        let rowCount = self.tableView(tableView, numberOfRowsInSection: 0)
        
        if state.fetchingMore && indexPath.row == rowCount - 1 {
            return ASCellNode()
        }
        
        
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
    
    func tableView(tableView: ASTableView, willBeginBatchFetchWithContext context: ASBatchContext) {
        /// This call will come in on a background thread. Switch to main
        /// to add our spinner, then fire off our fetch.
        
        Async.main {
            let oldState = self.state
            self.state = ViewController.handleAction(.BeginBatchFetch, fromState: oldState)
            self.renderDiff(oldState)
            
            }.main(after: 0.5) {
                
                let action = Action.EndBatchFetch(resultCount: 20)
                let oldState = self.state
                self.state = ViewController.handleAction(action, fromState: oldState)
                self.renderDiff(oldState)
                context.completeBatchFetching(true)
        }
        
        
    }
    
    private func renderDiff(oldState: State) {
        let tableView = tableNode.view
        tableView.beginUpdates()
        
        // Add or remove items
        let rowCountChange = state.itemCount - oldState.itemCount
        
        if rowCountChange > 0 {
            
            let indexPaths = (oldState.itemCount..<state.itemCount).map { index in
                NSIndexPath(forRow: index, inSection: 0)
            }
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
            
        } else if rowCountChange < 0 {
            
            assertionFailure("Deleting rows is not implemented. YAGNI.")
        }
        
        // Add or remove spinner.
        if state.fetchingMore != oldState.fetchingMore {
            
            if state.fetchingMore {
                // Add spinner.
                let spinnerIndexPath = NSIndexPath(forRow: state.itemCount, inSection: 0)
                tableView.insertRowsAtIndexPaths([ spinnerIndexPath ], withRowAnimation: .None)
            } else {
                // Remove spinner.
                let spinnerIndexPath = NSIndexPath(forRow: oldState.itemCount, inSection: 0)
                tableView.deleteRowsAtIndexPaths([ spinnerIndexPath ], withRowAnimation: .None)
            }
        }
        tableView.endUpdatesAnimated(true, completion: nil)
    }
    
    
    
    private static func handleAction(action: Action,  fromState state: State) -> State {
        
        var st = state
        switch action {
        case .BeginBatchFetch:
            st.fetchingMore = true
        case let .EndBatchFetch(resultCount):
            st.itemCount += resultCount
            st.fetchingMore = false
        }
        return st
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

