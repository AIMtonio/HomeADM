-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEFACTPROVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEFACTPROVALT`;

DELIMITER $$
CREATE PROCEDURE `DETALLEFACTPROVALT`(
	# =====================================================================================
	# ------- STORED PARA ALTA DE DETALLE DE FACTURA ---------
	# =====================================================================================
    Par_ProveedorID         INT(11),
    Par_NoFactura           VARCHAR(20),
    Par_CentroCostoID       INT(11),
    Par_CenCostoManualID    INT(11),
    Par_TipoGasto           INT(11),

    Par_Cantidad            DECIMAL(13,2),
    Par_PrecioUnit          DECIMAL(13,2),
    Par_Importe             DECIMAL(13,2),
    Par_Descripc            VARCHAR(50),
    Par_Gravable            CHAR(1),

    Par_GravaCero           CHAR(1),
    Par_Fecha               DATETIME,
    Par_Poliza              BIGINT(20),
    Par_ProrrateaImp        CHAR(1),                -- Indica si se prorratean los impuestos SI o NO
    Par_PagoAnticipado      CHAR(1),                -- Indica si la Factura es Pagada por Anticipado

    Par_TipoPagoAnt         INT(11),                -- Tipo de Pago Anticipado: TIPOPAGOPROV
    Par_EmpleadoID          INT(11),                -- numero de empleado del pago anticipado
    Par_CenCostoAntID       INT(11),                -- CC del Pago Anticipado

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
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
									'esto le ocasiona. Ref: SP-DETALLEFACTPROVALT');
					SET Var_Control = 'SQLEXCEPTION' ;

		END;

	IF(IFNULL(Par_NoFactura, Cadena_Vacia)) = Cadena_Vacia THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '001' AS NumErr,
				'La Factura esta vacia.' AS ErrMen,
				'noFactura' AS control,
				Entero_Cero AS consecutivo;
			LEAVE TerminaStore;
		END IF;
		IF(Par_Salida =SalidaNO) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'La Factura esta vacia.';
		END IF;
	END IF;

	IF(IFNULL(Par_Fecha, Fecha_Vacia)) = Fecha_Vacia THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '002' AS NumErr,
				'La Fecha no puede ser vacia.' AS ErrMen,
				'noFactura' AS control,
				Entero_Cero AS consecutivo;
			LEAVE TerminaStore;
		END IF;
		IF(Par_Salida =SalidaNO) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'La Fecha no puede ser vacia.';
		END IF;
	END IF;

	SET Par_Importe := IFNULL(Par_Importe,Entero_Cero);

	IF(Par_Importe <= Entero_Cero) THEN
		IF(Par_Salida = SalidaSI) THEN
			SELECT '003' AS NumErr,
				'El Importe del Detalle Debe ser Mayor a Cero.' AS ErrMen,
				'totalFactura' AS control,
				Entero_Cero AS consecutivo;
			LEAVE TerminaStore;
		END IF;
		IF(Par_Salida =SalidaNO) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El Importe del Detalle Debe ser Mayor a Cero.';
		END IF;
	END IF;

    SELECT CentroCostoID INTO var_CentroCostos
            FROM CENTROCOSTOS
                WHERE CentroCostoID=Par_CentroCostoID;

    SET var_CentroCostos :=IFNULL(var_CentroCostos,Entero_Cero );

    IF (IFNULL(var_CentroCostos,Entero_Cero) = Entero_Cero )THEN
        IF(Par_Salida = SalidaSI) THEN
            SELECT '004' AS NumErr,
                 CONCAT("El Centro de Costos ",Par_CentroCostoID, " no Existe.") AS ErrMen,
                 'centroCostoID' AS control,
                  Entero_Cero AS consecutivo;
        ELSE
            SET Par_NumErr := 4;
            SET Par_ErrMen := CONCAT("El Centro de Costos ",Par_CentroCostoID, " no Existe.") ;
		END IF;
		LEAVE TerminaStore;
	END IF;


	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	SET NumPartida := (SELECT IFNULL(MAX(NoPartidaID),Entero_Cero) + 1
                    FROM DETALLEFACTPROV
                    WHERE ProveedorID   = Par_ProveedorID
                      AND NoFactura     = Par_NoFactura);

	INSERT INTO DETALLEFACTPROV (
		ProveedorID,        NoFactura,          NoPartidaID,    CentroCostoID,  TipoGastoID,
		Cantidad,           PrecioUnitario,     Importe,        Descripcion,    Gravable,
		GravaCero,          EmpresaID,          Usuario,        FechaActual,    DireccionIP,
		ProgramaID,         Sucursal,           NumTransaccion)
		VALUES (
		Par_ProveedorID,    Par_NoFactura,      NumPartida,         Par_CentroCostoID,  Par_TipoGasto,
		Par_Cantidad,       Par_PrecioUnit,     Par_Importe,        Par_Descripc,       Par_Gravable,
		Par_GravaCero,      Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
	);

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



END ManejoErrores;

IF (Par_NumErr != Sin_Error) THEN
    IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen  AS ErrMen,
                'proveedorID' AS control,
                Entero_Cero AS consecutivo;
    END IF;
    LEAVE TerminaStore;
END IF;

IF(Par_Salida = SalidaSI) THEN
    SELECT '000' AS NumErr,
            'Detalle de Factura Agregado.' AS ErrMen,
            'facturaProvID' AS control,
            Par_NoFactura AS consecutivo;
END IF;

IF(Par_Salida = SalidaNO) THEN
    SET Par_NumErr := 0;
    SET Par_ErrMen := Par_NoFactura;
END IF;

END TerminaStore$$