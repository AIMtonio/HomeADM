-- BLOQUEOMASIVODEPACTCTAAHOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BLOQUEOMASIVODEPACTCTAAHOPRO`;
DELIMITER $$

CREATE PROCEDURE `BLOQUEOMASIVODEPACTCTAAHOPRO`(
-- =====================================================================================
-- --- STORED PARA BLOQUEO MASIVO DEL DEPOSITO DE ACTIVACION DE CUENTAS EXISTENTES   ---
-- --- TAREA: TAREA_BLOQUEO_MONTO_ACTIVA_CTA_EXISTENTES --------------------------------
-- =====================================================================================
	Par_NumTransaccion  	BIGINT(20),  	-- Numero de la transaccion

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
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
	DECLARE Var_CuentaAhoID 	BIGINT(12); 		-- Identificador de la cuenta de ahorro
	DECLARE Var_MontoDepositoActiva	DECIMAL(18,2); 	-- Si requiere un deposito para activar la cuenta, se indica el monto del deposito
    DECLARE Var_FechaAplicacion DATE;

    DECLARE Var_DescripBloq		VARCHAR(150);		-- descripcion del bloqueo
	DECLARE Var_BloqueID		INT(11);			-- ID del bloqueo realizado
    DECLARE Var_Aux				INT(11);   			-- Auxiliar para recorrer registros
    DECLARE Var_MaxConsecutivo	INT(11); 			-- Maximo numero consecutivo
    DECLARE Var_Exitosos		INT(11); 			-- Numero de registros exitosos

    DECLARE Var_Fallidos		INT(11); 			-- Numero de registros fallidos
    DECLARE Var_NumRegistros	INT(11); 			-- Numero total de registros

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Est_Registrado		INT(11);			-- 1 estatus registrado del deposito de activacion
	DECLARE Est_Depositado		INT(11);			-- 2 estatus depositado del monto de activacion
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si

    DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no
    DECLARE Naturaleza_Bloq		CHAR(1);			-- Naturaleza Bloqueo
    DECLARE TipoBloq_DepAct		INT(11);			-- Tipo de bloqueo, deopsito por activacion de cuenta
    DECLARE Act_AbonoBloqueo	INT(11);			-- Actualizacion 2 del deposito se registra que se bloqueo el monto
    DECLARE TipoRegCta_Existe	CHAR(1);			-- Tipo de  registro e cuenta E- existente

    DECLARE EstCta_Activa		CHAR(1);			-- Estatus de la cuenta A- activa

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET	Est_Registrado			:= 1;
	SET	Est_Depositado			:= 2;
	SET Cons_SI          		:= 'S';

	SET Cons_NO           		:= 'N';
    SET Naturaleza_Bloq			:= 'B';
    SET TipoBloq_DepAct			:= 24;
    SET Act_AbonoBloqueo		:= 2;
    SET TipoRegCta_Existe		:= 'E';

    SET EstCta_Activa			:= 'A';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BLOQUEOMASIVODEPACTCTAAHOPRO');
			SET Var_Control = 'sqlException';
		END;

        IF(IFNULL(Par_NumTransaccion, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El numero de transaccion esta Vacio.';
			SET Var_Control		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

        -- SE OBTIENEN TODAS LAS CUENTAS CON SALDO DISPONIBLE QUE REQUIEREN UN DEPOSITO
        SET @BitacoraBloqID := Entero_Cero;
        INSERT INTO BITACORABLOQMASIDEPACT(
			NumTransacProceso, 			BitacoraBloqID, 						CuentaAhoID, 			EstatusCta, 			EstatusDepAct,
			SaldoDispon, 	            MontoDepositoActiva, 					NumErr, 				ErrMen,
            EmpresaID, 					Usuario, 								FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 					NumTransaccion
        )SELECT
			Par_NumTransaccion, 		@BitacoraBloqID:= @BitacoraBloqID+1, 	DEP.CuentaAhoID,		CTA.Estatus, 			DEP.Estatus,
			CTA.SaldoDispon,			DEP.MontoDepositoActiva, 				Entero_Cero, 			Cadena_Vacia,
			Par_EmpresaID,				Aud_Usuario,         					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
        FROM DEPOSITOACTIVACTAAHO DEP
			INNER JOIN CUENTASAHO CTA
				ON DEP.CuentaAhoID = CTA.CuentaAhoID
        WHERE DEP.Estatus = Est_Registrado
			AND DEP.TipoRegistroCta = TipoRegCta_Existe
            AND CTA.Estatus = EstCta_Activa
            AND CTA.SaldoDispon >= DEP.MontoDepositoActiva
            AND DEP.MontoDepositoActiva > Entero_Cero
		ORDER BY DEP.DepositoActCtaID ASC;

        SET Var_FechaAplicacion := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_NumRegistros := (SELECT COUNT(BitacoraBloqID) FROM BITACORABLOQMASIDEPACT WHERE NumTransacProceso = Par_NumTransaccion);
		SET Var_MaxConsecutivo := (SELECT MAX(BitacoraBloqID) FROM BITACORABLOQMASIDEPACT WHERE NumTransacProceso = Par_NumTransaccion);

        SET Var_Aux := Entero_Uno;
        SET Var_Fallidos := Entero_Cero;
		SET Var_Exitosos := Entero_Cero;

		WHILE (Var_Aux <= Var_MaxConsecutivo) DO

			SELECT CuentaAhoID,	MontoDepositoActiva
				INTO Var_CuentaAhoID, Var_MontoDepositoActiva
			FROM BITACORABLOQMASIDEPACT
			WHERE NumTransacProceso = Par_NumTransaccion
				AND BitacoraBloqID = Var_Aux;

            IF(IFNULL(Var_CuentaAhoID, Entero_Cero) > Entero_Cero) THEN
				-- BLOQUEO DEL SALDO DE DEPOSITO PARA ACTIVACION DE CUENTA
				SET Var_DescripBloq := 'DEPOSITO ACTIVACION DE CUENTA';
				CALL `BLOQUEOSPRO`(
					Entero_Cero,	 	Naturaleza_Bloq,		Var_CuentaAhoID, 		Var_FechaAplicacion,	Var_MontoDepositoActiva,
					Fecha_Vacia,		TipoBloq_DepAct, 		Var_DescripBloq,		Var_CuentaAhoID,   		Cadena_Vacia,
					Cadena_Vacia,
					Salida_NO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
				);

				IF (Par_NumErr = Entero_Cero) THEN
					SET Var_BloqueID := (SELECT BloqueoID FROM BLOQUEOS WHERE CuentaAhoID = Var_CuentaAhoID AND TiposBloqID = TipoBloq_DepAct AND NumTransaccion = Aud_NumTransaccion);
					SET Var_BloqueID := IFNUlL(Var_BloqueID,Entero_Cero);

					-- ACTUALIZA EL ESTATUS DEL DEPOSITO
					CALL `DEPOSITOACTIVACTAAHOACT`(
						Var_CuentaAhoID,	Var_FechaAplicacion,		Entero_Cero,		Var_BloqueID,		Act_AbonoBloqueo,
						Salida_NO,			Par_NumErr,					Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
					);

					IF(Par_NumErr <> Entero_Cero)THEN
						SET Var_Fallidos := Var_Fallidos + Entero_Uno;
					ELSE
						SET Var_Exitosos := Var_Exitosos + Entero_Uno;
					END IF;
				ELSE
					SET Var_Fallidos := Var_Fallidos + Entero_Uno;
				END IF;

                UPDATE BITACORABLOQMASIDEPACT SET
					NumErr			= Par_NumErr,
                    ErrMen			= Par_ErrMen,

					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
                WHERE NumTransacProceso = Par_NumTransaccion
					AND BitacoraBloqID = Var_Aux;

			END IF;

			SET Var_Aux := Var_Aux + Entero_Uno;

		END WHILE;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Proceso de Bloqueo Masivo Realizado Exitosamente: ',
								'Numero de Cuentas: ',Var_NumRegistros,
								', Cuentas Exitosas: ', Var_Exitosos,
                                ', Cuentas Fallidas: ', Var_Fallidos);
		SET Var_Control		:= 'depositoActCtaID';
		SET Var_Consecutivo	:= Var_NumRegistros;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS Consecutivo;

	END IF;

END TerminaStore$$