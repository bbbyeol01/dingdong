<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Welcome!</title>
<%@ include file="../include/head.jsp" %>

<style>

  
   #calendar {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 5px;
  }
  .calendar-day {
    border: 1px solid #ccc;
    padding: 5px;
    text-align: center;
    cursor: pointer;
    border-radius: 40pt;
  }
  
  .calendar-day:hover {
    background-color: #f0f0f0;
  }


  .time-btn {
  	border-radius: 40pt;
    margin: 5px;
    padding: 10px;
    border: 1px solid #ccc;
    cursor: pointer;
  }
  .time-btn.disabled {
    background-color: #eee;
    cursor: not-allowed;
  }
  
  .calender-disable{
  	color : lightgrey;
  	background-color: #eee;
  	 cursor: not-allowed;
  }
  
</style>

</head>
<body>
	<div class="frame">

		<!-- header -->
		
		
		<!--  nav -->
		<nav>
		<%@ include file="../include/nav.jsp" %>
		</nav>
			
		<!-- container -->
		<div class="container">
		
			<!-- 스터디룸 정보 -->
			<div align="center">
			<br>
			
				<h1>${room.name}</h1>
				<br>
					<div class="image-box" style="width: 40%; height: 20%; overflow:hidden; margin:0 auto">
						<img class="image-thumbnail" style="width:100%; height: 100%; object-fit: cover" src="${contextPath}/resources/images/room/${room.fileName}" alt="${room.name}">
					</div>
					<br>
					
					<br>
						
				
					수용인원 | ${room.min}명 ~ ${room.max}명<br>
					<br>
					${room.content}<br>
					아늑한 스터디룸입니다. 방음 시설이 적용되어 있습니다.화장실은 외부 공용 화장실입니다.
				
					<br>
					<br>
					<hr>
					
					<br>
					
						<h5>당일 예약은 전화 문의 바랍니다.</h5>
						<br>
						<div style="width:30%" id="calendar"></div>
						<div id="selectDay"></div>
					
					<br>
					<br>
					
					
					<div id="time-buttons-container"></div>
					
					<br>
					<br>
					
					<form action="${contextPath }/reservation2/form" method="post">
						<!--   <div id="calendar"></div> -->
						<input type="text" id="dateInput"  value="" name="date"/>
						<input type="hidden" name="studyroomNumber" value="${room.studyroom}">
						<input type="hidden" name="roomNumber" value="${room.roomNumber}"/>
						<input type="text" name="start" id="start"/>
						<input type="text" name="end" id="end"/>
					<input type="submit" id="submitReservation" class="btn btn-primary" value="예약하기"/>
					</form>
			</div>
		
			
				
		</div>
			
		<br>
		<br>
		<hr>
		<br>
		<br>
		
		<div align="center">
			<br>
			<br>
			<br>
			<h2>여기에 리뷰 구현</h2>
			<br>
			<br>
			<br>
		</div>
		
	</div>
	
	<!-- footer -->
	<%@ include file="../include/footer.jsp" %>
	
  
  <script>

 var reservations = null;
  
$(document).ready(function() {
	
    
});

function getReservations(date){
	
	date = selectDay.innerText;
	
	$.ajax({
        url: 'reservedTime',
        type: 'GET',
        data: { 'date': date },
        success: function(result) {
        	
        	console.log("result " + result);
        	reservations = result;
			console.log("getReservations" + reservations);
        }
    });
	
	return reservations;
	
}


var startTime = null;
var endTime = null;


var calendarContainer = document.getElementById("calendar");
var selectDayContainer = document.getElementById("selectDay");
var date = selectDay.innerText;

var dateInput = document.getElementById("dateInput");


// HTML 요소를 가져와 변수에 저장
var timeButtonsContainer = document.getElementById("time-buttons-container");


// 시작 시간부터 끝 시간까지 버튼 생성
function createButtons(reservations, date) {
	
	timeButtonsContainer.innerHTML = "";
	
	
    for (var i = 9; i <= 24; i++) {
    	
    	// var date = "2024-03-07";
    	//date = selectDay.innerText;
    	
        var button = document.createElement("button");
        button.textContent = (i < 10 ? "0" + i : i) + ":00";
        button.classList.add("time-btn");

        for (var j = 0; j < reservations.length; j++) {
            var iTime = new Date(date + " " + i + ":00:00");
            var startTimeReserved = new Date(reservations[j].start);
            var endTimeReserved = new Date(reservations[j].end);

            if ((iTime >= startTimeReserved && iTime < endTimeReserved)) {
                button.classList.add("disabled");
                button.disabled = true;
                break;
            }
        }

        button.addEventListener("click", function() {
        	
        	
            var selectedTime = parseInt(this.textContent);

            if (!startTime) {
                startTime = selectedTime;
                date = selectDay.innerText;
                dateInput.value = date;
                document.getElementById("start").value = date + " " + (startTime < 10? "0" + startTime : startTime) + ":00";
            } else if (!endTime && selectedTime > startTime) {
                endTime = selectedTime;
                date = selectDay.innerText;
                dateInput.value = date;
                document.getElementById("end").value = date + " " + endTime + ":00";
            } else {
                startTime = null;
                endTime = null;
                document.getElementById("start").value = "";
                document.getElementById("end").value = "";
                dateInput.value = "";
            }
        });

        timeButtonsContainer.appendChild(button);
    }
}
</script>




<script>

// 현재 날짜 가져오기
var currentDate = new Date();
var currentYear = currentDate.getFullYear();
var currentMonth = currentDate.getMonth();



// 현재 월의 첫째 날과 마지막 날 가져오기
var firstDayOfMonth = new Date(currentYear, currentMonth, 1);
var lastDayOfMonth = new Date(currentYear, currentMonth + 1, 0);

// 달력 생성 함수 호출
generateCalendar(currentYear, currentMonth);

// 달력 생성 함수
function generateCalendar(year, month) {
    // 달력을 초기화
    calendarContainer.innerHTML = '';

    // 현재 월의 첫째 날의 요일
    var firstDayOfWeek = firstDayOfMonth.getDay();

    // 이전 달의 마지막 날짜
    var lastDayOfPrevMonth = new Date(year, month, 0).getDate();

    // 이번 달의 일자를 달력에 추가
    for (var i = 1; i <= lastDayOfMonth.getDate(); i++) {
        var dayElement = document.createElement("div");
        dayElement.textContent = i;
        dayElement.classList.add("calendar-day");
        
		// 오늘 이전 날짜는 선택할 수 없음
        if(i <= currentDate.getDate()){
    		dayElement.classList.add("calender-disable");
    	}

    	 console.log("today? " + currentDate.getDate());
    	 
    	 
        // 현재 월의 날짜는 선택 가능하도록 처리
        dayElement.addEventListener("click", function() {
        	
        	console.log("click!");
        	
        	
            selectDayContainer.textContent = currentYear + "-" + (currentMonth < 10 ? "0" + (currentMonth + 1) : (currentMonth + 1)) + "-" + (this.textContent < 10 ? "0" + this.textContent : this.textContent);
            
            document.getElementById("start").value = "";
            document.getElementById("end").value = "";
            document.getElementById("dateInput").value = "";
            
			
			console.log("before " + reservations);
			reservations = getReservations(selectDayContainer.textContent);
			console.log("after " + reservations);
			
			//timeButtonsContainer.innerHTML = "";
			
			console.log("date " + selectDay.innerText);
			createButtons(reservations, selectDay.innerText);
        	
        });

        calendarContainer.appendChild(dayElement);
    }
}

</script>
  
  
  
  
  
  
  
  
  
 
 
 

</body>
</html>
