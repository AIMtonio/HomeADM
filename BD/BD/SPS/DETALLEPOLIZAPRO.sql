-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPOLIZAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPOLIZAPRO`;DELIMITER $$

CREATE PROCEDURE `DETALLEPOLIZAPRO`(
	Par_Poliza			bigint,
	Par_Empresa			int,
	Par_Fecha			Date,
	Par_Cliente			int,
	Par_ConceptoOpera	int,
	Par_CuentaID		bigint,
	Par_Moneda			int,
	Par_Cargos			decimal(12,2),
	Par_Abonos			decimal(12,2),
	Par_Descripcion		varchar(100),
	Par_Referencia		varchar(50),

	Par_Salida          char(1),
	inout Par_NumErr	int,
	inout Par_ErrMen	varchar(100),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN

DECLARE SalidaSI char(1);



Set SalidaSI='S';

call POLIZAAHORROPRO(
		Par_Poliza,		Par_Empresa,	Par_Fecha, 			Par_Cliente,	Par_ConceptoOpera,
		Par_CuentaID,	Par_Moneda,		Par_Cargos,			Par_Abonos,		Par_Descripcion,
		Par_Referencia,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,
		Aud_Sucursal,	Aud_NumTransaccion);

if (Par_Salida=SalidaSI)then
	select 	'000' as NumErr,
		'Transaccion Realizada' as ErrMen,
		'cuentaAhoID' as control,
		Par_Poliza as consecutivo;
end if;
LEAVE TerminaStore;

END TerminaStore$$