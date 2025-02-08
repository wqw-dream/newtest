from bottle import Bottle, template, request
import sqlite3

app = Bottle()

# 首页路由，渲染包含选择框的页面
@app.route('/')
def index():
    return template('index.tpl', results=[])

# 处理表单提交的路由
@app.route('/search', method='POST')
def search():
    # 使用 request.forms.get 方法获取选择框的值
    biz_type = request.forms.get('biz_type')
    month = request.forms.get('month')
    
    # 连接到 SQLite 数据库
    conn = sqlite3.connect('bill_web.db')
    cursor = conn.cursor()

    # 查询所有类别，用于重新渲染选择框
    if biz_type and month:
        cursor.execute('SELECT appkey, ratio, biz_type, version FROM appkey_ratio')
       # results = [row[0] for row in cursor.fetchall()]
        results = cursor.fetchall()
    else:
        results = []

    print(results)
    # 关闭数据库连接
    conn.close()

    return template('index.tpl', results=results)

if __name__ == '__main__':
    app.run(host='localhost', port=8080, debug=True)
