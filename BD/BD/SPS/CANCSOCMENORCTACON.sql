-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCSOCMENORCTACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCSOCMENORCTACON`;DELIMITER $$

CREATE PROCEDURE `CANCSOCMENORCTACON`(
    Par_ClienteID       int(11),
    Par_NumCon          tinyint unsigned,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     dateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
		)
TerminaStore: BEGIN

-- Declaracion de Variables
declare Var_FechaCorte  date;
declare Var_FechaSug 	date;
declare Var_ClienteID	int(11);
declare Var_CuentaAhoID	bigint(12);
declare Var_Descripcion	varchar(50);
-- Declaracion de Constantes
declare Fecha_Vacia		date;
declare Entero_Cero		int(11);
declare Con_Principal	int(11);
declare Cadena_Vacia	char(1);
declare Con_Foranea		int(11);
declare Con_CtaPrincipal int(11);

-- Asignacion de Constantes
set Cadena_Vacia	:='';
set Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
set Entero_Cero     := 0;
set Con_Principal   := 1;
set Con_Foranea		:= 2;
set Con_CtaPrincipal:= 3;
-- Consulta que Devuelve la Ultima Fecha de Calificacion y Reserva
if(Par_NumCon = Con_Principal) then
	select distinct ClienteID,	MIN(CuentaAhoID),	format(sum(SaldoAhorro),2)as SaldoAhorro,
			MIN(EstatusCta),	MIN(FechaCancela),	MIN(Aplicado),				MIN(FechaRetiro)
		from CANCSOCMENORCTA
			where ClienteID=Par_ClienteID;

end if;

-- Consulta que devuelve la cuenta principal del cliente
if(Par_NumCon = Con_CtaPrincipal) then

	select  Cta.ClienteID,Cue.CuentaAhoID,Tip.Descripcion
		into Var_ClienteID,Var_CuentaAhoID,Var_Descripcion
		from CANCSOCMENORCTA Cta
		inner join CUENTASAHO Cue on Cue.CuentaAhoID=Cta.CuentaAhoID and EsPrincipal="S"
		inner join TIPOSCUENTAS Tip on Tip.TipoCuentaID=Cue.TipoCuentaID
		where Cta.ClienteID=Par_ClienteID;

	set Var_CuentaAhoID:= ifnull(Var_CuentaAhoID,Entero_Cero);

	if Var_CuentaAhoID=Entero_Cero then
		select  Cta.ClienteID,Cue.CuentaAhoID,Tip.Descripcion
			into Var_ClienteID,Var_CuentaAhoID,Var_Descripcion
			from CANCSOCMENORCTA Cta
			inner join CUENTASAHO Cue on Cue.CuentaAhoID=Cta.CuentaAhoID
			inner join TIPOSCUENTAS Tip on Tip.TipoCuentaID=Cue.TipoCuentaID
			where Cta.ClienteID=Par_ClienteID limit 1;
	end if;

	select Var_ClienteID,Var_CuentaAhoID,Var_Descripcion;

end if;


END TerminaStore$$