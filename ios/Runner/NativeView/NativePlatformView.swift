public class NativePlatformView: NSObject, FlutterPlatformView{
    private var _view: UIView
    private var _channel: FlutterMethodChannel

    init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        _view = UIView()
        _channel = FlutterMethodChannel(name: "native_view_\(viewId)", binaryMessenger: messenger)
        super.init()
        self.setupNativeView()
        self.setupChannel()
    }

    private func setupNativeView(){
        _view.backgroundColor = UIColor.white

        // Label
        let label = UILabel()
        label.text = "Native Text"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        // Button
        let button = UIButton()
        button.setTitle("Native Button", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        // Subviews
        _view.addSubview(label)
        _view.addSubview(button)

        // Constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: _view.topAnchor),
            label.leadingAnchor.constraint(equalTo: _view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: _view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: button.topAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),

            button.topAnchor.constraint(equalTo: label.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: _view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: _view.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: _view.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupChannel(){
        _channel.setMethodCallHandler{ [weak self] call, result in
            guard let self = self else { return }
            
            switch call.method {
            case "toNative":
                if let text = call.arguments as? String {
                    self.setText(text: text)
                    result("success")
                } else {
                    result(FlutterError(code: "Invalid Argument", message: "Invalid argument", details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }}
    }

    private func setText(text: String){
        for view in _view.subviews {
            if let label = view as? UILabel {
                label.text = text
            }
        }
    }

    @objc func buttonPressed(){
        _channel.invokeMethod("onFromNative", arguments: "Native Text")
    }

    public func view() -> UIView {
        return _view
    }
}
