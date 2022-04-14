
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGETTIPOCAMBIO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGETTIPOCAMBIO`;

DELIMITER $$
CREATE FUNCTION `FNGETTIPOCAMBIO`(
# FUNCIÓN PARA OBTENER EL TIPO DE CAMBIO DE UNA MONEDA.
	Par_MonedaID		INT(11),	-- Número ID de la Moneda
	Par_TipoCambio		INT(11),	-- Tipo de Cambio a Mostrar 1.- DOF (PLD)
	Par_FechaConsulta	DATE		-- Fecha de consulta.
) RETURNS decimal(16,6)
    DETERMINISTIC
BEGIN
	-- DECLARACIÓN DE VARIABLES
	DECLARE Var_TipoCambio		DECIMAL(16,6);

	-- DECLARACIÓN DE CONSTANTES
	DECLARE Cadena_Vacia		VARCHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Str_SI				CHAR(1);
	DECLARE Str_NO				CHAR(1);
	DECLARE TipoCambioDOF		INT(11);

	-- ASIGNACIÓN DE CONSTANTES
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Str_SI					:= 'S';				-- Constante Si
	SET Str_NO					:= 'N'; 			-- Constante No
	SET TipoCambioDOF			:= 01;				-- Tipo de cambio DOF

	# TIPO DE CAMBIO DOF, DÍA ANTERIOR A LA FECHA DE CONSULTA.
	IF(IFNULL(Par_TipoCambio, Entero_Cero) = TipoCambioDOF)THEN
		/** SE OBTIENE EL TIPO DE CAMBIO PRIMERO EN MONEDAS, SUPONIENDO QUE
		 ** EN LA FECHA DE SISTEMA EL USUARIO ENCARGADO DE LA ACTUALIZACIÓN
		 ** DEL TIPO DE CAMBIO NO LO HA REALIZADO DESDE PANTALLA.
		 ** */
		SET Var_TipoCambio := (
			SELECT TipCamDof FROM `MONEDAS`
			WHERE MonedaID = Par_MonedaID
				AND FechaRegistro < Par_FechaConsulta
			ORDER BY FechaActual DESC LIMIT 1);

		/** SI NO HAY UN TIPO DE CAMBIO RESPECTO AL DÍA ANTERIOR
		 ** A LA FECHA DEL SISTEMA EN LA TABLA DE MONEDAS, SE
		 ** OBTIENE EL TIPO DE CAMBIO EN EL HISTÓRICO DE MONEDAS.
		 ** */
		IF(IFNULL(Var_TipoCambio, Entero_Cero) = Entero_Cero)THEN
			SET Var_TipoCambio := (
				SELECT TipCamDof FROM `HIS-MONEDAS`
				WHERE MonedaID = Par_MonedaID
					AND FechaRegistro < Par_FechaConsulta
				ORDER BY FechaRegistro DESC , FechaActual DESC LIMIT 1);
		END IF;
	END IF;
	RETURN IFNULL(Var_TipoCambio, Entero_Cero);
END$$


