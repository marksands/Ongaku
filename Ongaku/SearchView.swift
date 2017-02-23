import UIKit
import RxSwift

class SearchView : UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let textEvents: Observable<String>
    let selectionEvents: Observable<Int>
    let data: AnyObserver<[String]>
    
    private let _selectionEvents = PublishSubject<Int>()
    private let _data = BehaviorSubject<[String]>(value: [])
    private let _textEvents = PublishSubject<String>()
    
    private let tableView = UITableView()
    private let textField = PaddedTextField()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        textEvents = _textEvents.debounce(0.3, scheduler: MainScheduler.instance)
        selectionEvents = _selectionEvents.asObservable()
        data = _data.asObserver()
        
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(textField)
        addSubview(tableView)
        
        textField.placeholder = "Search..."
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1 / UIScreen.main.scale
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        _data.asObservable().subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let _textFieldText = textField.text else { return true }
        let textFieldText = _textFieldText as NSString
        let text = textFieldText.replacingCharacters(in: range, with: string) as NSString
        _textEvents.onNext(text as String)
        return true
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
        if let value = try? _data.value() {
            return value.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
        if let value = try? _data.value() {
            cell.textLabel?.text = value[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectionEvents.onNext(indexPath.row)
    }
}
