-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEFACTPROVALTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEFACTPROVALTPRO`;

DELIMITER $$
CREATE PROCEDURE `DETALLEFACTPROVALTPRO`(
	# =====================================================================================
	# SP PARA ALTA DE DETALLE DE FACTURA DE LA CARGA MASIVA
	# =====================================================================================
    Par_ProveedorID         INT(11),			-- PROVEDOR
    Par_NoFactura           VARCHAR(20),		-- NUMERO DE FACTURA
    Par_CentroCostoID       INT(11),			-- CENTRO DE COSTOS
    Par_CenCostoManualID    INT(11),			-- CENTRO DE CONSTOS MANUAL
    Par_TipoGasto           INT(11),			-- TIPO DE GASTO

    Par_Cantidad            DECIMAL(13,2),		-- CANTIDAD
    Par_PrecioUnit          DECIMAL(13,2),		-- PRECIO UNITARIO
    Par_Importe             DECIMAL(13,2),		-- IMPORTE
    Par_Descripc            VARCHAR(50),		-- DESCRIPCION
    Par_Gravable            CHAR(1),			-- GRAVABLE

    Par_GravaCero           CHAR(1),			-- GRAVA EN CERO
    Par_Fecha               DATETIME,			-- FECHA
    Par_Poliza              BIGINT(20),			-- POLIZA
    Par_ProrrateaImp        CHAR(1),            -- INDICA SI  SE PORRATEAN LOS IMPUESTOS SI O NO
    Par_PagoAnticipado      CHAR(1),            -- INDICA SI LA FACTURA PAGA POR ANTICIPADO

    Par_TipoPagoAnt         INT(11),            -- TIPO DE PAGO ANTICIPADO CAT: TIPOPAGOPROV
    Par_EmpleadoID          INT(11),            -- NUMERO DE EMPLEADO DEL PAGO ANICIPADO
    Par_CenCostoAntID       INT(11),            -- CENTRO DE COSTOS DEL PAGO ANTICIPADO
    Par_GeneraConta         CHAR(1),			-- GENERA CONTABILIDAD S.-SI N.-NO
	Par_OrigenProceso		VARCHAR(10),		-- ORIGEN DE REGISTRO DE FACTURA FM.-CARGA MASIVA FP.-PANTALLA DE FACTURA DE PROVEEDOR

    Par_Salida              CHAR(1),			-- SALIDA
    INOUT Par_NumErr        INT(11),			-- NUMERO DE ERROR
    INOUT Par_ErrMen        VARCHAR(400),		-- MENSAJE DE ERROR

    Par_EmpresaID           INT(11),			-- AUDITORIA
    Aud_Usuario             INT(11),			-- AUDITORIA
    Aud_FechaActual         DATETIME,			-- AUDITORIA
    Aud_DireccionIP         VARCHAR(15),		-- AUDITORIA
    Aud_ProgramaID          VARCHAR(50),		-- AUDITORIA
    Aud_Sucursal            INT(11),			-- AUDITORIA
    Aud_NumTransaccion      BIGINT(20)			-- AUDITORIA
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE NumPartida          INT;
	DECLARE var_CentroCostos    INT(11);
	DECLARE Var_Poliza          BIGINT;
	DECLARE Var_CuentaContable  VARCHAR(20);
	DECLARE Var_Control         VARCHAR(100);

	DECLARE Var_CueGasto        CHAR(25);
	DECLARE Mon_Base            INT(11);
	DECLARE Var_Instrumento     VARCHAR(15);
	DECLARE Var_Referencia      VARCHAR(50);
	DECLARE Var_RFC             VARCHAR(30);

	DECLARE Var_FolioUUID       VARCHAR(100);
	DECLARE Var_NatConta        CHAR(2);
	DECLARE Var_RepresentaActivo CHAR(1);
	DECLARE Var_TipoActivoID	INT(11);
	DECLARE Var_ActivoID		INT(11);

    DECLARE Var_TiempoAmortiMeses	INT(11);			-- Tiempo Amortizar en Meses

	-- Declaracion de constantes
	DECLARE Entero_Cero         INT(11);
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE SalidaNO            CHAR(1);

	DECLARE SalidaSI            CHAR(1);
	DECLARE Tipo_RegFact        CHAR(1);
	DECLARE Tipo_PagAntFact     CHAR(1);
	DECLARE Sin_Error           INT(11);
	DECLARE Con_ProrrateaImpSI  CHAR(1);

	DECLARE Con_ProrrateaImpNO  CHAR(1);
	DECLARE AltaPoliza_NO       CHAR(1);
	DECLARE Con_PagoAntSI       CHAR(1);
	DECLARE Con_PagoAntNO       CHAR(1);
	DECLARE Nat_Cargo           CHAR(1);

	DECLARE Nat_Abono           CHAR(1);
	DECLARE Con_IngFactura      INT(11);
	DECLARE Des_IngrFactura     VARCHAR(100);
	DECLARE Con_PagAntFact      INT(11);
	DECLARE Des_PagoAntFact     VARCHAR(100);

	DECLARE Cuenta_Vacia        VARCHAR(15);
	DECLARE Par_PagoAntNO       CHAR(1);
    DECLARE Est_Vigente			CHAR(2);
    DECLARE ActivoAutomatico	CHAR(1);
    DECLARE Cons_Si				CHAR(1);
    DECLARE Est_Activos			CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero         := 0;
	SET Decimal_Cero        := 0.0;
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET SalidaNO            := 'N';

	SET SalidaSI            := 'S';
	SET Tipo_RegFact        := 'R';
	SET Tipo_PagAntFact     := 'G';
	SET Sin_Error           := 0;
	SET Con_ProrrateaImpSI  :='S';

	SET Con_ProrrateaImpNO  :='N';
	SET AltaPoliza_NO       := 'N';
	SET Con_PagoAntSI       := 'S';
	SET Con_PagoAntNO       := 'N';
	SET Nat_Cargo           := 'C';         -- Naturaleza del Movimiento: Cargo

	SET Nat_Abono           := 'A';         -- Naturaleza del Movimiento: Abono
	SET Con_IngFactura      := 71;          -- Concepto Contable: Ingreso de Factura
	SET Des_IngrFactura     := 'REGISTRO DE FACTURA';    -- Descripcion del Movimiento: Ingreso de Fact
	SET Con_PagAntFact      := 85;          -- Concepto Contable: Pago Anticipado de Factura
	SET Des_PagoAntFact     := 'PAGO ANTICIPADO DE FACTURA'; -- Descripcion del Movimiento: Pago Anticipado de Factura

	SET Cuenta_Vacia        := '000000000000000';        -- Cuenta Contable Vacia
	SET Par_PagoAntNO       := 'N';
    SET Est_Vigente			:= 'VI';
    SET ActivoAutomatico	:= 'A';
    SET Cons_Si				:= 'S';
    SET Est_Activos			:= 'A';

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DETALLEFACTPROVALTPRO');
					SET Var_Control = 'SQLEXCEPTION' ;

		END;

	IF(IFNULL(Par_NoFactura, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'La Factura esta vacia.';
		SET Var_Control := 'proveedorID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia THEN
        SET Par_NumErr := 002;
		SET Par_ErrMen := 'La Fecha no puede ser vacia.';
		SET Var_Control := 'proveedorID';
		LEAVE ManejoErrores;
	END IF;

	SET Par_Importe := IFNULL(Par_Importe,Entero_Cero);

	IF(Par_Importe <= Entero_Cero) THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'El Importe del Detalle Debe ser Mayor a Cero.';
		SET Var_Control := 'proveedorID';
		LEAVE ManejoErrores;
	END IF;

    SELECT CentroCostoID INTO var_CentroCostos
            FROM CENTROCOSTOS
                WHERE CentroCostoID=Par_CentroCostoID;

    SET var_CentroCostos :=IFNULL(var_CentroCostos,Entero_Cero );

    IF (IFNULL(var_CentroCostos,Entero_Cero) = Entero_Cero )THEN
        SET Par_NumErr := 004;
		SET Par_ErrMen := CONCAT("El Centro de Costos ",Par_CentroCostoID, " no Existe.") ;
		SET Var_Control := 'proveedorID';
		LEAVE ManejoErrores;
	END IF;


	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	SET NumPartida := (SELECT IFNULL(MAX(NoPartidaID),Entero_Cero) + 1
                    FROM DETALLEFACTPROV
                    WHERE ProveedorID   = Par_ProveedorID
                      AND NoFactura     = Par_NoFactura);

    /*************************************************************************************************************
	-- 									INICIO DE NO GENERA CONTABLIDAD											--
	**************************************************************************************************************/
	INSERT INTO DETALLEFACTPROV (
					ProveedorID,        NoFactura,          NoPartidaID,    CentroCostoID,  TipoGastoID,
					Cantidad,           PrecioUnitario,     Importe,        Descripcion,    Gravable,
					GravaCero,          EmpresaID,          Usuario,        FechaActual,    DireccionIP,
					ProgramaID,         Sucursal,           NumTransaccion)
		VALUES (	Par_ProveedorID,    Par_NoFactura,      NumPartida,         Par_CentroCostoID,  Par_TipoGasto,
					Par_Cantidad,       Par_PrecioUnit,     Par_Importe,        Par_Descripc,       Par_Gravable,
					Par_GravaCero,      Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
				);

    /*************************************************************************************************************
	-- 									INICIO DE SI GENERA CONTABLIDAD											--
	**************************************************************************************************************/
    IF(Par_GeneraConta = "S")THEN
		/* Seleccion de las Cuentas Contables */
		SELECT CuentaCompleta INTO Var_CueGasto
			FROM TESOCATTIPGAS
			WHERE TipoGastoID = Par_TipoGasto;

		SET Var_CueGasto = IFNULL(Var_CueGasto, Cuenta_Vacia);

			-- ALTA DE ACTIVO APARTIR DEL TIPO DE GASTO
			SELECT RepresentaActivo,	TipoActivoID
				INTO Var_RepresentaActivo,	Var_TipoActivoID
			FROM TESOCATTIPGAS
			WHERE TipoGastoID = Par_TipoGasto
				AND Estatus = Est_Activos;

		IF(Var_RepresentaActivo = Cons_Si)THEN

			SET Var_TiempoAmortiMeses := (SELECT TiempoAmortiMeses FROM TIPOSACTIVOS WHERE TipoActivoID = Var_TipoActivoID);

			CALL ACTIVOSALT(
				Var_TipoActivoID,	CONCAT('CANT. ',Par_Cantidad,'-',Par_Descripc),			Par_Fecha,		Par_ProveedorID,	Par_NoFactura,
				Cadena_Vacia,		Par_Importe,		Entero_Cero,	Par_Importe,		Var_TiempoAmortiMeses,
				Par_Poliza,			Par_CentroCostoID,	Var_CueGasto,	Var_CueGasto,		Est_Vigente,
				ActivoAutomatico,	Aud_Sucursal,		Decimal_Cero,	Decimal_Cero,		Decimal_Cero,
				Par_Fecha,			Var_ActivoID,
				SalidaNO,    		Par_NumErr, 		Par_ErrMen, 	Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;


		SELECT FolioUUID INTO Var_FolioUUID FROM FACTURAPROV WHERE ProveedorID=Par_ProveedorID AND NoFactura = Par_NoFactura;
		SELECT CASE TipoPersona WHEN 'M' THEN IFNULL(RFCpm,Cadena_Vacia) ELSE IFNULL(RFC,Cadena_Vacia) END
			INTO Var_RFC
		FROM PROVEEDORES
		WHERE ProveedorID = Par_ProveedorID;

		SET Var_RFC:= IFNULL(Var_RFC,Cadena_Vacia);

		SET Var_NatConta := Nat_Cargo;

		CALL CONTAFACTURAPRO(
			Par_ProveedorID,        Par_NoFactura,          Tipo_RegFact,           Par_PagoAntNO,          AltaPoliza_NO,
			Par_Poliza,             Par_Fecha,              Par_Importe,            Par_CenCostoManualID,   Par_CentroCostoID,
			Var_CueGasto,           Par_EmpleadoID,         Var_RFC,                Var_FolioUUID,          Var_NatConta,
			Con_IngFactura,         Par_Descripc,        	Entero_Cero,            Par_Salida,             Par_NumErr,
			Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
			Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

	IF(Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;
    SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Detalle de Factura Agregado.');
	SET Var_Control := 'facturaProvID';

	END IF;

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen,
           Var_Control AS control,
		   Par_NoFactura AS consecutivo;
END IF;
END TerminaStore$$