
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCATDATSOCIOELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCATDATSOCIOELIS`;
DELIMITER $$


CREATE PROCEDURE `BANCATDATSOCIOELIS`(
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de la lista a filtrar
	
	Aud_EmpresaID			INT(11),			-- Auditoria
	Aud_Usuario				INT,				-- Auditoria
	Aud_FechaActual			DATETIME,			-- Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Auditoria
	Aud_Sucursal			INT,				-- Auditoria
	Aud_NumTransaccion		BIGINT				-- Auditoria
	)

TerminaStore:BEGIN

-- Declaracion de variables
DECLARE listaPrincipal		INT;				-- Lista principal todos los datos con estatus activo 'A'
DECLARE Estatus				CHAR;

SET listaPrincipal			:=1;				-- Lista principal
SET Estatus					:= 'A';				-- Estatus del elemento a filtrar

IF(Par_NumLis = listaPrincipal)THEN
	SELECT CatSocioEID, Descripcion, Tipo FROM CATDATSOCIOE;
END IF;

END TerminaStore$$
