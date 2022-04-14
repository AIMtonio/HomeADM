-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNDIASPIFIRA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNDIASPIFIRA`;
DELIMITER $$

CREATE FUNCTION `FNDIASPIFIRA`(
-- FUNCION QUE DEVUELVE DIAS DE ATRASO EN EL REPORTE FIRA PI
	Par_NumConsulta		INT(11),		-- Numero de Consulta
	Par_CreditoID		BIGINT(12),		-- Numero de Credito
    Par_FechaInicio		DATE,			-- Fecha de Inicio
	Par_FechaCorte		DATE			-- Fecha de Corte

) RETURNS int(11)
    DETERMINISTIC
BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_DiasAtraso		INT(11);
    DECLARE Var_Valor			INT(11);

	-- DECLARACION DE CONSTANTES
    DECLARE Entero_Cero			INT(11);
    DECLARE Fecha_Vacia			DATE;
    DECLARE Con_DiasAtraso		INT(1);

    -- ASIGNACION DE CONSTANTES
    SET Entero_Cero := 0;
    SET Fecha_Vacia	:= '1900-01-01';
	SET Con_DiasAtraso	:= 1;

    -- Días de maximo incumplimiento
	IF(Par_NumConsulta = Con_DiasAtraso) THEN
		SELECT	DiasAtraso
		INTO Var_DiasAtraso
		FROM SALDOSCREDITOS
			WHERE CreditoID = Par_CreditoID AND
				FechaCorte = Par_FechaCorte
			GROUP BY CreditoID;

		SET Var_DiasAtraso := IFNULL(Var_DiasAtraso, Entero_Cero);
		SET Var_Valor := Var_DiasAtraso;
    END IF;

	RETURN Var_Valor;
END$$
