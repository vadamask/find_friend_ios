import UIKit

final class PhotoViewController: UIViewController {
    private let photoView: PhotoView
    
    init(photoView: PhotoView) {
        self.photoView = photoView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = photoView
        photoView.delegate = self
    }
}

extension PhotoViewController: PhotoViewDelegate {
    func presentAlertController(_ actionSheet: UIAlertController) {
        present(actionSheet, animated: true)
    }
    
    func presentImagePicker(_ imagePicker: UIImagePickerController) {
        present(imagePicker, animated: true)
    }
    
    func dimsiss() {
        dismiss(animated: true)
    }
}


