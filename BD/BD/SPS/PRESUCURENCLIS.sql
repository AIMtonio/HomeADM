-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURENCLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUCURENCLIS`;DELIMITER $$

CREATE PROCEDURE `PRESUCURENCLIS`(

     Par_NombreSucur	varchar(20),
     Par_Fecha       	date,
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
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal 	int;
DECLARE    Var_Solicitado 	char(1);

Set	Cadena_Vacia	:= '';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set Var_Solicitado	:= 'S';

if(Par_NumLis = Lis_Principal) then

	select distinct
		   Enc.FolioID, 		 Enc.SucursalOrigen,		Suc.NombreSucurs,
		   Enc.UsuarioElaboro, 	 Usu.NombreCompleto
	from   PRESUCURENC Enc, USUARIOS Usu, SUCURSALES Suc,PRESUCURDET Det
	where  Enc.SucursalOrigen  = Suc.SucursalID 	 and
		   Enc.UsuarioElaboro  = Usu.UsuarioID 		 and
	       Enc.MesPresupuesto  = MONTH(Par_Fecha) 	 and
	       Enc.AnioPresupuesto = YEAR (Par_Fecha)   and
	       Det.Estatus		   = Var_Solicitado	     and
		   Det.EncabezadoID	   = Enc.FolioID         and
	Suc.NombreSucurs like CONCAT('%', Par_NombreSucur, '%')
         limit 0, 15;

end if;
END$$