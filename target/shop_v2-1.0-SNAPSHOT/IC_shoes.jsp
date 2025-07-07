<%@page import="dao.FavoriteDAO"%>
<%@page import="model.User"%>
<%@page import="java.util.*"%>
<%@page import="model.Product"%>
<%@page import="model.Product"%>
<%@page import="dao.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Retrieve user info from session
    User user = (User) session.getAttribute("user");

    // Fetch the list of products from the database
    ProductDAO productDAO = new ProductDAO();
    List<Product> productList = productDAO.getAllProducts();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="style/style.css"/>
    </head>
    <body>
        <%
            Product product = (Product) request.getAttribute("products");
        %>
        <nav class="navbar navbar-expand-lg bg-body-tertiary">
            <div class="container-fluid">
                <div class="collapse navbar-collapse d-flex justify-content-between" id="navbarSupportedContent">
                    <a class="navbar-brand" href="home.jsp">
                        <img class="logo" src="asset/logoShop_transparent.png" alt="alt"/></a>

                    <form action="searchController" method="POST" class="d-flex w-100" role="search">
                        <input class="form-control me-2 flex-grow-1" type="search" name="productName" placeholder="Search" aria-label="Search">
                        <button class="btn btn-outline-success" type="submit">Search</button>   
                    </form>
                    <ul class="navbar-nav mb-2 mb-lg-0">
                        <% if (user == null) { %>
                        <li class="nav-item"> 
                            <a class="nav-link active" aria-current="page" href="login.jsp">    <i class="fa fa-user"></i>
                            </a>
                        </li>
                        <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" href="profile.jsp">    <i class="fa fa-user"></i>
                            </a>
                        </li>
                        <%
                            FavoriteDAO favoriteDAO = new FavoriteDAO();
                            List<Product> favorites = favoriteDAO.getFavoriteProducts(user.getUserId());
                        %>
                        <li class="nav-item mx-3">
                            <a class="nav-link" href="favoriteList.jsp">
                                <i class="fa fa-heart text-danger"></i>
                                <% if (!favorites.isEmpty()) {%>
                                <span class="badge bg-danger rounded-pill"><%= favorites.size()%></span>
                                <% } %>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" href="viewcart.jsp"><i class="fa fa-cart-plus"></i>
                            </a>
                        </li>

                        <% }%>
                    </ul>
                </div>
            </div>
        </nav>
        <nav class="navbar navbar-expand-lg bg-body-tertiary">
            <div class="container-fluid ">
                <a class="navbar-brand" href="home.jsp" style="font-weight: bold; ">Home</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNavDropdown">
                    <ul class="navbar-nav w-100 d-flex justify-content-cente" >
                        <li class="nav-item mx-3" >
                            <a class="nav-link active" aria-current="page" href="all.jsp" style="font-weight: bold;">All</a>
                        </li>
                        <li class="nav-item mx-3">
                            <a class="nav-link" href="TF_shoes.jsp" style="font-weight: bold;">TF Shoes</a>
                        </li>
                        <li class="nav-item mx-3">
                            <a class="nav-link" href="IC_shoes.jsp" style="font-weight: bold; color: red">IC Shoes</a>
                        </li>
                        <li class="nav-item dropdown mx-3">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="font-weight: bold;">
                                Brand
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="nike.jsp">Nike</a></li>
                                <li><a class="dropdown-item" href="adidas.jsp">Adidas</a></li>
                                <li><a class="dropdown-item" href="puma.jsp">Puma</a></li>
                                <li><a class="dropdown-item" href="mizuno.jsp">Mizuno</a></li>
                                <li><a class="dropdown-item" href="joma.jsp">Joma</a></li>
                                <li><a class="dropdown-item" href="kamito.jsp">Kamito</a></li>
                                <li><a class="dropdown-item" href="other.jsp">Other</a></li>
                            </ul>
                        </li>
                        <li class="nav-item mx-3">
                            <a class="nav-link" href="contact.jsp" style="font-weight: bold;">Contact</a>
                        </li>
                        <li class="nav-item mx-3">
                            <a class="nav-link" href="rate.jsp" style="font-weight: bold;">Rate</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
        <div class="container mt-5">
            <h2 class="text-center">IC Shoes</h2>
            <div class="row">
                <%
                    ProductDAO dao = new ProductDAO();
                    List<Product> TFProducts = dao.getProductsByType("IC");
                    for (Product p : TFProducts) {
                %>
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <img src="<%= p.getImage()%>" class="card-img-top" alt="<%= p.getProduct_Name()%>">
                        <div class="card-body">
                            <h5 class="card-title"><%= p.getProduct_Name()%></h5>
                            <p class="card-text"><%= p.getDescription()%></p>
                            <p class="card-text text-danger">Price: <%= p.getPrice()%>$</p>
                            <a href="DetailController?productId=<%= p.getProduct_ID()%>" class="btn btn-primary">View Details</a>

                        </div>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>


        <!-- footer -->
        <div class="footer">
            <footer>
                <div class="footer-container">
                    <!-- Về chúng tôi -->
                    <div class="footer-section about">
                        <h3>About us</h3>
                        <p>We are a shoe store that specializes in providing high quality products at reasonable prices. Customers are our top priority.</p>
                    </div>

                    <!-- Liên kết -->
                    <div class="footer-section links">
                        <h3>Link</h3>
                        <ul>
                            <li><a href="aboutUs.jsp">About us</a></li>
                            <li><a href="home.jsp">Store</a></li>
                            <li><a href="contact.jsp">Contact</a></li>
                            <li><a href="policy.jsp">Privacy policy</a></li>    
                            <li><a href="faq.jsp">FAQ</a></li>
                        </ul>
                    </div>

                    <!-- Liên hệ -->
                    <div class="footer-section contact">
                        <h3>Contact</h3>
                        <p>Address: SE1817, FPT University</p>
                        <p>Phone number: 123456789 </p>
                        <p>Email: kokororay356@gmail.com</p>
                    </div>

                    <!-- Theo dõi chúng tôi -->
                    <div class="footer-section social">
                        <h3>Follow us</h3>
                        <a href="#"><img src="asset/logofacebook.png" alt="Facebook"></a>
                        <a href="#"><img src="asset/logoInsta.png" alt="Instagram"></a>
                    </div>
                </div>

                <div class="footer-bottom">
                    <p>&copy; Group 7.</p>
                </div>
            </footer>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>
