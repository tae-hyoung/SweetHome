<%@ page import="com.homecat.sweethome.vo.calendar.CalendarVO"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
<script src='/resources/css/calendar/dist/index.global.min.js'></script>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
	
<style>
#calendar {
	max-width: 1100px;
	margin: 16px;
	margin-top: 22px;
	height: 796px !important;
}

textarea {
	width: 190px;
	height: 50px;
}

#pTable {
	border-collapse: separate;
	border-spacing: 0;
}

.fc .fc-toolbar h2 {
	font-size: 27px;
}

.fc-event {
	cursor: pointer;
}

.fc .fc-daygrid-day.fc-day-today {
	background-color: #f7eb4b2e;
}

.event-section {
	margin-bottom: 20px;
}

.event-title {
	margin-bottom: 10px;
	padding: 10px;
	border-radius: 5px;
	font-size: 29px;
    font-weight: bold;
}

label {
    display: flex;
}

.form-control {
  width: 300px;
}

.modal-content {
  width: 440px;
}
.fc-daygrid-day-number {
	width: 34px !important;
	font-size: 15px !important;
}
.fc .fc-popover{
	z-index: 10;
}
.swal2-title { 
	font-size: 25px !important; 
}

/* 각 날짜 셀의 높이를 조정 */
.fc-daygrid-day-frame {
    height: auto; /* 원하는 높이로 조절 */
}

/* 날짜 셀의 내용이 영역 내에 맞도록 조정 */
.fc-daygrid-day-top {
    height: 28px; /* 날짜 숫자의 높이 조절 */
}

/* 이벤트 목록의 높이 조정 */
.fc-daygrid-day-events {
    max-height: none; /* 날짜 숫자가 차지하는 공간을 제외한 높이 */
    overflow: visible;
}



/* 전체 캘린더의 높이를 조정 */
.fc-daygrid-body {
/*     max-height: 300px; /* 조정한 날짜 셀의 높이에 따라 전체 높이 설정 */ */
    overflow: visible;
}

.fc .fc-view-harness {
    flex-grow: 1;
    position: relative;
    margin-top: 14px;
}

  /* 특정 tbody 내의 첫 번째 <td> 요소를 왼쪽 정렬하고 왼쪽에 패딩 추가 */
#dayListBody td:first-child:not([colspan]),
#dayListBody2 td:first-child:not([colspan]),
#dayListBody3 td:first-child:not([colspan]) {
    text-align: left;
    padding-left: 30px; /* 원하는 만큼의 패딩을 추가 */
}

 /* 특정 tbody 내의 첫 번째 <td> 요소를 왼쪽 정렬하고 왼쪽에 패딩 추가 */
#dayListBody  td[colspan],
#dayListBody2 td[colspan],
#dayListBody3 td[colspan] {
    text-align: center;
}

.fc-direction-ltr .fc-daygrid-event.fc-event-start, .fc-direction-rtl .fc-daygrid-event.fc-event-end {
    margin-left: 1px;
    margin-right: 1px;
  }   
  
.fc-direction-ltr .fc-daygrid-event.fc-event-end, .fc-direction-rtl .fc-daygrid-event.fc-event-start {
 	margin-left: 1px;
    margin-right: 1px;
    }
</style>

<div class="container-fluid">
	<div class="row">
		<div class="col-12">
			<div class="page-title-box d-sm-flex align-items-center justify-content-between bg-galaxy-transparent">
				<p class="mb-sm-0" style="font-size:18px; color: #495057;"><i class="las la-calendar-alt"></i>&nbsp;<strong>개인 일정 관리</strong></p>
				<div class="page-title-right">
					<ol class="breadcrumb m-0">
						<li class="breadcrumb-item"><a href="javascript: void(0);">서비스</a></li>
						<li class="breadcrumb-item active">일정</li>
					</ol>
				</div>
			</div>
		</div>
	</div>
</div>

<div style="display: flex;">
    <!-- 달력 영역 -->
    <div style="flex: 1; height: 834px;" class="card">
        <div id='calendar'></div>
    </div>
   
    <!-- 일정 목록 영역 -->
    <div style="flex: 1; padding-left: 20px; text-align: center;">
        <div id="personalEventSection" class="event-section">
            <h2 class="event-title" style="background-color: #cdecff;">개인 일정</h2>
            <div class="card mb-3 personal-event" >
            
            <!-- 일정 등록 모달 -->
			<div class="modal fade bd-example-modal-sm" id="yrModal"
				tabindex="-1" aria-labelledby="exampleModalgridLabel"
				aria-modal="true">
				<div class="modal-dialog" style="margin-top: 143px;  margin-left:750px;">
					<div class="modal-content">
						<div class="modal-header">
							<h1 class="modal-title" style="font-size: 40px;">일정 등록</h1>
							<hr>
							<button type="button" class="btn-close" data-bs-dismiss="modal"
								aria-label="Close" id="close2"></button>
						</div>
						<div class="modal-body" style="font-size: 16px;">
							<div class="row">
								<div>
									<div class="mb-3" style="margin-left: 40px;">
										<label for="calStart" class="form-label"
											style="font-size: 18px;">시작일</label> <input
											type="datetime-local" id="calStart" class="form-control"
											value="" style="font-size: 16px;">

									</div>
									<div class="mb-3" style="margin-left: 40px;">
										<label for="calEnd" class="form-label"
											style="font-size: 18px;">종료일</label> <input
											type="datetime-local" id="calEnd" class="form-control"
											value="" style="font-size: 16px;">

									</div>
									<div class="mb-3" style="margin-left: 40px;">
										<label for="calTitle" class="form-label"
											style="font-size: 18px;">제목</label> <input type="text"
											id="calTitle" class="form-control" value=""
											style="font-size: 16px;">
									</div>
									<div class="mb-3" style="margin-left: 40px;">
										<label for="calContent" class="form-label"
											style="font-size: 18px;">상세내용</label>
										<textarea id="calContent" class="form-control" value=""
											style="resize: none; font-size: 16px;  min-height: 115px;"></textarea>

									</div>
									<div>
										<div class="d-flex justify-content-center gap-2" style="margin-top: 50px;">
											<button type="button"
												class="btn btn-soft-success waves-effect waves-light material-shadow-none"
												onclick="fCalAdd()">추가</button>
											<button type="button" id="close"
												class="btn btn-soft-dark waves-effect waves-light material-shadow-none"
												data-bs-dismiss="modal">취소</button>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 일정 상세 모달 -->
			<div class="modal fade bd-example-modal-sm" id="deModal"
				tabindex="-1" aria-labelledby="exampleModalgridLabel"
				aria-modal="true" >
				<div class="modal-dialog" style="margin-top: 143px;  margin-left:750px;">
					<div class="modal-content">
						<div class="modal-header">
							<h1 class="modal-title" style="font-size: 40px; ">일정 상세</h1>
							<hr><hr>
							<button type="button" id="deClose" class="btn-close"
								data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body" id="cont" style="font-size: 16px;">
							<input type="hidden" name="calSeq" value="">
							<div class="mb-3" style="margin-left: 40px;">
								<label for="calStart" class="form-label"
									style="font-size: 18px;">시작일</label> <input
									type="datetime-local" name="calStart" value=""
									class="form-control formdata" readonly style="font-size: 16px; ">
							</div>
							<div class="mb-3" style="margin-left: 40px;">
								<label for="calEnd" class="form-label" style="font-size: 18px;">종료일</label>
								<input type="datetime-local" name="calEnd" value=""
									class="form-control formdata" readonly style="font-size: 16px;">
							</div>
							<div class="mb-3" style="margin-left: 40px;">
								<label for="calTitle" class="form-label"
									style="font-size: 18px;">제목</label> <input type="text"
									name="calTitle" value="" class="form-control formdata" readonly
									style="font-size: 16px;">
							</div>
							<div class="mb-3" style="margin-left: 40px;">
								<label for="calContent" class="form-label"
									style="font-size: 18px;">상세내용</label>
								<textarea name="calContent" value=""
									class="form-control formdata"
									style="resize: none; font-size: 16px;  min-height: 115px;" readonly></textarea>
							</div>
							<input type="hidden" name="calStime" value=""> <input
								type="hidden" name="calEtime" value="">
							<!-- 일반모드  -->
							<div class="d-flex justify-content-center gap-2"  style="margin-top: 50px;">
								<p id="p1">
									<button type="button"
										class="btn btn-soft-success waves-effect waves-light material-shadow-none"
										id="edit">수정</button>
									<button type="button"
										class="btn btn-soft-danger waves-effect waves-light material-shadow-none"
										id="delete">삭제</button>
									<button type="button"
										class="btn btn-soft-dark waves-effect waves-light material-shadow-none"
										id="confirm">확인</button>


								</p>
							</div>
							<!-- 수정모드  -->
							<div class="d-flex justify-content-center gap-2"  style="margin-top: 50px;">
								<p id="p2" style="display: none;">
									<button type="button"
										class="btn btn-soft-secondary waves-effect material-shadow-none"
										id="update">저장</button>
									<button type="button"
										class="btn btn-soft-dark waves-effect waves-light material-shadow-none"
										id="cancle">취소</button>

								</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 일정 상세 모달(공통, 예약 일정 등으로 조회만 가능) -->
			<div class="modal fade bd-example-modal-sm" id="deModal2"
				tabindex="-1" aria-labelledby="exampleModalgridLabel"
				aria-modal="true">
				<div class="modal-dialog" style="margin-top: 143px;  margin-left:750px;">
					<div class="modal-content">
						<div class="modal-header">
							<h1 class="modal-title" style="font-size: 40px; ">일정 상세</h1>
							<hr>
							<button type="button" id="deClose" class="btn-close"
								data-bs-dismiss="modal" aria-label="Close"></button>
						</div>
						<div class="modal-body" id="cont" style="font-size: 16px;">
							<input type="hidden" name="calSeq" value="">
							<div class="mb-3" style="margin-left: 40px;">
								<label for="calStart" class="form-label"
									style="font-size: 18px;">시작일</label> <input
									type="datetime-local" name="calStart" value=""
									class="form-control formdata" readonly style="font-size: 16px;">
							</div>
							<div class="mb-3" style="margin-left: 40px;">
								<label for="calEnd" class="form-label" style="font-size: 18px;">종료일</label>
								<input type="datetime-local" name="calEnd" value=""
									class="form-control formdata" readonly style="font-size: 16px;">
							</div>
							<div class="mb-3" style="margin-left: 40px;">
								<label for="calTitle" class="form-label"
									style="font-size: 18px;">제목</label> <input type="text"
									name="calTitle" value="" class="form-control formdata" readonly
									style="font-size: 16px;">
							</div>
							<div class="mb-3" style="margin-left: 40px;">
								<label for="calContent" class="form-label"
									style="font-size: 18px;">상세내용</label>
								<textarea name="calContent" value=""
									class="form-control formdata"
									style="resize: none; font-size: 16px;  min-height: 115px;" readonly></textarea>
							</div>
							<input type="hidden" name="calStime" value=""> <input
								type="hidden" name="calEtime" value="">
							<!-- 일반모드  -->
							<div class="d-flex justify-content-center gap-2"  style="margin-top: 50px;">
							 <button type="button"
					            class="btn btn-soft-dark waves-effect waves-light material-shadow-none"
					             data-bs-dismiss="modal" id="confirm2">확인</button>
					            
							</div>
						</div>
					</div>
				</div>
			</div>
			
                <div class="card-body table-responsive p-0" style="width: 100%; height: 200px; overflow: auto;">
                    <table id="personalTable" class="table table-hover text-nowrap" style="table-layout: fixed;">
                        <thead class="table-light" style="text-align: center; position: sticky; top: 0; background: white;">
                            <tr>
                                <th style="font-size: 16px;">일정</th>
                                <th style="font-size: 16px;">시작날짜</th>
                                <th style="font-size: 16px;">종료날짜</th>
                            </tr>
                        </thead>
                        <tbody id="dayListBody" style="text-align: center; font-size: 16px;">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div id="complexEventSection" class="event-section">
            <h2 class="event-title" style="background-color: #cff8c7;">단지 일정</h2>
            <div class="card mb-3 complex-event">
                <div class="card-body table-responsive p-0" style="width: 100%; height: 200px; overflow: auto;">
                    <table id="complexTable" class="table table-hover text-nowrap" style="table-layout: fixed;">
                        <thead class="table-light" style="text-align: center; position: sticky; top: 0; background: white;">
                            <tr>
                                <th style="font-size: 16px;">일정</th>
                                <th style="font-size: 16px;">시작날짜</th>
                                <th style="font-size: 16px;">종료날짜</th>
                            </tr>
                        </thead>
                        <tbody id="dayListBody2" style="text-align: center;  font-size: 16px;">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div id="reservationEventSection" class="event-section">
            <h2 class="event-title" style="background-color: #ffdcdc;">예약 및 반납 일정</h2>
            <div class="card mb-3 reservation-event">
                <div class="card-body table-responsive p-0" style="width: 100%; height: 200px; overflow: auto;">
                    <table id="reservationTable" class="table table-hover text-nowrap" style="table-layout: fixed;">
                        <thead class="table-light" style="text-align: center; position: sticky; top: 0; background: white;">
                            <tr>
                                <th style="font-size: 16px;">일정</th>
                                <th style="font-size: 16px;">시작날짜</th>
                                <th style="font-size: 16px;">종료날짜</th>
                            </tr>
                        </thead>
                        <tbody id="dayListBody3" style="text-align: center;  font-size: 16px;">
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<h1>${reserveVOList}</h1>

<script>
      let str ="";
      let str2 ="";
      let str3 ="";
      let firstLoad = true; //초기 로드 여부를 나타내는 변수
      
        const YrModal = document.querySelector("#yrModal");
        const deModal = document.querySelector("#deModal");
        const calendarEl = document.querySelector('#calendar');
        const mySchStart = document.querySelector("#calStart");
        const mySchEnd = document.querySelector("#calEnd");
        const mySchTitle = document.querySelector("#calTitle");
        const mySchContent = document.querySelector("#calContent");
        const eventListEl = document.querySelector('#eventList');


        
        //캘린더 헤더 옵션
        const headerToolbar = {
            left: 'prevYear,prev,next,nextYear today',
            center: 'title',
            right: 'dayGridMonth,dayGridWeek,timeGridDay'
        }

        // 캘린더 생성 옵션
        const calendarOption = {
            height: '700px', // calendar 높이 설정
            expandRows: true, // 화면에 맞게 높이 재설정
            slotMinTime: '00:00', // Day 캘린더 시작 시간
            slotMaxTime: '24:00', // Day 캘린더 종료 시간
            // 맨 위 헤더 지정
            headerToolbar: headerToolbar,
            initialView: 'dayGridMonth',  // default: dayGridMonth 'dayGridWeek', 'timeGridDay', 'listWeek'
            locale: 'kr',        // 언어 설정
            selectable: true,    // 영역 선택
            selectMirror: true,  // 오직 TimeGrid view에만 적용됨, default false
            navLinks: true,      // 날짜,WeekNumber 클릭 여부, default false
            weekNumbers: false,   // WeekNumber 출력여부, default false
            editable: true,      // 드래그 및 리사이즈 허용 여부, default false
            droppable: true, // 외부 이벤트 드롭 허용 여부
            /* 드래그를 통해 시작일 및 기간 수정가능여부
            eventStartEditable: true,
            eventDurationEditable: true,
            */
            dayMaxEventRows: true,  // Row 높이보다 많으면 +숫자 more 링크 보임!
            /*
            views: {
                dayGridMonth: {
                    dayMaxEventRows: 3
                }
            },
            */
            nowIndicator: true,
            //events:[],
            eventSources: [
                {
                   // DB 데이터 가져와서 캘린더에 리스트 보여주기
                    events: function(info, successCallback, failureCallback) { // ajax 처리로 데이터를 로딩 시킨다.
                    	
                    	$.ajax({  
	                        url: "/calendar/calendarList5",
	                        dataType: "json",
	                        type: "get",
	                        success: function(data) {
                         	console.log("data : ", data);
                          
                         	
                         	
	                         //**일정 목록 변수
	                         str = "";
	                         str2 ="";
	                         str3 ="";
	                          
                          var events = data.map(function(event) { 
                        	  
	                          // event.calStart의 시간 부분이 "00:00:00"인지 확인하여 allDay 값 설정
	                          var isAllDay = event.calStart.endsWith("00:00:00");
	                          console.log("event : ", event);
	                          console.log("event.calEnd : ", event.calEnd);
                          
                          if(firstLoad){ //처음에 일정 페이지 열었을때 한번만 일정목록 불러오기 위해
                              if(event.calSort==2){//**개인 일정 목록 
                                   str +=`<tr>
                                      <td>\${event.calTitle}</td>
                                      <td>\${event.calStart.replace(/-/g, '/')}</td>
                                      <td>\${event.calEnd.replace(/-/g, '/')}</td>
                                      </tr>`;
                                }else if(event.calSort==0){// 아파트 일정 목록
                                   //**일정 목록 
                                   str2 +=`<tr>
                                      <td>\${event.calTitle}</td>
                                      <td>\${event.calStart.replace(/-/g, '/')}</td>
                                      <td>\${event.calEnd.replace(/-/g, '/')}</td>
                                      </tr>`;
                                }else if(event.calSort==1){ // 예약 및 신청 일정 목록
                                   //**일정 목록 
                                   str3 +=`<tr>
                                      <td>\${event.calTitle}</td>
                                      <td>\${event.calStart.replace(/-/g, '/')}</td>
                                      <td>\${event.calEnd.replace(/-/g, '/')}</td>
                                      </tr>`;
                                }
                          
                          }
                          
                            return {
                              id: event.calSeq,
                              title: event.calTitle,
                              start: event.calStart,
                              allDay: isAllDay,
                              end: event.calEnd,
                              extendedProps: {// 색상 설정
                                  calSort: event.calSort
                              }
                            };
                           
                          });
                          
                          if(firstLoad){
                             firstLoad = false;
                          
                             console.log("events : ",events);
                             console.log("str : ",str);
                             console.log("str2 : ",str2);
                             console.log("str3 : ",str3);
                          // 개인 일정 목록
                             if (str !== "") {
                                 $("#dayListBody").html(str);
                             } else {
                                 $("#dayListBody").html("<tr><td colspan='3'>일정이 없습니다.</td></tr>");
                             }

                             // 아파트 일정 목록
                             if (str2 !== "") {
                                 $("#dayListBody2").html(str2);
                             } else {
                                 $("#dayListBody2").html("<tr><td colspan='3'>일정이 없습니다.</td></tr>");
                             }

                             // 예약 및 신청 일정 목록
                             if (str3 !== "") {
                                 $("#dayListBody3").html(str3);
                             } else {
                                 $("#dayListBody3").html("<tr><td colspan='3'>일정이 없습니다.</td></tr>");
                             }
                          }
                          successCallback(events);
                        },
                        error: function() {
                          failureCallback();
                        }
                      });
                    }
                  }
                  
              ],
              
              eventDidMount: function(info) {
                  if (info.event.extendedProps.calSort == 2) {// 개인일정 색상
                      	info.el.style.backgroundColor = '#cdecff';// 일정 바
                      	info.el.style.color = '#107db8'; // 글씨 
                      	info.el.style.fontSize = '16px';
                      	$(info.el).find(".fc-event-title-container").css("color","#107db8");
                  } else if (info.event.extendedProps.calSort == 0) { // 아파트 일정 색상
	                   	info.el.style.backgroundColor = '#cff8c7'; // 일정 바
	                   	info.el.style.color = '#1e8c27'; // 글씨 
	                   	info.el.style.fontSize = '16px';
                      	$(info.el).find(".fc-event-title-container").css('color','#1e8c27');
                  } else if (info.event.extendedProps.calSort == 1) {// 예약 및 신청 일정 색상
               	    	info.el.style.backgroundColor = '#ffdcdc'; // 일정 바
                       	info.el.style.color = '#ee5231'; // 글씨 
                       	info.el.style.fontSize = '16px';
                       	$(info.el).find(".fc-event-title-container").css("color","#ee5231");
                  }
              },
              
              eventDrop: function(info) {
                // 일정이 드롭되었을 때의 처리 로직
                var event = info.event;
                var newStart = event.startStr; // 수정된 시작 시간
                var newEnd = event.endStr; // 수정된 종료 시간
                console.log("info :", info);
                console.log("eventtttttt :", event);
                console.log("event._def.publicId :", event._def.publicId);
                console.log("event._def.extendedProps.calSort :", event._def.extendedProps.calSort);
                console.log("newEnd :", newEnd);
                
                let calSort = event._def.extendedProps.calSort;
                
                // 개인 일정이 아닌데 드래그 드롭으로 수정할 경우
               if(calSort != 2) {
                	console.log("calSort - else :", calSort);
                	info.revert(); // 이벤트를 원래 위치로 되돌립니다.
                        Swal.fire(
                                {
                                  title: '<strong>수정 불가</strong>',
                                  text: '개인 일정만 수정 가능합니다.',
                                  icon: 'error',
                                  showButtonColor:"blue",
                                  showCloseButton: false
                                }
                        )
                	
                	
                }else{// 개인 일정 드래그 드롭으로 수정할 경우
                	console.log("calSort - ?? :", calSort);
                	
                    let calSeq = event._def.publicId;
                    
                    let newStartUp = newStart.split("T");
                    let newStartUpp =`\${newStartUp[0]} \${newStartUp[1]}`;
                    let newStartDate =`\${newStartUp[0]}`;
                    let nStart = newStartUpp.split("+");
                    let nStartUp = `\${nStart[0]}`;
                    console.log("newStartDate:", newStartDate )
                    
                    let newEndUp = newEnd.split("T");
                    let newEndUpp =`\${newEndUp[0]} \${newEndUp[1]}`;
                    let newEndDate =`\${newEndUp[0]}`;
                    let nEnd = newEndUpp.split("+");
                    let nEndUp = `\${nEnd[0]}`;
                    console.log("newEndDate:", newEndDate )
                    
                    
                    if(newEndDate == '' || newEndDate == ' undefined'){// 종료일자가 시작일자와 동일하면  종료일자가 '' 또는  undefined 로  나옴
                    	nEndUp = nStartUp; // 시작일자와 종료일자 동일하게
                    }else{ // 종료일자값이 정상적으로 인식될때
                        nEndUp; 
                    }
                    
                 	console.log("calSeq :", calSeq);
                    
                    
                    let data ={
                    	"calSeq": calSeq,
                    	"calStart":	nStartUp,
                    	"calEnd":	nEndUp
                    }
                    console.log("drop data :", data);
                    
                    //드롭한 일정 업데이트
    	            $.ajax({
    	              url: "/calendar/dragUp",
    	              contentType:"application/json;charset=utf-8",
    	              data:JSON.stringify(data),
    	              type: "post",
    	              dataType:"json",
    	              beforeSend:function(xhr){
    	                  xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
    	               },
    	              success: function (response) {
//     	                alert('수정: ' + nStartUp + ' ~ ' + nEndUp);
    	                    Swal.fire({
    	                        icon: 'success',
    	                        title: '<strong>일정 수정 완료!</strong>',
    	                        html: '기간 : '+ nStartUp + '<br/> ~ ' + nEndUp ,
    	                        showConfirmButton: false,
    	                        timer: 1500,
    	                        showCloseButton: false
    	                    })
    	                
    	                getPlan();
	                    
    	              },
	                    error: function(xhr, status, error) {
	                        console.error("Error updating event:", error);
	                        info.revert(); // 실패 시 이벤트를 원래 위치로 되돌립니다.
	                    }
    	            });
                    
                    
                    // 여기에 수정된 일정 데이터를 서버에 전송하거나 다른 동작을 수행할 수 있습니다.
                    console.log('일정이 드롭되었습니다. 새로운 시작 시간:', nStartUp, '새로운 종료 시간:', nEndUp);
                	
                	
                }
              }
             
              
          };

        // 캘린더 생성
        const calendar = new FullCalendar.Calendar(calendarEl, calendarOption);

        // 캘린더 그리기
        calendar.render();
      
        // 캘린더 이벤트 등록
        calendar.on("eventAdd", info => console.log("Add:", info));
        calendar.on("eventChange", info => console.log("Change:", info));
        calendar.on("eventRemove", info => console.log("Remove:", info));
        calendar.on("eventClick", info => { //alert("상세보쟈"); // 일정 상세 모달 
           // 일정 상세 모달 
            const calSeq = info.event.id;
               console.log("캘린더 번호 : {}",calSeq);
               
               // AJAX 요청으로 상세 데이터 가져오기
               $.ajax({
                   url: "/calendar/detailEvent",
                   contentType: "application/json;charset=UTF-8",
                   data: JSON.stringify({ calSeq: calSeq }),
                   type: "post",
                   dataType: "json",
                   beforeSend:function(xhr){
                   xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
                  },
                   success: function(data) {
                      if (data.calSort == 2) { // 개인 일정인 경우
                         $('#deModal').modal('show'); // deModal 열기
                         deModal.style.display = "block";
                         
                       	// 상세 데이터를 모달에 채우기
                       	$("input[name='calSeq']").val(data.calSeq);
                       	$("input[name='calStart']").val(data.calStart);
                       	$("input[name='calEnd']").val(data.calEnd);
                       	$("input[name='calTitle']").val(data.calTitle);
                       	$("textarea[name='calContent']").val(data.calContent);
                       
                       	// 수정 창에서 취소 눌렀을 시 입력값 초기화.
                  	   	$("#cancle").on("click",function(){
                     
	                     	$("#p1").css("display","block");
	                     	$("#p2").css("display","none");
							//readonly 속성을 추가
	                     	$(".formdata").attr("readonly",true);// attr: 속성
	                     	// 입력란 초기화
	                     	$("input[name='calStart']").val(data.calStart);
	                     	$("input[name='calEnd']").val(data.calEnd);
	                     	$("input[name='calTitle']").val(data.calTitle);
	                     	$("textarea[name='calContent']").val(data.calContent);
	                     
	                     	console.log("calStart : " + calStart + ", calEnd : "+ calEnd + ", calTitle : " + calTitle + ",calContent : " + calContent);
	                     	console.log("detailData : {}",data)
	                  		});
                       	
	                  	  // 수정 창에서  x 눌렀을 시 입력값 초기화.
	    					$("#deClose").on("click",function(){
	    					   
	    					   $("#p1").css("display","block");
	    					   $("#p2").css("display","none");
	    					   //readonly 속성을 추가
	    					   $(".formdata").attr("readonly",true);// attr: 속성
	    					   // 입력란 초기화
	    					   $("input[name='calStart']").val(data.calStart);
	    					   $("input[name='calEnd']").val(data.calEnd);
	    					   $("input[name='calTitle']").val(data.calTitle);
	    					   $("textarea[name='calContent']").val(data.calContent);
	    					   
	    					   console.log("calStart : " + calStart + ", calEnd : "+ calEnd + ", calTitle : " + calTitle + ",calContent : " + calContent);
	    					   console.log("detailData : {}",data)
	    				   });
	                      
                    } else if(data.calSort == 0 || data.calSort == 1) { // 공통 및 예약 일정 등인 경우
                    	$('#deModal2').modal('show'); // deModal 열기
                        deModal2.style.display = "block";
                         // 상세 데이터를 모달에 채우기
                          $("input[name='calSeq']").val(data.calSeq);
                          $("input[name='calStart']").val(data.calStart);
                          $("input[name='calEnd']").val(data.calEnd);
                          $("input[name='calTitle']").val(data.calTitle);
                          $("textarea[name='calContent']").val(data.calContent);
                     };
                  
            	}
         	});
                     
                     //내용 수정  클릭시
                     $("#edit").on("click",function(){
                        $("#p1").css("display","none");
                        $("#p2").css("display","block");
                           
                        //readonly 속성을 제거
                        $(".formdata").removeAttr("readonly");
                     });

                      
                     // 일정 수정      
                       $("#update").on("click",function(){
                         let dataArray = $("#deModal").serializeArray();
                       	 console.log("dataArray : ", dataArray);
                            
                         let calSeq = $("input[name='calSeq']").val();
                         let calTitle = $("input[name='calTitle']").val();
                         let calStartArr = $("input[name='calStart']").val().split("T");
                         let calStart = `\${calStartArr[0]} \${calStartArr[1]}`;
                         console.log("시작 시간 체크:",calStart);  
                         let calEndArr = $("input[name='calEnd']").val().split("T");
                         let calEnd = `\${calEndArr[0]} \${calEndArr[1]}`;
                         console.log("종료 시간 체크:",calEnd);  
                         let calContent = $("textarea[name='calContent']").val();
                         let calStime = $("input[name='calStime']").val();
                         let calEtime = $("input[name='calEtime']").val();
                      
                         //JSON 오브젝트
                         let data = {
                            "calSeq":calSeq,
                            "calTitle":calTitle,
                            "calStart":calStart,
                            "calEnd":calEnd,
                            "calContent":calContent,
                            "calStime":calStime,
                            "calEtime":calEtime
                            };
                             
                      
                       dataArray.map(function(row, idx){
                          //       key        value
                          data[row.name] = row.value;
                       });
                       
                       console.log("data : ", data);
                       $.ajax({
                              url:"/calendar/updateEvent",
                              contentType:"application/json;charset=utf-8",
                              data:JSON.stringify(data),
                              type:"post",
                              dataType:"json",
                              beforeSend:function(xhr){
                                xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
                             },
                         	 success:function(result){
                             	console.log("result : ",result);
                            	 Swal.fire({
         	                        icon: 'success',
         	                        title: '<strong>일정 수정 완료!</strong>',
         	                        showConfirmButton: false,
         	                        timer: 1500,
         	                        showCloseButton: false
         	                    }).then(() => {
         	                       // Swal.fire의 타이머가 끝난 후 호출됩니다.
         	                       location.replace(location.href);
         	                    });
         	                    
                             
	                            $("#p1").css("display","block");
	                            $("#p2").css("display","none");
	                            //readonly 속성을 추가
	                            $(".formdata").attr("readonly",true);// attr: 속성
                          }
                       });
                    });   
                  
                   
                 // 상세 일정 삭제
                $("#delete").on("click", function(){
				    Swal.fire({
				        title: "삭제시 복구가 불가능합니다.\n삭제 하시겠습니까?",
				        icon: "warning",
				        showCancelButton: true,
				        confirmButtonClass: 'btn btn-primary w-xs me-2 mt-2',
				        cancelButtonClass: 'btn btn-danger w-xs mt-2',
				        confirmButtonText: "예",
				        cancelButtonText: "아니오",
				        buttonsStyling: false,
				        showCloseButton: true
				    }).then(function (result) {
				        if (result.value) {
				            let calSeq = $("input[name='calSeq']").val();
				            
				            // JSON 오브젝트
				            let data = {
				                "calSeq": calSeq
				            };
				            
				            // {"lprodGu": "P501"}
				            console.log("data : ", data);
				            
				            $.ajax({
				                url: "/calendar/deleteEvent",
				                contentType: "application/json;charset=utf-8",
				                data: JSON.stringify(data),
				                type: "post",
				                dataType: "json",
				                beforeSend: function(xhr){
				                    xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
				                },
				                success: function(result){
				                    // result : lprodVO
				                    console.log("result : ", result);
				                    Swal.fire({
				                        title: '삭제 완료!',
				                        icon: 'success',
				                        showConfirmButton: false,
		    	                        timer: 1500,
		    	                        showCloseButton: false
				                    }).then(function() {
				                        // Optional: 페이지를 리로드하거나 다른 동작 수행
				                        location.href = "/calendar/calendarPage";
				                    });
				                },
				                error: function() {
				                    Swal.fire({
				                        title: 'Error!',
				                        icon: 'error',
				                        confirmButtonClass: 'btn btn-primary w-xs mt-2',
				                        buttonsStyling: false
				                    });
				                }
				            });
				        } else {
				            Swal.fire({
				                title: '일정 삭제가 취소되었습니다.',
				                icon: 'error',
				                showConfirmButton: false,
    	                        timer: 1500,
    	                        showCloseButton: false
				            });
				        }
				    });
				});

                  
              
              // 개인 상세 모달창 확인(모달 꺼짐)
               $("#confirm").on("click",function(){
                  deModal.style.display = "none";
                  location.href="/calendar/calendarPage";
               });
              
              
              
            console.log("eClick:", info);
            console.log('Event: ', info.event.extendedProps);
            console.log('Coordinates: ', info.jsEvent);
            console.log('View: ', info.view);
        });
        
 
        
        calendar.on("eventMouseEnter", info => {
           console.log("eEnter:", info);
           console.log("더보기 모달 클릭1");
        });
        calendar.on("eventMouseLeave", info => {
           console.log("eLeave:", info);   console.log("더보기 모달 클릭2")
           });
        
        // 날짜 클릭 시 이벤트 설정
        calendar.on("dateClick", info => {
           console.log("dateClick:", info);    console.log("더보기 모달 클릭3")
           
           // 클릭한 날짜의 값을 datetime-local 형식에 맞게 설정
            var clickedDate = info.dateStr;
            var datetimeLocal = clickedDate + 'T00:00'; // 기본 시간을 00:00으로 설정

            // 입력 필드에 값을 설정
            $('#calStart').val(datetimeLocal);
            $('#calEnd').val(datetimeLocal);
        });
        
        
        calendar.on("select", info => {
            console.log(" select 체크:", info);

            mySchStart.value = info.startStr;
            mySchEnd.value = info.endStr;

         // 모달 엘리먼트 가져오기
            const yrModal = document.getElementById("yrModal");

            // Bootstrap의 modal show 메소드 사용하여 모달 열기
            const modal = new bootstrap.Modal(yrModal);
            modal.show();
        });

        // 일정 등록하기
        function fCalAdd() {
        	 if (!mySchTitle.value) {
        	        Swal.fire({
        	            title: '제목을 작성해주세요',
        	            icon: 'warning',
        	            confirmButtonClass: 'btn btn-primary w-xs mt-2',
        	            buttonsStyling: false,
        	            showCloseButton: true
        	        }).then(function() {
        	            mySchTitle.focus(); // SweetAlert가 닫힌 후 포커스를 제목 입력 필드로 이동
        	        });
        	        return;
        	    }
            

            let calStartArr = mySchStart.value.split("T");
            let calStart = `\${calStartArr[0]} \${calStartArr[1]}`;
            console.log("시작 시간 체크:",calStart);  

            let calEndArr = mySchEnd.value.split("T");
            let calEnd = `\${calEndArr[0]} \${calEndArr[1]}`;
            console.log("종료 시간 체크:",calEnd);  


            let event = { // ajax 전송용
               calStart,
               calEnd,
               calTitle: mySchTitle.value,
               calContent: mySchContent.value

            };
         
            let calSort = 2;
            
            let newEvent = { // event 발생용
                start: mySchStart.value,
                end: mySchEnd.value,
                title: mySchTitle.value,
                content: calContent.value,
                extendedProps: {
                    calSort: calSort
                }
             
            };
         
           console.log("event:",event); 
           
            // 서버로 일정을 전송
            $.ajax({
                url: "/calendar/addEvent",
                contentType: "application/json;charset=UTF-8",
                data: JSON.stringify(event),
                type: "post",
                dataType:"text",
                beforeSend:function(xhr){
               xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
            },
                success: function(response) {
//                     alert("일정이 추가되었습니다.");
//                     location.href="/calendar/calendarPage";
                	Swal.fire({
	                        icon: 'success',
	                        title: '일정 추가 완료!',
	                        showConfirmButton: false,
	                        timer: 1500,
	                        showCloseButton: false
	                    }).then(() => {
	                       // Swal.fire의 타이머가 끝난 후 호출됩니다.
	                       location.replace(location.href);
	                    });
                    
                    }
            });
            console.log("addEvent////",event)
            console.log("newEvent////",newEvent)
            calendar.addEvent(newEvent); // 이벤트 발생
//             fMClose(); // 모달창 닫기
            
        }
        
        // 등록 모달에서 취소 클릭시
        $("#close").on("click",function(){
       	//입력란 초기화 
       	document.getElementById('calStart').value = '';
      	    document.getElementById('calEnd').value = '';
      	    document.getElementById('calTitle').value = '';
      	    document.getElementById('calContent').value = '';
        });
        
        // 
        $("#close2").on("click",function(){
       	//입력란 초기화 
        	document.getElementById('calStart').value = '';
      	    document.getElementById('calEnd').value = '';
      	    document.getElementById('calTitle').value = '';
      	    document.getElementById('calContent').value = '';
        });

//         // 등록 모달 닫기
//         function fMClose() {
//             YrModal.style.display = "none";
//         }
        
        
        // 다음/ 이전 달 선택 시 일정 목록 가져오기
        $("button").on("click", getPlan);
        		
        function getPlan(){
           let ym = $("#fc-dom-1").html();
           //2024년  8월 -> 202408
           //2024년 10월 -> 202410
           ym = ym.replace("월","");
           ym = ym.replace("년","");
           //2024  8
           ym = ym.replace("  "," ");
           ym = ym.replace("  "," ");
           //2024 8
           //2024 10
           let ymArr = ym.split(" ");
           let yr = ymArr[0];
           let mon = ('0' + ymArr[1]).slice(-2);
           
           let yrmon = yr+mon;
           console.log("yrmon : ", yrmon);
           
           $.ajax({  
                url: "/calendar/calendarList6?yrmon="+yrmon,
                dataType: "json",
                type: "get",
                beforeSend:function(xhr){
               xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");
            },
                success: function(data) {
                  console.log("data(6) : ", data);
                  
                  //**일정 목록 변수
                  str = "";
                  str2 = "";
                  str3 = "";
                  
                 var events = data.map(function(event) { 
                 if(event.calSort==2){//**개인 일정 목록 
                      str +=`<tr>
                         <td>\${event.calTitle}</td>
                         <td>\${event.calStart.replace(/-/g, '/')}</td>
                         <td>\${event.calEnd.replace(/-/g, '/')}</td>
                         </tr>`;
                    }else if(event.calSort==0){// 아파트 일정 목록
                        //**일정 목록 
                        str2 +=`<tr>
                           <td>\${event.calTitle}</td>
                           <td>\${event.calStart.replace(/-/g, '/')}</td>
                           <td>\${event.calEnd.replace(/-/g, '/')}</td>
                           </tr>`;
                    }else if(event.calSort==1){ // 예약및 신청 일정 목록
                        //**일정 목록 
                        str3 +=`<tr>
                           <td>\${event.calTitle}</td>
                           <td>\${event.calStart.replace(/-/g, '/')}</td>
                           <td>\${event.calEnd.replace(/-/g, '/')}</td>
                           </tr>`;
                     }
                       
                    
               });
                  console.log("str : ",str);
                  console.log("str2 : ",str2);
                  console.log("str3 : ",str3);
               // 개인 일정 목록
                  if (str !== "") {
                      $("#dayListBody").html(str);
                  } else {
                      $("#dayListBody").html("<tr><td colspan='3'>일정이 없습니다.</td></tr>");
                  }

                  // 아파트 일정 목록
                  if (str2 !== "") {
                      $("#dayListBody2").html(str2);
                  } else {
                      $("#dayListBody2").html("<tr><td colspan='3'>일정이 없습니다.</td></tr>");
                  }

                  // 예약 및 신청 일정 목록
                  if (str3 !== "") {
                      $("#dayListBody3").html(str3);
                  } else {
                      $("#dayListBody3").html("<tr><td colspan='3'>일정이 없습니다.</td></tr>");
                  }
                },
                error: function() {
                }
              });
        };
        getPlan();
    </script>

    