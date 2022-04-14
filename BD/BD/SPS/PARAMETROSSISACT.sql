-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSISACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSISACT`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSSISACT`(
	Par_EmpresaID			int,
	Par_FechaSistema			date,
	Par_SucursalMatrizID		int,
	Par_TelefonoLocal		varchar(20),
	Par_TelefonoInterior		varchar(20),
	Par_InstitucionID		int,
	Par_NombreRepresentante	varchar(100),
	Par_RFCRepresentante		varchar(13),
	Par_MonedaBaseID			int,
	Par_TasaISR				float,
	Par_EjercicioVigente		int,
	Par_PeriodoVigente		int,
	Par_TipoAct				smallint,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Tip_Ejercicio		smallint;
DECLARE	Tip_Periodo		smallint;
DECLARE	Tip_Fecha		smallint;

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Tip_Ejercicio		:= 1;
Set	Tip_Periodo		:= 2;
Set	Tip_Fecha		:= 3;

if( Par_TipoAct = Tip_Ejercicio) then
	update PARAMETROSSIS set
		EjercicioVigente	= Par_EjercicioVigente,

		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion;
end if;

if( Par_TipoAct = Tip_Periodo) then
	update PARAMETROSSIS set
		PeriodoVigente	= Par_PeriodoVigente,

		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion;
end if;

if( Par_TipoAct = Tip_Fecha) then
	update PARAMETROSSIS set
		FechaSistema	= Par_FechaSistema,

		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion;
end if;

END TerminaStore$$