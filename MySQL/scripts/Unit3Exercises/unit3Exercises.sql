USE actividades_tema3;
SET GLOBAL log_bin_trust_function_creators = 1;


/* Ejercicio 1: crea una función que devuelva 1 ó 0 si un número es o no divisible por otro. Debe de recibir dos números por parámetros. */
delimiter //
drop function if exists return1Or2 //
create function return1Or2(numero1 int, numero2 int)
	returns int
begin
	if numero1 % numero2 = 0 then
		return 1;
	else
		return 0;
	end if;
end //
delimiter ;

-- Llamada a la función:  
SELECT RETURN1OR2(2, 3);-- Resultado = 0
SELECT RETURN1OR2(4, 2);-- Resultado = 1


/* Ejercicio 2: usa las estructuras condicionales para mostrar el día de la semana según un valor de entrada numérico, 1 para domingo, 
2 lunes, etc. */
delimiter //
drop function if exists returnDay //
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
end //

-- LLamada a la función: 
delimiter ;
SELECT RETURNDAY(2); //


/* Ejercicio 3: sabiendo que la función now() devuelve la fecha actual y que DATE_FORMAT le da formato a la fecha, crea una procedimiento que 
llame a la función anterior del día de la semana, y para los días “viernes” nos de la fecha de hoy en formato dd-mm-yyyy. */
delimiter //
drop procedure if exists formatFriday //
create procedure formatFriday()
begin
    if returnDay(weekday(now())) = 'Viernes' then
		select date_format(now(), '%d-%m-%Y') as 'Fecha';
	end if;
end //

-- Llamada a la función:
delimiter ;
call formatFriday(); 


/* Ejercicio 4: Crea un procedimiento que reciba una fecha por parámetro y muestre por pantalla el día de la semana, seguido del número de día, mes y año como se muestra 
a continuación. 
 +------------------------------------+ 
 | Fecha                              | 
 +------------------------------------+ 
 | martes, 19 de febrero de 2019 	  | 
 +------------------------------------+ */
delimiter //
drop procedure if exists showDate //
create procedure showDate()
begin
SET lc_time_names = 'es_ES';
	select date_format(now(), '%W, %d de %M de %Y') as 'Fecha';
end //

-- LLamada al procedimiento
delimiter ;
call showDate(); 
 
 
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
drop function if exists returnEdad //
create function returnEdad(fechaNacimiento varchar(10))
	returns int
begin
	declare result int;
	set result = datediff(now(),fechaNacimiento) / 365;
    return result;
end //

-- LLamada a la función
delimiter ;
SELECT RETURNEDAD('1995-02-05') AS 'Edad';


/* Ejercicio 6: crea una función que devuelva el mayor de tres números pasados como parámetros. */
delimiter //
drop function if exists returnBigger //
create function returnBigger(number1 int, number2 int, number3 int)
	returns int
begin
	declare result int;
    set result = greatest(number1, number2, number3);
    return result;
end;//

-- LLamada a la función
delimiter ;
SELECT RETURNBIGGER(7, 6, 9);
SELECT RETURNBIGGER(56, 33, 45);


/* Ejercicio 7: crea un procedimiento con una sentencia while que:
	- Reciba por parámetro un número entero y muestre por pantalla la suma de todos los
	números, entre 1 y el pasado como parámetro (ambos incluidos).
	- Si el número introducido es cero o negativo, se deberá mostrar un mensaje de error. */
delimiter //
drop procedure if exists mostrarSuma //
create procedure mostrarSuma(in numero int(3)) 
begin
    declare contador int(3);
    declare resultado int(3);
    
    set contador = numero;
    set resultado = 0;
    
    if numero <= 0 then
		select "El número es igual o inferior a cero." as 'Error';
	else
		while (contador > 1) do
			set resultado = resultado + contador;
			set contador = contador - 1;
		end while;
    select resultado as Suma;
	end if;
end //

-- LLamada al procedimiento
delimiter ;
call mostrarSuma(4);
call mostrarSuma(3);
call mostrarSuma(-5);


/* Ejercicio 8: Mediante la sentencia repeat, realiza un procedimiento que muestre los números primos que hay desde 0 
hasta un número pasado por parámetro */
delimiter //
drop procedure if exists mostrarPrimos //
create procedure mostrarPrimos(numero int)
begin
	declare divisor int;
    declare numeroAMostrar int;
    
    set divisor = 2;
    set numeroAMostrar = 2;
    
    repeat
		if (divisor < numeroAMostrar) and mod(numeroAMostrar, divisor) != 0 then
			set divisor = divisor + 1;
		elseif divisor = numeroAMostrar then
			select concat(numeroAMostrar);
            set divisor = 2;
            set numeroAMostrar = numeroAMostrar + 1;
		else
            set divisor = 2;
            set numeroAMostrar = numeroAMostrar + 1;
		end if;
	until numeroAMostrar = numero
	end repeat;
end //

-- Llamada a la función
delimiter ;
call mostrarPrimos(10);
call mostrarPrimos(20);
call mostrarPrimos(50);


-- Creamos diferentes tablas sobre las que realizar otros ejercicios.
CREATE TABLE pedido (
    refped CHAR(5) PRIMARY KEY,
    fecped DATE NOT NULL
);

CREATE TABLE articulo (
    codart CHAR(5) PRIMARY KEY,
    desart VARCHAR(30) NOT NULL,
    pvpart FLOAT(6 , 2 ) UNSIGNED NOT NULL
);

CREATE TABLE lineapedido (
    refped CHAR(5),
    codart CHAR(5),
    cantart INT(4) UNSIGNED NOT NULL DEFAULT 1,
    INDEX (refped),
    FOREIGN KEY (refped)
        REFERENCES pedido (refped)
        ON UPDATE CASCADE,
    INDEX (codart),
    FOREIGN KEY (codart)
        REFERENCES articulo (codart)
        ON UPDATE CASCADE,
    PRIMARY KEY (refped , codart)
);

INSERT INTO pedido VALUES ('P0001', '2014-02-16');
INSERT INTO pedido VALUES ('P0002', '2014-02-18'); 
INSERT INTO pedido VALUES ('P0003', '2014-02-23');
INSERT INTO pedido VALUES ('P0004', '2014-02-25');

INSERT INTO articulo VALUES ('A0043', 'Bolígrafo azul', 0.78);
INSERT INTO articulo VALUES ('A0078', 'Bolígrafo rojo normal', 1.05);
INSERT INTO articulo VALUES ('A0075', 'Lápiz 2B', 0.55);
INSERT INTO articulo VALUES ('A0012', 'Goma de borrar', 0.15);
INSERT INTO articulo VALUES ('A0089', 'Sacapuntas', 0.25);

INSERT lineapedido VALUES ('P0001', 'A0043', 10);
INSERT lineapedido VALUES ('P0001', 'A0078', 12);
INSERT lineapedido VALUES ('P0002', 'A0043', 5);
INSERT lineapedido VALUES ('P0003', 'A0075', 20); 
INSERT lineapedido VALUES ('P0004', 'A0012', 15); 
INSERT lineapedido VALUES ('P0004', 'A0043', 5); 
INSERT lineapedido VALUES ('P0004', 'A0089', 50);


/* Ejercicio 9: Realiza una función llamada leerDescriArti, que reciba el código de un artículo 
y nos devuelva su descripción. */
delimiter //
drop function if exists leerDescriArti //
create function leerDescriArti(codigo char(5))
	returns varchar(20)
begin
	return (
		select
			a.desart
		from
			articulo a
		where
			codigo=a.codart);					
end //

-- Llamada a la función
delimiter ;
select leerDescriArti('A0089'); 			


/* 10. Realiza un procedimiento llamado consultarPedido, que reciba la referencia de un
pedido y nos devuelva el número de artículos diferentes solicitados en dicho pedido y el
número de unidades de artículos solicitadas.
La referencia del pedido es un parámetro de entrada y habrá dos parámetros de salida para
los otros dos datos indicados. */
delimiter //
drop procedure if exists consultarPedido //
create procedure consultarPedido(in referencia char(5))
begin
	select
		count(distinct l.codart) as 'Número de artículos diferentes', sum(l.cantart) as 'Cantidad de artículos en el pedido'
	from
		lineapedido l
	where
		referencia = l.refped;
end //
delimiter ;
-- LLamada al procedimiento
call consultarPedido('P0001');
call consultarPedido('P0004');

/* 11. Crea un procedimiento llamado mostrarInfoPedido, que reciba la referencia de un
pedido, llame al procedimiento consultarPedido y muestre los datos recibidos. */
delimiter //
drop procedure if exists mostrarInfoPedido //
create procedure mostrarInfoPedido(referencia char(5))
begin												
	call consultarPedido(referencia);
end //
-- Llamada a la función
delimiter ;
call mostrarInfoPedido('P0001');
call mostrarInfoPedido('P0004');

/* 12. Repite el ejercicio anterior pero realizando la llamada al procedimiento ConsultarPedido
mediante variables de sesión. */
delimiter //
drop procedure if exists mostrarInfoPedido2 //
create procedure mostrarInfoPedido2(referencia char(5))
begin
    set @v1 = referencia;											
    call consultarPedido(@v1);
end //
-- Llamada a la función
delimiter ;
call mostrarInfoPedido2('P0001');
call mostrarInfoPedido2('P0004');


/* 13. Realiza un procedimiento llamado importePedidos con un parámetro de entrada/salida,
debe de recibir una cantidad a la que habrá que sumar el importe de todos los pedidos de la
base de datos.
El parámetro es entrada/salida porque se pasa un dato al procedimiento (entrada), dato que
va a ser modificado por el procedimiento y devuelto al programa llamante (salida).
Para calcular el importe de todos los pedidos habrá que sumar los importes de todas las
líneas de pedido de la tabla LineaPedido. 
Se ha de tener en cuenta que el importe de una línea de pedido se calculará multiplicando el número de unidades solicitadas en dicha línea
de pedido (atributo CantArt) por el precio unitario del artículo correspondiente (atributo
PVPArt de la tabla artículo). */

delimiter //
drop procedure if exists importePedidos //
create procedure importePedidos(inout cantidad float)
begin
	declare importe float;
    set importe = (select sum(l.cantart * a.pvpart)
						from lineapedido l, articulo a
						where l.codart = a.codart);
	set cantidad = cantidad + importe;
end //

-- Llamada de la función
delimiter ;
set @cantidad = 5;
call importePedidos(@cantidad);
select @cantidad;
set @cantidad = 1;
call importePedidos(@cantidad);
select @cantidad;


/* 14. Realiza un procedimiento llamado impPedidos que realice una llamada al procedimiento
anterior importePedidos. El nuevo procedimiento ha de recibir como parámetro de
entrada el importe al que deseamos sumar el importe de los pedidos de la base de datos.
Debe de mostrar el mensaje “El importe total es xxx.xx euros”. */
delimiter //
drop procedure if exists impPedidos //
create procedure impPedidos(cantidad float)
begin
    set @cantidad = cantidad;
    call importePedidos(@cantidad);
    select concat( "El importe total es ", format(@cantidad, 2), " euros") as Mensaje;
end //

-- Llamada de la función
delimiter ;
call impPedidos(10);