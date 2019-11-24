//
//  UserDetailViewController.swift
//  FrogogoTestApp
//
//  Created by User on 11/23/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

extension UserDetailViewController {
    enum ScreenType {
        case create
        case show
        case edit
        
        var isEditing: Bool {
            switch self {
            case .show:
                return false
            default:
                return true
            }
        }
        
        var canBeNilProperties: Bool {
            switch self {
            case .edit:
                return true
            default:
                return false
            }
        }
    }
}

protocol UsersChangedDelegate: class {
    func usersDidUpdate(user: UserModel)
}

class UserDetailViewController: BaseViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var avatarTextField: UITextField!
    @IBOutlet weak var loadButton: UIButton!
    
    @IBOutlet weak var heightLoadAvatarViewConstraint: NSLayoutConstraint!
    
    var userModel: UserModel?
    weak var delegate: UsersChangedDelegate?
    
    private lazy var createUserModel: CreateUserModel = {
        return CreateUserModel(id: userModel?.id ?? CreateUserModel.newUser)
    }()
    
    var screenType: ScreenType = .create {
        didSet {
            guard isViewLoaded else { return }
            self.screenTypeDidChange(screenType: screenType)
        }
    }
    
    //MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatarImageView.borderWidth = 2
        self.avatarImageView.borderColor = .white
        
        self.screenTypeDidChange(screenType: self.screenType)
     
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.avatarTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.avatarImageView.cornerRadius = avatarImageView.frame.width / 2
    }
    
    //MARK: - Custom methods
    private func screenTypeDidChange(screenType: ScreenType) {
        self.firstNameTextField.isEnabled =  screenType.isEditing
        self.lastNameTextField.isEnabled =  screenType.isEditing
        self.emailTextField.isEnabled = screenType.isEditing
        self.heightLoadAvatarViewConstraint.constant = screenType.isEditing ? 100 : 0
        
        switch screenType {
        case .create:
            updateView(with: UserViewModel.generateViewModel(changedUser: createUserModel, user: nil))
            let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveUser(_:)))
            self.navigationItem.rightBarButtonItems = [save]
        case .edit:
            updateView(with: UserViewModel.generateViewModel(changedUser: createUserModel, user: userModel))
            let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveUser(_:)))
            let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(changeState(_:)))
            self.navigationItem.rightBarButtonItems = [cancel, save]
        case .show:
            updateView(with: UserViewModel.generateViewModel(changedUser: nil, user: userModel))
            let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeState(_:)))
            self.navigationItem.rightBarButtonItems = [edit]
        }
        self.view.layoutSubviews()
    }
    
    private func updateView(with user: UserViewModel) {
        self.firstNameTextField.text = user.firstName
        self.lastNameTextField.text = user.lastName
        self.emailTextField.text = user.email
        self.avatarTextField.text = user.avatarURL?.absoluteString
        
        guard let url = user.avatarURL else {
            self.avatarImageView.image = UIImage(named: "placeholder")
            return
        }
        self.avatarImageView.downloaded(from: url, contentMode: .scaleAspectFill) { (isSuccess) in
            guard !isSuccess else { return }
            self.avatarImageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func checkIsError() -> Bool {
        let states = createUserModel.isValid(canBeNil: screenType.canBeNilProperties)
        
        for (key, isValid) in states {
            switch key {
            case .firstName:
                firstNameTextField.setState(isValid: isValid)
            case .lastName:
                lastNameTextField.setState(isValid: isValid)
            case .email:
                emailTextField.setState(isValid: isValid)
            case .avatarStr:
                avatarTextField.setState(isValid: isValid)
            }
        }
        
        return !states.values.contains(false)
    }
    
    //MARK: - API Server
    func createOrEdit(createModel: CreateUserModel) {
        let completion: (UserModel?, Error?) -> Void = { [weak self] (response, error) in
            if let error = error {
                self?.showAlert(title: error.localizedDescription)
                return
            }
            
            guard let user = response else {
                self?.showAlert(title: "Undefined error")
                return
            }
            self?.delegate?.usersDidUpdate(user: user)
            DispatchQueue.main.async {
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self?.navigationController?.popViewController(animated: true)
                }
                let title = "User was create:\n\(user.description)"
                self?.showAlert(title: title, actions: [okAction], style: .alert)
            }
        }
        
        let wrappedUser = CreateUserWrapper(user: createModel)
        if self.screenType == .create {
            APIClient.createUser(user: wrappedUser, completion: completion)
        } else if self.screenType == .edit {
            guard wrappedUser.user.asAnyDictionary()?.keys.count ?? 0 > 0 else {
                self.showAlert(title: "You were don't any change in user")
                return
            }
            APIClient.updateUser(user: wrappedUser, completion: completion)
        }
    }
    
    //MARK: - Actions
    @IBAction func loadTempAvatarAction(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let url = createUserModel.avatarURL else {
            self.avatarImageView.image = UIImage(named: "placeholder")
            return
        }
        avatarImageView.downloaded(
            from: url,
            contentMode: .scaleAspectFill
        ) {[weak self] (isSuccess) in
            guard !isSuccess else { return }
            self?.avatarImageView.image = UIImage(named: "placeholder")
        }
    }
    
    @objc private func changeState(_ sender: Any) {
        self.view.endEditing(true)
        if screenType == .show {
            self.screenType = .edit
        } else if screenType == .edit {
            self.screenType = .show
        }
    }
    
    @objc private func saveUser(_ sender: Any) {
        self.view.endEditing(true)
        guard checkIsError() else {
            return
        }
        
        createOrEdit(createModel: createUserModel)
    }
}


extension UserDetailViewController: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        guard let text = textField.text,
            let textRange = Range(range, in: text) else {
            return true
        }
        let updatedText = text.replacingCharacters(in: textRange, with: string)

        textField.setState(isValid: true)
        
        switch textField {
        case firstNameTextField:
            self.createUserModel.firstName = updatedText
        case lastNameTextField:
            self.createUserModel.lastName = updatedText
        case emailTextField:
            self.createUserModel.email = updatedText
        case avatarTextField:
            self.createUserModel.avatarStr = updatedText
        default:
            print("undefined textfield")
        }
        
        return true
    }
}
