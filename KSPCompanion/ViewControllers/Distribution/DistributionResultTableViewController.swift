//
//  DistributionResultTableViewController.swift
//  KSPCompanion
//
//  Created by Thomas Durand on 24/09/2015.
//  Copyright © 2015 Thomas Durand. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DistributionResultTableViewController: UITableViewController, DZNEmptyDataSetSource {
    var results: (targetOrbit: Orbit, transferOrbit: Orbit, nSat: Int, deltaV: Double)?
    
    func prepare(_ results: (targetOrbit: Orbit, transferOrbit: Orbit, nSat: Int, deltaV: Double)) {
        self.results = results
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.allowsSelection = false
        
        self.tableView.tableFooterView = UIView()
        
        if self.navigationController != nil {
            self.navigationController!.topViewController!.title = NSLocalizedString("DISTRIBUTION_RESULT", comment: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if results != nil {
            return 3
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("TARGET_ORBIT", comment: "")
        case 1:
            return NSLocalizedString("TRANSIT_ORBIT", comment: "")
        case 2:
            return NSLocalizedString("ESTIMATED_DV", comment: "")
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("TARGET_ORBIT_FOOTER", comment: "")
        case 1:
            return NSLocalizedString("TRANSIT_ORBIT_FOOTER", comment: "")
        case 2:
            return NSLocalizedString("ESTIMATED_DV_FOOTER", comment: "")
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistributionResultCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel!.text = NSLocalizedString("ALTITUDE", comment: "")
                cell.detailTextLabel!.text = "\(Units.lengthUnit(results!.targetOrbit.apoapsisAltitude, allowSubUnits: true))"
            case 1:
                cell.textLabel!.text = NSLocalizedString("ORBITAL_PERIOD", comment: "")
                cell.detailTextLabel!.text = "\(Units.timeUnit(results!.targetOrbit.orbitalPeriod))"
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                if results!.transferOrbit.apoapsis == results!.targetOrbit.apoapsis {
                    cell.textLabel!.text = NSLocalizedString("TARGET_PERIAPSIS", comment: "")
                    cell.detailTextLabel!.text = "\(Units.lengthUnit(results!.transferOrbit.periapsisAltitude, allowSubUnits: true))"
                } else {
                    cell.textLabel!.text = NSLocalizedString("TARGET_APOAPSIS", comment: "")
                    cell.detailTextLabel!.text = "\(Units.lengthUnit(results!.transferOrbit.apoapsisAltitude, allowSubUnits: true))"
                }
            case 1:
                cell.textLabel!.text = NSLocalizedString("ORBITAL_PERIOD", comment: "")
                cell.detailTextLabel!.text = "\(Units.timeUnit(results!.transferOrbit.orbitalPeriod))"
            case 2:
                if results!.transferOrbit.apoapsis == results!.targetOrbit.apoapsis {
                    cell.textLabel!.text = NSLocalizedString("RETROGRADE_DV", comment: "")
                } else {
                    cell.textLabel!.text = NSLocalizedString("PROGRADE_DV", comment: "")
                }
                cell.detailTextLabel!.text = "\(results!.deltaV.format(1)) m/s"
            default:
                break
            }
        case 2:
            let globalDeltaV = 2 * (Double(results!.nSat)-1) * results!.deltaV
            
            cell.textLabel!.text = NSLocalizedString("TOTAL_DV", comment: "")
            cell.detailTextLabel!.text = "\(globalDeltaV.format(1)) m/s"
        default:
            break
        }
        
        return cell
    }
    
    // MARK: DZNEmptyDataSetSource
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = NSLocalizedString("DISTRIBUTE_SATELLITES", comment: "")
        
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.darkGray]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = NSLocalizedString("DISTRIBUTE_SATELLITES_DESC", comment: "")
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.lightGray,
            NSParagraphStyleAttributeName: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
