-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSANTGASTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSANTGASTOSCON`;DELIMITER $$

CREATE PROCEDURE `TIPOSANTGASTOSCON`(
	Par_TipoAntGastoID		int(11),
	Par_NumCon				tinyint unsigned,
	Par_EmpresaID			int,

	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int(11);
DECLARE	Con_Principal		int(11);
DECLARE	Con_Foranea			int(11);
DECLARE Con_NatSalidaEfect	int(11);
DECLARE ReqEmpleado			char(1);

Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
Set	Con_Principal			:= 1;
Set	Con_Foranea				:= 2;
Set Con_NatSalidaEfect		:= 3;
Set ReqEmpleado				:='S';
if(Par_NumCon = Con_Principal) then
	select	TipoAntGastoID,	Descripcion,	Naturaleza,		Estatus,	EsGastoTeso,
			TipoGastoID,	ReqNoEmp,		CtaContable,	CentroCosto,Instrumento,
			FORMAT(MontoMaxEfect,2)AS MontoMaxEfect,	FORMAT(MontoMaxTrans,2)AS MontoMaxTrans
		from TIPOSANTGASTOS
			where TipoAntGastoID = Par_TipoAntGastoID;
end if;

if(Par_NumCon = Con_NatSalidaEfect) then
	select	TipoAntGastoID,	Descripcion,	Naturaleza,		Estatus,	EsGastoTeso,
			TipoGastoID,	ReqNoEmp,		CtaContable,	CentroCosto,Instrumento,
			MontoMaxEfect,	MontoMaxTrans
		from TIPOSANTGASTOS
			where TipoAntGastoID = Par_TipoAntGastoID
			 and Naturaleza=ReqEmpleado;
end if;




END TerminaStore$$