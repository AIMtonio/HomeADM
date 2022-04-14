-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAPACIDADPAGOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAPACIDADPAGOREP`;DELIMITER $$

CREATE PROCEDURE `CAPACIDADPAGOREP`(




	Par_FechaInicio			date,
	Par_FechaFin			date,
	Par_ClienteID			int(11),
	Par_SucursalID			int(11),

	Par_NumRep			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia		char(1);
	DECLARE	Fecha_Vacia			date;
	DECLARE	Entero_Cero			int;
	DECLARE	Rep_Principal		int;





DECLARE Var_Sentencia	varchar(9000);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Rep_Principal		:= 1;

if(Par_NumRep = Rep_Principal) then

	set Var_Sentencia :=  'select His.ClienteID, Cli.NombreCompleto AS NombreCliente, His.SucursalID, Suc.NombreSucurs,  His.fecha, His.IngresoMensual, His.GastoMensual, His.MontoSolicitado, His.AbonoPropuesto,
								  His.ProducCredito1, His.ProducCredito2, His.ProducCredito3, ';
	set Var_Sentencia :=CONCAT(Var_Sentencia ,'concat("$",His.AbonoEstimado) AS AbonoEstimado,');
	set Var_Sentencia :=CONCAT(Var_Sentencia ,' His.IngresosGastos, His.Cobertura, His.CobsinPrestamo, His.CobConPrestamo, Usu.NombreCompleto AS NombreUsuario,
								  Usu.UsuarioID, Pro1.Descripcion AS DescripcionPC1, Pro2.Descripcion AS DescripcionPC2, Pro3.Descripcion AS DescripcionPC3');

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' from HISCAPACIDADPAGO His,
												 CLIENTES Cli,
												 SUCURSALES Suc,
												 USUARIOS Usu,
												 PRODUCTOSCREDITO Pro1,
												 PRODUCTOSCREDITO Pro2,
												 PRODUCTOSCREDITO Pro3');

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' where	His.Fecha	>=	?');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' and	His.Fecha	<=	?');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' and His.ClienteID = Cli.ClienteID
												 and His.SucursalID = Suc.SucursalID
												 and His.UsuarioID=Usu.UsuarioID
												 and Pro1.ProducCreditoID = His.ProducCredito1
												 and Pro2.ProducCreditoID = His.ProducCredito2
												 and Pro3.ProducCreditoID = His.ProducCredito3');

	if(ifnull(Par_ClienteID,Entero_Cero) != Entero_Cero)then
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' and His.ClienteID = ', Par_ClienteID);
    end if;
	if(ifnull(Par_SucursalID,Entero_Cero) > Entero_Cero)then
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' and His.SucursalID = ', Par_SucursalID);
    end if;

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by His.SucursalID, His.Fecha, Usu.UsuarioID, Cli.ClienteID;');

	set @Sentencia	= (Var_Sentencia);

	SET @FechaIni	= Par_FechaInicio;
	SET @FechaFin	= Par_FechaFin;
	PREPARE STCAPACIDADPAGOREP FROM @Sentencia;
	EXECUTE STCAPACIDADPAGOREP USING @FechaIni, @FechaFin;

	DEALLOCATE PREPARE STCAPACIDADPAGOREP;

end if;



END TerminaStore$$