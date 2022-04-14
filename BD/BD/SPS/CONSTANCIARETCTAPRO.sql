-- SP CONSTANCIARETCTAPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETCTAPRO;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETCTAPRO`(
# ============================================================================
# ----- PROCESO PARA OBTENER LOS INTERESES PAGADOS E ISR DE LAS CUENTAS ------
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
    DECLARE MovPagoRenCtaGra	INT(11);
    DECLARE MovPagoRenCtaEx	    INT(11);
    DECLARE RetISRCta			INT(11);
    DECLARE InstrumentoCta		INT(11);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.00; 			-- Decimal Cero
	SET Salida_SI			:= 'S'; 			-- Salida Store: SI

	SET Salida_NO 			:= 'N'; 			-- Salida Store: NO
    SET MovPagoRenCtaGra	:= 200;				-- Tipo de Movimiento: Pago Rendimiento Cuenta Gravado
	SET MovPagoRenCtaEx		:= 201;				-- Tipo de Movimiento: Pago Rendimiento Cuenta Exento
    SET RetISRCta			:= 220;				-- Tipo de Movimiento: Retencion ISR Cuentas
    SET InstrumentoCta		:= 2;				-- Tipo de Instrumento: Cuenta de Ahorro

	 ManejoErrores:BEGIN     #bloque para manejar los posibles errores
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		  SET Par_NumErr  = 999;
		  SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETCTAPRO');
		  SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Aud_FechaActual := NOW();

		-- Se registra los Intereses pagados en el periodo
		INSERT INTO CONSTANCIARETENCION(
				ClienteID,			Anio,				Mes,			TipoInstrumentoID,	InstrumentoID,
                Monto,				InteresGravado,		InteresExento,		InteresRetener,		Ajuste,
                InteresReal,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
                ProgramaID,			Sucursal,			NumTransaccion)
       	SELECT  Cta.ClienteID,		Par_Anio,			Par_Mes,			InstrumentoCta,		Mov.CuentaAhoID,
				Decimal_Cero,		SUM(CASE WHEN Mov.TipoMovAhoID = MovPagoRenCtaGra THEN Mov.CantidadMov ELSE Decimal_Cero END) AS InteresGravado,
				SUM(CASE WHEN Mov.TipoMovAhoID = MovPagoRenCtaEx THEN Mov.CantidadMov ELSE Decimal_Cero END) AS InteresExento,
                SUM(CASE WHEN Mov.TipoMovAhoID = RetISRCta THEN Mov.CantidadMov ELSE Decimal_Cero END) AS ISR,	Decimal_Cero,
                Decimal_Cero,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion
        FROM `HIS-CUENAHOMOV` Mov,
			  CUENTASAHO Cta
		WHERE Mov.TipoMovAhoID IN(MovPagoRenCtaGra,MovPagoRenCtaEx,RetISRCta)
			AND Mov.Fecha >= Par_IniMes
            AND Mov.Fecha <= Par_FinMes
			AND Mov.CuentaAhoID = Cta.CuentaAhoID
			GROUP BY Mov.CuentaAhoID, Cta.ClienteID;

        -- SE ELIMINA LA TABLA TEMPORAL
		DELETE FROM TMPSALDOPROMCUENTAS;

		INSERT INTO TMPSALDOPROMCUENTAS(
			CuentaAhoID,	SaldoPromedio,	EmpresaID,		Usuario,		FechaActual,
            DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
		SELECT
			CuentaAhoID,	SUM(SaldoProm),	Par_EmpresaID, 	Aud_Usuario,	Aud_FechaActual,
            Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion
		FROM `HIS-CUENTASAHO`
		WHERE Fecha >= Par_IniMes
		AND Fecha <= Par_FinMes
		GROUP BY CuentaAhoID;

        -- Se actualiza el monto del Saldo promedio de las cuentas
		UPDATE CONSTANCIARETENCION Con,
			   TMPSALDOPROMCUENTAS Tmp
		SET Con.Monto = Tmp.SaldoPromedio
		WHERE Con.InstrumentoID = Tmp.CuentaAhoID
        AND Con.TipoInstrumentoID = InstrumentoCta
        AND Con.Anio = Par_Anio
		AND Con.Mes = Par_Mes;

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