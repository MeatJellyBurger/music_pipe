<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.meatjellyburgur.musicpipe.util.InstrumentImageUtil" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Insert title here</title>
    <%@include file="../include/static-head.jsp"%>
    <link rel="stylesheet" href="/assets/css/together.css">
</head>

<body>
<%@include file="../include/header.jsp"%>
<div id="wrap">

    <div class="main-title-wrapper">
        <h1 class="main-title">구인 게시판</h1>
    </div>

    <div class="top-section">
        <!-- 검색창 영역 -->
        <div class="search">
            <button class="add-btn">새 글 쓰기</button>
            <form action="/board/list" id="search" method="get">
                <input type="text" class="form-control"name="keyword" value="${s.keyword}">
                <button class="btn btn-primary" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </form>


        </div>
    </div>


    <div class="card-container">

        <c:forEach var="b" items="${bList}"><%--게시글 리스트 --%>
            <div class="card-wrapper">
                <section class="card" data-bno="${b.boardId}">
                    <div class="card-title-wrapper">
                        <h2 class="card-title">${b.title}<%-- 제목 --%></h2>
                        <div class="time-wrapper">
                            <div class="time">
                                <i class="far fa-clock"></i>
                                    ${b.regDateTime} <%-- 생성 날짜 --%>
                            </div>
                        </div>
                        <div class="instrument_img">모집악기 :
                            <div class="img_box">
<%--                                모집악기 리스트 불러와서 값이 on 일경우만 찾아서 표시 아니면 표시하지 않기--%>
<%--                                    ${b.recruit_equipment}--%>

                                <c:forEach var="e" items="${b.recruit_equipment}">

                                        <img class="img" src="/assets/img/${InstrumentImageUtil.instrumentImage(e)}.png" alt="${e}">
                                </c:forEach>

<%--                                <c:if test="${bList.recruit_equipment.size()==0}">--%>
<%--                                    모집악기:없음.--%>
<%--                                </c:if>--%>
                            </div>
                        </div>
                    </div>
                    <div class="card-content">
                            ${b.content}
                    </div>
                </section>
                <div class="card-btn-group">
                    <button class="del-btn" data-href="/board/delete?bno=${b.boardId}">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

            </div>
        </c:forEach>


    </div>

    <!-- 게시글 목록 하단 영역 -->
    <div class="bottom-section">

        <!-- 페이지 버튼 영역 -->
        <nav aria-label="Page navigation example">
            <ul class="pagination pagination-lg pagination-custom">

                <c:if test="${maker.page.pageNo != 1}">
                    <li class="page-item"><a class="page-link" href="/board/list?pageNo=1&amount=${s.amount}&type=${s.type}&keyword=${s.keyword}">&lt;&lt;</a></li>
                </c:if>

                <c:if test="${maker.prev}">
                    <li class="page-item"><a class="page-link" href="/board/list?pageNo=${maker.begin - 1}&amount=${s.amount}&type=${s.type}&keyword=${s.keyword}">prev</a>
                    </li>
                </c:if>

                <c:forEach var="i" begin="${maker.begin}" end="${maker.end}" step="1">
                    <li data-page-num="${i}" class="page-item">
                        <a class="page-link" href="/board/list?pageNo=${i}&amount=${s.amount}&type=${s.type}&keyword=${s.keyword}">${i}</a>
                    </li>
                </c:forEach>


                <c:if test="${maker.next}">
                    <li class="page-item"><a class="page-link" href="/board/list?pageNo=${maker.end + 1}&amount=${s.amount}&type=${s.type}&keyword=${s.keyword}">next</a></li>
                </c:if>

                <c:if test="${maker.page.pageNo != maker.finalPage}">
                    <li class="page-item"><a class="page-link" href="/board/list?pageNo=${maker.finalPage}&amount=${s.amount}&type=${s.type}&keyword=${s.keyword}">&gt;&gt;</a>
                    </li>
                </c:if>

            </ul>
        </nav>

    </div>
</div>


</div>

<!-- 모달 창 -->
<div class="modal" id="modal">
    <div class="modal-content">
        <p>정말로 삭제할까요?</p>
        <div class="modal-buttons">
            <button class="confirm" id="confirmDelete"><i class="fas fa-check"></i> 예</button>
            <button class="cancel" id="cancelDelete"><i class="fas fa-times"></i> 아니오</button>
        </div>
    </div>
</div>


<script>

  const $cardContainer = document.querySelector('.card-container');

  //================= 삭제버튼 스크립트 =================//
  const modal = document.getElementById('modal'); // 모달창 얻기
  const confirmDelete = document.getElementById('confirmDelete'); // 모달 삭제 확인버튼
  const cancelDelete = document.getElementById('cancelDelete'); // 모달 삭제 취소 버튼

  $cardContainer.addEventListener('click', e => {
    // 삭제 버튼을 눌렀다면~
    if (e.target.matches('.card-btn-group *')) {
      console.log('삭제버튼 클릭');
      modal.style.display = 'flex'; // 모달 창 띄움

      const $delBtn = e.target.closest('.del-btn');
      const deleteLocation = $delBtn.dataset.href;

      // 확인 버튼 이벤트
      confirmDelete.onclick = e => {
        // 삭제 처리 로직
        window.location.href = deleteLocation;

        modal.style.display = 'none'; // 모달 창 닫기
      };


      // 취소 버튼 이벤트
      cancelDelete.onclick = e => {
        modal.style.display = 'none'; // 모달 창 닫기
      };
    } else { // 삭제 버튼 제외한 부분은 글 상세조회 요청

      // section태그에 붙은 글번호 읽기
      const bno = e.target.closest('section.card').dataset.bno;
      // 요청 보내기
      window.location.href = '/board/detail?bno=' + bno + '&pageNo=${s.pageNo}&amount=${s.amount}&type=${s.type}&keyword=${s.keyword}';
    }
  });

  // 전역 이벤트로 모달창 닫기
  window.addEventListener('click', e => {
    if (e.target === modal) {
      modal.style.display = 'none';
    }
  });

  //========== 게시물 목록 스크립트 ============//

  function removeDown(e) {

    if (!e.target.matches('.card-container *')) return;
    const $targetCard = e.target.closest('.card-wrapper');
    $targetCard?.removeAttribute('id', 'card-down');
  }

  function removeHover(e) {

    if (!e.target.matches('.card-container *')) return;
    const $targetCard = e.target.closest('.card');
    $targetCard?.classList.remove('card-hover');

    const $delBtn = e.target.closest('.card-wrapper')?.querySelector('.del-btn');
    $delBtn.style.opacity = '0';
  }


  $cardContainer.onmouseover = e => {
      console.log('리무브호버 발동')
    if (!e.target.matches('.card-container *')) return;

    const $targetCard = e.target.closest('.card');
    $targetCard?.classList.add('card-hover');

    const $delBtn = e.target.closest('.card-wrapper')?.querySelector('.del-btn');
    $delBtn.style.opacity = '1';
  }

  $cardContainer.onmousedown = e => {

    if (e.target.matches('.card-container .card-btn-group *')) return;

    const $targetCard = e.target.closest('.card-wrapper');
    $targetCard?.setAttribute('id', 'card-down');
  };

  $cardContainer.onmouseup = removeDown;

  $cardContainer.addEventListener('mouseout', removeDown);
  $cardContainer.addEventListener('mouseout', removeHover);

  // write button event
  document.querySelector('.add-btn').onclick = e => {
      console.log('새글쓰기 이벤투')
    window.location.href = '/board/write';
  };


  // 현재 위치한 페이지에 active 스타일 부여
  function appendPageActive() {

    // 현재 서버에서 내려준 페이지 번호
    const currPage = '${maker.page.pageNo}';
    // console.log(currPage);

    /*
       li태그들을 전부 확인해서
       현재 페이지번호와 일치하는 li를 찾은 다음 active 클래스 붙이기
     */
    const $ul = document.querySelector('.pagination');
    const $liList = [...$ul.children];

    $liList.forEach($li => {
      if (currPage === $li.dataset.pageNum) {
        $li.classList.add('active');
      }
    });

  }


  // 검색조건 셀렉트박스 옵션타입 고정하기
  <%--function fixSearchOption() {--%>
  <%--  // 셀렉트박스에 option태그들을 전부 가져옴--%>
  <%--    console.log('fixSearchOption')--%>
  <%--  const $options = [...document.getElementById('search-type').children];--%>

  <%--  $options.forEach($opt => {--%>
  <%--    if ($opt.value === '${s.type}') {--%>
  <%--      $opt.setAttribute('selected', 'selected');--%>
  <%--    }--%>
  <%--  });--%>
  <%--}--%>

  appendPageActive();
  // fixSearchOption();


</script>

</body>

</html>