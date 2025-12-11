import UIKit
import SwiftUI
import Social
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    private let appGroupID = "group.luiz.dev.sleek"
    
    private var foundImage: UIImage? {
        didSet {
            updateRootView()
        }
    }

    private var hostingController: UIHostingController<ShareView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupUI()
        extractImageFromContext()
    }

    private func setupUI() {
        let swiftUIView = ShareView(
            image: foundImage,
            onSave: { [weak self] in self?.saveAndClose() },
            onCancel: { [weak self] in self?.cancelAndClose() }
        )
        
        let host = UIHostingController(rootView: swiftUIView)
        hostingController = host
        
        addChild(host)
        view.addSubview(host.view)
        
        host.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        host.didMove(toParent: self)
    }

    private func updateRootView() {
        hostingController?.rootView = ShareView(
            image: foundImage,
            onSave: { [weak self] in self?.saveAndClose() },
            onCancel: { [weak self] in self?.cancelAndClose() }
        )
    }

    private func extractImageFromContext() {
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else { return }

        for item in items {
            guard let attachments = item.attachments else { continue }

            if let provider = attachments.first(where: {
                $0.hasItemConformingToTypeIdentifier(UTType.image.identifier)
            }) {
                loadImage(from: provider)
                return
            }
        }
    }

    private func loadImage(from provider: NSItemProvider) {
        provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { [weak self] item, _ in
            guard let self else { return }
            
            let image: UIImage? = {
                if let url = item as? URL,
                   let data = try? Data(contentsOf: url) {
                    return UIImage(data: data)
                }
                return item as? UIImage
            }()
            
            if let image {
                DispatchQueue.main.async {
                    self.foundImage = image
                }
            }
        }
    }

    private func saveAndClose() {
        guard
            let image = foundImage,
            let data = image.jpegData(compressionQuality: 1.0),
            let containerURL = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: appGroupID
            )
        else { return }

        let fileURL = containerURL.appendingPathComponent("shared_screenshot.data")

        do {
            try data.write(to: fileURL)
            UserDefaults(suiteName: appGroupID)?
                .set(true, forKey: "has_new_shared_image")
        } catch {
            print("Erro ao salvar: \(error)")
        }

        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        openParentApp()
    }

    private func openParentApp() {
        guard let url = URL(string: "sleekapp://") else { return }

        var responder: UIResponder? = self
        while responder != nil {
            if let app = responder as? UIApplication {
                app.open(url)
                break
            }
            responder = responder?.next
        }
    }

    private func cancelAndClose() {
        let error = NSError(domain: "UserCancelled", code: 0)
        extensionContext?.cancelRequest(withError: error)
    }
}
