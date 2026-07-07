import XCTest
@testable import Spindle

@MainActor
final class SpindleTests: XCTestCase {
    var store: Store!

    override func setUp() async throws {
        store = Store()
        store.items = []
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(SpinSession())
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let item = SpinSession()
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(where: { $0.id == item.id }))
    }

    func testCanAddMoreWhenBelowLimit() {
        store.items = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenNotPro() {
        store.isPro = false
        store.items = (0..<Store.freeLimit).map { _ in SpinSession() }
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProRegardlessOfLimit() {
        store.isPro = true
        store.items = (0..<(Store.freeLimit + 5)).map { _ in SpinSession() }
        XCTAssertTrue(store.canAddMore)
    }

    func testFreeLimitAboveSeedDataCount() {
        XCTAssertGreaterThan(Store.freeLimit, Store.seedData.count)
    }

    func testUpdateModifiesExistingItem() {
        var item = SpinSession()
        store.add(item)
        item.fiberSource = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.fiberSource, "Updated")
    }

    func testSaveAndLoadRoundTrip() {
        store.items = [SpinSession()]
        store.save()
        let reloaded = Store()
        XCTAssertFalse(reloaded.items.isEmpty)
    }
}
