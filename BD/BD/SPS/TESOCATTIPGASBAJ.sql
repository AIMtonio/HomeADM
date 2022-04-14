-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOCATTIPGASBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOCATTIPGASBAJ`;DELIMITER $$

CREATE PROCEDURE `TESOCATTIPGASBAJ`(
	Par_TipoGastoID		int,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE	Entero_Cero			int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE	Cadena_Vacia		char(1);
DECLARE	tipoGasto			int;

set Entero_Cero 	:=0;
Set Cadena_Vacia	:= '';
set Decimal_Cero 	:=0.00;
set tipoGasto 		:= (select TipoGastoID  from TESOCATTIPGAS where TipoGastoID=Par_TipoGastoID);

if(ifnull(Par_TipoGastoID,Entero_Cero)) = Entero_Cero then
	select '001' as NumErr,
		 'El Tipo de Gasto esta vacio.' as ErrMen,
		 'tipoGastoID' as control;
	LEAVE TerminaStore;
end if;


if exists(select P.Concepto
			from PRESUCURDET P,
				TESOCATTIPGAS TG
			where P.Concepto  = TG.TipoGastoID and P.Concepto= Par_TipoGastoID) then
	select '002' as NumErr,
			concat('El tipo de gasto: ',cast(Par_TipoGastoID  as char),'  es usado actualmente. ') as ErrMen,
			'tipoGastoID' as control;
        LEAVE TerminaStore;
end if;

if exists(select RG.TipoGastoID
			from REQGASTOSUCURMOV RG,
				TESOCATTIPGAS TG
			where RG.TipoGastoID  = TG.TipoGastoID and RG.TipoGastoID= Par_TipoGastoID) then
	select '003' as NumErr,
			concat('El tipo de gasto: ',cast(Par_TipoGastoID  as char),'  es usado actualmente. ') as ErrMen,
			'tipoGastoID' as control;
        LEAVE TerminaStore;
end if;



Set Aud_FechaActual := CURRENT_TIMESTAMP();

delete from  TESOCATTIPGAS
where TipoGastoID = Par_TipoGastoID;



select '000' as NumErr ,
		  concat('Tipo de Gasto Eliminado.',convert(tipoGasto, CHAR))as ErrMen,
		  'tipoGastoID' as control;

END TerminaStore$$