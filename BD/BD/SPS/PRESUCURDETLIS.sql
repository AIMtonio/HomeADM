-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURDETLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUCURDETLIS`;DELIMITER $$

CREATE PROCEDURE `PRESUCURDETLIS`(
     Par_Nombre			varchar(20),
     Par_SucursalID		int,
     Par_NumLis			tinyint unsigned,

     Aud_EmpresaID		int,
 	 Aud_Usuario		int,
	 Aud_FechaActual	DateTime,
     Aud_DireccionIP	varchar(15),
	 Aud_ProgramaID		varchar(50),
	 Aud_Sucursal		int,
	 Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE  	Var_Solicitado  char(1);
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal 	int;
DECLARE	Lis_Combo	 	int;

Set		Cadena_Vacia	:= '';
Set  	Var_Solicitado 	:= 'S';
Set		Entero_Cero		:= 0;
Set		Lis_Principal	:= 1;
Set 	Lis_Combo       := 2;

if(Par_NumLis = Lis_Combo) then


select det.FolioID,		det.Monto,		det.Descripcion
  from PRESUCURENC enc,PRESUCURDET det,TESOCATTIPGAS tgas
        where enc.FolioID=det.EncabezadoID and det.Concepto=tgas.TipoGastoID
        and enc.SucursalOrigen=Par_SucursalID and  det.Concepto= Par_Nombre
        and det.Estatus=Var_Solicitado
        limit 0, 15;
end if;
END$$