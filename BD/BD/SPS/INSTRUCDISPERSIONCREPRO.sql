-- INSTRUCDISPERSIONCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTRUCDISPERSIONCREPRO`;

DELIMITER $$
CREATE PROCEDURE `INSTRUCDISPERSIONCREPRO`(
	/* SP DE PROCESO PARA REALIZAR LAS INSTRUCCIONES DE DISPERSION */
	Par_CreditoID			BIGINT(12),
	Par_CuentaAhoID			BIGINT(12),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(100);		-- Variable de Control
	DECLARE Var_ClienteID			BIGINT;				-- Numero de Cliente
	DECLARE Var_FechaSistema		DATE;				-- Fecha de Sistema

	DECLARE Var_SPEIHabilitado		CHAR(1);			-- Variable para obtener si esta habilitado SPEI
	DECLARE Var_FolioEnvio			BIGINT(20);			-- Variable para obtener el folio de envio
	DECLARE Var_ClaveRastreo		VARCHAR(30);		-- Variable para obtener la clave de rastreo
	DECLARE Var_ComisionTrans		DECIMAL(16,2);		-- Variable para almacenar la comision de tranferencia
    DECLARE Var_ComisionIVA			DECIMAL(16,2);		-- Variable para almacenar le IVA de comision
    DECLARE Var_TipoCuentaID		INT(11);			-- Variable para obtener el tipo cuenta de la cuenta de ahorro del ordenante
    DECLARE Var_TotalCargoCuenta	DECIMAL(18,2);		-- Variable para almacenar el cargo total
    DECLARE Var_ClabeOrdenante		VARCHAR(20);		-- Variable para obtener la cable de la cuenta ordenante
    DECLARE Var_NombreOrdenante		VARCHAR(100);		-- Variable para obtener el nombre del ordenante
    DECLARE Var_RFCOrdenante		VARCHAR(18);		-- Variable para obtener el rfc del ordenante
    DECLARE Var_InstitRecep			INT(5);				-- Variable para obtener la institucion receptora
    DECLARE Var_TipoCuentaBen		INT(2);				-- Variable para obtener el tipo cuenta del beneficiario
    DECLARE Var_NombreBenefi		VARCHAR(100);		-- Variable para obtener el nombre del beneficiario
    DECLARE Var_RFCBenefi			VARCHAR(100);		-- Variable para obtener el rfc del beneficiario
    DECLARE Var_CliCuentaTrans		INT(11);			-- Variable para obtener el cliente de la cuenta CLABE del credito
    DECLARE Var_ReferenciaNum		INT(7);				-- Variable para almacenar la referencia numerica del envio SPEI
    DECLARE Var_UsuEnvioSPEI		VARCHAR(30);		-- Variable para almacenar el usuario de envio SPEI
    DECLARE Var_FechaSinGuion		VARCHAR(7);			-- Variable para almacenar la fecha sin guiones
    DECLARE Var_InstiRemi			INT(11);			-- Variable para almacenar la institucion remitente
    DECLARE Var_PrioEnvio			INT(1);				-- Variable para obtener la prioridad de envio
    DECLARE Var_FechaAuto			DATETIME;			-- Variable para almacenar la fecha de autorizacion
    DECLARE Var_FechaRecep			DATETIME;			-- Variable para almacenar la fecha de recepcion
    DECLARE Var_TipoConexion		CHAR(1);			-- Variable para almacenar el tipo conexion de SPEI
	DECLARE Var_montoReqAuTesor		DECIMAL(14,2);		-- variable para almacenar el monto de autorizacion de tesoreria

	DECLARE Var_CuentaCLABE			VARCHAR(18);
	DECLARE Var_MontoADisper		DECIMAL(14,2);
	DECLARE Var_MonedaID			INT(11);
	DECLARE Var_TipoDisper			CHAR(1);

	DECLARE Var_Contador			INT(11);			-- Variable Contador
	DECLARE Var_SoliciCredID		BIGINT(20);
	DECLARE Var_NumInstruc			INT(11);            -- Variable Numero de Instrucciones
	DECLARE Var_TipoCuentaDisper	TINYINT UNSIGNED;	-- Tipo Cuenta de Instruccione de Dispersion
	DECLARE Est_FinalEstatus		CHAR(1);			-- Estatus final con el que sera guardado el Envio de SPEI
	DECLARE Var_ConcepPagoDis		VARCHAR(40);		-- Concepto del pago Dispersion SPEI
	DECLARE Var_BloqueoID			INT(11);			-- ID de Bloqueo referente a la tabla de BLOQUEOS
	DECLARE Var_TipoDispersionID	CHAR(1);			-- Tipo de Dispersion
	DECLARE Var_MontoCliCartas 		DECIMAL(14,2);		-- Monto disponible del cliente despues de cubrir las cartas.
	DECLARE Var_MontoInstDisper 	DECIMAL(14,2); 		-- Monto de Instrucciones Dispersion del Cliente (No Cartas)
	DECLARE Var_MontoBloqueo 		DECIMAL(14,2); 		-- Monto a Bloquear del credito
	DECLARE Var_MontoPorDesemb		DECIMAL(14,2);		-- MOnto por Desembolsar del Credito

-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Estatus_Inactivo	CHAR(1);
	DECLARE Est_Verif			CHAR(1);		-- Estatus verificado SPEI ENVIO
	DECLARE Est_Pend			CHAR(1);		-- estatus pendiente spei envio

	DECLARE Var_TipoPagoTercer	INT(1);			-- Tipo pago Tercero a Tercero del catalogo TIPOSPAGOSPEI
	DECLARE Var_TipoCuentaOrd	INT(2);			-- Tipo cuenta cable del catalogo TIPOSCUENTASPEI
	DECLARE Var_ConceptoPago	VARCHAR(40);	-- Concepto del pago SPEI Desembolso
	DECLARE Var_ConceptoPagCred	VARCHAR(40);	-- Concepto del pago SPEI Cartas Liquidacion Externas
	DECLARE Var_AreaBanco		INT(1);			-- Area emite banco SPEI
	DECLARE Var_OrigenOperVent	CHAR(1);		-- Origen operacion ventanilla

	DECLARE Salida_No			CHAR(1);		-- Salida N=No
	DECLARE Salida_Si			CHAR(1);		-- Salida S=Si
	DECLARE Var_TipoCueClabe	INT(2);			-- Constante de tipo cuenta 40 CLABE del beneficiario
	DECLARE Var_SPEI			CHAR(1);		-- Tipo de Dispersion SPEI 'S'
	DECLARE Var_StrSi			CHAR(1);		-- String S=Si
	DECLARE Var_TipDisCliente	TINYINT UNSIGNED;	-- Tipo Instrucciones Dispersion del Cliente
	DECLARE Var_TipDisLiqExt	TINYINT UNSIGNED;	-- Tipo Instrucciones Dispersion Cartas Liquidacion Externas
	DECLARE Act_EstatusDesemPen	INT(11);			-- Actualiza el estatus a P) Pendiente cuando el SPEI es por desembolso
	DECLARE NatMovBloqueo		CHAR(1);
	DECLARE TipoBloqueo			INT(11);
	DECLARE DescripBloqueo		VARCHAR(100);
	DECLARE TipoDisperCheque	CHAR(1);		-- Tipo dispersion por cheque
	DECLARE TipoDisperOrden		CHAR(1);		-- Tipo dispersion por Orden
	DECLARE TipoDisperSantan	CHAR(1);		-- Tipo dispersion por santander
	DECLARE TipoDisperEfectivo	CHAR(1);		-- Tipo dispersion por Efectivo
	DECLARE Var_BenefiDisperID	INT(11);		-- ID de la isntruccion de dispersion
	DECLARE Var_MontoTotalDisp	DECIMAL(14,2);	-- Total de lo qeue se ha dispersado


-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';						-- String Vacio
	SET Fecha_Vacia				:= '1900-01-01';			-- Fecha Vacia
	SET Entero_Cero				:= 0;						-- Entero en Cero
	SET Decimal_Cero			:= 0.00;					-- DECIMAL Cero
	SET Estatus_Activo			:= 'A';						-- Estatus Activo
	SET Estatus_Inactivo		:= 'I';						-- Estatus Inactivo
	SET Est_Verif				:= 'V';						-- Estatus verificado SPEI ENVIO
	SET Est_Pend				:= 'P';						-- Estatus de pendiente en SPEI envio

	SET Var_TipoPagoTercer		:= 1;						-- Tipo pago Tercero a Tercero del catalogo TIPOSPAGOSPEI
	SET Var_TipoCuentaOrd		:= 40;						-- Tipo cuenta cable del catalogo TIPOSCUENTASPEI
	SET Var_ConceptoPago		:= 'DESEMBOLSO DE CREDITO';	-- Concepto del pago SPEI
	SET Var_ConceptoPagCred		:= 'PAGO DE CREDITO';		-- Concepto del pago credito cartas liq. externas SPEI

	SET Var_AreaBanco			:= 8;						-- Area emite banco SPEI
    SET Var_OrigenOperVent		:= 'V';						-- Origen operacion ventanilla

	SET Salida_No				:= 'N';						-- Ejecutar Store sin Regreso o Mensaje de Salida
	SET Salida_Si				:= 'S';						-- Salida Si
	SET Var_TipoCueClabe		:= 40;						-- Tipo de Cuenta CLABE
	SET Var_SPEI 				:= 'S';						-- Tipo Disporsion S = SPEI
	SET Var_StrSi				:= 'S';						-- String S= Si
	SET Var_TipDisCliente		:= 1;						-- Tipo Instrucciones Dispersion del Cliente
	SET Var_TipDisLiqExt		:= 2;						-- Tipo Instrucciones Dispersion de Cartas Liquidacion Externas
	SET Act_EstatusDesemPen		:= 11;						-- Actualiza el estatus a P) Pendiente cuando el SPEI es por desembolso
	SET NatMovBloqueo  			:= 'B';						-- Tipo de Movimiento de Bloqueo de Saldo en Cta de Ahorro
	SET TipoBloqueo 			:= 1;						-- Tipo de Movimiento de Bloqueo Dispersion
	SET DescripBloqueo			:= 'BLOQUEO DE SALDO POR INSTRUC DISPERSION';

	SET TipoDisperCheque		:= 'C';						-- Tipo dispersion por cheque
	SET TipoDisperOrden			:= 'O';						-- Tipo dispersion por Orden
	SET TipoDisperSantan		:= 'A';						-- Tipo dispersion por santander
	SET TipoDisperEfectivo		:= 'E';						-- Tipo dispersion por Efectivo


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr 	:= 999;
			SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-INSTRUCDISPERSIONCREPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SELECT 		Par.Clabe,				Par.Habilitado,		Inst.NombreCorto,		Inst.RFC,			Par.ParticipanteSpei,
					Par.Prioridad,			Par.TipoOperacion,	Par.MonReqAutTeso
			INTO 	Var_ClabeOrdenante,		Var_SPEIHabilitado,	Var_NombreOrdenante,	Var_RFCOrdenante,	Var_InstiRemi,
					Var_PrioEnvio,			Var_TipoConexion,	Var_montoReqAuTesor
		FROM PARAMETROSSPEI Par
		LEFT JOIN INSTITUCIONES Inst ON Par.ParticipanteSpei = Inst.ClaveParticipaSpei
		LIMIT 1;

		SET Var_ClabeOrdenante	:= IFNULL(Var_ClabeOrdenante, Cadena_Vacia);
		SET Var_SPEIHabilitado 	:= IFNULL(Var_SPEIHabilitado, Salida_No);
		SET Var_NombreOrdenante := IFNULL(Var_NombreOrdenante, Cadena_Vacia);
		SET Var_RFCOrdenante 	:= IFNULL(Var_RFCOrdenante, Cadena_Vacia);
		SET Var_InstiRemi		:= IFNULL(Var_InstiRemi, Entero_Cero);
		SET Var_PrioEnvio		:= IFNULL(Var_PrioEnvio, Entero_Cero);
		SET Var_TipoConexion	:= IFNULL(Var_TipoConexion, Cadena_Vacia);
		SET Var_montoReqAuTesor	:= IFNULL(Var_montoReqAuTesor,Entero_Cero);

	 	SELECT 	Cre.ClienteID, 	Cre.MonedaID,	Cre.SolicitudCreditoID, Cre.MontoClienteCartas, Cre.MontoPorDesemb
		INTO 	Var_ClienteID,	Var_MonedaID, 	Var_SoliciCredID,		Var_MontoCliCartas,		Var_MontoPorDesemb
		FROM 	CREDITOS Cre
		WHERE Cre.CreditoID	= Par_CreditoID;

		SELECT SUBSTRING(NombreCompleto, 1,30)
				INTO Var_UsuEnvioSPEI
				FROM USUARIOS
				WHERE UsuarioID =  Aud_Usuario;

		SET Var_UsuEnvioSPEI := IFNULL(Var_UsuEnvioSPEI, Cadena_Vacia);

		SELECT 	SUBSTRING(DATE_FORMAT(FechaSistema, '%y%m%d'), 1, 7),
				FechaSistema
			INTO Var_FechaSinGuion, Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT 1;

		SET Var_FechaSinGuion := IFNULL(Var_FechaSinGuion, Cadena_Vacia);
		SET Var_ReferenciaNum := CAST(Var_FechaSinGuion AS UNSIGNED);

		DELETE FROM TMPBENEFIDISPER
		WHERE 	SolicitudCreditoID = Var_SoliciCredID
		AND 	NumTransaccion = Aud_NumTransaccion;

		SET @idConsecutivo:= 0;

		-- Instrucciones de Dispersion que se Registraron en la pantalla.(No cartas Externas, No Internas)
		INSERT TMPBENEFIDISPER(
			ConsecutivoID,				SolicitudCreditoID, BenefiDisperID, 	Beneficiario,	Cuenta,
			MontoDispersion,			TipoCuentaDisper,	TipoDispersionID,	NumTransaccion)
		SELECT (@idConsecutivo := @idConsecutivo +1 ), Ben.SolicitudCreditoID, Ben.BenefiDisperID, Ben.Beneficiario, Ben.Cuenta,
				Ben.MontoDispersion, 	Ben.PermiteModificar,	Ben.TipoDispersionID, Aud_NumTransaccion
			FROM BENEFICDISPERSIONCRE Ben INNER JOIN SOLICITUDCREDITO Sol
				ON Sol.SolicitudCreditoID =  Ben.SolicitudCreditoID
			WHERE Ben.SolicitudCreditoID 	= Var_SoliciCredID
			 AND Ben.PermiteModificar 		= Var_TipDisCliente; -- Instrucciones Registradas en Pantalla

		-- Validar que el monto de las instrucciones dispersion cliente no sean mayores al monto disponible cliente
		SET Var_MontoInstDisper 	:= (SELECT SUM(MontoDispersion) FROM TMPBENEFIDISPER
												WHERE SolicitudCreditoID 	= Var_SoliciCredID
												  AND NumTransaccion 		= Aud_NumTransaccion);



		-- Incluir las Cartas Liq. Externas
		INSERT TMPBENEFIDISPER(
			ConsecutivoID,				SolicitudCreditoID, BenefiDisperID, 	Beneficiario,	Cuenta,
			MontoDispersion,			TipoCuentaDisper,	TipoDispersionID,	NumTransaccion)
		SELECT (@idConsecutivo := @idConsecutivo +1 ), Ben.SolicitudCreditoID, Ben.BenefiDisperID, Ben.Beneficiario, Ben.Cuenta,
				Ben.MontoDispersion, 	Ben.PermiteModificar,	Ben.TipoDispersionID, Aud_NumTransaccion
			FROM BENEFICDISPERSIONCRE Ben INNER JOIN SOLICITUDCREDITO Sol
				ON Sol.SolicitudCreditoID =  Ben.SolicitudCreditoID
			WHERE Ben.SolicitudCreditoID 	= Var_SoliciCredID
			 AND Ben.PermiteModificar 		= Var_TipDisLiqExt; -- Instrucciones para cartas externas


		SET Var_NumInstruc 	:= (SELECT COUNT(SolicitudCreditoID) FROM TMPBENEFIDISPER
								WHERE SolicitudCreditoID 	= Var_SoliciCredID
								  AND NumTransaccion 		= Aud_NumTransaccion);
		SET Var_Contador 	:= 1;
		SET Var_MontoTotalDisp := 0.0;
		-- Si tenemos instrucciones de dispersion recorremos las instrucciones de dispersion
		WHILE Var_Contador <= Var_NumInstruc DO

			SET Var_NombreBenefi 		:= Cadena_Vacia;
			SET Var_TipoCuentaBen		:= Entero_Cero;
			SET Var_RFCBenefi 			:= Cadena_Vacia;
			SET Var_InstitRecep			:= Entero_Cero;
			SET Var_CuentaCLABE 		:= Cadena_Vacia;
			SET Var_MontoADisper 		:= Decimal_Cero;
			SET Var_TipoCuentaDisper	:= Entero_Cero;

			SET Var_TipoCuentaBen 		:= Entero_Cero;
			SET Var_RFCBenefi 			:= Cadena_Vacia;
			SET Var_InstitRecep 		:= Entero_Cero;
			SET Var_CliCuentaTrans 		:= Entero_Cero;

			SELECT  Beneficiario,		TipoCuentaSpei,			RFC,					InstitucionID,		Cuenta,
					MontoDispersion,	TipoCuentaDisper,		TipoDispersionID,		BenefiDisperID
			INTO 	Var_NombreBenefi,	Var_TipoCuentaBen,		Var_RFCBenefi,			Var_InstitRecep, 	Var_CuentaCLABE,
					Var_MontoADisper,	Var_TipoCuentaDisper,	Var_TipoDispersionID,	Var_BenefiDisperID
			FROM TMPBENEFIDISPER
			WHERE ConsecutivoID 		= Var_Contador
			  AND SolicitudCreditoID	= Var_SoliciCredID
			  AND NumTransaccion 		= Aud_NumTransaccion;
			 -- Si el tipo de dispersion es  SPEI Intenamos enviar el proceso
			IF (Var_TipoDispersionID = Var_SPEI) THEN
				IF (Var_TipoCuentaDisper = Var_TipDisCliente) THEN
					-- Validar que la cuenta sean del mismo cliente y obtener el tipo y la institucion
					SELECT	ClienteID,			TipoCuentaSpei, 	RFCBeneficiario, 	InstitucionID
					INTO 	Var_CliCuentaTrans,	Var_TipoCuentaBen,	Var_RFCBenefi,		Var_InstitRecep
					FROM CUENTASTRANSFER
					WHERE Clabe 		= Var_CuentaCLABE
					  AND ClienteID		= Var_ClienteID
					  AND Estatus		= Estatus_Activo
					LIMIT 1;

					SET Var_CliCuentaTrans := IFNULL(Var_CliCuentaTrans, Entero_Cero);
					IF ( Var_CliCuentaTrans != Var_ClienteID) THEN
						SET Par_NumErr := 002;
						SET Par_ErrMen := 'La cuenta CLABE no corresponde al cliente';
						SET Var_Control := 'creditoID';
						LEAVE ManejoErrores;
					END IF;
				END IF;
				SET Var_NombreBenefi 	:= IFNULL(Var_NombreBenefi, Cadena_Vacia);
				SET Var_TipoCuentaBen 	:= IFNULL(Var_TipoCuentaBen, Entero_Cero);
				SET Var_RFCBenefi 		:= IFNULL(Var_RFCBenefi, Cadena_Vacia);
				SET Var_InstitRecep 	:= IFNULL(Var_InstitRecep, Entero_Cero);

				IF (Var_TipoCuentaDisper = Var_TipDisLiqExt) THEN
					SET Var_ConcepPagoDis 	:= Var_ConceptoPago;
				ELSE
					SET Var_ConcepPagoDis	:= Var_ConceptoPagCred;
				END IF;

				-- Si el SPEI esta encendido se hace la dispersion
				IF (Var_SPEIHabilitado =  Salida_Si) THEN
					-- SE REALIZA LA VALIDACION DE ESTATUS AUTORIZADO O PENDIENTE SEGUN EL MONTO A DESEMBOLSAR
					IF(Var_MontoADisper >= Var_montoReqAuTesor)	THEN
						SET	Est_FinalEstatus	:=	Est_Pend;
					ELSE
						SET	Est_FinalEstatus	:=	Est_Verif;
					END IF;

					SET Var_ComisionTrans 		:= Decimal_Cero;
					SET Var_ComisionIVA 		:= Decimal_Cero;
					SET Var_TotalCargoCuenta 	:= Var_MontoADisper + Var_ComisionTrans + Var_ComisionIVA;

					SET Var_FechaAuto 	:= CURRENT_TIMESTAMP();
					SET Var_FechaRecep 	:= CURRENT_TIMESTAMP();

					-- SE REGISTRA EL SPEI ENVIO
					CALL SPEIENVIOSPRO (
						Var_FolioEnvio, 	Var_ClaveRastreo, 		Var_TipoPagoTercer,		Par_CuentaAhoID,	Var_TipoCuentaOrd,
						Var_ClabeOrdenante,	Var_NombreOrdenante,	Var_RFCOrdenante,		Var_MonedaID,		Entero_Cero,
						Var_MontoADisper,	Decimal_Cero,			Var_ComisionTrans,		Var_ComisionIVA,	Var_TotalCargoCuenta,
						Var_InstitRecep,	Var_CuentaCLABE,		Var_NombreBenefi,		Var_RFCBenefi,		Var_TipoCuentaBen,
						Var_ConcepPagoDis,	Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,
						Cadena_Vacia,		Cadena_Vacia,			Var_ReferenciaNum,		Var_UsuEnvioSPEI,	Var_AreaBanco,
						Var_OrigenOperVent,	Salida_No,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF (Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL SPEIENVIOSDESEMBOLSOALT(
						Var_FolioEnvio,		Par_CreditoID,		Var_BloqueoID,			Salida_No,				Par_NumErr,
						Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL SPEIENVIOSACT(
						Var_FolioEnvio,		Cadena_Vacia,		Entero_Cero,			Entero_Cero,			Cadena_Vacia,
						Cadena_Vacia,		Entero_Cero,		Entero_Cero,			Act_EstatusDesemPen,	Salida_No,
						Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
					IF (Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
					-- Registramos la instruccion de dispersion del credito como DISPERSADA en la tabla de control
					CALL CTRINSTRUCCIONESDISPALT(
						Var_BenefiDisperID,	Par_CreditoID,		Entero_Cero,		Entero_Cero,	Var_TipoDispersionID,
						Var_TipoCuentaDisper,	Var_MontoADisper,	Aud_FechaActual,	Fecha_Vacia,	Salida_Si,
						Salida_No,			Salida_No,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					SET Var_MontoTotalDisp := Var_MontoTotalDisp + Var_MontoADisper;
					IF (Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
				ELSE -- Si el SPEI no esta habilitado se procede a bloquear el saldo y dar de alta la instruccion
					-- Registramos la instruccion de dispersion del credito como No Dispersada en la tabla de control
					CALL CTRINSTRUCCIONESDISPALT(
						Var_BenefiDisperID,	Par_CreditoID,		Entero_Cero,		Entero_Cero,	Var_TipoDispersionID,
						Var_TipoCuentaDisper,	Var_MontoADisper,	Aud_FechaActual,	Fecha_Vacia,	Salida_No,
						Salida_No,			Salida_No,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

			END IF;
			IF Var_TipoDispersionID = TipoDisperEfectivo  THEN

				SET Var_MontoTotalDisp := Var_MontoTotalDisp + Var_MontoADisper;
				CALL CTRINSTRUCCIONESDISPALT(
					Var_BenefiDisperID,	Par_CreditoID,		Entero_Cero,		Entero_Cero,	Var_TipoDispersionID,
					Var_TipoCuentaDisper,	Var_MontoADisper,	Aud_FechaActual,	Fecha_Vacia,	Salida_Si,
					Salida_No,			Salida_No,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF( Var_TipoDispersionID != TipoDisperEfectivo AND Var_TipoDispersionID != Var_SPEI)THEN
				CALL CTRINSTRUCCIONESDISPALT(
					Var_BenefiDisperID,	Par_CreditoID,		Entero_Cero,		Entero_Cero,	Var_TipoDispersionID,
					Var_TipoCuentaDisper,	Var_MontoADisper,	Aud_FechaActual,	Fecha_Vacia,	Salida_No,
					Salida_No,			Salida_No,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Var_Contador := Var_Contador + 1;
		END WHILE;

		-- Se obtiene el monto total de lo que se dispersará para bloquear
		SET Var_MontoBloqueo := (SELECT SUM(MontoDispersion) FROM TMPBENEFIDISPER
										WHERE SolicitudCreditoID 	= Var_SoliciCredID
										AND NumTransaccion 		= Aud_NumTransaccion);
		IF(Var_NumInstruc > 0) THEN -- Si hubo instrucciones de dispersion se resta de monto_bloqueo
			SET Var_MontoBloqueo := Var_MontoBloqueo - Var_MontoTotalDisp;
		END IF;

		IF Var_MontoBloqueo > Decimal_Cero THEN
			-- Realiza el Bloqueo
			CALL BLOQUEOSPRO(
				Entero_Cero,		NatMovBloqueo,		Par_CuentaAhoID,		Var_FechaSistema,	Var_MontoBloqueo,
				Fecha_Vacia,		TipoBloqueo,		DescripBloqueo,			Par_CreditoID,		Cadena_Vacia,
				Cadena_Vacia,		Salida_No,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		DELETE FROM TMPBENEFIDISPER
		WHERE SolicitudCreditoID	= Var_SoliciCredID
		AND NumTransaccion 		= Aud_NumTransaccion;

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Proceso Aplicacion de Instrucciones de Dispersion Realizado Correctamente';
		SET Var_Control:= 'creditoID';

	END ManejoErrores;

IF (Par_Salida = Salida_Si) THEN
	SELECT 	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_CreditoID AS Consecutivo;
END IF;

END TerminaStore$$