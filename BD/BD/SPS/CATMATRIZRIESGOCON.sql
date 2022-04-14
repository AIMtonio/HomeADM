-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMATRIZRIESGOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATMATRIZRIESGOCON`;DELIMITER $$

CREATE PROCEDURE `CATMATRIZRIESGOCON`(
	-- SP Para consultar la matriz de riesgos
    Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta
	Par_EmpresaID       	INT(11),  			-- Auditoria

    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria

    Aud_NumTransaccion  	BIGINT(20) 			-- Auditoria
		)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Con_Principal	INT; 				-- Consulta pricipal

	-- Asignacion de Constantes
	SET	Con_Principal		:= 1;

    IF (Par_NumCon=Con_Principal) THEN

    SELECT CodigoMatriz, ConceptoMatrizID, Concepto, Descripcion, Valor,
	   LimiteValida, GrupO FROM CATMATRIZRIESGO;

	END IF;

    END TerminaStore$$