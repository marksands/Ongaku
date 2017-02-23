import UIKit
import RxSwift
import RxSugar

class SearchView : UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let textEvents: Observable<String>
    let selectionEvents: Observable<Int>
    let data: AnyObserver<[String]>
    
    private let _selectionEvents = PublishSubject<Int>()
    private let _data = Variable<[String]>([])
    
    private let tableView = UITableView()
    private let textField = PaddedTextField()
    
    override init(frame: CGRect) {
        textEvents = textField.rxs.text.asObservable().debounce(0.3, scheduler: MainScheduler.instance)
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
        
        rxs.disposeBag
            ++ tableView.rxs.reloadData <~ _data.asObservable().toVoid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return _data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = _data.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectionEvents.onNext(indexPath.row)
    }
}
