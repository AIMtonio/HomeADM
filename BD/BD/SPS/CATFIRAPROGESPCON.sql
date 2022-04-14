-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATFIRAPROGESPCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATFIRAPROGESPCON`;DELIMITER $$

CREATE PROCEDURE `CATFIRAPROGESPCON`(
	/*SP Para Consultar los SubProgramas FIRA*/
	Par_NumCon					TINYINT UNSIGNED,		# Numero de Consulta
	Par_CveSubProgramaID		VARCHAR(11),				# Clave del SubPrograma

	/*Parametros de Auditoria*/
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			VARCHAR(1);
	DECLARE Con_Principal			INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET	Con_Principal					:= 1;				-- Consulta Principal

	/* Numero de Consulta: 1
	Consulta Principal */
	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			ClaveProgramaID,		CveSubProgramaID,		SubPrograma,		FrenteTecnologico,
            Vigente
			FROM CATFIRAPROGESP
				WHERE
					Vigente = 'N' AND
					CveSubProgramaID  = Par_CveSubProgramaID;
	END IF;

END TerminaStore$$