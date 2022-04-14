-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROYECCIONINDICALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROYECCIONINDICALIS`;DELIMITER $$

CREATE PROCEDURE `PROYECCIONINDICALIS`(
# =====================================================================================
# ----- STORED PARA LISTAR LA PROYECCION DE INDICADORES DE ACUERDO AL ANIO ------------
# =====================================================================================

	Par_TipoLis				INT(11),	# Tipo de Lista
	Par_AnioLis				INT(11),	# Anio en la cual se listara la proyeccíon

	-- Parametros de Auditoria
    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion

)
TerminaStore: BEGIN

DECLARE	Registros			INT(11);
DECLARE Flag				INT(11);


/* Declaracion de Constantes */
DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT(11);
DECLARE Decimal_Cero			DECIMAL(12,2);
DECLARE	Str_SI					CHAR(1);
DECLARE	Str_NO					CHAR(1);
DECLARE	Lista_Principal			INT(11);


/* Asignacion de Constantes */
SET	Cadena_Vacia				:= '';			-- Cadena Vacia
SET	Fecha_Vacia					:= '1900-01-01';-- Fecha Vacia
SET	Entero_Cero					:= 0;			-- Entero Cero
SET Decimal_Cero				:= 0.00;		-- Decimal Cero
SET	Str_SI						:= 'S';			-- Cadena de Si
SET	Str_NO						:= 'N';			-- Cadena de No
SET	Lista_Principal				:= 1;			-- Cadena de No



IF(Par_TipoLis = Lista_Principal) THEN

    SELECT COUNT(*) INTO Registros
		FROM PROYECCIONINDICA
			WHERE Anio = Par_AnioLis;
    IF (Registros > 0) THEN
		SET Flag := 1;
	/*  LISTA DE PROTYECCION DE INDICADORES POR ANIO */
		SELECT ConsecutivoID, Anio, Mes, SaldoTotal, SaldoFira, GastosAdmin,
				CapitalConta, UtilidadNeta, ActivoTotal, SaldoVencido, Flag
		   FROM PROYECCIONINDICA
			WHERE Anio = Par_AnioLis ORDER BY ConsecutivoID ;
	ELSE
		SET Flag := 0;
		SELECT ConsecutivoID, Anio, Mes, SaldoTotal, SaldoFira, GastosAdmin,
				CapitalConta, UtilidadNeta, ActivoTotal, SaldoVencido, Flag
			FROM PROYECCIONINDICABASE;
    END IF;

END IF;


END TerminaStore$$