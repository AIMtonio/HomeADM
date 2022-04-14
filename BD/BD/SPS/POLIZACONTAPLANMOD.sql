-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACONTAPLANMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACONTAPLANMOD`;DELIMITER $$

CREATE PROCEDURE `POLIZACONTAPLANMOD`(
     Par_PolizaID int,
     Par_Descripcion	varchar(150),
     Par_Empresa	int,
     Par_Fecha	Date,
     Par_Tipo	  char(1),
     Par_ConceptoID	int(11),
     Par_Concepto	varchar(150),


	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

DECLARE	v_Cadena_Vacia	char(1);
DECLARE	v_Fecha_Vacia	date;
DECLARE	v_Entero_Cero	int;
DECLARE	v_Observacion	varchar(200);


Set	v_Cadena_Vacia	:= '';
Set	v_Fecha_Vacia	:= '1900-01-01';
Set	v_Entero_Cero	:= 0;
Set	v_Observacion 	:= 'Sin Observacion';

Set Aud_FechaActual := CURRENT_TIMESTAMP();
update POLIZACONTAPLAN set
		PolizaID = Par_PolizaID,
         Descripcion= Par_Descripcion,
         EmpresaID=Par_Empresa,
         Fecha=Par_Fecha,
         Tipo=Par_Tipo,
         ConceptoID=Par_ConceptoID,
         Concepto=Par_Concepto,

		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
where PolizaID = Par_PolizaID;

select '000' as NumErr ,
	  'La Poliza Contable Plantilla Modificado' as ErrMen,
	  'numero' as control,
	  Par_PolizaID as consecutivo;
END TerminaStore$$