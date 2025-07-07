<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="model.User, model.Product, dao.ProductDAO, java.util.List" %>
<%
    // Ensure only admin has access
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser == null || !"admin".equals(loggedInUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Xử lý phân trang
    ProductDAO productDAO = new ProductDAO();
    int pageSize = 10; // Số sản phẩm hiển thị mỗi trang
    int currentPage = 1;
    if (request.getParameter("page") != null) {
        try {
            currentPage = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    int offset = (currentPage - 1) * pageSize;
    int totalProducts = productDAO.getProductsCount(); // Tổng số sản phẩm trong DB
    List<Product> productList = productDAO.getProducts(offset, pageSize); // Lấy danh sách sản phẩm theo phân trang
    int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Products</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">

        <!-- Custom CSS cho giao diện chuyên nghiệp -->
        <style>
            body {
                font-family: "Segoe UI", sans-serif;
                background-color: #f4f6f9;
                margin: 0;
                padding: 0;
            }
            /* Top Navbar */
            .navbar {
                background-color: #0d6efd;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .navbar-brand {
                color: #fff !important;
                font-weight: bold;
                margin-left: 1rem;
            }
            .navbar-nav .nav-link {
                color: #fff !important;
            }
            /* Sidebar */
            .sidebar {
                position: fixed;
                top: 56px;
                left: 0;
                bottom: 0;
                width: 220px;
                background-color: #343a40;
                padding-top: 20px;
                overflow-y: auto;
            }
            .sidebar .sidebar-header {
                text-align: center;
                font-size: 1.2rem;
                color: #fff;
                margin-bottom: 1rem;
            }
            .sidebar a {
                display: block;
                padding: 10px 20px;
                color: #adb5bd;
                text-decoration: none;
                transition: background 0.3s;
            }
            .sidebar a:hover,
            .sidebar a.active {
                background-color: #0d6efd;
                color: #fff;
            }
            /* Main Content */
            .main-content {
                margin-left: 220px;
                margin-top: 56px;
                padding: 20px;
            }
            .table-container {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            /* Phân trang */
            .pagination {
                justify-content: center;
            }
        </style>
    </head>
    <body>
        <!-- Top Navbar -->
        <nav class="navbar navbar-expand-lg navbar-dark">
            <a class="navbar-brand" href="#"><i class="fas fa-rocket"></i> Group 7</a>
            <div class="collapse navbar-collapse" id="topNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="profile.jsp"><i class="fas fa-user-circle"></i> <%= loggedInUser.getUserName()%></a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-user-shield"></i> Admin
            </div>
            <a href="dashboard.jsp"><i class="fas fa-tachometer-alt mr-2"></i> Dashboard</a>
            <a href="manage-orders.jsp"><i class="fas fa-shopping-cart mr-2"></i> Manage Orders</a>
            <a href="manage-products.jsp" class="active"><i class="fas fa-box-open mr-2"></i> Manage Products</a>
            <a href="manage-users.jsp"><i class="fas fa-users mr-2"></i> Manage Users</a>
            <a href="manage-discount.jsp"><i class="fas fa-tag mr-2"></i> Manage Discounts</a>
            <a href="manage-trademark.jsp"><i class="fas fa-copyright mr-2"></i> Manage Trademark</a>
            <a href="adminNotifications.jsp?page=users"><i class="fas fa-bell mr-2"></i> Notification Order</a>

        </div>

        <!-- Main Content -->
        <div class="main-content">
            <h3 class="text-center text-primary mb-4">Manage Products</h3>
            <div class="text-right mb-3">
                <a href="AddProductServlet" class="btn btn-success">Add New Product</a>
                <a href="dashboard.jsp" class="btn btn-secondary ml-2">Back to Dashboard</a>
            </div>

            <div class="table-container">
                <% if (productList != null && !productList.isEmpty()) { %>
                <%-- Thông báo thành công --%>
                <c:if test="${not empty param.status && param.status == 'success'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Thành công!</strong> Sản phẩm đã được thêm vào hệ thống.
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                </c:if>
                <table class="table table-bordered table-hover">
                    <thead class="thead-dark">
                        <tr>
                            <th>Image</th>
                            <th>Product Name</th>
                            <th>Brand</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Description</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Product product : productList) {%>
                        <tr>
                            <td>
                                <img src="<%= product.getImage()%>" alt="<%= product.getProduct_Name()%>" width="100" height="100" class="img-thumbnail">
                            </td>
                            <td><%= product.getProduct_Name()%></td>
                            <td><%= product.getBrand()%></td> <!-- Hiển thị tên thương hiệu -->
                            <td>$<%= product.getPrice()%></td>
                            <td><%= product.getQuantity()%></td>
                            <td><%= product.getDescription()%></td>
                            <td>
                                <a href="edit-product.jsp?productId=<%= product.getProduct_ID()%>" class="btn btn-primary btn-sm">Edit</a>
                                <a href="DeleteProductServlet?productId=<%= product.getProduct_ID()%>" 
                                   class="btn btn-danger btn-sm" 
                                   onclick="return confirm('Are you sure?')">Delete</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                <div class="alert alert-info">No products found.</div>
                <% } %>
            </div>

            <!-- Thanh phân trang -->
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <%
                        int startPage = 1;
                        int endPage = totalPages;
                        int maxVisiblePages = 5;

                        if (totalPages > maxVisiblePages) {
                            if (currentPage <= 3) {
                                endPage = maxVisiblePages - 1;
                            } else if (currentPage >= totalPages - 2) {
                                startPage = totalPages - (maxVisiblePages - 2);
                            } else {
                                startPage = currentPage - 1;
                                endPage = currentPage + 1;
                            }
                        }
                    %>

                    <%-- Nút trang đầu tiên --%>
                    <li class="page-item <%= (1 == currentPage) ? "active" : ""%>">
                        <a class="page-link" href="manage-products.jsp?page=1">1</a>
                    </li>

                    <%-- Hiển thị ... nếu cần --%>
                    <% if (startPage > 2 && totalPages > maxVisiblePages) { %>
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>

                    <%-- Hiển thị các trang giữa --%>
                    <% for (int i = Math.max(2, startPage); i <= Math.min(endPage, totalPages - 1); i++) {%>
                    <li class="page-item <%= (i == currentPage) ? "active" : ""%>">
                        <a class="page-link" href="manage-products.jsp?page=<%= i%>"><%= i%></a>
                    </li>
                    <% } %>

                    <%-- Hiển thị ... nếu cần --%>
                    <% if (endPage < totalPages - 1 && totalPages > maxVisiblePages) { %>
                    <li class="page-item disabled"><span class="page-link">...</span></li>
                        <% } %>

                    <%-- Nút trang cuối cùng (nếu totalPages > 1) --%>
                    <% if (totalPages > 1) {%>
                    <li class="page-item <%= (totalPages == currentPage) ? "active" : ""%>">
                        <a class="page-link" href="manage-products.jsp?page=<%= totalPages%>"><%= totalPages%></a>
                    </li>
                    <% }%>
                </ul>
            </nav>

        </div>

        <!-- Bootstrap JS, Popper.js -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
