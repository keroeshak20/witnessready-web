// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WitnessReady",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "WitnessReady",
            targets: ["AppModule"],
            bundleIdentifier: "com.witnessready.app",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .scale),
            accentColor: .presetColor(.orange),
            supportedDeviceFamilies: [.pad, .phone],
            supportedInterfaceOrientations: [.portrait],
            capabilities: []
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)
