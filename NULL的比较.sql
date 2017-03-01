-- 问题的引出：C语言中，NULL==NULL的比较返回的是1
SELECT 1=NULL
-- 结果为NULL，而不是0
SELECT NULL=NULL
-- 结果为NULL，而不是1
-- 总结：对于比较返回值为NULL的情况，可将其视为UNKOWN，即表示未知的。