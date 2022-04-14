DELIMITER ;

DROP PROCEDURE IF EXISTS `SEGOPCIONWSRESTLIS`;

DELIMITER $$

CREATE PROCEDURE `SEGOPCIONWSRESTLIS` (
	-- SP para consultar los permisos y los roles requeridos para ejecutar un Web Service

	Par_WSRestID 					INT(11),				-- ID del Web Service
	Par_RolID 						INT(11),				-- ID del Rol
	Par_URLWSRest 					VARCHAR(250),			-- URL del Web Service

	Par_NumLis						TINYINT,				-- Numero de lista

	Par_EmpresaID					INT(11),				-- Parametros de Auditoria
	Aud_Usuario						INT(11),				-- Parametros de Auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal					INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Lis_Desplegada			TINYINT;				-- Lista por Desplegada del Web Service
	DECLARE Lis_OpcionesCanal		TINYINT;				-- Lista para obtener los canales disponibles del Web Service
	DECLARE ExcepcionPathVar		CHAR(1);				-- Excepcion por PathVariable
	DECLARE Entero_Cero				INT(11);				-- Entero Cero

	-- Asignacion de constantes
	SET Lis_Desplegada				:= 1;					-- Lista por Desplegada del Web Service
	SET Lis_OpcionesCanal			:= 2;					-- Lista para obtener los canales disponibles del Web Service
	SET ExcepcionPathVar			:= 'P';					-- Excepcion por PathVariable
	SET Entero_Cero					:= 0;					-- Entero Cero

	IF(Par_NumLis = Lis_Desplegada) THEN
		SELECT	SEGWSREST.WSRestID,		SEGWSREST.URLWSRest,	SEGROL.RolID,	SEGROL.NombreRol,	SEGROL.Descripcion AS DescripcionRol
		FROM SEGWSREST
		INNER JOIN SEGOPCIONWSREST ON SEGOPCIONWSREST.WSRestID = SEGWSREST.WSRestID
		INNER JOIN SEGROL ON SEGROL.RolID = SEGOPCIONWSREST.RolID
		LEFT JOIN SEGWSRESTEXCEPCION EX ON EX.WSRestID = SEGWSREST.WSRestID
		WHERE SEGWSREST.URLWSRest = Par_URLWSRest
		OR (POSITION(SEGWSREST.URLWSRest IN Par_URLWSRest) > Entero_Cero AND EX.SegWSRestExcepcionID IS NOT NULL AND EX.TipoExcepcion = ExcepcionPathVar);
	END IF;

	IF(Par_NumLis = Lis_OpcionesCanal) THEN
		SELECT	SEGWSREST.WSRestID,		SEGWSREST.URLWSRest,	SEGCANALES.CanalID,		SEGCANALES.NombreCanal
		FROM SEGWSREST
		INNER JOIN SEGWSRESTCANAL ON SEGWSREST.WSRestID = SEGWSRESTCANAL.WSRestID
		INNER JOIN SEGCANALES ON SEGWSRESTCANAL.CanalID = SEGCANALES.CanalID
		WHERE SEGWSREST.URLWSRest = Par_URLWSRest;
	END IF;
END TerminaStore$$
