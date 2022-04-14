
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGETPLDSITILOC

DELIMITER ;
DROP FUNCTION IF EXISTS `FNGETPLDSITILOC`;

DELIMITER $$
CREATE FUNCTION `FNGETPLDSITILOC`(
	/* FUNCIÓN QUE OBTIENE LA CLAVE DE LA LOCALIDAD PARA LOS REPORTES PLD. */
	Par_EstadoID			INT(11),		-- ESTADO ID.
	Par_MunicipioID			INT(11),		-- MUNICIPIO ID.
	Par_LocalidadID			INT(11)			-- LOCALIDAD ID.
) RETURNS varchar(10) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion Variables
	DECLARE Var_ClaveLocID		VARCHAR(100);	-- RESULTADO.

	-- Declaracion de Constantes
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;

	-- Asignacion de Constantes
	SET Estatus_Activo			:= 'A';				-- ESTATUS ACTIVO.
	SET Cadena_Vacia			:= '';				-- CADENA VACIA.
	SET Fecha_Vacia				:= '1900-01-01';	-- FECHA VACIA.
	SET Entero_Cero				:= 0;				-- ENTERO CERO.


	SET Var_ClaveLocID := (
		SELECT L.ClaveRIPSF41 FROM LOCALIDADREPUB L
		WHERE L.EstadoID = Par_EstadoID
			AND L.MunicipioID = Par_MunicipioID
			AND L.LocalidadID = Par_LocalidadID
		LIMIT 1);

RETURN LEFT(IFNULL(Var_ClaveLocID, Cadena_Vacia),100);
END$$


