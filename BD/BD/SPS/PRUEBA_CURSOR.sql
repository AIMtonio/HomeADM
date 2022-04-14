-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRUEBA_CURSOR
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRUEBA_CURSOR`;DELIMITER $$

CREATE PROCEDURE `PRUEBA_CURSOR`(	)
BEGIN

Declare Var_Clave int;
Declare Var_Nombre varchar(100);

DECLARE  Cur1  CURSOR FOR
 	Select ClienteID, PrimerNombre From CLIENTES;

Create Temporary Table TMPCLIENTES(Clave int, Nombre varchar(100));




Open  Cur1;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	Loop
		Fetch Cur1  Into Var_Clave, Var_Nombre;

		insert into TMPCLIENTES values (Var_Clave, Var_Nombre);
	End Loop;
END;
Close Cur1;


select
Right (concat("00000000", convert(Clave, char(8))), 8)    as Clave,
Nombre
 from TMPCLIENTES;

Drop Table TMPCLIENTES;


END$$