CREATE DATABASE wikift
  DEFAULT CHARACTER SET utf8
  COLLATE utf8_general_ci;
USE wikift;
-- 路由表
DROP TABLE IF EXISTS role;
CREATE TABLE role (
  r_id          BIGINT(20) NOT NULL AUTO_INCREMENT,
  r_name        VARCHAR(255)        DEFAULT NULL,
  r_description VARCHAR(255)        DEFAULT NULL,
  PRIMARY KEY (r_id)
);
-- 用户表
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  u_id         BIGINT(20)   NOT NULL AUTO_INCREMENT,
  u_username   VARCHAR(25)  NOT NULL,
  u_password   VARCHAR(255) NOT NULL,
  u_avatar     VARCHAR(255),
  u_alias_name VARCHAR(25),
  u_signature  VARCHAR(200),
  PRIMARY KEY (u_id)
);
-- 用户路由关系表
DROP TABLE IF EXISTS users_role_relation;
CREATE TABLE users_role_relation (
  urr_user_id BIGINT(20) NOT NULL,
  urr_role_id BIGINT(20) NOT NULL,
  CONSTRAINT FK_user_id FOREIGN KEY (urr_user_id) REFERENCES users (u_id),
  CONSTRAINT FK_role_id FOREIGN KEY (urr_role_id) REFERENCES role (r_id)
);
-- 用户关注关系表
DROP TABLE IF EXISTS users_follow_relation;
CREATE TABLE users_follow_relation (
  ufr_user_id_follw BIGINT(20) NOT NULL
  COMMENT '关注者用户id',
  ufr_user_id_cover BIGINT(20) NOT NULL
  COMMENT '被关注用户id',
  ufr_create_time   TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);
-- 用户组表
DROP TABLE IF EXISTS groups;
CREATE TABLE groups (
  g_id          BIGINT(20)   NOT NULL AUTO_INCREMENT,
  g_name        VARCHAR(255) NOT NULL,
  g_description VARCHAR(255) NOT NULL,
  g_enabled     BOOLEAN      NOT NULL DEFAULT TRUE,
  PRIMARY KEY (g_id)
);
-- 用户与组关系表
DROP TABLE IF EXISTS users_groups_relation;
CREATE TABLE users_groups_relation (
  ugr_user_id  BIGINT(20) NOT NULL,
  ugr_group_id BIGINT(20) NOT NULL,
  CONSTRAINT FK_ugr_user_relation_id FOREIGN KEY (ugr_user_id) REFERENCES users (u_id),
  CONSTRAINT FK_ugr_group_relation_id FOREIGN KEY (ugr_group_id) REFERENCES groups (g_id)
);
-- 文章表
DROP TABLE IF EXISTS article;
CREATE TABLE article (
  a_id          BIGINT(20)   NOT NULL AUTO_INCREMENT,
  a_title       VARCHAR(255) NOT NULL,
  a_content     TEXT         NOT NULL,
  a_create_time TIMESTAMP,
  view_count    BIGINT(20) COMMENT '该字段只用于映射数据',
  fabulou_count BIGINT(20) COMMENT '该字段只用于映射数据',
  PRIMARY KEY (a_id)
);
-- 文章类型表
DROP TABLE IF EXISTS article_type;
CREATE TABLE article_type (
  at_id          BIGINT(20)   NOT NULL AUTO_INCREMENT,
  at_code        VARCHAR(255) NOT NULL,
  at_title       VARCHAR(255) NOT NULL,
  at_create_time TIMESTAMP             DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (at_id)
);
-- 文章与文章类型关系表
DROP TABLE IF EXISTS article_type_relation;
CREATE TABLE article_type_relation (
  atr_article_id      BIGINT(20) NOT NULL,
  atr_article_type_id BIGINT(20) NOT NULL,
  CONSTRAINT FK_atr_article_relation_id FOREIGN KEY (atr_article_id) REFERENCES article (a_id)
    ON DELETE CASCADE,
  CONSTRAINT FK_atr_article_type_relation_id FOREIGN KEY (atr_article_type_id) REFERENCES article_type (at_id)
    ON DELETE CASCADE
);
-- 用户与文章关系表
DROP TABLE IF EXISTS users_article_relation;
CREATE TABLE users_article_relation (
  uar_user_id    BIGINT(20) NOT NULL,
  uar_article_id BIGINT(20) NOT NULL,
  CONSTRAINT FK_uar_users_relation_id FOREIGN KEY (uar_user_id) REFERENCES users (u_id)
    ON DELETE CASCADE,
  CONSTRAINT FK_uar_article_relation_id FOREIGN KEY (uar_article_id) REFERENCES article (a_id)
    ON DELETE CASCADE
);
-- 用户赞文章关系表
DROP TABLE IF EXISTS users_article_fabulous_relation;
CREATE TABLE users_article_fabulous_relation (
  uafr_user_id     BIGINT(20) NOT NULL,
  uafr_article_id  BIGINT(20) NOT NULL,
  uafr_create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  CONSTRAINT FK_uafr_users_fabulous_relation_id FOREIGN KEY (uafr_user_id) REFERENCES users (u_id)
    ON DELETE CASCADE,
  CONSTRAINT FK_uafr_article_fabulous_relation_id FOREIGN KEY (uafr_article_id) REFERENCES article (a_id)
    ON DELETE CASCADE
);
-- 用户浏览文章关系表
DROP TABLE IF EXISTS users_article_view_relation;
CREATE TABLE users_article_view_relation (
  uavr_user_id     BIGINT(20)  NOT NULL,
  uavr_article_id  BIGINT(20)  NOT NULL,
  uavr_view_count  BIGINT(200) NOT NULL,
  uavr_view_device VARCHAR(50) NOT NULL,
  uavr_create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  CONSTRAINT FK_uavr_users_view_relation_id FOREIGN KEY (uavr_user_id) REFERENCES users (u_id)
    ON DELETE CASCADE,
  CONSTRAINT FK_uavr_article_view_relation_id FOREIGN KEY (uavr_article_id) REFERENCES article (a_id)
    ON DELETE CASCADE
);
-- 提醒表
DROP TABLE IF EXISTS remind;
CREATE TABLE remind (
  r_id          BIGINT(20)   NOT NULL AUTO_INCREMENT
  COMMENT '提醒信息id',
  r_title       VARCHAR(200) NOT NULL
  COMMENT '提醒信息标题',
  r_content     TEXT         NOT NULL
  COMMENT '提醒信息内容',
  r_create_time TIMESTAMP             DEFAULT CURRENT_TIMESTAMP()
  COMMENT '提醒信息创建时间',
  r_deleted     BOOLEAN               DEFAULT FALSE
  COMMENT '是否删除',
  r_read        BOOLEAN               DEFAULT FALSE
  COMMENT '是否阅读',
  r_read_time   DATETIME COMMENT '阅读时间',
  PRIMARY KEY (r_id)
);
-- 提醒表类型
DROP TABLE IF EXISTS remind_type;
CREATE TABLE remind_type (
  rt_id          BIGINT(20)  NOT NULL AUTO_INCREMENT
  COMMENT '信息类型',
  rt_code        VARCHAR(20) NOT NULL
  COMMENT '类型code,唯一标识',
  rt_title       VARCHAR(20) NOT NULL
  COMMENT '类型名称',
  rt_create_time TIMESTAMP            DEFAULT CURRENT_TIMESTAMP()
  COMMENT '类型创建时间',
  rt_disabled    BOOLEAN              DEFAULT TRUE
  COMMENT '是否启用该类型',
  rt_deleted     BOOLEAN              DEFAULT FALSE
  COMMENT '是否删除',
  PRIMARY KEY (rt_id)
);
-- 提醒与提醒类型关系表
DROP TABLE IF EXISTS remind_type_relation;
CREATE TABLE remind_type_relation (
  rtr_remind_id      BIGINT(20) NOT NULL,
  rtr_remind_type_id BIGINT(20) NOT NULL,
  rtr_create_time    TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
  CONSTRAINT FK_rtr_remind_relation_id FOREIGN KEY (rtr_remind_id) REFERENCES remind (r_id),
  CONSTRAINT FK_rtr_remind_type_relation_id FOREIGN KEY (rtr_remind_type_id) REFERENCES remind_type (rt_id)
);
-- 提醒与用户文章关系表
DROP TABLE remind_article_relation;
CREATE TABLE remind_article_relation (
  rar_remind_id  BIGINT(20) NOT NULL,
  rar_article_id BIGINT(20) NOT NULL,
  CONSTRAINT FK_rar_remind_relation_id FOREIGN KEY (rar_remind_id) REFERENCES remind (r_id)
    ON DELETE CASCADE,
  CONSTRAINT FK_rar_article_relation_id FOREIGN KEY (rar_article_id) REFERENCES article (a_id)
    ON DELETE CASCADE
);
-- 提醒与用户关系表
DROP TABLE remind_users_relation;
CREATE TABLE remind_users_relation (
  rur_remind_id BIGINT(20) NOT NULL,
  rur_user_id   BIGINT(20) NOT NULL,
  CONSTRAINT FK_rur_remind_relation_id FOREIGN KEY (rur_remind_id) REFERENCES remind (r_id)
    ON DELETE CASCADE,
  CONSTRAINT FK_rur_user_relation_id FOREIGN KEY (rur_user_id) REFERENCES users (u_id)
    ON DELETE CASCADE
);
-- 文章标签表
DROP TABLE IF EXISTS article_tag;
CREATE TABLE article_tag (
  at_id          BIGINT(20)   NOT NULL AUTO_INCREMENT,
  at_title       VARCHAR(255) NOT NULL,
  at_create_time TIMESTAMP             DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (at_id)
);
-- 文章与文章文章标签关系表
DROP TABLE IF EXISTS article_tag_relation;
CREATE TABLE article_tag_relation (
  atr_article_id     BIGINT(20) NOT NULL,
  atr_article_tag_id BIGINT(20) NOT NULL,
  CONSTRAINT FK_atr_article_1_relation_id FOREIGN KEY (atr_article_id) REFERENCES article (a_id),
  CONSTRAINT FK_atr_article_tag_relation_id FOREIGN KEY (atr_article_tag_id) REFERENCES article_tag (at_id)
);
-- 专栏/空间表
DROP TABLE IF EXISTS space;
CREATE TABLE space (
  s_id          BIGINT(20)  NOT NULL AUTO_INCREMENT
  COMMENT '空间id',
  s_avatar      LONGTEXT COMMENT '空间图像',
  s_name        VARCHAR(20) NOT NULL
  COMMENT '空间名称',
  s_code        VARCHAR(20) NOT NULL
  COMMENT '空间标识',
  s_private     BOOLEAN              DEFAULT TRUE
  COMMENT '空间是否私有, 默认是',
  s_description TEXT COMMENT '空间描述',
  create_time   TIMESTAMP            DEFAULT CURRENT_TIMESTAMP()
  COMMENT '空间创建时间',
  PRIMARY KEY (s_id)
);
-- 专栏/空间用户关系表
DROP TABLE IF EXISTS space_users_relation;
CREATE TABLE space_users_relation (
  sur_space_id BIGINT(20) NOT NULL,
  sur_users_id BIGINT(20) NOT NULL,
  CONSTRAINT FK_sur_space_relation_id FOREIGN KEY (sur_space_id) REFERENCES space (s_id),
  CONSTRAINT FK_sur_users_relation_id FOREIGN KEY (sur_users_id) REFERENCES users (u_id)
);
-- 专栏/空间文章关系表
DROP TABLE IF EXISTS space_article_relation;
CREATE TABLE space_article_relation (
  sar_space_id   BIGINT(20) NOT NULL,
  sar_article_id BIGINT(20) NOT NULL,
  CONSTRAINT FK_sar_space_relation_id FOREIGN KEY (sar_space_id) REFERENCES space (s_id),
  CONSTRAINT FK_sar_article_relation_id FOREIGN KEY (sar_article_id) REFERENCES article (a_id)
);
-- 评论表
DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
  c_id        BIGINT(20) NOT NULL AUTO_INCREMENT
  COMMENT '评论id',
  c_content   LONGTEXT COMMENT '评论内容',
  create_time TIMESTAMP           DEFAULT CURRENT_TIMESTAMP()
  COMMENT '评论内容时间',
  PRIMARY KEY (c_id)
);
-- 文章评论关系表
DROP TABLE IF EXISTS comments_article_relation;
CREATE TABLE comments_article_relation (
  car_comments_id BIGINT(20) NOT NULL,
  car_article_id     BIGINT(20) NOT NULL,
  CONSTRAINT FK_car_comments_relation_id FOREIGN KEY (car_comments_id) REFERENCES comments (c_id),
  CONSTRAINT FK_car_article_relation_id FOREIGN KEY (car_article_id) REFERENCES article (a_id)
);
-- 用户评论关系表
DROP TABLE IF EXISTS comments_users_relation;
CREATE TABLE comments_users_relation (
  cur_comments_id BIGINT(20) NOT NULL,
  cur_users_id     BIGINT(20) NOT NULL,
  CONSTRAINT FK_cur_comments_relation_id FOREIGN KEY (cur_comments_id) REFERENCES comments (c_id),
  CONSTRAINT FK_cur_users_relation_id FOREIGN KEY (cur_users_id) REFERENCES users (u_id)
);