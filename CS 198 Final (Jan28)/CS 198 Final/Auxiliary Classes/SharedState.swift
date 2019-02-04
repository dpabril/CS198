//
//  SharedState.swift
//  CS 198 Final
//
//  Created by Abril & Aquino on 2/2/2018.
//  Copyright © 2019 Abril & Aquino. All rights reserved.
//

class SharedState {
    var currentBuilding : Building?
    var currentBuildingLocs : [[IndoorLocation]]
    var currentFloorPlanImage : UIImage?
    var navSceneXCoord : Double
    var navSceneYCoord : Double

    init() {
        self.currentBuilding = nil
        self.currentBuildingLocs = []
        self.currentBuildingFloorPlanImage = nil
        self.navSceneXCoord = 0
        self.navSceneYCoord = 0
    }

    // Getters
    func getCurrentBuilding() -> Building {
        return self.currentBuilding!
    }
    func getCurrentBuildingLocs() -> [[IndoorLocation]] {
        return self.currentBuildingLocs
    }
    func getCurrentFloorPlanImage() -> UIImage {
        return self.currentFloorPlanImage!
    }
    func getNavSceneXCoord() -> Double {
        return self.navSceneXCoord
    }
    func getNavSceneYCoord() -> Double {
        return self.navSceneYCoord
    }

    // Setters
    func setCurrentBuilding(_ currentBuilding : Building) {
        self.currentBuilding = currentBuilding
    }
    func setCurrentBuildingLocs(_ currentBuildingLocs : [[IndoorLocation]]) {
        self.currentBuildingLocs = currentBuildingLocs
    }
    func setCurrentFloorPlanImage(_ currentFloorPlanImage : UIImage) {
        self.currentFloorPlanImage = currentFloorPlanImage
    }
    func setNavSceneXCoord(_ navSceneXCoord : Double) {
        self.navSceneXCoord = navSceneXCoord
    }
    func setNavSceneYCoord(_ navSceneYCoord : Double) {
        self.navSceneYCoord = navSceneYCoord
    }
}
