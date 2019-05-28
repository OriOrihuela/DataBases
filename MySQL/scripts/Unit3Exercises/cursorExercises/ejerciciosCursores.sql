/*1. Create a procedure called seeOrder, that shows only one row of the requested table,
You must show your reference and date by using a cursor.
Example of output:
+---------------------------------------------+
| Datos Pedidos |
+---------------------------------------------+
| Referencia: P0001 Fecha: 2014-02-16 |
+---------------------------------------------+*/
delimiter //
drop procedure if exists verPedido //
create procedure verPedido(referenciaPorParametro varchar(10))
begin
	declare referencia, fecha varchar(20);
    
	declare cursor1 cursor for
		select refped, fecped 
        from pedido
        ;
        
	open cursor1 ;
		fetch cursor1 into referencia, fecha;
    close cursor1;
    
    select concat("Referencia:  ", referencia, "  Fecha:  ", fecha) as 'Datos Pedidos';
end //

-- Llamada al procedimiento
delimiter ;
call verPedido();

/*2. Modifica verPedido, para que muestre cada una de las filas de la tabla pedido. Además,
se debe de mostrar un mensaje dependiendo de la cantidad en años que tenga el pedido,
siendo éste “vigente” si tienes menos de 2 años, “antiguo” si tiene 3 ó 4 años y “muy
antiguo” si tiene 5 o más años.*/
delimiter //
drop procedure if exists verPedido2; //
create procedure verPedido2()
begin
	declare temp date;
	declare variable int;
    
	declare cursor1 cursor for
	select p.fecped from pedido p;
    
	open cursor1;
		loop1: loop
			fetch cursor1 into temp;
			set variable = datediff(now(), temp);
			if  variable > 0 and variable < 2 then 
				select 'vigente';
			end if;
			if variable < 4 and variable > 2 then
				select 'antiguo';
			end if;
			if variable >= 5 then 
				select 'muy antiguo';
			end if;
		end loop loop1;
	close cursor1;
end //
delimiter ;
-- Llamada a la funcion
call verPedido2(); 

/*3. Realiza un procedimiento llamado verArticuloPedido, en que solicite por parámetro
el código de un producto y muestre cada uno de los pedidos que tiene asociado, así como el
número de unidades solicitadas del artículo.
Si el pedido tiene un número de unidades de 5 o menos, se indicará que es un pedido
pequeño, si tiene entre 6 y 10 unidades, será un pedido mediano y si tiene 15 o más
unidades, será un pedido grande.*/
delimiter //
drop procedure if exists verArticuloPedido //
create procedure verArticuloPedido(codigo varchar(10))
begin
	declare cantidad int(3);
    declare pedidoAsociado varchar(20);
    declare fallo bool;
    
    declare cursor1 cursor for
		select
			l.refped, l.cantart
		from
			lineapedido l
		where
			codigo = l.codart;
	
    declare continue handler for 1062 set fallo = 1;
    set fallo = 0;
    
    open cursor1;
		while fallo = 0 do
			fetch cursor1 into pedidoAsociado, cantidad;
			if cantidad <= 5 then
				select pedidoAsociado as 'Referencia del pedido', cantidad as 'pequeño';
			end if;
			
			if cantidad >= 6 and cantidad <= 10 then
				select pedidoAsociado as 'Referencia del pedido', cantidad as 'mediano';
			end if;
			
			if cantidad > 15 then
				select pedidoAsociado as 'Referencia del pedido', cantidad as 'grande' ;
			end if;
		end while;
    close cursor1;
end //
-- Llamada al procedimiento
delimiter ;
call verArticuloPedido('A0043');

/*4. Crea un procedimiento insertarPedido que se encargue de añadir un nuevo pedido a
la tabla PEDIDO, este procedimiento recibirá como parámetros la referencia del pedido que
se desea añadir y su fecha. Debe de mostrar un mensaje si se ha realizado correctamente.
Excepciones:*/
delimiter //
drop procedure if exists insertarPedido //
create procedure insertarPedido(refPedido varchar(20), fecha date)
modifies sql data
begin
	declare fallo bool;
    
    declare continue handler for 1062 set fallo = 1;
    insert into pedido (refped, fecped) values (refPedido, fecha);
    
    if fallo = 1 then
		select concat("Error en la inserción de ", refPedido, " clave referenciada duplicada") as 'Resultado';
	else
		select concat("Pedido ", refPedido, " añadido en ésta fecha: ", fecha) as 'Resultado';
	end if;
end //
-- LLamada al procedimiento
delimiter ;
call insertarPedido('P0005', now()); -- Éste va a insertarlo


/*5. Modifica el procedimiento insertarPedido para que, en el caso que se produzca la
excepción al insertar un pedido repetido (clave duplicada), no finalice anormalmente
mostrando la descripción por defecto del error por pantalla, y en su lugar, termine 
normalmente y guarde en una variable de salida estado, un mensaje con el tipo de error
“Clave duplicada”. Se debe de utilizar un manejador o handler.*/

call insertarPedido('P0005', now()); -- Éste va a dar error

/*6. Crea un procedimiento llamado insertar que se encargue de llamar a insertarPedido
y nos informe si la inserción se ha podido llevar a cabo o no. Nos debe de mostrar un
mensaje de error confeccionado por nosotros para el tipo de error que nos devuelve, por
ejemplo “ERROR. Ya hay un pedido con la referencia XXXX”.*/
delimiter //
drop procedure if exists insertar //
create procedure insertar(refPedido varchar(20), fecha date)
modifies sql data
begin
	
    call insertarPedido(refPedido, fecha);
end //
-- LLamada al procedimiento
delimiter ;
call insertar('P0006', now()); -- Éste va a insertarlo
call insertar('P0006', now()); -- Éste va a dar error.

/*7. Crea un procedimiento que reciba como parámetro el código de un artículo y nos muestre su
descripción en caso de existir. En caso de que no exista ningún artículo con dicho código, se
mostrará un mensaje como el siguiente: “No existe ningún artículo con el código XXXXX”.
Ejercicios sobre la base de datos creaBD_empresa.sql:
Esquema relacional de la base de datos empresa:
DEPART (dept_no, dnombre, loc)
EMPLE (emp_no, apellido, oficio, dir, fecha_alt, salario, comision, dept_no)
Clave ajenas: dir → EMPLE (emp_no)
dept_no → DEPART (dept_no)*/
delimiter //
drop procedure if exists mostrarDescripcion //
create procedure mostrarDescripcion(codigo varchar(20))
begin
	declare fallo bool;
    declare descripcion varchar(50);
        
    declare cursor1 cursor for
    select a.desart from articulo a where a.codart = codigo;
    
    declare continue handler for 1329 set fallo = 1;
    
    open cursor1;
    fetch cursor1 into descripcion;
    close cursor1;
    if fallo = 1 then
		select concat("No existe ningún artículo con el código: ", codigo) as 'Resultado';
	else
		select descripcion as 'Resultado';
	end if;
end //
-- Llamada al procedimiento
delimiter ;
call mostrarDescripcion('A0012');
call mostrarDescripcion('A0013'); -- Éste dará error :D 

/*8. Crea un procedimiento llamado cambiarJefe que cambie el director o jefe de un
empleado en la tabla emple de la base de datos Empresa.
Este procedimiento recibirá el apellido del empleado cuyo jefe se desea modificar y el
apellido de su nuevo empleado jefe.
En este procedimiento se pueden dar dos situaciones de error o excepciones (código 1329):
- Que no exista el empleado cuyo jefe se desea modificar.
- Que no exista el nuevo empleado jefe que se le quiere asignar.
Ejemplos de salida:
+-----------------------------------------+
| Mensaje |
+-----------------------------------------+
| El nuevo jefe de AAAA es BBBB |
+-----------------------------------------+
+--------------------------------------------------------------+
| Error jefe |
+--------------------------------------------------------------+
| No existe ningún empleado jefe apellidado CCCCC |
+--------------------------------------------------------------+
+----------------------------------------------------------+
| Error empleado |
+----------------------------------------------------------+
| No existe ningún empleado apellidado CCCCC |
+----------------------------- -------------------------------+*/
-- delimiter //
-- drop procedure if exists crearJefe //
-- create procedure crearJefe()