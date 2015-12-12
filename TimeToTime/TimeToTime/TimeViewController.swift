//
//  TimeViewController.swift
//  TimeToTime
//
//  Created by Paul Jarysta on 31/10/2015.
//  Copyright © 2015 Paul Jarysta. All rights reserved.
//

import UIKit
import CoreData

class TimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet var tableView: UITableView!
	@IBOutlet var editButton: UIBarButtonItem!
	
	
	var timer: NSTimer!
	
	var timezoneManage = [NSManagedObject]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "TimeToTime"
		
		tableView.delegate = self
		tableView.dataSource = self
		
		NSTimer.scheduledTimerWithTimeInterval(60.0, target:self, selector: Selector("reloadTableView"), userInfo: nil, repeats: true)
	}
	
	override func viewWillAppear(animated: Bool) {
		
		super.viewWillAppear(animated)
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		
  let managedContext = appDelegate.managedObjectContext
		
  let fetchRequest = NSFetchRequest(entityName: "Timezone")
		
  do {
		let results =
		try managedContext.executeFetchRequest(fetchRequest)
		timezoneManage = results as! [NSManagedObject]
	} catch let error as NSError {
		print("Could not fetch \(error), \(error.userInfo)")
  }
		reloadTableView()
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Methods
	
	func reloadTableView() {
		dispatch_async(dispatch_get_main_queue(), {
			self.tableView.reloadData()
		})

	}
	
	
	// MARK: - UITableView
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return timezoneManage.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let date = NSDate();
		let formatter = NSDateFormatter();
		
		
		let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomTimeCell
		
		cell.selectionStyle = UITableViewCellSelectionStyle.None
		
		formatter.dateFormat = "HH:mm";
		
		if let offset = timezoneManage[indexPath.row].valueForKey("offset") {
			
			formatter.timeZone = NSTimeZone(forSecondsFromGMT: (Int(offset as! NSNumber)))
			
			let dateUtcConvert = formatter.stringFromDate(date);
			
			cell.lbHour.text = dateUtcConvert
			
		}
		
		formatter.dateFormat = "E dd MMM yyyy";

		if let offset = timezoneManage[indexPath.row].valueForKey("offset") {
			
			formatter.timeZone = NSTimeZone(forSecondsFromGMT: (Int(offset as! NSNumber)))
			
			let dateUtcConvert = formatter.stringFromDate(date);
			
			cell.lbDate.text = dateUtcConvert
		}
		
		if let name = timezoneManage[indexPath.row].valueForKey("name"), abbreviation = timezoneManage[indexPath.row].valueForKey("abbreviation"), offset = timezoneManage[indexPath.row].valueForKey("offset") {

				let convertOffsetToHour = (Int(offset as! NSNumber) / 60) / 60
				
				if (convertOffsetToHour > 0) {
					if ((convertOffsetToHour - 1) == 0) {
						cell.lbTimezone.text = "\(name) / \(convertOffsetToHour - 1):00 / \(abbreviation)"
					} else {
						cell.lbTimezone.text = "\(name) / +\(convertOffsetToHour - 1):00 / \(abbreviation)"
					}
				} else {
					cell.lbTimezone.text = "\(name) / \(convertOffsetToHour - 1):00 / \(abbreviation)"
				}
		}
		
		if let lieux = timezoneManage[indexPath.row].valueForKey("locality") {
			cell.lbLocality.text = lieux as? String
		}
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("You selected cell #\(indexPath.row)!")
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		switch editingStyle {
		case .Delete:
		
			let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
			
			let managedContext = appDelegate.managedObjectContext
			
			managedContext.deleteObject(timezoneManage[indexPath.row] as NSManagedObject)
			timezoneManage.removeAtIndex(indexPath.row)
			
			do {
				try managedContext.save()
				reloadTableView()
			} catch let error as NSError {
				print("Could not remove \(error), \(error.userInfo)")
			}
		default:
			return
		}
	}
	
	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
		let itemToMove = timezoneManage[fromIndexPath.row]
		timezoneManage.removeAtIndex(fromIndexPath.row)
		timezoneManage.insert(itemToMove, atIndex: toIndexPath.row)
	}
	
	// MARK: - Action
	
	@IBAction func startEditing(sender: UIBarButtonItem) {
		// tableView.editing = !tableView.editing
		
		if tableView.editing {
			tableView.setEditing(false, animated: true)
			editButton.title = "Edit"
			editButton.style = UIBarButtonItemStyle.Plain
		}	else {
			tableView.setEditing(true, animated: true)
			editButton.title = "Done"
			editButton.style =  UIBarButtonItemStyle.Done
		}
	}
}
