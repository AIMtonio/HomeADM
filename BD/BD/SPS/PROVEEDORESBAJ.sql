-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROVEEDORESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROVEEDORESBAJ`;DELIMITER $$

CREATE PROCEDURE `PROVEEDORESBAJ`(
	Par_ProveedorID		int,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Var_ProveedorID	int;
DECLARE Var_NumeroFact	int;


DECLARE  Entero_Cero 	int;
DECLARE  Decimal_Cero	decimal(14,2);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Est_Baja		char(1);


set Var_ProveedorID	 := (select ProveedorID from PROVEEDORES where ProveedorID = Par_ProveedorID);
Set Aud_FechaActual	 := CURRENT_TIMESTAMP();
Set Var_NumeroFact	 := 0;


set Entero_Cero 		:=0;
Set Cadena_Vacia		:= '';
set Decimal_Cero		:=0.00;
set Est_Baja			:='B';


if(ifnull(Var_ProveedorID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		'El Proveedor especificado no existe.' as ErrMen,
		'proveedorID' as control,
		Cadena_Vacia as consecutivo;
	LEAVE TerminaStore;
end if;


Set Var_NumeroFact := (select count(FacturaProvID) from FACTURAPROV where ProveedorID = Par_ProveedorID);

if(ifnull(Var_NumeroFact, Entero_Cero))> Entero_Cero then
	select '002' as NumErr,
		concat('El Proveedor especificado no puede ser dado de Baja, cuenta con: ',
			Var_NumeroFact, ' factura(s) relacionadas') as ErrMen,
		'proveedorID' as control,
		Par_ProveedorID as consecutivo;
	LEAVE TerminaStore;
end if;


update PROVEEDORES set
	Estatus = Est_Baja
where ProveedorID = Par_ProveedorID;

select '000' as NumErr ,
	concat('Proveedor Eliminado: ',Par_ProveedorID ) as ErrMen,
	'proveedorID' as control,
	Cadena_Vacia as consecutivo;


END TerminaStore$$