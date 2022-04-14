-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOINTERESREALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULOINTERESREALPRO`;
DELIMITER $$


CREATE PROCEDURE `CALCULOINTERESREALPRO`(
# ====================================================================
# ------------- PROCESO PARA EL CALCULO DEL INTERES REAL -------------
# ====================================================================
	Par_Fecha				DATE,				-- Fecha de Calculo
	Par_TipoInstrumentoID	INT(11),			-- Tipo de Instrumento: 2 = Cuentas 13 = Inversiones 28 = Cedes

    Par_Salida				CHAR(1),			-- Indica si espera un SELECT de salida
	INOUT Par_NumErr 		INT(11),			-- Numero de Error
	INOUT Par_ErrMen 		VARCHAR(400), 		-- Descripcion de Error

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria

)

TerminaStore:BEGIN

	-- Declaracion de Variables
    DECLARE Var_TipoInstrumentoID	INT(11);		-- Almacene el Tipo de Instrumento
    DECLARE Var_InstrumentoID	BIGINT(12);			-- Almacena el Numero de Instrumento
    DECLARE Var_Monto			DECIMAL(18,2);		-- Monto del Instrumento
    DECLARE Var_FechaInicio		DATE;				-- Fecha de Inicio
    DECLARE Var_FechaFin		DATE;				-- Fecha de Fin

    DECLARE Var_Control 		VARCHAR(100);		-- Control de Errores
    DECLARE Var_ValorINPC		DECIMAL(12,3);		-- Almacena el valor del Idice Nacional de Precios al Consumidor
    DECLARE Var_ClienteID		INT(11);			-- Numero de Cliente
    DECLARE Var_Fecha			DATE;				-- Fecha de Registro
    DECLARE Var_InteresReal		DECIMAL(18,2);		-- Valor del Interes Real

    DECLARE Var_Ajuste			DECIMAL(18,2);		-- Valor del Ajuste
    DECLARE Var_Anio			INT(11);			-- Valor del Anio
	DECLARE Var_Mes				INT(11);			-- Valor del Mes
    DECLARE Var_FechaSistema	DATE;				-- Fecha del Sistema
    DECLARE Var_ConsecutivoID	INT(11);			-- Almacena el Numero Consecutivo

    DECLARE Var_NumRegistros	INT(11);			-- Numero de Registros
    DECLARE Var_Contador		INT(11);			-- Almacena el Contador
    DECLARE Var_FechaInicial	DATE;				-- Fecha Inicial del Anio Anterior

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE InstrumentoCta		INT(11);

    DECLARE InstrumentoInv		INT(11);
    DECLARE Est_NoCalculado	    CHAR(1);
    DECLARE Est_Calculado	    CHAR(1);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Salida_SI			CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.00; 			-- Decimal Cero
	SET InstrumentoCta		:= 2;				-- Tipo de Instrumento: Cuentas

    SET InstrumentoInv		:= 13;				-- Tipo de Instrumento: Inversiones
    SET Est_NoCalculado		:= 'N';				-- Estatus del Calculo de Interes Real: No calculado
	SET Est_Calculado		:= 'C';				-- Estatus del Calculo de Interes Real: Calculado
	SET Salida_NO 			:= 'N';				-- Salida No
	SET Salida_SI        	:= 'S';				-- Salida Si

	ManejoErrores:BEGIN     #bloque para manejar los posibles errores

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		  SET Par_NumErr  = 999;
		  SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-CALCULOINTERESREALPRO');
		  SET Var_Control = 'SQLEXCEPTION';
		END;

        SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_FechaInicial := CONCAT((YEAR(Var_FechaSistema)-1),'-01-01');

        -- Se elimina la tabla temporal
		DELETE FROM TMPCALCULOINTERESREAL;
		SET @Var_ConsecutivoID := 0;

        -- Se obtiene informacion para el calculo del interes real
		INSERT INTO TMPCALCULOINTERESREAL(
			ConsecutivoID,		Fecha,			Anio,			Mes,			ClienteID,
            TipoInstrumentoID,	InstrumentoID,	Monto,			FechaInicio,	FechaFin,
            EmpresaID,			Usuario,		FechaActual,	DireccionIP,	ProgramaID,
            Sucursal,			NumTransaccion)
		SELECT
			@Var_ConsecutivoID:=@Var_ConsecutivoID+1, Fecha,	Anio,	Mes,	ClienteID,
            TipoInstrumentoID,	InstrumentoID,	Monto,			FechaInicio, 	FechaFin,
            Par_EmpresaID, 		Aud_Usuario,	Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,
            Aud_Sucursal,      	Aud_NumTransaccion
		FROM CALCULOINTERESREAL
		WHERE TipoInstrumentoID = Par_TipoInstrumentoID
		AND Estatus = Est_NoCalculado
		AND FechaFin BETWEEN Var_FechaInicial AND Var_FechaSistema;

		-- Se obtiene el Numero de Registros para realizar el Calculo del Ajuste e Interes Real
		SET Var_NumRegistros := (SELECT COUNT(ConsecutivoID) FROM TMPCALCULOINTERESREAL);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

		-- Se valida que el Numero de Registros para realizar el Calculo del Ajuste e Interes Real sea mayor a Cero
		IF(Var_NumRegistros > Entero_Cero)THEN

           -- Se inicializa el Contador
			SET Var_Contador := 1;

			-- Se realiza el ciclo para el Calculo del Ajuste e Interes Real
			WHILE(Var_Contador <= Var_NumRegistros) DO
				SELECT	Fecha,				Anio,		Mes,			ClienteID,		TipoInstrumentoID,
						InstrumentoID,		Monto,		FechaInicio,	FechaFin
				INTO    Var_Fecha,			Var_Anio,	Var_Mes,		Var_ClienteID,	Var_TipoInstrumentoID,
						Var_InstrumentoID,	Var_Monto,	Var_FechaInicio,Var_FechaFin
				FROM TMPCALCULOINTERESREAL
				WHERE ConsecutivoID = Var_Contador;

                -- Se obtiene el valor del INPC del mes y anio para el Caluclo del Interes Real
                SET Var_ValorINPC := (SELECT IFNULL(ValorINPC,Decimal_Cero) FROM INDICENAPRECONS WHERE Anio = Var_Anio AND Mes = Var_Mes);

                -- Se realiza el Calculo del Ajuste e Interes Real cuando encuentre el valor del INPC
                IF(Var_ValorINPC <> Decimal_Cero)THEN
					CALL CALCULOAJUSTEINPCPRO(
						Var_Fecha,			Var_ClienteID,		Var_TipoInstrumentoID,		Var_InstrumentoID,		Var_Monto,
						Var_FechaInicio,	Var_FechaFin,		Salida_NO,					Par_NumErr,				Par_ErrMen,
                        Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
                        Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

                    -- Se actualiza el valor del Interes Real
					UPDATE CALCULOINTERESREAL SET
						InteresReal = InteresGenerado - Ajuste,
						Estatus = Est_Calculado,
						FechaCalculo = Par_Fecha,
                        EmpresaID = Par_EmpresaID,
                        Usuario = Aud_Usuario,
                        FechaActual = NOW(),
                        DireccionIP = Aud_DireccionIP,
                        ProgramaID = Aud_ProgramaID,
                        Sucursal = Aud_Sucursal,
                        NumTransaccion = Aud_NumTransaccion
					WHERE Fecha = Var_Fecha
						AND ClienteID = Var_ClienteID
						AND TipoInstrumentoID = Var_TipoInstrumentoID
						AND InstrumentoID = Var_InstrumentoID;

                    -- Se obtiene el valor del Ajuste e Interes Real
                    SELECT InteresReal, Ajuste INTO Var_InteresReal, Var_Ajuste
                    FROM CALCULOINTERESREAL
                    WHERE Fecha = Var_Fecha
						AND ClienteID = Var_ClienteID
						AND TipoInstrumentoID = Var_TipoInstrumentoID
						AND InstrumentoID = Var_InstrumentoID;

					-- Se actualiza el valor del Ajuste e Interes Real en la tabla CONSTANCIARETENCION para mostrarlo en la Constancia de Retencion Anual
                    UPDATE CONSTANCIARETENCION SET
						Ajuste = Var_Ajuste,
						InteresReal = Var_InteresReal,
                        EmpresaID = Par_EmpresaID,
                        Usuario = Aud_Usuario,
                        FechaActual = NOW(),
                        DireccionIP = Aud_DireccionIP,
                        ProgramaID = Aud_ProgramaID,
                        Sucursal = Aud_Sucursal,
                        NumTransaccion = Aud_NumTransaccion
					WHERE ClienteID = Var_ClienteID
						AND Anio = Var_Anio
						AND Mes = Var_Mes
						AND TipoInstrumentoID = Var_TipoInstrumentoID
						AND InstrumentoID = Var_InstrumentoID;

                END IF; -- FIN se realiza el Calculo del Ajuste e Interes Real cuando encuentre el valor del INPC

				SET Var_Contador := Var_Contador + 1;

			END WHILE; -- FIN del WHILE

        END IF; -- FIN Se valida que el Numero de Registros para realizar el Calculo del Ajuste e Interes Real sea mayor a Cero

		-- Se envia al historico los Intereses Reales Calculados
		INSERT INTO HISCALINTERESREAL(
				Fecha,				Anio,				Mes,					ClienteID, 			TipoInstrumentoID,
				InstrumentoID, 		Monto,				FechaInicio,			FechaFin,			InteresGenerado,
				ISR,				TasaInteres,		Ajuste,					InteresReal,		Estatus,
				FechaCalculo,
				EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
		SELECT  Fecha,				Anio,				Mes,					ClienteID, 			TipoInstrumentoID,
				InstrumentoID, 		Monto,				FechaInicio,			FechaFin,			InteresGenerado,
				ISR,				TasaInteres,		Ajuste,					InteresReal,		Estatus,
				FechaCalculo,
				EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion
		FROM CALCULOINTERESREAL
		WHERE Estatus = Est_Calculado;

		DELETE FROM CALCULOINTERESREAL WHERE Estatus = Est_Calculado;


		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Calculo de Interes Real Realizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen	AS ErrMen;
	END IF;

END TerminaStore$$