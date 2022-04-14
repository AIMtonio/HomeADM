-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURAPROVALTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURAPROVALTPRO`;
DELIMITER $$


CREATE PROCEDURE `FACTURAPROVALTPRO`(
-- ---------------------------------------------------------------------------------
-- SP PARA DAR DE ALTA LAS FACTURAS DE LA CARGA MASIVA
-- ---------------------------------------------------------------------------------
    Par_ProveedorID         INT(11),			-- PROVEEDOR
    Par_NoFactura           VARCHAR(20),		-- NUMERO DE FACTURA
    Par_FechFactura         DATETIME,			-- FECHA DE LA FACTURA
    Par_Estatus             CHAR(1),			-- ESTATUS DE LA FACTURA A.-ALTA C.-CANCELADA P.-PARCIALMENTE PAGADA L.-LIQUIDADA V.-VENCIDA R.-EN PROCESO DE REQUISICION I.-IMPORTADA/GUARDADA
    Par_CondicPago          INT(11),			-- CONDICION DE PAGO

    Par_FechProgPag         DATETIME,			-- FECHA DE PROXIMO PAGO
    Par_FechaVenc           DATETIME,			-- FECHA DE VENCIMIENTO
    Par_SaldoFact           DECIMAL(13,2),		-- SALDO DE LA FACTURA
    Par_TotalGrava          DECIMAL(13,2),		-- TOTAL GRAVA
    Par_TotalFact           DECIMAL(13,2),		-- TOTAL DE LA FACTURA

    Par_SubTotal            DECIMAL(13,2),		-- SUBTOTAL
    Par_PagoAnticipado      CHAR(1),			-- PAGO ANTICIPADO
    Par_TipoPagoAnt         CHAR(1),			-- TIPO DE PAGO ANTICIPADO
    Par_EmpleadoID          INT(11),			-- EMPLEADO
    Par_CenCostoAntID       INT(11),			-- CENTRO DE COSTOS ANTICIPADO

    Par_CenCostoManualID    INT(11),			-- CENTRO DE COSTOS MANUAL
    Par_ProrrateaImp        CHAR(1),			-- PRORRATEA IMPUESTOS
    Par_RutaImgFac          VARCHAR(150),		-- RUTA IMAGEN DE FACTURA
    Par_RutaXMLFac          VARCHAR(150),		-- RUTA DE ARCHIVO XML DE LA FACTURA
    Par_FolioUUID           VARCHAR(100),		-- FOLIO UUID

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
    Aud_Sucursal            INT(2),				-- AUDITORIA
    Aud_NumTransaccion      BIGINT(20)			-- AUDITORIA
    )

TerminaStore: BEGIN


DECLARE IDFactProv          INT;
DECLARE Var_Poliza          BIGINT;
DECLARE Var_CuentaContable  VARCHAR(25);
DECLARE Var_RFC             CHAR(13);
DECLARE Var_Control         VARCHAR(100);
DECLARE Var_CtaAntProv      VARCHAR(25);
DECLARE Var_CtaProvee       VARCHAR(25);
DECLARE Var_NatConta        CHAR(2);
DECLARE Var_Operacion       CHAR(1);
DECLARE Var_ConFolio        INT(11);
DECLARE Var_EstPeriodo      CHAR(1);
DECLARE Var_FecIniMes       DATE;


DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE SalidaNO            CHAR(1);
DECLARE SalidaSI            CHAR(1);
DECLARE Tipo_RegFact        CHAR(1);
DECLARE Tipo_PagAntFact     CHAR(1);
DECLARE AltaPoliza_SI       CHAR(1);
DECLARE Sin_Error           INT;
DECLARE subtotal            DECIMAL(12,2);
DECLARE Con_PagoAntSI       CHAR(1);
DECLARE Con_ProrrateaImpSI  CHAR(1);
DECLARE Con_ProrrateaImpNO  CHAR(1);
DECLARE Par_PagoAntNO       CHAR(1);
DECLARE Var_NoFactura       VARCHAR(20) ;
DECLARE Salida_SI           CHAR(1);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Con_PagAntFact      INT(11);
DECLARE Des_PagoAntFact     VARCHAR(100);
DECLARE Con_IngFactura      INT(11);
DECLARE Des_IngrFactura     VARCHAR(100);
DECLARE Cuenta_Vacia        VARCHAR(15);
DECLARE Est_Cerrado         CHAR(1);


SET Entero_Cero             := 0;
SET Decimal_Cero            := 0.0;
SET Cadena_Vacia            := '';
SET SalidaSI                := 'S';
SET SalidaNO                := 'N';
SET Fecha_Vacia             := '1900-01-01';
SET Tipo_RegFact            := 'R';
SET Tipo_PagAntFact         := 'G';
SET AltaPoliza_SI           := 'S';
SET Sin_Error               := 0;
SET Con_PagoAntSI           := 'S';
SET Con_ProrrateaImpSI      := 'S';
SET Con_ProrrateaImpNO      := 'N';
SET Par_PagoAntNO           := 'N';
SET Salida_SI               := 'S';
SET Nat_Cargo               := 'C';
SET Nat_Abono               := 'A';
SET Con_PagAntFact          := 85;
SET Des_PagoAntFact         := 'PAGO ANTICIPADO DE FACTURA';
SET Con_IngFactura          := 71;
SET Des_IngrFactura         := 'REGISTRO DE FACTURA';
SET Cuenta_Vacia            := '000000000000000';
SET Est_Cerrado             := 'C';


SET Var_CuentaContable      :='';

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr = 999;
					SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-FACTURAPROVALTPRO');
							SET Var_Control = 'sqlException' ;
				END;


	SET Var_FecIniMes    := CONVERT(DATE_ADD(Par_FechFactura, INTERVAL -1*(DAY(Par_FechFactura))+1 DAY),DATE);

	SELECT  Estatus
	   INTO Var_EstPeriodo
	FROM PERIODOCONTABLE
	WHERE Inicio = Var_FecIniMes;

	SET Var_EstPeriodo := IFNULL(Var_EstPeriodo,Cadena_Vacia);

    IF(Var_EstPeriodo = Cadena_Vacia )THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := CONCAT('La Factura no se puede registrar, No existe periodo contable');
		SET Var_Control := 'fechaFactura';
		LEAVE ManejoErrores;
    END IF;

	IF(Var_EstPeriodo != Cadena_Vacia AND Var_EstPeriodo = Est_Cerrado)THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := CONCAT('La Factura no se puede registrar, periodo contable cerrado');
		SET Var_Control := 'fechaFactura';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ProveedorID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr := 003;
		SET Par_ErrMen := 'El Proveedor esta vacio.';
		SET Var_Control := 'proveedorID';
		LEAVE ManejoErrores;
	END IF;


	SELECT IFNULL(NoFactura,Cadena_Vacia)
	  INTO Var_NoFactura
	  FROM FACTURAPROV
	 WHERE NoFactura = Par_NoFactura
	   AND ProveedorID=Par_ProveedorID;

	IF(Var_NoFactura != Cadena_Vacia)THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := CONCAT('La Factura ',Par_NoFactura,' del Proveedor ',CONVERT(Par_ProveedorID,CHAR(5)),' ya Fue Registrada en el Sistema.');
		SET Var_Control := 'proveedorID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_FolioUUID !=Cadena_Vacia)THEN
		SELECT COUNT(FolioUUID)AS FolioUUID
		INTO Var_ConFolio
		FROM FACTURAPROV
		WHERE FolioUUID = Par_FolioUUID;

		IF(Var_ConFolio > Entero_Cero)THEN
			SET Par_NumErr := 012;
			SET Par_ErrMen := CONCAT('El FolioUUID ya se fue Registrado. [ ', Var_ConFolio,' ]');
			LEAVE ManejoErrores;
		END IF;
	END IF;







	SET Par_TotalFact := IFNULL(Par_TotalFact,Decimal_Cero);
	IF(Par_TotalFact <= Decimal_Cero) THEN
        SET Par_NumErr := 005;
		SET Par_ErrMen := 'El Total de la Factura Debe ser Mayor a Cero.';
		SET Var_Control := 'totalFactura';
		LEAVE ManejoErrores;
	END IF;

	SET Par_SubTotal := IFNULL(Par_SubTotal,Decimal_Cero);

	IF(Par_SubTotal <= Decimal_Cero) THEN
        SET Par_NumErr := 006;
		SET Par_ErrMen := 'El SubTotal de la Factura Debe ser Mayor a Cero.';
		SET Var_Control := 'subTotalFactura';
		LEAVE ManejoErrores;
	END IF;

	SET Par_CenCostoManualID := IFNULL(Par_CenCostoManualID,Entero_Cero);

    IF(Par_PagoAnticipado=Par_PagoAntNO AND Par_CenCostoManualID = Entero_Cero) THEN
		SET Par_NumErr := 007;
		SET Par_ErrMen := 'El Centro de Costo CxP esta vacio.';
		SET Var_Control := 'cenCostoManualID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_PagoAnticipado = Con_PagoAntSI) THEN
		SET Var_CuentaContable = (SELECT IFNULL(CuentaContable,Cadena_Vacia) FROM TIPOPAGOPROV WHERE TipoPagoProvID=Par_TipoPagoAnt);
		IF(Var_CuentaContable = Cadena_Vacia)THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := CONCAT('No existe una Cuenta Contable para el Tipo de Pago. [ ',Par_TipoPagoAnt,' ]');
			SET Var_Control := 'tipoPagoAnt';
			LEAVE ManejoErrores;
		END IF;

        SET Par_CenCostoAntID := IFNULL(Par_CenCostoAntID,Entero_Cero);
		IF(Par_CenCostoAntID=Entero_Cero) THEN
			SET Par_NumErr := 009;
            SET Par_ErrMen := 'El Centro de Costo de Pago Anticipo esta vacio.';
			SET Var_Control := 'cenCostoAntID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_EmpleadoID := IFNULL(Par_EmpleadoID,Entero_Cero);
		IF(Par_EmpleadoID=Entero_Cero)THEN
			SET Par_NumErr := 010;
			SET Par_ErrMen := 'El Numero de Empleado esta vacio.';
			SET Var_Control := 'noEmpleadoID';
			LEAVE ManejoErrores;
		END IF;

	END IF;


	IF(IFNULL(Par_Estatus, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 011;
		SET Par_ErrMen := 'El Estatus esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	SET IDFactProv := (SELECT IFNULL(MAX(FacturaProvID),Entero_Cero)+1 FROM FACTURAPROV);
	SET Par_RutaImgFac:=IFNULL(Par_RutaImgFac,Cadena_Vacia);
	SET Par_RutaXMLFac:=IFNULL(Par_RutaXMLFac,Cadena_Vacia);
	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	INSERT INTO FACTURAPROV (
		FacturaProvID,      ProveedorID,    NoFactura,          FechaFactura,   Estatus,
		CondicionesPago,    FechaProgPago,  FechaVencimient,    SaldoFactura,   TotalGravable,
		TotalFactura,       SubTotal,       CenCostoManualID,   CenCostoAntID,  PagoAnticipado,
		ProrrateaImp,       TipoPagoAnt,    EmpleadoID,         RutaImagenFact, RutaXMLFact,
		FolioUUID,          EmpresaID,      Usuario,            FechaActual,    DireccionIP,
		ProgramaID,         Sucursal,       NumTransaccion,     PolizaID)
	VALUES (
		IDFactProv,         Par_ProveedorID,    Par_NoFactura,          Par_FechFactura,    Par_Estatus,
		Par_CondicPago,     Par_FechProgPag,    Par_FechaVenc,          Par_SaldoFact,      Par_TotalGrava,
		Par_TotalFact,      Par_SubTotal,       Par_CenCostoManualID,   Par_CenCostoAntID,  Par_PagoAnticipado,
		Par_ProrrateaImp,   Par_TipoPagoAnt,    Par_EmpleadoID,         Par_RutaImgFac,     Par_RutaXMLFac,
		Par_FolioUUID,      Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion,     Decimal_Cero);

    -- ACTUALIZAMOS EL REGISTRO
	UPDATE FACTURAPROV
		SET OrigenFactura = 'FM'
	WHERE ProveedorID = Par_ProveedorID
    AND NoFactura = Par_NoFactura;

	/*************************************************************************************************************
	-- 									INICIO DE SI GENERA CONTABLIDAD											--
	**************************************************************************************************************/
	IF(Par_GeneraConta = "S")THEN

		   SET Var_RFC := (SELECT CASE TipoPersona WHEN 'M' THEN IFNULL(RFCpm,Cadena_Vacia) ELSE IFNULL(RFC,Cadena_Vacia) END
			  FROM PROVEEDORES
			 WHERE ProveedorID = Par_ProveedorID);

			SET Var_RFC:= IFNULL(Var_RFC,Cadena_Vacia);

			SELECT CuentaAnticipo,CuentaCompleta
			INTO Var_CtaAntProv, Var_CtaProvee
			FROM PROVEEDORES
			WHERE ProveedorID = Par_ProveedorID;

			SET Var_CtaAntProv := IFNULL(Var_CtaAntProv, Cuenta_Vacia);
			SET Var_CtaProvee  := IFNULL(Var_CtaProvee, Cuenta_Vacia);

		SELECT PolizaID INTO Var_Poliza
				FROM POLIZACONTABLE
				WHERE NumTransaccion= Aud_NumTransaccion;

		IF(Par_PagoAnticipado = Con_PagoAntSI)THEN

			 SET Var_NatConta :=    Nat_Abono;
			IF(Par_OrigenProceso= "FM" )THEN
				CALL CONTAFACTURAPRO(
					Par_ProveedorID,        Par_NoFactura,          Tipo_PagAntFact,        Par_PagoAnticipado,     "N",
					Var_Poliza,             Par_FechFactura,        Par_TotalFact,          Par_CenCostoAntID,      Par_CenCostoManualID,
					Var_CuentaContable,     Par_EmpleadoID,         Var_RFC,                Par_FolioUUID,          Var_NatConta,
					Con_PagAntFact,         Des_PagoAntFact,        Entero_Cero,            Par_Salida,             Par_NumErr,
					Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
					Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
			ELSE
				CALL CONTAFACTURAPRO(
					Par_ProveedorID,        Par_NoFactura,          Tipo_PagAntFact,        Par_PagoAnticipado,     AltaPoliza_SI,
					Var_Poliza,             Par_FechFactura,        Par_TotalFact,          Par_CenCostoAntID,      Par_CenCostoManualID,
					Var_CuentaContable,     Par_EmpleadoID,         Var_RFC,                Par_FolioUUID,          Var_NatConta,
					Con_PagAntFact,         Des_PagoAntFact,        Entero_Cero,            Par_Salida,             Par_NumErr,
					Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
					Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
            END IF;


		ELSE


			SET Var_NatConta := Nat_Abono;
            IF(Par_OrigenProceso= "FM" )THEN
				CALL CONTAFACTURAPRO(
					Par_ProveedorID,        Par_NoFactura,          Tipo_RegFact,           Par_PagoAntNO,          "N",
					Var_Poliza,             Par_FechFactura,        Par_TotalFact,          Par_CenCostoManualID,   Par_CenCostoManualID,
					Var_CtaProvee,          Par_EmpleadoID,         Var_RFC,                Par_FolioUUID,          Var_NatConta,
					Con_IngFactura,         Des_IngrFactura,        Entero_Cero,            Par_Salida,             Par_NumErr,
					Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
					Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
			ELSE
				CALL CONTAFACTURAPRO(
					Par_ProveedorID,        Par_NoFactura,          Tipo_RegFact,           Par_PagoAntNO,          AltaPoliza_SI,
					Var_Poliza,             Par_FechFactura,        Par_TotalFact,          Par_CenCostoManualID,   Par_CenCostoManualID,
					Var_CtaProvee,          Par_EmpleadoID,         Var_RFC,                Par_FolioUUID,          Var_NatConta,
					Con_IngFactura,         Des_IngrFactura,        Entero_Cero,            Par_Salida,             Par_NumErr,
					Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
					Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
            END IF;

		 END IF;


		   UPDATE FACTURAPROV
			  SET PolizaID = Var_Poliza
			WHERE FacturaProvID = IDFactProv
			  AND ProveedorID = Par_ProveedorID
			  AND Par_NoFactura = NoFactura;

        SET Par_NumErr := 000;
		SET Par_ErrMen :=  CONCAT('La Factura : ',Par_NoFactura,' fue Modificada exitosamente.');
		SET Var_Control := "polizaID";
	END IF;

    SET Par_NumErr := 000;
	SET Par_ErrMen := Par_ErrMen;
	SET Var_Control := Var_Control;

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Poliza AS consecutivo;
END IF;

END TerminaStore$$