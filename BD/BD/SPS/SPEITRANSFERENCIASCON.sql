-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEITRANSFERENCIASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEITRANSFERENCIASCON`;DELIMITER $$

CREATE PROCEDURE `SPEITRANSFERENCIASCON`(
	Par_SpeiTransID 	bigint(20),
    Par_Estatus       	char(1),
	Par_CorresponsalID  int,
	Par_Referencia      varchar(40),
	Par_NumCon			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(20),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)
TerminaStore: BEGIN


DECLARE Var_Corresponsal  varchar(60);


DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Con_Principal	bigint;
DECLARE		Con_Estatus     bigint;
DECLARE		Con_EstatusPen  bigint;
DECLARE		EstatusPen      char(1);
DECLARE		Con_Corres      bigint;
DECLARE 	NumUno          int;
DECLARE 	IncorporateEx   varchar(60);
DECLARE 	NoDispon        varchar(60);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Estatus		:= 2;
Set	Con_EstatusPen	:= 3;
Set	EstatusPen		:= 'P';
Set Con_Corres      := 4;
Set NumUno          := 1;
Set IncorporateEx   := 'Incorporated Express';
Set NoDispon        := 'No Disponible';


if(Par_NumCon = Con_Principal) then
	select	ST.SpeiTransID, ST.ClabeCli, ST.NombreCli,ST.Monto,CA.CuentaAhoID,CL.ClienteID, CA.Estatus,
            CL.Estatus
	from SPEITRANSFERENCIAS ST inner join CUENTASAHO CA on CA.Clabe = ST.ClabeCli
		inner join CLIENTES CL on CL.ClienteID = CA.ClienteID
	where SpeiTransID = Par_SpeiTransID;
end if;


if(Par_NumCon = Con_Estatus) then
	select	SpeiTransID,NombreCli, ClabeCli, Monto, Estatus
	from SPEITRANSFERENCIAS
	where  SpeiTransID = Par_SpeiTransID and Estatus = Par_Estatus;
end if;

if(Par_NumCon = Con_EstatusPen) then
	select	SpeiTransID,NombreCli, ClabeCli, Monto
	from SPEITRANSFERENCIAS
	where Estatus = EstatusPen;
end if;


if(Par_CorresponsalID = NumUno)then

	Set Var_Corresponsal := IncorporateEx;
else
	Set Var_Corresponsal := NoDispon;
end if;


if(Par_NumCon = Con_Corres) then
	select	NombreCli, ClabeCli, Monto, Referencia, FechaProceso, Estatus, Transaccion
	from SPEITRANSFERENCIAS
	where  Corresponsal= Var_Corresponsal and Referencia like concat("%",Par_Referencia,"%");

end if;

END TerminaStore$$