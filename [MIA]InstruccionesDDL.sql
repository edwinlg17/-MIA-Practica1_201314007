SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema Practica1
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Practica1` ;

-- -----------------------------------------------------
-- Schema Practica1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Practica1` ;
USE `Practica1` ;

-- -----------------------------------------------------
-- Table `Practica1`.`Hospital`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`Hospital` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`Hospital` (
  `idHospital` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `direccion` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idHospital`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`Paciente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`Paciente` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`Paciente` (
  `idPaciente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido` VARCHAR(50) NOT NULL,
  `direccion` VARCHAR(100) NOT NULL,
  `fechaPrimeraSospecha` DATETIME NOT NULL,
  `fechaConfirmacion` DATETIME NOT NULL,
  `fechaDefuncion` DATETIME NULL,
  `statusEnfermedad` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idPaciente`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`Tratamiento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`Tratamiento` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`Tratamiento` (
  `idTratamiento` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idTratamiento`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`TratamientoPaciente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`TratamientoPaciente` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`TratamientoPaciente` (
  `idTratamientoPaciente` INT NOT NULL AUTO_INCREMENT,
  `idPaciente` INT NOT NULL,
  `idTratamiento` INT NOT NULL,
  `efectividad` INT NOT NULL,
  `fechaInicio` DATETIME NOT NULL,
  `fechaFin` DATETIME NOT NULL,
  PRIMARY KEY (`idTratamientoPaciente`),
  INDEX `fk_idPaciente_Tratamiento_idx` (`idPaciente` ASC) VISIBLE,
  INDEX `fk_idTratemiento_Tratamiento_idx` (`idTratamiento` ASC) VISIBLE,
  CONSTRAINT `fk_idPaciente_Tratamiento`
    FOREIGN KEY (`idPaciente`)
    REFERENCES `Practica1`.`Paciente` (`idPaciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_idTratemiento_Tratamiento`
    FOREIGN KEY (`idTratamiento`)
    REFERENCES `Practica1`.`Tratamiento` (`idTratamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`Ubicacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`Ubicacion` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`Ubicacion` (
  `idUbicacion` INT NOT NULL AUTO_INCREMENT,
  `idPaciente` INT NOT NULL,
  `direccion` VARCHAR(100) NOT NULL,
  `fechaIngreso` DATETIME NOT NULL,
  `fechaEgreso` DATETIME NOT NULL,
  PRIMARY KEY (`idUbicacion`),
  INDEX `fk_idPaciente_Ubicacion_idx` (`idPaciente` ASC) VISIBLE,
  CONSTRAINT `fk_idPaciente_Ubicacion`
    FOREIGN KEY (`idPaciente`)
    REFERENCES `Practica1`.`Paciente` (`idPaciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`Contacto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`Contacto` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`Contacto` (
  `idContacto` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idContacto`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`PacienteContacto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`PacienteContacto` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`PacienteContacto` (
  `idPacienteContacto` INT NOT NULL AUTO_INCREMENT,
  `idPaciente` INT NOT NULL,
  `idContacto` INT NOT NULL,
  `fechaConocer` DATETIME NOT NULL,
  PRIMARY KEY (`idPacienteContacto`),
  INDEX `fk_idPaciente_Contacto_idx` (`idPaciente` ASC) VISIBLE,
  INDEX `fk_idContacto_Contacto_idx` (`idContacto` ASC) VISIBLE,
  CONSTRAINT `fk_idPaciente_Contacto`
    FOREIGN KEY (`idPaciente`)
    REFERENCES `Practica1`.`Paciente` (`idPaciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_idContacto_Contacto`
    FOREIGN KEY (`idContacto`)
    REFERENCES `Practica1`.`Contacto` (`idContacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`Interaccion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`Interaccion` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`Interaccion` (
  `idInteraccion` INT NOT NULL AUTO_INCREMENT,
  `interaccion` VARCHAR(50) NOT NULL,
  `fechaInicio` DATETIME NOT NULL,
  `fechaFin` DATETIME NOT NULL,
  `idPaciente` INT NOT NULL,
  `idContacto` INT NOT NULL,
  PRIMARY KEY (`idInteraccion`),
  INDEX `fk_idPaciente_Interaccion_idx` (`idPaciente` ASC) VISIBLE,
  INDEX `fk_idContacto_Interaccion_idx` (`idContacto` ASC) VISIBLE,
  CONSTRAINT `fk_idPaciente_Interaccion`
    FOREIGN KEY (`idPaciente`)
    REFERENCES `Practica1`.`Paciente` (`idPaciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_idContacto_Interaccion`
    FOREIGN KEY (`idContacto`)
    REFERENCES `Practica1`.`Contacto` (`idContacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`HospitalPaciente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`HospitalPaciente` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`HospitalPaciente` (
  `idHospitalPaciente` INT NOT NULL AUTO_INCREMENT,
  `idPaciente` INT NOT NULL,
  `idHospital` INT NOT NULL,
  PRIMARY KEY (`idHospitalPaciente`),
  INDEX `fk_idPaciente_HospitalPaciente_idx` (`idPaciente` ASC) VISIBLE,
  INDEX `fk_idHospital_HospitalPaciente_idx` (`idHospital` ASC) VISIBLE,
  CONSTRAINT `fk_idPaciente_HospitalPaciente`
    FOREIGN KEY (`idPaciente`)
    REFERENCES `Practica1`.`Paciente` (`idPaciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_idHospital_HospitalPaciente`
    FOREIGN KEY (`idHospital`)
    REFERENCES `Practica1`.`Hospital` (`idHospital`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`HospitalPaciente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`HospitalPaciente` ;

CREATE TABLE IF NOT EXISTS `Practica1`.`HospitalPaciente` (
  `idHospitalPaciente` INT NOT NULL AUTO_INCREMENT,
  `idPaciente` INT NOT NULL,
  `idHospital` INT NOT NULL,
  PRIMARY KEY (`idHospitalPaciente`),
  INDEX `fk_idPaciente_HospitalPaciente_idx` (`idPaciente` ASC) VISIBLE,
  INDEX `fk_idHospital_HospitalPaciente_idx` (`idHospital` ASC) VISIBLE,
  CONSTRAINT `fk_idPaciente_HospitalPaciente`
    FOREIGN KEY (`idPaciente`)
    REFERENCES `Practica1`.`Paciente` (`idPaciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_idHospital_HospitalPaciente`
    FOREIGN KEY (`idHospital`)
    REFERENCES `Practica1`.`Hospital` (`idHospital`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Practica1`.`Temporal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Practica1`.`Temporal` ;

CREATE TABLE Temporal(
    idTemporal INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    NOMBRE_VICTIMA VARCHAR (50) NOT NULL,
    APELLIDO_VICTIMA VARCHAR (50) NOT NULL,
    DIRECCION_VICTIMA VARCHAR (100) NOT NULL,
    FECHA_PRIMERA_SOSPECHA DATETIME NOT NULL,
    FECHA_CONFIRMACION DATETIME NOT NULL,
    FECHA_MUERTE DATETIME NULL,
    ESTADO_VICTIMA VARCHAR (50) NOT NULL,
    NOMBRE_ASOCIADO VARCHAR (50) NULL,
    APELLIDO_ASOCIADO VARCHAR (50) NULL,
    FECHA_CONOCIO DATETIME NULL,
    CONTACTO_FISICO VARCHAR (50) NULL,
    FECHA_INICIO_CONTACTO DATETIME NULL,
    FECHA_FIN_CONTACTO DATETIME NULL,
    NOMBRE_HOSPITAL VARCHAR(50) NULL,
    DIRECCION_HOSPITAL VARCHAR(100) NULL,
    UBICACION_VICTIMA VARCHAR (100) NULL,
    FECHA_LLEGADA DATETIME NULL,
    FECHA_RETIRO DATETIME NULL,
    TRATAMIENTO VARCHAR (50) NULL,
    EFECTIVIDAD INT DEFAULT '0' NULL,
    FECHA_INICIO_TRATAMIENTO DATETIME NULL,
    FECHA_FIN_TRATAMIENTO DATETIME NULL,
    EFECTIVIDAD_EN_VICTIMA INT DEFAULT '0' NULL
);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;