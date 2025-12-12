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
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; flex-direction: column; }
        .navbar { background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { color: #333; font-size: 24px; }
        .navbar-right { display: flex; align-items: center; gap: 20px; }
        .timer { background: white; padding: 12px 20px; border-radius: 6px; text-align: center; font-weight: bold; color: #333; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .timer #timer { font-size: 28px; color: #e74c3c; font-family: monospace; }
        .logout-btn { background: #e74c3c; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; text-decoration: none; transition: background 0.3s; }
        .logout-btn:hover { background: #c0392b; }
        .container { flex: 1; display: flex; justify-content: center; padding: 30px 20px; }
        .content { background: white; border-radius: 10px; box-shadow: 0 5px 25px rgba(0,0,0,0.2); padding: 40px; width: 100%; max-width: 900px; max-height: 85vh; overflow-y: auto; }
        h2 { color: #333; margin-bottom: 25px; font-size: 26px; }
        .info-box { background: #f0f8ff; border-left: 4px solid #2196f3; padding: 15px; border-radius: 4px; margin-bottom: 25px; font-size: 14px; color: #1565c0; }
        .question { margin-bottom: 30px; padding: 20px; background: #f9f9f9; border: 1px solid #e0e0e0; border-radius: 8px; }
        .question-header { margin-bottom: 15px; }
        .question-header strong { color: #333; font-size: 15px; }
        .question-content { color: #333; margin: 10px 0; font-size: 15px; line-height: 1.6; }
        .options { margin-top: 15px; display: flex; flex-direction: column; gap: 8px; }
        .option-label { display: flex; align-items: center; padding: 10px; background: white; border: 1px solid #ddd; border-radius: 4px; cursor: pointer; transition: all 0.3s; }
        .option-label:hover { background: #f5f5f5; border-color: #667eea; }
        .option-label input[type="radio"] { margin-right: 10px; cursor: pointer; }
        .option-text { flex: 1; }
        .option-label.selected { background: #e3f2fd; border-color: #667eea; }
        .button-group { display: flex; gap: 15px; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; }
        .btn { padding: 12px 30px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: 600; transition: all 0.3s; text-decoration: none; display: inline-block; }
        .btn-submit { background: #27ae60; color: white; flex: 1; }
        .btn-submit:hover { background: #229954; transform: translateY(-2px); }
        .btn-exit { background: #95a5a6; color: white; }
        .btn-exit:hover { background: #7f8c8d; }
        .disabled { opacity: 0.6; pointer-events: none; }
        .message { padding: 15px; border-radius: 5px; margin-bottom: 20px; text-align: center; font-weight: 600; }
        .message-error { background: #ffe5e5; color: #c0392b; border: 1px solid #e74c3c; }
        .message-success { background: #e5ffe5; color: #27ae60; border: 1px solid #2ecc71; }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>📚 Hệ Thống Thi Trắc Nghiệm</h1>
        <div class="navbar-right">
            <div class="timer">
                ⏱️ Thời gian còn lại: <div id="timer">--:--</div>
            </div>
            <!-- <a href="<%= request.getContextPath() %>/student?action=list" class="logout-btn">← Quay lại</a> -->
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