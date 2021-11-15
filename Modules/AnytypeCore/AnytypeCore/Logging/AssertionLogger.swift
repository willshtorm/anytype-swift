public protocol MessageLogger {
    func log(_ message: String)
}

public final class AssertionLogger {
    public static var shared: MessageLogger?
}