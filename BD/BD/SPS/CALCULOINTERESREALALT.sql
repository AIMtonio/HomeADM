-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOINTERESREALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULOINTERESREALALT`;
DELIMITER $$


CREATE PROCEDURE `CALCULOINTERESREALALT`(
# ==================================================================================
# --- PROCESO PARA EL REGISTRO DE INFORMACION PARA EL CALCULO DEL INTERES REAL -----
# ==================================================================================
	Par_ClienteID			INT(11),			-- Numero del Cliente
	Par_Fecha				DATE,				-- Fecha de Calculo
	Par_TipoInstrumentoID	INT(11),			-- Tipo de Instrumento: 2 = Cuentas 13 = Inversiones 28 = Cedes
    Par_InstrumentoID		BIGINT(12),			-- Numero de Instrumento: Numero de Cuenta, Inversion o CEDE
	Par_Monto				DECIMAL(18,2),		-- Valor del Monto

    Par_InteresGenerado		DECIMAL(18,2),		-- Valor del Interes Generado
	Par_ISR					DECIMAL(18,2),		-- Valor del ISR
	Par_TasaInteres			DECIMAL(14,2),		-- Tasa de Interes
    Par_FechaInicio			DATE,				-- Fecha de Inicio para el calculo del interes real
    Par_FechaFin			DATE,				-- Fecha Final para el calculo del interes real

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria

)

TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE InstrumentoCta		INT(11);

    DECLARE InstrumentoInv		INT(11);
    DECLARE Est_NoCalculado	    CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.00; 			-- Decimal Cero
	SET InstrumentoCta		:= 2;				-- Tipo de Instrumento: Cuentas

    SET InstrumentoInv		:= 13;				-- Tipo de Instrumento: Inversiones
	SET Est_NoCalculado		:= 'N';				-- Estatus del Calculo de Interes Real: No calculado

	SET Aud_FechaActual 	:= NOW();

	INSERT INTO CALCULOINTERESREAL(
		Fecha,				Anio,				Mes,					ClienteID, 			TipoInstrumentoID,
        InstrumentoID, 		Monto,				FechaInicio,			FechaFin,			InteresGenerado,
        ISR,				TasaInteres,        Ajuste,					InteresReal,		Estatus,
        FechaCalculo,
        EmpresaID,	        Usuario,			FechaActual,			DireccionIP,		ProgramaID,
        Sucursal,	        NumTransaccion
	)VALUES(
		Par_Fecha,			YEAR(Par_Fecha),	MONTH(Par_Fecha),		Par_ClienteID,		Par_TipoInstrumentoID,
        Par_InstrumentoID,	Par_Monto,			Par_FechaInicio,		Par_FechaFin,		Par_InteresGenerado,
        Par_ISR,		 	Par_TasaInteres,    Decimal_Cero,			Decimal_Cero,		Est_NoCalculado,
        Fecha_Vacia,
        Par_EmpresaID,      Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion
	);

END TerminaStore$$