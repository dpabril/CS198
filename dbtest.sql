.mode column
.headers on
PRAGMA foreign_keys = ON;

CREATE TABLE QRTag (
    url VARCHAR,
    xcoord REAL,
    ycoord REAL,
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
    level VARCHAR,
    plan VARCHAR NOT NULL,
    PRIMARY KEY (bldg, level),
    FOREIGN KEY (bldg) REFERENCES Building(alias)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    );

CREATE TABLE IndoorLocation (
    bldg VARCHAR,
    level VARCHAR,
    name VARCHAR,
    xcoord REAL,
    ycoord REAL,
    PRIMARY KEY (bldg, level, name),
    FOREIGN KEY (bldg, level) REFERENCES Floor(bldg, level)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    );

INSERT INTO QRTag VALUES
    ("UP AECH::BF", 0.0, 0.0),
    ("UP AECH::1st", 0.0, 0.0),
    ("UP AECH::2nd", 0.0, 0.0),
    ("UP AECH::3rd", 0.0, 0.0);
INSERT INTO Building VALUES ("UP AECH", "UP Alumni Engineering Centennial Hall", 4, 3.0);
INSERT INTO Floor VALUES
    ("UP AECH", "BF", "basement_floorplan"),
    ("UP AECH", "1st", "ground_floorplan"),
    ("UP AECH", "2nd", "second_floorplan"),
    ("UP AECH", "3rd", "third_floorplan");
INSERT INTO IndoorLocation VALUES
    ("UP AECH", "BF", "Engineering Library 2", 0.0, 0.0),
    ("UP AECH", "1st", "The Learning Commons", 0.0, 0.0),
    ("UP AECH", "2nd", "Rm 200 Web Science Laboratory", 0.0, 0.0),
    ("UP AECH", "3rd", "Administration Office", 0.0, 0.0);

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