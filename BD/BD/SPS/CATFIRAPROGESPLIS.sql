-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATFIRAPROGESPLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATFIRAPROGESPLIS`;DELIMITER $$

CREATE PROCEDURE `CATFIRAPROGESPLIS`(
	/*SP Para Listar Los SubProgramas FIRA*/
	Par_NumLis					TINYINT UNSIGNED,			# Numero de Lista
	Par_SubPrograma				VARCHAR(100),				# Descripcion del SubPrograma

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
	DECLARE Lis_Principal			INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET	Lis_Principal					:= 1;				-- Lista Principal

	/* Numero de Lista: 1
	Lista Principal */
	IF(Par_NumLis = Lis_Principal) THEN
		SET Par_SubPrograma := IFNULL(Par_SubPrograma, Cadena_Vacia);
		SELECT
			ClaveProgramaID,		CveSubProgramaID,		SubPrograma
			FROM CATFIRAPROGESP
				WHERE
					Vigente = 'N' AND
					SubPrograma LIKE CONCAT('%',UPPER(Par_SubPrograma),'%')
                    LIMIT 15;
	END IF;

END TerminaStore$$