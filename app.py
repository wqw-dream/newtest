from bottle import Bottle, template, request,response

import json
from datetime import datetime
import sqlite3
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)

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
    # 设置日志记录

    logger.info(f"Searching for biz_type: {biz_type}, version: {month}")
    
    # 查询所有类别，用于重新渲染选择框
    if biz_type and month:
        try:
            # 执行查询
            search_sql = "SELECT appkey, ratio, biz_type, version, modify_time FROM appkey_ratio WHERE biz_type = ? AND version = ?"
            cursor.execute(search_sql, (biz_type, month))
        except sqlite3.Error as e:
            logger.error(f"Database error occurred: {e}")
            return []
            
       # results = [row[0] for row in cursor.fetchall()]
        #cursor.execute('SELECT appkey, ratio, biz_type, version, modify_time FROM appkey_ratio')
        results = cursor.fetchall()
    else:
        results = []

    print(results)
    # 关闭数据库连接
    conn.close()

    return template('index.tpl', results=results)

@app.route('/update_table', method='POST')
def update_table():
    try:
        data = request.json
        print('Received data:', data)
        
        # 这里可以添加将数据保存到数据库的逻辑
        conn = sqlite3.connect('bill_web.db')
        cursor = conn.cursor()

        for row in data:
            # 假设每行数据中有一个 id 字段用于唯一标识记录
            appkey = row.get('appkey')
            ratio = row.get('ratio')
            biz_type = row.get('biz_type')
            version = row.get('version')
            
            modify_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            print(modify_time)

            if appkey:
                # 构建 UPDATE 语句
                update_query = "UPDATE appkey_ratio SET ratio = ?, biz_type = ?, version = ?, modify_time = ? WHERE appkey = ?"
                cursor.execute(update_query, (ratio, biz_type, version, modify_time, appkey))

        conn.commit()
        conn.close()

        response.content_type = 'application/json'
        return json.dumps({'message': 'Changed data updated successfully'})
    
    except Exception as e:
        print('Error processing request:', e)
        response.status = 500
        return json.dumps({'error': str(e)})


if __name__ == '__main__':
    app.run(host='localhost', port=8080, debug=True)
