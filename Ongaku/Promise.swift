import Foundation

public enum PromiseResult<T> {
    case evaluating
    case success(T)
    case failure(Error)
    
    public var value: T? {
        guard case .success(let t) = self else { return nil }
        return t
    }
}

extension PromiseResult where T : Equatable {
    public static func ==(lhs: PromiseResult<T>, rhs: PromiseResult<T>) -> Bool {
        switch (lhs, rhs) {
        case (.evaluating, .evaluating): return true
        case (.success(let left), .success(let right)): return left == right
        case (.failure(_), .failure(_)): return true
        default: return false
        }
    }
}

public class Promise<T> {
    public typealias FulfillType = (T) -> ()
    public typealias RejectType = (Error) -> ()
    
    private let queue = DispatchQueue.global()
    
    private var result = PromiseResult<T>.evaluating
    private var fulfillCallbacks: [FulfillType] = []
    private var rejectCallbacks: [RejectType] = []
    
    public init(work: @escaping (@escaping FulfillType, @escaping RejectType)->()) {
        queue.async {
            work(self.fulfill, self.reject)
        }
    }
    
    public init(value: T) {
        result = .success(value)
        maybeExecuteCallbacks()
    }
    
    public var value: PromiseResult<T> {
        return result
    }
    
    private func fulfill(_ value: T) {
        result = .success(value)
        maybeExecuteCallbacks()
    }
    
    private func reject(_ error: Error) {
        result = .failure(error)
        maybeExecuteCallbacks()
    }
    
    @discardableResult
    public func flatMap<U>(_ onFulfilled: @escaping (T) -> (Promise<U>)) -> Promise<U> {
        return Promise<U>(work: { (fulfill, reject) in
            self.enqueueCallback(
                onFulfilled: { value in
                    _ = onFulfilled(value).then(fulfill, reject)
            },
                onRejected: reject
            )
        })
    }
    
    @discardableResult
    public func map<U>(_ onFulfilled: @escaping (T) -> (U)) -> Promise<U> {
        return flatMap({ value -> Promise<U> in
            return Promise<U>(value: onFulfilled(value))
        })
    }
    
    @discardableResult
    public func mapError(_ onRejected: @escaping (Error) -> ()) -> Promise<T> {
        return Promise<T>(work: { (_, reject) in
            self.enqueueCallback(onRejected: { error in
                reject(error)
                onRejected(error)
            })
        })
    }
    
    @discardableResult
    private func then(_ onFulfilled: @escaping FulfillType, _ onRejected: @escaping RejectType = { _ in }) -> Promise<T> {
        return Promise<T>(work: { (fulfill, reject) in
            self.enqueueCallback(onFulfilled: { value in
                fulfill(value)
                onFulfilled(value)
            }, onRejected: { error in
                reject(error)
                onRejected(error)
            })
        })
    }
    
    private func enqueueCallback(onFulfilled: @escaping FulfillType = { _ in }, onRejected: @escaping RejectType = { _ in }) {
        fulfillCallbacks.append(onFulfilled)
        rejectCallbacks.append(onRejected)
        maybeExecuteCallbacks()
    }
    
    private func maybeExecuteCallbacks() {
        switch result {
        case .success(let value):
            fulfillCallbacks.forEach { $0(value) }
            fulfillCallbacks.removeAll()
        case .failure(let error):
            rejectCallbacks.forEach { $0(error) }
            rejectCallbacks.removeAll()
        case .evaluating: break
        }
    }
}
