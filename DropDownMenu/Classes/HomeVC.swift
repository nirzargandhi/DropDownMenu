//
//  HomeVC.swift
//  DropDownMenu
//
//  Created by Nirzar Gandhi on 18/05/25.
//

import UIKit

struct HomeTableTag {
    
    static let MenuOptionTag = 0
    static let DropdownTag = 1
}

class HomeVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var dropDownContainer: UIView!
    @IBOutlet weak var dropDownTitleLabel: UILabel!
    @IBOutlet weak var dropdownArrow: UIImageView!
    @IBOutlet weak var dropDownBtn: UIButton!
    
    
    // MARK: - Properties
    fileprivate var popover: Popover?
    fileprivate var menuPopover: Popover?
    
    fileprivate lazy var menuOptions = ["Add",
                                        "Edit",
                                        "Delete",
                                        "View"]
    
    fileprivate lazy var selectedDropDownIndex = 0
    fileprivate lazy var selectedDropDownTitle = ""
    
    
    // MARK: -
    // MARK: - View init Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        self.setControlsProperty()
        self.addRightNavBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.popover?.dismiss()
        self.menuPopover?.dismiss()
    }
    
    fileprivate func setControlsProperty() {
        
        self.view.backgroundColor = .black
        self.view.isOpaque = false
        
        // DropDown Container
        self.dropDownContainer.backgroundColor = .clear
        self.dropDownContainer.addRadiusWithBorder(radius: 10)
        self.dropDownContainer.applyBorderWidth()
        self.dropDownContainer.layer.borderColor = UIColor(hex: "#FFFFFF").cgColor
        self.dropDownContainer.clipsToBounds = true
        
        // DropDown Title Label
        self.dropDownTitleLabel.backgroundColor = .clear
        self.dropDownTitleLabel.textColor = .white
        self.dropDownTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.dropDownTitleLabel.numberOfLines = 1
        self.dropDownTitleLabel.adjustsFontSizeToFitWidth = true
        self.dropDownTitleLabel.textAlignment = .left
        self.dropDownTitleLabel.text = "Select option"
        
        // DropDown Button
        self.dropDownBtn.backgroundColor = .clear
        
        // Dropdown Arrow
        self.dropdownArrow.image = UIImage(named: "DownArrowWhite")
    }
}


// MARK: - Call back
extension HomeVC {
    
    fileprivate func addRightNavBarButton() {
        
        if !self.menuOptions.isEmpty {
            
            let menuBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
            menuBtn.showsTouchWhenHighlighted = false
            menuBtn.adjustsImageWhenHighlighted = false
            menuBtn.adjustsImageWhenDisabled = false
            menuBtn.setImage(UIImage(named: "MenuDots"), for: .normal)
            menuBtn.addTarget(self, action: #selector(self.menuOptionsBtnTouch(_:)), for: .touchUpInside)
            
            self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: menuBtn)], animated: true)
        } else {
            self.navigationItem.rightBarButtonItems = nil
        }
    }
    
    fileprivate func openMenuOptions(sender: UIButton) {
        
        var width = [Int]()
        let height = self.menuOptions.count * 41
        
        for i in 0..<self.menuOptions.count {
            let size = getTextWidth(text: self.menuOptions[i], font: UIFont.systemFont(ofSize: 16, weight: .semibold))
            width.append(Int(size.width) + 32)
        }
        
        var maxWidth = width.max() ?? 0
        maxWidth = (maxWidth > Int(SCREENWIDTH - 40)) ? (Int(SCREENWIDTH - 40)) : maxWidth
        
        let popoverview = UIView(frame: CGRect(x: 0, y: 0, width: maxWidth, height: height))
        popoverview.backgroundColor = UIColor(hex: "#1E1E1E")
        popoverview.addRadiusWithBorder(radius: 10)
        
        let menuTableView = UITableView(frame: CGRect(x: 0, y: 10, width: maxWidth, height: height))
        
        if #available(iOS 15.0, *) {
            menuTableView.sectionHeaderTopPadding = 0.0
        }
        
        popoverview.addSubview(menuTableView)
        
        menuTableView.backgroundColor = UIColor(hex: "#1E1E1E")
        menuTableView.tag = HomeTableTag.MenuOptionTag
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .none
        menuTableView.addRadiusWithBorder(radius: 10)
        menuTableView.isScrollEnabled = false
        
        let options: [PopoverOption] = [.color(UIColor(hex: "#1E1E1E")), .blackOverlayColor(UIColor.black.withAlphaComponent(0.5)), .animationIn(0.5), .type(.down)]
        self.menuPopover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        
        let startPoint = CGPoint(x: SCREENWIDTH - 31, y: getNavBarHeight + STATUSBARHEIGHT - 11)
        self.menuPopover?.show(popoverview, point: startPoint)
    }
    
    fileprivate func openDropDown(_ sender: UIButton) {
        
        let scrollInset = SCREENHEIGHT - dropDownContainer.frame.maxY
        var height = CGFloat(self.menuOptions.count * 41)
        var isScrollable = false
        
        if height >= scrollInset {
            height = scrollInset - 20.0
            isScrollable = true
        }
        
        self.dropdownArrow.image = UIImage(named: "UpArrowWhite")
        
        let popoverview = UIView(frame: CGRect(x: 20, y: 0, width: Int(SCREENWIDTH - 40), height: Int(height)))
        popoverview.backgroundColor = UIColor(hex: "#1E1E1E")
        popoverview.addRadiusWithBorder(radius: 10)
        
        let menuTableView = UITableView(frame: CGRect(x: 20, y: 0, width: Int(SCREENWIDTH - 40), height: Int(height)))
        popoverview.addSubview(menuTableView)
        menuTableView.backgroundColor = UIColor(hex: "#1E1E1E")
        menuTableView.tag = HomeTableTag.DropdownTag
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .none
        menuTableView.addRadiusWithBorder(radius: 5)
        menuTableView.isScrollEnabled = isScrollable
        
        let options: [PopoverOption] = [.color(UIColor(hex: "#1E1E1E")), .blackOverlayColor(UIColor.black.withAlphaComponent(0.5)), .arrowSize(.zero), .animationIn(0.5), .type(.down)]
        self.popover = Popover(options: options, showHandler: nil, dismissHandler: {
            self.dropdownArrow.image = UIImage(named: "DownArrowWhite")
        })
        self.popover?.show(popoverview, fromView: sender)
    }
}


// MARK: - Button Touch & Action
extension HomeVC {
    
    @objc fileprivate func menuOptionsBtnTouch(_ sender: UIButton) {
        self.openMenuOptions(sender: sender)
    }
    
    @IBAction func dropdownBtnTouch(_ sender: UIButton) {
        self.openDropDown(sender)
    }
}


// MARK: -
// MARK: - UITableView DataSource
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.className) as? MenuCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed(MenuCell.className, owner: self, options: nil)
            cell = nib![0] as? MenuCell
        }
        
        let isSelected = (self.selectedDropDownIndex == indexPath.row) ? true : false
        let isSeparatorHide = (indexPath.row < (self.menuOptions.count - 1)) ? false : true
        
        cell?.configureCell(item: self.menuOptions[indexPath.row], isSeparatorHide: isSeparatorHide, isSelected: isSelected)
        
        return cell!
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == HomeTableTag.MenuOptionTag {
            
            self.menuPopover?.dismiss()
            print("Menu Popover: \(self.menuOptions[indexPath.row])")
            
        } else if tableView.tag == HomeTableTag.DropdownTag {
            
            if self.selectedDropDownIndex == indexPath.row {
                self.popover?.dismiss()
                return
            }
            
            self.dropdownArrow.image = UIImage(named: "DownArrowWhite")
            
            self.selectedDropDownIndex = indexPath.row
            self.dropDownTitleLabel.text = self.menuOptions[self.selectedDropDownIndex]
            
            self.popover?.dismiss()
        }
    }
}
