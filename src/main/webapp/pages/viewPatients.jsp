<%@ page import="java.util.*, com.hms.dao.PatientDAO, com.hms.model.Patient" %>

<h2>Patient List</h2>

<table border="1">
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Age</th>
    <th>Disease</th>
</tr>

<%
List<Patient> list = PatientDAO.getAllPatients();
for(Patient p : list){
%>

<tr>
    <td><%= p.getId() %></td>
    <td><%= p.getName() %></td>
    <td><%= p.getAge() %></td>
    <td><%= p.getDisease() %></td>
</tr>

<% } %>
</table>