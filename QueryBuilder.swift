import GRDB

class QueryBuilder {
    static func fetchBuilding(_ alias : String) -> Building? {
        var building : Building?
        do {
            try DB.write { db in
                building = try Building.fetchOne(db, "SELECT * FROM Building WHERE alias = ?", arguments: [alias])
                return building
            }
        } catch {
            print(error)
        }
    }

    // CS 199, for GPS maybe?
    static func fetchAllBuildings() -> [Building] {
        var buildings : [Building]
        do {
            try DB.write { db in
                buildings = try Building.fetchAll(db, "SELECT alias, name FROM Building")
                return buildings
            }
        } catch {
            print(error)
        }
    }

    static func fetchFloor(_ bldg : String, _ level : Int) -> Floor? {
        var floor : Floor?
        do {
            try DB.write { db in
                floor = try Floor.fetchOne(db, "SELECT * FROM Floor WHERE (bldg, level) = (?, ?)", arguments: [bldg, level])
                return floor
            }
        } catch {
            print(error)
        }
    }

    static func fetchBuildingFloors(_ bldg : String) -> [Floor] {
        var floors : [Floor]
        do {
            try DB.write { db in
                floors = try Floor.fetchAll(db, "SELECT * FROM Floor WHERE bldg = ?", arguments: [bldg])
                return floors
            }
        } catch {
            print(error)
        }
    }

    static func fetchIndoorLocation(_ bldg : String, _ level : Int, _ name : String) -> IndoorLocation? {
        var loc : IndoorLocation?
        do {
            try DB.write { db in
                loc = try IndoorLocation.fetchOne(db, "SELECT * FROM IndoorLocation WHERE (bldg, level, name) = (?, ?, ?)", arguments: [bldg, level, name])
                return loc
            }
        } catch {
            print(error)
        }
    }

    static func fetchFloorIndoorLocations(_ bldg : String, _ level : Int) -> [IndoorLocation] {
        var locs : [IndoorLocation]
        do {
            try DB.write { db in
                locs = try IndoorLocation.fetchAll(db, "SELECT * FROM IndoorLocation WHERE (bldg, level) = (?, ?)", arguments: [bldg, level])
                return locs
            }
        } catch {
            print(error)
        }
    }

}