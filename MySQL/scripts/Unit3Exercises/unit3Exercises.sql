SET GLOBAL log_bin_trust_function_creators = 1;

/* Ejercicio 1: crea una función que devuelva 1 ó 0 si un número es o no divisible por otro. Debe de recibir dos números por parámetros. */
delimiter //
drop function if exists return1Or2;
create function return1Or2(numero1 int, numero2 int)
	returns int
begin
	if numero1 % numero2 = 0 then
		return 1;
	else
		return 0;
	end if;
end; 
-- Llamada a la función:  
select return1Or2(2,3);//-- Resultado = 0
-- Llamada a la función:  
select return1Or2(4,2);//-- Resultado = 1


/* Ejercicio 2: usa las estructuras condicionales para mostrar el día de la semana según un valor de entrada numérico, 1 para domingo, 
2 lunes, etc. */
delimiter //
drop function if exists returnDay;
create function returnDay(numero int)
	returns varchar(10)
begin
	declare dia varchar(10);
	if numero = 0 then
		set dia = 'Lunes';
	elseif numero = 1 then
		set dia = 'Martes';
	elseif numero = 2 then
		set dia = 'Miércoles';
	elseif numero = 3 then
		set dia = 'Jueves';
	elseif numero = 4 then
		set dia = 'Viernes';
	elseif numero = 5 then
		set dia = 'Sábado';
	else
		set dia = 'Domingo';
	end if;
    return dia;
end; 
-- LLamada a la función: 
select returnDay(2); //


/* Ejercicio 3: sabiendo que la función now() devuelve la fecha actual y que DATE_FORMAT le da formato a la fecha, crea una procedimiento que 
llame a la función anterior del día de la semana, y para los días “viernes” nos de la fecha de hoy en formato dd-mm-yyyy. */
delimiter //
drop procedure if exists formatFriday;
create procedure formatFriday()
begin
    if returnDay(weekday(now())) = 'Viernes' then
		select date_format(now(), '%d-%m-%Y') as 'Fecha';
	end if;
end;
-- Llamada a la función:
call formatFriday();//


/* Ejercicio 4: Crea un procedimiento que reciba una fecha por parámetro y muestre por pantalla el día de la semana, seguido del número de día, mes y año como se muestra 
a continuación. 
 +------------------------------------+ 
 | Fecha                              | 
 +------------------------------------+ 
 | martes, 19 de febrero de 2019 	  | 
 +------------------------------------+ */
delimiter //
drop procedure if exists showDate;
create procedure showDate()
begin
SET lc_time_names = 'es_ES';
	select date_format(now(), '%W, %d de %M de %Y') as 'Fecha';
end;
-- LLamada al procedimiento
call showDate(); //
 
/* Ejercicio 5: crea una función, que reciba por parámetro una fecha de nacimiento y devuelva la edad de la persona en años. */

/*delimiter //
drop procedure if exists returnAge;
create procedure returnAge()
begin
	select (datediff(now(),'1995-02-05') / 365) as 'Años de edad'; 
end;
-- LLamada al procedimiento
call returnAge(); // */

delimiter //
drop function if exists returnEdad;
create function returnEdad(fechaNacimiento varchar(10))
	returns double
begin
	declare result double;
	set result = datediff(now(),fechaNacimiento) / 365;
    return result;
end;
-- LLamada a la función
select returnEdad('1995-02-05') as 'Edad'; //

/* Ejercicio 6: crea una función que devuelva el mayor de tres números pasados como parámetros. */
delimiter //
drop function if exists returnBigger;
create function returnBigger(number1 int, number2 int, number3 int)
	returns int
begin
	declare result int;
    set result = greatest(number1, number2, number3);
    return result;
end;
-- LLamada a la función
select returnBigger(7,6,9); //
select returnBigger(56,33,45); //