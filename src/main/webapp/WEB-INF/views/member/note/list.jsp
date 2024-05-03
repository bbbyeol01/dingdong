<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Welcome!</title>
<%@ include file="../../include/head.jsp" %>
</head>
<body>
	<div class="frame">

		<!-- header -->
		
		
		<!--  nav -->
		<%@ include file="../../include/nav.jsp" %>
		

		
		<!-- container -->
		<div class="container" align="center">
		
		
		
			<div style="margin : 200px">
			
			
		
		<!--  
		새별: 모달창 안에 해당 id(noteHere)의 div가 있으면 그 div의 내용이 대체되는 걸로 바꿔놨어요! 
		-->
			<div id="noteHere"></div>
			<br>
			<br>
			
			
			<button class="btn listbannerfont2" style="text-align:center; background-color: blue; color: white" data-bs-toggle="modal" data-bs-target="#exampleModal" data-bs-whatever="@mdo" id="quit-modal">작성</button> 
			
			<br>
			<br>
			<h3>쪽지</h3>
			
			
			<%-- 
			<c:if test="${fn:length(noteList) == 0} ">
					등록된 쪽지가 없습니다.
			</c:if>
			
			 --%>
			
						
			
			<div id="noteListHere"></div>
			
			
			<hr>
		
		
		</div>
		
	
	
	
		</div>
		 
		
		
	
		
		
		
	</div>
	<script>
	
	$(function() {
		allNote();
	})
	
	function getNote(idx){
		
		var htmls = "";
		var url = "/dingdong/member/note/read";
		var paramData = {
		 		'idx' : idx
		}
		
		$.ajax({
			url : url,
			data : paramData,
			dataType : 'json',
			type : 'GET',
			success : function(result) {
				
				console.log(result);
				console.log(result.receiver);

				htmls += "<div>"
				+ "받는 이: " + result.receiver
				+ "<br>"
				+ "보낸 이: " + result.sender
				+ "<br>"
				+ "내용 : " + result.content
				+ "<br>"
				+ "날짜: " + result.date
				+ "</div>";
				
				$("#noteHere").html(htmls);
				
				allNote();
			},
			error : function(result) {
				// 여기에 통신 실패 로직 구현
			}
		})
		
	}
	
	function allNote(){
		var htmls = "";
		url = "/dingdong/member/note/getList";
		
		$.ajax({
			url : url,
			dataType : 'json',
			type : 'GET',
			success : function(result) {
				// 여기에 통신 성공 로직 구현
				// result가 해당 url에서 보내는 return값
				
				console.log(result);
				
				
				$.each(result, function(index, item){
					if(item.read === 0){
						htmls += "<a onclick='getNote(" + item.idx + ")' style='text-decoration-line : none'>"
							+ "<div style='color:black'>"
							+ item.sender + " | " +  item.date + " | " + item.content
							+ "</div>"
							+ "</a>";
					}else if(item.read === 1){
						htmls += "<a onclick='getNote(" + item.idx + ")' style='text-decoration-line : none'>"
							+ "<div style='opacity: 0.2; color:black;'>"
							+ item.sender + " | " +  item.date + " | " + item.content
							+ "</div>"
							+ "</a>";
					}
					
					
					// 0개일 때도 구현
				})
				
				$("#noteListHere").html(htmls);
				
			},
			error : function(result) {
				// 여기에 통신 실패 로직 구현
			}
		})
	}
	
	</script>
	<!-- footer -->
	<%@ include file="../../include/footer.jsp" %>

</body>
</html>