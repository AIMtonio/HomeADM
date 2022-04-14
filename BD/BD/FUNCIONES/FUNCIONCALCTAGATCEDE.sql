-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONCALCTAGATCEDE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONCALCTAGATCEDE`;
DELIMITER $$

CREATE FUNCTION `FUNCIONCALCTAGATCEDE`(
# ============================================
# --- FUNCION QUE REALIZA EL CALCULO DE GAT---
# ============================================
	Par_FechaOperacion		DATE,			/* Fecha en la que se esta realizando el cierre de mes*/
	Par_FechaApertura		DATE,			/* Fecha en la que se aperturo la cuenta el cierre de mes*/
 	Par_Tasa				DECIMAL(12,4)	/* Tasa de Ahorro anualizada*/
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
	DECLARE dias_periodos	INT(5);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0;
	SET	Salida_SI			:= 'S';

	-- Inicializacion de variables
	SET Par_Gat				:= 0.00;

	/* Calculo del GAT con la formula :
	** GAT= ((1+(r/m))^m)-1 ,
	** donde r= tasa de interes o rendimiento anual simple y m= numero de periodos uniformes en el ano.*/

	SET Par_Tasa			:= IFNULL(Par_Tasa,Decimal_Cero);
	SET Par_FechaOperacion	:= IFNULL(Par_FechaOperacion,Fecha_Vacia);
	SET Par_FechaApertura	:= IFNULL(Par_FechaApertura,Fecha_Vacia);
	SET dias_periodos		:= DATEDIFF(Par_FechaOperacion, Par_FechaApertura);
	SET Con_PerioUni		:= ROUND(360/NULLIF(dias_periodos,Entero_Cero));
	SET Par_Tasa			:= Par_Tasa /100 ;

	SET Par_Gat	:= ROUND((POWER(1 + (Par_Tasa/Con_PerioUni),Con_PerioUni) - 1) * 100,2);

	RETURN Par_Gat;

END$$