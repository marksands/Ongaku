import UIKit
import BrightFutures
import Result

protocol SearchViewProtocol: class {
    func textChanged(_ text: String)
    func indexSelected(_ index: Int)
}

class SearchView : UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var data: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: SearchViewProtocol?
    
    private let tableView = UITableView()
    private let textField = PaddedTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(textField)
        addSubview(tableView)
        
        textField.placeholder = "Search..."
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1 / UIScreen.main.scale
        textField.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let _textFieldText = textField.text else { return true }
        let textFieldText = _textFieldText as NSString
        let text = textFieldText.replacingCharacters(in: range, with: string) as NSString
        debounce(#selector(callTextDidChange(with:)), value: text, delay: 0.3)
        return true
    }
    
    func callTextDidChange(with text: String) {
        delegate?.textChanged(text)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 8
        let textFieldHeight: CGFloat = 44
        textField.frame = CGRect(x: margin, y: 64 + margin, width: bounds.width - margin * 2, height: textFieldHeight)
        tableView.frame = bounds.divided(atDistance: textField.frame.maxY + margin, from: .minYEdge).remainder
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.indexSelected(indexPath.row)
    }
}

extension NSObject {
    func debounce(_ selector: Selector, value: NSString, delay: TimeInterval) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(selector, with: value, afterDelay: delay)
    }
}
