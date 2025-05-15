//
//  Elec_TestTests.swift
//  Elec_TestTests
//
//  Created by Jameel Shammr on 28/10/2022.
//

import Combine
import XCTest

@testable import Elec_Test

final class Elec_TestTests: XCTestCase {
    var sut: CircularTimerViewModel!
    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
//        cancellables.removeAll()
//        sut.cancellable?.cancel()
//        sut = nil
        super.tearDown()
    }

    func testInitWithIntervalAndProgress() {
        // Given
        let interval: TimeInterval = 60.0  // 1 minute
        let initialProgress: CGFloat = 0.25

        // When
        sut = CircularTimerViewModel(
            interval: interval, progress: initialProgress)

        // Then
        XCTAssertEqual(sut.progress, initialProgress)
        XCTAssertEqual(
            sut.timerInterval, interval * (1 - initialProgress), accuracy: 0.001
        )
        XCTAssertEqual(
            sut.stepProgress, 0.25 / CGFloat(interval), accuracy: 0.0001)
        XCTAssertNotNil(sut.cancellable)
    }

    // MARK: - Time Formatting Tests

    func testTextFromTimeInterval_WithHoursMinutesAndSeconds() {
        // Given
        sut = CircularTimerViewModel(interval: 3661, progress: 0)

        // When
        let timeString = sut.textFromTimeInterval()

        // Then
        XCTAssertEqual(timeString, " 1 minute")
    }

    func testTextFromTimeInterval_WithMinutesOnly() {
        // Given
        sut = CircularTimerViewModel(interval: 120, progress: 0)

        // When
        let timeString = sut.textFromTimeInterval()

        // Then
        XCTAssertEqual(timeString, "2 m")
    }

    func testTextFromTimeInterval_WithSecondsOnly() {
        // Given
        sut = CircularTimerViewModel(interval: 45, progress: 0)

        // When
        let timeString = sut.textFromTimeInterval()

        // Then
        XCTAssertEqual(timeString, "45 s")
    }

    func testTimeStringFrom_WithSingularHour() {
        // Given
        sut = CircularTimerViewModel(interval: 3600, progress: 0)

        // When
        let timeString = sut.textFromTimeInterval()

        // Then
        XCTAssertEqual(timeString, "1 hour")
    }

    func testTimeStringFrom_WithPluralHours() {
        // Given
        sut = CircularTimerViewModel(interval: 7200, progress: 0)

        // When
        let timeString = sut.textFromTimeInterval()

        // Then
        XCTAssertEqual(timeString, "2 hours")
    }

    func testTimeStringFrom_WithSingularMinute() {
        // Given
        sut = CircularTimerViewModel(interval: 60, progress: 0)

        // When
        let timeString = sut.textFromTimeInterval()

        // Then
        XCTAssertEqual(timeString, "1 m")
    }

    func testTimeStringFrom_WithSingularSecond() {
        // Given
        sut = CircularTimerViewModel(interval: 1, progress: 0)

        // When
        let timeString = sut.textFromTimeInterval()

        // Then
        XCTAssertEqual(timeString, "1 s")
    }

    // MARK: - Timer Progress Tests

    func testTimerProgressUpdates() {
        // Given
        let expectation = XCTestExpectation(
            description: "Timer progress updates")
        let interval: TimeInterval = 1.0
        var progressValues: [CGFloat] = []

        // When
        sut = CircularTimerViewModel(interval: interval, progress: 0)

        sut.$progress
            .dropFirst()  // Skip initial value
            .sink { progress in
                progressValues.append(progress)
                if progress >= 1.0 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 2.0)

        // We expect at least 4 progress updates (0.25, 0.5, 0.75, 1.0)
        XCTAssertGreaterThanOrEqual(progressValues.count, 4)
        XCTAssertEqual(progressValues.last, 1.0)
    }

    func testTimerCancelsWhenProgressReachesOne() {
        // Given
        let expectation = XCTestExpectation(description: "Timer completes")
        let interval: TimeInterval = 1.0

        // When
        sut = CircularTimerViewModel(interval: interval, progress: 0)

        sut.$progress
            .filter { $0 >= 1.0 }
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 2.0)

        // Wait a bit more to ensure no more progress updates
        let noMoreUpdatesExpectation = XCTestExpectation(
            description: "No more updates")
        noMoreUpdatesExpectation.isInverted = true

        var moreUpdateReceived = false
        sut.$progress
            .dropFirst()  // Skip the current value
            .sink { _ in
                moreUpdateReceived = true
                noMoreUpdatesExpectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [noMoreUpdatesExpectation], timeout: 0.5)
        XCTAssertFalse(moreUpdateReceived)
    }

    func testTimerStopsWhenTimerIntervalReachesZero() {
        // Given
        let expectation = XCTestExpectation(
            description: "Timer interval reaches zero")
        let interval: TimeInterval = 1.0

        // When
        sut = CircularTimerViewModel(interval: interval, progress: 0)

        sut.$timerInterval
            .filter { $0 <= 0 }
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 2.0)
        XCTAssertLessThanOrEqual(sut.timerInterval, 0)
        XCTAssertEqual(sut.progress, 1.0)
    }

    // MARK: - Time Struct Tests

    func testTimeStructIntervalCalculation() {
        // Given
        let time1 = CircularTimerViewModel.Time(
            hours: 1, minutes: 30, seconds: 45)
        let time2 = CircularTimerViewModel.Time(
            hours: 0, minutes: 15, seconds: 30)
        let time3 = CircularTimerViewModel.Time(
            hours: 0, minutes: 0, seconds: 10)

        // When
        let interval1 = time1.interval
        let interval2 = time2.interval
        let interval3 = time3.interval

        // Then
        XCTAssertEqual(interval1, 5445.0, accuracy: 0.001)
        XCTAssertEqual(interval2, 930.0, accuracy: 0.001)
        XCTAssertEqual(interval3, 10.0, accuracy: 0.001)
    }

    func testStartWithHighInitialProgress() {
        // Given
        let interval: TimeInterval = 60.0
        let initialProgress: CGFloat = 0.9  // 90% complete

        // When
        sut = CircularTimerViewModel(
            interval: interval, progress: initialProgress)

        // Then
        XCTAssertEqual(sut.progress, initialProgress)
        XCTAssertEqual(sut.timerInterval, interval * 0.1, accuracy: 0.001)
    }

    func testStartWithFullProgress() {
        // Given
        let interval: TimeInterval = 60.0
        let initialProgress: CGFloat = 1.0  // 100% complete
        let expectation = XCTestExpectation(description: "No timer progress")
        expectation.isInverted = true

        // When
        sut = CircularTimerViewModel(
            interval: interval, progress: initialProgress)

        var progressUpdated = false
        sut.$progress
            .dropFirst()  // Skip initial value
            .sink { _ in
                progressUpdated = true
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertFalse(progressUpdated)
        XCTAssertEqual(sut.progress, 1.0)
        XCTAssertEqual(sut.timerInterval, 0.0, accuracy: 0.001)
    }
}
