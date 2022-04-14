-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURDETALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUCURDETALT`;DELIMITER $$

CREATE PROCEDURE `PRESUCURDETALT`(
	Par_EncabezadoID		int(11),
	Par_Concepto			int(11),
	Par_Descripcion			varchar(250),
	Par_Estatus				char(1),
	Par_Monto				decimal(18,2),
	Par_Observaciones		varchar(250),

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore: BEGIN

DECLARE		Var_Folio		int;
DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Esta_Auto		char(1);
DECLARE		Esta_Soli		char(1);
DECLARE		Esta_Cancel		char(1);
DECLARE		Var_Monto		decimal(18,2);
DECLARE 		Var_MontoDispon	decimal(13,2);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero 	:= 0;
Set Esta_Auto		:="A";
Set Esta_Soli		:= "S";
Set Esta_Cancel		:= "C";


if(ifnull(Par_EncabezadoID, Entero_Cero) = Entero_Cero) then
		select	'001'	as NumErr,
				'El folio esta vacio' as ErrMen,
				'folio' as control,
				'1' as consecutivo;
				LEAVE TerminaStore;
end if;

if(ifnull(Par_Concepto, Cadena_Vacia) =  Cadena_Vacia) then
		select 	'002'	as NumErr,
				'El concepto esta vacio' as ErrMen,
				'concepto'	as control,
				'2' as consecutivo;
		LEAVE TerminaStore;
end if;

if(ifnull(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia) then
		Set Par_Descripcion := Cadena_Vacia;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

Set Var_Folio = (select ifnull(MAX(FolioID), Entero_Cero) + 1 from PRESUCURDET);


Set Var_MontoDispon:=Par_Monto;


  insert into  PRESUCURDET (
			FolioID,		EncabezadoID,		Concepto,			Descripcion,	Estatus,
			Monto,			MontoDispon,		Observaciones,		EmpresaID,		Usuario,
			FechaActual,	DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
			)
  values	(
			Var_Folio,		Par_EncabezadoID, 	Par_Concepto,		Par_Descripcion,Par_Estatus,
			Par_Monto,		Var_MontoDispon,	Par_Observaciones,	Aud_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion );

					select	'000' as NumErr,
					'Se Agrego exitosamente' as ErrMen,
					'folio'	as control,
					Var_Folio as consecutivo;

END TerminaStore$$