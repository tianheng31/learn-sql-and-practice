-- 我们通过司机考勤，建立驾驶员和车辆的对应关系，在现实中，车队可能不会每天都进行考勤。
-- 一般情况下驾驶员不会频繁更换车辆，因此，这就要求车队至少在驾驶员更换车辆时进行考勤。
-- 在查询驾驶员和车辆对应关系时，提取某驾驶员的最后一条考勤信息即可。

SELECT vehicleNo, deviceId, driverName, driverId, lineDeptId, signInTime
FROM
  (SELECT
    t1.vehicleNo,
    t1.deviceId,
    t1.driverName,
    t1.driverId,
    t1.lineDeptId,
    t1.signInTime,
    IF(@vno <> t1.vehicleNo, @r := 1, @r := @r + 1) AS r,
    @vno := t1.vehicleNo
  FROM
    (SELECT * FROM driver_attendance ORDER BY vehicleNo, signInTime DESC) t1
    INNER JOIN
    (SELECT @r := 0, @vno := '') t2 -- 初始化用户变量
    ON 1 = 1) tt
WHERE r = 1 ;