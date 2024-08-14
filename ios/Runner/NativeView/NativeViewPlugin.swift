public class NativeViewPlugin{
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = NativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "native_view")
    }
}