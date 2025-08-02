package db;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBaseConnection {
    public static Connection initializeDatabase() throws SQLException, ClassNotFoundException {
        String dbDriver = "org.apache.derby.jdbc.ClientDriver";
        String dbURL = "jdbc:derby://localhost:1527/";
        String dbName = "E_library";
        String dbUsername = "Elibrary";
        String dbPassword = "1234";   

        Class.forName(dbDriver);
        return DriverManager.getConnection(dbURL + dbName, dbUsername, dbPassword);
    }
}
