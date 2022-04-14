-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTAARCHIVOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTAARCHIVOSBAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTAARCHIVOSBAJ`(
	Par_CuentaAhoID		bigint(12),
	Par_TipoDocumen		varchar(45),
	Par_ArchivCtaID		int(11),
	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN
DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;

Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

if(not exists(select CuentaAhoID
			from CUENTAARCHIVOS
			where CuentaAhoID = Par_CuentaAhoID)) then
	select '001' as NumErr,
		 'El Numero de Cuenta no existe.' as ErrMen,
		 'cuentaAhoID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;


delete from CUENTAARCHIVOS
where CuentaAhoID = Par_CuentaAhoID
and TipoDocumento = Par_TipoDocumen
and ArchivoCtaID = Par_ArchivCtaID;

select '000' as NumErr ,
	  'Archivo de Cuenta Eliminado' as ErrMen,
	  'cuentaAhoID' as control,
	  '0' as consecutivo;

END TerminaStore$$