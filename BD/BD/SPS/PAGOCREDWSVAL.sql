-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDWSVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDWSVAL`;DELIMITER $$

CREATE PROCEDURE `PAGOCREDWSVAL`(
-- =============================================================================================
-- ------ STORE DE VALIDACION PARA REALIZAR EL PAGO DE CREDITO VIA WS PARA SANA TUS FINANZAS ------
-- =============================================================================================
	Par_CreditoID			BIGINT(12),		# ID del Credito a pagar
	Par_Monto				DECIMAL(14,2),	# Monto a pagar
	Par_MontoGL				DECIMAL(14,2),	# Monto de Garantia liquida Adicional (opcional)
    Par_Folio				VARCHAR(20),    # Folio generado por el PDA
    Par_ClaveUsuario    	VARCHAR(100),   # ID del usuario

	Par_Dispositivo			VARCHAR(40),	# Dispositivo del que se genera el movimiento
    Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(400),
	/* Parametros de Auditoria */
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
DECLARE	Var_NumErr			INT;
DECLARE	Var_CharNumErr		VARCHAR(10);
DECLARE Var_ErrMen			VARCHAR(400);
DECLARE Var_CuentaAhoID		BIGINT;
DECLARE Var_StrCueAhoID		VARCHAR(30);
DECLARE Var_MonedaID		INT;
DECLARE Var_Poliza			BIGINT;
DECLARE Var_Consecutivo		BIGINT;
DECLARE Var_SucCliente		INT;
DECLARE	Var_RefereMov		VARCHAR(35);
DECLARE Var_UsuarioID		INT(11);
DECLARE Var_SucursalID		INT(11);
DECLARE Var_CajaID			INT(11);
DECLARE Var_RolFR			INT(11);
DECLARE Var_EstatusUsuario	CHAR(1);
DECLARE Var_MontoPagado		DECIMAL(14,2);
DECLARE Var_TotDeuda		DECIMAL(14,2);
DECLARE Vat_TotalExigible	DECIMAL(14,2);
DECLARE Var_PagCapita		DECIMAL(14,2);
DECLARE Var_PagIntOrd		DECIMAL(14,2);
DECLARE Var_PagIntMora		DECIMAL(14,2);
DECLARE Var_PagIVAIntOrd	DECIMAL(14,2);
DECLARE Var_PagIVAIntMora	DECIMAL(14,2);
DECLARE Var_PagIVATot		DECIMAL(14,2);
DECLARE Var_IVASucurs		DECIMAL(14,4);
DECLARE Var_Promotor        INT(11);
DECLARE Var_EstatusCaja		CHAR(1);
DECLARE Var_CreditoID		BIGINT(12);
DECLARE Var_GrupoID			INT(11);
DECLARE Var_ClienteID		INT(11);
DECLARE Var_DiferenciaPago	DECIMAL(14,2);
DECLARE Var_TipoPrepago		CHAR(1);
DECLARE Var_EstatusCredito	CHAR(1);
DECLARE Var_CuentaAhoGaran	BIGINT(12);
DECLARE Var_EsBloqAuto      CHAR(1);
DECLARE Par_PagoExigible	DECIMAL(14,2);	# Pago Exigible
DECLARE Par_TotalAdeudo		DECIMAL(14,2);	# Total del Adeudo
DECLARE Var_AltaPoliza		CHAR(1);
DECLARE Var_ExigiblePagado	CHAR(1);
DECLARE Var_PermitePrepago	CHAR(1);
DECLARE Var_EsGrupal		CHAR(1);
DECLARE Var_CicloGrupo		INT(11);
DECLARE Var_ProrrateoPago	CHAR(1);
DECLARE Var_MontoPago		DECIMAL(14,2);
DECLARE Var_MontoGLA		DECIMAL(14,2);
DECLARE Var_TotalPago		DECIMAL(14,2);
DECLARE Var_TotalGLA		DECIMAL(14,2);
DECLARE Var_DifPago			DECIMAL(14,2);
DECLARE Var_DifGLA			DECIMAL(14,2);
DECLARE Var_NumIntegrantes	INT;
DECLARE Error_Key       	INT;			# Clave de Error en el ciclo del cursor
DECLARE Var_MensajeExito	VARCHAR(50);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Entero_Uno			INT;
DECLARE Decimal_Cero    	DECIMAL(12, 2);
DECLARE Decimal_Cien    	DECIMAL(12, 2);
DECLARE NO_EsPrePago		CHAR(1);
DECLARE	NO_EsFiniquito		CHAR(1);
DECLARE SI_EsPrePago		CHAR(1);
DECLARE	SI_EsFiniquito		CHAR(1);
DECLARE Par_SalidaNO    	CHAR(1);
DECLARE AltaPoliza_SI   	CHAR(1);
DECLARE AltaPoliza_NO   	CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Tip_MovAhoID		CHAR(4);
DECLARE	Tip_ConceptoCon		INT;
DECLARE Con_AhoCapital  	INT;
DECLARE TipoOperacion		INT(1);
DECLARE NatMovi				INT(1);
DECLARE DenominacionID 		INT(4);
DECLARE Est_Activo			CHAR(1);
DECLARE	Aho_DescriMov		VARCHAR(100);
DECLARE Var_Es_Valido       VARCHAR(10);
DECLARE	ModoPagoEfec 		CHAR(1);
DECLARE DireccionIP			VARCHAR(15);
DECLARE EstatusVigente		CHAR(1);
DECLARE EstatusVencido		CHAR(1);
DECLARE TipoPrepagoUlt		CHAR(1);
DECLARE DescMovDepGarantiaL	VARCHAR(40);
DECLARE BloqueoSi			CHAR(1);
DECLARE BloqueoNO			CHAR(1);
DECLARE NatBloqueo			CHAR(1);
DECLARE TipoBloqueo			INT(11);
DECLARE EstatusApuertura	CHAR(1);
DECLARE ConstanteSI			CHAR(1);
DECLARE ConstanteNO			CHAR(1);
DECLARE Error_SQLEXCEPTION	INT;
DECLARE Error_DUPLICATEKEY	INT;
DECLARE Error_VARUNQUOTED	INT;
DECLARE Error_INVALIDNULL	INT;
DECLARE MensajeExitoCredito VARCHAR(50);
DECLARE MensajeExitoGLA		VARCHAR(50);
DECLARE SalidaSI			CHAR(1);
DECLARE SalidaNO			CHAR(1);
/* Declaracion de cursor para realizar el deposito de la garantia adicional */
DECLARE CURSORDEPGLA CURSOR FOR
    SELECT ClienteID,	CuentaAhoID, MontoGLA, SucursalOrigenCliente
        FROM TMPDEPGLA;

-- Asignacion de Constantes

SET	SalidaNO				:= 'N';				-- No es salida
SET	SalidaSI				:= 'S';				-- Si es salida
SET Cadena_Vacia    		:= '';              -- String Vacio
SET Fecha_Vacia     		:= '1900-01-01';    -- Fecha Vacia
SET Entero_Cero     		:= 0;               -- Entero en Cero
SET Entero_Uno				:= 1;				-- Entero en Uno
SET Decimal_Cero    		:= 0.00;            -- Decimal Cero
SET Decimal_Cien    		:= 100.00;          -- Decimal en Cien
SET	NO_EsPrePago			:= 'N';				-- No es Prepago
SET	NO_EsFiniquito			:= 'N';				-- No es Finiquito
SET	SI_EsPrePago			:= 'S';				-- SI es Prepago
SET	SI_EsFiniquito			:= 'S';				-- SI es Finiquito
SET Par_SalidaNO    		:= 'N';             -- Ejecutar Store sin Regreso o Mensaje de Salida
SET AltaPoliza_SI   		:= 'S';             -- Alta de la Poliza Contable: SI
SET AltaPoliza_NO   		:= 'N';             -- Alta de la Poliza Contable: NO
SET Nat_Abono       		:= 'A';             -- Naturaleza de Abono
SET Tip_MovAhoID			:= '10';			-- Tipo de Movimeinto de Ahorro: Deposito de Efectivo
SET	Tip_ConceptoCon			:=  30;				-- Tipo de Concepto Contable: Pago de Credito en Caja
SET Con_AhoCapital  		:= 	1;              -- Concepto Contable de Ahorro: Pasivo
SET TipoOperacion			:= 	8;				-- ENTRADA EFECTIVO POR PAGO DE CREDITO
SET NatMovi					:= 	1;				-- Naturaleza del Movimiento: Entrada
SET DenominacionID			:= 	7;				-- Denominacion Monedas: 1-Peso
SET Est_Activo				:= 'A';				-- Estatus de Activo
SET Aho_DescriMov			:= 'DEPOSITO PAGO DE CREDITO'; -- Descripcion del Movimiento
SET ModoPagoEfec            := 'E';             -- Modo de Pago: Efectivo
SET DireccionIP 			:= '127.0.0.1';		-- Direccion ip
SET EstatusVigente			:= 'V';				-- Estatus del credito: Vigente
SET EstatusVencido			:= 'B';				-- Estatus del credito: vencido
SET TipoPrepagoUlt			:= 'U';				-- Tipo de Pago de Ultimas Cuotas
SET DescMovDepGarantiaL		:= 'DEPOSITO POR GARANTIA LIQUIDA ADICIONAL';-- Descripcion del movimiento para el deposito de garantia liquida adicional
SET BloqueoSi				:= 'S';				-- Si bloquear
SET BloqueoNO				:= 'N';				-- No bloquear
SET NatBloqueo				:= 'B';				-- Naturaleza Bloqueo
SET TipoBloqueo				:= 10;				-- Corresponde a la tabla TIPOSBLOQUEOS: DEPOSITO POR GARANTIA LIQUIDA ADICIONAL
SET EstatusApuertura		:= 'A';				-- Estatus de la Caja A.- Aperturada
SET ConstanteSI				:= 'S';				-- Constante SI
SET ConstanteNO				:= 'N';				-- Constante NO
SET Error_SQLEXCEPTION		:= 1;				-- Codigo de Error para el SQLSTATE: SQLEXCEPTION.
SET Error_DUPLICATEKEY		:= 2; 				-- Codigo de Error para el SQLSTATE: LLAVE DUPLICADA, COLUMNA NO DEBE SER NULA, COLUMNA AMBIGUA, ETC.
SET Error_VARUNQUOTED		:= 3; 				-- Codigo de Error para el SQLSTATE: VARIABLE SIN COMILLAS, FUNCIONES DE AGREGACION (GROUP BY, SUM, ETC), ETC.
SET Error_INVALIDNULL		:= 4; 				-- Codigo de Error para el SQLSTATE: USO INVALIDO DEL VALOR NULL, ERROR OBTENIDO DESDE EXPRESON REGULAR.
SET MensajeExitoCredito		:= 'El Credito fue Pagado Exitosamente.';-- Mensaje de Exito en caso de que se realice el pago del credito
SET MensajeExitoGLA			:= 'Abono Exitoso a la Garantia Liquida Adicional.';-- Mensaje de Exito en caso de que SOLO se abone a la garantia liquida

-- Asignacion de Variables
SET	Var_NumErr				:= Entero_Cero;
SET	Var_ErrMen				:= Cadena_Vacia;
SET	Var_Poliza				:= Entero_Cero;
SET	Var_Consecutivo			:= Entero_Cero;
SET	Var_TotDeuda 			:= Entero_Cero;
SET Vat_TotalExigible		:= Entero_Cero;
SET	Var_PagCapita 			:= Entero_Cero;
SET	Var_PagIntOrd 			:= Entero_Cero;
SET	Var_PagIntMora 			:= Entero_Cero;
SET	Var_PagIVAIntOrd 		:= Entero_Cero;
SET	Var_PagIVAIntMora 		:= Entero_Cero;
SET Var_ExigiblePagado		:= ConstanteNO;

SELECT	UsuarioID, 		DireccionIP,		Entero_Uno,		SucursalUsuario
INTO	Aud_Usuario,	Aud_DireccionIP,	Par_EmpresaID,	Aud_Sucursal
	FROM USUARIOS
		WHERE	Clave 		= Par_ClaveUsuario
			AND Estatus		= Est_Activo;

SELECT 	Cre.CreditoID, 		Cre.GrupoID, 		Cre.Estatus, 		Cre.CicloGrupo,
		p.TipoPrepago, 		p.PermitePrepago, 	p.EsGrupal,			p.ProrrateoPago
INTO 	Var_CreditoID, 		Var_GrupoID, 		Var_EstatusCredito,	Var_CicloGrupo,
		Var_TipoPrepago,	Var_PermitePrepago,	Var_EsGrupal,		Var_ProrrateoPago
	FROM CREDITOS Cre, PRODUCTOSCREDITO p
		WHERE Cre.ProductoCreditoID	= p.ProducCreditoID
			AND Cre.CreditoID		= Par_CreditoID;

SELECT FechaSistema INTO Aud_FechaActual
	FROM PARAMETROSSIS;

/* ***** TOTALES DE CREDITO INDIVIDUAL ***** */
IF(IFNULL(Var_EsGrupal,ConstanteNO)=ConstanteNO OR IFNULL(Var_ProrrateoPago,ConstanteNO)=ConstanteNO)THEN
	SET	Par_TotalAdeudo 	:= FUNCIONCONFINIQCRE(Par_CreditoID);
	SET Par_PagoExigible 	:= FUNCIONEXIGIBLE(Par_CreditoID);
END IF;

/* ***** TOTALES DE CREDITO GRUPAL ***** */
IF(IFNULL(Var_EsGrupal,ConstanteNO)=ConstanteSI AND IFNULL(Var_ProrrateoPago,ConstanteNO)=ConstanteSI)THEN
	SET	Par_TotalAdeudo 	:= FUNCIONCONFINIQGPO(Par_CreditoID);
	SET Par_PagoExigible 	:= FUNCIONEXIGIBLEGPO(Par_CreditoID);
END IF;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Var_NumErr := 999;
				SET Var_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDWSVAL');
			END;

	IF(IFNULL(Par_CreditoID,Entero_Cero))= Entero_Cero THEN
		SET Var_NumErr := 01;
		SET Var_ErrMen := 'El Numero de Credito esta vaci­o.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Monto,Decimal_Cero) <= Decimal_Cero )THEN
		SET Var_NumErr := 02;
		SET Var_ErrMen := 'El Monto debe de ser mayor a 0.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Folio,Cadena_Vacia))= Cadena_Vacia THEN
		SET Var_NumErr := 03;
		SET Var_ErrMen := 'El Folio PDA esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ClaveUsuario,Cadena_Vacia))= Cadena_Vacia THEN
		SET Var_NumErr := 04;
		SET Var_ErrMen := 'La Clave del Usuario esta vacia.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Dispositivo,Cadena_Vacia))= Cadena_Vacia THEN
		SET Var_NumErr := 05;
		SET Var_ErrMen := 'El Dispositivo esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_CreditoID,Entero_Cero))= Entero_Cero THEN
		SET Var_NumErr := 06;
		SET Var_ErrMen := 'El Credito no existe.';
		LEAVE ManejoErrores;
	END IF;

	IF((IFNULL(Var_EstatusCredito,Cadena_Vacia))= Cadena_Vacia) OR (Var_EstatusCredito != EstatusVigente
		AND Var_EstatusCredito != EstatusVencido) THEN
		SET Var_NumErr := 07;
		SET Var_ErrMen := 'El Credito no se puede pagar. Estatus del Credito Incorrecto.';
		LEAVE ManejoErrores;
	END IF;

    IF NOT EXISTS(SELECT U.RolID
						FROM USUARIOS U,
							 PARAMETROSCAJA P
						WHERE U.Clave = Par_ClaveUsuario
							AND U.RolID = P.EjecutivoFR
							AND U.Estatus = Est_Activo
						LIMIT 1)THEN
		SET Var_NumErr := 09;
		SET Var_ErrMen := 'El Usuario Indicado no puede realizar operaciones. Rol Invalido.';
		LEAVE ManejoErrores;
	END IF;

	SELECT	Caj.CajaID,	Caj.EstatusOpera,	Usu.Estatus
	INTO	Var_CajaID, Var_EstatusCaja,	Var_EstatusUsuario
		FROM USUARIOS Usu,
			 PARAMETROSCAJA Par,
			 CAJASVENTANILLA Caj
		WHERE Usu.Clave			= Par_ClaveUsuario
			AND Usu.UsuarioID	= Caj.UsuarioID;

	IF(IFNULL(Var_CajaID,Entero_Cero))= Entero_Cero THEN
		SET Var_NumErr := 10;
		SET Var_ErrMen := 'El Usuario no tiene una Caja Asignada.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_EstatusCaja,Cadena_Vacia))= Cadena_Vacia OR (Var_EstatusCaja!=EstatusApuertura) THEN
		SET Var_NumErr := 11;
		SET Var_ErrMen := 'La Caja No se encuentra Aperturada.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PagoExigible,Decimal_Cero) <= Decimal_Cero )THEN
		-- si el pago exigible esta en cero, quiere decir que ya se ha pagado
		SET Var_ExigiblePagado		:= ConstanteSI;
	END IF;

	IF(IFNULL(Par_TotalAdeudo,Decimal_Cero) <= Decimal_Cero )THEN
		SET Var_NumErr := 13;
		SET Var_ErrMen := 'El Monto del Adeudo Total debe ser Mayor a 0.';
		LEAVE ManejoErrores;
	END IF;

	SELECT 	Cre.CuentaID, 		Cli.ClienteID,	Cre.MonedaID, Cli.SucursalOrigen
    INTO 	Var_CuentaAhoID, 	Var_ClienteID,	Var_MonedaID, Var_SucCliente
		FROM CREDITOS Cre,
			 CLIENTES Cli
			WHERE Cre.CreditoID = Par_CreditoID
			  AND Cre.ClienteID = Cli.ClienteID;

	SET Aud_ProgramaID			:= UPPER(CONCAT(Par_Folio, ' ', Par_Dispositivo));

/* Valida que el Usuario sea el Promotor de la Cuenta el que realiza el Abono*/
	SET	Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID, Entero_Cero);
	SET	Var_MonedaID	:= IFNULL(Var_MonedaID, Entero_Cero);

	SET	Var_RefereMov	:= CONVERT(Par_CreditoID, CHAR);
	SET	Var_StrCueAhoID	:= CONVERT(Var_CuentaAhoID, CHAR);

	SELECT Suc.IVA INTO Var_IVASucurs
		FROM SUCURSALES Suc
			WHERE Suc.SucursalID = Var_SucCliente;

	SET	Var_IVASucurs	:= IFNULL(Var_IVASucurs, Entero_Cero);

	-- Complemento Contable
	SELECT 	Usu.SucursalUsuario, 	CajaID
    INTO 	Var_SucursalID, 		Var_CajaID
		FROM CAJASVENTANILLA Ven,
			 USUARIOS Usu
			WHERE Ven.UsuarioID = Usu.UsuarioID
			  AND Ven.Estatus = Est_Activo
			  AND Usu.Clave = Par_ClaveUsuario
			LIMIT 1;

	SET	Var_SucursalID	:= IFNULL(Var_SucursalID, Entero_Cero);
	SET	Var_CajaID		:= IFNULL(Var_CajaID, Entero_Cero);

	-- Aplica solo para el encabezado de la poliza
    IF(IFNULL(Var_Poliza,Entero_Cero)=Entero_Cero)THEN
		SET Var_AltaPoliza	:= AltaPoliza_SI;
	ELSE
		IF(IFNULL(Var_Poliza,Entero_Cero)>Entero_Cero)THEN
			SET Var_AltaPoliza	:= AltaPoliza_NO;
		END IF;
    END IF;

    -- SI el monto ingresado es MAYOR al pago exigible Y sea MENOR al total adeudo
	-- Y el pago exigible se encuentre pagado, entonces se calcula la diferencia del pago
    IF((Par_Monto>Par_PagoExigible)AND(Par_Monto<Par_TotalAdeudo)AND(Var_ExigiblePagado=ConstanteSI))THEN
		-- Se calcula la diferencia para poder realizar el abono de la garantia liq. adicional
		SET Var_DiferenciaPago := Par_Monto-Par_PagoExigible;
        -- Si la diferencia es mayor a cero
		IF(IFNULL(Var_DiferenciaPago,Decimal_Cero)>Decimal_Cero) THEN
			-- Si el prod. de credito NO permite prepagos
			IF(IFNULL(Var_PermitePrepago,ConstanteNO)=ConstanteNO)THEN
				-- Entonces la cantidad del Pago Exigible es el monto a abonar a la cuenta de ahorro
				-- y la diferencia se sumara al monto de la garantia liq. adicional
				SET Par_Monto	:= Par_PagoExigible;
				SET Par_MontoGL	:= IFNULL(Par_MontoGL,Decimal_Cero) + Var_DiferenciaPago;
			END IF;
		END IF;
	END IF;



-- =============================================================================================
-- ---------- INICIO DEL PROCESO PAGO DE CREDITO DEPENDIENDO DE LA CANTIDAD DEL MONTO ----------
-- =============================================================================================
	-- Aplica solo para el encabezado de la poliza
	IF(IFNULL(Var_Poliza,Entero_Cero)=Entero_Cero)THEN
		SET Var_AltaPoliza	:= AltaPoliza_SI;
	ELSE
		IF(IFNULL(Var_Poliza,Entero_Cero)>Entero_Cero)THEN
			SET Var_AltaPoliza	:= AltaPoliza_NO;
		END IF;
	END IF;
	-- si el monto ingresado es menor o igual al pago exigible y
	-- el pago exigible no esta pagado, entonces hace el abono a la cuota exigible
	IF(Par_Monto<=Par_PagoExigible AND Var_ExigiblePagado=ConstanteNO) THEN
	-- Procedimiento del Pago del Credito "ordinario"
		-- SI el monto ingresado es MAYOR al pago exigible Y sea MENOR al total adeudo y
		-- y el pago exigible se encuentra pagado, entonces hace el abono a la cuota exigible y/o prepago
		IF((Par_Monto>Par_PagoExigible)AND(Par_Monto<Par_TotalAdeudo))THEN
			-- Se calcula la diferencia para poder realizar el prepago
			SET Var_DiferenciaPago := Par_Monto-Par_PagoExigible;
			-- Procedimiento del Pago del Credito "ordinario"

			IF((IFNULL(Var_DiferenciaPago,Decimal_Cero)>Decimal_Cero)) THEN-- si es exito Y la diferencia es mayor a cero
			-- Procedimiento del Pago del Credito "prepago" con la difrencia antes calculada
				IF(IFNULL(Var_PermitePrepago,ConstanteNO)=ConstanteSI)THEN
					/* *** PAGO DE CREDITO INDIVIDUAL *** */
					-- Si el producto de credito NO permite prepago, entonces se suma
					-- la diferencia al monto de la garantia adicional
					IF(IFNULL(Var_PermitePrepago,ConstanteNO)=ConstanteNO)THEN
						SET Par_MontoGL := IFNULL(Par_MontoGL,Decimal_Cero) + Var_DiferenciaPago;
					END IF;
				END IF;
			END IF;
		ELSE -- Si no, se comprueba que el monto a pagar sea igual al total del adeudo
			IF(Par_Monto=Par_TotalAdeudo)THEN
			-- Procedimiento del Pago del Credito "finiquito"
				/* *** PAGO DE CREDITO INDIVIDUAL *** */
				IF(Par_Monto>Par_TotalAdeudo)THEN
					SET Var_NumErr := 26;
					SET Var_ErrMen := 'El Monto No debe ser Mayor al Monto del Adeudo Total.';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;
    END IF;

-- =============================================================================================
-- ------------------------- FIN DEL PROCESO DEL PAGO DE CREDITO -------------------------------
-- =============================================================================================

-- =============================================================================================
-- ------------------------ INICIO DEPOSITO DE GARATIA LIQUIDA ADICIONAL -----------------------
-- =============================================================================================
	IF (IFNULL(Par_MontoGL,Decimal_Cero)>Decimal_Cero)THEN

        DROP TABLE IF EXISTS TMPDEPGLA;
		CREATE TEMPORARY TABLE TMPDEPGLA (
			ClienteID 				INT(11),
			CreditoID 				BIGINT(12),
			CuentaAhoID				BIGINT(12),
			MontoGLA				DECIMAL(14,2),
			SucursalOrigenCliente	INT(11)
		);
		CREATE INDEX TMPDEPGLA_IDX1 ON TMPDEPGLA (ClienteID, CreditoID);

		-- Si es grupal y si si prorratea, se obtienen los integrantes del grupo
		IF(IFNULL(Var_EsGrupal,ConstanteNO)=ConstanteSI AND IFNULL(Var_ProrrateoPago,ConstanteNO)=ConstanteSI)THEN
			INSERT INTO TMPDEPGLA (
					ClienteID,		CreditoID,		SucursalOrigenCliente)
			SELECT 	Cli.ClienteID,	Cre.CreditoID,	Cli.SucursalOrigen
			FROM CLIENTES Cli INNER JOIN CREDITOS Cre ON Cli.ClienteID = Cre.ClienteID
				INNER JOIN GRUPOSCREDITO Gpo ON Cre.GrupoID = Gpo.GrupoID
				WHERE Gpo.GrupoID 		= Var_GrupoID
	            	AND Cre.CicloGrupo	= Var_CicloGrupo;
		ELSE -- Se trata como credito individual o es credito individual
			INSERT INTO TMPDEPGLA (
					ClienteID,		CreditoID,		SucursalOrigenCliente)
			SELECT 	Cli.ClienteID,	Cre.CreditoID,	Cli.SucursalOrigen
			FROM CREDITOS Cre,
				 CLIENTES Cli
				WHERE Cre.CreditoID = Par_CreditoID
				  AND Cli.ClienteID = Var_ClienteID;
		END IF;

		-- Se actualizan CUENTAS PARA DEPOSITO DE LA GARATIA LIQUIDA ADICIONAL
		UPDATE TMPDEPGLA tmp, CUENTASAHO Cta, PARAMETROSSIS Par
			SET tmp.CuentaAhoID = Cta.CuentaAhoID
				WHERE  Cta.ClienteID 		= tmp.ClienteID
					AND Cta.TipoCuentaID 	= Par.TipoCtaGLAdi
					AND Estatus 			= Est_Activo;

		-- Se obtienten el numero de integrantes y se dividen los montos en partes iguales
		SELECT COUNT(ClienteID) INTO Var_NumIntegrantes
			FROM TMPDEPGLA;

		SET Var_MontoGLA 	:= ROUND((Par_MontoGL / Var_NumIntegrantes),2);

		UPDATE TMPDEPGLA
			SET MontoGLA = Var_MontoGLA;

		-- Se obtinen el total de los montos guardados
		SELECT 	SUM(MontoGLA) INTO Var_TotalGLA
			FROM TMPDEPGLA;

		SET Var_DifGLA	:= Par_MontoGL - Var_TotalGLA;

		-- En caso de que la diferencia sea mayor a cero, se le suma esa
		-- diferencia al cliente que esta pagando para que las cantidades sean las mismas
		-- (no se pierda dinero)

		IF(IFNULL(Var_DifGLA,Decimal_Cero)!=Decimal_Cero)THEN
			UPDATE TMPDEPGLA
			SET MontoGLA = MontoGLA + Var_DifGLA
				WHERE ClienteID = Var_ClienteID;
		END IF;

		OPEN CURSORDEPGLA;
		    BEGIN
		        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		        CICLOGLA:LOOP

					FETCH CURSORDEPGLA  INTO
						Var_ClienteID,	Var_CuentaAhoGaran, Var_MontoGLA, Var_SucCliente;

					BEGIN
						-- Inicalizacion
						SET Error_Key   	:= Entero_Cero;

						IF(IFNULL(Var_CuentaAhoGaran,Entero_Cero))= Entero_Cero THEN
							SET Var_NumErr := 25;
							SET Var_ErrMen := 'La Cuenta para Depositar la Garantia Li­quida Adicional esta vaci­a.';
							LEAVE CICLOGLA;
						END IF;

					END; -- END START TRANSACTION

		        END LOOP CICLOGLA;
		    END; -- END OPEN CURSORDEPGLA
		CLOSE CURSORDEPGLA;

		IF(Var_NumErr != Entero_Cero)THEN
		    LEAVE ManejoErrores;
		END IF;

		DROP TABLE IF EXISTS TMPDEPGLA;
    END IF;



END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen;
END IF;

 IF (Par_Salida = SalidaNO) THEN
    SET  Par_NumErr := Var_NumErr;
	SET  Par_ErrMen := Var_ErrMen;
END IF;


END TerminaStore$$