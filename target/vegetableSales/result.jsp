<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Daily Sales Report</title>
    <style>
        body { font-family: Arial; background: #f4f7fb; }
        h2 { text-align: center; color: #1F3864; }
        table {
            border-collapse: collapse;
            width: 90%;
            margin: auto;
            background: white;
        }
        th { background: #1F3864; color: white; }
        th, td {
            border: 1px solid #888;
            padding: 8px;
            text-align: center;
        }
        .total {
            text-align: center;
            font-weight: bold;
            margin: 20px;
        }
    </style>
</head>
<body>

<%
    String vegetable = request.getParameter("vegetable");
    String kgValue = request.getParameter("kg");
    String rateValue = request.getParameter("rate");
    String dateValue = request.getParameter("sale_date");

    double totalKg = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/vegdb",
            "root",
            "root123"
        );

        if (vegetable != null && kgValue != null
                && rateValue != null && dateValue != null
                && !vegetable.trim().isEmpty()
                && !kgValue.isEmpty()
                && !rateValue.isEmpty()
                && !dateValue.isEmpty()) {

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO veg_sales " +
                "(vegetable, kg, rate, sale_date) VALUES (?, ?, ?, ?)"
            );

            ps.setString(1, vegetable);
            ps.setDouble(2, Double.parseDouble(kgValue));
            ps.setDouble(3, Double.parseDouble(rateValue));
            ps.setDate(4, java.sql.Date.valueOf(dateValue));
            ps.executeUpdate();
            ps.close();
        }
%>

<h2>Saved! Daily Vegetable Sales</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Vegetable</th>
        <th>Kg Sold</th>
        <th>Rate per Kg (Rs.)</th>
        <th>Date</th>
        <th>Amount (Rs.)</th>
    </tr>

<%
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(
            "SELECT * FROM veg_sales ORDER BY id"
        );

        while (rs.next()) {
            double kg = rs.getDouble("kg");
            double rate = rs.getDouble("rate");
            double amount = kg * rate;
            totalKg += kg;
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("vegetable") %></td>
        <td><%= kg %></td>
        <td><%= rate %></td>
        <td><%= rs.getDate("sale_date") %></td>
        <td><%= String.format("%.2f", amount) %></td>
    </tr>
<%
        }

        rs.close();
        st.close();
        con.close();

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
</table>

<div class="total">
    Total Kg Sold: <%= String.format("%.2f", totalKg) %> kg
</div>

<p style="text-align:center">
    <a href="index.html">Add Another Sale</a>
</p>

</body>
</html>
