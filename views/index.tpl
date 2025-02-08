<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>业务分摊查询</title>
</head>
<body>
    <h1>业务分摊查询</h1>
    <form method="post" action="/search">
        <label for="biz_type">业务类型:</label>
        <select name="biz_type">
            <option value="vedio">短视频</option>
            <option value="live">直播</option>
            <option value="dianping">点评</option>
        </select>
        &nbsp;&nbsp
        <label for="month">月份:</label>
        <select name="month">
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
        <table>
            <thead>
                <tr>
                    <th>APPKEY</th>
                    <th>RATIO</th>
                    <th>BIZ_TYPE</th>
                    <th>VERSION</th>
                </tr>
            </thead>
            <tbody>
                % for res in results:
                    <tr>
                        <td>{{res[0]}}</td>
                        <td>{{res[1]}}</td>
                        <td>{{res[2]}}</td>
                        <td>{{res[3]}}</td>
                    </tr>
                % end
            </tbody>
        </table>
    % end
</body>
</html>
