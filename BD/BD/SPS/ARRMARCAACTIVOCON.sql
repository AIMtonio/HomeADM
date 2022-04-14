-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRMARCAACTIVOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRMARCAACTIVOCON`;DELIMITER $$

CREATE PROCEDURE `ARRMARCAACTIVOCON`(
-- SP para la consulta de una Marca
	Par_MarcaID				BIGINT(12),				-- Id de la marca
	Par_NumCon				TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID			INT,					-- Id de la empresa
	Aud_Usuario         	INT,					-- Usuario
	Aud_FechaActual     	DATETIME,				-- Fecha actual
	Aud_DireccionIP     	VARCHAR(15),			-- Descripcion IP
	Aud_ProgramaID      	VARCHAR(50),			-- Id del programa
	Aud_Sucursal        	INT(11),				-- Numero de sucursal
	Aud_NumTransaccion  	BIGINT(20)				-- Numero de transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Con_Principal	INT;

	-- Asignacion de Contantes
	SET Con_Principal		:=1;	-- consulta principal

	-- Consulta los datos de una marca --
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	MarcaID,		TipoActivo,		Descripcion,	Estatus
		FROM	ARRMARCAACTIVO
		WHERE	MarcaID = Par_MarcaID;
	END IF;

END TerminaStore$$