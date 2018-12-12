class PreparedStatements {
    static var selectQRTag = """
        SELECT *
        FROM QRTag
        WHERE url = ?
        """

    static var selectBuilding = """
        SELECT *
        FROM Building
        WHERE alias = ?
        """

    // CS 199, for GPS maybe?
    static var selectAllBuildings = """
        SELECT *
        FROM Building
        """

    static var selectFloor = """
        SELECT *
        FROM Floor
        WHERE bldg = ?
          AND level = ?
        """

    static var selectFloors = """
        SELECT *
        FROM Floor
        WHERE bldg = ?
        """

    static var selectIndoorLocation = """
        SELECT *
        FROM IndoorLocation
        WHERE bldg = ?
          AND level = ?
          AND name = ?
        """

    static var selectIndoorLocations = """
        SELECT *
        FROM IndoorLocation
        WHERE bldg = ?
          AND level = ?
        """
}