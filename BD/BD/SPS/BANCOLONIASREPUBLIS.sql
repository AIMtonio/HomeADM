-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCOLONIASREPUBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCOLONIASREPUBLIS`;
DELIMITER $$

CREATE PROCEDURE `BANCOLONIASREPUBLIS`(
	Par_EstadoID			INT(11),				-- Clave de Estado
	Par_MunicipioID			INT(11),				-- Clave de municipio
	Par_LocalidadID			INT(11),				-- Clave de la Localidad
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de listado
	Aud_EmpresaID			INT(11),				-- Parametro de auditoria

	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria

)TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Sentencia       VARCHAR(3000); 		-- Consulta dinamica
	-- Declaracion de constante
	DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);			-- Entero Cero
	DECLARE	Lis_Principal		INT(11);			-- Numero de listado de las colonias para el ws de milagro

	-- Asignacion de constante
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero

	SET	Lis_Principal			:= 1;				-- Numero de listado de las colonias para el ws de milagro

	-- 1.- Numero de listado de las colonias para el ws de milagro
	IF(Par_NumLis = Lis_Principal) THEN
		SET Var_Sentencia := 'SELECT	COL.EstadoID,		COL.MunicipioID,	COL.ColoniaID,		COL.TipoAsenta,		COL.Asentamiento, ';
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'COL.CodigoPostal,	COL.ClaveINEGI,		COL.ColoniaCNBV ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'FROM COLONIASREPUB COL ');
		IF(Par_LocalidadID > Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN LOCALIDADREPUB LOC ON LOC.MunicipioID = COL.MunicipioID ');
		END IF;
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'WHERE COL.EstadoID = ', Par_EstadoID, ' ');
		IF(Par_MunicipioID > Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND COL.MunicipioID = ', Par_MunicipioID);
		END IF;
		IF(Par_LocalidadID > Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND LOC.LocalidadID = ', Par_LocalidadID);
		END IF;
		SET Var_Sentencia := CONCAT(Var_Sentencia, ';');

		SET @Sentencia  = (Var_Sentencia);
	    PREPARE CONSULTACOLONIAS FROM @Sentencia;
	    EXECUTE CONSULTACOLONIAS ;
	    DEALLOCATE PREPARE CONSULTACOLONIAS;
	END IF;

END TerminaStore$$
