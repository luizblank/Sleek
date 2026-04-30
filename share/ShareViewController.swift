import UIKit
import SwiftUI
import Social
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    private let appGroupID = "group.luiz.dev.sleek"

    private var foundImages: [UIImage] = [] {
        didSet {
            updateRootView()
        }
    }

    private var isLoading: Bool = true {
        didSet {
            updateRootView()
        }
    }

    private var hostingController: UIHostingController<ShareView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupUI()
        extractImagesFromContext()
    }

    private func setupUI() {
        let host = UIHostingController(rootView: makeRootView())
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
        hostingController?.rootView = makeRootView()
    }

    private func makeRootView() -> ShareView {
        ShareView(
            images: foundImages,
            isLoading: isLoading,
            onSave: { [weak self] in self?.saveAndClose() },
            onCancel: { [weak self] in self?.cancelAndClose() }
        )
    }

    private func extractImagesFromContext() {
        guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            isLoading = false
            return
        }

        let providers: [NSItemProvider] = inputItems
            .compactMap { $0.attachments }
            .flatMap { $0 }
            .filter { $0.hasItemConformingToTypeIdentifier(UTType.image.identifier) }

        guard !providers.isEmpty else {
            isLoading = false
            return
        }

        let group = DispatchGroup()
        var collected: [(Int, UIImage)] = []
        let lock = NSLock()

        for (index, provider) in providers.enumerated() {
            group.enter()
            provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, _ in
                defer { group.leave() }

                let image: UIImage? = {
                    if let url = item as? URL,
                       let data = try? Data(contentsOf: url) {
                        return UIImage(data: data)
                    }
                    if let data = item as? Data {
                        return UIImage(data: data)
                    }
                    return item as? UIImage
                }()

                if let image {
                    lock.lock()
                    collected.append((index, image))
                    lock.unlock()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.foundImages = collected
                .sorted { $0.0 < $1.0 }
                .map { $0.1 }
            self.isLoading = false
        }
    }

    private func saveAndClose() {
        guard
            !foundImages.isEmpty,
            let containerURL = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: appGroupID
            )
        else { return }

        var savedCount = 0
        for (index, image) in foundImages.enumerated() {
            guard let data = image.jpegData(compressionQuality: 1.0) else { continue }
            let fileURL = containerURL.appendingPathComponent("shared_screenshot_\(index).data")
            do {
                try data.write(to: fileURL)
                savedCount += 1
            } catch {
                print("Erro ao salvar imagem \(index): \(error)")
            }
        }

        if savedCount > 0 {
            let defaults = UserDefaults(suiteName: appGroupID)
            defaults?.set(savedCount, forKey: "shared_image_count")
            defaults?.set(true, forKey: "has_new_shared_image")
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
