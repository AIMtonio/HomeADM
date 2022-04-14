-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIALTORIESGOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIALTORIESGOREP`;DELIMITER $$

CREATE PROCEDURE `CLIALTORIESGOREP`(
	Par_SucursalID 			INT(11),
	Par_TipoRep				INT(11),
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
-- Declaración de constantes --
DECLARE EstatusActivo	CHAR(1);
DECLARE RiesgoAlto		CHAR(1);
DECLARE	MenorEdadNo		CHAR(1);
DECLARE Cadena_SI		CHAR(1);
DECLARE Fecha_Vacia		DATE;
DECLARE Entero_cero		INT(11);

-- Declaración de Variables --
DECLARE Var_Sentencia	VARCHAR(30000);

-- Asignación de constantes --
SET EstatusActivo 	:= 'A'; 		-- Estatus Activo del cliente--
SET RiesgoAlto 		:= 'A'; 		-- Cliente de Riesgo Alto --
SET MenorEdadNo 	:= 'N'; 		-- Cliente No es menor de edad --
SET Cadena_SI 		:= 'S';			-- Valor S --
SET Fecha_Vacia 	:= '1900-01-01';-- Fecha vacia --
SET Entero_Cero		:=0;			-- valor Cero --
SET Var_Sentencia	:='select 	cli.ClienteID, cli.NombreCompleto, 	cli.SucursalOrigen as SucursalID, 	cli.FechaAlta, 		dir.DireccionCompleta, ';
SET Var_Sentencia	:= CONCAT(Var_sentencia,'ocu.Descripcion as OcupacionCli, 	act.Descripcion as ActividadBMX,	substring(now(),12) as HoraEmision, NombreSucurs
						from CLIENTES  cli
						left join DIRECCLIENTE dir on cli.ClienteID = dir.ClienteID and dir.Oficial = "',Cadena_SI,'"
						left join SUCURSALES suc on cli.SucursalOrigen = suc.SucursalID
						left join OCUPACIONES ocu on cli.OcupacionID = ocu.OcupacionID
						left join ACTIVIDADESBMX act on cli.ActividadBancoMX =  act.ActividadBMXID ');
SET Var_Sentencia	:= CONCAT(Var_sentencia,'where cli.NivelRiesgo = "',RiesgoAlto,'"'
							' and cli.Estatus = "',EstatusActivo,'"'
							' and cli.EsMenorEdad = "',MenorEdadNo,'"');

IF(Par_SucursalID > Entero_Cero)THEN
	SET Var_Sentencia	:= CONCAT(Var_sentencia,'and cli.SucursalOrigen = ',Par_SucursalID );
END IF;

	SET @Sentencia	= (Var_Sentencia);

	PREPARE SPCTEALTORIESGO FROM @Sentencia;
	EXECUTE SPCTEALTORIESGO  ;
	DEALLOCATE PREPARE SPCTEALTORIESGO;

END TerminaStore$$