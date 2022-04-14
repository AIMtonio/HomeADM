-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURAPROVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURAPROVALT`;DELIMITER $$

CREATE PROCEDURE `FACTURAPROVALT`(
    Par_ProveedorID         INT,
    Par_NoFactura           VARCHAR(20),
    Par_FechFactura         DATETIME,
    Par_Estatus             CHAR(1),
    Par_CondicPago          INT,

    Par_FechProgPag         DATETIME,
    Par_FechaVenc           DATETIME,
    Par_SaldoFact           DECIMAL(13,2),
    Par_TotalGrava          DECIMAL(13,2),
    Par_TotalFact           DECIMAL(13,2),

    Par_SubTotal            DECIMAL(13,2),
    Par_PagoAnticipado      CHAR(1),
    Par_TipoPagoAnt         CHAR(1),
    Par_EmpleadoID          INT,
    Par_CenCostoAntID       INT(11),

    Par_CenCostoManualID    INT(11),
    Par_ProrrateaImp        CHAR(1),
    Par_RutaImgFac          VARCHAR(150),
    Par_RutaXMLFac          VARCHAR(150),
    Par_FolioUUID           VARCHAR(100),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
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
                                        'esto le ocasiona. Ref: SP-FACTURAPROVALT');
                        SET Var_Control = 'sqlException' ;
            END;


SET Var_FecIniMes    := CONVERT(DATE_ADD(Par_FechFactura, INTERVAL -1*(DAY(Par_FechFactura))+1 DAY),DATE);

SELECT  Estatus
   INTO Var_EstPeriodo
FROM PERIODOCONTABLE
WHERE Inicio = Var_FecIniMes;

SET Var_EstPeriodo := IFNULL(Var_EstPeriodo,Cadena_Vacia);

IF(Var_EstPeriodo != Cadena_Vacia )THEN
    IF (Var_EstPeriodo = Est_Cerrado)THEN
        SELECT '011' AS NumErr,
        CONCAT('La Factura no se puede registrar, periodo contable cerrado') AS ErrMen,
        'fechaFactura' AS control,
        Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    END IF;
ELSE
    SELECT '012' AS NumErr,
    CONCAT('La Factura no se puede registrar, No existe periodo contable') AS ErrMen,
    'fechaFactura' AS control,
    Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_ProveedorID, Entero_Cero)) = Entero_Cero THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '001' AS NumErr,
            'El Proveedor esta vacio.' AS ErrMen,
            'proveedorID' AS control,
            Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := 1;
        SET Par_ErrMen := 'El Proveedor esta vacio.';
    END IF;
END IF;

SELECT IFNULL(NoFactura,Cadena_Vacia)
  INTO Var_NoFactura
  FROM FACTURAPROV
 WHERE NoFactura = Par_NoFactura
   AND ProveedorID=Par_ProveedorID;

IF(Var_NoFactura != Cadena_Vacia)THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '002' AS NumErr,
            CONCAT('La Factura ',Par_NoFactura,' del Proveedor ',CONVERT(Par_ProveedorID,CHAR(5)),' ya Fue Registrada en el Sistema.') AS ErrMen,
            'proveedorID' AS control,
            Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := 2;
        SET Par_ErrMen :=CONCAT('La Factura ',Par_NoFactura,' del Proveedor ',CONVERT(Par_ProveedorID,CHAR(5)),' ya Fue Registrada en el Sistema.');
    END IF;
END IF;


SET Par_TotalFact := IFNULL(Par_TotalFact,Decimal_Cero);
IF(Par_TotalFact <= Decimal_Cero) THEN
    SELECT '003' AS NumErr,
        'El Total de la Factura Debe ser Mayor a Cero.' AS ErrMen,
        'totalFactura' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

SET Par_SubTotal := IFNULL(Par_SubTotal,Decimal_Cero);
IF(Par_SubTotal <= Decimal_Cero) THEN
    SELECT '004' AS NumErr,
        'El SubTotal de la Factura Debe ser Mayor a Cero.' AS ErrMen,
        'subTotalFactura' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;


IF(Par_PagoAnticipado=Par_PagoAntNO) THEN
    SET Par_CenCostoManualID := IFNULL(Par_CenCostoManualID,Entero_Cero);
    IF(Par_CenCostoManualID = Entero_Cero)THEN
        SELECT '005' AS NumErr,
                'El Centro de Costo CxP esta vacio' AS ErrMen,
                'cenCostoManualID' AS control,
                Entero_Cero AS consecutivo;
            LEAVE TerminaStore;
    END IF;
END IF;

IF(Par_PagoAnticipado = Con_PagoAntSI) THEN
    SET Var_CuentaContable = (SELECT IFNULL(CuentaContable,Cadena_Vacia) FROM TIPOPAGOPROV WHERE TipoPagoProvID=Par_TipoPagoAnt);
        IF(Var_CuentaContable = Cadena_Vacia)THEN
            SELECT '006' AS NumErr,
            'No existe una Cuenta Contable para el Tipo de Pago' AS ErrMen,
            'tipoPagoAnt' AS control,
            Entero_Cero AS consecutivo;
            LEAVE TerminaStore;
        END IF;
    SET Par_CenCostoAntID := IFNULL(Par_CenCostoAntID,Entero_Cero);
        IF(Par_CenCostoAntID=Entero_Cero) THEN
            SELECT '007' AS NumErr,
            'El Centro de Costo de Pago Anticipo esta vacio' AS ErrMen,
            'cenCostoAntID' AS control,
            Entero_Cero AS consecutivo;
            LEAVE TerminaStore;
        END IF;
    SET Par_EmpleadoID := IFNULL(Par_EmpleadoID,Entero_Cero);
    IF(Par_EmpleadoID=Entero_Cero)THEN
            SELECT '008' AS NumErr,
            'El Numero de Empleado esta vacio' AS ErrMen,
            'noEmpleadoID' AS control,
            Entero_Cero AS consecutivo;
            LEAVE TerminaStore;
    END IF;
END IF;


IF(IFNULL(Par_Estatus, Cadena_Vacia)) = Cadena_Vacia THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '009' AS NumErr,
            'El Estatus esta vacio.' AS ErrMen,
            'estatus' AS control,
            Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := 9;
        SET Par_ErrMen := 'El Estatus esta vacio.';
    END IF;
END IF;

IF(Par_FolioUUID !=Cadena_Vacia)THEN

    SELECT COUNT(FolioUUID)AS FolioUUID
    INTO Var_ConFolio
    FROM FACTURAPROV
    WHERE FolioUUID = Par_FolioUUID;

    IF(Var_ConFolio > Entero_Cero)THEN
        IF(Par_Salida = SalidaSI) THEN
            SELECT '010' AS NumErr,
                'El FolioUUID ya se fue Registrado.' AS ErrMen,
                'folioUUID' AS control,
                Entero_Cero AS consecutivo;
            LEAVE TerminaStore;
        END IF;
        IF(Par_Salida =SalidaNO) THEN
            SET Par_NumErr := 10;
            SET Par_ErrMen := 'El FolioUUID ya se fue Registrado.';
        END IF;
    END IF;
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


IF(Par_PagoAnticipado = Con_PagoAntSI)THEN

     SET Var_NatConta :=    Nat_Abono;

    CALL CONTAFACTURAPRO(
        Par_ProveedorID,        Par_NoFactura,          Tipo_PagAntFact,        Par_PagoAnticipado,     AltaPoliza_SI,
        Var_Poliza,             Par_FechFactura,        Par_TotalFact,          Par_CenCostoAntID,      Par_CenCostoManualID,
        Var_CuentaContable,     Par_EmpleadoID,         Var_RFC,                Par_FolioUUID,          Var_NatConta,
        Con_PagAntFact,         Des_PagoAntFact,        Entero_Cero,            Par_Salida,             Par_NumErr,
        Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);


ELSE


    SET Var_NatConta := Nat_Abono;

    CALL CONTAFACTURAPRO(
        Par_ProveedorID,        Par_NoFactura,          Tipo_RegFact,           Par_PagoAntNO,          AltaPoliza_SI,
        Var_Poliza,             Par_FechFactura,        Par_TotalFact,          Par_CenCostoManualID,   Par_CenCostoManualID,
        Var_CtaProvee,          Par_EmpleadoID,         Var_RFC,                Par_FolioUUID,          Var_NatConta,
        Con_IngFactura,         Des_IngrFactura,        Entero_Cero,            Par_Salida,             Par_NumErr,
        Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
    );
 END IF;


   UPDATE FACTURAPROV
      SET PolizaID = Var_Poliza
    WHERE FacturaProvID = IDFactProv
      AND ProveedorID = Par_ProveedorID
      AND Par_NoFactura = NoFactura;


END ManejoErrores;

IF (Par_NumErr != Sin_Error) THEN
    IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen  AS ErrMen,
                'polizaID' AS control,
                Var_Poliza AS consecutivo;
    END IF;
    LEAVE TerminaStore;
END IF;


IF(Par_Salida = SalidaSI) THEN
    SELECT '000' AS NumErr,
            CONCAT('La Factura :',Par_NoFactura,'fue Agregada.') AS ErrMen,
            Aud_NumTransaccion AS control,
            Var_Poliza AS consecutivo;
END IF;
IF(Par_Salida =SalidaNO) THEN
    SET     Par_NumErr := 0;
    SET     Par_ErrMen := 'La Factura fue Agregada.';
END IF;


END TerminaStore$$