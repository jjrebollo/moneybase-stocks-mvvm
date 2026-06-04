import Foundation

class BaseUseCase<Output> {
    func execute() async throws -> Output {
        fatalError("Subclasses must override execute()")
    }
}

class BaseInputUseCase<Input, Output> {
    func execute(_ input: Input) async throws -> Output {
        fatalError("Subclasses must override execute(_:)")
    }
}