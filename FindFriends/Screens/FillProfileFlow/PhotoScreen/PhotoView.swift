//
//  PhotoView.swift
//  FindFriends
//
//  Created by Вадим Шишков on 05.04.2024.
//

import UIKit

protocol PhotoViewDelegate: AnyObject {
    func presentAlertController(_ actionSheet: UIAlertController)
    func presentImagePicker(_ imagePicker: UIImagePickerController)
    func dimsiss()
}

final class PhotoView: UIView {
    weak var delegate: PhotoViewDelegate?
    private let viewModel: PhotoViewModel
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
    }()
    
    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.font = .medium24
        label.textAlignment = .center
        label.text = "Фото профиля"
        return label
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.font = .regular16
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .standardGreyWireframe
        label.text = "Добавьте фото, чтобы другим было\n проще вас узнать"
        return label
    }()
    
    private lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "plugPhoto")
        view.tintColor = .lightGray
        view.layer.frame.size.height = 171
        view.contentMode = .center
        view.layer.frame.size.width = view.layer.frame.size.height
        view.layer.cornerRadius = view.bounds.height / 2
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.setImage(UIImage(named: "addPhoto"), for: .normal)
        button.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var continueButton: PrimeOrangeButton = {
        let button = PrimeOrangeButton(text: "Сохранить и продолжить")
        button.isEnabled = false
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пропустить", for: .normal)
        button.setTitleColor(.buttonBlack, for: .normal)
        button.titleLabel?.font = .semibold17
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var clearPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancelPhoto"), for: .normal)
        button.addTarget(self, action: #selector(clearPhotoTapped), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupLayout()
        updateUI()
        imagePickerController.delegate = self
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        if avatarView.image != UIImage(named: "plugPhoto") {
            continueButton.backgroundColor = .mainOrange
            continueButton.isEnabled = true
            avatarView.layer.borderWidth = 0
            clearPhotoButton.isHidden = false
            addPhotoButton.isHidden = true
            secondLabel.text = "Отлично! Все готово для поиска\n новых друзей"
        } else {
            continueButton.backgroundColor = .lightOrange
            continueButton.isEnabled = false
            avatarView.layer.borderWidth = 4
            clearPhotoButton.isHidden = true
            addPhotoButton.isHidden = false
            secondLabel.text = "Добавьте фото, чтобы другим было\n проще вас узнать"
        }
    }
    
    private func setupLayout() {
        [firstLabel, secondLabel, avatarView, addPhotoButton, continueButton, skipButton, clearPhotoButton].forEach(addSubviewWithoutAutoresizingMask(_:))
        
        NSLayoutConstraint.activate([
            firstLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            firstLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            firstLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 36),
            secondLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            secondLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 10),
            avatarView.topAnchor.constraint(equalTo: secondLabel.bottomAnchor, constant: 20),
            avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: avatarView.frame.width),
            avatarView.heightAnchor.constraint(equalToConstant: avatarView.frame.height),
            clearPhotoButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor, constant: -60),
            clearPhotoButton.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor, constant: 60),
            addPhotoButton.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: -25),
            addPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            skipButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -38),
            skipButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 48),
            continueButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -10),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            continueButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            continueButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc private func addPhotoTapped() {
        showImagePickerControleActionSheet()
    }
    
    @objc private func continueButtonTapped() {
        viewModel.avatarIsSelect(true)
    }
    
    @objc private func skipButtonTapped() {
        viewModel.avatarIsSelect(false)
    }
    
    @objc private func clearPhotoTapped() {
        deleteImage()
    }
}

extension PhotoView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func showImagePickerControleActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { [unowned self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                delegate?.presentImagePicker(imagePickerController)
            } else {
                print("Камера недоступна")
            }
        }
        
        let libraryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { [unowned self] _ in
            imagePickerController.sourceType = .photoLibrary
            delegate?.presentImagePicker(imagePickerController)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        delegate?.presentAlertController(actionSheet)
    }
    
    func saveImage(_ image: UIImage) {
        guard let data = image.pngData() else { return }
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageUrl = documentsURL.appendingPathComponent("avatar.png")
        do {
            try data.write(to: imageUrl)
            updateUI()
        } catch {
            updateUI()
        }
    }
    
    func deleteImage() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageUrl = documentsURL.appendingPathComponent("avatar.png")
        do {
            try fileManager.removeItem(at: imageUrl)
            avatarView.image = UIImage(named: "plugPhoto")
            updateUI()
        } catch {
            updateUI()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            saveImage(editedImage)
            avatarView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarView.image = originalImage
            saveImage(originalImage)
        }
        updateUI()
        delegate?.dimsiss()
    }
}
