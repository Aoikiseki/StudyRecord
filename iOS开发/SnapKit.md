> https://www.freecodecamp.org/news/how-to-use-snapkit-to-write-constraints-programmatically-for-ios-apps-ce0a6d9e76cf/

## 基本使用

- 通过`.snp.makeConstraints`创建约束

  ```swift
  username.snp.makeConstraints { (make) in
      make.height.equalTo(20)
      usernameWidth = make.width.equalTo(200).constraint
      usernameWidthOther = make.width.equalTo(150).constraint
      usernameWidth?.activate()
      usernameWidthOther?.deactivate()
      make.center.equalToSuperview()
  }
  ```

- 将constraint保存起来

  ```swift
  usernameWidth = make.width.equalTo(200).constraint
  usernameWidthOther = make.width.equalTo(150).constraint
  ```

- 对不同约束进行activate和deactivate

  ```swift
  usernameWidth?.activate()
  usernameWidthOther?.deactivate()
  ```

- 更新已存在约束，若不存在会报assertionFailure

  ```swift
  self.password.snp.updateConstraints { (make) in
  		make.width.equalTo(150)
  }
  ```

## 一个更新约束的小例子

```swift
class UserLoginViewController: UIViewController {
    let password = UITextField()
    let username = UITextField()
    
    var usernameWidth: Constraint?
    var usernameWidthOther: Constraint?
    var flag = false
    let button = UIButton()
    let label = UILabel()
    let bag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupActions()
    }
    
    func setupSubviews() {
        view.backgroundColor = .gray
        
        username.backgroundColor = .white
        view.addSubview(username)
        username.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            usernameWidth = make.width.equalTo(200).constraint
            usernameWidthOther = make.width.equalTo(150).constraint
            usernameWidth?.activate()
            usernameWidthOther?.deactivate()
            make.center.equalToSuperview()
        }
        
        password.backgroundColor = .white
        view.addSubview(password)
        password.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(username.snp.bottom).offset(20)
        }
        
        button.backgroundColor = .brown
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-140)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func setupActions() {
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.flag = !self.flag
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    guard let self = self else { return }
                    
                    if self.flag {
                        // 通过存储constraint
                        // 可以update、deactivate、acitvate
                        self.usernameWidth?.deactivate()
                        self.usernameWidthOther?.activate()
                        
                        // 通过updateConstraints更新指定约束
                        // 只能更新已有约束，如果更新没有的约束会fatal error
                        self.password.snp.updateConstraints { (make) in
                            make.width.equalTo(150)
                        }
                    } else {
                        self.usernameWidth?.activate()
                        self.usernameWidthOther?.deactivate()
                        
                        self.password.snp.updateConstraints { (make) in
                            make.width.equalTo(50)
                        }
                    }
                    
                    // 需要调用superview的layoutIfNeeded
                    self.view.layoutIfNeeded()
                })
            })
            .disposed(by: bag)
    }
}
```

