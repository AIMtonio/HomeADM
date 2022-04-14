-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEUSUARIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEUSUARIOSCON`;DELIMITER $$

CREATE PROCEDURE `BEUSUARIOSCON`(
	 Par_ClienteID	int,

    Aud_EmpresaID       	int,
    Aud_Usuario         	int,
    Aud_FechaActual     	datetime,
    Aud_DireccionIP     	varchar(20),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint(20)
	)
TerminaStore: BEGIN


DECLARE Var_ClienteID       int;
DECLARE	NumErr		      int(11);
DECLARE	ErrMen		      varchar(40);


DECLARE  Entero_Cero	  int;
DECLARE	Cadena_Vacia		char(1);




Set Entero_Cero     := 0;
Set	Cadena_Vacia		:= '';
Set Aud_FechaActual	:= now();

Set Var_ClienteID:= (select ClienteID from CLIENTES where ClienteID = Par_ClienteID);
    if(ifnull(Var_ClienteID, Entero_Cero))= Entero_Cero then
		set 	NumErr := '001';
		set 	ErrMen := 'El numero de Cliente no existe.';
            select 	Entero_Cero as ClienteID, Cadena_Vacia as NombreCompleto,	Cadena_Vacia as RFCOficial,
                      Cadena_Vacia as Clave, NumErr, ErrMen;
	else
		set 	NumErr := '000';
		set 	ErrMen := 'Consulta Exitosa';
        select  us.ClienteID,  cli.NombreCompleto,  cli.RFCOficial,    us.Clave,    NumErr,
                ErrMen
        from BEUSUARIOS us inner join CLIENTES cli on us.ClienteID=cli.ClienteID
        where us.ClienteID=Par_ClienteID;

    end if;

END TerminaStore$$