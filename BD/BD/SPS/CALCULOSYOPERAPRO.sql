-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOSYOPERAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULOSYOPERAPRO`;DELIMITER $$

CREATE PROCEDURE `CALCULOSYOPERAPRO`(
-- ===================================================================================
-- SP QUE REALIZA OPERACIONES ENTRE DOS CANTIDADES (SUMA, MULTIPLICACION)
-- ===================================================================================

	Par_NumeroDecimales	INT(11),
	Par_ValorUnoA		DECIMAL(14,2),
	Par_ValorDosA		DECIMAL(14,2),
	Par_ValorUnoB		DECIMAL(14,4),
	Par_ValorDosB		DECIMAL(14,4),

	Par_NumOpe			INT(11),
	Par_Salida			CHAR(1),
	INOUT Par_ResulDos	DECIMAL(12,2),
	INOUT Par_ResulCua	DECIMAL(12,4),
    INOUT Par_NumErr    INT(11),

    INOUT Par_ErrMen    VARCHAR(400),
    Par_EmpresaID 		INT(11) ,
    Par_Usuario 		INT(11) ,
    Par_FechaActual 	DATETIME,
    Par_DireccionIP 	VARCHAR(15),

    Par_ProgramaID 		VARCHAR(50),
    Par_SucursalID 		INT(11) ,
    Par_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN




DECLARE Cadena_Vacia        CHAR(1);
DECLARE Salida_SI	        CHAR(1);
DECLARE Entero_Cero         INT(11);
DECLARE Fecha_Vacia         DATE;
DECLARE Decimal_CeroDos		DECIMAL(12,2);
DECLARE Decimal_CeroCua		DECIMAL(12,4);
DECLARE MultiplicaDosDec	INT(11);
DECLARE MultiplicaCuaDec	INT(11);
DECLARE SumaDosDec			INT(11);


SET Decimal_CeroDos		:= 0.0;
SET Decimal_CeroCua		:= 0.0;
SET Cadena_Vacia        := '';
SET Salida_SI	        := 'S';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET MultiplicaDosDec	:= 1;
SET MultiplicaCuaDec	:= 2;
SET SumaDosDec			:= 3;

SET Par_ResulDos		:= 0;
SET Par_ResulCua		:= 0;

-- MULTIPLICACION A DOS DECIMALES
IF (Par_NumOpe = MultiplicaDosDec)THEN
	SET Par_ResulDos := ROUND((Par_ValorUnoA*Par_ValorDosA),2);
END IF;

-- MULTIPLICACION A CUATRO DECIMALES
IF (Par_NumOpe = MultiplicaCuaDec)THEN
	SET Par_ResulCua := ROUND((Par_ValorUnoB*Par_ValorDosB),4);
END IF;

-- SUMA A DOS DECIMALES
IF (Par_NumOpe = SumaDosDec)THEN
	SET Par_ResulDos := ROUND((Par_ValorUnoA + Par_ValorDosA),2);
END IF;


IF (Par_Salida = Salida_SI) THEN
	SELECT 	IFNULL(Par_ResulDos,Decimal_CeroDos) AS ResultadoDos,
			IFNULL(Par_ResulCua,Decimal_CeroDos) AS ResultadoCuatro;
END IF;

END TerminaStore$$