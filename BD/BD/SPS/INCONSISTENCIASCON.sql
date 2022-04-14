-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INCONSISTENCIASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INCONSISTENCIASCON`;DELIMITER $$

CREATE PROCEDURE `INCONSISTENCIASCON`(
/* SP PARA CONSULTAR LAS INCONSISTENCIAS QUE TIENE UN CLIENTE, PROSPECTO, AVAL O GARANTE */
	Par_ClienteID			INT(11),		-- ID del Cliente
	Par_ProspectoID			BIGINT(20),		-- ID del Prospecto
	Par_AvalID				BIGINT(20),		-- ID del Aval
	Par_GaranteID			INT(11),		-- ID del Garante
	Par_TipoConsulta		INT(11),		-- Especifica el tipo de consulta

	-- Parametros de Auditoria
	Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),

    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore:BEGIN

	# Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);
    DECLARE Con_Principal		INT(11);

	# Asignacion de Constantes
	SET Entero_Cero			:= 0;		-- Constante Entero Cero: 0
	SET Con_Principal		:= 1;		-- Consulta Principal


	IF(Par_TipoConsulta=Con_Principal)THEN
		SELECT ClienteID, ProspectoID, AvalID, GaranteID, NombreCompleto, Comentario
			FROM INCONSISTENCIAS
            WHERE ClienteID = Par_ClienteID
				AND ProspectoID = Par_ProspectoID
                AND AvalID = Par_AvalID
                AND GaranteID = Par_GaranteID;
	END IF;


END TerminaStore$$