<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	//UTF-8を使う。
	request.setCharacterEncoding("utf-8");
%>
<jsp:include page="header.jsp">
	<jsp:param value="管理者TOP" name="PageName" />
</jsp:include>

	<div id="wrapper" class="container">
		<h1>管理者TOP</h1>
		<a href="ConfirmServlet">承認待ちアプリ一覧</a>
	</div>

<jsp:include page="footer.jsp"></jsp:include>