CREATE DATABASE social_media_db;

USE social_media_db;

CREATE TABLE Users(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    bio VARCHAR(150) NOT NULL,
    is_deleted TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Hashtags(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(140) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Posts(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    content NVARCHAR(1000) NOT NULL,
    file VARCHAR(255) DEFAULT NULL,
    user_id INT NOT NULL,
    is_deleted TINYINT(1) DEFAULT 0, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE Post_Hashtags(
    post_hashtag_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    hashtag_id INT NOT NULL,
    post_id INT NOT NULL,
    is_deleted TINYINT(1) DEFAULT 0, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hashtag_id) REFERENCES Hashtags(id),
    FOREIGN KEY (post_id) REFERENCES Posts(id)
);

CREATE TABLE Comments(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    content NVARCHAR(1000) NOT NULL,
    file VARCHAR(255) DEFAULT NULL,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    is_deleted TINYINT(1) DEFAULT 0, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(id),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE Comment_Hashtags(
    comment_hashtag_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    hashtag_id INT NOT NULL,
    comment_id INT NOT NULL,
    is_deleted TINYINT(1) DEFAULT 0, 
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hashtag_id) REFERENCES Hashtags(id),
    FOREIGN KEY (comment_id) REFERENCES Comments(id)
);