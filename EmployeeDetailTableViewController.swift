
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewControllerDelegate {
    func selectEmployeeTypeTableViewController(_ controller: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType) {
        self.employeeType = employeeType
        updateEmployeeType()
    }
    
    var employeeType: EmployeeType?

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    
    let dobDatePickerCellIndexPath = IndexPath(row: 2, section: 0)
    let dobDatePickerLabelIndexPath = IndexPath(row: 1, section: 0)
    
    var isEditingBirthday = false
    var isDobDatePickerVisible: Bool = false {
        didSet {
            //isEditingBirthday.toggle()
            dobDatePicker.isHidden = !isDobDatePickerVisible
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    
    var employee: Employee?
    
    
    func updateEmployeeType() {
        if let employeeType = employeeType {
            employeeTypeLabel.text = employeeType.description
            employeeTypeLabel.textColor = .black
        } else {
            employeeTypeLabel.text = "Not set"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
        updateEmployeeType()
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }
        guard let employeeType = employeeType else { return }
        let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: employeeType)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == dobDatePickerCellIndexPath && isEditingBirthday == false {
            return 0
        } else if indexPath == dobDatePickerCellIndexPath && isEditingBirthday == true {
            return 190
        } else {
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         tableView.deselectRow(at: indexPath, animated: true)
         let roomType = RoomType.all[indexPath.row]
         self.roomType = roomType
         delegate?.selectRoomTypeTableViewController(self, didSelect: roomType)
         tableView.reloadData()
         */
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == dobDatePickerLabelIndexPath {
            isDobDatePickerVisible.toggle() //= true
            isEditingBirthday.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
            if dobLabel.text == nil {
                dobLabel.textColor = .label
                dobLabel.text = dobDatePicker.date.formatted(date: .numeric, time: .omitted)
            }
        }
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        dobLabel.text = dobDatePicker.date.formatted(date: .numeric, time: .omitted)
    }
    /*
     @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
         let selectRoomTypeController =
                SelectRoomTypeTableViewController(coder: coder)
             selectRoomTypeController?.delegate = self
             selectRoomTypeController?.roomType = roomType
         
         return selectRoomTypeController
     */
    
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
        let employeeTypeTableViewController = EmployeeTypeTableViewController(coder: coder)
        employeeTypeTableViewController?.employeeTypeDelegate = self
        employeeTypeTableViewController?.employeeType = employeeType
        return employeeTypeTableViewController
    }
    
    
}
