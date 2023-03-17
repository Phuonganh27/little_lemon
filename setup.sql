-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema little_lemon
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema little_lemon
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `little_lemon` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `little_lemon` ;

-- -----------------------------------------------------
-- Table `little_lemon`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon`.`Customers` (
  `CustomerID` INT NOT NULL,
  `FirstName` VARCHAR(45) NULL DEFAULT NULL,
  `LastName` VARCHAR(45) NULL DEFAULT NULL,
  `Address` VARCHAR(45) NULL DEFAULT NULL,
  `ContactNumber` VARCHAR(45) NULL DEFAULT NULL,
  `Email` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon`.`Bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `TableNo` INT NULL DEFAULT NULL,
  `CustomerID` INT NULL DEFAULT NULL,
  `BookingDate` DATE NOT NULL,
  `EmployeeID` INT NULL DEFAULT NULL,
  `Customers_CustomerID` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `fk_Bookings_Customers1_idx` (`Customers_CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_Bookings_Customers1`
    FOREIGN KEY (`Customers_CustomerID`)
    REFERENCES `little_lemon`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon`.`DeliveryStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon`.`DeliveryStatus` (
  `DeliveryDate` DATE NOT NULL,
  `OrderID` INT NULL DEFAULT NULL,
  `Status` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`DeliveryDate`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon`.`Employees` (
  `EmployeeID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NULL DEFAULT NULL,
  `Role` VARCHAR(100) NULL DEFAULT NULL,
  `Address` VARCHAR(100) NULL DEFAULT NULL,
  `ContactNumber` INT NULL DEFAULT NULL,
  `Email` VARCHAR(100) NULL DEFAULT NULL,
  `AnnualSalary` VARCHAR(100) NULL DEFAULT NULL,
  `Bookings_BookingID` INT NOT NULL,
  PRIMARY KEY (`EmployeeID`),
  INDEX `fk_Employees_Bookings1_idx` (`Bookings_BookingID` ASC) VISIBLE,
  CONSTRAINT `fk_Employees_Bookings1`
    FOREIGN KEY (`Bookings_BookingID`)
    REFERENCES `little_lemon`.`Bookings` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon`.`Orders` (
  `OrderID` INT NOT NULL,
  `TableNo` INT NULL,
  `MenuID` INT NULL DEFAULT NULL,
  `BookingID` INT NULL DEFAULT NULL,
  `BillAmount` INT NULL DEFAULT NULL,
  `Quantity` INT NULL DEFAULT NULL,
  `Bookings_BookingID` INT NOT NULL,
  `DeliveryStatus_DeliveryDate` DATE NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `fk_Orders_Bookings1_idx` (`Bookings_BookingID` ASC) VISIBLE,
  INDEX `fk_Orders_DeliveryStatus1_idx` (`DeliveryStatus_DeliveryDate` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Bookings1`
    FOREIGN KEY (`Bookings_BookingID`)
    REFERENCES `little_lemon`.`Bookings` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_DeliveryStatus1`
    FOREIGN KEY (`DeliveryStatus_DeliveryDate`)
    REFERENCES `little_lemon`.`DeliveryStatus` (`DeliveryDate`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon`.`Menus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon`.`Menus` (
  `MenuID` INT NOT NULL,
  `ItemID` INT NOT NULL,
  `Cuisine` VARCHAR(100) NULL DEFAULT NULL,
  `Orders_OrderID` INT NOT NULL,
  PRIMARY KEY (`MenuID`, `ItemID`),
  INDEX `fk_Menus_Orders1_idx` (`Orders_OrderID` ASC) VISIBLE,
  CONSTRAINT `fk_Menus_Orders1`
    FOREIGN KEY (`Orders_OrderID`)
    REFERENCES `little_lemon`.`Orders` (`OrderID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon`.`MenuItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon`.`MenuItems` (
  `ItemID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(200) NULL DEFAULT NULL,
  `Type` VARCHAR(100) NULL DEFAULT NULL,
  `Price` INT NULL DEFAULT NULL,
  `Menus_MenuID` INT NOT NULL,
  `Menus_ItemID` INT NOT NULL,
  PRIMARY KEY (`ItemID`),
  INDEX `fk_MenuItems_Menus1_idx` (`Menus_MenuID` ASC, `Menus_ItemID` ASC) VISIBLE,
  CONSTRAINT `fk_MenuItems_Menus1`
    FOREIGN KEY (`Menus_MenuID` , `Menus_ItemID`)
    REFERENCES `little_lemon`.`Menus` (`MenuID` , `ItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 18
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `little_lemon` ;

-- -----------------------------------------------------
-- procedure AddBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddBooking`(IN booking_id INT, IN booking_date DATE, IN table_no INT)
BEGIN 
INSERT INTO Bookings (BookingID, BookingDate, TableNo)
VALUES(booking_id, booking_date, table_no);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ManageBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ManageBooking`(IN booking_date Date, IN table_no INT)
BEGIN
START TRANSACTION ;
INSERT INTO Bookings (BookingDate, TableNo)
VALUES (booking_date, table_no);
IF (SELECT COUNT(BookingID) FROM Bookings WHERE BookingDate = booking_date AND TableNo = table_no) > 1 THEN
	SELECT CONCAT("Table ", table_no, "is already booked at ", booking_date, " - booking cancelled") AS "Result";
    ROLLBACK;
ELSE
	SELECT CONCAT("Table ", table_no, "is successfully booked at ", booking_date, " - booking cancelled") AS "Result";
	COMMIT;
END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(IN booking_id INT)
BEGIN 
DELETE FROM Bookings
WHERE BookingID = booking_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelOrder
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelOrder`(IN order_id INT)
BEGIN
DELETE FROM Orders
WHERE OrderID = order_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckBooking`(IN booking_date date, IN table_no INT)
BEGIN
SELECT
(CASE 
WHEN EXISTS(SELECT BookingID FROM Bookings 
WHERE BookingDate = booking_date AND
TableNo = table_no)
THEN CONCAT("Table", table_no, "is available at", booking_date)
ELSE CONCAT("Table", table_no, "is not available at", booking_date)
END) AS booking_status ; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetMaxQuantity
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMaxQuantity`()
begin
select max(quantity) from orders;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBooking`(IN booking_id INT, IN booking_date DATE)
BEGIN 
UPDATE Bookings SET BookingDate = booking_date
WHERE BookingID = booking_id;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
