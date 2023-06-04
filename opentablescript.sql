-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Table Reservations
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Table Reservations
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Table Reservations` DEFAULT CHARACTER SET utf8 ;
USE `Table Reservations` ;

-- -----------------------------------------------------
-- Table `Table Reservations`.`Special Use`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Special Use` (
  `Special_Use_ID` INT NOT NULL AUTO_INCREMENT,
  `Quicker_Seat` TINYINT NOT NULL,
  `Line_Bump` TINYINT NOT NULL,
  `Moved_First_Line` TINYINT NOT NULL,
  PRIMARY KEY (`Special_Use_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Table Reservations`.`Subscription Cases`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Subscription Cases` (
  `Subscription_ID` INT NOT NULL AUTO_INCREMENT,
  `Subscription_To App` TINYINT NOT NULL,
  `Special_Use_ID` INT NOT NULL,
  PRIMARY KEY (`Subscription_ID`),
  INDEX `Special_Use_ID_idx` (`Special_Use_ID` ASC) VISIBLE,
  CONSTRAINT `Special_Use_ID`
    FOREIGN KEY (`Special_Use_ID`)
    REFERENCES `Table Reservations`.`Special Use` (`Special_Use_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Table Reservations`.`Customer Payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Customer Payment` (
  `Customer_Payment_ID` INT NOT NULL AUTO_INCREMENT,
  `Credit_Card_Number` CHAR(16) NOT NULL,
  `Billing_Address_1` VARCHAR(45) NOT NULL,
  `Billing_Address_2` CHAR(7) NULL,
  `Postal Code_copy1` CHAR(7) NOT NULL,
  `Expiration_Date` DATE NOT NULL,
  `Security_Code` CHAR(3) NOT NULL,
  `Subscription_ID` INT NOT NULL,
  PRIMARY KEY (`Customer_Payment_ID`),
  INDEX `Subscription_ID_idx` (`Subscription_ID` ASC) VISIBLE,
  CONSTRAINT `Subscription_ID`
    FOREIGN KEY (`Subscription_ID`)
    REFERENCES `Table Reservations`.`Subscription Cases` (`Subscription_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Table Reservations`.`Table Pager`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Table Pager` (
  `Pager_ID` INT NOT NULL AUTO_INCREMENT,
  `Customer_Phone` CHAR(10) NOT NULL,
  `Notify_Phone` TINYINT NOT NULL,
  PRIMARY KEY (`Pager_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Table Reservations`.`Reservation Information`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Reservation Information` (
  `Reservation_ID` INT NULL AUTO_INCREMENT,
  `Customers_In_Line` DECIMAL(100) NOT NULL,
  `Time_Of_Wait` TIME NOT NULL,
  `Pager_ID` INT NOT NULL,
  PRIMARY KEY (`Reservation_ID`),
  INDEX `pager_ID_idx` (`Pager_ID` ASC) VISIBLE,
  CONSTRAINT `pager_ID`
    FOREIGN KEY (`Pager_ID`)
    REFERENCES `Table Reservations`.`Table Pager` (`Pager_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Table Reservations`.`Restaurant Information`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Restaurant Information` (
  `Restraunt_ID` INT NOT NULL AUTO_INCREMENT,
  `Restraunt_Name` VARCHAR(100) NOT NULL,
  `Restraunt_Address_1` VARCHAR(100) NOT NULL,
  `Restraunt_Address_Line2` TIME NULL,
  `Restraunt_City` VARCHAR(45) NOT NULL,
  `Restraunt_Zipcode` CHAR(7) NOT NULL,
  `Restraunt_State` CHAR(2) NOT NULL,
  `Restraunt_Food_Type` VARCHAR(45) NOT NULL,
  `Restraunt_Location_ID` INT NOT NULL,
  `Reservation_ID` INT NOT NULL,
  PRIMARY KEY (`Restraunt_ID`),
  INDEX `reservation_ID_idx` (`Reservation_ID` ASC) VISIBLE,
  INDEX `restraurant_location_ID_idx` (`Restraunt_Location_ID` ASC) VISIBLE,
  CONSTRAINT `reservation_ID`
    FOREIGN KEY (`Reservation_ID`)
    REFERENCES `Table Reservations`.`Reservation Information` (`Reservation_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `restraurant_location_ID`
    FOREIGN KEY (`Restraunt_Location_ID`)
    REFERENCES `Table Reservations`.`Restraunt Location` (`Restraunt_Location_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Table Reservations`.`Restraunt Location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Restraunt Location` (
  `Restraunt_Location_ID` INT NOT NULL AUTO_INCREMENT,
  `Restraunt_Geolocation` INT NOT NULL,
  `Restraunt_Information_ID` INT NOT NULL,
  PRIMARY KEY (`Restraunt_Location_ID`),
  INDEX `restraunt_information_ID_idx` (`Restraunt_Information_ID` ASC) VISIBLE,
  CONSTRAINT `restraunt_information_ID`
    FOREIGN KEY (`Restraunt_Information_ID`)
    REFERENCES `Table Reservations`.`Restaurant Information` (`Restraunt_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Table Reservations`.`Current Location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Current Location` (
  `Current_Location_ID` INT NOT NULL AUTO_INCREMENT,
  `Phone_Geolocation` DECIMAL NOT NULL,
  `Restraunt_Location_ID` INT NOT NULL,
  PRIMARY KEY (`Current_Location_ID`),
  INDEX `restraunt_location_ID_idx` (`Restraunt_Location_ID` ASC) VISIBLE,
  CONSTRAINT `restraunt_location_ID`
    FOREIGN KEY (`Restraunt_Location_ID`)
    REFERENCES `Table Reservations`.`Restraunt Location` (`Restraunt_Location_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Table Reservations`.`Notify Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Notify Customer` (
  `Notify_ID` INT NOT NULL AUTO_INCREMENT,
  `Page_Phone` INT NOT NULL,
  `Phone_ID` INT NOT NULL,
  `Pager_ID` INT NOT NULL,
  PRIMARY KEY (`Notify_ID`),
  INDEX `Phone_ID_idx` (`Phone_ID` ASC) VISIBLE,
  INDEX `Pager_ID_idx` (`Pager_ID` ASC) VISIBLE,
  CONSTRAINT `Phone_ID`
    FOREIGN KEY (`Phone_ID`)
    REFERENCES `Table Reservations`.`Customer_Information` (`CustomerInfo_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Pager_ID`
    FOREIGN KEY (`Pager_ID`)
    REFERENCES `Table Reservations`.`Table Pager` (`Pager_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Table Reservations`.`Customer_Information`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Table Reservations`.`Customer_Information` (
  `CustomerInfo_ID` INT NOT NULL AUTO_INCREMENT,
  `Customer_Name` VARCHAR(45) NOT NULL,
  `Customer_Last_Name` VARCHAR(45) NOT NULL,
  `Address_Line1` VARCHAR(150) NOT NULL,
  `Address_Line2` VARCHAR(65) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `State` CHAR(45) NOT NULL,
  `Postal_Code` CHAR(10) NOT NULL,
  `Country` VARCHAR(45) NOT NULL,
  `Cutomer_Phone` CHAR(11) NOT NULL,
  `Current_Location_ID` INT NOT NULL,
  `Customer_Payment_ID` INT NOT NULL,
  `Customer_phone_id` INT NOT NULL,
  PRIMARY KEY (`CustomerInfo_ID`),
  INDEX `Customer_Payment_ID_idx` (`Customer_Payment_ID` ASC) VISIBLE,
  INDEX `Current_Location_ID_idx` (`Current_Location_ID` ASC) VISIBLE,
  INDEX `customer_phone_ID_idx` (`Customer_phone_id` ASC) VISIBLE,
  CONSTRAINT `Customer_Payment_ID`
    FOREIGN KEY (`Customer_Payment_ID`)
    REFERENCES `Table Reservations`.`Customer Payment` (`Customer_Payment_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Current_Location_ID`
    FOREIGN KEY (`Current_Location_ID`)
    REFERENCES `Table Reservations`.`Current Location` (`Current_Location_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `customer_phone_ID`
    FOREIGN KEY (`Customer_phone_id`)
    REFERENCES `Table Reservations`.`Notify Customer` (`Notify_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
