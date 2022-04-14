-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNTCADEUDOLINEA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNTCADEUDOLINEA`;DELIMITER $$

CREATE FUNCTION `FNTCADEUDOLINEA`(
-- FUNCION PARA EL CALCULO DEL ADEUDO ACTUAL DE LA LINEA DE CREDITO
	Par_ClienteID  		   INT(11),
	Par_LineaTarCredID	   INT(20)
) RETURNS decimal(16,2)
    DETERMINISTIC
BEGIN
-- DECLARACION DE CONSTANTES
DECLARE Decimal_Cero       DECIMAL(1,1);

-- DECLARACION DE VARIABLES
DECLARE Var_AdeudoActual   DECIMAL(16,2);


-- ASIGANACION DE CONSTANTES
SET Decimal_Cero       := '0.0';

SET Var_AdeudoActual := (SELECT (IFNULL(SaldoAFavor,Decimal_Cero) 		 + IFNULL(SaldoCapVigente,Decimal_Cero) 		+IFNULL(SaldoCapVencido, Decimal_Cero) 			+IFNULL(SaldoInteres, Decimal_Cero) 			+IFNULL(SaldoIVAInteres, Decimal_Cero)
								+IFNULL(SaldoMoratorios,Decimal_Cero)	 + IFNULL(SaldoIVAMoratorios,Decimal_Cero)		+IFNULL(SalComFaltaPag,Decimal_Cero)			+IFNULL(SalIVAComFaltaPag, Decimal_Cero)		+IFNULL(SalOrtrasComis, Decimal_Cero)
								+IFNULL(SalIVAOrtrasComis, Decimal_Cero))
						   FROM LINEATARJETACRED
						  WHERE LineaTarCredID= Par_LineaTarCredID AND  ClienteID=Par_ClienteID);


RETURN Var_AdeudoActual;
END$$