PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS QRTag;
DROP TABLE IF EXISTS Building;
DROP TABLE IF EXISTS Floor;
DROP TABLE IF EXISTS IndoorLocation;
DROP INDEX IF EXISTS FloorDex;
DROP INDEX IF EXISTS IndoorLocationDex;

CREATE TABLE QRTag (
    url VARCHAR,
    xcoord REAL NOT NULL,
    ycoord REAL NOT NULL,
    PRIMARY KEY (url)
    );

CREATE TABLE Building (
    alias VARCHAR,
    name VARCHAR NOT NULL UNIQUE,
    floors INTEGER NOT NULL,
    delta REAL NOT NULL,
    PRIMARY KEY (alias)
    );

CREATE TABLE Floor (
    bldg VARCHAR,
    level INTEGER,
    plan VARCHAR NOT NULL,
    PRIMARY KEY (bldg, level),
    FOREIGN KEY (bldg) REFERENCES Building--(alias)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    );

CREATE TABLE IndoorLocation (
    bldg VARCHAR,
    level INTEGER,
    name VARCHAR,
    xcoord REAL NOT NULL,
    ycoord REAL NOT NULL,
    PRIMARY KEY (bldg, level, name),
    FOREIGN KEY (bldg, level) REFERENCES Floor--(bldg, level)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    );

CREATE UNIQUE INDEX FloorDex ON Floor(bldg, level);
CREATE UNIQUE INDEX IndoorLocationDex ON IndoorLocation(bldg, level, name);

INSERT INTO QRTag VALUES
    -- Format: Building::FloorLevel::Point
    ("UP AECH::0::A", 0.0, 0.0),
    ("UP AECH::0::B", 0.0, 0.0),
    ("UP AECH::0::C", 0.0, 0.0),
    ("UP AECH::1::A", 1.0, 1.0),
    ("UP AECH::2::A", 0.0, 0.0),
    ("UP AECH::3::A", 0.0, 0.0),
    ("UP ITDC::1::A", 0.0, 0.0),
    ("UP ITDC::2::A", 0.0, 0.0),
    ("UP ITDC::3::A", 0.0, 0.0);
INSERT INTO Building VALUES
    ("UP AECH", "UP Alumni Engineering Centennial Hall", 4, 3.0),
    ("UP ITDC", "UP Information Technology Development Center", 3, 3.2);
INSERT INTO Floor VALUES
    ("UP AECH", 0, "basement_floorplan"),
    ("UP AECH", 1, "ground_floorplan"),
    ("UP AECH", 2, "second_floorplan"),
    ("UP AECH", 3, "third_floorplan"),
    ("UP ITDC", 1, "ground_floorplan"),
    ("UP ITDC", 2, "second_floorplan"),
    ("UP ITDC", 3, "third_floorplan");
INSERT INTO IndoorLocation VALUES
    ("UP AECH", 0, "Engineering Library 2", 0.0, 0.0),
    ("UP AECH", 1, "Serials", -0.117, 0.137),
    ("UP AECH", 1, "The Learning Commons", 0.126, 0.137),
    ("UP AECH", 2, "Rm 200 Web Science Laboratory", 0.0, 0.0),
    ("UP AECH", 3, "Administration Office", 0.0, 0.0),
    ("UP ITDC", 1, "Rm 101", 0.0, 0.0),
    ("UP ITDC", 2, "Conference Room", 0.0, 0.0),
    ("UP ITDC", 3, "Networks and Infrastructure", 0.0, 0.0);

-- Notes:
--  QRTag is for initialization and localization. URL attribute stores strings of the form
--      BuildingAlias::FloorLevel ->
--        BuildingAlias used to determine building
--        BuildingAlias::FloorLevel used to determine Floor
--  Building information important for altimeter updates
--  Floor rows store paths to floor plans for plane retexturing
--  IndoorLocation entries show up in UI; relocate pin marker upon selection
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Additional useful info:
--  - For Building, user marker rotation offset
--  - Don't forget to scale maps/user or both (not necessarily same time)