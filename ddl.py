import sqlite3

# 连接到 SQLite 数据库
conn = sqlite3.connect('bill_web.db')
cursor = conn.cursor()

# 创建一个示例表
cursor.execute('''
CREATE TABLE IF NOT EXISTS appkey_ratio (
    appkey TEXT,
    ratio TEXT,
    biz_type TEXT,
    version TEXT
)
''')

# 插入示例数据
data = [
    ('abc', '0.1', 'video', '202501'),
    ('def', '0.1', 'video', '202501'),
]

cursor.executemany('INSERT INTO appkey_ratio (appkey, ratio, biz_type, version) VALUES (?,?,?,?)', data)

# 提交更改并关闭连接
conn.commit()
conn.close()
