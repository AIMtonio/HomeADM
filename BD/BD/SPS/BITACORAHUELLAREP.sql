-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAHUELLAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAHUELLAREP`;DELIMITER $$

CREATE PROCEDURE `BITACORAHUELLAREP`(
/* SP DE REPORTE BITACORA HUELLA */
	Par_TipoReporte			INT(11), 	-- Numero de Reporte 1.- Cliente 2.-Usuario
	Par_FechaInicio			DATE,		-- Fecha de Incio para la busqueda de registros
    Par_FechaFin			DATE,		-- Fecha de Fin para la busqueda de registros
    /* Parametros Auditoria */
	Par_EmpresaID			INT(11),	-- Parametro Auditoria
	Aud_Usuario				INT(11),	-- Parametro Auditoria

	Aud_FechaActual			DATETIME,	-- Parametro Auditoria
	Aud_DireccionIP			VARCHAR(15),-- Parametro Auditoria
	Aud_ProgramaID			VARCHAR(50),-- Parametro Auditoria
	Aud_Sucursal			INT(11),	-- Parametro Auditoria
	Aud_NumTransaccion		BIGINT(20)	-- Parametro Auditoria
	)
TerminaStore: BEGIN

	DECLARE Fecha_Vacia 		DATE;
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE Con_ReporteCli		INT;
	DECLARE Con_ReporteUsr		INT;
	DECLARE Tipo_Cli			CHAR(1);
	DECLARE Tipo_Usr			CHAR(1);

	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Con_ReporteCli		:= 1;
	SET Con_ReporteUsr		:= 2;
	SET Tipo_Cli			:= 'C';
	SET Tipo_Usr			:= 'U';

	IF(Par_TipoReporte = Con_ReporteCli) THEN

		SELECT 	CT.NombreCompleto, 		BH.ClienteUsuario,		BH.TipoOperacion,		BH.DescriOperacion,		BH.CajaID,
				BH.SucursalOperacion,	SC.NombreSucurs,		BH.Fecha, 	DATE_FORMAT(BH.FechaActual,'%H:%i:%s') AS Hora
		FROM BITACORAHUELLA  BH, CLIENTES CT, SUCURSALES SC
		WHERE BH.TipoUsuario = Tipo_Cli
		AND BH.Fecha >= Par_FechaInicio
		AND BH.Fecha <= Par_FechaFin
		AND BH.ClienteUsuario = CT.ClienteID
		AND BH.SucursalOperacion = SC.SucursalID;

	END IF;

    IF(Par_TipoReporte = Con_ReporteUsr) THEN

		SELECT 	US.NombreCompleto, 		BH.ClienteUsuario,		BH.DescriOperacion,		BH.SucursalOperacion,	SC.NombreSucurs,
			BH.Fecha, 	DATE_FORMAT(BH.FechaActual,'%H:%i:%s') AS Hora
		FROM BITACORAHUELLA  BH, USUARIOS US, SUCURSALES SC
		WHERE BH.TipoUsuario = Tipo_Usr
		AND BH.Fecha >= Par_FechaInicio
		AND BH.Fecha <= Par_FechaFin
		AND BH.ClienteUsuario = US.UsuarioID
		AND BH.SucursalOperacion = SC.SucursalID;

	END IF;

END TerminaStore$$