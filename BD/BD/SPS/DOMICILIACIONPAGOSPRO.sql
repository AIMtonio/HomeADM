-- SP DOMICILIACIONPAGOSPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS DOMICILIACIONPAGOSPRO;

DELIMITER $$


CREATE PROCEDURE `DOMICILIACIONPAGOSPRO`(
# ====================================================================
# --------- STORE PARA EL PROCESO DE DOMICILIACION DE PAGOS ----------
# ====================================================================
	Par_ClienteID			INT(11),			-- ID Cliente
	Par_InstitucionID		INT(11),			-- ID Institucion
    Par_CuentaClabe			VARCHAR(18),		-- Cuenta Clabe
    Par_CreditoID			BIGINT(12),			-- ID Credito
    Par_MontoAplicado		DECIMAL(14,2),		-- Monto Aplicado

    Par_MontoPendiente		DECIMAL(14,2),		-- Monto Pendiente
    Par_ClaveDomicilia		CHAR(2),			-- Clave de Domiciliacion
    Par_FolioID				BIGINT(20),			-- ID Folio
	Par_Poliza				BIGINT(20),			-- Numero de Poliza
    Par_NombreArchivo		VARCHAR(200),		-- Nombre del Archivo

    Par_Salida           	CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),			-- Numero de Error
	INOUT Par_ErrMen     	VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control     		VARCHAR(100);	-- Almacena el control de errores
    DECLARE Var_CuentaClabe			VARCHAR(18);	-- Numero de Cuenta Clabe
    DECLARE Var_ClienteID       	INT(11);		-- Numero del Cliente
	DECLARE	Var_ConsecutivoID		BIGINT(20);		-- ID Consecutivo
    DECLARE Var_FechaProceso    	DATETIME;		-- Fecha Proceso

    DECLARE Var_CtaTransDomicilia	VARCHAR(25);	-- Cuenta Contable en Transito para Domiciliacion de Pagos
	DECLARE Var_CtaContable 		VARCHAR(25);	-- Numero de la Cuenta Contable
	DECLARE Var_TipoMovDomiciliaID	CHAR(4);		-- ID del Tipo de Movimiento de Domiciliacion de Pagos
    DECLARE Var_TipoMovTesoID		CHAR(4);		-- ID de Movimiento de Tesoreria
    DECLARE Var_ReqVerificacion		CHAR(1);		-- Requiere Verificacion (S = SI N = NO)

    DECLARE Var_MontoExigible		DECIMAL(14,2);	-- Monto Exigible del Credito
	DECLARE Var_CuentaAhoID     	BIGINT(12);		-- Cuenta de Ahorro
    DECLARE Var_FechaOper       	DATE;			-- Fecha Operacion
	DECLARE Var_MonedaID        	INT(11);		-- ID Moneda
    DECLARE Var_Referencia			VARCHAR(50);	-- Valor de la Referencia

    DECLARE Var_FrecuenCap      	CHAR(1);		-- Frecuencia de Capital
    DECLARE Var_InstitNominaID		INT(11);		-- Institucion de Nomina
    DECLARE Var_ConvenioNominaID	INT(11);		-- Convenio de Nomina
	DECLARE Var_CreditoID			BIGINT(12);		-- ID Credito
    DECLARE Var_BancoDeposito		INT(11);		-- Banco de Deposito

    DECLARE Var_CuentaDeposito		CHAR(18);		-- Cuenta de Deposito
    DECLARE Var_ClienteNominaID		INT(11);		-- ID Cliente de Nomina
	DECLARE Var_EmitePoliza         CHAR(1);		-- Emite Poliza
	DECLARE Var_AltaMovAho      	CHAR(1);		-- Alta de Movimiento de Ahorro
	DECLARE Var_TipoMovAho      	VARCHAR(4);		-- Tipo de Movimiento de Ahorro

	DECLARE Var_NomenclaturaCR  	VARCHAR(30);	-- NomenclaturaCR en la tabla PARAMETROSNOMINA
	DECLARE Var_AltaDetPol      	CHAR(1); 		-- Alta detalle de poliza de ahorro
	DECLARE Var_CentroCostos    	INT(11);		-- Centro de Costos Sucursal Cliente/Origen
	DECLARE Var_EsPrePago			CHAR(1); 		-- Es Prepago
	DECLARE Var_Finiquito			CHAR(1); 		-- Es Finiquito de Credito

	DECLARE Var_CuotasPendientes	INT(11);		-- Cuotas Pendientes por Cubrir
	DECLARE Var_MontoPendiente		INT(11);		-- Monto Pendiente por Cubrir
    DECLARE Var_NombreArchivo		VARCHAR(200);	-- Nombre del Archivo de Domiciliacion de Pagos
    DECLARE Var_SucursalID			INT(11);		-- Numero de la Sucursal

	DECLARE Var_CargosPoliza		DECIMAL(14,4);	-- Almacena los Cargos de la Poliza
	DECLARE Var_AbonosPoliza		DECIMAL(14,4);	-- Almacena los Abonos de la Poliza
	DECLARE Var_InstitucionNominaID INT(11);		-- Almacena el valor de la empresa de Institucion de Nomina en la Solicitud de Credito

    -- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);
    DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Cadena_Vacia   		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	SalidaSI        	CHAR(1);

    DECLARE	SalidaNO        	CHAR(1);
    DECLARE ConstanteSI			CHAR(1);
	DECLARE ConstanteNO			CHAR(1);
    DECLARE Est_Activo			CHAR(1);
    DECLARE	Est_NoConci			CHAR(1);

    DECLARE Est_Vigente     	CHAR(1);
    DECLARE Est_Vencido     	CHAR(1);
	DECLARE Est_Pagado			CHAR(1);
    DECLARE Est_Afiliada		CHAR(1);
    DECLARE Aplica_Credito		CHAR(1);

    DECLARE Aplica_Ambas		CHAR(1);
    DECLARE TipoCtaSpeiClabe	INT(11);
	DECLARE NatConta			CHAR(1);
	DECLARE Nat_Abono           CHAR(1);
    DECLARE DescripcionMov		VARCHAR(50);

    DECLARE ConAhoPasivo		INT(11);
	DECLARE CentroCostoCli		VARCHAR(10);
	DECLARE CentroCostoOri		VARCHAR(10);
	DECLARE Procedimiento		VARCHAR(50);
	DECLARE Tipo_Instrumento	INT(11);

	DECLARE Pago_CargoCuenta	CHAR(1);
	DECLARE Con_Origen			CHAR(1);
	DECLARE ClaveExitosa		CHAR(2);
    DECLARE Entero_Uno			INT(11);
    DECLARE LimiteDifPoliza		DECIMAL(12,2);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
    SET Decimal_Cero		:= 0.00;			-- Decimal Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	SalidaSI        	:= 'S';				-- Salida Si

    SET	SalidaNO        	:= 'N'; 			-- Salida No
    SET ConstanteSI			:= 'S';				-- Constante: SI
	SET ConstanteNO			:= 'N';				-- Constante: NO
    SET Est_Activo			:= 'A';				-- Estatus: Activo
    SET Est_NoConci		 	:= 'N';				-- Estatus: No Conciliado

    SET Est_Vigente	    	:= 'V'; 			-- Estatus Credito: Vigente
    SET Est_Vencido     	:= 'B'; 			-- Estatus Credito: Vencido
    SET Est_Pagado			:= 'P';				-- Estatus Amortizacion: Pagada
    SET Est_Afiliada		:= 'A';				-- Estatus Domiciliacion: Afiliada
    SET Aplica_Credito		:= 'C';				-- Aplica para: Credito

    SET Aplica_Ambas		:= 'A';				-- Aplica para: Ambas
	SET TipoCtaSpeiClabe	:= 40;				-- Tipo Cuenta Spei: Clabe Interbancaria
	SET NatConta        	:= 'C';				-- Naturaleza Contable
	SET Nat_Abono           := 'A';				-- Naturaleza Abono
	SET DescripcionMov		:= 'DOMICILIACION PAGO DE CREDITO';		-- Descripcion Movimiento

	SET ConAhoPasivo		:= 1;				-- Corresponde con la tabla CONCEPTOSAHORRO
    SET CentroCostoCli  	:= '&SC';			-- Centro de Costos Sucursal Cliente
	SET CentroCostoOri  	:= '&SO';			--  Centro de Costos Sucursal Origen
	SET Procedimiento 		:= 'DOMICILIACIONPAGOSPRO';
	SET Tipo_Instrumento	:= 11;				-- Tipo de Instrumento CREDITOS de la tabla TIPOINSTRUMENTOS

	SET Pago_CargoCuenta	:= 'C';				-- Pago con Cargo a Cuenta
	SET Con_Origen			:= 'D';				-- Origen de Pago domiciliacion
    SET ClaveExitosa		:= '00';			-- Clave Exitosa
	SET Entero_Uno			:= 1;				-- Entero Uno
    SET LimiteDifPoliza		:= 0.01;			-- Monto Limite de Diferencia

    -- Asignacion de Variables
    SET Var_TipoMovAho 	:= '101';				-- Corresponde al Tipo de Movimiento de PAGO CREDITO de la tabla TIPOSMOVSAHO
    SET Entero_Uno		:= 1;

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DOMICILIACIONPAGOSPRO');
			SET Var_Control= 'SQLEXCEPTION' ;
		END;

		-- Se obtiene la Fecha de Operacion
		SET Var_FechaOper :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

        -- Se valida si el Archivo de Domiciliacion de Pagos ya fue Procesada anteriormente.
        SET Var_NombreArchivo :=(SELECT NombreArchivo FROM DOMICILIAPAGOSARCH WHERE NombreArchivo = Par_NombreArchivo AND Fecha = Var_FechaOper);
        SET Var_NombreArchivo :=IFNULL(Var_NombreArchivo,Cadena_Vacia);

        IF(Var_NombreArchivo <> Cadena_Vacia)THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= CONCAT("El Archivo ",Var_NombreArchivo," ya Fue Procesado Anteriormente.");
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
        END IF;


		-- Se obtiene el Numero de Institucion de Nomina del Credito del Cliente
		SELECT Cre.InstitNominaID INTO Var_InstitucionNominaID
		FROM CLIENTES Cli,
			 CREDITOS Cre
		WHERE Cre.ClienteID = Cli.ClienteID
		  AND Cre.ClienteID = Par_ClienteID
		  AND Cre.CreditoID = Par_CreditoID;

		SET Var_InstitucionNominaID :=IFNULL(Var_InstitucionNominaID,Entero_Cero);


        -- Se obtiene informacion necesaria para clientes de Nomina
		SELECT 	DISTINCT Cli.ClienteID,			Nom.InstitNominaID,		Nom.ConvenioNominaID,	Ins.ReqVerificacion
		INTO 	Var_ClienteNominaID,	Var_InstitNominaID,		Var_ConvenioNominaID,	Var_ReqVerificacion
		FROM INSTITNOMINA Ins,
			 CONVENIOSNOMINA Con,
			 NOMINAEMPLEADOS Nom,
			 CLIENTES Cli,
			 SOLICITUDCREDITO Sol,
			 CREDITOS Cre,
			 CUENTASTRANSFER Cta
		WHERE Ins.InstitNominaID = Con.InstitNominaID
		  AND Con.ConvenioNominaID = Nom.ConvenioNominaID
		  AND Con.InstitNominaID = Nom.InstitNominaID
		  AND Nom.ClienteID = Cli.ClienteID
		  AND Nom.ClienteID = Sol.ClienteID
		  AND Sol.ClienteID = Cre.ClienteID
		  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
		  AND Cre.ClienteID = Cta.ClienteID
		  AND Con.Estatus = Est_Activo
		  AND Con.DomiciliacionPagos = ConstanteSI
		  AND Cre.Estatus IN(Est_Vigente,Est_Vencido)
		  AND Cta.EstatusDomici = Est_Afiliada
		  AND Cta.AplicaPara IN(Aplica_Credito,Aplica_Ambas)
		  AND Cta.TipoCuentaSpei = TipoCtaSpeiClabe
		  AND Sol.InstitucionNominaID != Entero_Cero
		  AND Cre.CreditoID = Par_CreditoID
          AND Ins.InstitNominaID = Var_InstitucionNominaID;

		SET Var_ClienteNominaID  :=IFNULL(Var_ClienteNominaID,Entero_Cero);
		SET Var_InstitNominaID 	 :=IFNULL(Var_InstitNominaID,Entero_Cero);
        SET Var_ConvenioNominaID :=IFNULL(Var_ConvenioNominaID,Entero_Cero);
		SET Var_ReqVerificacion := IFNULL(Var_ReqVerificacion,ConstanteNO);

        SELECT  Cre.ClienteID,          Cre.CuentaID,           Cre.MonedaID,			Cre.FrecuenciaCap
		  INTO	Var_ClienteID,      	Var_CuentaAhoID,    	Var_MonedaID,     		Var_FrecuenCap
		FROM 	CREDITOS Cre,
				CUENTASAHO Cta
		WHERE CreditoID 			= Par_CreditoID
		  AND Cta.ClienteID			= Cre.ClienteID
		  AND Cta.CuentaAhoID		= Cre.CuentaID;

		-- Se obtiene la Referencia del Cliente registrada en DETAFILIABAJACTADOM
        SET Var_Referencia :=(SELECT MAX(Referencia) FROM DETAFILIABAJACTADOM WHERE ClienteID = Par_ClienteID);
        SET Var_Referencia :=IFNULL(Var_Referencia,Cadena_Vacia);

        -- Se valida si existe la Cuenta Clabe de Domiciliacion
        SET Var_CuentaClabe 	:= (SELECT ClabeCtaDomici
												FROM SOLICITUDCREDITO
                                                WHERE ClabeCtaDomici = Par_CuentaClabe
                                                LIMIT 1);

		SET Var_CuentaClabe 	:=IFNULL(Var_CuentaClabe,Cadena_Vacia);

        IF(Var_CuentaClabe = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen 	:= CONCAT("La Cuenta Clabe No Existe ",Var_CuentaClabe,".");
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;

        -- Se valida que exista el Credito
        SET Var_CreditoID	:= (SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET Var_CreditoID   :=IFNULL(Var_CreditoID,Entero_Cero);

		IF(Var_CreditoID = Entero_Cero) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:= CONCAT("El Credito No Existe ",Var_CreditoID,".");
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;

		-- Se obtiene la Cuenta Contable en Transito para la Domiciliacion de Pagos
		SET Var_CtaTransDomicilia	:= (SELECT CtaTransDomicilia FROM PARAMETROSNOMINA LIMIT 1);
		SET Var_CtaTransDomicilia 	:=IFNULL(Var_CtaTransDomicilia,Cadena_Vacia);

        -- Se valida que la cuenta existe
		SET Var_CtaContable 	:= (SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Var_CtaTransDomicilia);
		IF(IFNULL(Var_CtaContable,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen 	:= 'La Cuenta Contable en Transito para Domiciliacion No Existe.';
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;

        -- Se obtiene el Tipo de Movimiento para la Domiciliacion de Pagos
		SET Var_TipoMovDomiciliaID  :=(SELECT TipoMovDomiciliaID FROM PARAMETROSNOMINA LIMIT 1);
		SET Var_TipoMovDomiciliaID :=IFNULL(Var_TipoMovDomiciliaID,Cadena_Vacia);

        -- Se valida que el Tipo de Movimiento de Domiciliacion Exista
		SET Var_TipoMovTesoID	:= (SELECT TipoMovTesoID FROM TIPOSMOVTESO WHERE TipoMovTesoID = Var_TipoMovDomiciliaID);
		IF(IFNULL(Var_TipoMovTesoID,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen 	:= 'El Tipo de Movimiento de Domiciliacion No Existe.';
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;

         -- Se obtiene el Centro de Costos
		SET Var_NomenclaturaCR := (SELECT NomenclaturaCR FROM PARAMETROSNOMINA LIMIT 1);
		SET Var_NomenclaturaCR 	:=IFNULL(Var_NomenclaturaCR,Cadena_Vacia);

        IF(Var_NomenclaturaCR = Cadena_Vacia) THEN
			SET Par_NumErr 	:= 006;
			SET Par_ErrMen	:= 'La Nomenclatura Centro de Costo esta Vacia.';
			SET Var_Control := 'procesar';
			LEAVE ManejoErrores;
		END IF;

		-- Se obtiene el numero y cuenta de Deposito del Banco
		SELECT BancoDeposito,		CuentaDeposito
        INTO   Var_BancoDeposito,	Var_CuentaDeposito
        FROM INSTITNOMINA
        WHERE InstitNominaID = Var_InstitNominaID;

		-- Validaciones cuando se requiere Verificacion
		IF(Var_ReqVerificacion = ConstanteSI)THEN
			IF NOT EXISTS(SELECT FolioCargaID
							FROM TESOMOVSCONCILIA
							WHERE InstitucionID = Var_BancoDeposito
							AND NumCtaInstit = Var_CuentaDeposito
							AND NatMovimiento = Nat_Abono
							AND TipoMov = Var_TipoMovDomiciliaID
							AND EstatusConciliaIN = Est_NoConci
							AND ReferenciaMov = Var_InstitNominaID)THEN
				SET Par_NumErr 	:= 007;
				SET Par_ErrMen 	:= 'No se Localizo Deposito en Banco.';
				SET Var_Control := 'procesar';
				LEAVE ManejoErrores;
			END IF;

        END IF;

		-- Se obtiene el Monto Exigible del Credito
        SET Var_MontoExigible := (SELECT FUNCIONEXIGIBLE(Par_CreditoID));
		SET Var_MontoExigible := IFNULL(Var_MontoExigible,Decimal_Cero);

        -- Se realizan las afectaciones cuando el Monto Exigible del Credito es igual a 0.00
       IF(Var_MontoExigible = Decimal_Cero AND Par_MontoAplicado > Decimal_Cero AND Par_ClaveDomicilia = ClaveExitosa)THEN

			SET Var_EmitePoliza	:= ConstanteNO;
			SET Var_AltaDetPol  := ConstanteSI;

			-- Llama al store para Abonar a la cuenta del Cliente
			CALL CONTAAHOPRO(
				Var_CuentaAhoID,	Var_ClienteID,		Aud_NumTransaccion,		Var_FechaOper,		Var_FechaOper,
				Nat_Abono,			Par_MontoAplicado,	DescripcionMov,			Par_CreditoID,		Var_TipoMovAho,
				Var_MonedaID,		Entero_Cero,		Var_EmitePoliza, 		Entero_Cero,		Par_Poliza,
				Var_AltaDetPol, 	ConAhoPasivo,		Nat_Abono,				Entero_Cero,		SalidaNO,
				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Se obtiene el valor de la Nomenclatura del Centro de Costos
			IF(Var_NomenclaturaCR = CentroCostoCli)THEN
				SET Var_SucursalID 		:=(SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_ClienteID);
                SET Var_CentroCostos 	:=(SELECT CentroCostoID FROM SUCURSALES WHERE SucursalID = Var_SucursalID);
			ELSE
				IF (Var_NomenclaturaCR = CentroCostoOri) THEN
					SET Var_CentroCostos :=(SELECT CentroCostoID FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
				END IF;
			END IF;

			-- Llama al store para dar de alta el detalle de poliza
			CALL DETALLEPOLIZASALT (
				Par_EmpresaID,		Par_Poliza,			Var_FechaOper, 		Var_CentroCostos,	Var_CtaTransDomicilia,
				Par_CreditoID,		Var_MonedaID,		Par_MontoAplicado,	Entero_Cero,		DescripcionMov,
				Par_CreditoID,		Procedimiento,		Tipo_Instrumento,	Cadena_Vacia,		Decimal_Cero,
				Cadena_Vacia,		SalidaNO, 			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

        END IF;

		-- Se realizan las afectaciones cuando el Monto Exigible del Credito es mayor a 0.00
        IF(Var_MontoExigible > Decimal_Cero AND Par_MontoAplicado > Decimal_Cero AND Par_ClaveDomicilia = ClaveExitosa)THEN

			SET Var_EmitePoliza	:= ConstanteNO;
			SET Var_AltaDetPol  := ConstanteSI;

			-- Llama al store para Abonar a la cuenta del Cliente
			CALL CONTAAHOPRO(
				Var_CuentaAhoID,	Var_ClienteID,		Aud_NumTransaccion,		Var_FechaOper,		Var_FechaOper,
				Nat_Abono,			Par_MontoAplicado,	DescripcionMov,			Par_CreditoID,		Var_TipoMovAho,
				Var_MonedaID,		Entero_Cero,		Var_EmitePoliza, 		Entero_Cero,		Par_Poliza,
				Var_AltaDetPol, 	ConAhoPasivo,		Nat_Abono,				Entero_Cero,		SalidaNO,
				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_NomenclaturaCR = CentroCostoCli)THEN
				SET Var_SucursalID 		:=(SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_ClienteID);
                SET Var_CentroCostos 	:=(SELECT CentroCostoID FROM SUCURSALES WHERE SucursalID = Var_SucursalID);
			ELSE
				IF (Var_NomenclaturaCR = CentroCostoOri) THEN
					SET Var_CentroCostos :=(SELECT CentroCostoID FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
				END IF;
			END IF;

			-- Llama al store para dar de alta el detalle de poliza
			CALL DETALLEPOLIZASALT (
				Par_EmpresaID,		Par_Poliza,			Var_FechaOper, 		Var_CentroCostos,	Var_CtaTransDomicilia,
				Par_CreditoID,		Var_MonedaID,		Par_MontoAplicado,	Entero_Cero,		DescripcionMov,
				Par_CreditoID,		Procedimiento,		Tipo_Instrumento,	Cadena_Vacia,		Decimal_cero,
				Cadena_Vacia,		SalidaNO, 			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_EsPrePago 	:= ConstanteNO;
			SET Var_Finiquito 	:= ConstanteNO;
			SET Var_EmitePoliza	:= ConstanteNO;

			-- Llamada al store para aplicar los pagos de Credito
			CALL PAGOCREDITOPRO(
				Par_CreditoID,   	Var_CuentaAhoID,   	Par_MontoAplicado, 	Entero_Uno, 		Var_EsPrePago,
				Var_Finiquito,   	Par_EmpresaID,	  	SalidaNO,			Var_EmitePoliza, 	Decimal_Cero,
				Par_Poliza,	  		Par_NumErr,        	Par_ErrMen,	 		Entero_Cero,	 	Pago_CargoCuenta,
				Con_Origen,			ConstanteNO, 		Aud_Usuario,	 	Aud_FechaActual, 	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,    	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

        END IF;

        -- Se realiza la suma de los CARGOS y ABONOS de la Poliza
		SELECT ROUND(SUM(Cargos),2), ROUND(SUM(Abonos),2) INTO Var_CargosPoliza, Var_AbonosPoliza
		FROM DETALLEPOLIZA
		WHERE PolizaID = Par_Poliza;

		SET	Var_CargosPoliza	:= IFNULL(Var_CargosPoliza,Decimal_Cero);
		SET	Var_AbonosPoliza	:= IFNULL(Var_AbonosPoliza,Decimal_Cero);

		IF(Var_CargosPoliza > Decimal_Cero OR Var_AbonosPoliza > Decimal_Cero)THEN
			IF(ABS((Var_CargosPoliza - Var_AbonosPoliza)) > LimiteDifPoliza OR (Var_CargosPoliza + Var_AbonosPoliza) = Decimal_Cero)THEN
				SET Par_NumErr 	:= 008;
				SET Par_ErrMen	:= CONCAT("Poliza Descuadrada ",Var_CargosPoliza ,' - ',Var_AbonosPoliza);
				LEAVE ManejoErrores;
			END IF;
		END IF;

        -- Se obtiene el Numero de Cuotas Atrasadas despues de Aplicar los Pagos del Credito
        SELECT IFNULL(COUNT(CreditoID), Entero_Cero)
        INTO Var_CuotasPendientes
        FROM AMORTICREDITO
		WHERE FechaExigible <= Var_FechaOper
		  AND Estatus       <> Est_Pagado
		  AND CreditoID     =  Par_CreditoID;

        -- Se obtiene el Monto Exigible despues de Aplicar los Pagos del Credito
        SET Var_MontoPendiente := (SELECT FUNCIONEXIGIBLE(Par_CreditoID));
		SET Var_MontoPendiente := IFNULL(Var_MontoPendiente,Decimal_Cero);

		-- Se obtiene el valor consecutivo para el registro en la tabla BITACORADOMICIPAGOS
		SET Var_ConsecutivoID := (SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero)+1 FROM BITACORADOMICIPAGOS);

         -- Se obtiene la Fecha Actual
        SET Aud_FechaActual  := NOW();

        -- Se obtiene la Fecha de Proceso
        SET Var_FechaProceso := CONVERT(CONCAT(Var_FechaOper,":",CURRENT_TIME),DATETIME);

        -- Se registra la informacion en la tabla BITACORADOMICIPAGOS
		INSERT INTO BITACORADOMICIPAGOS(
			ConsecutivoID, 			FolioID,				Fecha,					ClienteID,				InstitucionID,			CuentaClabe,
            CreditoID,				MontoAplicado,			MontoNoAplicado,		ClaveDomicilia,			Reprocesado,			InstitNominaID,
            ConvenioNominaID,		Referencia,				Frecuencia,				CuotasPendientes,		MontoPendiente,			EmpresaID,
            Usuario, 				FechaActual,			DireccionIP, 			ProgramaID, 			Sucursal, 				NumTransaccion)
		VALUES(
			Var_ConsecutivoID, 		Par_FolioID,			Var_FechaProceso,		Par_ClienteID,			Par_InstitucionID,		Par_CuentaClabe,
            Par_CreditoID,			Par_MontoAplicado,		Par_MontoPendiente,		Par_ClaveDomicilia,		ConstanteNO,			Var_InstitNominaID,
            Var_ConvenioNominaID,	Var_Referencia,			Var_FrecuenCap,			Var_CuotasPendientes,	Var_MontoPendiente,		Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr      := 0;
		SET Par_ErrMen      := 'Domiciliacion de Pagos Procesada Exitosamente.';
		SET Var_Control		:= 'generar';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Var_ConsecutivoID AS Consecutivo;
	END IF;
END TerminaStore$$
