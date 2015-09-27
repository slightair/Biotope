import Foundation
import RxSwift

class GameScenePaceMaker {
    static let defaultPaceMaker = GameScenePaceMaker()

    let interval = 0.5
    var previousTime: CFTimeInterval = kCFAbsoluteTimeIntervalSince1970

    let update = PublishSubject<CFTimeInterval>()
    let pace = PublishSubject<CFTimeInterval>()

    func knock(currentTime: CFTimeInterval) {
        update.on(.Next(currentTime))

        let firstKnock = (previousTime == kCFAbsoluteTimeIntervalSince1970)
        if firstKnock {
            previousTime = currentTime / interval * interval
            return
        }

        while currentTime > previousTime + interval {
            previousTime += interval

            pace.on(.Next(previousTime))
        }
    }
}