
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGETPLDSITIMONEDA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGETPLDSITIMONEDA`;

DELIMITER $$
CREATE FUNCTION `FNGETPLDSITIMONEDA`(
# FUNCIÓN PARA OBTENER EL VALOR DE UN PARÁMETRO GENERAL.
	Par_MonedaID		INT(11)-- Id de la Moneda (MONEDAS).
) RETURNS varchar(3) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- DECLARACIÓN DE VARIABLES
	DECLARE Var_ClaveMoneda		VARCHAR(3);
	DECLARE Var_TipoClaveMon	CHAR(1);

	-- DECLARACIÓN DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Str_SI				CHAR(1);
	DECLARE Str_NO				CHAR(1);
	DECLARE TipoMon_Clave		INT(11);	

	-- ASIGNACIÓN DE CONSTANTES
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Str_SI					:= 'S';				-- Constante Si
	SET Str_NO					:= 'N'; 			-- Constante No
	SET TipoMon_Clave  			:= 2;				-- Tipo Clave CNBV.

	SET Var_TipoClaveMon := LEFT(FNPARAMGENERALES('PLDSITI_Col12ClaveMon'),1);
	SET Var_TipoClaveMon := IFNULL(Var_TipoClaveMon, 1);

	# SI ES POR CLAVE SE OBTIENE DE MONEDAS.
	IF(Var_TipoClaveMon = TipoMon_Clave)THEN
		SET Var_ClaveMoneda := (SELECT EqCNBVUIF FROM MONEDAS WHERE MonedaID=Par_MonedaID);
	ELSE
		# SINO, SE REGRESA EL VALOR QUE LE LLEGA POR PARÁMETRO.
		SET Var_ClaveMoneda := Par_MonedaID;
	END IF;

	RETURN IFNULL(Var_ClaveMoneda, Cadena_Vacia);
END$$

