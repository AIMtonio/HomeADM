-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPAGCREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESPAGCREDITOCON`;
DELIMITER $$


CREATE PROCEDURE `RESPAGCREDITOCON`(
# ============================================================
# -------- SP PARA CONSULTAR LOS PAGOS PARA REVERSAS----------
# ============================================================
	Par_CreditoID       BIGINT(12),
	Par_TipoConsul		INT(2),


    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

	)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Transaccion		BIGINT(20);
	DECLARE Var_TransaccionGar	BIGINT(20);


	-- Declaracion de Constantes
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT(11);
	DECLARE Salida_SI           CHAR(1);
	DECLARE Con_Principal		INT(2);

	-- Asignacion de Constantes
	SET Cadena_Vacia        	:= '';              -- String Vacio
	SET Fecha_Vacia         	:= '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero         	:= 0;               -- Entero en Cero
	SET Salida_SI           	:= 'S';             -- Indica una salida en pantalla
	SET Con_Principal			:= 1; 				-- Consulta principal



	SET Var_TransaccionGar	:= (SELECT   	NumTransaccion
									FROM	BITACORAAPLIGAR
									WHERE 	CreditoID = Par_CreditoID
									LIMIT	1);
	SET Var_Transaccion		:= (SELECT   	MAX(TranRespaldo)
									FROM 	RESPAGCREDITO
									WHERE	CreditoID = Par_CreditoID);

	SET Var_TransaccionGar	:= IFNULL(Var_TransaccionGar,Entero_Cero);

	IF(Con_Principal = Par_TipoConsul ) THEN
		SELECT 		MAX(TranRespaldo) AS TranRespaldo, CuentaAhoID, MAX(CreditoID) AS CreditoID, FechaPago, SUM(MontoPagado) AS MontoPagado
			FROM  	RESPAGCREDITO
			WHERE	TranRespaldo 	= Var_Transaccion
            AND 	TranRespaldo	!= Var_TransaccionGar
			AND  	CreditoID 		= Par_CreditoID
            GROUP BY CuentaAhoID, FechaPago;
	END IF;


END TerminaStore$$