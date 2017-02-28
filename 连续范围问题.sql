-- 创建表并插入数据
create table t(a int primary key);
insert into t values(1);
insert into t values(2);
insert into t values(3);
insert into t values(100);
insert into t values(101);
insert into t values(103);
insert into t values(104);
insert into t values(105);

-- 问题一：求数据的连续范围
-- 1、给数据增加行号
SET @a:=0;
SELECT a, @a:=@a+1 AS rn FROM t;
-- 或
SELECT a, @a:=@a+1 rn FROM t, (SELECT @a:=0) AS b;
-- 或
SELECT a, @a:=@a+1 rn FROM t, (SELECT @a:=0) AS a;
-- 2、求数据与行号的差值
SELECT a, rn, a-rn AS diff FROM(
	SELECT a, @a:=@a+1 rn FROM t, (SELECT @a:=0) AS a
) AS b;
-- 3、分组统计得到结果
SELECT MIN(a) start_range, MAX(a) end_range FROM(
	SELECT a, rn, a-rn AS diff FROM(
		SELECT a, @a:=@a+1 rn FROM t, (SELECT @a:=0) AS a
	) AS b
) AS c GROUP BY diff;

-- 问题二：求数据的间断范围
-- 核心思路：构造自定义变量@a，使得如果数据连续，每行的值减去@a应该是1
SELECT rn+1 start_range, a-1 end_range FROM(
	SELECT a, @a rn, @a:=a FROM t, (
		SELECT @a:=MIN(a)-1 FROM t
	) AS b
) AS c WHERE a-rn <> 1

-- 在项目中的应用：求驾驶员最长连续签到的时间段
SELECT * FROM(
	SELECT e.*, @npre:=@ncur, @ncur:=e.driverId, IF(@npre=@ncur, @nrn:=@nrn+1, @nrn:=1) AS nrn FROM(
		SELECT driverId, MIN(signInTime), MAX(signInTime), COUNT(*) FROM(
			SELECT b.*, @pre:=@cur, @cur:=driverId, IF(@pre=@cur, @rn:=@rn+1, @rn:=1) AS rank, diff-@rn AS flag
			-- rank是列的别名，不能直接引用。而@表示变量，可以引用，但是需要给它赋值。
			-- “AS rank, diff-@rank”，这里rank和@rank的类型不同。
			FROM(
				SELECT DISTINCT driverId, DATE_FORMAT(signInTime, '%Y-%m-%d') signInTime, DATEDIFF(signInTime, NOW()) diff
				FROM driver_attendance ORDER BY driverId, signInTime
			) AS b, (SELECT @pre:=1, @cur:=1, @rn:=1) AS c
		) AS d GROUP BY driverId, flag ORDER BY driverId, COUNT(*) DESC
	) AS e, (SELECT @npre:=1, @ncur:=1, @nrn:=1) AS f
)AS g WHERE nrn=1