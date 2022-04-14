-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMOD`;DELIMITER $$

CREATE PROCEDURE `DISPERSIONMOD`(

	Par_FolioOperacion   int(11),
	Par_FechaOperacion   datetime,
	Par_InstitucionID    int(11),
	Par_CuentaAhoID      bigint(12),
	Par_CantRegistros    int(11),
	Par_CantEnviados     int(11),
	Par_MontoTotal       decimal(12,2),
	Par_MontoEnviado     decimal(12,4),
	Par_Estatus          varchar(2),

	Aud_EmpresaID        int(11),
	Aud_Usuario          int(11),
	Aud_FechaActual      datetime,
	Aud_DireccionIP      varchar(20),
	Aud_ProgramaID       varchar(50),
	Aud_Sucursal         int(11),
	Aud_NumTransaccion   bigint(20)

				)
TerminaStore: BEGIN

	DECLARE	Cadena_Vacia	char(1);
	DECLARE	Entero_Cero		int;


	Set	Cadena_Vacia	:= '';
	Set	Entero_Cero		:= 0;


	if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
		select '001' as NumErr,
			 'El numero de Cuenta esta vacio.' as ErrMen,
			 'cuentaAhoID' as control;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_InstitucionID, Entero_Cero))= Entero_Cero then
		select '003' as NumErr,
			 'El numero de institucion esta vacio.' as ErrMen,
			 'institucionID' as control;
		LEAVE TerminaStore;
	end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

update DISPERSION set

       FechaOperacion=Par_FechaOperacion,      InstitucionID=Par_InstitucionID,
       CuentaAhoID=Par_CuentaAhoID,           CantRegistros=Par_CantRegistros,        CantEnviados=Par_CantEnviados,
	   MontoTotal=Par_MontoTotal,             MontoEnviado=Par_MontoEnviado,          Estatus=Par_Estatus,

       EmpresaID=Aud_EmpresaID,               Usuario=Aud_Usuario,                    FechaActual=Aud_FechaActual,
	   DireccionIP=Aud_DireccionIP,           ProgramaID=Aud_ProgramaID,              Sucursal=Aud_Sucursal,
	   NumTransaccion=Aud_NumTransaccion

where FolioOperacion=Par_FolioOperacion;

select '000' as NumErr,
	concat("Dispersion Autorizada Modificada: ",
	convert(Par_FolioOperacion, CHAR))  as ErrMen,
	'cuentaAhoID' as control,
	Par_FolioOperacion as consecutivo;

END TerminaStore$$