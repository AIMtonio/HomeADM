-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWCALCULACATINVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWCALCULACATINVPRO`;
DELIMITER $$


CREATE PROCEDURE `CRWCALCULACATINVPRO`(
	Par_SolFondeoID   	BIGINT(20),			-- ID del fondeo

    Par_Salida			CHAR(1), 			-- Parametros de salida S = SI N= NO
	INOUT Par_CAT		DECIMAL(14,4),		-- Valor CAT
    INOUT Par_NumErr 	INT,				-- Numero de error
    INOUT Par_ErrMen  	VARCHAR(350),		-- Mensaje de error

	Aud_EmpresaID       INT,				-- Auditoria
    Aud_Usuario         INT,				-- Auditoria
    Aud_FechaActual     DATETIME,			-- Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Auditoria
    Aud_Sucursal        INT,				-- Auditoria
    Aud_NumTransaccion  BIGINT				-- Auditoria


)

Terminastore:BEGIN

-- Declaracion de Variables
DECLARE Var_NumAmorti		INT;
DECLARE Var_Contador		INT;
DECLARE Var_CreditoID		BIGINT(12);
DECLARE Var_MontoFondeo		DECIMAL(12,2);
DECLARE Var_FrecuPago		INT(11);
DECLARE Var_ValorCuotas		VARCHAR(15000);
DECLARE Var_CAT				DECIMAL(14,4);

-- Declaracion de Constantes
DECLARE StringNO			CHAR(1);

-- Asignacion de Constantes
SET Var_ValorCuotas	:= '';

SET Var_NumAmorti	:= (SELECT COUNT(SolFondeoID)
						FROM AMORTICRWFONDEO
						WHERE SolFondeoID = Par_SolFondeoID);

SET Var_Contador = 1;
SELECT CreditoID,MontoFondeo INTO Var_CreditoID, Var_MontoFondeo
	FROM  CRWFONDEO WHERE SolFondeoID = Par_SolFondeoID;


SET Var_FrecuPago:= (SELECT PeriodicidadCap
						FROM CREDITOS WHERE CreditoID =Var_CreditoID);

WHILE Var_Contador <= Var_NumAmorti  DO

	SET Var_ValorCuotas:= CONCAT(Var_ValorCuotas, (SELECT Capital + InteresGenerado
											FROM AMORTICRWFONDEO
											WHERE  AmortizacionID = Var_Contador
											AND SolFondeoID = Par_SolFondeoID),',');
	SET Var_Contador := Var_Contador +1;
END WHILE;


CALL CALCULARCAT(Var_MontoFondeo,Var_ValorCuotas,Var_FrecuPago,StringNO,Par_CAT,Aud_NumTransaccion);


END TerminaStore$$
