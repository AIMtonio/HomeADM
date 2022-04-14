-- SP CONSTANCIARETAPORTAPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONSTANCIARETAPORTAPRO;

DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETAPORTAPRO`(
# ============================================================================
# --- PROCESO PARA OBTENER LOS INTERESES PAGADOS E ISR DE LAS APORTACIONES ---
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
    DECLARE RetISRAportacion	INT(11);
    DECLARE InstrumentoAporta	INT(11);

	DECLARE MovPagoIntGraFin	INT(11);
	DECLARE MovPagoIntExFin	    INT(11);
    DECLARE Nat_Abono			CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.00; 			-- Decimal Cero
	SET Salida_SI			:= 'S'; 			-- Salida Store: SI

	SET Salida_NO 			:= 'N'; 			-- Salida Store: NO
    SET MovPagoIntGra		:= 603;				-- Tipo de Movimiento: Pago APORTACIONES Interes Gravado
	SET MovPagoIntEx		:= 604;				-- Tipo de Movimiento: Pago APORTACIONES Interes Exento
    SET RetISRAportacion	:= 605;				-- Tipo de Movimiento: Retencion ISR APORTACIONES
    SET InstrumentoAporta	:= 31;				-- Tipo de Instrumento: APORTACIONES

	SET MovPagoIntGraFin	:= 606;				-- Tipo de Movimiento: Pago APORTACIONES Fin Mes Interes Gravado
	SET MovPagoIntExFin		:= 607;				-- Tipo de Movimiento: Pago APORTACIONES Fin Mes Interes Exento
    SET Nat_Abono			:= 'A';				-- Naturaleza de Movimiento : ABONO

	 ManejoErrores:BEGIN     #bloque para manejar los posibles errores
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		  SET Par_NumErr  = 999;
		  SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSTANCIARETAPORTAPRO');
		  SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Tabla temporal para obtener los Intereses pagadas en el periodo
		DROP TEMPORARY TABLE IF EXISTS TMPINTERESAPORTACIONES;
		CREATE TEMPORARY TABLE TMPINTERESAPORTACIONES (
            `RegistroID` 			BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			 ClienteID				INT(11)			COMMENT 'Numero de Cliente',
			 AportacionID        	INT(11)			COMMENT 'Numero de Aportacion',
			 InteresGravado     	DECIMAL(18,2)	COMMENT 'Monto de Interes Gravado',
			 InteresExento			DECIMAL(18,2)	COMMENT 'Monto Interes Exento',
             Monto					DECIMAL(18,2)	COMMENT 'Monto de la Aportacion');

		CREATE INDEX IDX_TMPINTERESAPORTACIONES ON TMPINTERESAPORTACIONES (ClienteID,AportacionID);

        -- Se obtienen los Intereses pagadas en el periodo
        INSERT INTO TMPINTERESAPORTACIONES(
				ClienteID,		AportacionID,		InteresGravado,		InteresExento,	  Monto)
		SELECT  Apo.ClienteID,  Apo.AportacionID,  SUM(CASE WHEN Mov.TipoMovAhoID IN(MovPagoIntGra,MovPagoIntGraFin) THEN Mov.CantidadMov ELSE Decimal_Cero END) AS InteresGravado,
				SUM(CASE WHEN Mov.TipoMovAhoID IN(MovPagoIntEx,MovPagoIntExFin) THEN Mov.CantidadMov ELSE Decimal_Cero END) AS InteresExento,
                Apo.Monto
		FROM `HIS-CUENAHOMOV` Mov,
			  APORTACIONES Apo
		WHERE Mov.TipoMovAhoID IN(MovPagoIntGra,MovPagoIntEx,MovPagoIntGraFin,MovPagoIntExFin)
			AND Mov.Fecha >= Par_IniMes
            AND Mov.Fecha <= Par_FinMes
			AND Mov.ReferenciaMov = Apo.AportacionID
			AND Mov.NatMovimiento = Nat_Abono
			GROUP BY Apo.AportacionID, Apo.ClienteID, Apo.Monto;

         -- Tabla temporal para obtener el ISR Cobrado en el periodo
		 DROP TEMPORARY TABLE IF EXISTS TMPCOBROISRAPORTACIONES;
		 CREATE TEMPORARY TABLE TMPCOBROISRAPORTACIONES(
            `RegistroID` 	BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			ClienteID		INT(11)			COMMENT 'Numero de Cliente',
			AportacionID    INT(11)			COMMENT 'Numero de Aportacion',
			ISR   			DECIMAL(18,2)	COMMENT 'Monto del ISR');

		CREATE INDEX IDX_TMPCOBROISRAPORTACIONES ON TMPCOBROISRAPORTACIONES (ClienteID,AportacionID);

		INSERT INTO TMPCOBROISRAPORTACIONES(
				ClienteID,		AportacionID,		ISR)
		SELECT  Apo.ClienteID,  Apo.AportacionID,  SUM(Mov.CantidadMov)
		FROM `HIS-CUENAHOMOV` Mov,
			  APORTACIONES Apo
		WHERE Mov.TipoMovAhoID = RetISRAportacion
			AND Mov.Fecha >= Par_IniMes
            AND Mov.Fecha <= Par_FinMes
			AND Mov.ReferenciaMov = Apo.AportacionID
			GROUP BY Apo.AportacionID, Apo.ClienteID;

        SET Aud_FechaActual := NOW();

		-- Se registra los Intereses pagados en el periodo
		INSERT INTO CONSTANCIARETENCION(
				ClienteID,			Anio,				Mes,				TipoInstrumentoID,	InstrumentoID,
                Monto,				InteresGravado,		InteresExento,		InteresRetener,		Ajuste,
                InteresReal,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
                ProgramaID,			Sucursal,			NumTransaccion)
		SELECT  ClienteID,			Par_Anio,			Par_Mes,			InstrumentoAporta,	AportacionID,
				Monto,				InteresGravado,		InteresExento,		Decimal_Cero,		Decimal_Cero,
                Decimal_Cero,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion
        FROM TMPINTERESAPORTACIONES;

        -- Se actualiza el monto del ISR de las APORTACIONES del periodo
		UPDATE CONSTANCIARETENCION Con,
			   TMPCOBROISRAPORTACIONES Cob
		SET Con.InteresRetener = Cob.ISR
		WHERE Con.InstrumentoID = Cob.AportacionID
        AND Con.TipoInstrumentoID = InstrumentoAporta
        AND Con.Anio = Par_Anio
        AND Con.Mes = Par_Mes;

        UPDATE CONSTANCIARETENCION Con,
			   HISCALINTERESREAL His
		SET Con.Ajuste = His.Ajuste,
			Con.InteresReal = His.InteresReal
		WHERE Con.TipoInstrumentoID = His.TipoInstrumentoID
		AND Con.InstrumentoID = His.InstrumentoID
		AND Con.TipoInstrumentoID = InstrumentoAporta
		AND Con.Anio = Par_Anio
		AND Con.Ajuste = Decimal_Cero
		AND Con.InteresReal = Decimal_Cero;

		UPDATE CONSTANCIARETENCION Cons,
				AMORTIZAAPORT Amor
		SET Cons.Monto = Amor.SaldoCap
		WHERE Cons.InstrumentoID = Amor.AportacionID
		AND Cons.Anio = YEAR(Amor.FechaPago)
		AND Cons.Mes = MONTH(Amor.FechaPago)
		AND Cons.TipoInstrumentoID = InstrumentoAporta
		AND Cons.Anio = Par_Anio
        AND Cons.Mes = Par_Mes;

		UPDATE CONSTANCIARETENCION Cons,
			   TMPINTERESAPORTACIONES Tmp
		SET Cons.Monto = Tmp.Monto
        WHERE Cons.InstrumentoID = Tmp.AportacionID
        AND Cons.TipoInstrumentoID = InstrumentoAporta
		AND Cons.Anio = Par_Anio
        AND Cons.Mes = Par_Mes
        AND Cons.Monto = Decimal_Cero;

        UPDATE CALCULOINTERESREAL Cal,
			   CONSTANCIARETENCION Cons
		SET Cal.Monto = Cons.Monto
		WHERE Cal.InstrumentoID = Cons.InstrumentoID
		AND Cal.TipoInstrumentoID = Cons.TipoInstrumentoID
		AND Cal.Anio = Cons.Anio
		AND Cal.Mes = Cons.Mes
		AND Cal.TipoInstrumentoID = InstrumentoAporta
		AND Cal.Anio = Par_Anio
        AND Cal.Mes = Par_Mes;

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