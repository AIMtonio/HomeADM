-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSMSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSMSCON`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSSMSCON`(
# ========================================================
# ---------- SP PARA CONSULTAR LOS PARAMETROS SMS---------
# ========================================================
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
-- Declaracion de constantes
	DECLARE	Con_Principal	INT;
	DECLARE conRuta 		INT;
	DECLARE	conNumIns		INT;

-- Asignacion de constantes
	SET	Con_Principal		:= 1;		-- Consulta Principal
	SET conRuta  			:= 4;		-- Consulta la Ruta
	SET	conNumIns			:= 3;		-- Obtiene el primer numero de celular de la institucion

	IF(Par_NumCon = Con_Principal) THEN
		SELECT		NumeroInstitu1,	NumeroInstitu2,NumeroInstitu3,
					RutaMasivos,    NumDigitosTel, NumMsmEnv, 	EnviarSiNoCoici
			FROM 	PARAMETROSSMS;
	END IF;

	IF (Par_NumCon = conRuta) THEN
		SELECT RutaMasivos FROM PARAMETROSSMS;
	END IF;

	IF(Par_NumCon = conNumIns) THEN
		SELECT	NumeroInstitu1	FROM PARAMETROSSMS;
	END IF;

END TerminaStore$$