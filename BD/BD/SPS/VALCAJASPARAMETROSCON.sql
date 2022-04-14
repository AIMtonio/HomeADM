-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALCAJASPARAMETROSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALCAJASPARAMETROSCON`;
DELIMITER $$

CREATE PROCEDURE `VALCAJASPARAMETROSCON`(
# ==============================================================
# -------- SP PARA ACTUALIZAR LOS VALCAJASPARAMETROSCON-----------
# ==============================================================
	Par_ValCajaParamID		INT(11),			-- Llave primaria tabla VALCAJASPARAMETROS
	Par_TipConsulta			TINYINT UNSIGNED,	-- Tipo de Consulta

	Par_EmpresaID			INT(11),			-- Parámetro de Auditoría
	Aud_Usuario				INT(11),			-- Parámetro de Auditoría
	Aud_FechaActual			DATETIME,			-- Parámetro de Auditoría
	Aud_DireccionIP			VARCHAR(15),		-- Parámetro de Auditoría
	Aud_ProgramaID			VARCHAR(50),		-- Parámetro de Auditoría
	Aud_Sucursal			INT(11),			-- Parámetro de Auditoría
	Aud_NumTransaccion		BIGINT(20)			-- Parámetro de Auditoría
)
TerminaStore: BEGIN

	-- DECLARACIÓN DE CONSTANTES
	DECLARE Con_Principal		TINYINT UNSIGNED;

	-- ASIGNACIÓN DE CONSTANTES
	SET Con_Principal			:= 1;

	IF(Par_TipConsulta = Con_Principal) THEN
		SELECT HoraInicio, NumEjecuciones, Intervalo, RemitenteID
		FROM VALCAJASPARAMETROS
		WHERE ValCajaParamID = Par_ValCajaParamID;
	END IF;

END TerminaStore$$