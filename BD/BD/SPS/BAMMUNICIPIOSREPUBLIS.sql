-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMMUNICIPIOSREPUBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMMUNICIPIOSREPUBLIS`;
DELIMITER $$

CREATE PROCEDURE `BAMMUNICIPIOSREPUBLIS`(
	Par_EstadoID			INT(11),			-- Numero de estado
	Par_MunicipioID			INT(11),			-- Numero de Municipio

	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

	Aud_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria

)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia   VARCHAR(3000);
	-- Declaracion de constante
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante de Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;				-- Constante de Fecha Vacia
	DECLARE	Entero_Cero			INT(11);			-- Constante de Enetero cero

	DECLARE	Lis_MunicipioWS		INT(11);			-- Lista de los municipios para WS

	-- Asignacion de constante
	SET	Cadena_Vacia	:= '';						-- Constante de Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';			-- Constante de Fecha Vacia
	SET	Entero_Cero		:= 0;						-- Constante de Enetero cero

	SET	Lis_MunicipioWS	:= 1;						-- Lista de los municipios para WS

	-- 1.- Lista de los municipios para WS
	IF(Par_NumLis = Lis_MunicipioWS) THEN

		SET Var_Sentencia := CONCAT('SELECT	EstadoID,		MunicipioID,		Nombre,			Ciudad,		Localidad, ',
										' EqCNBV ',
										' FROM MUNICIPIOSREPUB ');

		IF(IFNULL(Par_EstadoID,Entero_Cero) <> Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE EstadoID = ',Par_EstadoID);
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE EstadoID = EstadoID');
		END IF;
		IF(IFNULL(Par_MunicipioID, Entero_Cero) <> Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND MunicipioID = ',Par_MunicipioID);
		END IF;

		SET @Sentencia	= (Var_Sentencia);

		PREPARE STBAMMUNICIPIOSREPUBLIS FROM @Sentencia;
		EXECUTE STBAMMUNICIPIOSREPUBLIS;
		DEALLOCATE PREPARE STBAMMUNICIPIOSREPUBLIS;

	END IF;

END TerminaStore$$
