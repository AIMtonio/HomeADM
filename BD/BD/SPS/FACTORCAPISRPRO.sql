-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTORCAPISRPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTORCAPISRPRO`;
DELIMITER $$


CREATE PROCEDURE `FACTORCAPISRPRO`(
# ====================================================================
# SP ENCARGADO DE GENERAR EL PORCENTAJE DEL ISR POR PRODUCTO Y PERIODO
# ====================================================================
	Par_Fecha			DATE,				-- Fecha De Registro
	Par_FechaOperacion	DATE,				-- Fecha de Operacion
	Par_Dias			INT(11),			-- Numero de Dias a Sumar para el Saldo Promedio puede se 1 o 0
	Par_TipoRegistro	CHAR(1),			-- Nombre del Proceso
    Par_AjusteCien		CHAR(1),			-- Indica si es necesario realizar un ajuste al 100%
	Par_Salida			CHAR(1),			-- Tipo de Salida.

	INOUT Par_NumErr	INT(11),			-- Numero de Error.
	INOUT Par_ErrMen	VARCHAR(400),    	-- Mensaje de Error.
	/* Parámetros de Auditoría */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	CadenaVacia			CHAR(1);
DECLARE EnteroCero			INT(1);
DECLARE DecimalCero			DECIMAL(12,2);
DECLARE FechaVacia			DATE;
DECLARE SalidaSI			CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE Const_NO			CHAR(1);
DECLARE Const_SI			CHAR(1);
DECLARE PagaISRSI			CHAR(1);
DECLARE InstAhorro			INT(1);
DECLARE InstInversion		INT(1);
DECLARE InstCedes			INT(1);
DECLARE EstatusPENDiente	CHAR(1);
DECLARE Est_NoAplicado		CHAR(1);
DECLARE Est_Calculado		CHAR(1);
DECLARE EnteroUno			INT(1);
DECLARE ValorUMA			VARCHAR(12);		-- Constante para el valor de UMA

-- Declaracion de Variables
DECLARE InicioMes			DATE;				-- Inicio de Mes
DECLARE	Fre_DiasAnio		INT(11);			-- Dias de PARAMETROSSIS
DECLARE Var_SalMinDF		DECIMAL(14,2);		-- Salario del DF
DECLARE Var_SalMinAn		DECIMAL(14,2);		-- Salario Minimo Anualizado
DECLARE VarTasaIsrGen		DECIMAL(12,2);		-- Tasa ISR de PARAMETROSSIS
DECLARE Var_Control			VARCHAR(50);		-- Control ID


-- Asignacion de Constantes
SET	CadenaVacia			:= '';					-- Cadena Vacia
SET	EnteroCero			:= 0;					-- Entero en cero
SET	DecimalCero			:= 0.00;				-- Decimal en cero
SET	FechaVacia			:= '1900-01-01';		-- Fecha Vacia
SET	SalidaSI			:= 'S';					-- El Store si regresa una Salida
SET SalidaNO			:= 'N';					-- El Store no regresa una Salida
SET Const_NO			:= 'N';					-- Constante NO
SET Const_SI			:= 'S';					-- Constante SI
SET	InstAhorro			:= 2;					-- Instrumento de CUENTA AHORRO
SET	InstInversion		:= 13;					-- Instrumento de INVERSION PLAZO
SET	InstCedes			:= 28;					-- Instrumento de CEDE
SET EstatusPENDiente	:= 'P';					-- Estatus Pendiente
SET Est_NoAplicado		:= 'N';					-- Estatus No Aplicado
SET Est_Calculado		:= 'C';					-- Estatus Calculado
SET PagaISRSI			:= 'S';					-- Paga ISR Si
SET EnteroUno   	    := 1;					-- Entero en Uno
SET Aud_FechaActual		:= NOW();				-- Fecha Actual
SET ValorUMA			:= 'ValorUMABase';		-- Valor UMA Base

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-FACTORCAPISRPRO');
				SET Var_Control := 'sqlException';
	END;

	DELETE FROM TMPFACTCAP;
	DELETE FROM TMPTOTALCAP;

    DELETE FROM FACTORCAPTACION where Fecha = Par_Fecha;

	# SE OBTIENEN LOS SALDOS PROMEDIOS DE CADA UNO DE LOS INSTRUMENTOS POR PERIODO
	INSERT IGNORE INTO FACTORCAPTACION(
		Fecha,				ClienteID,			InstrumentoID,		ProductoID,			Saldo,
		EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
		Sucursal,			NumTransaccion)
	SELECT
		Par_Fecha,			FAC.ClienteID,		InstInversion,		FAC.InversionID,	ROUND((SUM(FAC.Capital)/(datediff(max(COB.FinPeriodo),min(COB.InicioPeriodo))+1)),4),
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion
		FROM FACTORINVERSION FAC
			INNER JOIN COBROISR COB ON FAC.ClienteID = COB.ClienteID AND FAC.Fecha BETWEEN COB.InicioPeriodo AND COB.FinPeriodo
						AND COB.InstrumentoID = InstInversion
						AND FAC.InversionID = COB.ProductoID
		WHERE COB.InstrumentoID = InstInversion
			AND COB.Fecha = Par_Fecha
	GROUP BY FAC.ClienteID, FAC.InversionID
	UNION
	SELECT
		Par_Fecha,			FAC.ClienteID,		InstCedes,			FAC.CedeID,			ROUND((SUM(FAC.Capital)/(datediff(max(COB.FinPeriodo),min(COB.InicioPeriodo))+1)),4),
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion
		FROM FACTORCEDES FAC
			INNER JOIN COBROISR COB ON FAC.ClienteID = COB.ClienteID AND FAC.Fecha BETWEEN COB.InicioPeriodo AND COB.FinPeriodo
									AND COB.InstrumentoID = InstCedes
                                        AND FAC.CedeID = COB.ProductoID
		WHERE COB.InstrumentoID = InstCedes
			AND COB.Fecha = Par_Fecha
	GROUP BY FAC.ClienteID, FAC.CedeID
	UNION
	SELECT
		Par_Fecha,			FAC.ClienteID,		InstAhorro,			FAC.CuentaAhoID,	ROUND((SUM(FAC.Saldo)/(datediff(max(COB.FinPeriodo),min(COB.InicioPeriodo))+1)),4),
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion
		FROM FACTORAHORRO FAC
			INNER JOIN COBROISR COB ON FAC.ClienteID = COB.ClienteID AND FAC.Fecha BETWEEN COB.InicioPeriodo AND COB.FinPeriodo
									AND COB.InstrumentoID = InstAhorro
									AND FAC.CuentaAhoID = COB.ProductoID
		WHERE COB.InstrumentoID = InstAhorro
			AND COB.Fecha = Par_Fecha
	GROUP BY FAC.ClienteID, FAC.CuentaAhoID;

	# SE CALCULA EL PROMEDIO DEL SALDO DE CAPTACIÓN DEL PERIODO
	INSERT INTO TMPTOTALCAP(
		Fecha,	ClienteID,	SaldoCaptacion,	NumTransaccion)
	SELECT
		Par_Fecha,TC.ClienteID, AVG(TC.TotalCaptacion), Aud_NumTransaccion
		FROM TOTALCAPTACION TC
			INNER JOIN COBROISR COB ON TC.ClienteID = COB.ClienteID AND TC.Fecha BETWEEN COB.InicioPeriodo AND COB.FinPeriodo
		WHERE COB.Fecha = Par_Fecha
	GROUP BY TC.ClienteID;

	# SE ACTUALIZA EL PROMEDIO DE TODOS LOS CLIENTES
	UPDATE FACTORCAPTACION FC
		INNER JOIN TMPTOTALCAP TC ON FC.ClienteID = TC.ClienteID
	SET FC.TotalCaptacion = TC.SaldoCaptacion
	WHERE FC.Fecha = TC.Fecha
		AND FC.NumTransaccion = TC.NumTransaccion;

	# SE CALCULA EL PORCENJATE POR PRODUCTO
	UPDATE FACTORCAPTACION FC
	SET
		FC.Factor = IF(IFNULL(FC.TotalCaptacion, EnteroCero) != EnteroCero, (FC.Saldo/FC.TotalCaptacion), EnteroCero),
		FC.Estatus = Est_Calculado
	WHERE FC.NumTransaccion = Aud_NumTransaccion;

	IF Par_AjusteCien = Const_SI THEN
			# AUTO AJUSTE POR DIFERENCIA POR CLIENTE POR INSTRUMENTO CUANDO EL FACTOR NO SEA EXACTAMENTE EL 100% (1).
			# SE OBTIENE LA DIFERENCIA
			INSERT INTO TMPFACTCAP(
				Fecha,				ClienteID,	TotalFactor,	Diferencia,
				NumTransaccion)
			SELECT
				Fecha,				ClienteID,	SUM(Factor),	(SUM(Factor)-1),
				MIN(NumTransaccion)
			FROM FACTORCAPTACION
				WHERE NumTransaccion = Aud_NumTransaccion
			GROUP BY Fecha,	ClienteID
				HAVING SUM(Factor) != 1;

			# SE ACTUALIZA EL INSTRUMENTO Y EL PRODUCTO QUE SE VA A REAJUSTAR
			UPDATE FACTORCAPTACION FC
				INNER JOIN TMPFACTCAP TMP ON FC.Fecha = TMP.Fecha AND FC.ClienteID = TMP.ClienteID
			SET
				TMP.InstrumentoID = FC.InstrumentoID,
				TMP.ProductoID = FC.ProductoID
			WHERE FC.NumTransaccion = Aud_NumTransaccion
				AND TMP.NumTransaccion = Aud_NumTransaccion
				AND FC.Factor >= TMP.Diferencia;

			# SE ACTUALIZA EL FACTOR CON LA DIFERENCIA ANTES CALCULADA
			UPDATE FACTORCAPTACION FC
				INNER JOIN TMPFACTCAP TMP ON FC.Fecha = TMP.Fecha
				AND FC.ClienteID = TMP.ClienteID
				AND FC.InstrumentoID = TMP.InstrumentoID
				AND FC.ProductoID = TMP.ProductoID
			SET
				FC.Factor = (FC.Factor - (TMP.Diferencia))
			WHERE FC.NumTransaccion = Aud_NumTransaccion
				AND TMP.NumTransaccion = Aud_NumTransaccion;

    END IF;

	# SE ACTUALIZA EL NUEVO FACTOR EN COBROISR
	UPDATE COBROISR C
		INNER JOIN FACTORCAPTACION F ON (C.Fecha = F.Fecha AND C.ClienteID = F.ClienteID
											AND C.InstrumentoID = F.InstrumentoID AND C.ProductoID = F.ProductoID)
	SET
		C.Factor = F.Factor
	WHERE C.Fecha = Par_Fecha
		AND F.NumTransaccion = Aud_NumTransaccion;

	SET Par_NumErr := 0;
	SET Par_ErrMen := 'Calculo de Factores ISR Exitoso';


END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen	 		 AS ErrMen,
			Var_Control 		 AS Control;
	END IF;

END TerminaStore$$