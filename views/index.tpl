<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>导航窗格示例</title>
    <style>
        .tab-container {
            width: 80%;
            margin: 20px auto;
        }
        .tabs {
            display: flex;
            border-bottom: 1px solid #ccc;
        }
        .tab {
            padding: 10px 20px;
            cursor: pointer;
            background-color: #f1f1f1;
            border: 1px solid #ccc;
            border-bottom: none;
            margin-right: 5px;
        }
        .tab.active {
            background-color: white;
            border-bottom: 1px solid white;
            margin-bottom: -1px;
        }
        .tab-content {
            display: none;
            padding: 20px;
            border: 1px solid #ccc;
            border-top: none;
        }
        .tab-content.active {
            display: block;
        }
    </style>
</head>
<body onload="restoreActiveTab()">
    <div class="tab-container">
        <div class="tabs">
            <div class="tab active" onclick="switchTab(0)">业务分摊查询</div>
            <div class="tab" onclick="switchTab(1)">分摊比例查询</div>
            <div class="tab" onclick="switchTab(2)">分业务占比</div>
        </div>
        
        <div class="tab-content">
            <h2>业务分摊查询</h2>
        </div>
        
        <div class="tab-content">
            <h2>分摊比例查询</h2>
            
            <form method="post" action="/search">
                <label for="biz_type">业务类型:</label>
                <select name="biz_type" id="biz_type">
                    <option value="">请选择业务类型</option>
                    <option value="video">短视频</option>
                    <option value="live">直播</option>
                    <option value="dianping">点评</option>
                </select>
                &nbsp;&nbsp
                <label for="month">月份:</label>
                <select name="month" id="month">
                    <option value="">请选择月份</option>
                    <option value=202501>202501</option>
                    <option value=202502>202502</option>
                    <option value=202503>202503</option>
                </select>
                <input type="submit" value="查询">
            </form>
            
            <hr>
            <style>
                table {
                    border-collapse: collapse;
                    width: 80%;
                }
                th, td {
                    border: 1px solid #ddd;
                    padding: 8px;
                    text-align: left;
                }
                th {
                    background-color: #f2f2f2;
                }
            </style>
            
            % if results:
                <table id="result_table">
                    <thead>
                        <tr>
                            <th>APPKEY</th>
                            <th>RATIO</th>
                            <th>BIZ_TYPE</th>
                            <th>VERSION</th>
                            <th>MODIFY_TIME</th>
                        </tr>
                    </thead>
                    <tbody>
                        % for res in results:
                            <tr>
                                <td>{{res[0]}}</td>
                                <td contenteditable="true">{{res[1]}}</td>
                                <td>{{res[2]}}</td>
                                <td>{{res[3]}}</td>
                                <td>{{res[4]}}</td>
                            </tr>
                        % end
                    </tbody>
                </table>
            <button onclick="saveChanges()">保存</button>
            % else:
                <table id="result_table"></table>
                <p>No results found.</p>
            % end
            <script>
                // 页面加载时记录表格的初始状态
                window.onload = function () {
                    const table = document.getElementById('result_table');
                    const rows = table.rows;
                    window.initialTableData = [];
                    for (let i = 1; i < rows.length; i++) {
                        const cells = rows[i].cells;
                        const rowData = {};
                        for (let j = 0; j < cells.length; j++) {
                            const header = table.rows[0].cells[j].textContent.toLowerCase();
                            rowData[header] = cells[j].textContent;
                        }
                        window.initialTableData.push(rowData);
                    }
                    restoreActiveTab()
                };
        
                function saveChanges() {
                    const table = document.getElementById('result_table');
                    const rows = table.rows;
                    const currentTableData = [];
                    for (let i = 1; i < rows.length; i++) {
                        const cells = rows[i].cells;
                        const rowData = {};
                        for (let j = 0; j < cells.length; j++) {
                            const header = table.rows[0].cells[j].textContent.toLowerCase();
                            rowData[header] = cells[j].textContent;
                        }
                        currentTableData.push(rowData);
                    }
        
                    const changedRows = [];
                    for (let i = 0; i < currentTableData.length; i++) {
                        const initialRow = window.initialTableData[i];
                        const currentRow = currentTableData[i];
                        let isChanged = false;
                        for (const key in initialRow) {
                            if (initialRow[key]!== currentRow[key]) {
                                isChanged = true;
                                break;
                            }
                        }
                        if (isChanged) {
                            changedRows.push(currentRow);
                        }
                    }
        
                    if (changedRows.length > 0) {
                        let message = "本次修改的行内容如下：\n";
                        changedRows.forEach((row, index) => {
                            message += `第 ${index + 1} 行：`;
                            for (const key in row) {
                                message += `${key}: ${row[key]}  `;
                            }
                            message += "\n";
                        });
                        // 弹窗提示修改的行内容
                        const confirmSave = confirm(message + "确认保存这些修改吗？");
        
                        if (confirmSave) {
                            console.log('Changed rows:', changedRows);
                            fetch('/update_table', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(changedRows)
                            })
                           .then(response => {
                                if (!response.ok) {
                                    throw new Error(`HTTP error! status: ${response.status}`);
                                }
                                return response.json();
                            })
                           .then(result => {
                                restoreActiveTab()
                                console.log('Server response:', result);
                                alert('Server response: ' + JSON.stringify(result));
                            })
                           .catch(error => {
                                restoreActiveTab()
                                console.error('Fetch error:', error);
                                alert('Fetch error: ' + error.message);
                            });
                        }
                    } else {
                        restoreActiveTab()
                        console.log('No changes detected.');
                        alert('No changes detected.');
                    }
                }
            </script>
        
        </div>
        
        <div class="tab-content">
            <h2>窗格三内容</h2>
            <p>这是第三个导航窗格的内容。</p>
            <form>
                <input type="text" placeholder="示例输入框">
                <button type="submit">提交</button>
            </form>
        </div>
    </div>

    <script>
        function switchTab(tabIndex) {
            // 获取所有标签和内容
            const tabs = document.getElementsByClassName('tab');
            const contents = document.getElementsByClassName('tab-content');
            
            //移除所有活动状态
            for(let i = 0; i < tabs.length; i++) {
                tabs[i].classList.remove('active');
                contents[i].classList.remove('active');
            }
            
            // 设置选中标签的活动状态
            tabs[tabIndex].classList.add('active');
            contents[tabIndex].classList.add('active');

            // 将当前激活的标签页索引存储到 localStorage 中
            localStorage.setItem('activeTabIndex', tabIndex);
        }

        function restoreActiveTab() {
            // 从 localStorage 中获取之前存储的索引
            const activeTabIndex = localStorage.getItem('activeTabIndex');

            if (activeTabIndex!== null) {
                // 调用 switchTab 函数将对应的标签页和内容设置为激活状态
                switchTab(parseInt(activeTabIndex));
            } else {
                // 如果没有存储的索引，默认激活第一个标签页
                switchTab(0);
            }
        }
    </script>
</body>
</html>