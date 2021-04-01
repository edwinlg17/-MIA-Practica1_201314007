use Practica1;
-- -----------------------------------------------------
-- Cargar Tabla Temporal
-- -----------------------------------------------------
LOAD  DATA LOCAL INFILE '/home/edwin/Escritorio/Practica1/GRAND_VIRUS_EPICENTER.csv'
into table  Temporal
character set latin1
fields terminated by ';'
ignore 1 lines
(NOMBRE_VICTIMA, APELLIDO_VICTIMA, DIRECCION_VICTIMA, @var1, @var2, @var3, ESTADO_VICTIMA, NOMBRE_ASOCIADO, APELLIDO_ASOCIADO, @var4, CONTACTO_FISICO, @var5, @var6, NOMBRE_HOSPITAL, DIRECCION_HOSPITAL, UBICACION_VICTIMA, @var7, @var8, TRATAMIENTO, EFECTIVIDAD, @var9, @var10, EFECTIVIDAD_EN_VICTIMA)
set FECHA_PRIMERA_SOSPECHA = STR_TO_DATE(@var1, '%Y-%m-%d %H:%i:%s'),
FECHA_CONFIRMACION = STR_TO_DATE(@var2, '%Y-%m-%d %H:%i:%s'),
FECHA_MUERTE = STR_TO_DATE(@var3, '%Y-%m-%d %H:%i:%s'),
FECHA_CONOCIO = STR_TO_DATE(@var4, '%Y-%m-%d %H:%i:%s'),
FECHA_INICIO_CONTACTO = STR_TO_DATE(@var5, '%Y-%m-%d %H:%i:%s'),
FECHA_FIN_CONTACTO = STR_TO_DATE(@var6, '%Y-%m-%d %H:%i:%s'),
FECHA_LLEGADA = STR_TO_DATE(@var7, '%Y-%m-%d %H:%i:%s'),use Practica1;
FECHA_RETIRO = STR_TO_DATE(@var8, '%Y-%m-%d %H:%i:%s'),
FECHA_INICIO_TRATAMIENTO = STR_TO_DATE(@var9, '%Y-%m-%d %H:%i:%s'),
FECHA_FIN_TRATAMIENTO = STR_TO_DATE(@var10, '%Y-%m-%d %H:%i:%s');

-- -----------------------------------------------------
-- Carga del Modelo 
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Consulta Hospitales 
-- -----------------------------------------------------
insert into Hospital(nombre, direccion) 
select distinct temp.NOMBRE_HOSPITAL, temp.DIRECCION_HOSPITAL 
from Temporal as temp
where temp.NOMBRE_HOSPITAL != "";

-- -----------------------------------------------------
-- Consulta Contacto 
-- -----------------------------------------------------
insert into Contacto(nombre, apellido) 
select distinct temp.NOMBRE_ASOCIADO, temp.APELLIDO_ASOCIADO
from Temporal as temp
where temp.NOMBRE_ASOCIADO != "" and temp.APELLIDO_ASOCIADO != "";

-- -----------------------------------------------------
-- Consulta Tratamiento 
-- -----------------------------------------------------
insert into Tratamiento(nombre) 
select distinct temp.TRATAMIENTO
from Temporal as temp
where temp.TRATAMIENTO != "";

-- -----------------------------------------------------
-- Consulta Paciente 
-- -----------------------------------------------------
insert into Paciente(nombre, apellido, direccion, fechaPrimeraSospecha, fechaConfirmacion, fechaDefuncion, statusEnfermedad) 
select distinct temp.NOMBRE_VICTIMA, temp.APELLIDO_VICTIMA, temp.DIRECCION_VICTIMA, temp.FECHA_PRIMERA_SOSPECHA, temp.FECHA_CONFIRMACION, temp.FECHA_MUERTE, temp.ESTADO_VICTIMA
from Temporal as temp
where temp.NOMBRE_VICTIMA != "";

-- -----------------------------------------------------
-- Consulta HospitalPaciente 
-- -----------------------------------------------------
insert into HospitalPaciente(idPaciente, idHospital) 
select distinct paci.idPaciente, hosp.idHospital
from Temporal as temp
inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido
inner join Hospital as hosp on temp.NOMBRE_HOSPITAL = hosp.nombre and temp.DIRECCION_HOSPITAL = hosp.direccion;

-- -----------------------------------------------------
-- Consulta TratamientoPaciente 
-- ----------------------------------------------------- 
insert into TratamientoPaciente(idPaciente, idTratamiento, efectividad, fechaInicio, fechaFin) 
select distinct paci.idPaciente, trat.idTratamiento, temp.EFECTIVIDAD_EN_VICTIMA, temp.FECHA_INICIO_TRATAMIENTO, temp.FECHA_FIN_TRATAMIENTO
from Temporal as temp
inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido
inner join Tratamiento as trat on temp.TRATAMIENTO = trat.nombre;

-- -----------------------------------------------------
-- Consulta Ubicacion 
-- -----------------------------------------------------
insert into Ubicacion(idPaciente, direccion, fechaIngreso, fechaEgreso) 
select distinct paci.idPaciente, temp.UBICACION_VICTIMA, temp.FECHA_LLEGADA, temp.FECHA_RETIRO
from Temporal as temp
inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido
where temp.UBICACION_VICTIMA != "";

-- -----------------------------------------------------
-- Consulta PacienteContacto 
-- -----------------------------------------------------
insert into PacienteContacto(idPaciente, idContacto, fechaConocer) 
select distinct paci.idPaciente, cont.idContacto, temp.FECHA_CONOCIO
from Temporal as temp
inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido
inner join Contacto as cont on temp.NOMBRE_ASOCIADO = cont.nombre and temp.APELLIDO_ASOCIADO = cont.apellido
where temp.NOMBRE_VICTIMA != "" and temp.NOMBRE_ASOCIADO != "" and cont.idContacto != "";

-- -----------------------------------------------------
-- Consulta Interaccion 
-- -----------------------------------------------------
insert into Interaccion(idPaciente, idContacto, interaccion, fechaInicio, fechaFin) 
select distinct paci.idPaciente, cont.idContacto, temp.CONTACTO_FISICO, temp.FECHA_INICIO_CONTACTO, temp.FECHA_FIN_CONTACTO
from Temporal as temp
inner join Paciente as paci on temp.NOMBRE_VICTIMA = paci.nombre and temp.APELLIDO_VICTIMA = paci.apellido
inner join Contacto as cont on temp.NOMBRE_ASOCIADO = cont.nombre and temp.APELLIDO_ASOCIADO = cont.apellido
where temp.CONTACTO_FISICO is not null and temp.FECHA_INICIO_CONTACTO is not null;