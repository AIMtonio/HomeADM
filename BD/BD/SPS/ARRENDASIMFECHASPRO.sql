-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDASIMFECHASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDASIMFECHASPRO`;DELIMITER $$

CREATE PROCEDURE `ARRENDASIMFECHASPRO`(
	-- STORED PROCEDURE PARA GENERAR EL CALENDARIO DE PAGOS
	Par_FechaApertura		DATE,					-- FECHA DE APERTURA
	Par_Periodicidad		CHAR(1),				-- PERIODICIDAD MENSUAL(M)
	Par_DiasPago			CHAR(1),				-- DIAS DE PAGO FIN DE MES(F) O POR ANIVERSARIO (A)
	Par_Plazo				INT(11),				-- PLAZO (NUMERO DE CUOTAS)
	Par_DiaHabil			CHAR(1),				-- INDICA SI SE TRATA DE UN DIA HABIL SIGUIENTE (S)

	Par_DiasEntreCuotas		INT(11),				-- NUMERO DE DIAS QUE DEBEN DE EXISTIR ENTRE CADA CUOTA

	Par_Salida				CHAR(1),				-- Salida Si o No
	INOUT Par_NumErr		INT(11),				-- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),			-- Control de Errores: Descripcion del Error

	Aud_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control         VARCHAR(100);       -- Variable de control
	DECLARE Var_Contador        INT(11);            -- CONTADOR PARA WHILE
	DECLARE Var_FechaVencim     DATE;               -- VARIABLE PARA VALOR FECHA DE VENCIMIENTO
	DECLARE Var_FechaFinal      DATE;               -- VARIABLE PARA VALOR FECHA FINAL
	DECLARE Var_FechaInicio     DATE;               -- VARIABLE PARA VALOR FECHA DE INICIO
	DECLARE Var_FechaExi        DATE;               -- VARIABLE PARA VALOR FECHA EXIGIBLE
	DECLARE Var_Dias            INT;                -- NUMERO DE DIAS QUE HAY ENTRE LA FECHA DE INICIO Y FIN
	DECLARE Var_EsHabil         CHAR(1);			-- Es habil

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE Entero_Cero			INT(11);			-- Entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);		-- Decimal cero
	DECLARE Var_SI				CHAR(1);			-- SI
	DECLARE Var_No				CHAR(1);			-- NO
	DECLARE Var_PagoMensual		CHAR(1);			-- Pago Mensual (M)
	DECLARE Var_FinMes			CHAR(1);			-- Pago FIN DE MES (F)
	DECLARE Var_Aniver			CHAR(1);			-- Pago ANIVERSARIO (A)

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero en Cero
	SET Decimal_Cero			:= 0.00;			-- DECIMAL CERO
	SET Var_SI					:= 'S';				-- Variable para  SI
	SET Var_No					:= 'N';				-- Variable para  NO
	SET Var_PagoMensual			:= 'M';				-- Var_PagoMensual
	SET Var_FinMes				:= 'F';				-- Pago FIN DE MES (F)
	SET Var_Aniver				:= 'A';				-- Pago ANIVERSARIO (A)

	-- ASIGNACION DE VARIABLES
	SET Aud_FechaActual			:= NOW();

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-ARRENDASIMFECHASPRO');
				SET Var_Control = 'sqlException';
			END;

	-- SE LIMPIA LA TABLA DE PASO EN CASO DE QUE EXISTAN REGISTROS CON EL MISMOS NUMERO DE TRANSACCION
	DELETE
		FROM TMPARRENDAPAGOSIM
		WHERE	NumTransaccion = Aud_NumTransaccion;

	-- Se calcula la fecha de vencimiento en base al numero de cuotas recibidas y a la periodicidad
	CASE Par_Periodicidad
		WHEN Var_PagoMensual THEN SET Var_FechaVencim := (SELECT DATE_ADD(Par_FechaApertura, INTERVAL Par_Plazo MONTH));
	END CASE;

	SET Var_FechaInicio		:= Par_FechaApertura;
	-- SE INICIALIZA CONTADOR
	SET Var_Contador		:= 1;
	-- se calculan las Fechas
	WHILE (Var_Contador <= Par_Plazo) DO
		CASE Par_Periodicidad
			WHEN Var_PagoMensual THEN -- Pagos Mensuales
				-- Para pagos que se haran por aniversario
				CASE Par_DiasPago
					WHEN Var_FinMes THEN -- Pagos Mensuales en fin de mes
						-- Para pagos que se haran cada fin de mes
						IF (DAY(Var_FechaInicio)>=28)THEN
							SET Var_FechaFinal := DATE_ADD(Var_FechaInicio, INTERVAL 2 MONTH);
							SET Var_FechaFinal := DATE_ADD(Var_FechaFinal, INTERVAL -1*CAST(DAY(Var_FechaFinal)AS SIGNED) DAY);
						ELSE
						-- si no indica que es un numero menor y se obtiene el final del mes.
							SET Var_FechaFinal:= DATE_ADD(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(Par_FechaApertura) DAY);
						END IF;

					WHEN Var_Aniver THEN -- Pagos Mensuales por aniversario
						SET Var_FechaFinal := CONVERT(CONCAT(
								YEAR(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH)), '-' ,
									MONTH(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH)), '-' , DAY(Par_FechaApertura)), DATE);
				END CASE;
		END CASE;

		-- SE VALIDA SI LA FECHA QUE SE OBTUVO CAE O NO EN DIA INHABIL
		IF(Par_DiaHabil = Var_SI) THEN
			CALL DIASFESTIVOSCAL(
				Var_FechaFinal,         Entero_Cero,        Var_FechaExi,           Var_EsHabil,        Aud_EmpresaID,
				Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);
		END IF;


		-- SE VALIDAN LOS DIAS DE GRACIA O DIAS MINIMOS QUE DEBE DE HABER ENTRE CUOTAS
		WHILE (DATEDIFF(Var_FechaExi, Par_FechaApertura) < Par_DiasEntreCuotas) DO
			CASE Par_Periodicidad
				WHEN Var_PagoMensual THEN -- Pagos Mensuales
					-- Para pagos que se haran por aniversario
					CASE Par_DiasPago
						WHEN Var_FinMes THEN -- Pagos Mensuales en fin de mes
							IF ((CAST(DAY(Var_FechaFinal)AS SIGNED)*1)>=28)THEN
								SET Var_FechaFinal	:= DATE_ADD(Var_FechaFinal, INTERVAL 2 MONTH);
								SET Var_FechaFinal	:= DATE_ADD(Var_FechaFinal, INTERVAL -1*DAY(Var_FechaFinal) DAY);
							ELSE
								SET Var_FechaFinal	:= DATE_ADD(DATE_ADD(Var_FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(Par_FechaApertura) DAY);
							END IF;
					END CASE;
			END CASE;

			-- SE VALIDA SI LA FECHA QUE SE OBTUVO CAE O NO EN DIA INHABIL
			IF(Par_DiaHabil = Var_SI) THEN
				CALL DIASFESTIVOSCAL(
					Var_FechaFinal,			Entero_Cero,		Var_FechaExi,			Var_EsHabil,		Aud_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);
			END IF;

			-- SE VALIDA SI LA FECHA QUE SE OBTUVO CAE O NO EN DIA INHABIL
			IF(Par_DiaHabil = Var_SI) THEN
				CALL DIASFESTIVOSCAL(
					Var_FechaFinal,			Entero_Cero,		Var_FechaExi,			Var_EsHabil,		Aud_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);
			END IF;

			SET Var_FechaFinal	:= Var_FechaExi;
		END WHILE;

		SET Var_Dias	:= (DATEDIFF(Var_FechaExi,Var_FechaInicio));

		INSERT INTO TMPARRENDAPAGOSIM(
			Tmp_Consecutivo,		Tmp_Dias,				Tmp_FecIni,				Tmp_FecFin,			Tmp_FecExi,
			Tmp_Capital,			Tmp_Interes,			Tmp_Renta,				Tmp_Iva,			Tmp_Insoluto,
			Tmp_MontoSeg,			Tmp_MontoSegVida,		Tmp_PagoTotal,			EmpresaID,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion)
		VALUES(
			Var_Contador,			Var_Dias,				Var_FechaInicio,		Var_FechaFinal,		Var_FechaExi,
			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,		Decimal_Cero,
			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_FechaInicio	:= Var_FechaFinal;
		SET Var_Contador	:= Var_Contador + 1;

	END WHILE;

	-- se determina cual es la fecha de vencimiento
	SET Var_FechaVencim	:= (SELECT	MAX(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE	NumTransaccion = Aud_NumTransaccion);

	SET Par_NumErr		:= 0;
	SET Par_ErrMen		:= 'El Calendario se Ejecuto Exitosamente';

	END ManejoErrores;

	-- Se muestran los datos
	IF (Par_Salida = Var_SI) THEN
		SELECT  Tmp_Consecutivo,			Tmp_Dias,					Tmp_FecIni,				Tmp_FecFin,				Tmp_FecExi,
				FORMAT(Tmp_Capital,2),		FORMAT(Tmp_Interes,2),		FORMAT(Tmp_Renta,2),	FORMAT(Tmp_Iva,2),		FORMAT(Tmp_Insoluto,2),
				FORMAT(Tmp_PagoTotal,2),	EmpresaID,					Usuario,				FechaActual,			DireccionIP,
				ProgramaID,					Sucursal,					NumTransaccion
			FROM TMPARRENDAPAGOSIM
			WHERE	NumTransaccion = Aud_NumTransaccion;
	END IF;
END TerminaStore$$