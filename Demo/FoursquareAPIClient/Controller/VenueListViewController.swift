//
//  VenueListViewController.swift
//  FoursquareAPIClient
//
//  Created by koogawa on 2015/07/23.
//  Copyright (c) 2015年 Kosuke Ogawa. All rights reserved.
//

import UIKit
import MapKit

class VenueListViewController: UITableViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var locationUpdated = false

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        locationManager.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Private methods

    func fetchVenues(coordinate: CLLocationCoordinate2D) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        // TODO: ACCESSTOKEN渡さないと

        FoursquareManager.sharedManager().searchVenuesWithCoordinate(coordinate, completion: {
            [weak self] (error) in

            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            self?.tableView.reloadData()
        })
    }


    // MARK: - CLLocationManager delegate

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        if locationUpdated == true {
            return
        }

        if !CLLocationCoordinate2DIsValid(newLocation.coordinate) {
            return
        }

        fetchVenues(newLocation.coordinate)

        locationUpdated = true
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return FoursquareManager.sharedManager().venues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("venueCell", forIndexPath: indexPath) as! UITableViewCell
        let venue = FoursquareManager.sharedManager().venues[indexPath.row]

        // Configure the cell...
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = venue.address
        cell.imageView?.sd_cancelCurrentAnimationImagesLoad
        cell.imageView?.sd_setImageWithURL(venue.categoryIconURL,
            placeholderImage: UIImage(named: "none"))

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
