-- DEPOSITOREFEREMASIVOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFEREMASIVOPRO`;
DELIMITER $$

CREATE PROCEDURE `DEPOSITOREFEREMASIVOPRO`(
-- =====================================================================================
-- ------- STORED PARA PROCESO MASIVO DE PAGOS REFERENCIADOS ---------
-- =====================================================================================
	Par_NumTran				BIGINT(20),		-- Numero de Transaccion de Carga
	Par_InstitucionID		INT(11),		-- ID institucion bancaria
	Par_NumCtaInstit		VARCHAR(20),	-- Cuenta de la institución bancaria
	Par_BancoEstandar		CHAR(1),		-- Formato de banco o estandar
	INOUT Par_Consecutivo	BIGINT(12),		-- Consecutivo identificador

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;				-- Fecha de sistema
   	DECLARE Var_ConsecutivoID  	INT(11);      		-- ID consecutivo a recorrer
   	DECLARE Var_MaxConsecutivoID INT(11);      		-- Maximo ID consecutivo a recorrer

	DECLARE Var_NumTran			BIGINT(20);			-- Numero de Transaccion de Carga
	DECLARE Var_NumeroFila 		INT(11); 			-- Numero de Fila del deposito en el archivo cargado
	DECLARE Var_NumRegistros	INT(11); 			-- Numero de registros de la carga del archivo
	DECLARE Var_NumRegAplica	INT(11); 			-- Numero de registros que se apicaran
	DECLARE Var_NumExitosos		INT(11); 			-- Numero de registros exitosos

	DECLARE Var_NumFallidos		INT(11); 			-- Numero de registros fallidos
    DECLARE Var_FechaOperacion	DATE;				-- Fecha de operacion del deposito referenciado
    DECLARE Var_InstitucionID 	INT(11);			-- ID de la institución bancaria
    DECLARE Var_BancoEstandar	CHAR(1);			-- Formato de banco o estandar
	DECLARE Var_TipoMov			CHAR(4);			-- Id del Tipo de Movimiento

    DECLARE Var_TipoCanal		INT(11); 			-- Identificacion de donde vino el deposito, corresponde con la tabla : TIPOCANAL
    DECLARE Var_NumVal			INT(11);			-- NUmero de validaciOn
	DECLARE Var_NumCtaInstit	VARCHAR(20);		-- Cuenta de la institución bancaria
    DECLARE Var_ReferenciaMov	VARCHAR(40);		-- Referencia del Movimiento Debe ser el CREDITO o CUENTA
    DECLARE Var_DescripcionMov	VARCHAR(150);		-- Decripcion del Movimiento

    DECLARE Var_NatMovimiento	CHAR(1);			-- Naturaleza del Movimiento: C.- Cargo, A.- Abono
    DECLARE Var_MontoMov		DECIMAL(12,2); 		-- Monto del Movimiento
	DECLARE Var_MontoPendApli	DECIMAL(18,2); 		-- Monto del Pendiente aplicar
    DECLARE Var_TipoDeposito	CHAR(1);			-- Tipo de Deposito: E .-  Si pago Efectivo, T .-  Otro tipo deposito.
    DECLARE Var_MonedaId		INT(11);			-- Numero de la Moneda. MONEDAS.

    DECLARE Var_NumIdenArchivo	VARCHAR(20);		-- Este campo se forma con el numero de transaccion del archivo y con la fecha en que se realiza la operacion, cero indica vacio.
    DECLARE Var_CuentaAhoID		BIGINT(12);			-- ID de cuenta de ahorro
    DECLARE Var_Canal			CHAR(1);			-- Canal
    DECLARE Var_Validacion		VARCHAR(150);		-- Mensaje de Validacion.
	DECLARE Error_Key			INT(11);			-- Codigo de error en transaccion

    DECLARE Var_FolioCargaID	BIGINT(17);			-- Folio unico de Carga de Archivo a Conciliar

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-DEPOSITOREFEREMASIVOPRO');
			SET Var_Control = 'sqlException';
		END;

		-- ELIMINA AL INICIO LOS REGISTROS POR TRANSACCION SI NO SE TERMINO CORRECTAMENTE EL PROCESO
        DELETE FROM TMPIDDEPOSITOSREFEAPLICA WHERE NumTran = Par_NumTran;

		SET @ConsecutivoID := Entero_Cero;
		INSERT INTO TMPIDDEPOSITOSREFEAPLICA(
			ConsecutivoID,								NumTran,		NumeroFila
        )SELECT
			@ConsecutivoID:=@ConsecutivoID+Entero_Uno,	NumTran, 		FolioCargaID
        FROM ARCHIVOCARGADEPREF
        WHERE NumTran = Par_NumTran
			AND AplicarDeposito = Cons_SI;

		SELECT MIN(ConsecutivoID), MAX(ConsecutivoID)
			INTO Var_ConsecutivoID, Var_MaxConsecutivoID
        FROM TMPIDDEPOSITOSREFEAPLICA
        WHERE NumTran = Par_NumTran;

        -- VALORES
        SET Var_NumRegistros := (SELECT COUNT(FolioCargaID) FROM ARCHIVOCARGADEPREF WHERE NumTran = Par_NumTran);
        SET Var_NumRegAplica := (SELECT COUNT(ConsecutivoID) FROM TMPIDDEPOSITOSREFEAPLICA WHERE NumTran = Par_NumTran);
        SET Var_NumExitosos := Entero_Cero;
        SET Var_NumFallidos := Entero_Cero;

        IteraRegistros: WHILE(Var_ConsecutivoID <= Var_MaxConsecutivoID)DO
			START TRANSACTION;

			Iteraciones: BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

				SET Error_Key	:= Entero_Cero;
				SET Par_NumErr 	:= 0;
				SET Par_ErrMen 	:= '';

				-- OBTIENE LA INFORMACION DEL REGISTRO A APLICAR
				SELECT ARC.NumTran,			ARC.NumeroFila,			ARC.FechaAplica,		Par_InstitucionID,			Par_BancoEstandar,
					ARC.TipoMov,			ARC.TipoCanal,			ARC.NumVal,				Par_NumCtaInstit,			ARC.ReferenciaMov,
					ARC.DescripcionMov,		ARC.NatMovimiento,		ARC.MontoMov,			Entero_Cero,				TipoDeposito,
					ARC.MonedaID,			ARC.NumIdenArchivo,		ARC.Validacion,			ARC.FolioCargaID

				INTO Var_NumTran,			Var_NumeroFila,			Var_FechaOperacion,		Var_InstitucionID,			Var_BancoEstandar,
					Var_TipoMov,			Var_TipoCanal,			Var_NumVal,				Var_NumCtaInstit,			Var_ReferenciaMov,
					Var_DescripcionMov,		Var_NatMovimiento,		Var_MontoMov,			Var_MontoPendApli,			Var_TipoDeposito,
					Var_MonedaId,			Var_NumIdenArchivo,		Var_Validacion,			Var_FolioCargaID
				FROM TMPIDDEPOSITOSREFEAPLICA TMP
					INNER JOIN ARCHIVOCARGADEPREF ARC
						ON TMP.NumTran = ARC.NumTran
							AND TMP.NumeroFila = ARC.FolioCargaID
				WHERE TMP.ConsecutivoID = Var_ConsecutivoID
					AND TMP.NumTran = Par_NumTran;

				-- FECHA DE OPERACION DEL DEPOSITO REFERENCIADO
				SET Var_FechaOperacion := DATE_FORMAT(Var_FechaOperacion, "%Y-%m-%d");

				-- SI EL DEPOSITO ES DE TIPO CANAL 2 (CUENTA)
				IF(Var_TipoCanal = 2)THEN
					-- SI EL NUMERO DE VALIDACIÓN OBTENIDO EN EL GRID ES 3 O 4, ES POR QUE EL SALDO DE LA CUENTA
					-- EXCEDIO SU LIMITE DE SALDO EN EL MES O EXCEDIO SU LIMITE DE SALDO EN GENERAL
					-- EN ESTE CASO EL DEPOSITO SE APLICA, PERO SE DA DE ALTA COMO CUENTA CON LIMITE DE SALDO EXCEDIDO
					IF(Var_NumVal = 3 || Var_NumVal = 4)THEN

						CALL DEPOSITOREFEREPRO(
							Var_InstitucionID,		Var_NumCtaInstit,	Var_FechaOperacion,		Var_ReferenciaMov,		Var_DescripcionMov,
							Var_NatMovimiento,		Var_MontoMov,		Var_MontoPendApli,		Var_TipoCanal,			Var_TipoDeposito,
							Var_MonedaId,			Cons_SI,			Var_NumIdenArchivo,		Var_BancoEstandar,		Entero_Cero,
							Salida_NO,				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
							Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
							Aud_NumTransaccion
						);

						IF(Par_NumErr <> Entero_Cero)THEN
                            SET Error_Key := 5;
							LEAVE Iteraciones;
						END IF;

						-- SE INSERTA EN LIMEXCTAS
						SET Var_CuentaAhoID := Var_ReferenciaMov;
						SET Var_Canal := 'R';

						CALL LIMEXCUENTASALT(
							Var_CuentaAhoID,		Entero_Cero,		Aud_Sucursal,		Var_FechaOperacion,			Var_NumVal,
							Var_Validacion,			Var_Canal,
							Salida_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,          	Aud_Usuario,
							Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,               Aud_NumTransaccion
						);

						IF(Par_NumErr <> Entero_Cero)THEN
                            SET Error_Key := 6;
							LEAVE Iteraciones;
						END IF;

					END IF;

					-- SI EL NUMERO DE VALIDACION OBTENIDO EN EL GRID ES IGUAL A 0
					-- ENTONCES EL DEPOSITO SE APLICA NORMALMENTE
					IF(Var_NumVal = 0)THEN

						CALL DEPOSITOREFEREPRO(
							Var_InstitucionID,		Var_NumCtaInstit,	Var_FechaOperacion,		Var_ReferenciaMov,		Var_DescripcionMov,
							Var_NatMovimiento,		Var_MontoMov,		Var_MontoPendApli,		Var_TipoCanal,			Var_TipoDeposito,
							Var_MonedaId,			Cons_SI,			Var_NumIdenArchivo,		Var_BancoEstandar,		Entero_Cero,
							Salida_NO,				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
							Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
							Aud_NumTransaccion
						);

						IF(Par_NumErr <> Entero_Cero)THEN
                            SET Error_Key := 7;
							LEAVE Iteraciones;
						END IF;

					END IF;

				ELSE   -- IF(Var_TipoCanal > 0)THEN SI ES DIFETENTE DEL CANAL 2

					CALL DEPOSITOREFEREPRO(
						Var_InstitucionID,		Var_NumCtaInstit,	Var_FechaOperacion,		Var_ReferenciaMov,		Var_DescripcionMov,
						Var_NatMovimiento,		Var_MontoMov,		Var_MontoPendApli,		Var_TipoCanal,			Var_TipoDeposito,
						Var_MonedaId,			Cons_SI,			Var_NumIdenArchivo,		Var_BancoEstandar,		Entero_Cero,
						Salida_NO,				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
						Aud_NumTransaccion
					);

					IF(Par_NumErr <> Entero_Cero)THEN
						SET Error_Key := 8;
						LEAVE Iteraciones;
					END IF;

				END IF;

				-- ACTUALZIA QUE SE APLICO EL DEPOSITO POR EL PROCESO MASIVO
				UPDATE ARCHIVOCARGADEPREF SET
					AplicarDeposito = 'A',

					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
				WHERE NumTran = Var_NumTran
					AND NumeroFila = Var_NumeroFila;

				SET Var_NumExitosos := Var_NumExitosos + Entero_Uno;
				SET Par_NumErr 		:= 0;
				SET Par_ErrMen 		:= CONCAT('Deposito Referenciado Aplicado Exitosamente');

			END Iteraciones;

			-- ACTUALIZA EL CONSECUTIVO
			SET Var_ConsecutivoID := Var_ConsecutivoID + Entero_Uno;

			IF(Error_Key = Entero_Cero)THEN
				COMMIT;
			ELSE
				ROLLBACK;
				SET Var_NumFallidos := Var_NumFallidos + Entero_Uno;

				CALL BITACORADEPREFALT(
					Var_NumTran,			Var_FolioCargaID,		Par_NumErr,				Par_ErrMen,
					Salida_NO,				Par_NumErr,				Par_ErrMen,
					Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,			Aud_NumTransaccion
				);

				IF(Par_NumErr <> Entero_Cero)THEN
					ITERATE IteraRegistros;
				END IF;
			END IF;

		END WHILE IteraRegistros;

		-- ELIMINA AL FINAL LOS REGISTROS POR TRANSACCION
		DELETE FROM TMPIDDEPOSITOSREFEAPLICA WHERE NumTran = Par_NumTran;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Proceso Masivo de Depositos Referenciados Realizado Exitosamente: ',
									'Total Carga: ',Var_NumRegistros, ', ',
                                    'Total Aplicar: ', Var_NumRegAplica,', ',
                                    'Exitosos: ',Var_NumExitosos,', ',
                                    'Fallidos(BITACORADEPREF):',Var_NumFallidos);
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= 0;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$