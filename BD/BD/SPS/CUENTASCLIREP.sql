-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASCLIREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASCLIREP`;DELIMITER $$

CREATE PROCEDURE `CUENTASCLIREP`(
	Par_ClienteID		int,
	Par_NumRep			tinyint unsigned
	)
TerminaStore: BEGIN




DECLARE Rep_CueCli	int;

Set Rep_CueCli	:= 1;

if(Par_NumRep = Rep_CueCli) then

	Select  LPAD(convert(CU.CuentaAhoID, CHAR),11,'0') as Cuenta,
		  CU.FechaApertura, CU.Etiqueta, CU.Estatus,
		  LPAD(convert(TC.TipoCuentaID, CHAR),3,'0') as TipoCuenta,
		  TC.Descripcion as DescCuenta,
		  LPAD(convert(MO.MonedaId, CHAR),3,'0') as Moneda,
		  MO.DescriCorta as DescMoneda,
		  LPAD(convert(SU.SucursalID, CHAR),3,'0') as Sucursal,
		  SU.NombreSucurs
	from  CLIENTES CL,
		CUENTASAHO CU,
		TIPOSCUENTAS TC,
		MONEDAS MO,
		SUCURSALES SU
	where	CL.ClienteID	= Par_ClienteID
	and	CU.ClienteID   	= CL.ClienteID
	and	CU.TipoCuentaID	= TC.TipoCuentaID
	and	CU.MonedaID		= MO.MonedaId
	and	CU.SucursalID	= SU.SucursalID
	order by CU.CuentaAhoID;

end if;



END TerminaStore$$