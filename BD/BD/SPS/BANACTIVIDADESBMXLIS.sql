-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANACTIVIDADESBMXLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANACTIVIDADESBMXLIS`;
DELIMITER $$

CREATE PROCEDURE `BANACTIVIDADESBMXLIS`(
	Par_ActividadBMXID		VARCHAR(15),			-- Numero de Actividad BMX
	Par_Descripcion			VARCHAR(50),			-- Descripción de la Actividad
	Par_TamanioLista		INT(11),				-- Parametro tamanio de la lista
	Par_PosicionInicial		INT(11),				-- Parametro posicion inicial de la lista

	Par_NumLis				TINYINT UNSIGNED,		-- Numero de Lista

	Aud_EmpresaID			INT(11),				-- Parametros de auditoria
	Aud_Usuario				INT(11),				-- Parametros de auditoria
	Aud_FechaActual			DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal			INT(11),				-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametros de auditoria
)TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(1);			-- Entero cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Fecha Vacia 

	DECLARE Lis_ActBMXWS		INT(11);		-- Lista de las actividades BMX Para el ws de Milagro

	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;				-- Entero cero
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia 

	SET Lis_ActBMXWS			:= 1;				-- Lista principal

	-- Asignacion d evalores por defaul
	SET Par_ActividadBMXID		:= IFNULL(Par_ActividadBMXID, Cadena_Vacia);
	SET Par_Descripcion			:= IFNULL(Par_Descripcion, Cadena_Vacia);
	SET Par_TamanioLista		:= IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial		:= IFNULL(Par_PosicionInicial, Entero_Cero);

	-- 1.- -- Lista de las actividades BMX Para el ws de Milagro
	IF(Par_NumLis = Lis_ActBMXWS) THEN
		IF(Par_TamanioLista = Entero_Cero) THEN
			SELECT COUNT(ActividadBMXID)
				INTO Par_TamanioLista
				FROM ACTIVIDADESBMX;
		END IF;

		SELECT	ActividadBMXID,			Descripcion,		ActividadINEGIID,		ActividadFR,		ActividadFOMUR,
				NumeroBuroCred,			NumeroCNBV,			ActividadGuber,			ClaveRiesgo,		Estatus,
				ClasifRegID,			ActividadSCIANID
		FROM ACTIVIDADESBMX
		WHERE ActividadBMXID = IF(Par_ActividadBMXID <> Cadena_Vacia , Par_ActividadBMXID , ActividadBMXID)
			AND Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		LIMIT Par_PosicionInicial, Par_TamanioLista;
	END IF;
END TerminaStore$$