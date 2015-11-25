//
//  SearchViewController.swift
//  TimeToTime
//
//  Created by Paul Jarysta on 30/10/2015.
//  Copyright © 2015 Paul Jarysta. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
	

	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var tableViewResult: UITableView!

	var saveQueryTimezone: String? = ""
	var saveQueryLocality: String? = ""
	var saveQueryAbbreviation: String? = ""
	var saveQueryOffset: Int?
	var saveQueryName: String? = ""
	
	var timezoneManage = [NSManagedObject]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Ajouter un fuseau horaire"
		
		searchBar.delegate = self
		
		tableViewResult.delegate = self
		tableViewResult.dataSource = self
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK: - Methods
	
	func saveTimezone() {
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		
		let managedContext = appDelegate.managedObjectContext
		
		let entity =  NSEntityDescription.entityForName("Timezone", inManagedObjectContext:managedContext)
		
  let timezoneObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
		
		timezoneObject.setValue(self.saveQueryLocality, forKey: "locality")
		timezoneObject.setValue(self.saveQueryTimezone, forKey: "timezone")
		timezoneObject.setValue(self.saveQueryAbbreviation, forKey: "abbreviation")
		timezoneObject.setValue(self.saveQueryOffset, forKey: "offset")
		timezoneObject.setValue(self.saveQueryName, forKey: "name")
		
		do {
			try managedContext.save()
			timezoneManage.append(timezoneObject)
			
		} catch let error as NSError {
			print("Could not save \(error), \(error.userInfo)")
		}
	}
	
	func geocodeCityZoneWithText(text: String) {
		print(text)
		let geocoder : CLGeocoder = CLGeocoder()
		
		geocoder.geocodeAddressString(text, completionHandler: { (placemarks, error) -> Void in

			if let firstPlacemark = placemarks?[0] {
				
				
				self.saveQueryTimezone = firstPlacemark.timeZone?.description
				self.saveQueryLocality = firstPlacemark.locality
				self.saveQueryAbbreviation = firstPlacemark.timeZone?.abbreviation
				self.saveQueryOffset = firstPlacemark.timeZone?.secondsFromGMT
				self.saveQueryName = firstPlacemark.timeZone?.name
				self.reloadTableView()
			}
		})
	}
	
	func reloadTableView() {
		dispatch_async(dispatch_get_main_queue(), {
			self.tableViewResult.reloadData()
		})
	}
	
	func setTitleForCell(cell: CustomSearchCell) {
		cell.lbName?.text = saveQueryLocality
		cell.lbTimezone?.text = saveQueryTimezone
	}
	
	@IBAction func dismissModalView(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	// MARK: - UISearchBar
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		geocodeCityZoneWithText(searchBar.text!)
	}
	
	
	// MARK: - UITableView
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (saveQueryLocality?.characters.count > 0) {
			return 1
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = self.tableViewResult.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CustomSearchCell

		cell.lbTimezone?.adjustsFontSizeToFitWidth = true

		setTitleForCell(cell)
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		print("You selected cell #\(indexPath.row)!")
		
		if (indexPath.row == 0) {
			saveTimezone()
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}

	
//	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//		print("You selected cell #\(indexPath.row)!")
//		
//		if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//			if cell.accessoryType == .Checkmark {
//				cell.accessoryType = .None
//			} else {
//				cell.accessoryType = .Checkmark
//				saveTimezone()
//			}
//		}
//	}
	
	
}

