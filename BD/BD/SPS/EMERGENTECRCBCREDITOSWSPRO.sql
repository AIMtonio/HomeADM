-- EMERGENTECRCBCREDITOSWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMERGENTECRCBCREDITOSWSPRO`;

DELIMITER $$
CREATE PROCEDURE `EMERGENTECRCBCREDITOSWSPRO`(
	-- === SP para realizar alta de creditos mediante el WS de Alta de Creditos de CREDICLUB =====
	 Par_FolioCarga				INT(11),			-- Folio de la Carga a Procesar

	Par_Salida					CHAR(1), 			-- Indica mensaje de Salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Descripcion de Error

	Par_EmpresaID		        INT(11),			-- Parametro de Auditoria
	Aud_Usuario			        INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		  		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_Contador				BIGINT(20);			-- Contador para las iteraciones
	DECLARE Var_CantRegistros			BIGINT(20);			-- Cantidad de registros para las iteraciones
	DECLARE Var_CrcbCreditosWSID		BIGINT(20);			-- ID del la tabla de carga masiva de creditos
	DECLARE Var_FechaCarga				DATETIME;			-- Fecha de Carga
	DECLARE Var_FolioCarga				INT(11);			-- Folio de carga
	DECLARE Var_ClienteID				INT(11);  			-- ID del Cliente
	DECLARE Var_ProductoCreditoID		INT(11); 		 	-- Producto Credito ID
	DECLARE Var_Monto					DECIMAL(14,2); 		-- Monto del Credito
	DECLARE Var_TasaFija				DECIMAL(12,4); 		-- Tasa fija
	DECLARE Var_Frecuencia				CHAR(1); 			-- Frecuencia del Credito
	DECLARE Var_DiaPago					CHAR(1); 			-- Dia de pago del Credito
	DECLARE Var_DiaMesPago				INT(11);
	DECLARE Var_PlazoID         		INT(11);
	DECLARE Var_DestinoCreID			INT(11);
	DECLARE Var_TipoIntegrante			INT(11);
	DECLARE Var_GrupoID         		INT(11);
	DECLARE Var_TipoDispersion      	CHAR(1);
	DECLARE Var_MontoPorComAper			DECIMAL(14,2);
	DECLARE Var_PromotorID				INT(11);
	DECLARE Var_CuentaClabe     		CHAR(18);
	DECLARE Var_FechaIniPrimAmor		DATE;
	DECLARE Var_TipoConsultaSIC 		CHAR(2);
	DECLARE Var_FolioConsultaSIC 		VARCHAR(30);
	DECLARE Var_ReferenciaPago			VARCHAR(20);
	DECLARE Error_Key					INT(11);
	DECLARE Var_SolicitudCreditoID		BIGINT(12);			-- ID de la solicitud de credito generada
	DECLARE Var_CreditoID				BIGINT(10);			-- ID del credito generado
	DECLARE Var_IDCreditoSIERRA			CHAR(24);			-- ID del credito sierra
    DECLARE Var_CuentaID				BIGINT(12);
   	DECLARE Var_Reestrucutra			CHAR(1);			-- indica si realiza reestructura o no
   	DECLARE Var_NuevoCredito			CHAR(1);			-- indica si realiza nuevo credito o no
    DECLARE Var_CreditoOrigen			BIGINT(20);
    DECLARE Var_NumErrRees				INT(11);			-- Numero de Error proceso de reestructura
	DECLARE Var_ErrMenRess				VARCHAR(400);		-- Descripcion de Error reestructura
	DECLARE Var_PlazoIDAnterior    		INT(11);

    -- Declaracion de Constantes
    DECLARE Entero_Cero         		INT(11);
    DECLARE Cadena_Vacia        		CHAR(1);
	DECLARE Decimal_Cero	    		DECIMAL(12,2);
	DECLARE Fecha_Vacia         		DATE;
    DECLARE SalidaSI            		CHAR(1);
    DECLARE SalidaNO            		CHAR(1);
    DECLARE Entero_Uno					INT(11);

    -- Asignacion de Constantes
	SET Entero_Cero						:= 0;					-- Entero Cero
	SET Cadena_Vacia					:= '';					-- Cadena Vacia
	SET Decimal_Cero	    			:=  0.00;   			-- DECIMAL Cero
	SET Fecha_Vacia						:= '1900-01-01';		-- Fecha Vacia
    SET SalidaSI           				:= 'S';        			-- El Store SI genera una Salida
    SET	SalidaNO 	   	   				:= 'N';	      			-- El Store NO genera una Salida
    SET Entero_Uno						:= 1;

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-EMERGENTECRCBCREDITOSWSPRO');
		END;

		SET @IDNum := 0;

		DELETE FROM TMP_CS_CRCBCREDITOSWS;

		INSERT INTO TMP_CS_CRCBCREDITOSWS
			SELECT 	(@IDNum := @IDNum + 1),	CrcbCreditosWSID,       FechaCarga,				FolioCarga,				ClienteID,
                    ProductoCreditoID,      Monto,					TasaFija,				Frecuencia,				DiaPago,
                    DiaMesPago,             PlazoID,				DestinoCreID,			TipoIntegrante,			GrupoID,
                    TipoDispersion,         MontoPorComAper,		PromotorID,				CuentaClabe,			FechaIniPrimAmor,
                    TipoConsultaSIC,        FolioConsultaSIC,		ReferenciaPago,			IDCreditoSIERRA,		CreditoOrigen
				FROM CS_CRCBCREDITOSWS
				WHERE FolioCarga = Par_FolioCarga;


		SELECT MIN(NumRegistro),		MAX(NumRegistro)
			INTO Var_Contador,			Var_CantRegistros
			FROM TMP_CS_CRCBCREDITOSWS;

		WHILE Var_Contador <= Var_CantRegistros AND Var_Contador > Entero_Cero  DO
            SET Var_CrcbCreditosWSID := NULL;
			SET Var_FechaCarga	:= NULL;
			SET Var_FolioCarga := NULL;
			SET Var_ClienteID := NULL;
			SET Var_ProductoCreditoID := NULL;
			SET Var_Monto:= NULL;
			SET Var_TasaFija := NULL;
			SET Var_Frecuencia := NULL;
			SET Var_DiaPago := NULL;
			SET Var_DiaMesPago := NULL;
			SET Var_PlazoID := NULL;
			SET Var_DestinoCreID := NULL;
			SET Var_TipoIntegrante := NULL;
			SET Var_GrupoID := NULL;
			SET Var_TipoDispersion := NULL;
			SET Var_MontoPorComAper := NULL;
			SET Var_PromotorID := NULL;
			SET Var_CuentaClabe := NULL;
			SET Var_FechaIniPrimAmor := NULL;
			SET Var_TipoConsultaSIC := NULL;
			SET Var_FolioConsultaSIC := NULL;
			SET Var_SolicitudCreditoID := NULL;
			SET Var_CreditoID := NULL;
            SET	Var_IDCreditoSIERRA	:= NULL;
            SET Var_CuentaID := NULL;

			SELECT 		FechaCarga,				FolioCarga,				ClienteID,				ProductoCreditoID,		Monto,
						TasaFija,				Frecuencia,				DiaPago,				DiaMesPago,				PlazoID,
						DestinoCreID,			TipoIntegrante,			GrupoID,				TipoDispersion,			MontoPorComAper,
						PromotorID,				CuentaClabe,			FechaIniPrimAmor,		TipoConsultaSIC,		FolioConsultaSIC,
						ReferenciaPago,			CrcbCreditosWSID,		IDCreditoSIERRA,		CreditoOrigen
				INTO 	Var_FechaCarga,			Var_FolioCarga,			Var_ClienteID,			Var_ProductoCreditoID,	Var_Monto,
						Var_TasaFija,			Var_Frecuencia,			Var_DiaPago,			Var_DiaMesPago,			Var_PlazoID,
						Var_DestinoCreID,		Var_TipoIntegrante,		Var_GrupoID,			Var_TipoDispersion,		Var_MontoPorComAper,
						Var_PromotorID,			Var_CuentaClabe,		Var_FechaIniPrimAmor,	Var_TipoConsultaSIC,	Var_FolioConsultaSIC,
						Var_ReferenciaPago,		Var_CrcbCreditosWSID,	Var_IDCreditoSIERRA,	Var_CreditoOrigen
				FROM TMP_CS_CRCBCREDITOSWS
				WHERE NumRegistro = Var_Contador;

			-- Iniciamos transaccion
			START TRANSACTION;
			transaccion: BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

				SET Error_Key				:= Entero_Cero;
				SET Par_NumErr				:= Entero_Cero;
				SET Par_ErrMen				:= '';

				CALL TRANSACCIONESPRO(Aud_NumTransaccion);

                -- VALIDA SI EL REGISTRO TIENE UN NUMERO DE CREDITO ORIGEN
                IF(Var_CreditoOrigen > Entero_Cero)THEN
					SET Var_NuevoCredito := 'N';
					SET Var_Reestrucutra := 'S';
				ELSE
					SET Var_NuevoCredito := 'S';
					SET Var_Reestrucutra := 'N';
                END IF;

                IF(Var_Reestrucutra = 'S')THEN
					SELECT  PlazoID
						INTO Var_PlazoIDAnterior
					FROM CREDITOS
					WHERE CreditoID = Var_CreditoOrigen;

					CALL CRCBREESTRUCTURACREDPRO (
						Var_CreditoOrigen,
						Var_ClienteID,			Var_ProductoCreditoID,		Var_Monto,				Var_TasaFija,			Var_Frecuencia,
						Var_DiaPago,			Var_DiaMesPago,				Var_PlazoID,			Var_DestinoCreID,		Var_TipoIntegrante,
						Var_GrupoID,			Var_TipoDispersion,			Var_MontoPorComAper,	Var_PromotorID,			Var_CuentaClabe,
						Var_FechaIniPrimAmor,	Var_TipoConsultaSIC,		Var_FolioConsultaSIC,	Var_ReferenciaPago,		SalidaNO,
						Par_NumErr,				Par_ErrMen,					Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion
					);

                    IF(Par_NumErr <> Entero_Cero)THEN
                        SET Var_NumErrRees := Par_NumErr;
                        SET Var_ErrMenRess := Par_ErrMen;
						ROLLBACK;
						SET Var_NuevoCredito := 'S';
                        START TRANSACTION;
                    END IF;
                END IF;

                IF(Var_NuevoCredito = 'S')THEN
					CALL CRCBCREDITOSWSPRO (
						Var_ClienteID,			Var_ProductoCreditoID,		Var_Monto,				Var_TasaFija,			Var_Frecuencia,
						Var_DiaPago,			Var_DiaMesPago,				Var_PlazoID,			Var_DestinoCreID,		Var_TipoIntegrante,
						Var_GrupoID,			Var_TipoDispersion,			Var_MontoPorComAper,	Var_PromotorID,			Var_CuentaClabe,
						Var_FechaIniPrimAmor,	Var_TipoConsultaSIC,		Var_FolioConsultaSIC,	Var_ReferenciaPago,		SalidaNO,
						Par_NumErr,				Par_ErrMen,					Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion
					);
                END IF;

			END transaccion;
			IF Error_Key = 0 && Par_NumErr = Entero_Cero THEN
				COMMIT;

                -- SI ES REESTRUCTURA TOMA LA INFORMACION DEL CREDITO ORIGEN SI NO LO HACE NORMAL DEL CREDITO NUEVO
				IF(Var_Reestrucutra = 'S' AND Var_NumErrRees = Entero_Cero)THEN
					SELECT 		CreditoID,			CuentaID,		SolicitudCreditoID,		PlazoID,
								ClienteID,			ProductoCreditoID,	Frecuencia
						INTO 	Var_CreditoID,		Var_CuentaID,	Var_SolicitudCreditoID,	Var_PlazoID,
								Var_ClienteID,		Var_ProductoCreditoID,	Var_Frecuencia
					FROM CREDITOS
					WHERE CreditoID = Var_CreditoOrigen;
                ELSE
					SELECT 		SolicitudCreditoID
						INTO 	Var_SolicitudCreditoID
					FROM SOLICITUDCREDITO
					WHERE NumTransaccion = Aud_NumTransaccion
						AND ClienteID = Var_ClienteID;

					SELECT 		CreditoID,			CuentaID
						INTO 	Var_CreditoID,		Var_CuentaID
					FROM CREDITOS
					WHERE NumTransaccion = Aud_NumTransaccion
						AND ClienteID = Var_ClienteID;
                END IF;


				INSERT INTO BITEXITOCREDITOALTBATCHWS (
							FechaCarga,				FolioCarga,				ClienteID,				ProductoCreditoID,		Monto,
							TasaFija,				Frecuencia,				DiaPago,				DiaMesPago,				PlazoID,
							DestinoCreID,			TipoIntegrante,			GrupoID,				TipoDispersion,			MontoPorComAper,
							PromotorID,				CuentaClabe,			FechaIniPrimAmor,		TipoConsultaSIC,		FolioConsultaSIC,
							ReferenciaPago,			CrcbCreditosWSID,		SolicitudCreditoID,		CreditoID,				IDCreditoSIERRA,
                            CuentaAhoID
					)
                    SELECT 	Var_FechaCarga,			Var_FolioCarga,			Var_ClienteID,			Var_ProductoCreditoID,	Var_Monto,
							Var_TasaFija,			Var_Frecuencia,			Var_DiaPago,			Var_DiaMesPago,			Var_PlazoID,
							Var_DestinoCreID,		Var_TipoIntegrante,		Var_GrupoID,			Var_TipoDispersion,		Var_MontoPorComAper,
							Var_PromotorID,			Var_CuentaClabe,		Var_FechaIniPrimAmor,	Var_TipoConsultaSIC,	Var_FolioConsultaSIC,
							Var_ReferenciaPago,		Var_CrcbCreditosWSID,	Var_SolicitudCreditoID,	Var_CreditoID,			Var_IDCreditoSIERRA,
                            Var_CuentaID;

				IF(Var_Reestrucutra = 'S' AND Var_NumErrRees <> Entero_Cero)THEN
					SELECT 		CreditoID,			CuentaID,		SolicitudCreditoID,		PlazoID,
								ClienteID,			ProductoCreditoID,	FrecuenciaCap
						INTO 	Var_CreditoID,		Var_CuentaID,	Var_SolicitudCreditoID,	Var_PlazoID,
								Var_ClienteID,		Var_ProductoCreditoID,	Var_Frecuencia
					FROM CREDITOS
					WHERE CreditoID = Var_CreditoOrigen;
						SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);
						SET Var_ProductoCreditoID := IFNULL(Var_ProductoCreditoID,Entero_Cero);
						SET Var_Frecuencia := IFNULL(Var_Frecuencia,Cadena_Vacia);
						SET Var_PlazoID := IFNULL(Var_PlazoID,Entero_Cero);
						SET Var_SolicitudCreditoID := IFNULL(Var_SolicitudCreditoID,Entero_Cero);
						SET Var_CreditoID := IFNULL(Var_CreditoID,Var_CreditoOrigen);

					CALL`BITACORAREESTRUCREDCRCBALT`(
						Var_ClienteID,		Var_ProductoCreditoID,	Var_Frecuencia, 	Var_PlazoIDAnterior,Var_CreditoOrigen,
                        Var_PlazoID,		Var_ErrMenRess,
						SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
                        Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
					);
                END IF;
			ELSE
				ROLLBACK;

				INSERT INTO BITERRORCREDITOALTBATCHWS (
							FechaCarga,				FolioCarga,				ClienteID,				ProductoCreditoID,		Monto,
							TasaFija,				Frecuencia,				DiaPago,				DiaMesPago,				PlazoID,
							DestinoCreID,			TipoIntegrante,			GrupoID,				TipoDispersion,			MontoPorComAper,
							PromotorID,				CuentaClabe,			FechaIniPrimAmor,		TipoConsultaSIC,		FolioConsultaSIC,
							ReferenciaPago,			Mensaje,				Codigo,					SP,						CrcbCreditosWSID,
                            IDCreditoSIERRA
					)
                    SELECT 	Var_FechaCarga,			Var_FolioCarga,			Var_ClienteID,			Var_ProductoCreditoID,	Var_Monto,
							Var_TasaFija,			Var_Frecuencia,			Var_DiaPago,			Var_DiaMesPago,			Var_PlazoID,
							Var_DestinoCreID,		Var_TipoIntegrante,		Var_GrupoID,			Var_TipoDispersion,		Var_MontoPorComAper,
							Var_PromotorID,			Var_CuentaClabe,		Var_FechaIniPrimAmor,	Var_TipoConsultaSIC,	Var_FolioConsultaSIC,
							Var_ReferenciaPago,		Par_ErrMen,				Par_NumErr,				'CRCBCREDITOSWSPRO',	Var_CrcbCreditosWSID,
                            Var_IDCreditoSIERRA;

					IF(Var_Reestrucutra = 'S' AND Var_NumErrRees <> Entero_Cero)THEN
						SELECT 		CreditoID,			CuentaID,		SolicitudCreditoID,		PlazoID,
									ClienteID,			ProductoCreditoID,	FrecuenciaCap
							INTO 	Var_CreditoID,		Var_CuentaID,	Var_SolicitudCreditoID,	Var_PlazoID,
									Var_ClienteID,		Var_ProductoCreditoID,	Var_Frecuencia
						FROM CREDITOS
						WHERE CreditoID = Var_CreditoOrigen;

						SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);
						SET Var_ProductoCreditoID := IFNULL(Var_ProductoCreditoID,Entero_Cero);
						SET Var_Frecuencia := IFNULL(Var_Frecuencia,Cadena_Vacia);
						SET Var_PlazoID := IFNULL(Var_PlazoID,Entero_Cero);
						SET Var_SolicitudCreditoID := IFNULL(Var_SolicitudCreditoID,Entero_Cero);
						SET Var_CreditoID := IFNULL(Var_CreditoID,Var_CreditoOrigen);

						CALL`BITACORAREESTRUCREDCRCBALT`(
							Var_ClienteID,		Var_ProductoCreditoID,	Var_Frecuencia, 	Var_PlazoIDAnterior,Var_CreditoOrigen,
							Var_PlazoID,		Var_ErrMenRess,
							SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
						);
					END IF;
			END IF;

			DELETE FROM TMPPAGAMORSIM
				WHERE NumTransaccion = Aud_NumTransaccion;

			-- Incrementamos el contador
			SET Var_Contador := Var_Contador + 1;
		END WHILE;

		SET Par_NumErr      := Entero_Cero;
		SET Par_ErrMen      := 'Proceso realizado Exitosamente.';
	END ManejoErrores;

     IF(Par_Salida = SalidaSI)THEN
		SELECT 	Par_NumErr		AS codigoRespuesta,
				Par_ErrMen     	AS mensajeRespuesta;
	END IF;

END TerminaStore$$