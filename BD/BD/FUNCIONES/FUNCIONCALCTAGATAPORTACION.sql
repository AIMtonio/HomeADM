-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONCALCTAGATAPORTACION
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONCALCTAGATAPORTACION`;DELIMITER $$

CREATE FUNCTION `FUNCIONCALCTAGATAPORTACION`(
# ============================================
# --- FUNCION QUE REALIZA EL CALCULO DE GAT---
# ============================================
	Par_FechaOperacion		DATE,			-- Fecha en la que se esta realizando la operacion
	Par_FechaApertura		DATE,			-- Fecha en la que se aperturo
 	Par_Tasa				DECIMAL(12,4)	-- Tasa de Ahorro anualizada



) RETURNS decimal(12,4)
    DETERMINISTIC
BEGIN

	-- Declaracion de variables
	DECLARE Con_PerioUni	INT(1);
	DECLARE Par_Gat			DECIMAL(12,4);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(3);
	DECLARE	Decimal_Cero	DECIMAL(12,4);
	DECLARE	Salida_SI		CHAR(1);
	DECLARE Con_Mes			INT(11);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Entero cero
	SET	Decimal_Cero		:= 0;				-- Decimal cero
	SET	Salida_SI			:= 'S';				-- Salida si
	SET Con_PerioUni		:= 1;				-- Constante

	-- Inicializacion de variables
	SET Par_Gat				:= 0.00;

	/* Cálculo del GAT con la formula :
	** GAT= ((1+(r/m))^m)-1 ,
	** donde r= tasa de interés o rendimiento anual simple y m= número de períodos uniformes en el año.*/

	SET Par_Tasa			:= IFNULL(Par_Tasa,Decimal_Cero);
	SET Par_FechaOperacion	:= IFNULL(Par_FechaOperacion,Fecha_Vacia);
	SET Par_FechaApertura	:= IFNULL(Par_FechaApertura,Fecha_Vacia);

	SET Par_Gat	:= ROUND((POWER(1 + (Par_Tasa/Con_PerioUni),Con_PerioUni) - 1),2);

	RETURN Par_Gat;

END$$