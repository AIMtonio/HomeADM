-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGENERADIGVERI
DELIMITER ;
DROP FUNCTION IF EXISTS `FNGENERADIGVERI`;
DELIMITER $$
-- FN Función para obtener el codigo verificador de las tarjetas maquiladas por TGS
CREATE FUNCTION `FNGENERADIGVERI`(

	Par_Cuenta 				CHAR(15)

) RETURNS CHAR(16) DETERMINISTIC
BEGIN
	/* Declaracion de Variables */
	DECLARE Var_Indice			INT(11);
	DECLARE Var_Acum			INT(11);
	DECLARE Var_Val				INT(11);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_Cadena			INT(11);
	DECLARE Var_Digito			CHAR(15);
	/* Declaracion de Constantes */
	DECLARE	Cadena_Vacia		CHAR(15);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE Salida_SI			CHAR(1);

 	/* Asignacion de Constantes */
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET Salida_NO			:= 'N';
	SET Salida_SI			:= 'S';

	SET Var_Indice := 0;
	SET Var_Acum := 0;
	SET Var_Val := 0;

	WHILE Var_Indice < 15 DO

		SET Var_Cadena := CAST(SUBSTRING(Par_Cuenta, Var_Indice + 1, 1) AS UNSIGNED);
        
		IF ((Var_Indice % 2) != 0) THEN

			SET Var_Acum := Var_Acum + Var_Cadena;

		ELSE SET Var_Val :=  Var_Cadena * 2;
            IF (Var_Val < 10) THEN
                
                SET Var_Acum := Var_Acum + Var_Val;
                
            ELSE

                SET Var_Acum := Var_Acum + (Var_Val DIV 10 + Var_Val % 10);
                
            END IF;
		END IF;

		SET Var_Indice := Var_Indice + 1;

	END WHILE;

	SET Var_Digito := 10 - (IF(Var_Acum % 10 = 0, 10, Var_Acum%10));

    
	RETURN Var_Digito;
END$$
