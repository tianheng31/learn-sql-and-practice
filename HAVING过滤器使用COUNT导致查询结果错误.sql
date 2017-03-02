-- 有驾驶员基本信息表和驾驶员违章记录表，想要查询违章驾驶员的手机号码。

-- 为了便于说明问题，仅列出表中的关键字段。
-- drivername   drivertel
-- 蔡子英       13587984934
-- 陈建平       13598898998
-- 戴胜军       15502938902
-- 邓芳兰       (NULL)
-- 韩鹏飞       13298702987
-- 革新         (NULL)
-- 王琪琪       15502938902
-- 陆梦溪       15502938902
-- 小埋         18706073384
-- lmx1号       18129382910

-- driverName   violationName
-- 蔡子英       闯红灯
-- 蔡子英       超速
-- 戴胜军       闯红灯
-- 蔡子英       闯红灯
-- 蔡子英       闯红灯
-- 王琪琪       不知道名称是啥
-- 韩鹏飞       逆行
-- 陆梦溪       ~~~~(>_<)~~~~

-- 最初的写法：
SELECT a.drivername, a.drivertel, b.violationName FROM t_driverinfo a LEFT JOIN t_vehicleviolationrecord b
ON a.drivername=b.driverName GROUP BY a.drivername HAVING COUNT(*)>=1
-- 查询结果：
-- drivername   drivertel     violationName
-- lmx1号       18129382910   (NULL)
-- 小埋         18706073384   (NULL)
-- 戴胜军       15502938902   闯红灯
-- 王琪琪       15502938902   不知道名称是啥
-- 蔡子英       13587984934   闯红灯
-- 邓芳兰       (NULL)        (NULL)
-- 陆梦溪       15502938902   ~~~~(>_<)~~~~
-- 陈建平       13598898998   (NULL)
-- 革新         (NULL)        (NULL)
-- 韩鹏飞       13298702987   逆行

-- 出现错误的原因：在这个分组中不能使用COUNT(*)或COUNT(1)，因为这会把通过OUTER JOIN添加的行统计入内（非保留表的空值数据），
-- 导致最终查询结果与预期结果不同。

-- 改进写法：
SELECT a.drivername, a.drivertel, b.violationName FROM t_driverinfo a LEFT JOIN t_vehicleviolationrecord b
ON a.drivername=b.driverName GROUP BY a.driverName HAVING COUNT(violationName)>=1
-- 或
SELECT a.drivername, a.drivertel, b.violationName FROM t_driverinfo a INNER JOIN t_vehicleviolationrecord b
ON a.drivername=b.driverName GROUP BY a.driverName HAVING COUNT(*)>=1
-- 查询结果：
-- drivername   drivertel     violationName
-- 戴胜军       15502938902   闯红灯
-- 王琪琪       15502938902   不知道名称是啥
-- 蔡子英       13587984934   闯红灯
-- 陆梦溪       15502938902   ~~~~(>_<)~~~~
-- 韩鹏飞       13298702987   逆行