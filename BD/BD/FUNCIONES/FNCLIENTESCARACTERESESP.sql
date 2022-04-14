-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCLIENTESCARACTERESESP
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCLIENTESCARACTERESESP`;
DELIMITER $$


CREATE FUNCTION `FNCLIENTESCARACTERESESP`(
/* FUNCION PARA VALIDAR CARACTERES ESPECIALES*/
	Par_Cadena			VARCHAR(150),		-- Cadena
	Tipo_Con			CHAR (1)			-- Tipo de consulta
) RETURNS int(11)
    DETERMINISTIC
BEGIN

	-- Declaracion de variables
	DECLARE Var_Control			INT;		-- Variable de control

	IF(Tipo_Con = '1')THEN
        SET Var_Control  :=  ( SELECT Par_Cadena REGEXP '[°|!#|$|%|&|/|()|=|?|:|;|-|¡|¿|\\¬|+*{}|\\[\\]|_|]');
	END IF;
	IF(Tipo_Con = '2')THEN
		SET Var_Control  :=  ( SELECT Par_Cadena REGEXP '[°|!#|$|%|&|/|()|=|?|:|;|-|¡|¿|\\¬|+*{}|\\[\\]|_|]');
    END IF;
    RETURN Var_Control;
END$$