//
//  TableViewController.swift
//  legend_business_ios
//
//  Created by msb-ios-dev on 16/2/21.
//  Copyright © 2016年 heyk. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    
    @IBOutlet var logoutButton : UIButton?
    @IBOutlet var phoneLabel : UILabel?
    @IBOutlet var footView : UIView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UitlCommon.setFlat(view: logoutButton!, radius: Configure.SYS_CORNERRADIUS())
        
        let userInfo = SaveEngine.getUserInfo()
        
        phoneLabel?.text = userInfo?.telephone
      
        logoutButton?.titleLabel?.font = Configure.SYS_UI_BUTTON_FONT()
        footView?.frame = CGRect(x: 0, y: 0, width: Configure.SYS_UI_WINSIZE_WIDTH(),  height: Configure.SYS_UI_BUTTON_HEIGHT() + 40)
        
    
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickLogOut(){
        
        DefaultService.loginOut()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45//Configure.SYS_FONT_SCALE(44)
        
    }
    override  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {return 0}
        return 10
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
       /* if indexPath.section == 1 && indexPath.row == 0 {//关于我们
        
            let vc = WebViewViewController(nibName:"WebViewViewController",bundle:nil)
            vc.type = WebType_AboutUs
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 1 {//用户协议
            
            let vc = WebViewViewController(nibName:"WebViewViewController",bundle:nil)
            vc.type = WebType_UserAgent
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else*/ if indexPath.section == 2 && indexPath.row == 0 {//客服热线
            
            
            UIApplication.shared.openURL(URL(string: "tel:18180208706")!)
        }
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
