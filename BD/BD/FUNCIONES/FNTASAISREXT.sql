-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNTASAISREXT
DELIMITER ;
DROP FUNCTION IF EXISTS `FNTASAISREXT`;DELIMITER $$

CREATE FUNCTION `FNTASAISREXT`(
	/* FUNCIÓN QUE DEVUELVE LA TASA ISR PARA RESIDENTES EN EL EXTRANJERO. */
	Par_PaisID		INT(11),		-- Id del Pais de consulta
	Par_NumCon		INT(11),		-- Núm. de consulta
	Par_Fecha 		DATE,			-- Fecha de Operacion
	Par_TasaISR		DECIMAL(12,2)	-- Tasa ISR Actual
) RETURNS decimal(12,2)
    DETERMINISTIC
BEGIN
	-- Declaracion Variables
	DECLARE Var_TasaISRExt		DECIMAL(12,2);	-- TASA ISR EXTRANJERA
	DECLARE Var_MaxFecha		DATE ;
	DECLARE Var_SigAntFecha		DATE ;
	DECLARE Var_NumTrans		BIGINT(20);
	DECLARE Var_SAntNumTrans	BIGINT(20);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Con_TasaVigente		INT(11);
	DECLARE Con_CambioTasa		INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';			-- CADENA VACIA
	SET Fecha_Vacia				:= '1900-01-01';-- FECHA VACIA
	SET Entero_Cero				:= 0;			-- ENTERO CERO
	SET Con_TasaVigente			:= 1;			-- TASA ISR ACTUAL.
	SET Con_CambioTasa			:= 2;			-- TASA ISR SI EXISTIÓ CAMBIO DE TASA.

	IF(Par_NumCon = Con_TasaVigente)THEN
		SET Var_TasaISRExt := (SELECT TasaISR FROM TASASISREXTRAJERO WHERE PaisID = Par_PaisID LIMIT 1);
		SET Var_TasaISRExt := IFNULL(Var_TasaISRExt, Entero_Cero);
	END IF;

	IF(Par_NumCon = Con_CambioTasa)THEN
		# SI NO HAY CAMBIO DE TASA, SE REGRESA LA ACTUAL.
		SET Var_TasaISRExt := Par_TasaISR;

		SELECT
			MAX(Fecha),MAX(NumTransaccion)
		INTO
			Var_MaxFecha,Var_NumTrans
		FROM HISTASASISREXTRAJERO WHERE PaisID = Par_PaisID;

		IF(Var_MaxFecha<=Par_Fecha)THEN
			SET Var_TasaISRExt := (SELECT Valor FROM HISTASASISREXTRAJERO
										WHERE Fecha=Var_MaxFecha
											AND PaisID = Par_PaisID
											AND NumTransaccion= Var_NumTrans);
		ELSE
			SELECT
				MAX(Fecha),		MAX(NumTransaccion)
			INTO
				Var_SigAntFecha,Var_SAntNumTrans
			FROM HISTASASISREXTRAJERO
				WHERE Fecha < Var_MaxFecha
					AND Fecha <= Par_Fecha
					AND PaisID = Par_PaisID
				LIMIT 1;

			IF(IFNULL(Var_SAntNumTrans, Entero_Cero) != Entero_Cero)THEN
				SET Var_TasaISRExt := (SELECT Valor FROM HISTASASISREXTRAJERO
										WHERE Fecha = Var_SigAntFecha
											AND PaisID = Par_PaisID
											AND NumTransaccion = Var_SAntNumTrans
											LIMIT 1);
			END IF;
		END IF;
	END IF;
	SET Var_TasaISRExt := IFNULL(Var_TasaISRExt, Entero_Cero);

RETURN Var_TasaISRExt;
END$$