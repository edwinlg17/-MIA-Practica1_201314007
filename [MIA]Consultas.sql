use Practica1;
-- -----------------------------------------------------
-- Repotes
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Consulta 1 
-- -----------------------------------------------------
select hos.nombre, hos.direccion, count(hos.idHospital) as fallecidos
from HospitalPaciente as reg
inner join Hospital as hos on reg.idHospital = hos.idHospital
inner join Paciente as pac on reg.idPaciente = pac.idPaciente
where pac.fechaDefuncion is not null
group by hos.idHospital;

-- -----------------------------------------------------
-- Consulta 2 
-- -----------------------------------------------------
select pac.nombre, pac.apellido
from TratamientoPaciente as reg
inner join Paciente as pac on reg.idPaciente = pac.idPaciente
inner join Tratamiento as tra on reg.idTratamiento = tra.idTratamiento
where pac.statusEnfermedad = 'en cuarentena' and tra.nombre = 'transfusiones de sangre' and reg.efectividad > 5;

-- -----------------------------------------------------
-- Consulta 3
-- -----------------------------------------------------
select count(reg.idPaciente), pac.nombre, pac.apellido, direccion
from PacienteContacto as reg
inner join Paciente as pac on reg.idPaciente = pac.idPaciente
where pac.fechaDefuncion is not null
group by reg.idPaciente
having count(reg.idPaciente) > 3;

-- -----------------------------------------------------
-- Consulta 4
-- -----------------------------------------------------
select pac.nombre, pac.apellido
from Interaccion as reg
inner join Paciente as pac on reg.idPaciente = pac.idPaciente
where pac.statusEnfermedad = "sospecha" and reg.interaccion = "Beso"
group by pac.idPaciente
having count(pac.idPaciente) > 2;

-- -----------------------------------------------------
-- Consulta 5
-- -----------------------------------------------------
select pac.nombre, pac.apellido
from TratamientoPaciente as reg
inner join Paciente as pac on reg.idPaciente = pac.idPaciente
inner join Tratamiento as tra on reg.idTratamiento = tra.idTratamiento
where tra.nombre = "Oxígeno"
group by pac.idPaciente
order by count(pac.idPaciente) desc
limit 5;

-- -----------------------------------------------------
-- Consulta 6
-- -----------------------------------------------------
select distinct pac.nombre, pac.apellido
from Ubicacion as ubi
inner join Paciente as pac on ubi.idPaciente = pac.idPaciente
inner join TratamientoPaciente as traPac on ubi.idPaciente = traPac.idPaciente
inner join Tratamiento as tra on tra.idTratamiento = traPac.idTratamiento
where ubi.direccion = "1987 Delphine Well"
and pac.fechaDefuncion is not null 
and tra.nombre = "Manejo de la presión arterial";

-- -----------------------------------------------------
-- Consulta 7
-- -----------------------------------------------------
select pac.nombre, pac.apellido, pac.direccion
from ((PacienteContacto as reg inner join Paciente as pac on reg.idPaciente = pac.idPaciente) inner join Contacto as con on reg.idContacto = con.idContacto)
inner join (
	select pac.nombre, pac.apellido
	from PacienteContacto as reg
	inner join Contacto as con on reg.idContacto = con.idContacto
	inner join Paciente as pac on pac.nombre = con.nombre and pac.apellido = con.apellido
	inner join HospitalPaciente as hosPac on hosPac.idPaciente = pac.idPaciente
	inner join TratamientoPaciente as traPac on traPac.idPaciente = pac.idPaciente
	group by pac.idPaciente
	having count(pac.idPaciente) = 2
) as sub on con.nombre = sub.nombre and con.apellido = sub.apellido
group by pac.idPaciente
having count(pac.idPaciente) < 2;

-- -----------------------------------------------------
-- Consulta 8
-- -----------------------------------------------------

select month(pac.fechaPrimeraSospecha) as mes, pac.nombre, pac.apellido
from TratamientoPaciente as reg
inner join Paciente as pac on pac.idPaciente = reg.idPaciente
group by pac.idPaciente
having count(pac.idPaciente) = (
	select count(idPaciente)
	from TratamientoPaciente
	group by idPaciente
	order by count(idPaciente) desc
	limit 1 ) 
or count(pac.idPaciente) = (
	select count(idPaciente)
	from TratamientoPaciente
	group by idPaciente
	order by count(idPaciente)
	limit 1 
);


-- -----------------------------------------------------
-- Consulta 9
-- -----------------------------------------------------
select hos.nombre, count(hos.idHospital)/ (select count(*) from HospitalPaciente) * 100 as porcentaje
from HospitalPaciente as hosPac
inner join Hospital as hos on hos.idHospital = hosPac.idHospital
group by hos.idHospital;

-- -----------------------------------------------------
-- Consulta 10
-- -----------------------------------------------------
select distinct hos.nombre, sub1.interaccion, sub1.cantidad/sub2.total*100 as promedio
from Hospital as hos
inner join (
	select hos.idHospital, inte.interaccion, count(inte.interaccion) as cantidad
	from Hospital as hos
	inner join HospitalPaciente as hosPac on hosPac.idHospital = hos.idHospital
	inner join Paciente as pac on pac.idPaciente = hosPac.idPaciente
	inner join Interaccion as inte on inte.idPaciente = pac.idPaciente
	group by hos.idHospital, inte.interaccion
	order by hos.idHospital, cantidad desc
) as sub1 on hos.idHospital = sub1.idHospital
inner join (
	select hos.idHospital, count(hos.idHospital) as total
	from Hospital as hos
	inner join HospitalPaciente as hosPac on hosPac.idHospital = hos.idHospital
	inner join Paciente as pac on pac.idPaciente = hosPac.idPaciente
	inner join Interaccion as inte on inte.idPaciente = pac.idPaciente
	group by hos.idHospital
) as sub2 on hos.idHospital = sub2.idHospital;

select hos.nombre, max(sub1.cantidad/sub2.total*100)
from Hospital as hos
right join (
	select hos.idHospital, inte.interaccion, count(inte.interaccion) as cantidad
	from Hospital as hos
	inner join HospitalPaciente as hosPac on hosPac.idHospital = hos.idHospital
	inner join Paciente as pac on pac.idPaciente = hosPac.idPaciente
	inner join Interaccion as inte on inte.idPaciente = pac.idPaciente
	group by hos.idHospital, inte.interaccion
	order by hos.idHospital, cantidad desc
) as sub1 on hos.idHospital = sub1.idHospital
right join (
	select hos.idHospital, count(hos.idHospital) as total
	from Hospital as hos
	inner join HospitalPaciente as hosPac on hosPac.idHospital = hos.idHospital
	inner join Paciente as pac on pac.idPaciente = hosPac.idPaciente
	inner join Interaccion as inte on inte.idPaciente = pac.idPaciente
	group by hos.idHospital
) as sub2 on hos.idHospital = sub2.idHospital
group by hos.idHospital;