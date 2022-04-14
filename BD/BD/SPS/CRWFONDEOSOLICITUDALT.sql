
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOSOLICITUDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONDEOSOLICITUDALT`;

DELIMITER $$
CREATE PROCEDURE `CRWFONDEOSOLICITUDALT`(
    Par_SolicCredID     	BIGINT(20),			-- ID de la solicitud de credito
    Par_ClienteID      		INT(11),			-- ID del cliente institucion
    Par_CuentaAhoID     	BIGINT(12),			-- ID de la cuenta de ahorro de la institucion
    Par_ProductoCreID		BIGINT(20),			-- Producto de credito ID
    Par_FechaRegistro   	DATE,				-- Fecha de registro de la solicitud

    Par_MontoFondeo     	DECIMAL(12,2),		-- Monto de fondeo
    Par_PorceFondeo     	DECIMAL(10,6),		-- Porcentaje de fondeo
    Par_MonedaID        	INT(11),			-- Moneda ID (Tabla MONEDAS)
    Par_TasaActiva      	DECIMAL(8,4),		-- Tasa activa
    Par_TasaPasiva      	DECIMAL(8,4),		-- Tasa Pasiva

    Par_TipoFondeadorID 	INT(11),            -- Tipo de Fondeador (TIPOSFONDEADORES)
    Par_TipoFondeo      CHAR(1),            -- S: Fondeo por Solicitud, C: Fondeo por Credito
    Par_Salida			CHAR(1),			-- S: Salida si N: Salida no
    INOUT Par_NumErr	INT(11),			-- Numero error del proceso
    INOUT Par_ErrMen	VARCHAR(400),		-- Mensaje de error del proceso

    INOUT Par_NumSolFon	BIGINT(20),			-- Numero de solicitud de fondeo
    INOUT Par_GAT		DECIMAL(12,2),		-- Valor de GAT
	INOUT Par_GatReal	DECIMAL(12,2),		-- Valor de GAT real

    Aud_EmpresaID		INT(11),			-- Auditoria
    Aud_Usuario			INT(11),			-- Auditoria
    Aud_FechaActual		DATETIME,			-- Auditoria
    Aud_DireccionIP		VARCHAR(15),		-- Auditoria

    Aud_ProgramaID		VARCHAR(50),		-- Auditoria
    Aud_Sucursal		INT(11),			-- Auditoria
    Aud_NumTransaccion	BIGINT(20)			-- Auditoria
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Control			VARCHAR(50);		-- Variable de control
DECLARE Var_Consecutivo    	INT(11);			-- Consecutivo del procedimiento
DECLARE Var_PorceFondeo    	DECIMAL(8,2);		-- Variable porcentajde del fondeo
DECLARE Var_SolFondeoID		BIGINT(20);			-- Solicitud de fondeo ID
DECLARE	Var_SolFondeoIniID	BIGINT(20);			-- Solicitud de fondeo inicial ID
DECLARE Var_CuentaAhoID		BIGINT(12);			-- Variable cuenta de ahorro
DECLARE Var_ClienteID		INT(11);			-- Cliente ins ID

DECLARE Var_DiasInv			INT;		/* DIAS DE INVERSION*/
DECLARE Var_DiasInversion	INT;		/* DIAS DE INVERSION PARAM SIS*/
DECLARE Var_MontoRend		DECIMAL(12,2);		/* MONTO CON RENDIMIENTO*/
DECLARE Var_NumAmorti       INT(11);	-- Numero de amortizaciones
DECLARE Var_FrecuenCap      CHAR(1);	-- Frecuencia capital
DECLARE Var_LlaveCRW		VARCHAR(50);		-- Llave para filtro de modulo crowdfunding
DECLARE Var_CrwActivo		CHAR(1);			-- Variable para almacenar el valor de habilitacion de modulo crowdfunding

-- Declaracion de Constantes
DECLARE ClienteInstit		INT(11);			-- Cliente institucion
DECLARE CuentaInst			INT(11);			-- Cuenta de la institucion
DECLARE Tipo_Actualiza		INT(11);			-- Tipo de actualizacion
DECLARE Entero_Cero     	INT(11);			-- Entero cero
DECLARE Decimal_Cero   	 	DECIMAL (12,2);		-- Decimal cero
DECLARE NumConsecutivo  	INT(11);			-- Numero consecutivo
DECLARE Cadena_Vacia   		CHAR(1);			-- Cadena vacia
DECLARE Nace_Estatus    	CHAR(1); 			-- Estatus de nacimiento
DECLARE SalidaSI       		CHAR(1); 			-- Salida si
DECLARE Salida_NO       	CHAR(1);			-- Salida no
DECLARE NumAct_Alta     	INT(11);			-- Numero actualizacion de alta
DECLARE NumAct_Act      	INT(11);			-- Numero de actualizacion
DECLARE NombreProceso   	VARCHAR(16); 		-- Nombre del proceso
DECLARE Tip_FonSolici   	CHAR(1);			-- Tipo fondeo solicitud
DECLARE Tip_FonCredito  	CHAR(1);			-- Tipo fondeo credito
DECLARE Constante_No		CHAR(1);			-- Constante no

-- CONSTANTES QUE SE USAN PARA EL CALCULO DEL GAT
DECLARE PagoSemanal			CHAR(1);	-- Pago Semanal (S)
DECLARE PagoCatorcenal		CHAR(1);	-- Pago Catorcenal (C)
DECLARE PagoQuincenal		CHAR(1);	-- Pago Quincenal (Q)
DECLARE PagoMensual			CHAR(1);	-- Pago Mensual (M)
DECLARE FrecSemanal			INT(11);	-- frecuencia semanal en dias
DECLARE FrecCator			INT(11);	-- frecuencia Catorcenal en dias
DECLARE FrecQuin			INT(11);	-- frecuencia en dias quincena
DECLARE FrecMensual			INT(11);	-- frecuencia mensual


-- Asignacion de variables
SET Var_LlaveCRW				:= 'ActivoModCrowd'; 	-- Filtro para variable de modulo crowdfunding

-- Asignacion de Constantes
SET NumConsecutivo  := 1;
SET Nace_Estatus    := 'F';
SET Entero_Cero     := 0;
SET Cadena_Vacia    := '';
SET Decimal_Cero    := 0.0;
SET SalidaSI        := 'S';
SET Salida_NO        := 'N';
SET NumAct_Alta     := 1;
SET NumAct_Act      := 5;
SET Tip_FonSolici   := 'S';         -- Tipo de Fondeo en base a la Solicitud
SET Tip_FonCredito  := 'C';         -- Tipo de Fondeo en base al Credito
-- ASIGNACION DE CONSTANTES QUE SE USAN PARA EL CALCULO DEL GAT
SET PagoSemanal		:= 'S';		-- PagoSemanal
SET PagoCatorcenal	:= 'C';		-- PagoCatorcenal
SET PagoQuincenal	:= 'Q';		-- PagoQuincenal
SET PagoMensual		:= 'M';		-- PagoMensual
SET FrecSemanal		:= 7;		-- frecuencia semanal en dias
SET FrecCator		:= 14;		-- frecuencia Catorcenal en dias
SET FrecQuin		:= 15;		-- frecuencia en dias de quincena
SET FrecMensual		:= 30;		-- frecuencia mesual

SET	NombreProceso	:= 'SOLICITUDFONDEO'; -- Nombre del proceso que dispara el escalamiento
SET Par_NumErr			:= 0;
SET Par_ErrMen			:= '';
SET Var_Consecutivo		:= 0;
SET Aud_FechaActual 	:= NOW();
SET Constante_No		:= 'N';				-- Constante NO

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWFONDEOSOLICITUDALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SELECT 	ClienteInstitucion,	CuentaInstituc,		DiasInversion
		INTO 	ClienteInstit,		CuentaInst,			Var_DiasInversion
		FROM PARAMETROSSIS;

		-- Se obtiene el valor de la parametrizacion para fondeos de crowdfunding
		SELECT ValorParametro
		INTO  Var_CrwActivo
		FROM PARAMGENERALES WHERE LlaveParametro = Var_LlaveCRW;

		IF(Var_CrwActivo = Constante_No)THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'Para ejecutar el proceso, se requiere habilitar el modulo de crowdfunding';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_SolicCredID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 001;
			SET Par_ErrMen 			:= 'El numero de solicitud de credito esta vacio.';
			SET Var_Control 		:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 002;
			SET Par_ErrMen 			:= 'El numero de Cliente esta vacio.';
			SET Var_Control 		:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_MontoFondeo, Decimal_Cero))= Decimal_Cero THEN
			SET Par_NumErr 			:= 003;
			SET Par_ErrMen 			:= 'El monto de fondeo esta vacio.';
			SET Var_Control 		:= 'MontoFondeo';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClienteID != ClienteInstit) THEN

			IF(IFNULL(Par_TasaPasiva, Decimal_Cero))= Decimal_Cero THEN
				SET Par_NumErr 			:= 004;
				SET Par_ErrMen 			:= 'La Tasa Pasiva esta vacia.';
				SET Var_Control 		:= 'TasaPasiva';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 005;
			SET Par_ErrMen 			:= 'Especifique Cuenta de Ahorro.';
			SET Var_Control 		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 006;
			SET Par_ErrMen 			:= 'Especifique Moneda de la cuenta.';
			SET Var_Control 		:= 'monedaID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_CuentaAhoID	:= (SELECT CuentaAhoID
									FROM CUENTASAHO
										WHERE	CuentaAhoID	=	Par_CuentaAhoID
										AND	ClienteID	=	Par_ClienteID  );



		IF(IFNULL(Var_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 007;
			SET Par_ErrMen 			:= 'La cuenta no corresponde con el cliente indicado.';
			SET Var_Control 		:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		SET NumConsecutivo	:= (SELECT IFNULL(MAX(Consecutivo),Entero_Cero) + 1
							FROM CRWFONDEOSOLICITUD
							WHERE SolicitudCreditoID = Par_SolicCredID);

		-- El Fondeo es por Solicitud de Credito
		SELECT 	CRE.Dias
		INTO	Var_DiasInv
		FROM  SOLICITUDCREDITO	SOL
		INNER JOIN CREDITOSPLAZOS CRE ON CRE.PlazoID = SOL.PlazoID
		WHERE SOL.SolicitudCreditoID =	Par_SolicCredID;

		SET Var_MontoRend := Par_MontoFondeo + ((Par_MontoFondeo * Var_DiasInv * Par_TasaPasiva)/ (Var_DiasInversion * 100));



		-- Consulta del Folio de Solicitud
		CALL FOLIOSAPLICAACT('CRWFONDEOSOLICITUD',	Var_SolFondeoID );

		INSERT INTO CRWFONDEOSOLICITUD	(
			SolFondeoID,    	SolicitudCreditoID, Consecutivo,    	ClienteID,      		CuentaAhoID,
			FechaRegistro,  	MontoFondeo,        PorcentajeFondeo,   MonedaID,       		Estatus,
			TasaActiva,     	TasaPasiva,         FondeoID,			TipoFondeadorID,    	ProducCreditoID,
			Gat,				ValorGatReal,		EmpresaID,     		Usuario,        		FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion	)
		VALUES (
			Var_SolFondeoID,	Par_SolicCredID,    NumConsecutivo,     	Par_ClienteID,  	 		Par_CuentaAhoID,
			Par_FechaRegistro,	Par_MontoFondeo,    Par_PorceFondeo,    	Par_MonedaID,   	    	Nace_Estatus,
			Par_TasaActiva,   	Par_TasaPasiva,     Entero_Cero,			Par_TipoFondeadorID,		Par_ProductoCreID,
			Par_GAT,			Par_GatReal,		Aud_EmpresaID,			Aud_Usuario,				Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		SET Tipo_Actualiza  := NumAct_Alta;

		IF (Par_TipoFondeo = Tip_FonSolici) THEN
			-- Actualizamos la Solicitud de Credito
			CALL SOLICITUDCREDITOACT(
				Par_SolicCredID,    Par_MontoFondeo,    Par_PorceFondeo,    Decimal_Cero,		Decimal_Cero,
				Decimal_Cero,		Tipo_Actualiza,     Entero_Cero,		Entero_Cero,		Cadena_Vacia,
				Decimal_Cero,       Cadena_Vacia,       Entero_Cero,		Salida_NO,			Par_NumErr,
				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		END IF;

		-- Llamada. al proceso de deteccion de nivel de riesgo del cliente, modulo PLD
		CALL DETESCALAINTPLDPRO (
			Var_SolFondeoID,		NumConsecutivo,		NombreProceso,		Entero_Cero, 		Salida_NO,
			Par_NumErr,		   		Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	    Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Solicitud de Fondeo Agregada', Var_SolFondeoID);
		ELSE
			SET Par_ErrMen := CONCAT('Solicitud de Fondeo Agregada',Var_SolFondeoID);
		END IF;

	END ManejoErrores;

	IF Par_Salida = SalidaSI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'solFondeoID' AS Control,
				Var_SolFondeoID AS Consecutivo;
	END IF;

	SET Par_NumSolFon   := Var_SolFondeoID;
END TerminaStore$$
