-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWCREDITOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWCREDITOSPRO`;
DELIMITER $$

CREATE PROCEDURE `CRWCREDITOSPRO`(
-- ------------------------------------------------------------
-- ----------- SP PARA DAR DE ALTA UN CREDITO CON FONDEOS------
-- ------------------------------------------------------------
	Par_SolicCredID		BIGINT(20),					-- Solicitud de credito id
	Par_CuentaCLABE		CHAR(18),					-- Cuenta Clabe para cuando el tipo de Dispersion sea por SPEI
	Par_AjFUlVenAm		CHAR(1),					-- Ajuste de fecha de Vencimiento de Amortizacion
	Par_FolioConsultaBC VARCHAR(30),				-- Folio Consulta BC 
	Par_FechaConBC		DATE,						-- Fecha reliza la consulta de buro de credito
	Par_FactorMora      DECIMAL(12,2),				-- Factor Moratorio - Tasa Mora

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Aud_EmpresaID 		INT(11) ,					-- Auditoria
    Aud_Usuario 		INT(11) ,					-- Auditoria
    Aud_FechaActual 	DATETIME,					-- Auditoria
    Aud_DireccionIP 	VARCHAR(15),				-- Auditoria
    Aud_ProgramaID 		VARCHAR(50),				-- Auditoria
    Aud_Sucursal 		INT(11) ,					-- Auditoria
    Aud_NumTransaccion 	BIGINT(20)					-- Auditoria
						)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_Control             VARCHAR(100);		-- Variable de control
	DECLARE Var_Consecutivo			VARCHAR(50);		-- varaible consecutivo
	DECLARE Var_SolicitudID			BIGINT(20);			-- solicitud de credito id
	DECLARE Var_TipoPerSAFI			VARCHAR(50);		-- Tipo persona safi
	DECLARE Var_SolicAuto			CHAR(1);			-- Estatus autorizado 'A'
	DECLARE Var_FechaSistema		DATE;				-- Variable fecha sistema
	DECLARE Var_FechaVenCred		DATE;				-- Variable fecha vencimiento credito
	DECLARE Var_TipoPagoCapi		CHAR(1);			-- Tipo pago capital
	DECLARE Var_Porcent				DECIMAL(8,4);		-- Variable de porcentaje
	DECLARE Var_MontoaFond			DECIMAL(12,2);		-- Variable Monto fondeo
	DECLARE Var_MontoPorComAper		DECIMAL(12,2);		-- Variable Monto comision por apertura
	DECLARE Var_IVAComAper			DECIMAL(12,2);		-- Variable IVA Monto comision por apertura
	DECLARE Var_PlazoID				INT(11);			-- Plazo en meses para el Vencimiento de Crédito
	DECLARE Var_Frecuencia			CHAR(1);			-- Frecuencia de la solicitud
	DECLARE Var_ProcDetecCre		VARCHAR(50);		-- Variable de proceso de deteccion pld de credito
	DECLARE Var_Correo				VARCHAR(50);		-- Variable correo
	DECLARE Var_Monto           	DECIMAL(14,2);		-- Variable monto
	DECLARE Var_NombreProducto  	VARCHAR(100);		-- Nombre del producto de credito
	DECLARE Var_FechaSolicitud  	DATE;				-- Fecha de la solicitud
	DECLARE Var_PrcesoEscID			VARCHAR(50);		-- clave del proceso que genero el escalamiento\nsegún catalogo de procesos de escalamiento
	DECLARE Var_PlantillaCorre		VARCHAR(2000);		-- Plantilla del correo
	DECLARE Var_FechaDeteccion		DATE;				-- Fecha deteccion pld
	DECLARE Var_FechaInicio			DATE;				-- Fecha inicio de la solicitud de credito
	DECLARE Var_NumAmortizacion		INT(11);			-- Numero de amortizaciones
	DECLARE Var_CobraSeguroCuota 	CHAR(1);			-- Valida si el producto cobra seguro por cuota, este campo es del producto
	DECLARE Var_CobraIVASegCuota	CHAR(1);			-- Valida si el producto cobra IVA seguro por cuota, este campo es del producto
	DECLARE Var_MontoSeguroCuota	DECIMAL(12,2);		-- Monto por Seguro por Cuota
	DECLARE Var_CuentaAho			BIGINT(20);			-- Variable cuenta id de la cuenta de ahorro
	DECLARE Var_SucursalID			INT(11);			-- Variable sucursal ID
	DECLARE Var_Clabe				VARCHAR(18);		-- Variable de la clabe de la cuenta de ahorro
	DECLARE Var_MonedaID			INT(11);			-- ID de la moneda
	DECLARE Var_TipoCuentaID		INT(11);			-- Tipo cuenta id
	DECLARE Var_FechaReg			DATE;				-- Fecha de registro
	DECLARE Var_Estatus				CHAR(1);			-- Estatus del estado de cuenta
	DECLARE Var_EstadosCta			CHAR(1);			-- Indica a donde sera mandado el estado de cuenta\n“D” Domicilio\n“I” Internet\n“S” Sucursal
	DECLARE Var_InstitucionID		INT(11);			-- Variable institucion id
	DECLARE Var_EsPrincipal			CHAR(1);			-- Variable es principal
	DECLARE Var_TelCelular			VARCHAR(20);		-- Variable telefono celular
	DECLARE Var_InstitucionCuenta	BIGINT(20);			-- Variable descripcion institucion
	DECLARE Var_TipoFondeadDef		INT(11);			-- Variable tipo fondeador default
	DECLARE Var_NumSolFond			INT(11);			-- Numero de la solicitud de fondeo
	DECLARE Var_TipoCredNuevo		CHAR(1);			-- Tipo credito N 
	DECLARE Var_TPagCapCrec			CHAR(1);			-- Tipo de pago capital crecientes C.
	DECLARE Var_PagoCapFAnu			CHAR(1);			-- Pago capital anual
	DECLARE Var_NumTranSimulador	BIGINT(20);			-- Numero de transaccion del simulador
	DECLARE Var_TipoFondProp		CHAR(1);			-- Tipo fondeador propios
	DECLARE Var_TipoDispersion		CHAR(1);			-- Tipo de dispersion S .- SPEI\n	C .- Cheque\n	O .- Orden de Pago
	DECLARE Var_CalcInteresID		INT(11);			-- Calculo de intereses id
	DECLARE Var_DestinoCredID		INT(11);			-- Destino de credito ID
	DECLARE Var_InstitFondeoID		INT(11);			-- Institucion ID para fondeo
	DECLARE	Var_LineaFondeo			INT(11);			-- Linea de fondeo
	DECLARE Var_NumAmortizacionInt	INT(11);			-- Numero de Amortizaciones (cuotas) de Interes
	DECLARE Var_MontoSeguroVida		DECIMAL(12,2);		-- Monto seguro de vida
	DECLARE Var_AporteCliente		DECIMAL(12,2);		-- Monto aporte del cliente
	DECLARE Var_ClasiDestinCred		CHAR(1);			-- Clasificacion del destino de credito
	DECLARE Var_ForCobroSegVida		CHAR(1);			-- A: Anticipado, D: Deduccion, F: Financiamiento		
	DECLARE Var_DescuentoSeguro		DECIMAL(12, 2);		-- Descuento del seguro de vida
	DECLARE Var_MontoSegOriginal	DECIMAL(12, 2);		-- Monto Seguro original
	DECLARE Var_TipoConsultaSIC	 	CHAR(2);			-- Se indica BC si la Consulta se realizó a Buró de Crédito o CC si se realizó a  Círculo de Crédito
	DECLARE Var_FolioConsultaBC 	VARCHAR(30);		-- Folio de consulta de Buro de Credito
	DECLARE Var_FolioConsultaCC		VARCHAR(30);		-- Folio de consulta de Circulo de Credito
	DECLARE Var_FechaCobroComision	DATE;				-- Fecha de cobro de comision
	DECLARE Var_NombreCompleto		VARCHAR(150);		-- nombre completo
	DECLARE Var_Descripcion			VARCHAR(50);		-- Descripcion escalamiento interno pld
	DECLARE Var_Etiqueta			VARCHAR(50);		-- Etiqueta razon de apertura de lac cuenta
	DECLARE Var_CuentaInst			INT(11);			-- Cuenta ahorro de la institucion
	DECLARE Var_DiasInv				INT(11);			-- Dias inversion
	DECLARE Var_DiaPago				CHAR(1);			-- Dia pago capital
	DECLARE Var_TipoPrepago			CHAR(1);			-- Tipo de prepago del producto de credito
	
	DECLARE Var_ClienteID		INT(11);			-- Numero del cliente
	DECLARE Var_MontoAuto		DECIMAL(12,2);		-- Monto autorizado de la solicitud
	DECLARE Var_FInicioCre		DATE;				-- Fecha de inicio del credito
	DECLARE Var_FVenCredito		DATE;				-- Fecha de vencimiento del credito
	DECLARE Var_CalInt			INT(11);			-- Calculo intereses
	DECLARE Var_TasaFija		DECIMAL(12,2);		-- Tasa activa base
	DECLARE Var_FechaHabilT		CHAR(1);			-- Fecha habil tasa
	DECLARE Var_AjFUlVenAm		CHAR(1);			-- Ajuste de fecha de Vencimiento de Amortizacion
	DECLARE Var_AjuFecExVen		CHAR(1);			-- Ajuste de la fecha
	DECLARE Var_EstatusSoli		CHAR(1);			-- Estatus de la solicitud
	DECLARE Var_Periodicidad	INT(1);				-- Periodicidad del credito
	DECLARE Var_ProductoCreditoID INT(11);			-- Producto credito ID
	DECLARE Var_FactorMora		DECIMAL(12,2);		-- Variable factor mora
	DECLARE Var_CreditoID		BIGINT(20);			-- Variable de credito id
	DECLARE Var_Remitente		VARCHAR(50);		-- Varaible remitente del correo
	DECLARE Var_ServidorCorr	VARCHAR(50);		-- Variable servidor correo
	DECLARE Var_Puerto			VARCHAR(10);		-- Puerto para el envio del correo
	DECLARE Var_UsuarioCorreo	VARCHAR(50);		-- Variable usuario correo
	DECLARE Var_Contrasenia		VARCHAR(20);		-- Variable Contrasenia del servidor para envio de correo
	DECLARE Var_Cuotas        	INT(11);			-- Variable cuotas
    DECLARE Var_Cat           	DECIMAL(14,4);      -- cat que corresponde con lo generado
    DECLARE Var_MontoCuo		DECIMAL(14,4);      -- corresponde con la cuota promedio a pagar
	DECLARE Var_FechaVen		DATE;  	            -- corresponde con la fecha final que genere el cotizador
	DECLARE Var_GAT				DECIMAL(12,2);		-- Valor de GAT
	DECLARE Var_GatReal			DECIMAL(12,2);		-- Valor de GAT real
	DECLARE Var_TransacPagare	BIGINT(20);			-- Transaccion para la amortizaciones
	
	
	DECLARE Var_NumErr			INT(11);			-- Variable numero de error
    DECLARE Var_ErrMen			VARCHAR(400);		-- Variable error mensaje
	
	DECLARE Var_PrimerNombre		VARCHAR(100);	-- Primer nombre del cliente
	DECLARE Var_SegundoNombre		VARCHAR(100);	-- Segundo nombre del cliente
	DECLARE Var_TercerNombre		VARCHAR(100);	-- Tercer nombre del cliente
	DECLARE Var_ApellidoPaterno		VARCHAR(50);	-- Apellido paterno del cliente
	DECLARE Var_ApellidoMaterno		VARCHAR(50);	-- Apellido materno del cliente
	DECLARE Var_RFCOficial			VARCHAR(50);	-- Rfc oficial del cliente
	DECLARE Var_FechaNacimiento		DATE;			-- Fecha de nacimiento del cliente
	DECLARE Var_PaisID				INT(11);		-- Pais del cliente
	DECLARE Var_EstadoID			INT(11);		-- Estadi del cliente
	DECLARE	Var_TipoPersona			CHAR(1);		-- Tipo de persona del cliente F: Fisica, M: Moral
	DECLARE Var_LlaveCRW			VARCHAR(50);	-- Llave para filtro de modulo crowdfunding
	DECLARE Var_CrwActivo			CHAR(1);		-- Variable para almacenar el valor de habilitacion de modulo crowdfunding
	
	/*Declaracion de constantes*/
	DECLARE Cadena_Vacia		VARCHAR(2);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Fecha vacia
	DECLARE Cadena_Cero			VARCHAR(4);			-- Cadena cero
	DECLARE Entero_Cero			INT(11);				-- Entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);		-- Decimal cero
	DECLARE SalidaSI			CHAR(1);			-- Salida si
	DECLARE SalidaNO			CHAR(1);			-- Salida no
	DECLARE Constante_SI		CHAR(1);			-- Constante si
	DECLARE Constante_NO		CHAR(1);			-- Constante no
	DECLARE Entero_Uno			INT(11);			-- Entero uno
	
	DECLARE montoAutSC			DECIMAL(12,2);		-- Monto autorizado solicitado
	DECLARE	plazoMes			INT(11);			-- plazo mes
	DECLARE cienPorciento		DECIMAL(12,2);		-- cien por ciento
	DECLARE porcent				DECIMAL(8,4);		-- Porcentaje
	DECLARE montoInv			DECIMAL(12,2);		-- Monto inversion
	DECLARE montoaFond			DECIMAL(12,2);		-- Monto fondeo
	DECLARE FecSist				DATE;				-- Fecha sistema
	DECLARE Per_Semanal		 	CHAR(1);			-- Periodicidad semanal
	DECLARE FecVenCred			DATE;				-- Fecha vencimiento credito
	DECLARE	Frecuencia			CHAR(1);			-- Frecuencia
	DECLARE	FrecSemanal			INT(11);			-- Frecuencia Semanal
	DECLARE FrecCator			INT(11);			-- Frecuencia catorcenal
	DECLARE FrecQuin			INT(11);			-- Frecuencia quincenal
	DECLARE FrecMensual			INT(11);			-- Frecuencia mensual
	DECLARE Per_Catorcenal		CHAR(1); 			-- Periodicidad catorcenal
	DECLARE Per_Quincenal	 	CHAR(1); 			-- Periodicidad quincenal
	DECLARE Per_Mensual	 		CHAR(1);			-- Periodicidad mensual
	DECLARE	AjuFecExVen			CHAR(1); 			-- Ajuste fecha
	DECLARE	CalInt				INT(11);			-- Calculo interes
	DECLARE	fechaHabilT			CHAR(1);
	DECLARE Var_FechaAutoriza	DATE;				-- Fecha de autorizacion del credito
	
	/* Asignacion de Constantes */
	SET Cadena_Vacia        := '';              -- Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero         := 0;               -- Entero en Cero
	SET Decimal_Cero        := 0.0;             -- DECIMAL Cero
	SET SalidaSI            := 'S';             -- El store si Regresa una Salida
	SET SalidaNO            := 'N';             -- El store no Regresa una Salida
	SET Constante_NO		:= 'N';			-- Constante NO
	SET Constante_SI		:= 'S';			-- Constante SI
	SET Entero_Uno			:= 1;			-- Entero uno

    SET Cadena_Cero			:= '0';			-- Cadena cero
    SET cienPorciento 		:= 100.00;		-- Cien por ciento
    SET Per_Semanal			:='S';			-- Asignacion Periodicidad semanal
    SET Per_Catorcenal		:='C';			-- Periodicidad catorcenal			
	SET Per_Quincenal		:='Q'; 			-- Periodicidad quincenal
	SET Per_Mensual			:='M'; 			-- Periodicidad mensual
    SET FrecSemanal			:= 7;			-- Frecuencia semanal
    SET FrecCator			:= 14;			-- Frecuencia catorcenal
    SET FrecQuin			:= 15;			-- Frecuencia quincenal
    SET FrecMensual			:= 30;			-- Frecuencia mensual
    SET	AjuFecExVen 		:= 'N';			-- Ajuste fecha exigente
    SET	CalInt				:= 1;			-- tipo calculo de intereses (1 .- Saldos Insolutos\n2 .- Monto Original (Saldos Globales)
    SET	fechaHabilT 		:= 'S';
	SET Par_SolicCredID 	:= IFNULL(Par_SolicCredID, Entero_Cero);
	SET Par_AjFUlVenAm		:= IFNULL(Par_AjFUlVenAm, Cadena_Vacia);
	SET Par_CuentaCLABE		:= IFNULL(Par_CuentaCLABE, Entero_Cero);
	SET Constante_No		:= 'N';				-- Constante NO
    
    /* Asignacion de variables */ 
    SET Var_TipoFondProp	:= 'P';			-- Pago tipo fondeador propios
    SET Var_PagoCapFAnu		:= 'A';			-- Pago capital anual
    SET Var_TPagCapCrec		:= 'C';			-- Tipo pago capital crecientes
    SET Var_TipoCredNuevo	:= 'N';			-- Tipo credito nuevo N
    SET Var_TipoFondeadDef	:= 3;			-- Asignacion de tipo de fondeador por default
    SET Var_ProcDetecCre	:= 'CREDITO';	-- Asignacion de proceso de deteccion pld
	SET Var_TipoPerSAFI		:= 'CTE';		-- Tipo persona safi
	SET Var_SolicAuto		:= 'A';			-- Estatus autorizada
	SET Var_DiaPago			:= 'A';			-- Dia pago capital anual
	SET Var_Cat				:= Decimal_Cero;
	SET Var_FechaAutoriza	:= NOW();
	SET Var_LlaveCRW		:= 'ActivoModCrowd'; 	-- Filtro para variable de modulo crowdfunding

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWCREDITOSPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;
		
		-- Se obtiene el valor de la parametrizacion para fondeos de crowdfunding
		SELECT ValorParametro
		INTO  Var_CrwActivo
		FROM PARAMGENERALES WHERE LlaveParametro = Var_LlaveCRW;
		
		/*IF(Var_CrwActivo = Constante_No)THEN 
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'Para ejecutar el proceso, se requiere habilitar el modulo de crowdfunding';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;*/
		
		IF(Par_SolicCredID = Entero_Cero) THEN
			SET Par_NumErr 		:= 001;
			SET Par_ErrMen	 	:= 'La solcitud de credito se encuentra vacio.';
			SET Var_Control		:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		
		IF(Par_AjFUlVenAm <> Cadena_Vacia) THEN
			IF((Par_AjFUlVenAm <> Constante_SI) AND (Par_AjFUlVenAm <> Constante_NO)) THEN
				SET Par_NumErr 		:= 002;
				SET Par_ErrMen	 	:= 'Formato para indicar si ajusta la fecha de la ultima amortización no valida.';
				SET Var_Control		:= 'ajFUlVenAm';
				LEAVE ManejoErrores;
			END IF;
		END IF;
		
		IF(Par_CuentaCLABE <> Entero_Cero) THEN
			IF(LENGTH(Par_CuentaCLABE) <> 18) THEN
				SET Par_NumErr 		:= 003;
				SET Par_ErrMen	 	:= 'Cuenta clabe debe contener 18 caracteres.';
				SET Var_Control		:= 'cuentaClabe';
				LEAVE ManejoErrores;
			END IF;
		END IF;
		-- Para comprobacion de datos
		SELECT SolicitudCreditoID, 		ClienteID,		Estatus,			FechaInicio
		INTO Var_SolicitudID,			Var_ClienteID,	Var_EstatusSoli,	Var_FechaInicio
		FROM SOLICITUDCREDITO
		WHERE SolicitudCreditoID = Par_SolicCredID;
		
		SET Var_SolicitudID := IFNULL(Var_SolicitudID, Entero_Cero);
		-- Validacion de existencia
		IF(Var_SolicitudID = Entero_Cero) THEN
			SET Par_NumErr 		:= 004;
			SET Par_ErrMen	 	:= 'La solicitud de credito no existe.';
			SET Var_Control		:= 'solicitudCreditoID';
			LEAVE ManejoErrores;
		END IF;
		
		-- Validacion estatus
		IF(Var_EstatusSoli <> Var_SolicAuto) THEN 
			SET Par_NumErr 		:= 005;
			SET Par_ErrMen	 	:= 'La solicitud de credito no se encuentra autorizada.';
			SET Var_Control		:= 'estatus';
			LEAVE ManejoErrores;
		END IF;
		-- Valida su cliente 
		IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr 		:= 006;
			SET Par_ErrMen	 	:= 'La solicitud de credito requiere de un cliente.';
			SET Var_Control		:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;
		
		-- Registro nuevo
		SELECT 	TRIM(UPPER(PrimerNombre)),		TRIM(UPPER(SegundoNombre)),		TRIM(UPPER(TercerNombre)),		TRIM(UPPER(ApellidoPaterno)),
				TRIM(UPPER(ApellidoMaterno)),	TRIM(UPPER(RFCOficial)),		FechaNacimiento,				Entero_Cero,
				LugarNacimiento,				EstadoID,						TipoPersona
		INTO 	Var_PrimerNombre,				Var_SegundoNombre,				Var_TercerNombre,				Var_ApellidoPaterno,
				Var_ApellidoMaterno,			Var_RFCOficial,					Var_FechaNacimiento,			Var_CuentaAho,
				Var_PaisID,						Var_EstadoID,					Var_TipoPersona
		FROM CLIENTES
		WHERE ClienteID = Var_ClienteID;
		
		CALL PLDDETECCIONPRO(
			Var_ClienteID,				Var_PrimerNombre, 		Var_SegundoNombre, 	Var_TercerNombre, 		Var_ApellidoPaterno,
			Var_ApellidoMaterno, 		Var_TipoPersona, 		Cadena_Vacia, 		Var_RFCOficial,			Cadena_Vacia, 
			Var_FechaNacimiento, 		Var_CuentaAho,			Var_PaisID, 		Var_EstadoID, 			Cadena_Vacia, 
			Var_TipoPerSAFI, 			Cadena_Vacia, 			Cadena_Vacia, 		Cadena_Vacia,		SalidaNO, 	
			Par_NumErr, 				Par_ErrMen, 			Aud_EmpresaID,		Aud_Usuario, 		Aud_FechaActual,
			Aud_DireccionIP, 			Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion	
			);
		
		IF(Par_NumErr <> Entero_Cero) THEN
			SET Par_NumErr	:= 005;
			LEAVE ManejoErrores;
		END IF;
			
		SET	Par_AjFUlVenAm 	:= Constante_SI;
		
		-- Genera los datos para dar de alta un credito
		SELECT 	SOL.MontoAutorizado,		CRE.Dias,			SOL.FrecuenciaCap
		INTO	montoAutSC,					Var_DiasInv,		Var_Frecuencia
		FROM  SOLICITUDCREDITO	SOL
		INNER JOIN CREDITOSPLAZOS CRE ON CRE.PlazoID = SOL.PlazoID
		WHERE SOL.SolicitudCreditoID =	Par_SolicCredID;
		
		SELECT (cienPorciento-(SUM(ROUND(PorcentajeFondeo,2)))), (SUM(ROUND(MontoFondeo,2)))
		INTO	porcent,								  		montoInv
		FROM CRWFONDEOSOLICITUD
		WHERE SolicitudCreditoID = Par_SolicCredID;
			
		SET porcent	:=IFNULL(porcent, cienPorciento);
		SET montoInv	:=IFNULL(montoInv, Decimal_Cero);
		SET montoaFond:= ROUND(montoAutSC,2) - ROUND(montoInv,2);
		SET FecSist	:= (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = 1);	
		SET FecVenCred	:= (SELECT DATE_ADD(FecSist, INTERVAL Var_DiasInv DAY));
		
		
	
		SET Var_FechaHabilT 	:= fechaHabilT;
		SET Var_Porcent			:= porcent;
		SET Var_MontoaFond		:= montoaFond;
		SET Var_CalInt			:= CalInt;
		SET Var_FechaSistema 	:= FecSist;
		SET Var_FechaVenCred	:= FecVenCred;
		
		
		SELECT	Sol.ClienteID,			Sol.MontoAutorizado,	Sol.MonedaID,				Sol.TasaFija,			Sol.AjusFecExiVen,
				Par_AjFUlVenAm,			Sol.TipoPagoCapital,	Sol.PeriodicidadCap,		Sol.ProductoCreditoID,	Pro.FactorMora,
				Sol.Estatus,			Sol.CreditoID,			Sol.MontoPorComAper,		Sol.IVAComAper,			Sol.PlazoID,
				Sol.NumAmortizacion,	Pro.CobraSeguroCuota,	Pro.CobraIVASeguroCuota,	Sol.MontoSeguroCuota,	Sol.TipoDispersion,
				Sol.CalcInteresID,		Sol.DestinoCreID,		Sol.InstitFondeoID,			Sol.LineaFondeo,		Sol.NumAmortInteres,
				Sol.MontoSeguroVida,	Sol.AporteCliente,		Sol.ClasiDestinCred,		Sol.ForCobroSegVida,	Sol.DescuentoSeguro,
				Sol.MontoSegOriginal,	Sol.TipoConsultaSIC,	Sol.FolioConsultaBC,		Sol.FolioConsultaCC,	Sol.FechaCobroComision,	
				Pro.TipoPrepago
				
		INTO	Var_ClienteID,			Var_MontoAuto,			Var_MonedaID,			Var_TasaFija,			Var_AjuFecExVen,		
				Var_AjFUlVenAm,			Var_TipoPagoCapi,		Var_Periodicidad,		Var_ProductoCreditoID,	Var_FactorMora,
				Var_EstatusSoli,		Var_CreditoID,			Var_MontoPorComAper,	Var_IVAComAper,			Var_PlazoID,			
				Var_NumAmortizacion,	Var_CobraSeguroCuota,	Var_CobraIVASegCuota,	Var_MontoSeguroCuota,	Var_TipoDispersion,
				Var_CalcInteresID,		Var_DestinoCredID,		Var_InstitFondeoID,		Var_LineaFondeo,		Var_NumAmortizacionInt,	
				Var_MontoSeguroVida,	Var_AporteCliente,		Var_ClasiDestinCred,	Var_ForCobroSegVida,	Var_DescuentoSeguro,
				Var_MontoSegOriginal,	Var_TipoConsultaSIC,	Var_FolioConsultaBC,	Var_FolioConsultaCC,	Var_FechaCobroComision,	
				Var_TipoPrepago
		FROM 	SOLICITUDCREDITO	Sol,
					PRODUCTOSCREDITO 	Pro
			WHERE	Sol.SolicitudCreditoID = Par_SolicCredID
			AND 	Sol.ProductoCreditoID = Pro.ProducCreditoID;
		
		-- Se procede a la creacion del credito
		IF(Var_CreditoID = Entero_Cero) THEN
		
			-- Actualiza la cuenta clabe
			UPDATE SOLICITUDCREDITO SET
			CuentaCLABE		=  Par_CuentaCLABE
			WHERE SolicitudCreditoID = Par_SolicCredID;
			

			-- Se genera las amportizacciones
			CALL CREPAGCRECAMORPRO(
					Entero_Cero,			Var_MontoAuto,			Var_TasaFija,					Var_DiasInv,				Var_Frecuencia,
					Var_DiaPago,			DAY(Var_FechaSistema),	Var_FechaInicio,				Var_NumAmortizacion,		Var_ProductoCreditoID,	
					Var_ClienteID,			Var_FechaHabilT,		Var_AjFUlVenAm,					Var_AjuFecExVen,			Var_MontoPorComAper,
					Decimal_Cero,			Var_CobraSeguroCuota,	Var_CobraIVASegCuota,			Var_MontoSeguroCuota,		Decimal_Cero,			
					SalidaNO,				Par_NumErr,				Par_ErrMen,						Var_NumTranSimulador,		Var_Cuotas,
					Var_Cat,				Var_MontoCuo,			Var_FechaVen,					Aud_EmpresaID,				Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,				Aud_NumTransaccion);
			
			IF(Par_NumErr <> Entero_Cero) THEN
				SET Par_NumErr	:= 009;
				LEAVE ManejoErrores;
			END IF;
			
			SELECT	CuentaAhoID,	ClienteID
			INTO	Var_CuentaAho,	Var_ClienteID
			FROM CUENTASAHO
			WHERE	ClienteID	= Var_ClienteID
			AND	EsPrincipal	= Constante_SI;
			
			IF (IFNULL(Var_CuentaAho, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= 'El cliente debe de contar con una Cuenta Principal';
				SET Var_Control	:= 'cuentaAhoID';
				LEAVE ManejoErrores;
			END IF;
			
			SELECT	CuentaAhoID,	 	SucursalID,			ClienteID,	 		Clabe,		MonedaID,	
					TipoCuentaID,		FechaReg,			Etiqueta,			Estatus,	EstadoCta,
					InstitucionID, 		EsPrincipal,    	TelefonoCelular
					
			INTO 	Var_CuentaAho,		Var_SucursalID,		Var_ClienteID,		Var_Clabe,		Var_MonedaID,
					Var_TipoCuentaID,	Var_FechaReg,		Var_Etiqueta,		Var_Estatus,	Var_EstadosCta,
					Var_InstitucionID,	Var_EsPrincipal,	Var_TelCelular
			FROM CUENTASAHO
			WHERE	CuentaAhoID	= Var_CuentaAho;
			
			IF(IFNULL(Var_Estatus, Cadena_Vacia) <> 'A') THEN
				SET Par_NumErr	:= 010;
				SET Par_ErrMen	:= 'La cuenta de ahorro debe estar activada';
				SET Var_Control	:= 'estatus';
				LEAVE ManejoErrores;
			END IF;
			
			-- Registro de fondeo
			SELECT 	ClienteInstitucion, 	CuentaInstituc, 		FechaSistema
			INTO	Var_InstitucionID,		Var_CuentaInst,			Var_FechaSistema
			FROM PARAMETROSSIS;
			
			SET Var_GAT 	:= Decimal_Cero;
			SET Var_GatReal	:= Decimal_Cero;
			
			-- Validar si el modulo de crw se encuentra activo
			IF(Var_CrwActivo = Constante_SI) THEN 
				-- Solo si el porcentaje es mayor a cero
				IF(IFNULL(porcent, Decimal_Cero) > Entero_Cero) THEN
					
					CALL CRWFONDEOSOLICITUDALT(
							Par_SolicCredID,		Var_InstitucionID,		Var_CuentaInst,			Var_ProductoCreditoID,		Var_FechaSistema,
							montoaFond,				porcent,				Var_MonedaID,			Var_TasaFija,				Entero_Cero,
							Var_TipoFondeadDef,		Constante_SI,			SalidaNO,				Par_NumErr,					Par_ErrMen,
							Var_NumSolFond,			Var_GAT,				Var_GatReal,			Aud_EmpresaID,				Aud_Usuario,
							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
							
					);
					-- Validacion de registro de fondeo
					IF(Par_NumErr <> Entero_Cero) THEN
						SET Par_NumErr	:= 012;
						LEAVE ManejoErrores;
					END IF;
				END IF; -- validacion porcent
			END IF;-- validacion modulo crw
			
			-- Se registra el credito
			CALL CREDITOSALT(
					Var_ClienteID,			Entero_Cero,			Var_ProductoCreditoID,			Var_CuentaAho,				Var_TipoCredNuevo,
					Entero_Cero,			Var_SolicitudID,		Var_MontoAuto,					Var_MonedaID,				Var_FechaInicio,
					Var_FechaVen,			Var_FactorMora,			Var_CalcInteresID,				Entero_Cero,				Var_TasaFija,
					Decimal_Cero,			Decimal_Cero,			Decimal_Cero,					Var_Frecuencia,				Var_Periodicidad,
					Var_Frecuencia,			Var_Periodicidad,		Var_TPagCapCrec,				Var_Cuotas,					Var_FechaHabilT,
					Cadena_Vacia,			Var_PagoCapFAnu,		Var_PagoCapFAnu,				DAY(Var_FechaSistema),		DAY(Var_FechaSistema),
					Var_AjFUlVenAm,			Var_AjuFecExVen,		Var_NumTranSimulador,			Var_TipoFondProp,			Var_MontoPorComAper,
					Var_IVAComAper,			Var_Cat,				Var_PlazoID,					Var_TipoDispersion,			Var_Clabe,
					Var_CalInt,				Var_DestinoCredID,		Var_InstitFondeoID,				Var_LineaFondeo,			Var_NumAmortizacionInt,
					Var_MontoCuo,			Var_MontoSeguroVida,	Var_AporteCliente,				Var_ClasiDestinCred,		Cadena_Vacia,
					Var_FechaInicio,		Var_ForCobroSegVida,	Var_DescuentoSeguro,			Var_MontoSegOriginal,		Var_TipoConsultaSIC,
					Var_FolioConsultaBC,	Var_FolioConsultaCC,	Var_FechaCobroComision,			Cadena_Vacia,				SalidaNO,
					Var_CreditoID,			Par_NumErr,				Par_ErrMen,						Aud_EmpresaID,				Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,				Aud_NumTransaccion
				);
				
			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
			-- Fin seccion envio correo
		
		END IF;
		-- Fin de creacion de credito
		
		-- Se autoriza la solicitud en caso de que exista el credito
		IF(Var_CreditoID <> Entero_Cero) THEN
		
			CALL DETESCALAINTPLDPRO (
			Var_CreditoID,		Entero_Cero,		Var_ProcDetecCre,		Entero_Cero,	SalidaNO,
			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
			
			IF(Par_NumErr <> Entero_Cero) THEN
				-- SET Par_NumErr	:= 006;
				-- LEAVE ManejoErrores;
				
				CALL CRWENVIOCORREOALT(
				Var_CreditoID,	Entero_Cero,	SalidaNO,			Par_NumErr,			Par_ErrMen,
				Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,	Aud_NumTransaccion);
						
				IF(Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr	:= 015;
					LEAVE ManejoErrores;
				END IF;
				-- Se genera una nueva transaccion
				CALL TRANSACCIONESPRO(Var_TransacPagare);
				
				-- Grabar pagarE
				CALL CREGENAMORTIZAPRO(
					Var_CreditoID,		Var_FechaSistema,		Var_FechaInicio, 		Var_TipoPrepago,	SalidaNO,   
					Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual, 
					Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Var_TransacPagare);
					
				IF(Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr	:= 016;
					LEAVE ManejoErrores;
				END IF;

				-- Impresion de pagare
				UPDATE CREDITOS SET 
					PagareImpreso 	= SalidaSI
				WHERE CreditoID = IFNULL(Var_CreditoID, Entero_Cero);
				
				
				-- actualizamos el check list como recibido
				UPDATE CREDITODOCENT
					SET DocAceptado = SalidaSI
				WHERE CreditoID  = Var_CreditoID;
				
				CALL CREDITOSACT(
					Var_CreditoID,		Entero_Cero,		Var_FechaAutoriza,		Aud_Usuario,		Entero_Uno,
					Fecha_Vacia,		Fecha_Vacia,		Decimal_Cero,			Decimal_Cero,		Entero_Cero,
					Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,			SalidaNO,			Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
					
				IF(Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr	:= 017;
					LEAVE ManejoErrores;
				END IF;
				
			END IF;	-- Fin if pld
		END IF; 	-- Fin if autoriza
	
		SET     Par_NumErr 	:= 0;
		SET     Par_ErrMen 	:=  CONCAT("Credito Agregado: ", CONVERT(Var_CreditoID, CHAR));
		SET     Var_Control := 'creditoID';
	
	END ManejoErrores;
	
		IF(Par_Salida =SalidaSI) THEN
			SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS Control,
				Var_CreditoID AS Consecutivo,
				Var_Cat		AS CAT;
		END IF;

END TerminaStore$$
