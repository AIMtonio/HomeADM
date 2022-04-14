-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESWSCON`;DELIMITER $$

CREATE PROCEDURE `CLIENTESWSCON`(
	Par_ClienteID		int,
	Par_InstitNominaID	int,
   Par_NegocioAfiliadoID int,
	Par_NumCon			tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Var_NomCliente  varchar(40);
DECLARE	NumErr		      int(11);
DECLARE	ErrMen		      varchar(40);


DECLARE  Entero_Cero	int;
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE Con_Principal	int;
DECLARE Con_NombreCliIN  	int;
DECLARE Con_NombreCliNA  	int;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Fecha_Vacia			:= '1900-01-01';
Set	Con_Principal		:= 1;
Set   Con_NombreCliIN  	:= 2;
Set   Con_NombreCliNA  	:= 3;
Set   Aud_FechaActual	:= now();



if(Par_NumCon = Con_NombreCliIN) then
Set Var_NomCliente:= (select  NombreCompleto
        from CLIENTES Cli
        inner join NOMINAEMPLEADOS Ne
        on Ne.ClienteID= Cli.ClienteID
        where Cli.ClienteID = Par_ClienteID
        and Ne.InstitNominaID  =  Par_InstitNominaID);
    if(ifnull(Var_NomCliente, Cadena_Vacia))= Cadena_Vacia then
		set 	NumErr := '001';
		set 	ErrMen := 'El Cliente no Existe.';
      select Var_NomCliente as NombreCompleto,NumErr,ErrMen;
    else
      set 	NumErr := '000';
		set 	ErrMen := 'Consulta Exitosa';
      select Var_NomCliente as NombreCompleto,NumErr,ErrMen;
    end if;
end if;


if(Par_NumCon = Con_NombreCliNA) then
Set Var_NomCliente:= (select  NombreCompleto
        from CLIENTES Cli
        inner join NEGAFILICLIENTE Neg
        on Neg.ClienteID= Cli.ClienteID
        where Cli.ClienteID = Par_ClienteID
        and Neg.NegocioAfiliadoID=Par_NegocioAfiliadoID);
    if(ifnull(Var_NomCliente, Cadena_Vacia))= Cadena_Vacia then
		set 	NumErr := '001';
		set 	ErrMen := 'El Cliente no Existe.';
      select Var_NomCliente as NombreCompleto,NumErr,ErrMen;
    else
      set 	NumErr := '000';
		set 	ErrMen := 'Consulta Exitosa';
      select Var_NomCliente as NombreCompleto,NumErr,ErrMen;
    end if;
end if;

END TerminaStore$$