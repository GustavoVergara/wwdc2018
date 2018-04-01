import Foundation

open class DelayOperation: Operation {
    private var _executing = false {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
        }
        didSet {
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    private var _finished = false {
        willSet {
            self.willChangeValue(forKey: "isFinished")
        }
        didSet {
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    private let delayInSeconds: TimeInterval
    
    public init(_ delayInSeconds: TimeInterval) {
        self.delayInSeconds = delayInSeconds
        super.init()
    }
    
    open override func cancel() {
        super.cancel()
        finish()
    }
    
    open override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        _executing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds, execute: { [weak self] in
            
            // If we were cancelled, then finish() has already been called.
            if self?.isCancelled == false {
                self?.finish()
            }
        })
    }
    
    func finish() {
        _executing = false
        _finished = true
    }
    
    override open var isExecuting: Bool {
        return _executing
    }
    
    override open var isFinished: Bool {
        return _finished
    }
}
