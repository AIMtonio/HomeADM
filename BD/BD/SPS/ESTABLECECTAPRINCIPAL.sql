-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTABLECECTAPRINCIPAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTABLECECTAPRINCIPAL`;DELIMITER $$

CREATE PROCEDURE `ESTABLECECTAPRINCIPAL`(
	)
TerminaStore: BEGIN

declare cuenta int;
declare totalCtes int;
declare contador int;


set contador:= 1;

Update CUENTASAHO SET
EsPrincipal ='';

set totalCtes := (select count(ClienteID) from CLIENTES);

WHILE Contador <= totalCtes DO

set cuenta := (select min(CuentaAhoID) from CUENTASAHO where  ClienteID=contador);

Update CUENTASAHO SET
EsPrincipal ='S'
Where CuentaAhoID =cuenta;
Set Contador = Contador + 1;

	END WHILE;


END TerminaStore$$