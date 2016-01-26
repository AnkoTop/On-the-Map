//
//  StatisticsViewController.swift
//  On The Map
//
//  Created by Anko Top on 23/04/15.
//  Copyright (c) 2015 Anko Top. All rights reserved.
//

import UIKit
import CoreLocation

class StatisticsViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label10: UILabel!
    @IBOutlet weak var label11: UILabel!
    @IBOutlet weak var label12: UILabel!
    @IBOutlet weak var label13: UILabel!
    @IBOutlet weak var label14: UILabel!
    @IBOutlet weak var label15: UILabel!
    @IBOutlet weak var label16: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateStatistics()
        
        // register for updates of the StudenLocation data
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStatistics", name: StudentLocationNotificationKey , object: nil)

    }

    func updateStatistics() {
        let newStats = AppStatistics()
        let statisticsDictionary = newStats.returnStatistics()
        
        //Headings
        let attributedStringLocations = NSAttributedString(string: "Student Locations", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
        let attributedStringHQ = NSAttributedString(string: "Distances to Udacity HQ", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
        let attributedStringURL = NSAttributedString(string: "URL's", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
        
        // text
        label1.attributedText = attributedStringLocations
        label2.text = "There are \(statisticsDictionary[AppStatistics.totalStudentLocations]!) locations registered,"
        label3.text = "added by \(statisticsDictionary[AppStatistics.totalUniqueStudents]!) different students."
        var end = "locations."
        if (Int(statisticsDictionary[AppStatistics.totalUserLocations]!)) == 1 {
          end = "location."
        }
        label4.text = "You have \(statisticsDictionary[AppStatistics.totalUserLocations]!) active \(end)"
        
        label5.text = " "
        
        label6.attributedText = attributedStringURL
        label7.text = "\(statisticsDictionary[AppStatistics.totalValidUrls]!) locations have a valid URL and"
        label8.text = "\(statisticsDictionary[AppStatistics.totalInvalidUrls]!) have invalid URL's."
        
        label9.text = " "
        
        label10.attributedText = attributedStringHQ
        label11.text = "The average distance is \(statisticsDictionary[AppStatistics.averageDistanceToUdacityHQ]!) km."
        label12.text = "The minimum distance is \(statisticsDictionary[AppStatistics.minDistanceToUdacityHQ]!) km,"
        label13.text = "added by \(statisticsDictionary[AppStatistics.nameMinDistanceToUdacityHQ]!)."
        label14.text = "The maximum is a whopping \(statisticsDictionary[AppStatistics.maxDistanceToUdacityHQ]!) km,"
        label15.text = "added by \(statisticsDictionary[AppStatistics.nameMaxDistanceToUdacityHQ]!)."
        
        label16.text = "---"
        
    }

}
