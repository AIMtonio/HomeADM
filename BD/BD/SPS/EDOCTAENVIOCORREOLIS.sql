-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAENVIOCORREOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAENVIOCORREOLIS`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAENVIOCORREOLIS`(
	-- SP para listar los registros de la tabla EDOCTAENVIOCORREO
	Par_AnioMes 		INT(11),			-- Periodo de los estados de cuenta
	Par_SucursalID		INT(11),			-- Numero de sucursal
	Par_ClienteID		BIGINT(20),			-- Numero de cliente
	Par_Descripcion		VARCHAR(6),			-- Descripcion para la lista de periodos
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

	Par_EmpresaID		INT(11),			-- Parametros de Auditoria
	Aud_Usuario			INT(11),			-- Parametros de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal		INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametros de Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Descripcion		VARCHAR(20);

	-- Declaracion de constantes
	DECLARE Est_NoEnviado		CHAR(1);			-- Estatus no enviado N
	DECLARE Lis_Principal		TINYINT UNSIGNED;	-- Lista principal
	DECLARE Lis_NoEnviadosOrd1	TINYINT UNSIGNED;	-- Lista de registros de un Periodo (AnioMes) sin importar el Estatus Ordenado por Periodo, Sucursal y Cliente
	DECLARE Lis_NoEnviadosOrd2	TINYINT UNSIGNED;	-- Lista de registros de un Periodo (AnioMes) con Estatus no enviado Ordenado por Periodo, Sucursal y Cliente
	DECLARE Lis_NoEnviadosCte	TINYINT UNSIGNED;	-- Lista registros de un cliente, de un Periodo (AnioMes)con Estatus no enviado Ordenado por Periodo
	DECLARE Lis_Periodos		TINYINT UNSIGNED;	-- Lista de periodos
	DECLARE listaEdoCtas		TINYINT UNSIGNED;	-- Lista de de Estados de Cta ya generados

	-- Asignacion de constantes
	SET Est_NoEnviado			:= 'N';				-- Estatus de Correo de Estado de Cuenta no Enviado
	SET Lis_Principal			:= 1;				-- Lista de registros de un Periodo (AnioMes) sin importar el Estatus, Ordenado por Periodo, Sucursal y Cliente
	SET Lis_NoEnviadosOrd1		:= 2;				-- Lista de registros de un Periodo (AnioMes)con Estatus no enviado, Ordenado por Periodo, Sucursal y Cliente
	SET Lis_NoEnviadosOrd2		:= 3;				-- Lista de registros de un Periodo (AnioMes)con Estatus no enviado, Ordenado por Periodo y Cliente
	SET Lis_NoEnviadosCte		:= 4;				-- Lista de los registros de un cliente con Estatus no enviado, Ordenado por Periodo
	SET Lis_Periodos			:= 5;				-- Lista de periodos
	SET listaEdoCtas			:= 6;				-- Lista de de Estados de Cta ya generados

	/*	Consulta todos los registros de envio de correo de un Periodo (AnioMes) sin importar el Estatus
		Ordenado por Periodo, Sucursal y Cliente */
	IF (Par_NumLis = Lis_Principal) THEN
		SELECT	AnioMes,		ClienteID,	SucursalID,	CorreoEnvio,	EstatusEdoCta,
				EstatusEnvio,	FechaEnvio,	PDFGenerado
			FROM EDOCTAENVIOCORREO
			WHERE	AnioMes = Par_AnioMes
			ORDER BY AnioMes DESC, SucursalID, ClienteID;
	END IF;

	/*	Consulta todos los registros de envio de correo de un Periodo (AnioMes)con Estatus no enviado
		Ordenado por Periodo, Sucursal y Cliente */
	IF (Par_NumLis = Lis_NoEnviadosOrd1) THEN
		SELECT	envio.AnioMes,			envio.ClienteID,	envio.SucursalID,	envio.CorreoEnvio,	envio.EstatusEdoCta,
				datoscte.NombreComple,
				CONVERT(CONCAT(params.RutaExpPDF, params.PrefijoEmpresa, '/', envio.AnioMes, '/', RIGHT(CONCAT('000', CAST(envio.SucursalID AS CHAR)), 3), '/', RIGHT(CONCAT('0000000000', CAST(envio.ClienteID AS CHAR)), 10), '-', envio.AnioMes, '.pdf'), CHAR) AS RutaPDF,
				CONVERT(CONCAT(params.RutaExpPDF, 'XML/', params.PrefijoEmpresa, '/', envio.AnioMes, '/', RIGHT(CONCAT('000', CAST(envio.SucursalID AS CHAR)), 3), '/', RIGHT(CONCAT('0000000000', CAST(envio.ClienteID AS CHAR)), 10), '-', '1', '-', envio.AnioMes, '.xml'), CHAR) AS RutaXML
			FROM EDOCTAENVIOCORREO AS envio
			INNER JOIN EDOCTAPARAMS AS params
			INNER JOIN EDOCTADATOSCTE AS datoscte ON envio.SucursalID = datoscte.SucursalID AND envio.ClienteID = datoscte.ClienteID
			WHERE	envio.AnioMes = Par_AnioMes
			  AND	envio.EstatusEnvio = Est_NoEnviado
			ORDER BY envio.AnioMes DESC, ClienteID;
	END IF;

	/*	Consulta todos los registros de envio de correo de un Periodo (AnioMes)con Estatus no enviado
		Ordenado por Periodo y Cliente */
	IF (Par_NumLis = Lis_NoEnviadosOrd2) THEN
		SELECT	AnioMes,	ClienteID,	SucursalID,	CorreoEnvio,	EstatusEdoCta
			FROM EDOCTAENVIOCORREO
			WHERE	AnioMes = Par_AnioMes
			  AND	EstatusEnvio = Est_NoEnviado
			ORDER BY AnioMes DESC, ClienteID;
	END IF;

	/*	Consulta todos los registros de envio de correo, para un cliente, de un Periodo (AnioMes)con Estatus no enviado
		Ordenado por Periodo */
	IF (Par_NumLis = Lis_NoEnviadosCte) THEN
		SELECT	envio.AnioMes,			envio.ClienteID,	envio.SucursalID,	envio.CorreoEnvio,	envio.EstatusEdoCta,
				datoscte.NombreComple,
				CONVERT(CONCAT(params.RutaExpPDF, params.PrefijoEmpresa, '/', envio.AnioMes, '/', RIGHT(CONCAT('000', CAST(envio.SucursalID AS CHAR)), 3), '/', RIGHT(CONCAT('0000000000', CAST(envio.ClienteID AS CHAR)), 10), '-', envio.AnioMes, '.pdf'), CHAR) AS RutaPDF,
				CONVERT(CONCAT(params.RutaExpPDF, 'XML/', params.PrefijoEmpresa, '/', envio.AnioMes, '/', RIGHT(CONCAT('000', CAST(envio.SucursalID AS CHAR)), 3), '/', RIGHT(CONCAT('0000000000', CAST(envio.ClienteID AS CHAR)), 10), '-', '1', '-', envio.AnioMes, '.xml'), CHAR) AS RutaXML
			FROM EDOCTAENVIOCORREO AS envio
			INNER JOIN EDOCTAPARAMS AS params
			INNER JOIN EDOCTADATOSCTE AS datoscte ON envio.SucursalID = datoscte.SucursalID AND envio.ClienteID = datoscte.ClienteID
			WHERE	envio.ClienteID = Par_ClienteID
			  AND	envio.EstatusEnvio = Est_NoEnviado
			ORDER BY envio.AnioMes DESC;
	END IF;

	-- Lista de periodos de la tabla EDOCTAENVIOCORREO
	IF (Par_NumLis = Lis_Periodos) THEN
		SET Var_Descripcion := CONCAT('%', Par_Descripcion, '%');
		SELECT DISTINCT(AnioMes) AS AnioMes
			FROM EDOCTAENVIOCORREO
			WHERE	CAST(AnioMes AS CHAR(10)) LIKE Var_Descripcion
			ORDER BY AnioMes DESC
			LIMIT 0, 15;
	END IF;

	IF (Par_NumLis = listaEdoCtas) THEN
		SELECT	envio.AnioMes,			envio.ClienteID,	envio.SucursalID,	envio.CorreoEnvio,	envio.EstatusEdoCta,
				datoscte.NombreComple,
				CONVERT(CONCAT(params.RutaExpPDF, params.PrefijoEmpresa, '/', envio.AnioMes, '/', RIGHT(CONCAT('000', CAST(envio.SucursalID AS CHAR)), 3), '/', RIGHT(CONCAT('0000000000', CAST(envio.ClienteID AS CHAR)), 10), '-', envio.AnioMes, '.pdf'), CHAR) AS RutaPDF,
				CONVERT(CONCAT(params.RutaExpPDF, 'XML/', params.PrefijoEmpresa, '/', envio.AnioMes, '/', RIGHT(CONCAT('000', CAST(envio.SucursalID AS CHAR)), 3), '/', RIGHT(CONCAT('0000000000', CAST(envio.ClienteID AS CHAR)), 10), '-', '1', '-', envio.AnioMes, '.xml'), CHAR) AS RutaXML
			FROM EDOCTAENVIOCORREO AS envio
			INNER JOIN EDOCTAPARAMS AS params
			INNER JOIN EDOCTADATOSCTE AS datoscte ON envio.SucursalID = datoscte.SucursalID AND envio.ClienteID = datoscte.ClienteID
			WHERE	envio.ClienteID = Par_ClienteID
			ORDER BY envio.AnioMes DESC;
	END IF;

END TerminaStore$$