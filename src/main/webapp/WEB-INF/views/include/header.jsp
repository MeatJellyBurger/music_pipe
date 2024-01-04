<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    header {
        /* background: red; */
        background: #ffffff;
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 1000;
    }

    header.on {
        background: #222;
        border-bottom: 1px solid #2c2c2c;
        transition: .4s;
    }

    header .inner-header {
        /* background: orange; */
        width: 92%;
        margin: 0 auto;
        height: 120px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 700;
        color: #000000;

        /*position: relative;*/
    }

    header .inner-header .logo {
        width: 200px;
    }

    header .inner-header .logo a {
        display: block;
    }

    header .inner-header .logo a img {
        height: 100px;
    }

    header .inner-header #search {
        margin-left: 1150px;
        width: 550px;
        display: flex;
        justify-content: center;
        align-content: center;
        flex-direction: row;
        margin-top: 0px;
        padding: 0px;
        height: 20px;
    }

    header .inner-header #search select {
        font-size: 12px;
        margin-top: 25px;
        height: 25px;
        width: 75px;
    }

    header .inner-header .intro-text {
        /* background: greenyellow; */
        flex: 4;
        text-transform: uppercase;
        margin-left: 40px;
    }

    header .inner-header .menu-open {
        margin-left: 20px;
        margin-right: 20px;
        font-size: 16px;
        display: flex;
        justify-content: flex-end;
        align-items: center;
    }

    header .inner-header .menu-open .lnr-menu {
        font-size: 33px;
        margin-left: 15px;
    }

    /* header gnb style */
    header .gnb {
        max-width: 500px;
        background: #e4e4e4;
        color: #666;
        height: 100vh;
        font-size: 40px;
        padding: 50px 70px;
        box-sizing: border-box;

        position: fixed;
        z-index: 2000;
        right: -100%;
        top: 0;
        transition: .6s;

        display: flex;
        flex-direction: row-reverse;
    }

    header .gnb.on {
        right: 0;
    }

    header .gnb .close {
        display: block;
        color: #000000;
    }

    header .gnb ul {
        margin-right: 100px;
    }

    header .gnb ul li {
        font-weight: 700;
        line-height: 1.7;
    }

    header .gnb ul li:hover,
    header .gnb ul li.active {
        color: #000000;
    }

    button {
        border: 0;
        outline: 0;
        /*background: transparent;*/
        cursor: pointer;
    }

    header .inner-header #search .btn-primary {
        height: 35px;
        margin-top: 20px;
    }

    header .inner-header #search .form-control {
        margin-top: 20px;
        height: 35px;
        width: 150px;
    }

    @media ( max-width: 1600px ) {
        header .inner-header #search {
            margin-left: 800px;
        }
    }

    @media ( max-width: 1450px ) {
        header .inner-header #search {
            margin-left: 650px;
        }
    }

    @media ( max-width: 1300px ) {
        header .inner-header #search {
            margin-left: 500px;
        }
    }

    @media ( max-width: 1000px ) {
        header .inner-header #search {
            margin-left: 200px;
        }
    }


    .user-profile-image{
        box-sizing: border-box;
        width: 100px;
        height: 100px;
        border: 1px solid black;
        border-radius:50%;
        justify-content: center;
        display: flex;
        align-items: center;
        overflow: hidden;
    }

    .user-profile-image img{
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

</style>


<!-- header -->
<header>
    <div class="inner-header">

        <h1 class="logo">
            <a href="/">
                <img src="/assets/img/logo.png" alt="로고이미지">
            </a>
        </h1>
        <div class="user-profile-image">
            <c:if test="${login != null}">
                <img src="/local${login.profileImagePath}" alt="가져온 프사">
            </c:if>
        </div>


        <form action="/user/list" id="search" method="POST">
            <select name="search_select">
                <option value="none">팀/개인</option>
                <option value="korean">팀</option>
                <option value="english">개인</option>
            </select>
            <input type="text" class="form-control" name="equipmentId">
            <button class="btn btn-primary" type="submit">
                <i class="fas fa-search"></i>
            </button>
        </form>

        <a href="#" class="menu-open">
            <span class="lnr lnr-menu"></span>
        </a>

        <c:if test="${empty login}">
            <a href="/user/sign-in">Login</a>
        </c:if>
        <c:if test="${not empty login}">
            <a href="/user/sign-out">LogOut</a>
        </c:if>
        <%--        <c:if test="${not empty login}">--%>
        <%--            <a href="#"><img src="${login.profile_img}"></a>--%>
        <%--            <p>${login.profile_nikname}</p>--%>
        <%--        </c:if>--%>

    </div>

    <nav class="gnb">
        <a href="#" class="close">
            <span class="lnr lnr-cross"></span>
        </a>
        <ul>
            <li><a href="#">Home</a></li>
            <li><a href="/board/list">together</a></li>
            <li><a href="/user/sign-up">sign-up</a></li>
            <%--            <c:if test="${not empty login}">
                            <li><a href="#">My Page</a></li>
                            <li><a href="/user/sign-out">Sign Out</a></li>
                        </c:if>--%>
        </ul>
    </nav>

</header>
<!— //header —>