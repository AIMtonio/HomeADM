-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEASCREDITOPRO`;DELIMITER $$

CREATE PROCEDURE `LINEASCREDITOPRO`(
-- ============================================================================================================
-- SP UTILIZADO EN EL CIERRE DE MES PARA VALIDAR EL MES DE ANUALIDAD DE LA LINEA DE CREDITO
-- ============================================================================================================
	Par_Fecha	DATE,					-- Fecha en la que se realiza el calculo

	-- Parametros de Auditoria
	Par_EmpresaID		INT(11),		-- Parametro de Auditoria
	Aud_Usuario			INT(11),		-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50), 	-- Parametro de Auditoria
	Aud_Sucursal		INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT 			-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Declaración de Variables
	DECLARE Var_FechaMesAnual		DATE;
	DECLARE	Var_FechaFinMes			DATE;

	-- Declaración de Constantes
    DECLARE Entero_Cero	INT;

    SET Entero_Cero := 0;


	SET Var_FechaMesAnual := ADDDATE( Par_Fecha, INTERVAL 1 MONTH);
	SET Var_FechaFinMes := LAST_DAY(Par_Fecha);

	IF(Par_Fecha=Var_FechaFinMes)THEN
		UPDATE LINEASCREDITO SET
			ComisionCobrada = 'N',
	        SaldoComAnual = (CASE WHEN CobraComAnual='S' AND TipoComAnual = 'P' THEN ROUND( Autorizado * (ValorComAnual/100),2)
	                            WHEN CobraComAnual='S' AND TipoComAnual = 'M' THEN ValorComAnual
	                            ELSE Entero_Cero END)
		WHERE Estatus = 'A'
	    AND MONTH(FechaInicio)=MONTH(Var_FechaMesAnual);

	END IF;

END TerminaStore$$