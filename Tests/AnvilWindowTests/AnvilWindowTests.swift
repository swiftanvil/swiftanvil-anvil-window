import Foundation
import SwiftUI
import Testing
@testable import AnvilWindow

@Suite("AnvilWindow")
struct AnvilWindowTests {

    @Test("WindowFrame is Codable")
    func windowFrameCodable() throws {
        let frame = WindowFrame(x: 10, y: 20, width: 300, height: 400)
        let data = try JSONEncoder().encode(frame)
        let decoded = try JSONDecoder().decode(WindowFrame.self, from: data)

        #expect(decoded == frame)
    }

    @Test("WindowStateSnapshot is Codable")
    func windowStateSnapshotCodable() throws {
        let snapshot = WindowStateSnapshot(
            id: "inspector",
            frame: WindowFrame(x: 0, y: 0, width: 200, height: 300),
            isVisible: true,
            level: 3
        )
        let data = try JSONEncoder().encode(snapshot)
        let decoded = try JSONDecoder().decode(WindowStateSnapshot.self, from: data)

        #expect(decoded == snapshot)
    }

    @Test("WindowState captures and restores snapshot")
    func windowStateCaptureRestore() async throws {
        let state = AnvilWindowState()
        let snapshot = WindowStateSnapshot(
            id: "test",
            frame: WindowFrame(x: 100, y: 200, width: 400, height: 500),
            isVisible: false,
            level: 5
        )

        await state.restore(from: snapshot)
        let captured = await state.capture(id: "test")

        #expect(captured == snapshot)
    }

    @Test("WindowState clear removes snapshot")
    func windowStateClear() async throws {
        let state = AnvilWindowState()
        let snapshot = WindowStateSnapshot(
            id: "test",
            frame: WindowFrame(x: 0, y: 0, width: 100, height: 100),
            isVisible: true,
            level: 0
        )

        await state.restore(from: snapshot)
        await state.clear(id: "test")
        let captured = await state.capture(id: "test")

        #expect(captured == nil)
    }

    @Test("WindowState clearAll removes all snapshots")
    func windowStateClearAll() async throws {
        let state = AnvilWindowState()
        await state.restore(from: WindowStateSnapshot(id: "a", frame: WindowFrame(x: 0, y: 0, width: 1, height: 1), isVisible: true, level: 0))
        await state.restore(from: WindowStateSnapshot(id: "b", frame: WindowFrame(x: 0, y: 0, width: 1, height: 1), isVisible: true, level: 0))

        await state.clearAll()

        #expect(await state.capture(id: "a") == nil)
        #expect(await state.capture(id: "b") == nil)
    }

    @Test("WindowState captureAll returns all snapshots")
    func windowStateCaptureAll() async throws {
        let state = AnvilWindowState()
        let snapA = WindowStateSnapshot(id: "a", frame: WindowFrame(x: 0, y: 0, width: 1, height: 1), isVisible: true, level: 0)
        let snapB = WindowStateSnapshot(id: "b", frame: WindowFrame(x: 0, y: 0, width: 2, height: 2), isVisible: false, level: 1)

        await state.restore(from: snapA)
        await state.restore(from: snapB)
        let all = await state.captureAll()

        #expect(all.count == 2)
    }

    @Test("WindowController tracks window IDs")
    func windowControllerTrack() async throws {
        let controller = AnvilWindowController()

        await controller.showWindow(id: "win1")
        await controller.showWindow(id: "win2")

        let tracked = await controller.trackedWindowIDs
        #expect(tracked.contains("win1"))
        #expect(tracked.contains("win2"))
    }

    @Test("WindowController close removes tracking")
    func windowControllerClose() async throws {
        let controller = AnvilWindowController()

        await controller.showWindow(id: "win1")
        await controller.closeWindow(id: "win1")

        let tracked = await controller.trackedWindowIDs
        #expect(!tracked.contains("win1"))
    }

    @Test("AnvilPanel can be instantiated")
    func panelCreation() {
        let panel = AnvilPanel("Test", id: "test") {
            Text("Hello")
        }
        .floating(true)
        .resizable(false)
        .defaultSize(width: 200, height: 300)

        // Just verify it compiles and modifiers chain
        #expect(true)
    }

    @Test("AnvilHUD can be instantiated")
    func hudCreation() {
        let hud = AnvilHUD("Test") {
            Text("Hello")
        }
        .autoDismiss(after: 2.0)

        // Just verify it compiles and modifiers chain
        #expect(true)
    }

    @Test("WindowFrame equality")
    func windowFrameEquality() {
        let a = WindowFrame(x: 1, y: 2, width: 3, height: 4)
        let b = WindowFrame(x: 1, y: 2, width: 3, height: 4)
        let c = WindowFrame(x: 0, y: 0, width: 0, height: 0)

        #expect(a == b)
        #expect(a != c)
    }

    @Test("WindowStateSnapshot equality")
    func snapshotEquality() {
        let a = WindowStateSnapshot(id: "x", frame: WindowFrame(x: 0, y: 0, width: 1, height: 1), isVisible: true, level: 0)
        let b = WindowStateSnapshot(id: "x", frame: WindowFrame(x: 0, y: 0, width: 1, height: 1), isVisible: true, level: 0)
        let c = WindowStateSnapshot(id: "y", frame: WindowFrame(x: 0, y: 0, width: 1, height: 1), isVisible: true, level: 0)

        #expect(a == b)
        #expect(a != c)
    }
}
