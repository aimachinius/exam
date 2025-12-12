<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.List,java.util.Map" %>
<%@ page import="Bean.Question,Bean.Answer,Bean.TestSession" %>
<% String username=(String) session.getAttribute("username"); String role=(String) session.getAttribute("role"); if (username==null || role==null || !role.equals("STUDENT")) { response.sendRedirect("../login.jsp"); return; } %>
<% Test test = (Test) request.getAttribute("test"); List<Question> questions = (List<Question>) request.getAttribute("questions"); Map<Integer, List<Answer>> answersMap = (Map<Integer, List<Answer>>) request.getAttribute("answersMap"); Integer remainingSeconds = (Integer) request.getAttribute("remainingSeconds"); TestSession ts = (TestSession) request.getAttribute("testSession"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Thi: <%= test.getName() %></title>
    <style> .question{margin-bottom:20px;padding:10px;border:1px solid #ddd;} .option{margin:6px 0;} .disabled{opacity:0.6;pointer-events:none;} </style>
</head>
<body>
    <h2>Thi: <%= test.getName() %></h2>
    <div>Thời gian còn lại: <span id="timer"></span></div>
    <form id="examForm">
        <input type="hidden" name="testId" value="<%= test.getId() %>" />
        <div id="questions">
            <% for (Question q : questions) { %>
                <div class="question" data-qid="<%= q.getId() %>">
                    <div><strong>Câu <%= questions.indexOf(q)+1 %>:</strong> <%= q.getContent() %></div>
                    <div>
                        <% List<Answer> opts = answersMap.get(q.getId()); if (opts!=null) { for (Answer a: opts) { %>
                            <div class="option">
                                <label>
                                    <input type="radio" name="ans_<%= q.getId() %>" value="<%= a.getOptionKey() %>" />
                                    <%= a.getOptionKey() %>. <%= a.getContent() %>
                                </label>
                            </div>
                        <% } } %>
                    </div>
                </div>
            <% } %>
        </div>
        <div style="margin-top:20px;">
            <button type="button" id="submitBtn">Nộp bài</button>
            <a href="<%= request.getContextPath() %>/student?action=list">Thoát</a>
        </div>
    </form>

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

async function autosave(){
    const sel = collectAnswers();
    const payload = { order: {}, selected: sel };
    // no need to send order here; server already has it
    const params = new URLSearchParams();
    params.append('action','autosave');
    params.append('testId',''+<%= test.getId() %>);
    params.append('answersJson', JSON.stringify(payload));
    params.append('timeSpentSeconds', ''+timeSpent);
    try{
        await fetch('<%= request.getContextPath() %>/student', { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded'}, body: params });
    }catch(e){ console.error(e); }
}

function disableUI(){ document.getElementById('examForm').classList.add('disabled'); }

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
            alert((timeout? 'Hết giờ. ':'') + 'Bài đã được nộp. Điểm: ' + score);
            window.location = '<%= request.getContextPath() %>/student?action=list';
        } else {
            alert('Lỗi khi nộp bài');
        }
    }catch(e){ console.error(e); alert('Lỗi mạng khi nộp'); }
}

document.getElementById('submitBtn').addEventListener('click', function(){ if(confirm('Bạn chắc chắn nộp bài?')) autoSubmit(false); });
startTimer();
setInterval(autosave, 10000);
</script>
</body>
</html>