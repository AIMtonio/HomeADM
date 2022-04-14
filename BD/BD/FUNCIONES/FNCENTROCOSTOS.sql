-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCENTROCOSTOS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCENTROCOSTOS`;
DELIMITER $$

CREATE FUNCTION `FNCENTROCOSTOS`(
-- Funcion que obtiene el CENTRO DE COSTOS de la sucursal
	Par_SucursalID 	INT
) RETURNS int(11)
    DETERMINISTIC
BEGIN

	-- Declaracion de Constantes
	DECLARE Var_CentroCostoID 	INT(11);	-- Centro de Costos de la Sucursal
	DECLARE Entero_Cero			INT(11);
	-- Asignacion de Constantes
	SET Entero_Cero				:= 0;

	SELECT CentroCostoID
    INTO Var_CentroCostoID
		FROM SUCURSALES
		WHERE SucursalID = Par_SucursalID;

	SET Var_CentroCostoID := IFNULL(Var_CentroCostoID, Entero_Cero);
/* Proceso para rectificar que exista en la Tabla de Centro de Costos */
	IF(Var_CentroCostoID != Entero_Cero) THEN
		SELECT CentroCostoID INTO Var_CentroCostoID
			FROM CENTROCOSTOS
				WHERE CentroCostoID = Var_CentroCostoID;
    END IF;

    IF(Var_CentroCostoID = Entero_Cero) THEN
		SELECT CentroCostoID INTO Var_CentroCostoID
			FROM CENTROCOSTOS
				WHERE CentroCostoID = Par_SucursalID;
    END IF;
    SET Var_CentroCostoID := IFNULL(Var_CentroCostoID, Entero_Cero);

RETURN Var_CentroCostoID;
END$$