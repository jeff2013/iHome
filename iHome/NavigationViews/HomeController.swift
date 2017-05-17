//
//  ViewController.swift
//  iHome
//
//  Created by Jeff Chang on 2017-05-01.
//  Copyright © 2017 Jeff Chang. All rights reserved.
//

import UIKit
import SWRevealViewController
import JTAppleCalendar

class HomeController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let outsideMonthColor = UIColor.lightGray
    let insideMonthColor = UIColor.white
    let selectedMonthColor = UIColor.black
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    var startDate: Date?
    var endDate: Date?
    var rangeSelected: Bool = false
    var dateSelected: Date?
    let formatter = DateFormatter()
    
    weak var delegate: DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "greyGradient.jpg")!)
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        setupCalendar()
    }
    
    private func setupCalendar(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: Date())
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        calendarView.deselectAllDates()
    }
    
    @IBAction func messageSubmitted(_ sender: Any) {
        if !(messageTextField.text?.isEmpty)! {
            messageLabel.text = messageTextField.text
            self.delegate?.didRecieveUpdate(data: messageTextField.text!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !(messageLabel.text?.isEmpty)! {
            delegate?.didRecieveUpdate(data: messageLabel.text!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    // Handles the date color for in/out month color and selected color.
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState, date: Date) {
        guard let validCell = cell as? CellView else { return }
        validCell.dayLabel.textColor = cellState.isSelected ? selectedMonthColor : cellState.dateBelongsTo == .thisMonth ? insideMonthColor : outsideMonthColor
        if !isValidDate(date: date) {
            validCell.dayLabel.textColor = outsideMonthColor
        }
    }
    
    /*
     * Takes in the selected date 
     * returns true if the date selected is after the current date
     * False otherwise
     */
    func isValidDate(date: Date) -> Bool {
        return Date() < date
    }
    
    //handle cell style
    /*
     * Resets cell frame 
     *
     */
    func handleCellStyle(cell: JTAppleCell?, cellState: CellState, date: Date) {
        guard let customCell = cell as? CellView else { return }
        //customCell.frame = CGRect(x: 0, y: 0, width: calendarView.frame.width/7, height: calendarView.frame.width/7)
        
        let selectedViewSize = CGFloat(customCell.frame.width * 0.8)
        
        //purely here to reset the frame (some edge cases where it would keep state)
        customCell.selectedView.frame = CGRect(x: 0, y: 0, width: selectedViewSize, height: selectedViewSize)
        customCell.selectedView.layer.cornerRadius = 0
        
        let frame = customCell.selectedView.frame
        let origin = (customCell.frame.width - frame.width)/2
        switch cellState.selectedPosition() {
        case .left:
            customCell.selectedView.frame = CGRect(x: origin, y: origin, width: selectedViewSize, height: selectedViewSize)
            customCell.selectedView.layer.cornerRadius = selectedViewSize/2
            customCell.rangeView.frame = CGRect(x: customCell.frame.width/2, y: origin, width: customCell.frame.width/2, height: selectedViewSize)
            customCell.dayLabel.center = customCell.selectedView.center
            customCell.rangeView.isHidden = false
            break
        case .middle:
            customCell.selectedView.frame = CGRect(x: frame.origin.x, y: origin, width: customCell.frame.width, height: selectedViewSize)
            customCell.selectedView.layer.cornerRadius = 0
            customCell.rangeView.isHidden = true
            customCell.dayLabel.center = customCell.selectedView.center
            break
        case .right:
            customCell.selectedView.frame = CGRect(x: origin, y: origin, width: selectedViewSize, height: selectedViewSize)
            customCell.selectedView.layer.cornerRadius = customCell.selectedView.frame.width/2
            customCell.rangeView.frame = CGRect(x: 0, y: origin, width: customCell.frame.width/2, height: selectedViewSize)
            customCell.rangeView.isHidden = false
            customCell.dayLabel.center = customCell.selectedView.center
            break
        default:
            customCell.selectedView.frame = CGRect(x: origin, y: origin, width: selectedViewSize, height: selectedViewSize)
            customCell.selectedView.layer.cornerRadius = selectedViewSize/2
            customCell.dayLabel.center = customCell.selectedView.center
            customCell.rangeView.isHidden = true
            break
        }
        handleCellTextColor(cell: cell, cellState: cellState, date: date)
    }
    
    //if cell is selected, custom selected view
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState) {
        guard let customCell = cell as? CellView else { return }
        customCell.selectedView.isHidden = !cellState.isSelected
        let frame = customCell.selectedView.frame
        customCell.selectedView.frame = CGRect(x: frame.midX-20, y: frame.midY - 20, width: 40, height: 40)
        customCell.selectedView.layer.cornerRadius = customCell.selectedView.frame.width/2
    }
    
    func cellSelected(cell: JTAppleCell?, cellState: CellState, date: Date) {
        guard let customCell = cell as? CellView else { return }
        
        if isValidDate(date: date) {
            switch cellState.selectedPosition() {
            case .full, .right, .left, .middle:
                if let startDate = startDate {
                    if startDate < date {
                        //start date is earlier than the end date so select all in between
                        endDate = date
                        customCell.selectedView.isHidden = false
                        calendarView.selectDates(from: startDate, to: endDate!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                        rangeSelected = true
                        setDate(for: endDateLabel, date: date)
                    } else {
                        // selected date is earlier than the start date
                        // replace start date with selected date
                        rangeSelected = false
                        calendarView.deselectDates(from: startDate)
                        self.startDate = date
                        
                        setDate(for: startDateLabel, date: date)
                        customCell.selectedView.isHidden = false
                    }
                } else {
                    startDate = date
                    customCell.selectedView.isHidden = false
                    setDate(for: startDateLabel, date: date)
                }
            default:
                if rangeSelected {
                    //If we deslect any cell inside the range we remove all selected dates in the range and select the clicked cell
                    //Also set startDate
                    rangeSelected = false
                    calendarView.deselectDates(from: startDate!, to: endDate!, triggerSelectionDelegate: false)
                    calendarView.selectDates([date], triggerSelectionDelegate:false, keepSelectionIfMultiSelectionAllowed: true)
                    startDate = date
                    setDate(for: startDateLabel, date: date)
                    endDateLabel.text = "N/A"
                } else {
                    //Random date has been deselected so we hide the selection
                    //Clear start and end date
                    customCell.selectedView.isHidden = true
                    startDate = nil
                    endDate = nil
                    startDateLabel.text = "N/A"
                    endDateLabel.text = "N/A"
                }
            }
        }
    }
    
    func setDate(for label: UILabel, date: Date) {
        formatter.dateFormat = "dd"
        label.text = formatter.string(from: date)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension HomeController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = Date()
        
        formatter.dateFormat = "YYYY"
        let year = Int(formatter.string(from: startDate))! + 10
        
        formatter.dateFormat = "yyy MM dd"
        let endDate = formatter.date(from : "2027 02 01")
        let parameters = ConfigurationParameters(startDate: Date(), endDate: endDate!, numberOfRows: 5, calendar: Calendar.current, generateInDates: InDateCellGeneration.forAllMonths, generateOutDates: OutDateCellGeneration.tillEndOfRow, firstDayOfWeek: DaysOfWeek.sunday, hasStrictBoundaries: true)
        return parameters
        
    }
}

extension HomeController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let customCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CellView
        customCell.dayLabel.text = cellState.text
        customCell.selectedView.isHidden = !cellState.isSelected
        handleCellStyle(cell: customCell, cellState: cellState, date: date)
        return customCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellStyle(cell: cell, cellState: cellState, date: date)
        cellSelected(cell: cell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellStyle(cell: cell, cellState: cellState, date: date)
        cellSelected(cell: cell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        monthLabel.text = dateFormatter.string(from: date)
    }
}
