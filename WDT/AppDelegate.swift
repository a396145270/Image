//
//  AppDelegate.swift
//  WDT
//
//  Created by sunxh396145270 on 16/7/30.
//  Copyright © 2016年 sunxh396145270. All rights reserved.
//

import UIKit
import RESideMenu



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let _leftView = LeftViewController()
    let _contentView =   ViewController()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        if NSUserDefaults().objectForKey("AllData") == nil {
            
            let dt = [
                ["name":"ROSI写真","url":"ROSI/rosi","subUrl":1481,"width":3],
                ["name":"4K-Star","url":"4kstar/","subUrl":512,"width":5],
                ["name":"咪咪图秀","url":"beautyleg/beautyleg","subUrl":1287,"width":3],
                ["name":"第四印象","url":"DISI/DISI","subUrl":607,"width":3],
                ["name":"NAKED-ART套图","url":"NAKEDART/","subUrl":642,"width":5],
                ["name":"3Agirl写真","url":"3Agirl/No","subUrl":530,"width":3],
                ["name":"TPimage","url":"tpimage/tpimage","subUrl":437,"width":3],
                ["name":"STG丝图阁","url":"STG/STG","subUrl":46,"width":3],
                ["name":"Sityle丝尚写真馆","url":"Sityle/Sityle","subUrl":96,"width":3],
                ["name":"丝间舞","url":"sjw/sjw","subUrl":660,"width":3],
                ["name":"秀人模特","url":"XiuRen/","subUrl":375,"width":5],
                ["name":"RU1MM如壹写真","url":"RU1MM/No","subUrl":331,"width":3],
                ["name":"MYGIRL美媛馆","url":"MYGIRL/Vol","subUrl":179,"width":3],
                ["name":"Legku写真","url":"Legku/","subUrl":220,"width":3],
                ["name":"PANS写真","url":"PANS/PANS","subUrl":579,"width":3],
                ["name":"Ugirls尤果写真","url":"Ugirls/","subUrl":164,"width":3],
                ["name":"AISS爱丝","url":"AISS/","subUrl":81,"width":3],
                ["name":"BOLOLI波萝社","url":"bololi/Vol","subUrl":81,"width":3],
                ["name":"RQ-STAR","url":"RQSTAR/","subUrl":1041,"width":5]]
            
            NSUserDefaults().setObject(dt, forKey: "AllData")
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.window!.backgroundColor = UIColor.whiteColor()
        
      
        
        _leftView.detailView = _contentView
        
        
        let nav1 = UINavigationController(rootViewController:_leftView)
        let nav2 = UINavigationController(rootViewController:_contentView)
        
        nav1.hidesBarsOnSwipe = true
        nav2.hidesBarsOnSwipe = true
       
       
        
        let v3 = RESideMenu(
            contentViewController: nav2,
            leftMenuViewController: nav1,
            rightMenuViewController: nil)
        
        
        v3.scaleMenuView = false
        v3.scaleContentView = false
       
        
        self.window!.rootViewController = v3
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    
    
}

