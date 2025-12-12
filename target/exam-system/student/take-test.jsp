<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.List,java.util.Map" %>
<%@ page import="Bean.Question,Bean.Answer,Bean.TestSession,Bean.Test" %>
<% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role"); String fullname=(String) session.getAttribute("fullname"); if (username==null || role==null || !role.equals("STUDENT")) { response.sendRedirect("../login.jsp"); return; } %>
<% Test test = (Test) request.getAttribute("test"); List<Question> questions = (List<Question>) request.getAttribute("questions"); Map<Integer, List<Answer>> answersMap = (Map<Integer, List<Answer>>) request.getAttribute("answersMap"); Integer remainingSeconds = (Integer) request.getAttribute("remainingSeconds"); TestSession ts = (TestSession) request.getAttribute("testSession"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Thi: <%= test.getName() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/take-test.css">
</head>
<body>
    <div class="navbar">
        <div class="navbar-brand">
            <div class="logo">📚</div>
            <h1>Hệ Thống Thi Trắc Nghiệm</h1>
        </div>
        <div class="navbar-right">
            <a href="<%= request.getContextPath() %>/student-dashboard.jsp" class="home-btn">🏠 Trang chủ</a>
            <div class="timer">
                ⏱️ Thời gian còn lại: <div id="timer">--:--</div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="content">
            <h2>✏️ Thi: <%= test.getName() %></h2>
            <div class="info-box">
                📌 Tổng số câu: <strong><%= questions.size() %></strong> | ⏱️ Thời lượng: <strong><%= test.getTime() %></strong> phút | Lưu ý: Mỗi sinh viên chỉ được thi 1 lần
            </div>

            <form id="examForm">
                <input type="hidden" name="testId" value="<%= test.getId() %>" />
                
                <div id="questions">
                <% int qNum = 1; for (Question q : questions) { %>
                    <div class="question" data-qid="<%= q.getId() %>">
                        <div class="question-header">
                            <strong>Câu <%= qNum %>:</strong>
                        </div>
                        <div class="question-content"><%= q.getContent() %></div>
                        <div class="options">
                            <% List<Answer> opts = answersMap.get(q.getId()); if (opts!=null) { for (Answer a: opts) { %>
                                <label class="option-label">
                                    <input type="radio" name="ans_<%= q.getId() %>" value="<%= a.getOptionKey() %>" />
                                    <span class="option-text"><strong><%= a.getOptionKey() %>.</strong> <%= a.getContent() %></span>
                                </label>
                            <% } } %>
                        </div>
                    </div>
                <% qNum++; } %>
                </div>

                <div class="button-group">
                    <button type="button" id="submitBtn" class="btn btn-submit">💾 Nộp bài</button>
                    <!-- <a href="<%= request.getContextPath() %>/student?action=list" class="btn btn-exit">← Quay lại</a> -->
                </div>
            </form>
        </div>
    </div>

<script>
const remainingStart = <%= (remainingSeconds!=null? remainingSeconds:0) %>;
let remaining = remainingStart;
let intervalId = null;
let timeSpent = <%= ts.getTimeSpentSeconds() %> || 0;

function startTimer(){
    const el = document.getElementById('timer');
    function tick(){
        if (remaining<=0){
            el.innerText = '00:00';
            clearInterval(intervalId);
            autoSubmit(true);
            return;
        }
        remaining--; timeSpent++;
        let mm = Math.floor(remaining/60); let ss = remaining%60;
        el.innerText = (mm<10? '0'+mm:mm) + ':' + (ss<10? '0'+ss:ss);
    }
    tick(); intervalId = setInterval(tick,1000);
}

function collectAnswers(){
    const selected = {};
    document.querySelectorAll('[name^="ans_"]').forEach(r=>{
        if (r.checked) {
            const qid = r.name.substring(4);
            selected[qid] = r.value;
        }
    });
    return selected;
}

// Highlight selected option
document.querySelectorAll('.option-label input[type="radio"]').forEach(r=>{
    r.addEventListener('change', function(){
        document.querySelectorAll('label[data-qid="'+this.name.substring(4)+'"]').forEach(l=>l.classList.remove('selected'));
        this.parentElement.classList.add('selected');
        autosave();
    });
});

async function autosave(){
    const sel = collectAnswers();
    const payload = { order: {}, selected: sel };
    const params = new URLSearchParams();
    params.append('action','autosave');
    params.append('testId',''+<%= test.getId() %>);
    params.append('answersJson', JSON.stringify(payload));
    params.append('timeSpentSeconds', ''+timeSpent);
    try{
        await fetch('<%= request.getContextPath() %>/student', { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: params });
    }catch(e){ console.error(e); }
}

function disableUI(){ 
    document.getElementById('examForm').classList.add('disabled'); 
    document.getElementById('submitBtn').disabled = true;
}

async function autoSubmit(timeout){
    disableUI();
    const sel = collectAnswers();
    const payload = { order: {}, selected: sel };
    const params = new URLSearchParams();
    params.append('action','submit-test');
    params.append('testId',''+<%= test.getId() %>);
    params.append('answersJson', JSON.stringify(payload));
    params.append('timeSpentSeconds', ''+timeSpent);
    try{
        const res = await fetch('<%= request.getContextPath() %>/student', { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: params });
        const txt = await res.text();
        if (txt && txt.startsWith('OK|')){
            const score = txt.split('|')[1];
            alert((timeout? 'Hết giờ. ':'') + 'Bài đã được nộp. Điểm của bạn: ' + score + '/100');
            window.location = '<%= request.getContextPath() %>/student?action=list';
        } else {
            alert('Lỗi khi nộp bài');
        }
    }catch(e){ console.error(e); alert('Lỗi mạng khi nộp'); }
}

document.getElementById('submitBtn').addEventListener('click', function(){ 
    if(confirm('Bạn chắc chắn nộp bài? Hành động này không thể hoàn tác.')) autoSubmit(false); 
});

startTimer();
setInterval(autosave, 10000);
</script>
</body>
</html>