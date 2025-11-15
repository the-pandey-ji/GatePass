<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="gatepass.Database" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Select Officer</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">

    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: background: #f4f7f6;;
            margin: 0;
            padding: 30px;
        }

        .form-container {
            max-width: 600px;
            margin: 80px auto;
            padding: 25px 35px;
            background-color: #fdfdfd;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h2.header {
            color: #003366;
            margin-bottom: 25px;
            letter-spacing: 1px;
        }

        label {
            display: block;
            text-align: left;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        select, input[type="submit"] {
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-top: 10px;
        }

        select {
            width: 100%;
        }

        input[type="submit"] {
            background-color: #1e3c72;
            color: white;
            border: none;
            cursor: pointer;
            transition: 0.3s;
            width: 100%;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .error {
            color: red;
            font-size: 14px;
            margin-top: 10px;
        }

        footer {
            text-align: center;
            font-size: 13px;
            color: #555;
            margin-top: 30px;
        }
    </style>
</head>

<body>
    <div class="form-container">
        <h2 class="header">Select Officer</h2>

        <form action="vname.jsp" method="get">
            <label for="officertomeet">Officer to Meet:</label>
            <select name="officertomeet" id="officertomeet" required>
                <%
                    // Define resources
                    Connection conn = null;
                    Statement st = null;
                    ResultSet rs = null;
                    try {
                        Database db = new Database();
                        conn = db.getConnection();

                        if (conn != null) {
                            String sql = "SELECT officers FROM officertomeet ORDER BY officers ASC";
                            st = conn.createStatement();
                            rs = st.executeQuery(sql);

                            boolean hasData = false;
                            while (rs.next()) {
                                hasData = true;
                                String officerName = rs.getString("officers");
                %>
                                <option value="<%= officerName %>"><%= officerName %></option>
                <%
                            }

                            if (!hasData) {
                %>
                                <option value="" disabled>No officers found</option>
                <%
                            }
                        } else {
                %>
                            <option value="" disabled>⚠️ Database connection failed.</option>
                <%
                        }
                    } catch (SQLException e) {
                        System.err.println("Database Error: " + e.getMessage());
                %>
                        <option value="" disabled>⚠️ Error loading officers.</option>
                <%
                    } finally {
                        try { if (rs != null) rs.close(); } catch (SQLException ignore) {}
                        try { if (st != null) st.close(); } catch (SQLException ignore) {}
                        try { if (conn != null) conn.close(); } catch (SQLException ignore) {}
                    }
                %>
            </select>

            <input type="submit" value="View">
        </form>
    </div>

    <footer>
        © <%= java.time.Year.now() %> Gate Pass Management System | NFL Panipat
    </footer>
</body>
</html>
