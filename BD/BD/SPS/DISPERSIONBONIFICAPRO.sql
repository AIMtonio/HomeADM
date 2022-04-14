-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONBONIFICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONBONIFICAPRO`;

DELIMITER $$
CREATE PROCEDURE `DISPERSIONBONIFICAPRO`(
	# ===============================================================
	# ---- SP PARA OBTENER LAS BONIFICACIONES POR DISPERSION-----
	# ===============================================================
	Par_InstitucionID 		INT(11),		-- Intitucion
	Par_NumCtaInstit 		VARCHAR(20),	-- Cuenta de Institucion
	Par_Fecha				DATE,			-- Fecha de Registro

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr 		INT(11),		-- numero de Error
	INOUT Par_ErrMen 		VARCHAR(400),	-- Mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaSistema		DATE;			-- Fecha del Sistema
	DECLARE Var_SiHabilita			CHAR(1);		-- Indica si Habilita Fecha de Dispersion
	DECLARE	Var_SpeiHab				CHAR(1);		-- indica el estatus de habilitado de SPEI
	DECLARE Var_TipoPersona			CHAR(1);		-- Tipo de Cliente
	DECLARE Var_TipoDispersion		CHAR(1);		-- Tipo de Dispercion

	DECLARE Var_TipoChequera		CHAR(2);		-- Tipo de Chequera
	DECLARE Var_TipoMovDis			CHAR(4);		-- Tipo de Movimiento de Dispercion
	DECLARE Var_Dispersiones 		CHAR(10);		-- cambia de acuerdo a los tipos de dispersion habilitados
	DECLARE Var_SucursalID			INT(11);		-- Sucursal de la Cuenta de Ahorro
	DECLARE Var_Institucion			INT(11);		-- Intitucion

	DECLARE Var_FolioOperacion		INT(11);		-- Folio de Operacion
	DECLARE Var_FormaPago			INT(11);		-- Forma de Pago
	DECLARE Var_NumConsecutivo 		INT(11);		-- Registro de Salida
	DECLARE Var_Bonificaciones		INT(11);		-- Numero de Bonificaciones
	DECLARE Var_Contador 			INT(11);		-- Contador de Ciclo

	DECLARE Var_ClienteID 			INT(11);		-- ID de Cliente
	DECLARE Var_CuentaAhoID			BIGINT(12);		-- Cuenta de Ahorro de la Bonificacion
	DECLARE	Var_Consecutivo			BIGINT(12);		-- Consecutivo de Salida
	DECLARE Var_BonificacionID 		BIGINT(20);		-- ID de Bonificacion
	DECLARE Var_RFC					VARCHAR(13);	-- Referencia

	DECLARE Var_RFCcte				VARCHAR(13);	-- RFC de Persona Fisica
	DECLARE Var_RFCPMcte			VARCHAR(13);	-- RFC de Persona Moral
	DECLARE Var_CuentaClabe			VARCHAR(20);	-- Cuenta Clabe
	DECLARE Var_CtaInstitucion		VARCHAR(20);	-- Cuenta de la Institucion
	DECLARE Var_Referencia 			VARCHAR(50);	-- Referencia de la Dispercion

	DECLARE Var_Control 			VARCHAR(100);	-- Control del Salida
	DECLARE Var_NombreCliente		VARCHAR(200);	-- Nombre del Cliente
	DECLARE Var_MontoBonificacion	DECIMAL(14,2);	-- Monto de la Bonificacion
	DECLARE Var_DispersionSan 		CHAR(1);			-- Genera Dispersion Automatica
	DECLARE Var_EsAutomatico		CHAR(1);			-- requiere generar la referencia automantica
	DECLARE Var_RefAutomatico		VARCHAR(20);		-- Referencia Automatica
	DECLARE Var_Complemento			VARCHAR(18);			-- Cmplemento de la referencia
	DECLARE Var_Vigencia 			INT(11);			-- Dias de vigencia de la referencia
	DECLARE Var_FechaVen			DATE;			-- Fecha de vencimineto de la reerencia
	DECLARE Var_FolioOrden			INT(11);		-- Campo para el folio de la ordende pago por bonificacion
	DECLARE Var_FolioCredito		INT(11);		-- FOLIO DEL CREDITO 1.-CREDITO 2.-OTROS 3.-CUENTAS

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Decimal_Cero		DECIMAL(12,4);	-- Constante Decimal Cero
	DECLARE Salida_SI			CHAR(1);		-- Constante Salida SI

	DECLARE Salida_NO			CHAR(1);		-- Constante Salida NO
	DECLARE TipoDisperSPEI 		CHAR(1);		-- Constante Tipo Dispersion SPEI
	DECLARE TipoDisperOrden		CHAR(1);		-- Constante Tipo Dispersion Orden Pago
	DECLARE TipoDisperCheque 	CHAR(1);		-- Constante Tipo Dispersion Cheque
	DECLARE TipoMovDisSPEI 		CHAR(4);		-- Constante Movimiento de Tipo Dispersion SPEI

	DECLARE TipoMovDisCheq 		CHAR(4);		-- Constante Movimiento de Tipo Dispersion Cheque
	DECLARE TipoMovDisOrden		CHAR(4);		-- Constante Movimiento de Tipo Dispersion Orden Pago
	DECLARE Per_Fisica 			CHAR(1);		-- Constante Persona Fisica
	DECLARE Per_Moral 			CHAR(1);		-- Constante Persona Moral
	DECLARE Var_Descripcion 	VARCHAR(40);	-- Constante Descripcion de la Dispersion

	DECLARE DescripSPEI 		VARCHAR(40);	-- Constante Descripcion SPEI
	DECLARE DescripCheq			VARCHAR(40);	-- Constante Descripcion Cheque
	DECLARE DescripOrdenPago	VARCHAR(50);	-- Constante Descripcion Orden de Pago
	DECLARE Est_Pendiente		CHAR(1);		-- Constante Estatus Pendiente
	DECLARE FormaPagoSPEI      	INT(11);		-- Constante Forma de Pago SPEI

	DECLARE FormaPagoCheque	   	INT(11);		-- Constante Forma de Pago Cheque
	DECLARE FormaPagoOrden	   	INT(11);		-- Constante Forma de Pago Orden de Pago
	DECLARE Bloq_Bonificacion	INT(11);		-- Constante Bloqueo Bonificacion
	DECLARE Mov_Bloqueo        	CHAR(1);		-- Constante Movimiento de Bloqueo
	DECLARE Con_SiHabilita		CHAR(1);		-- Constante Si Habilita

	DECLARE Llave_HabiFechaDisp VARCHAR(100);	-- Constante Habilita Fecha Dispersion
	DECLARE Est_SpeiHab			CHAR(1);		-- Constante SPEI Habil
	DECLARE Est_BonInactiva		CHAR(1);		-- Estatus de Bonificacion Inactiva
	DECLARE Tipo_SPEI			CHAR(1);		-- Constante Tipo de Dispersion SPEI
	DECLARE Tipo_Cheque			CHAR(1);		-- Constante Tipo de Dispersion Cheque

	DECLARE Tipo_OrdenPago		CHAR(1);		-- Constante Tipo de Dispersion Orden de Pago
	DECLARE Entero_Uno			INT(11);		-- Constante Entero Uno
	DECLARE DispersionSantander VARCHAR(50);		-- Llave Parametros Para dipersion Santander
	DECLARE Con_Otro			INT(11);		-- Constante para la generacion de la referencia automatica
	DECLARE Con_SI 				CHAR(1);		-- Constante SI
	DECLARE Con_Automatico		CHAR(1);		-- Constante es automatico
	DECLARE Con_TipoOtro		INT(11);		-- Tipo otra referencia

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Salida_SI  			:= 'S';
	SET Salida_NO			:= 'N';
	SET TipoDisperSPEI 		:= 'S';

	SET TipoDisperCheque	:= 'C';
	SET TipoDisperOrden 	:= 'O';
	SET TipoMovDisSPEI      := '27';
	SET TipoMovDisCheq      := '123';
	SET TipoMovDisOrden     := '708';

	SET Per_Fisica          := 'F';
	SET Per_Moral           := 'M';
	SET DescripSPEI         := 'SPEI PAGO POR BONIFICACION';
	SET DescripCheq         := 'CHEQUE PAGADO POR BONIFICACION';
	SET DescripOrdenPago	:= 'ORDEN PAGO POR BONIFICACION';

	SET Est_Pendiente       := 'P';
	SET FormaPagoSPEI       := 1;
	SET FormaPagoCheque     := 2;
	SET FormaPagoOrden		:= 5;
	SET Bloq_Bonificacion	:= 22;
	SET Mov_Bloqueo 		:= 'B';

	SET Con_SiHabilita		:= 'S';
	SET	Est_SpeiHab			:= 'S';
	SET Est_BonInactiva 	:= 'I';
	SET Tipo_SPEI 			:= 'S';
	SET Tipo_Cheque 		:= 'C';

	SET Tipo_OrdenPago 		:= 'O';
	SET Llave_HabiFechaDisp := 'HabilitaFechaDisp';
	SET Entero_Uno 			:= 1;
	SET DispersionSantander	:= 'DispersionSantander';				-- Llave Parametros Para dipersion Santander
	SET Con_Otro			:= 3;
	SET Con_SI 				:= 'S';
	SET Con_Automatico		:= 'A';
	SET Con_TipoOtro		:= 81;

	SELECT FechaSistema
	INTO Var_FechaSistema
	FROM PARAMETROSSIS;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								 	 'Disculpe las molestias que esto le ocasiona. Ref: SP-DISPERSIONBONIFICAPRO');
		END;

		SELECT ValorParametro
		INTO Var_SiHabilita
		FROM PARAMGENERALES
		WHERE LlaveParametro = Llave_HabiFechaDisp;

		SELECT ValorParametro INTO Var_DispersionSan
			FROM PARAMGENERALES WHERE LlaveParametro=DispersionSantander;

		IF( Var_SiHabilita = Con_SiHabilita ) THEN
			SET Par_Fecha := Par_Fecha;
		ELSE
			SET Par_Fecha := Var_FechaSistema;
		END IF;

		SET	Var_Dispersiones :=	'S,C,O';

		-- se obtiene el numero de Bonificaciones por dispersar
		SELECT	IFNULL(COUNT(Bon.BonificacionID), Entero_Cero)
		INTO Var_Bonificaciones
		FROM BONIFICACIONES Bon, BLOQUEOS Bloq
		WHERE Bon.FolioDispersion = Entero_Cero
		  AND Bon.CuentaAhoID = Bloq.CuentaAhoID
		  AND Bon.BonificacionID = Bloq.Referencia
		  AND Bloq.TiposBloqID	= Bloq_Bonificacion
		  AND Bloq.NatMovimiento = Mov_Bloqueo
		  AND IFNULL(Bloq.FolioBloq, Entero_Cero) = Entero_Cero
		  AND Bon.Estatus = Est_BonInactiva
		  AND FIND_IN_SET(Bon.TipoDispersion, Var_Dispersiones) > Entero_Cero
		  AND Bon.TipoDispersion IN (Tipo_SPEI, Tipo_Cheque,Tipo_OrdenPago);


		IF( Var_Bonificaciones = Entero_Cero)THEN
			SET	Par_NumErr 		:= 001;
			SET	Par_ErrMen		:= 'No Hay Bonificaciones para Importar';
			SET Var_Control		:= 'folioOperacion';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_EmpresaID,Entero_Cero) = Entero_Cero )THEN
			SET	Par_NumErr 		:= 002;
			SET	Par_ErrMen		:= 'La Empresa esta vacia';
			SET Var_Control		:= '';
			SET Var_Consecutivo := Par_EmpresaID;
			LEAVE ManejoErrores;
		END IF;

		-- se valida que existe el numero de institucion
		SET Var_Institucion := IFNULL((SELECT InstitucionID
											FROM 	INSTITUCIONES
											WHERE 	InstitucionID = Par_InstitucionID ),Entero_Cero);

		IF( IFNULL(Var_Institucion,Entero_Cero) = Entero_Cero ) THEN
			SET	Par_NumErr 		:= 003;
			SET	Par_ErrMen		:= 'La Institucion especificada no Existe';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		-- se valida que existe el numero de cuenta de la institucion
		SET Var_CtaInstitucion := IFNULL((SELECT NumCtaInstit
										FROM 	CUENTASAHOTESO
										WHERE 	InstitucionID	= Par_InstitucionID
										AND 	NumCtaInstit	= Par_NumCtaInstit),Cadena_Vacia);

		IF( IFNULL(Var_CtaInstitucion,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET	Par_NumErr 		:= 004;
			SET	Par_ErrMen		:= 'La Cuenta Bancaria especificada no Existe';
			SET Var_Control		:= 'numCtaInstit';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Var_Bonificaciones := Entero_Cero;

		SELECT C.AlgClaveRetiro,C.VigClaveRetiro INTO Var_EsAutomatico,Var_Vigencia
		FROM CUENTASAHOTESO C
		WHERE C.InstitucionID		= Var_Institucion
			AND	C.NumCtaInstit		= Var_CtaInstitucion;

		SELECT	IFNULL(COUNT(Bon.BonificacionID), Entero_Cero)
		INTO Var_Bonificaciones
		FROM BONIFICACIONES Bon, BLOQUEOS Bloq
		WHERE Bon.FolioDispersion = Entero_Cero
		  AND Bon.CuentaAhoID = Bloq.CuentaAhoID
		  AND Bon.BonificacionID = Bloq.Referencia
		  AND Bloq.TiposBloqID	= Bloq_Bonificacion
		  AND Bloq.NatMovimiento = Mov_Bloqueo
		  AND IFNULL(Bloq.FolioBloq, Entero_Cero) = Entero_Cero
		  AND Bon.Estatus = Est_BonInactiva
		  AND FIND_IN_SET(Bon.TipoDispersion, Var_Dispersiones) > Entero_Cero
		  AND Bon.TipoDispersion IN (Tipo_SPEI, Tipo_Cheque,Tipo_OrdenPago);

		SET Var_Bonificaciones := IFNULL(Var_Bonificaciones, Entero_Cero);

		IF( Var_Bonificaciones > Entero_Cero ) THEN

			SET Aud_FechaActual := NOW();
			CALL DISPERSIONALT(
				Par_Fecha,			Var_Institucion,	Var_CtaInstitucion,		Par_NumCtaInstit,	Salida_NO,
				Par_NumErr,			Par_ErrMen,			Var_FolioOperacion,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			DELETE FROM TMPBONIFICACIONES WHERE NumTransaccion = Aud_NumTransaccion;
			SET @NumRegistro := Entero_Cero;
			INSERT INTO TMPBONIFICACIONES(
					RegistroID,		BonificacionID,	ClienteID,		CuentaAhoID,	TipoDispersion,
					CuentaClabe,	Monto,			EmpresaID,		Usuario,		FechaActual,
					DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
			SELECT @NumRegistro:=@NumRegistro+1 AS NumRegistro,
					Bon.BonificacionID,	Bon.ClienteID, 		Bon.CuentaAhoID,	Bon.TipoDispersion,	Bon.CuentaClabe,
					Bon.Monto,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			FROM BONIFICACIONES Bon
			INNER JOIN BLOQUEOS Bloq ON Bon.CuentaAhoID = Bloq.CuentaAhoID
			WHERE Bon.FolioDispersion = Entero_Cero
			  AND Bon.CuentaAhoID = Bloq.CuentaAhoID
			  AND Bon.BonificacionID = Bloq.Referencia
			  AND Bloq.TiposBloqID	= Bloq_Bonificacion
			  AND Bloq.NatMovimiento = Mov_Bloqueo
			  AND IFNULL(Bloq.FolioBloq, Entero_Cero) = Entero_Cero
			  AND Bon.Estatus = Est_BonInactiva
			  AND FIND_IN_SET(Bon.TipoDispersion, Var_Dispersiones) > Entero_Cero
			  AND Bon.TipoDispersion IN (Tipo_SPEI, Tipo_Cheque,Tipo_OrdenPago);

			SET Var_Contador := Entero_Uno;
			SET Var_TipoChequera := Cadena_Vacia;

			SELECT DATE_FORMAT(FechaSistema,'%Y-%m-01')
			INTO Var_FechaSistema
			FROM PARAMETROSSIS;

			WHILE ( Var_Contador <= Var_Bonificaciones ) DO

				SELECT 	BonificacionID, 	CuentaAhoID, 	 ClienteID,		TipoDispersion,		CuentaClabe,
						Monto
				INTO 	Var_BonificacionID, Var_CuentaAhoID, Var_ClienteID,	Var_TipoDispersion, Var_CuentaClabe,
						Var_MontoBonificacion
				FROM TMPBONIFICACIONES
				WHERE RegistroID = Var_Contador
				  AND NumTransaccion = Aud_NumTransaccion;

				SELECT  SucursalID
				INTO 	Var_SucursalID
				FROM CUENTASAHO
				WHERE CuentaAhoID = Var_CuentaAhoID;

				IF( YEAR(Par_Fecha) <= YEAR(Var_FechaSistema) ) THEN
					IF( MONTH(Par_Fecha) < MONTH(Var_FechaSistema) ) THEN
						SET	Par_NumErr 		:= 003;
						SET	Par_ErrMen		:= 'El Mes no Puede ser Menor al del Sistema';
						SET Var_Control		:= 'fechaActual';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				SELECT TipoPersona,		RFC,		RFCpm,			NombreCompleto
				INTO Var_TipoPersona,	Var_RFCcte,	Var_RFCPMcte,	Var_NombreCliente
				FROM CLIENTES
				WHERE ClienteID = Var_ClienteID;

				IF( Var_TipoPersona = Per_Fisica )THEN
					SET Var_RFC := Var_RFCcte;
				END IF;

				IF( Var_TipoPersona = Per_Moral )THEN
					SET Var_RFC := Var_RFCPMcte;
				END IF;

				-- Dispersion SPEI
				IF(Var_TipoDispersion = TipoDisperSPEI) THEN
					SET Var_FormaPago	:= FormaPagoSPEI;
					SET Var_TipoMovDis	:= TipoMovDisSPEI;
					SET Var_Descripcion	:= DescripSPEI;
					SET Var_CuentaClabe := Var_CuentaClabe;
				END IF;

				-- Dispersion Cheque
				IF(Var_TipoDispersion = TipoDisperCheque) THEN
					SET Var_FormaPago	:= FormaPagoCheque;
					SET Var_TipoMovDis	:= TipoMovDisCheq;
					SET Var_Descripcion	:= DescripCheq;
					SET Var_CuentaClabe	:= Cadena_Vacia;
				END IF;

				-- Dispersion Order de Pago
				IF(Var_TipoDispersion = TipoDisperOrden) THEN
					SET Var_FormaPago	:= FormaPagoOrden;
					SET Var_TipoMovDis	:= TipoMovDisOrden;
					SET Var_Descripcion	:= DescripOrdenPago;
					SET Var_CuentaClabe	:= Cadena_Vacia;
				END IF;

				SET Var_Referencia := Var_BonificacionID;
				SET Aud_FechaActual := NOW();

				IF Var_DispersionSan = Con_SI AND Var_TipoDispersion = TipoDisperOrden AND Var_EsAutomatico = Con_Automatico THEN
					SET Var_FolioOrden := (SELECT IFNULL(MAX(Complemento)+1,Entero_Cero)FROM REFORDENPAGOSAN WHERE Tipo=Con_TipoOtro);
					SET Var_FolioOrden := Var_FolioOrden + Var_Contador;
					CALL GENERAREFAUTSAN(Con_Otro,				Var_FolioOrden,	Salida_NO,				Par_NumErr,			Par_ErrMen,
										Var_RefAutomatico, 		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
				END IF;

				IF Var_RefAutomatico != Cadena_Vacia THEN
					SET Var_CuentaClabe := Var_RefAutomatico;
				END IF;


				CALL DISPERSIONMOVALT(
					Var_FolioOperacion,		Var_CuentaAhoID,	Cadena_Vacia,			Var_Descripcion,	Var_Referencia,
					Var_TipoMovDis,			Var_FormaPago,		Var_MontoBonificacion,	Var_CuentaClabe, 	Var_NombreCliente,
					Par_Fecha, 				Var_RFC,			Est_Pendiente, 			Salida_NO,			Var_SucursalID,
					Entero_Cero,			Entero_Cero,		Entero_Cero,			Entero_Cero,		Entero_Cero,
					Entero_Cero,			Cadena_Vacia,		Var_TipoChequera,		Par_NumErr,			Par_ErrMen,
					Var_NumConsecutivo,		Par_EmpresaID, 		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				IF Var_DispersionSan = Con_SI AND Var_TipoDispersion = TipoDisperOrden AND Var_EsAutomatico = Con_Automatico THEN

							SET Var_FolioCredito := SUBSTRING(Var_RefAutomatico,1,1);
							IF (Var_FolioCredito = Con_Otro) THEN
								SET Var_Complemento := SUBSTRING(Var_RefAutomatico,20,1);
							END IF;
							IF(Var_FolioCredito = Con_Cuenta)THEN
								SET Var_Complemento := SUBSTRING(Var_RefAutomatico,14,1);
							END IF;
							IF(Var_FolioCredito = Con_Creditos)THEN
								SET Var_Complemento := SUBSTRING(Var_RefAutomatico,13,1);
							END IF;

							CALL DIASFESTIVOSCAL(
								Var_FechaSistema,	Var_Vigencia,		Var_FechaVen,		@EsHabil,			Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

							CALL REFORDENPAGOSANALT(
								Var_RefAutomatico,		Var_Complemento,		Var_FolioOperacion,		Var_NumConsecutivo,		Var_FechaSistema,
								Var_FechaVen,			Con_TipoOtro,		Var_NumConsecutivo,		Salida_NO,
								Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

				END IF;

				SET Var_Contador := Var_Contador + Entero_Uno;
				SET Var_BonificacionID := Entero_Cero;
				SET Var_CuentaAhoID := Entero_Cero;
				SET Var_ClienteID := Entero_Cero;
				SET Var_TipoDispersion := Cadena_Vacia;
				SET Var_CuentaClabe := Cadena_Vacia;
				SET Var_TipoPersona := Cadena_Vacia;
				SET Var_RFC := Cadena_Vacia;
				SET Var_RFCPMcte := Cadena_Vacia;
				SET Var_RFCcte := Cadena_Vacia;
				SET Var_TipoMovDis := Cadena_Vacia;
				SET Var_FormaPago := Entero_Cero;
				SET Var_Descripcion := Cadena_Vacia;
				SET Var_Referencia := Cadena_Vacia;
				SET Var_MontoBonificacion := Decimal_Cero;

			END WHILE;
		END IF;

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 0;
		SET Par_ErrMen 		:= CONCAT('Dispersion agregada: ',CONVERT(Var_FolioOperacion,CHAR(10)));
		SET Var_Control		:= 'folioOperacion';
		SET Var_Consecutivo := Var_FolioOperacion;
		DELETE FROM TMPBONIFICACIONES WHERE NumTransaccion = Aud_NumTransaccion;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;


END TerminaStore$$
