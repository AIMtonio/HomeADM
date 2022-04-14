-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNDIASVENCIMIENTOARRENDA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNDIASVENCIMIENTOARRENDA`;DELIMITER $$

CREATE FUNCTION `FNDIASVENCIMIENTOARRENDA`(
# =====================================================================================
# -- FUNCION PARA EL CALCULO DE DIAS DE ATRASO QUE PRESENTA UN ARRENDAMIENTO.
# =====================================================================================
		Par_Fecha		DATE,			-- Fecha de calculo
		Par_ArrendaID   BIGINT(12)		-- ID del arrendamiento
) RETURNS int(11)
    DETERMINISTIC
BEGIN
	-- Declaracion de variables
	DECLARE Var_NumDiasAtraso	INT(11);		-- Numero de dias de atraso de la amortizacion

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Entero cero
	DECLARE Var_MontoMinimo		DECIMAL(12,2);	-- Monto minimo
	DECLARE Est_Atrasado		CHAR(1);		-- Estatus de atraso para las amortizaciones
	DECLARE Est_Vencida			CHAR(1);		-- Estatus de vencido para las amortizaciones

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Valor de cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Valor de fecha vacia.
	SET	Entero_Cero			:= 0;				-- Valor de entero cero.
	SET	Var_MontoMinimo		:= 0.10;			-- Valor de monto minimo
	SET Est_Atrasado      	:= 'A';				-- Estatus atrasado= A
	SET Est_Vencida 		:= 'B';             -- Estatus vencido = B


	-- Valores por default si son nulos
	SET Par_Fecha			:= IFNULL(Par_Fecha,Fecha_Vacia);
	SET Par_ArrendaID		:= IFNULL(Par_ArrendaID,Entero_Cero);


	SELECT	DATEDIFF(Par_Fecha,MIN(FechaVencim))
	  INTO	Var_NumDiasAtraso
		FROM ARRENDAAMORTI
		WHERE	ArrendaID = Par_ArrendaID
		  AND	Estatus IN (Est_Atrasado,Est_Vencida);

	SET Var_NumDiasAtraso := IFNULL(Var_NumDiasAtraso,Entero_Cero);

	IF (Var_NumDiasAtraso <= Entero_Cero) THEN
		SET Var_NumDiasAtraso := Entero_Cero;
	ELSE
		SET Var_NumDiasAtraso := Var_NumDiasAtraso + 1;
	END IF;

	RETURN Var_NumDiasAtraso;
END$$