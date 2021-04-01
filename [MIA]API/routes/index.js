const { Router } = require('express');
const router = Router();

// variables 

var mysql = require('mysql');
var connection = mysql.createConnection({
    multipleStatements: true,
    host: 'localhost',
    user: 'root',
    password: '1234',
    database: 'Practica1',
    port: 3306
});

// routes
// CONSULTA 1
router.get('/consulta1', (req, res) => {
    var sql = "select hos.nombre as hospital, hos.direccion, count(hos.idHospital) as fallecidos\
    from HospitalPaciente as reg\
    inner join Hospital as hos on reg.idHospital = hos.idHospital\
    inner join Paciente as pac on reg.idPaciente = pac.idPaciente\
    where pac.fechaDefuncion is not null\
    group by hos.idHospital;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// CONSULTA 2
router.get('/consulta2', (req, res) => {
    var sql = "select pac.nombre, pac.apellido\
    from TratamientoPaciente as reg\
    inner join Paciente as pac on reg.idPaciente = pac.idPaciente\
    inner join Tratamiento as tra on reg.idTratamiento = tra.idTratamiento\
    where pac.statusEnfermedad = 'en cuarentena' and tra.nombre = 'transfusiones de sangre' and reg.efectividad > 5;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// CONSULTA 3
router.get('/consulta3', (req, res) => {
    var sql = "select pac.nombre, pac.apellido, direccion\
    from PacienteContacto as reg\
    inner join Paciente as pac on reg.idPaciente = pac.idPaciente\
    where pac.fechaDefuncion is not null\
    group by reg.idPaciente\
    having count(reg.idPaciente) > 3;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// CONSULTA 4
router.get('/consulta4', (req, res) => {
    var sql = "select pac.nombre, pac.apellido\
    from Interaccion as reg\
    inner join Paciente as pac on reg.idPaciente = pac.idPaciente\
    where pac.statusEnfermedad = 'sospecha' and reg.interaccion = 'Beso'\
    group by pac.idPaciente\
    having count(pac.idPaciente) > 2;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// CONSULTA 5
router.get('/consulta5', (req, res) => {
    var sql = "select pac.nombre, pac.apellido\
    from TratamientoPaciente as reg\
    inner join Paciente as pac on reg.idPaciente = pac.idPaciente\
    inner join Tratamiento as tra on reg.idTratamiento = tra.idTratamiento\
    where tra.nombre = 'Oxígeno'\
    group by pac.idPaciente\
    order by count(pac.idPaciente) desc\
    limit 5;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// CONSULTA 6
router.get('/consulta6', (req, res) => {
    var sql = "select distinct pac.nombre, pac.apellido\
    from Ubicacion as ubi\
    inner join Paciente as pac on ubi.idPaciente = pac.idPaciente\
    inner join TratamientoPaciente as traPac on ubi.idPaciente = traPac.idPaciente\
    inner join Tratamiento as tra on tra.idTratamiento = traPac.idTratamiento\
    where ubi.direccion = '1987 Delphine Well'\
    and pac.fechaDefuncion is not null \
    and tra.nombre = 'Manejo de la presión arterial';";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// CONSULTA 7
router.get('/consulta7', (req, res) => {
    var sql = "select pac.nombre, pac.apellido, pac.direccion\
    from ((PacienteContacto as reg inner join Paciente as pac on reg.idPaciente = pac.idPaciente) inner join Contacto as con on reg.idContacto = con.idContacto)\
    inner join (\
        select pac.nombre, pac.apellido\
        from PacienteContacto as reg\
        inner join Contacto as con on reg.idContacto = con.idContacto\
        inner join Paciente as pac on pac.nombre = con.nombre and pac.apellido = con.apellido\
        inner join HospitalPaciente as hosPac on hosPac.idPaciente = pac.idPaciente\
        inner join TratamientoPaciente as traPac on traPac.idPaciente = pac.idPaciente\
        group by pac.idPaciente\
        having count(pac.idPaciente) = 2\
    ) as sub on con.nombre = sub.nombre and con.apellido = sub.apellido\
    group by pac.idPaciente\
    having count(pac.idPaciente) < 2;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// CONSULTA 8
router.get('/consulta8', (req, res) => {
    var sql = "select month(pac.fechaPrimeraSospecha) as mes, pac.nombre, pac.apellido\
    from TratamientoPaciente as reg\
    inner join Paciente as pac on pac.idPaciente = reg.idPaciente\
    group by pac.idPaciente\
    having count(pac.idPaciente) = (\
        select count(idPaciente)\
        from TratamientoPaciente\
        group by idPaciente\
        order by count(idPaciente) desc\
        limit 1 ) \
    or count(pac.idPaciente) = (\
        select count(idPaciente)\
        from TratamientoPaciente\
        group by idPaciente\
        order by count(idPaciente)\
        limit 1 \
    );";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// CONSULTA 9
router.get('/consulta9', (req, res) => {
    var sql = "select hos.nombre, count(hos.idHospital)/ (select count(*) from HospitalPaciente) * 100 as porcentaje\
    from HospitalPaciente as hosPac\
    inner join Hospital as hos on hos.idHospital = hosPac.idHospital\
    group by hos.idHospital;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// CONSULTA 10
router.get('/consulta10', (req, res) => {
    var sql = "select distinct hos.nombre, sub1.interaccion, sub1.cantidad/sub2.total*100 as promedio\
    from Hospital as hos\
    inner join (\
        select hos.idHospital, inte.interaccion, count(inte.interaccion) as cantidad\
        from Hospital as hos\
        inner join HospitalPaciente as hosPac on hosPac.idHospital = hos.idHospital\
        inner join Paciente as pac on pac.idPaciente = hosPac.idPaciente\
        inner join Interaccion as inte on inte.idPaciente = pac.idPaciente\
        group by hos.idHospital, inte.interaccion\
        order by hos.idHospital, cantidad desc\
    ) as sub1 on hos.idHospital = sub1.idHospital\
    inner join (\
        select hos.idHospital, count(hos.idHospital) as total\
        from Hospital as hos\
        inner join HospitalPaciente as hosPac on hosPac.idHospital = hos.idHospital\
        inner join Paciente as pac on pac.idPaciente = hosPac.idPaciente\
        inner join Interaccion as inte on inte.idPaciente = pac.idPaciente\
        group by hos.idHospital\
    ) as sub2 on hos.idHospital = sub2.idHospital;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        res.end(JSON.stringify(result, null, 2));
    });
});

// ELIMINAR TEMPORAL 
router.get('/eliminarTemporal', (req, res) => {
    var sql = "truncate table Temporal;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        console.log("Datos de Tabla Temporal Eliminados");
    });
    res.json({ texto: 'Datos de Tabla Temporal Eliminados' });
});

// ELIMINAR MODELO
router.get('/eliminarModelo', (req, res) => {
    var sql = "SET FOREIGN_KEY_CHECKS = 0;\
    DROP TABLE IF EXISTS `Practica1`.`Hospital`;\
    DROP TABLE IF EXISTS `Practica1`.`Paciente`;\
    DROP TABLE IF EXISTS `Practica1`.`Tratamiento`;\
    DROP TABLE IF EXISTS `Practica1`.`TratamientoPaciente`;\
    DROP TABLE IF EXISTS `Practica1`.`Ubicacion`;\
    DROP TABLE IF EXISTS `Practica1`.`Contacto`;\
    DROP TABLE IF EXISTS `Practica1`.`PacienteContacto`;\
    DROP TABLE IF EXISTS `Practica1`.`Interaccion`;\
    DROP TABLE IF EXISTS `Practica1`.`HospitalPaciente`;\
    DROP TABLE IF EXISTS `Practica1`.`HospitalPaciente`;\
    SET FOREIGN_KEY_CHECKS = 1;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        console.log("Modelo Eliminado");
    });
    res.json({ texto: 'Modelo Eliminado' });
});

// CARGA TERMPORAL
router.post('/cargarTemporal', (req, res) => {

    var sql = "LOAD  DATA LOCAL INFILE '" + req.body.ruta + "'\
    into table  Temporal\
    character set latin1\
    fields terminated by ';'\
    ignore 1 lines\
    (NOMBRE_VICTIMA, APELLIDO_VICTIMA, DIRECCION_VICTIMA, @var1, @var2, @var3, ESTADO_VICTIMA, NOMBRE_ASOCIADO, APELLIDO_ASOCIADO, @var4, CONTACTO_FISICO, @var5, @var6, NOMBRE_HOSPITAL, DIRECCION_HOSPITAL, UBICACION_VICTIMA, @var7, @var8, TRATAMIENTO, EFECTIVIDAD, @var9, @var10, EFECTIVIDAD_EN_VICTIMA)\
    set FECHA_PRIMERA_SOSPECHA = STR_TO_DATE(@var1, '%Y-%m-%d %H:%i:%s'),\
    FECHA_CONFIRMACION = STR_TO_DATE(@var2, '%Y-%m-%d %H:%i:%s'),\
    FECHA_MUERTE = STR_TO_DATE(@var3, '%Y-%m-%d %H:%i:%s'),\
    FECHA_CONOCIO = STR_TO_DATE(@var4, '%Y-%m-%d %H:%i:%s'),\
    FECHA_INICIO_CONTACTO = STR_TO_DATE(@var5, '%Y-%m-%d %H:%i:%s'),\
    FECHA_FIN_CONTACTO = STR_TO_DATE(@var6, '%Y-%m-%d %H:%i:%s'),\
    FECHA_LLEGADA = STR_TO_DATE(@var7, '%Y-%m-%d %H:%i:%s'),\
    FECHA_RETIRO = STR_TO_DATE(@var8, '%Y-%m-%d %H:%i:%s'),\
    FECHA_INICIO_TRATAMIENTO = STR_TO_DATE(@var9, '%Y-%m-%d %H:%i:%s'),\
    FECHA_FIN_TRATAMIENTO = STR_TO_DATE(@var10, '%Y-%m-%d %H:%i:%s');";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        console.log('Tabla Temporal Cargada');
    });

    res.json({ texto: 'Tabla Temporal Cargada' });
});

// CARGAR MODELO
router.get('/cargarModelo', (req, res) => {
    var sql = "SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;\
    SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;\
    SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';\
    DROP TABLE IF EXISTS `Practica1`.`Hospital` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`Hospital` (\
      `idHospital` INT NOT NULL AUTO_INCREMENT,\
      `nombre` VARCHAR(50) NOT NULL,\
      `direccion` VARCHAR(100) NOT NULL,\
      PRIMARY KEY (`idHospital`))\
    ENGINE = InnoDB;\
    DROP TABLE IF EXISTS `Practica1`.`Paciente` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`Paciente` (\
      `idPaciente` INT NOT NULL AUTO_INCREMENT,\
      `nombre` VARCHAR(50) NOT NULL,\
      `apellido` VARCHAR(50) NOT NULL,\
      `direccion` VARCHAR(100) NOT NULL,\
      `fechaPrimeraSospecha` DATETIME NOT NULL,\
      `fechaConfirmacion` DATETIME NOT NULL,\
      `fechaDefuncion` DATETIME NULL,\
      `statusEnfermedad` VARCHAR(50) NOT NULL,\
      PRIMARY KEY (`idPaciente`))\
    ENGINE = InnoDB;\
    DROP TABLE IF EXISTS `Practica1`.`Tratamiento` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`Tratamiento` (\
      `idTratamiento` INT NOT NULL AUTO_INCREMENT,\
      `nombre` VARCHAR(45) NOT NULL,\
      PRIMARY KEY (`idTratamiento`))\
    ENGINE = InnoDB;\
    DROP TABLE IF EXISTS `Practica1`.`TratamientoPaciente` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`TratamientoPaciente` (\
      `idTratamientoPaciente` INT NOT NULL AUTO_INCREMENT,\
      `idPaciente` INT NOT NULL,\
      `idTratamiento` INT NOT NULL,\
      `efectividad` INT NOT NULL,\
      `fechaInicio` DATETIME NOT NULL,\
      `fechaFin` DATETIME NOT NULL,\
      PRIMARY KEY (`idTratamientoPaciente`),\
      INDEX `fk_idPaciente_Tratamiento_idx` (`idPaciente` ASC) VISIBLE,\
      INDEX `fk_idTratemiento_Tratamiento_idx` (`idTratamiento` ASC) VISIBLE,\
      CONSTRAINT `fk_idPaciente_Tratamiento`\
        FOREIGN KEY (`idPaciente`)\
        REFERENCES `Practica1`.`Paciente` (`idPaciente`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION,\
      CONSTRAINT `fk_idTratemiento_Tratamiento`\
        FOREIGN KEY (`idTratamiento`)\
        REFERENCES `Practica1`.`Tratamiento` (`idTratamiento`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION)\
    ENGINE = InnoDB;\
    DROP TABLE IF EXISTS `Practica1`.`Ubicacion` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`Ubicacion` (\
      `idUbicacion` INT NOT NULL AUTO_INCREMENT,\
      `idPaciente` INT NOT NULL,\
      `direccion` VARCHAR(100) NOT NULL,\
      `fechaIngreso` DATETIME NOT NULL,\
      `fechaEgreso` DATETIME NOT NULL,\
      PRIMARY KEY (`idUbicacion`),\
      INDEX `fk_idPaciente_Ubicacion_idx` (`idPaciente` ASC) VISIBLE,\
      CONSTRAINT `fk_idPaciente_Ubicacion`\
        FOREIGN KEY (`idPaciente`)\
        REFERENCES `Practica1`.`Paciente` (`idPaciente`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION)\
    ENGINE = InnoDB;\
    DROP TABLE IF EXISTS `Practica1`.`Contacto` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`Contacto` (\
      `idContacto` INT NOT NULL AUTO_INCREMENT,\
      `nombre` VARCHAR(50) NOT NULL,\
      `apellido` VARCHAR(50) NOT NULL,\
      PRIMARY KEY (`idContacto`))\
    ENGINE = InnoDB;\
    DROP TABLE IF EXISTS `Practica1`.`PacienteContacto` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`PacienteContacto` (\
      `idPacienteContacto` INT NOT NULL AUTO_INCREMENT,\
      `idPaciente` INT NOT NULL,\
      `idContacto` INT NOT NULL,\
      `fechaConocer` DATETIME NOT NULL,\
      PRIMARY KEY (`idPacienteContacto`),\
      INDEX `fk_idPaciente_Contacto_idx` (`idPaciente` ASC) VISIBLE,\
      INDEX `fk_idContacto_Contacto_idx` (`idContacto` ASC) VISIBLE,\
      CONSTRAINT `fk_idPaciente_Contacto`\
        FOREIGN KEY (`idPaciente`)\
        REFERENCES `Practica1`.`Paciente` (`idPaciente`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION,\
      CONSTRAINT `fk_idContacto_Contacto`\
        FOREIGN KEY (`idContacto`)\
        REFERENCES `Practica1`.`Contacto` (`idContacto`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION)\
    ENGINE = InnoDB;\
    DROP TABLE IF EXISTS `Practica1`.`Interaccion` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`Interaccion` (\
      `idInteraccion` INT NOT NULL AUTO_INCREMENT,\
      `interaccion` VARCHAR(50) NOT NULL,\
      `fechaInicio` DATETIME NOT NULL,\
      `fechaFin` DATETIME NOT NULL,\
      `idPaciente` INT NOT NULL,\
      `idContacto` INT NOT NULL,\
      PRIMARY KEY (`idInteraccion`),\
      INDEX `fk_idPaciente_Interaccion_idx` (`idPaciente` ASC) VISIBLE,\
      INDEX `fk_idContacto_Interaccion_idx` (`idContacto` ASC) VISIBLE,\
      CONSTRAINT `fk_idPaciente_Interaccion`\
        FOREIGN KEY (`idPaciente`)\
        REFERENCES `Practica1`.`Paciente` (`idPaciente`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION,\
      CONSTRAINT `fk_idContacto_Interaccion`\
        FOREIGN KEY (`idContacto`)\
        REFERENCES `Practica1`.`Contacto` (`idContacto`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION)\
    ENGINE = InnoDB;\
    DROP TABLE IF EXISTS `Practica1`.`HospitalPaciente` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`HospitalPaciente` (\
      `idHospitalPaciente` INT NOT NULL AUTO_INCREMENT,\
      `idPaciente` INT NOT NULL,\
      `idHospital` INT NOT NULL,\
      PRIMARY KEY (`idHospitalPaciente`),\
      INDEX `fk_idPaciente_HospitalPaciente_idx` (`idPaciente` ASC) VISIBLE,\
      INDEX `fk_idHospital_HospitalPaciente_idx` (`idHospital` ASC) VISIBLE,\
      CONSTRAINT `fk_idPaciente_HospitalPaciente`\
        FOREIGN KEY (`idPaciente`)\
        REFERENCES `Practica1`.`Paciente` (`idPaciente`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION,\
      CONSTRAINT `fk_idHospital_HospitalPaciente`\
        FOREIGN KEY (`idHospital`)\
        REFERENCES `Practica1`.`Hospital` (`idHospital`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION)\
    ENGINE = InnoDB;\
    DROP TABLE IF EXISTS `Practica1`.`HospitalPaciente` ;\
    CREATE TABLE IF NOT EXISTS `Practica1`.`HospitalPaciente` (\
      `idHospitalPaciente` INT NOT NULL AUTO_INCREMENT,\
      `idPaciente` INT NOT NULL,\
      `idHospital` INT NOT NULL,\
      PRIMARY KEY (`idHospitalPaciente`),\
      INDEX `fk_idPaciente_HospitalPaciente_idx` (`idPaciente` ASC) VISIBLE,\
      INDEX `fk_idHospital_HospitalPaciente_idx` (`idHospital` ASC) VISIBLE,\
      CONSTRAINT `fk_idPaciente_HospitalPaciente`\
        FOREIGN KEY (`idPaciente`)\
        REFERENCES `Practica1`.`Paciente` (`idPaciente`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION,\
      CONSTRAINT `fk_idHospital_HospitalPaciente`\
        FOREIGN KEY (`idHospital`)\
        REFERENCES `Practica1`.`Hospital` (`idHospital`)\
        ON DELETE NO ACTION\
        ON UPDATE NO ACTION)\
    ENGINE = InnoDB;\
    SET SQL_MODE=@OLD_SQL_MODE;\
    SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;\
    SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;\
    insert into Hospital(nombre, direccion) \
    select distinct temp.NOMBRE_HOSPITAL, temp.DIRECCION_HOSPITAL \
    from Temporal as temp\
    where temp.NOMBRE_HOSPITAL != \"\";\
    insert into Contacto(nombre, apellido) \
    select distinct temp.NOMBRE_ASOCIADO, temp.APELLIDO_ASOCIADO\
    from Temporal as temp\
    where temp.NOMBRE_ASOCIADO != \"\" and temp.APELLIDO_ASOCIADO != \"\";\
    insert into Tratamiento(nombre) \
    select distinct temp.TRATAMIENTO\
    from Temporal as temp\
    where temp.TRATAMIENTO != \"\";\
    insert into Paciente(nombre, apellido, direccion, fechaPrimeraSospecha, fechaConfirmacion, fechaDefuncion, statusEnfermedad) \
    select distinct temp.NOMBRE_VICTIMA, temp.APELLIDO_VICTIMA, temp.DIRECCION_VICTIMA, temp.FECHA_PRIMERA_SOSPECHA, temp.FECHA_CONFIRMACION, temp.FECHA_MUERTE, temp.ESTADO_VICTIMA\
    from Temporal as temp\
    where temp.NOMBRE_VICTIMA != \"\";\
    insert into HospitalPaciente(idPaciente, idHospital) \
    select distinct paci.idPaciente, hosp.idHospital\
    from Temporal as temp\
    inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido\
    inner join Hospital as hosp on temp.NOMBRE_HOSPITAL = hosp.nombre and temp.DIRECCION_HOSPITAL = hosp.direccion;\
    insert into TratamientoPaciente(idPaciente, idTratamiento, efectividad, fechaInicio, fechaFin) \
    select distinct paci.idPaciente, trat.idTratamiento, temp.EFECTIVIDAD_EN_VICTIMA, temp.FECHA_INICIO_TRATAMIENTO, temp.FECHA_FIN_TRATAMIENTO\
    from Temporal as temp\
    inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido\
    inner join Tratamiento as trat on temp.TRATAMIENTO = trat.nombre;\
    insert into Ubicacion(idPaciente, direccion, fechaIngreso, fechaEgreso) \
    select distinct paci.idPaciente, temp.UBICACION_VICTIMA, temp.FECHA_LLEGADA, temp.FECHA_RETIRO\
    from Temporal as temp\
    inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido\
    where temp.UBICACION_VICTIMA != \"\";\
    insert into PacienteContacto(idPaciente, idContacto, fechaConocer) \
    select distinct paci.idPaciente, cont.idContacto, temp.FECHA_CONOCIO\
    from Temporal as temp\
    inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido\
    inner join Contacto as cont on temp.NOMBRE_ASOCIADO = cont.nombre and temp.APELLIDO_ASOCIADO = cont.apellido\
    where temp.NOMBRE_VICTIMA != \"\" and temp.NOMBRE_ASOCIADO != \"\" and cont.idContacto != \"\";\
    insert into Interaccion(idPaciente, idContacto, interaccion, fechaInicio, fechaFin) \
    select distinct paci.idPaciente, cont.idContacto, temp.CONTACTO_FISICO, temp.FECHA_INICIO_CONTACTO, temp.FECHA_FIN_CONTACTO\
    from Temporal as temp\
    inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido\
    inner join Contacto as cont on temp.NOMBRE_ASOCIADO = cont.nombre and temp.APELLIDO_ASOCIADO = cont.apellido\
    where temp.CONTACTO_FISICO is not null and temp.FECHA_INICIO_CONTACTO is not null;";

    var consulta = connection.query(sql, function (err, result) {
        if (err) throw err;
        console.log('Modelo Cargado');
    });

    res.json({ texto: 'Modelo Cargado' });
});

module.exports = router;