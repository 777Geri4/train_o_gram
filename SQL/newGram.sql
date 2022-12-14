-- MySQL Script generated by MySQL Workbench
-- Tue Nov  8 12:08:42 2022
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema new_trainogram
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `new_trainogram` ;

-- -----------------------------------------------------
-- Schema new_trainogram
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `new_trainogram` DEFAULT CHARACTER SET utf8 ;
USE `new_trainogram` ;

-- -----------------------------------------------------
-- Table `new_trainogram`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`user` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `login` VARCHAR(45) NOT NULL,
  `password` VARCHAR(1024) NOT NULL,
  `email` VARCHAR(90) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `userlogin_UNIQUE` (`login` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`avatar`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`avatar` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`avatar` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `path` VARCHAR(256) NULL,
  `created` DATETIME NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_avatar_user_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_avatar_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`post` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`post` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `likes` INT NOT NULL DEFAULT 0,
  `created` DATETIME NOT NULL,
  `message` VARCHAR(1024) NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_post_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_post_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`picture`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`picture` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`picture` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `path` VARCHAR(256) NOT NULL,
  `created` DATETIME NOT NULL,
  `post_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_picture_post1_idx` (`post_id` ASC) VISIBLE,
  CONSTRAINT `fk_picture_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `new_trainogram`.`post` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`comment` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` VARCHAR(2056) NULL,
  `likes` INT NOT NULL DEFAULT 0,
  `created` DATETIME NOT NULL,
  `user_id` INT NOT NULL,
  `post_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_comment_user1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_comment_post1_idx` (`post_id` ASC) VISIBLE,
  CONSTRAINT `fk_comment_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `new_trainogram`.`post` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`like_post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`like_post` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`like_post` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_like_post_post1_idx` (`post_id` ASC) VISIBLE,
  INDEX `fk_like_post_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_like_post_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `new_trainogram`.`post` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_like_post_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`like_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`like_comment` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`like_comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `comment_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_like_comment_comment1_idx` (`comment_id` ASC) VISIBLE,
  INDEX `fk_like_comment_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_like_comment_comment1`
    FOREIGN KEY (`comment_id`)
    REFERENCES `new_trainogram`.`comment` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_like_comment_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`user_has_subscribers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`user_has_subscribers` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`user_has_subscribers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `subscriber_id` INT NOT NULL,
  `publisher_id` INT NOT NULL,
  `status_of_subscribe` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_has_subscribers_user1_idx` (`subscriber_id` ASC) VISIBLE,
  INDEX `fk_user_has_subscribers_user2_idx` (`publisher_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_friends_user1`
    FOREIGN KEY (`subscriber_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_friends_user2`
    FOREIGN KEY (`publisher_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`notification_friendship`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`notification_friendship` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`notification_friendship` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `recipient_id` INT NOT NULL,
  `creator_id` INT NOT NULL,
  `notification_type` VARCHAR(10) NOT NULL,
  `notification_status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_EventFriendship_user1_idx` (`recipient_id` ASC) VISIBLE,
  INDEX `fk_EventFriendship_user2_idx` (`creator_id` ASC) VISIBLE,
  CONSTRAINT `fk_EventFriendship_user1`
    FOREIGN KEY (`recipient_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventFriendship_user2`
    FOREIGN KEY (`creator_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`notification_post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`notification_post` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`notification_post` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `recipient_id` INT NOT NULL,
  `creator_id` INT NOT NULL,
  `post_id` INT NOT NULL,
  `notification_type` VARCHAR(45) NOT NULL,
  `notification_status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_notification_post_user1_idx` (`recipient_id` ASC) VISIBLE,
  INDEX `fk_notification_post_post1_idx` (`post_id` ASC) VISIBLE,
  INDEX `fk_event_post_user1_idx` (`creator_id` ASC) VISIBLE,
  CONSTRAINT `fk_notification_post_user1`
    FOREIGN KEY (`recipient_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_notification_post_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `new_trainogram`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_event_post_user1`
    FOREIGN KEY (`creator_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `new_trainogram`.`notification_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `new_trainogram`.`notification_comment` ;

CREATE TABLE IF NOT EXISTS `new_trainogram`.`notification_comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `recipient_id` INT NOT NULL,
  `creator_id` INT NOT NULL,
  `comment_id` INT NOT NULL,
  `notification_type` VARCHAR(45) NOT NULL,
  `notification_status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_notifiication_comment_user1_idx` (`recipient_id` ASC) VISIBLE,
  INDEX `fk_notifiication_comment_comment1_idx` (`comment_id` ASC) VISIBLE,
  INDEX `fk_event_comment_user1_idx` (`creator_id` ASC) VISIBLE,
  CONSTRAINT `fk_notifiication_comment_user1`
    FOREIGN KEY (`recipient_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_notifiication_comment_comment1`
    FOREIGN KEY (`comment_id`)
    REFERENCES `new_trainogram`.`comment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_event_comment_user1`
    FOREIGN KEY (`creator_id`)
    REFERENCES `new_trainogram`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
