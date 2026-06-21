---
alwaysApply: false
description: 设计数据库时生效
---
# 数据库设计规则
- 对表和字段修改时，先评估改动数量，如果较少用alter语句修改，较多就重新创建表
- 重新创建表时，如果表中没有数据，直接用create if not exists语句创建，如果有数据必须先询问用户接下来的处理方案
- 数据库、表、字段字符集都采用utf8mb4，排序规则为utf8mb4_bin
- 一般情况下不添加外键、唯一索引
- 一般情况下，要在表最后按顺序添加deleted、create_user、update_user、create_time、update_time字段，分别表示删除状态、创建用户、修改用户、创建时间、修改时间
- 主键等ID类字段使用varchar类型，长度为36
- 字符串字段使用varchar类型，一般长度为30，长一点的可以为50，根据实际情况调整
- 长文本、文件路径、链接使用mediumtext类型
- 小数字段使用decimal类型，一般长度为10，小数位为2
- 一般情况下，字段都可以为null