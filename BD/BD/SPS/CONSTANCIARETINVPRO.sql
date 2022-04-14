-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSTANCIARETINVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSTANCIARETINVPRO`;
DELIMITER $$


CREATE PROCEDURE `CONSTANCIARETINVPRO`(
# ============================================================================
# --- PROCESO PARA OBTENER LOS INTERESES PAGADOS E ISR DE LAS INVERSIONES ----
# ============================================================================
	Par_Anio			INT(11),			-- Anio Constancia de Retencion
	Par_Mes    			INT(11),			-- Mes Constancia de Retencion
	Par_IniMes			DATE,				-- Fecha Inicio Mes
	Par_FinMes			DATE,				-- Fecha Fin Mes

	Par_Salida			CHAR(1),			-- Indica si espera un SELECT de salida
	INOUT Par_NumErr 	INT(11),			-- Numero de Error
	INOUT Par_ErrMen 	VARCHAR(400), 		-- Descripcion de Error

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria

)

TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control 		VARCHAR(100);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Salida_SI 			CHAR(1);

	DECLARE Salida_NO 			CHAR(1);
    DECLARE MovPagoIntGra		INT(11);
	DECLARE MovPagoIntEx		INT(11);
    DECLARE RetISRInv			INT(11);
    DECLARE InstrumentoInv		INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.00; 			-- Decimal Cero
	SET Salida_SI			:= 'S'; 			-- Salida Store: SI

	SET Salida_NO 			:= 'N'; 			-- Salida Store: NO
    SET MovPagoIntGra		:= 62;				-- Tipo de Movimiento: Pago Inversion Interes Gravado
	SET MovPagoIntEx		:= 63;				-- Tipo de Movimiento: Pago Inversion Interes Exento
    SET RetISRInv			:= 64;				-- Tipo de Movimiento: Retencion ISR Inversion
    SET InstrumentoInv		:= 13;				-- Tipo de Instrumento: Inversiones

	 ManejoErrores:BEGIN     #bloque para manejar los posibles errores
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		  SET Par_NumErr  = 999;
		  SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETINVPRO');
		  SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Aud_FechaActual := NOW();

		-- Se registra los Intereses pagados en el periodo
		INSERT INTO CONSTANCIARETENCION(
				ClienteID,			Anio,				Mes,			TipoInstrumentoID,	InstrumentoID,
                Monto,				InteresGravado,		InteresExento,		InteresRetener,		Ajuste,
                InteresReal,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
                ProgramaID,			Sucursal,			NumTransaccion)
		SELECT  Inv.ClienteID,		Par_Anio,			Par_Mes,		InstrumentoInv,		Inv.InversionID,
				Inv.Monto,			SUM(CASE WHEN Mov.TipoMovAhoID = MovPagoIntGra THEN Mov.CantidadMov ELSE Decimal_Cero END) AS InteresGravado,
                SUM(CASE WHEN Mov.TipoMovAhoID = MovPagoIntEx THEN Mov.CantidadMov ELSE Decimal_Cero END) AS InteresExento,
				SUM(CASE WHEN Mov.TipoMovAhoID = RetISRInv THEN Mov.CantidadMov ELSE Decimal_Cero END) AS ISR,	Decimal_Cero,
                Decimal_Cero,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion
        FROM `HIS-CUENAHOMOV` Mov,
			  INVERSIONES Inv
		WHERE Mov.TipoMovAhoID IN(MovPagoIntGra,MovPagoIntEx,RetISRInv)
			AND Mov.Fecha >= Par_IniMes
            AND Mov.Fecha <= Par_FinMes
			AND Mov.ReferenciaMov = Inv.InversionID
			GROUP BY Inv.InversionID, Inv.ClienteID;

		UPDATE CONSTANCIARETENCION Con,
			   HISCALINTERESREAL His
		SET Con.Ajuste = His.Ajuste,
			Con.InteresReal = His.InteresReal
		WHERE Con.TipoInstrumentoID = His.TipoInstrumentoID
		AND Con.InstrumentoID = His.InstrumentoID
		AND Con.TipoInstrumentoID = InstrumentoInv
		AND Con.Anio = Par_Anio
		AND Con.Ajuste = Decimal_Cero
		AND Con.InteresReal = Decimal_Cero;

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= 'Proceso Finalizado Exitosamente.';
		SET Var_Control 	:= Cadena_Vacia;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$