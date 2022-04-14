-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPSANTANDERMINISPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPSANTANDERMINISPRO`;
DELIMITER $$


CREATE PROCEDURE `DISPSANTANDERMINISPRO`(
# ==========================================================================================================
# ---- SP PARA REALIZAR LA CONTABLIDAD DE LAS DISPERSIONES DE TRANSFERENCIA Y ORDEN DE PAGO SANTANDER -----
# ==========================================================================================================
	Par_NombreArchivo 		VARCHAR(100),			-- NOMBRE DEL ARCHIVO A PROCESAR
	Par_TipoAct				TINYINT UNSIGNED, 		-- TIPO DE TRANSACCION
    Par_Salida				CHAR(1),				-- SALIDA
	INOUT	Par_NumErr 		INT(11),				-- NUMERO DE ERROR
	INOUT	Par_ErrMen  	VARCHAR(400),			-- MENSAJE DE ERROR

	Aud_EmpresaID			INT(11),				-- AUDITORIA
	Aud_Usuario				INT(11),				-- AUDITORIA
	Aud_FechaActual			DATETIME,				-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),			-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),			-- AUDITORIA
	Aud_Sucursal			INT(11),				-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)				-- AUDITORIA
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE NumError				INT(11);		-- NUMERO DE ERROR
	DECLARE ErrorMen				VARCHAR(400);	-- MENSAJE DE ERROR
    DECLARE Var_Control				VARCHAR(25);	-- CONTROL
    DECLARE	Var_Consecutivo			BIGINT(12);		-- CONSECUTIVO
	DECLARE Var_CantDisper			INT(11);		-- NUMERO DE DISPERCIONES A PROCESAR
	DECLARE Var_AuxiliarI			INT(11);		-- AUXILIAR I PARA REALIZAR EL CLICLO
    DECLARE Var_DispersionID		INT(11);		-- ID DE LA DISPERSION A PROCESAR
    DECLARE Var_ClaveDispMov		INT(11);		-- CLAVE DE LA DISPERSION A PROCESAR
    DECLARE Var_Poliza				BIGINT(20);		-- POLIZA
	DECLARE Var_FechaSistema		DATE;			-- FECHA DEL SISTEMA
	DECLARE Var_EmpresaID			INT(11);		-- EMPRESA
	DECLARE Var_ConceptoArch		VARCHAR(100);	-- CONCEPTO QUE CONTIENE EL ARCHIVO
	DECLARE Var_Institucion			INT(11);		-- INSTITUCION
    DECLARE Var_CuentaAhoID			BIGINT(12);		-- CUENTA DE AHORRO
    DECLARE Var_NumCtaInstit		VARCHAR(20);	-- NUMERO DE CTA DE LA INSTITUCION
    DECLARE Var_FolioSalida			INT(11);		-- FOLIO SALIDA
    DECLARE Var_DesEstatus			VARCHAR(100);	-- DESCRIPCION DE ESTATUS
    DECLARE Var_FolioEstatus		VARCHAR(3);		-- FOLIO ESTATUS
    DECLARE Var_TipoMovDIspID		INT(11);		-- TIPO DE MOVIMIENTO
    DECLARE Var_Monto				DECIMAL(14,2);	-- MONTO DE DISPERSION
    DECLARE Var_NumeroPago			VARCHAR(100);	-- NUMERO DE PAGO
    DECLARE Var_Beneficiario		VARCHAR(100);	-- BENEFICIARIO
    DECLARE Var_Referencia			VARCHAR(100);	-- REFERENCIA
    DECLARE Var_ClienteID			INT(11);		-- REFERENCIA
    DECLARE Var_FechaLiquidacion	DATE;			-- FECHA LIQUIDACION
    DECLARE Var_FechaRechazo		DATE;			-- FECHA RECHAZO
	DECLARE Var_ContVencido			INT(11);		-- CONTADOR DE ESTATUS VENCIDO
	DECLARE Var_ContCancelado		INT(11);		-- CONTADOR DE ESTATUS CANCELADO
	DECLARE Var_ContLiquidado		INT(11);		-- CONTADOR DE ESTATUS LIQUIDADO
	DECLARE Var_ContPendiente		INT(11);		-- CONTADOR DE ESTATUS PENDIENTE DE AUTORIZAR
    DECLARE Var_Concepto			VARCHAR(200);	-- Concepto de la orden de pago
	DECLARE Var_CuentaDestino		VARCHAR(25);	-- CUENTA DESTINO
    DECLARE Var_TxtFolioProceso		VARCHAR(200);	-- FOLIO DE PROCESO DE DISPERSION
	DECLARE Var_NumRegistrosProc	INT(11);		-- NUMERO DE REGITROS
    DECLARE Var_CreditoID			BIGINT(12);		-- NUMERO DE CREDITO
    DECLARE Var_Estatus				CHAR(2);		-- ESTATUS DE LA DISPERSION
    DECLARE Var_DescripcionEstatus	VARCHAR(50);	-- DESCRIPCION DEL ESTATUS DE LA DISPERSION
	DECLARE Var_CreditosVencidos	TEXT;			-- CRDITOS VENCIDOS

    -- DECLARACION DE CONSTANTES
	DECLARE TransferenciaSan		INT(11);		-- PROCESO DE DISPERSION DE TRANSFERENCIAS
	DECLARE OrdenPagoSan			INT(11);		-- PROCESO DE SIDPERCIONES DE ORDEN DE PAGO
    DECLARE Cadena_Vacia			CHAR(1);		-- CADENA VACIA
	DECLARE Fecha_Vacia				DATE;			-- FECHA VACIA
	DECLARE Entero_Cero				INT(11);		-- ENTERO CERO
	DECLARE Decimal_Cero			DECIMAL(12,4);	-- DECIMAL CERO
	DECLARE SalidaSi           		CHAR(1);		-- SALIDA SI
	DECLARE SalidaNo           		CHAR(1);		-- SALIDA NO
	DECLARE Con_ConceptoDis			INT(11);		-- CONCEPTO CONTABLE DISPERSION DE RECURSOS [CONCEPTOSCONTA]
	DECLARE Con_DesConcepto			VARCHAR(150);	-- DESCRIPCION DEL CONCEPTO CONTABLE
    DECLARE Con_TipoPolizaAut		CHAR(1);		-- TIPO DE POLIZA A.-Automatica
    DECLARE Con_ActCuentas			INT(11);		-- ACTUALIZACION DE CUENTAS
    DECLARE Con_ActCierre			INT(11);		-- ACTUALIZACION DE CUENTAS
    DECLARE Con_BancoS				CHAR(1);		-- BANCO SANTANDER
    DECLARE Con_OrdenPago			CHAR(1);		-- ORDEN DE PAGOS
    DECLARE Con_Transferencia		CHAR(1);		-- TRANSFERECNIA
    DECLARE Con_EstatusC			CHAR(1);		-- ESTATUS CANCELADO
    DECLARE Act_Ejecutado			INT(11);		-- Actualizacion a Ejecutado
	DECLARE Act_Proceso				INT(11);		-- Actualizacion a En Proceso

	-- ASIGNACION DE CONSTANTES
	SET TransferenciaSan			:=1;
	SET OrdenPagoSan				:=2;
    SET Cadena_Vacia        		:= '';
    SET Fecha_Vacia					:= '1900-01-01';
    SET Entero_Cero         		:= 0;
    SET Decimal_Cero         		:= 0.0;
	SET SalidaSi            		:= 'S';
	SET SalidaNo            		:= 'N';
	SET Con_ConceptoDis				:= 82;
	SET Con_DesConcepto				:= 'DISPERSION DE RECURSOS';
    SET Con_TipoPolizaAut			:= 'A';
    SET Con_ActCuentas				:= 1;
    SET Con_ActCierre				:= 3;
    SET Con_BancoS					:= 'S';
    SET Con_OrdenPago				:= 'O';
    SET Con_Transferencia			:= 'T';
    SET Con_EstatusC				:= 'C';
    SET Act_Ejecutado				:= 5;
    SET Act_Proceso					:= 6;

	-- INICIALIZAMOS VARIBALES
    SET Var_CantDisper 				:= Entero_Cero;
    SET Var_AuxiliarI 				:= Entero_Cero;
    SET Var_DispersionID 			:= Entero_Cero;
    SET Var_ClaveDispMov 			:= Entero_Cero;
    SET Var_Poliza					:= Entero_Cero;
    SET Var_Institucion				:= Entero_Cero;
    SET Var_CuentaAhoID				:= Entero_Cero;
    SET Var_NumCtaInstit			:= Cadena_Vacia;
    SET Var_FolioSalida				:= Entero_Cero;
    SET Var_DesEstatus				:= Cadena_Vacia;
	SET Var_FolioEstatus			:= Cadena_Vacia;
	SET Var_Monto					:= Decimal_Cero;
	SET	Var_NumeroPago				:= Cadena_Vacia;
    SET Var_Beneficiario			:= Cadena_Vacia;
    SET Var_Referencia				:= Cadena_Vacia;
    SET Var_ClienteID				:= Entero_Cero;
	SET Var_ContVencido				:= Entero_Cero;
	SET Var_ContCancelado			:= Entero_Cero;
	SET Var_ContLiquidado			:= Entero_Cero;
	SET Var_ContPendiente			:= Entero_Cero;
	SET Var_FechaRechazo			:= Fecha_Vacia;
	SET Var_FechaLiquidacion		:= Fecha_Vacia;
	SET Var_Concepto				:= Cadena_Vacia;
	SET Var_TxtFolioProceso			:= Cadena_Vacia;
    SET Var_NumRegistrosProc		:= Entero_Cero;
    SET Var_CreditoID				:= Entero_Cero;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-DISPSANTANDERMINISPRO- ',Var_TxtFolioProceso);
		END;

        SET Par_TipoAct := IFNULL(Par_TipoAct, Entero_Cero);
        SET Par_NombreArchivo := IFNULL(Par_NombreArchivo, Cadena_Vacia);

        SELECT FechaSistema, 		EmpresaID
			INTO Var_FechaSistema, 	Var_EmpresaID
		FROM PARAMETROSSIS LIMIT 1;

        IF(Par_TipoAct = Entero_Cero)THEN
			SET	Par_NumErr 		:= 1;
			SET	Par_ErrMen		:= 'El Tipo de Transaccion esta vacio';
            SET Var_Control		:= 'rutaArchivo';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(Par_NombreArchivo = Cadena_Vacia)THEN
			SET	Par_NumErr 		:= 2;
			SET	Par_ErrMen		:= 'Nombre del archivo esta vacio';
            SET Var_Control		:= 'rutaArchivo';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        -- ELIMINAMOS LOS DATOS DE LA TEMPORAL
		DELETE FROM TMPDISPERSIONESSANTANDER
			WHERE NombreArchivo=Par_NombreArchivo
			AND NumTransaccion=Aud_NumTransaccion;


		/****************************************************************************
        *				PROCESO DE DISPERSIONES POR TRANSFERENCIAS					*
        *****************************************************************************/
		IF(Par_TipoAct=TransferenciaSan)THEN
			SET @Consecutivo :=Entero_Cero;
			INSERT INTO TMPDISPERSIONESSANTANDER
							(Consecutivo,			NumTransaccion, 		NombreArchivo, 		Concepto,								Importe,
							 IVA,					Estatus,				FechaLiquidacion,	FechaRechazo)
			SELECT @Consecutivo:=@Consecutivo+1, 	TMP.NumTransaccion, 	TMP.NombreArchivo, 	IFNULL(TMP.Concepto, Cadena_Vacia),	TMP.Importe,
							CASE IFNULL(TMP.IVA,Cadena_Vacia) WHEN Cadena_Vacia THEN 0 ELSE TMP.IVA END AS IVA,
                            TMP.Estatus,			TMP.FechaLiquidacion,
                            CASE TMP.Estatus
								WHEN '01' THEN Var_FechaSistema
								WHEN '02' THEN Var_FechaSistema
								WHEN '03' THEN Var_FechaSistema
								WHEN '05' THEN Var_FechaSistema
								WHEN '06' THEN Var_FechaSistema
								WHEN '14' THEN Var_FechaSistema
								WHEN '15' THEN Var_FechaSistema
								WHEN '16' THEN Var_FechaSistema
							ELSE Fecha_Vacia END AS FechaRechazo
				FROM DISPTRANSFERENCIASAN TMP
				WHERE TMP.NombreArchivo=Par_NombreArchivo
				AND TMP.NumTransaccion=Aud_NumTransaccion;

            SELECT COUNT(NumTransaccion) INTO Var_CantDisper
				FROM TMPDISPERSIONESSANTANDER
                WHERE NombreArchivo=Par_NombreArchivo
				AND NumTransaccion=Aud_NumTransaccion;

            IF(Var_CantDisper<=0)THEN
				SET	Par_NumErr 		:= 904;
				SET	Par_ErrMen		:= 'No se encontraron registros para procesar.';
                SET Var_TxtFolioProceso := Par_ErrMen;
				SET Var_Control		:= 'rutaArchivo';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
            END IF;

            -- CLICLO PARA PROCESAR DISPERSIONES DE TRANSFERENCIAS
			WHILE Var_AuxiliarI<Var_CantDisper DO
				SET Var_AuxiliarI :=Var_AuxiliarI+1;
				SET Var_FolioEstatus := '';
				SET Var_Institucion := Entero_Cero;
				SET Var_CuentaAhoID := Entero_Cero;
				SET Var_NumCtaInstit := Cadena_Vacia;

                -- ALTA DEL ENCABEZADO DE LA POLIZA
                IF(Var_AuxiliarI = 1)THEN
					CALL MAESTROPOLIZASALT(Var_Poliza,			Var_EmpresaID,		Var_FechaSistema,		Con_TipoPolizaAut,		Con_ConceptoDis,
										   Con_DesConcepto,		SalidaNo,			Par_NumErr,				Par_ErrMen,				Aud_Usuario,
										   Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,         Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr!=Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
                END IF;


				SELECT  SUBSTRING_INDEX(Concepto, "X", 1) AS DispersionID,
						SUBSTRING(Concepto,LENGTH(SUBSTRING_INDEX(Concepto, "X", 1))+2,
                        (LENGTH(SUBSTRING_INDEX(Concepto, "X", 2))-(LENGTH(SUBSTRING_INDEX(Concepto, "X", 1))+1))) AS ClaveDispMov,
                        Estatus,
                        FechaLiquidacion,
                        FechaRechazo,
                        Importe
					INTO Var_DispersionID,
						 Var_ClaveDispMov,
                         Var_DesEstatus,
                         Var_FechaLiquidacion,
                         Var_FechaRechazo,
                         Var_Monto
				FROM TMPDISPERSIONESSANTANDER
				WHERE NombreArchivo=Par_NombreArchivo
					AND NumTransaccion=Aud_NumTransaccion
					AND Consecutivo=Var_AuxiliarI
                    LIMIT 1;

				IF(Var_DispersionID = Entero_Cero)THEN
					SET Par_NumErr := 901;
					SET Par_ErrMen := 'El numero de dispersion no existe.';
					SET Var_Control		:= 'rutaArchivo';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_ClaveDispMov = Entero_Cero)THEN
					SET Par_NumErr := 902;
					SET Par_ErrMen := 'El detalle de la dispersion no existe.';
					SET Var_Control		:= 'rutaArchivo';
					LEAVE ManejoErrores;
				END IF;

				SELECT DIS.Estatus, CASE DIS.Estatus  WHEN "A" THEN "AUTORIZADO"
											  WHEN "P" THEN "PENDIENTE"
											  WHEN "N" THEN "NO APLICADA"
                                              WHEN "E" THEN "EXPORTADA"
                                              ELSE "CANCELADA" END
					INTO Var_Estatus, Var_DescripcionEstatus
					FROM DISPERSIONMOV DIS
					INNER JOIN CREDITOS CRE ON DIS.CreditoID = CRE.CreditoID
					INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID =CRE.SolicitudCreditoID
				WHERE DIS.DispersionID= Var_DispersionID
				AND DIS.ClaveDispMov = Var_ClaveDispMov
                LIMIT 1;

                IF(Var_Estatus !="A" AND Var_Estatus !="P")THEN
					SET	Par_NumErr 		:= 904;
					SET	Par_ErrMen		:= CONCAT('La dispersion con datos: [',Var_DispersionID," ",Var_ClaveDispMov," ",Var_Monto,"]", "tiene un estatus ", Var_DescripcionEstatus);
                    SET Var_Control		:= 'rutaArchivo';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
                END IF;

                SELECT CRE.CreditoID  INTO Var_CreditoID
					FROM DISPERSIONMOV DIS
					INNER JOIN CREDITOS CRE ON DIS.CreditoID = CRE.CreditoID
					INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID =CRE.SolicitudCreditoID
				WHERE DIS.DispersionID= Var_DispersionID
				AND DIS.ClaveDispMov = Var_ClaveDispMov
				AND DIS.Estatus="A" OR DIS.Estatus="P"
                LIMIT 1;


                SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);
                IF(Var_CreditoID=Entero_Cero)THEN
					SET	Par_NumErr 		:= 904;
					SET	Par_ErrMen		:= CONCAT('No existe el credito para los datos: [',Var_DispersionID,", ",Var_ClaveDispMov,", $",Var_Monto,"]" );
                    SET Var_Control		:= 'rutaArchivo';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
                END IF;

                SET Var_TxtFolioProceso := CONCAT("FOLIO DISPERSION: ",Var_DispersionID,"-",Var_ClaveDispMov);
			    -- OBTENEMOS EL CODIGO DEL PROCESO DEL REGISTRO
                SELECT CodigoID INTO Var_FolioEstatus
					FROM CATSTATUSDISPERSIONES
					WHERE Descripcion= LOWER(Var_DesEstatus)
                    AND Banco = Con_BancoS
                    AND TipoOper = Con_Transferencia;

				SELECT DIS.InstitucionID,  		NumCtaInstit, 			NumCtaInstit,		DET.CuentaDestino
						INTO Var_Institucion,  	Var_CuentaAhoID,		Var_NumCtaInstit, 	Var_CuentaDestino
					FROM DISPERSION DIS
					INNER JOIN 	DISPERSIONMOV DET ON DET.DispersionID=DIS.FolioOperacion
					WHERE DIS.FolioOperacion=Var_DispersionID
					AND DET.ClaveDispMov = Var_ClaveDispMov
					AND IFNULL(DET.EstatusResSanta,Cadena_Vacia)!="20";

				SET Var_Institucion := IFNULL(Var_Institucion, Entero_Cero);
				SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);
				SET Var_NumCtaInstit := IFNULL(Var_NumCtaInstit, Cadena_Vacia);

				IF(Var_FolioEstatus=20 AND Var_NumCtaInstit!=Cadena_Vacia
					AND Var_CuentaAhoID!=Entero_Cero AND Var_Institucion!=Entero_Cero)THEN -- VALIDACION SI EL ESTATUS ES EJECUTADO
					-- ACTUALIZAMOS LA DISPERSION
					CALL DISPERSIONACT (Var_DispersionID,		Var_FechaSistema,		Var_Institucion, 	Var_CuentaAhoID,	Var_NumCtaInstit,
										Con_ActCuentas,			SalidaNo,				Par_NumErr,			Par_ErrMen,			Var_FolioSalida,
										Aud_EmpresaID,			Aud_Usuario,            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
										Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr!=Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

                    SET Var_Monto :=IFNULL(Var_Monto,Entero_Cero);

					-- REALIZAMOS LOS MOVIMIENTOS CONTABLES CORRESPONDIENTES
					CALL DISPERSIONMOVPRO(Var_ClaveDispMov, 	Var_DispersionID,		Var_CuentaDestino,	'A',				Var_Poliza,
										  Var_FechaSistema,		Cadena_Vacia,			Var_Monto,			SalidaNo,			Par_NumErr,
                                          Par_ErrMen,	 		Var_Consecutivo,		Aud_EmpresaID,		Aud_Usuario,        Aud_FechaActual,
                                          Aud_DireccionIP,	  	Aud_ProgramaID,       	Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr!=Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					-- ACTUALIZAMOS LA DISPERSION
					CALL DISPERSIONACT (Var_DispersionID,		Var_FechaSistema,		Var_Institucion, 	Var_CuentaAhoID,	Var_NumCtaInstit,
										Con_ActCierre,			SalidaNo,				Par_NumErr,			Par_ErrMen,			Var_FolioSalida,
										Aud_EmpresaID,			Aud_Usuario,            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
										Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr!=Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					-- VALIDAMOS SI EL ESTAUS ES RECHAZADO
					IF(FIND_IN_SET(Var_FolioEstatus, '01,02,03,05,06,14,15,16')>0)THEN
						-- ACTUALIZAMOS EL ESTATUS DE LA DISPERSION
						UPDATE  DISPERSIONMOV  SET
								Estatus				= Con_EstatusC,

								EmpresaID			= Aud_EmpresaID ,
								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID ,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE ClaveDispMov=Var_ClaveDispMov
							AND DispersionID = Var_DispersionID;
					END IF;



					-- ACTUALIZAMOS EL MOVIMIENTO DE LA DISPERSION
					UPDATE DISPERSIONMOV
						SET NombreArchivo	= Par_NombreArchivo,
							EstatusResSanta = Var_FolioEstatus,
							FechaLiquidacion = Var_FechaLiquidacion,
							FechaRechazo	= Var_FechaRechazo
					WHERE ClaveDispMov=Var_ClaveDispMov
					AND DispersionID = Var_DispersionID;
				END IF; -- FIN VALIDACION SI EL ESTATUS ES EJECUTADO

			END WHILE;
            -- FIN CLICLO PARA PROCESAR DISPERSIONES DE TRANSFERENCIAS

		END IF;



        /****************************************************************************
        *				PROCESO DE DISPERSIONES DE ORDEN DE PAGO					*
        *****************************************************************************/
        IF(Par_TipoAct=OrdenPagoSan)THEN
            SET @ConOrdenPag :=Entero_Cero;
			SET Var_CreditosVencidos := Entero_Cero;
            INSERT INTO TMPDISPERSIONESSANTANDER
							(Consecutivo,			NumTransaccion, 		NombreArchivo, 		Concepto,		Importe,
							 IVA,					Estatus,				NumeroPago,         Beneficiario,   Referencia,
                             FechaLiquidacion,		FechaRechazo)
			SELECT @ConOrdenPag:=@ConOrdenPag+1, 	NumTransaccion, 		NombreArchivo, 		Concepto,		Importe,
							CASE IFNULL(ImporteIVA,Cadena_Vacia) WHEN Cadena_Vacia THEN 0 ELSE ImporteIVA END AS IVA,
                            Estatus,		NumeroPago,         Beneficiario,   Referencia,
                            STR_TO_DATE(FechaLiquidacion, '%d/%m/%Y'),
                            CASE Estatus WHEN '51' THEN Var_FechaSistema ELSE Fecha_Vacia END AS FechaRechazo
				FROM DISPORDENPAGOSAN
				WHERE NombreArchivo=Par_NombreArchivo
				AND NumTransaccion=Aud_NumTransaccion;


            SELECT COUNT(NumTransaccion) INTO Var_CantDisper
				FROM TMPDISPERSIONESSANTANDER
                WHERE NombreArchivo=Par_NombreArchivo
				AND NumTransaccion=Aud_NumTransaccion;


            -- CLICLO PARA PROCESAR DISPERSIONES DE ORDEN DE PAGO
			WHILE Var_AuxiliarI<Var_CantDisper DO
				SET Var_AuxiliarI :=Var_AuxiliarI+1;
				SET Var_FolioEstatus := '';
				SET Var_Institucion := Entero_Cero;
				SET Var_CuentaAhoID := Entero_Cero;
				SET Var_NumCtaInstit := Cadena_Vacia;

				SELECT 	SUBSTRING_INDEX(Concepto, "X", 1) AS DispersionID,
						SUBSTRING(Concepto,LENGTH(SUBSTRING_INDEX(Concepto, "X", 1))+2,
                        (LENGTH(SUBSTRING_INDEX(Concepto, "X", 2))-(LENGTH(SUBSTRING_INDEX(Concepto, "X", 1))+1))) AS ClaveDispMov,
                        Estatus,
                        Importe,
                        NumeroPago,
                        Beneficiario,
                        Referencia,
                        FechaLiquidacion,
                        FechaRechazo,
                        Concepto
					INTO Var_DispersionID,
						 Var_ClaveDispMov,
                         Var_DesEstatus,
                         Var_Monto,
                         Var_NumeroPago,
                         Var_Beneficiario,
                         Var_Referencia,
                         Var_FechaLiquidacion,
                         Var_FechaRechazo,
                         Var_Concepto
				FROM TMPDISPERSIONESSANTANDER
				WHERE NombreArchivo=Par_NombreArchivo
					AND NumTransaccion=Aud_NumTransaccion
					AND Consecutivo=Var_AuxiliarI
                    LIMIT 1;
				SET Var_DispersionID :=IFNULL(Var_DispersionID, Entero_Cero);
				SET Var_ClaveDispMov :=IFNULL(Var_ClaveDispMov, Entero_Cero);

                IF(Var_DispersionID = Entero_Cero)THEN
					SET Par_NumErr := 901;
					SET Par_ErrMen := 'El numero de dispersion no existe.';
					SET Var_Control		:= 'rutaArchivo';
					LEAVE ManejoErrores;
				END IF;

				IF(Var_ClaveDispMov = Entero_Cero)THEN
					SET Par_NumErr := 902;
					SET Par_ErrMen := 'El detalle de la dispersion no existe.';
					SET Var_Control		:= 'rutaArchivo';
					LEAVE ManejoErrores;
				END IF;

                SELECT DIS.Estatus, CASE DIS.Estatus  WHEN "A" THEN "AUTORIZADO"
											  WHEN "P" THEN "PENDIENTE"
											  WHEN "N" THEN "NO APLICADA"
                                              WHEN "E" THEN "EXPORTADA"
                                              ELSE "CANCELADA" END
					INTO Var_Estatus, Var_DescripcionEstatus
					FROM DISPERSIONMOV DIS
					INNER JOIN CREDITOS CRE ON DIS.CreditoID = CRE.CreditoID
					INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID =CRE.SolicitudCreditoID
				WHERE DIS.DispersionID= Var_DispersionID
				AND DIS.ClaveDispMov = Var_ClaveDispMov
                LIMIT 1;

                IF(Var_Estatus !="A" AND Var_Estatus !="P")THEN
					SET	Par_NumErr 		:= 904;
					SET	Par_ErrMen		:= CONCAT('La dispersion con datos: [',Var_DispersionID," ",Var_ClaveDispMov," ",Var_Monto,"]", "tiene un estatus "+ Var_DescripcionEstatus);
                    SET Var_Control		:= 'rutaArchivo';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
                END IF;

                SELECT CRE.CreditoID  INTO Var_CreditoID
					FROM DISPERSIONMOV DIS
					INNER JOIN CREDITOS CRE ON DIS.CreditoID = CRE.CreditoID
					INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID =CRE.SolicitudCreditoID
				WHERE DIS.DispersionID= Var_DispersionID
				AND DIS.ClaveDispMov = Var_ClaveDispMov
				AND DIS.Estatus="A" OR DIS.Estatus="P"
                LIMIT 1;


                SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);
                IF(Var_CreditoID=Entero_Cero)THEN
					SET	Par_NumErr 		:= 904;
					SET	Par_ErrMen		:= CONCAT('No existe el credito para los datos: [',Var_DispersionID,", ",Var_ClaveDispMov,", $",Var_Monto,"]" );
                    SET Var_Control		:= 'rutaArchivo';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
                END IF;

				SET Var_TxtFolioProceso := CONCAT("FOLIO DISPERSION: ",Var_DispersionID,"-",Var_ClaveDispMov);

                -- ALTA DEL ENCABEZADO DE LA POLIZA
                IF(Var_AuxiliarI = 1)THEN
					CALL MAESTROPOLIZASALT(Var_Poliza,			Var_EmpresaID,		Var_FechaSistema,		Con_TipoPolizaAut,		Con_ConceptoDis,
										   Con_DesConcepto,		SalidaNo,			Par_NumErr,				Par_ErrMen,				Aud_Usuario,
										   Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,         Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr!=Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

				SELECT DIS.InstitucionID,  		NumCtaInstit, 			NumCtaInstit,		DET.CuentaDestino
						INTO Var_Institucion,  	Var_CuentaAhoID,		Var_NumCtaInstit,	Var_CuentaDestino
					FROM DISPERSION DIS
					INNER JOIN 	DISPERSIONMOV DET ON DET.DispersionID=DIS.FolioOperacion
					WHERE DIS.FolioOperacion=Var_DispersionID
					AND DET.ClaveDispMov = Var_ClaveDispMov
					AND IFNULL(DET.EstatusResSanta,Cadena_Vacia)!="52";
				
                SET Var_Institucion := IFNULL(Var_Institucion, Entero_Cero);
				SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);
				SET Var_NumCtaInstit := IFNULL(Var_NumCtaInstit, Cadena_Vacia);

				-- VALIDACION QUE LA DISPERSION ESTE EN ESTATUS "GENERADA"
                IF(Var_NumCtaInstit!=Cadena_Vacia AND Var_CuentaAhoID!=Entero_Cero AND Var_Institucion!=Entero_Cero)THEN
					-- OBTENEMOS EL CODIGO DEL PROCESO DEL REGISTRO
					SELECT CodigoID INTO Var_FolioEstatus
						FROM CATSTATUSDISPERSIONES
						WHERE Descripcion=Var_DesEstatus
						AND Banco = Con_BancoS
						AND TipoOper = Con_OrdenPago;

					CASE Var_FolioEstatus
						WHEN '52' THEN -- VALIDACION DE ESTATUS DE LIQUIDACION
							SET Var_Beneficiario := TRIM(IFNULL(Var_Beneficiario, Cadena_Vacia));
							-- ACTUALIZAMOS LA DISPERSION
							CALL DISPERSIONACT (Var_DispersionID,		Var_FechaSistema,		Var_Institucion, 	Var_CuentaAhoID,	Var_NumCtaInstit,
												Con_ActCuentas,			SalidaNo,				Par_NumErr,			Par_ErrMen,			Var_FolioSalida,
												Aud_EmpresaID,			Aud_Usuario,            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
												Aud_Sucursal,			Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							-- REALIZAMOS LOS MOVIMIENTOS CONTABLES CORRESPONDIENTES
							CALL DISPERSIONMOVPRO(Var_ClaveDispMov, 	Var_DispersionID,		Var_CuentaDestino,	'A',				Var_Poliza,
												  Var_FechaSistema,		Cadena_Vacia,			Var_Monto,			SalidaNo,			Par_NumErr,
												  Par_ErrMen,		  	Var_Consecutivo,		Aud_EmpresaID,		Aud_Usuario,        Aud_FechaActual,
												  Aud_DireccionIP,	  	Aud_ProgramaID,       	Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							SELECT CRE.ClienteID INTO Var_ClienteID
								FROM DISPERSIONMOV DIS
								INNER JOIN CREDITOS CRE ON CRE.CreditoID=DIS.CreditoID
								WHERE DIS.ClaveDispMov = Var_ClaveDispMov
								AND DIS.DispersionID= Var_DispersionID
								AND IFNULL(DIS.CreditoID, Entero_Cero)!=Entero_Cero;

							SET Var_ClienteID := IFNULL(Var_ClienteID, Entero_Cero);

							IF(Var_ClienteID!=Entero_Cero)THEN
								CALL ORDENPAGODESCREDALT(Var_ClienteID,		Var_Institucion,		Var_NumCtaInstit,		Var_NumeroPago,		Var_Monto,
														Var_Beneficiario,	Var_Referencia, 		Var_Concepto,			Cadena_Vacia,		SalidaNo,
														Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,        Aud_FechaActual,
														Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

								IF(Par_NumErr!=Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;
							END IF;

							-- ACTUALIZAMOS LA DISPERSION
							CALL DISPERSIONACT (Var_DispersionID,		Var_FechaSistema,		Var_Institucion, 	Var_CuentaAhoID,	Var_NumCtaInstit,
												3,						SalidaNo,				Par_NumErr,			Par_ErrMen,			Var_FolioSalida,
												Aud_EmpresaID,			Aud_Usuario,            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
												Aud_Sucursal,			Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							SET Var_ContLiquidado := Var_ContLiquidado+1;

							/* Se Actualiza el Estatus de la Orden de Pago*/
							CALL REFORDENPAGOSANACT(
									Var_DispersionID,		Var_ClaveDispMov,	Cadena_Vacia,		Act_Ejecutado,		SalidaNo,
									Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,    	Aud_FechaActual,
									Aud_DireccionIP,    	Aud_ProgramaID,	    Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

						WHEN '50' THEN -- VALIDACION DE ESTATUS ES VENCIDO
							CALL CANCELACIONORDPAGPRO(Var_DispersionID,		Var_ClaveDispMov,		SalidaNo,			Par_NumErr,			Par_ErrMen,
													  Aud_EmpresaID,		Aud_Usuario,    		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
													  Aud_Sucursal,			Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
                            
                            -- ACTUALIZAMOS EL FOLIO DE DISPERSION
                           CALL CREDITOSACT(   Var_CreditoID,	Entero_Cero,	Fecha_Vacia,	Entero_Cero,	5,
												Fecha_Vacia,	Fecha_Vacia,	Entero_Cero,	Entero_Cero, 	Entero_Cero,
												Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,	SalidaNo,		Par_NumErr,			
												Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,    Aud_FechaActual,Aud_DireccionIP,    
												Aud_ProgramaID, Aud_Sucursal,	Aud_NumTransaccion);	

							IF(Par_NumErr!=Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
                            SET Var_CreditosVencidos := CONCAT(Var_CreditosVencidos,",",Var_CreditoID);
							SET Var_ContVencido := Var_ContVencido+1;
						WHEN '51' THEN -- VALIDACION DE ESTATUS ES CANCELADO
							CALL CANCELACIONORDPAGPRO(Var_DispersionID,		Var_ClaveDispMov,		SalidaNo,			Par_NumErr,			Par_ErrMen,
													  Aud_EmpresaID,		Aud_Usuario,    		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
													  Aud_Sucursal,			Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							SET Var_ContCancelado := Var_ContCancelado+1;
						WHEN '53' THEN -- VALIDACION DE ESTATUS ES PENDIENTE DE COBRO POR EL CLIENTE
							SET Var_ContPendiente := Var_ContPendiente+1;

							/* Se Actualiza el Estatus de la Orden de Pago*/
							CALL REFORDENPAGOSANACT(
									Var_DispersionID,		Var_ClaveDispMov,	Cadena_Vacia,		Act_Proceso,		SalidaNo,
									Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,    	Aud_FechaActual,
									Aud_DireccionIP,    	Aud_ProgramaID,	    Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
						WHEN '54' THEN -- VALIDACION DE ESTATUS RECHAZADO
							CALL CANCELACIONORDPAGPRO(Var_DispersionID,		Var_ClaveDispMov,		SalidaNo,			Par_NumErr,			Par_ErrMen,
													  Aud_EmpresaID,		Aud_Usuario,    		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
													  Aud_Sucursal,			Aud_NumTransaccion);

							IF(Par_NumErr!=Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							SET Var_ContCancelado := Var_ContCancelado+1;
						ELSE
							SET Var_ContPendiente := Var_ContPendiente;
					END CASE;
                     -- ACTUALIZAMOS EL MOVIMIENTO DE LA DISPERSION
					UPDATE DISPERSIONMOV
						SET NombreArchivo	= Par_NombreArchivo,
							EstatusResSanta = Var_FolioEstatus,
							FechaLiquidacion = Var_FechaLiquidacion,
							FechaRechazo = Var_FechaRechazo
					WHERE ClaveDispMov=Var_ClaveDispMov
					AND DispersionID = Var_DispersionID;
				END IF;

			END WHILE;
            -- FIN CLICLO PARA PROCESAR DISPERSIONES DE ORDEN DE PAGO


			-- ACTUALIZAMOS EL FOLIO DE DISPERSION DE LAS ORDENES DE PAGOS VENCIDAS
            UPDATE CREDITOS SET
				FolioDispersion	= Entero_Cero,

				EmpresaID       = Aud_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
			WHERE CreditoID IN (Var_CreditosVencidos);

            -- INSERTAMOS LOS TOTALES DE LOS ESTATUS PROCESADOS
            INSERT INTO DISPRESPUESTAORDPAGO
					(NombreArchivo,          ContVencido,        ContCancelado,          ContLiquidado,        ContPendiente,
					 EmpresaID,              Usuario,            FechaActual,            DireccionIP,          ProgramaID,
					 Sucursal,               NumTransaccion)
			VALUES(Par_NombreArchivo,		 Var_ContVencido,    Var_ContCancelado,      Var_ContLiquidado,    Var_ContPendiente,
				   Aud_EmpresaID,			 Aud_Usuario,    	 Aud_FechaActual,		 Aud_DireccionIP,      Aud_ProgramaID,
                   Aud_Sucursal,			 Aud_NumTransaccion);

        END IF;


        -- ELIMINAMOS LOS DATOS DE LA TEMPORAL
        DELETE FROM TMPDISPERSIONESSANTANDER
			WHERE NombreArchivo=Par_NombreArchivo
            AND NumTransaccion=Aud_NumTransaccion;

        IF(Par_NumErr=Entero_Cero)THEN
			SET Par_NumErr		:= 0;
			SET Par_ErrMen 		:= CONCAT('Dispersion generada exitosamentente. [',Par_NombreArchivo,']');
			SET Var_Control		:= 'rutaArchivo';
			SET Var_Consecutivo := Aud_NumTransaccion;
        END IF;

	END ManejoErrores;

	IF(Par_NumErr!=0)THEN
		SET Par_ErrMen := CONCAT(Var_TxtFolioProceso,"-",Par_ErrMen);
	END IF;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;


END TerminaStore$$