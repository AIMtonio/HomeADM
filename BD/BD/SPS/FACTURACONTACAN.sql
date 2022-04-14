-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURACONTACAN
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURACONTACAN`;DELIMITER $$

CREATE PROCEDURE `FACTURACONTACAN`(

    Par_ProveedorID         INT,
    Par_NoFactura           VARCHAR(20),
    Par_FolioUUID           VARCHAR(100),
    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,

    INOUT Par_ErrMen        VARCHAR(400),
    INOUT Par_Consecutivo   INT,

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
)
TerminaStore: BEGIN


DECLARE IDFactProv              INT;
DECLARE Var_CenCostoID          INT;
DECLARE Var_CenCostoImpID       INT;
DECLARE Var_Poliza              BIGINT;
DECLARE Var_FechaSist           DATE;
DECLARE Var_TotalFac            DECIMAL(12,2);
DECLARE Var_IVA                 DECIMAL(12,2);
DECLARE Var_RetIVA              DECIMAL(12,2);
DECLARE Var_RetISR              DECIMAL(12,2);
DECLARE Var_ProrrateaImp        CHAR(1);
DECLARE Var_ProrrateaSI         CHAR(1);
DECLARE Var_ProrrateaNO         CHAR(1);
DECLARE Var_IvaCenCosto         DECIMAL(13,2);
DECLARE Var_RetIvaCenCosto      DECIMAL(13,2);
DECLARE Var_RetISRCenCosto      DECIMAL(13,2);
DECLARE Var_CenCostoManualID    INT(11);
DECLARE Var_ImporteImp          DECIMAL(14,2);
DECLARE Var_TipoGasto           INT;
DECLARE Var_Descripcion         VARCHAR(50);
DECLARE Var_Importe             DECIMAL(12,2);
DECLARE Var_RFC                 CHAR(13);
DECLARE Var_Control             VARCHAR(100);
DECLARE Var_CtaAntProv          VARCHAR(25);
DECLARE Var_CtaProvee           VARCHAR(25);
DECLARE Var_NatConta            CHAR(2);
DECLARE Var_CueGasto            CHAR(25);
DECLARE Var_ImpID               INT(11);
DECLARE Var_FechaFact           DATE;


DECLARE Entero_Cero             INT;
DECLARE Decimal_Cero            DECIMAL(12,2);
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Fecha_Vacia             DATE;
DECLARE SalidaNO                CHAR(1);
DECLARE SalidaSI                CHAR(1);
DECLARE Tipo_RegFact            CHAR(1);
DECLARE AltaPoliza_SI           CHAR(1);
DECLARE Sin_Error               INT;
DECLARE subtotal                DECIMAL(12,2);
DECLARE AltaPoliza_NO           CHAR(1);
DECLARE PagadaAntNO             CHAR(1);
DECLARE Con_CanFactura          INT;
DECLARE Des_CanFactura          VARCHAR(100);
DECLARE Nat_Cargo               CHAR(1);
DECLARE Nat_Abono               CHAR(1);
DECLARE Cuenta_Vacia            VARCHAR(15);
DECLARE Var_TraCue              VARCHAR(25);
DECLARE Var_ReaCue              VARCHAR(25);
DECLARE Var_TipoImp             CHAR(1);
DECLARE Imp_Gravado             CHAR(1);
DECLARE Imp_Retenido            CHAR(1);


DECLARE CURSORDETFACT CURSOR FOR
    SELECT  TipoGastoID,    Descripcion,    Importe , CentroCostoID
    FROM    FACTURAPROV  Fac,
            DETALLEFACTPROV Det
        WHERE Fac.ProveedorID = Det.ProveedorID
        AND Fac.ProveedorID = Par_ProveedorID
        AND Fac.NoFactura = Det.NoFactura
        AND Fac.NoFactura = Par_NoFactura;


DECLARE CURSORDETIMPUESTOS CURSOR FOR
    SELECT  ImporteImpuesto,ImpuestoID,CentroCostoID
    FROM    DETALLEIMPFACT DI,
            DETALLEFACTPROV Det
    WHERE DI.ProveedorID = Par_ProveedorID
        AND DI.NoFactura = Par_NoFactura
        AND Det.ProveedorID = Par_ProveedorID
        AND Det.NoFactura = Par_NoFactura
        AND Det.NoPartidaID = DI.NoPartidaID;



SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.0;
SET Cadena_Vacia    := '';
SET SalidaSI        := 'S';
SET SalidaNO        := 'N';
SET Fecha_Vacia     := '1900-01-01';
SET AltaPoliza_SI   := 'S';
SET Sin_Error       := 0;
SET Tipo_RegFact    := 'C';
SET Var_ProrrateaSI := 'S';
SET Var_ProrrateaNO := 'N';
SET AltaPoliza_NO   := 'N';
SET PagadaAntNO     := 'N';
SET Con_CanFactura  := 78;
SET Des_CanFactura  := 'CANCELACION DE FACTURA';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Cuenta_Vacia    := '000000000000000';
SET Imp_Gravado     := 'G';
SET Imp_Retenido    := 'R';

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    set Par_NumErr = 999;
                    set Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                            'esto le ocasiona. Ref: SP-FACTURACONTACAN');
                            SET Var_Control = 'sqlException' ;
                END;

SET Var_FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);


SELECT  TotalFactura, ProrrateaImp,     CenCostoManualID,       FechaFactura
INTO    Var_TotalFac, Var_ProrrateaImp, Var_CenCostoManualID,   Var_FechaFact
FROM    FACTURAPROV
WHERE   ProveedorID =Par_ProveedorID
AND     NoFactura   =Par_NoFactura;

SET Par_NumErr := 0;
SET Par_ErrMen := "";


SET Var_RFC := (SELECT RFC FROM PROVEEDORES
              WHERE ProveedorID = Par_ProveedorID);

SELECT CuentaAnticipo,CuentaCompleta
INTO Var_CtaAntProv, Var_CtaProvee
FROM PROVEEDORES
WHERE ProveedorID = Par_ProveedorID;

SET Var_CtaAntProv := IFNULL(Var_CtaAntProv, Cuenta_Vacia);
SET Var_CtaProvee  := IFNULL(Var_CtaProvee, Cuenta_Vacia);

SET Var_NatConta := Nat_Cargo;

  CALL CONTAFACTURAPRO(
        Par_ProveedorID,        Par_NoFactura,      Tipo_RegFact,           PagadaAntNO,        AltaPoliza_SI,
        Var_Poliza,             Var_FechaFact,      Var_TotalFac,           Entero_Cero,        Var_CenCostoManualID,
        Var_CtaProvee,          Entero_Cero,        Var_RFC,                Par_FolioUUID,      Var_NatConta,
        Con_CanFactura,         Des_CanFactura,     Entero_Cero,            Par_Salida,         Par_NumErr,
        Par_ErrMen,             Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion
    );



IF (Par_NumErr = Entero_Cero) THEN
    SET Par_NumErr := 0;
    SET Par_ErrMen := "";


    OPEN CURSORDETFACT;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            LOOP

            FETCH CURSORDETFACT INTO
                Var_TipoGasto,      Var_Descripcion,    Var_Importe, Var_CenCostoID;

                BEGIN



                    SELECT CuentaCompleta INTO Var_CueGasto
                    FROM TESOCATTIPGAS
                    WHERE TipoGastoID = Var_TipoGasto;

                    SET Var_CueGasto = IFNULL(Var_CueGasto, Cuenta_Vacia);

                    SET Var_NatConta := Nat_Abono;



                    CALL CONTAFACTURAPRO(
                        Par_ProveedorID,        Par_NoFactura,      Tipo_RegFact,           PagadaAntNO,        AltaPoliza_NO,
                        Var_Poliza,             Var_FechaFact,      Var_Importe,            Entero_Cero,        Var_CenCostoID,
                        Var_CueGasto,           Entero_Cero,        Var_RFC,                Par_FolioUUID,      Var_NatConta,
                        Con_CanFactura,         Des_CanFactura,     Entero_Cero,            Par_Salida,         Par_NumErr,
                        Par_ErrMen,             Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);



                    IF (Par_NumErr != Entero_Cero) THEN
                        IF(Par_Salida = SalidaSI) THEN
                            SELECT Par_NumErr AS NumErr,
                                Par_ErrMen AS ErrMen,
                                Aud_NumTransaccion AS control,
                                Var_Poliza AS consecutivo;
                        END IF;
                        LEAVE TerminaStore;
                    END IF;

                END;

            END LOOP;

        END;
    CLOSE CURSORDETFACT;


    OPEN CURSORDETIMPUESTOS;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            LOOP

                FETCH CURSORDETIMPUESTOS INTO

                    Var_ImporteImp,Var_ImpID,Var_CenCostoImpID;

                BEGIN


                    SELECT CtaEnTransito, CtaRealizado, GravaRetiene
                    INTO   Var_TraCue,    Var_ReaCue,   Var_TipoImp
                    FROM IMPUESTOS
                    WHERE ImpuestoID = Var_ImpID;

                    SET Var_TraCue := IFNULL(Var_TraCue, Cuenta_Vacia);
                    SET Var_ReaCue := IFNULL(Var_ReaCue, Cuenta_Vacia);


                    IF(Var_TipoImp = Imp_Gravado)THEN
                        SET Var_NatConta := Nat_Abono;
                    ELSE
                        IF(Var_TipoImp = Imp_Retenido)THEN
                            SET Var_NatConta := Nat_Cargo;
                        END IF;

                    END IF;



                    CALL CONTAFACTURAPRO(
                                Par_ProveedorID,        Par_NoFactura,      Tipo_RegFact,       PagadaAntNO,        AltaPoliza_NO,
                                Var_Poliza,             Var_FechaFact,      Var_ImporteImp,     Entero_Cero,        Var_CenCostoImpID,
                                Var_TraCue,             Entero_Cero,        Var_RFC,            Par_FolioUUID,      Var_NatConta,
                                Con_CanFactura,         Des_CanFactura,     Entero_Cero,        Par_Salida,         Par_NumErr,
                                Par_ErrMen,             Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                                Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion
                            );


                    IF (Par_NumErr != Entero_Cero) THEN
                        IF(Par_Salida = SalidaSI) THEN
                            SELECT Par_NumErr AS NumErr,
                                Par_ErrMen AS ErrMen,
                                Aud_NumTransaccion AS control,
                                Var_Poliza AS consecutivo;
                        END IF;
                        LEAVE TerminaStore;
                    END IF;

                END;

            END LOOP;

        END;
    CLOSE CURSORDETIMPUESTOS;

ELSE

    IF(Par_Salida = SalidaSI) THEN
        SELECT Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Aud_NumTransaccion AS control,
                Var_Poliza AS consecutivo;
    END IF;
    LEAVE TerminaStore;
END IF;

END ManejoErrores;

  IF (Par_NumErr = Entero_Cero) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '000' AS NumErr,
                CONCAT('La Factura :',Par_NoFactura,'fue Cancelada.') AS ErrMen,
                Aud_NumTransaccion AS control,
                Var_Poliza AS consecutivo;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := Par_NumErr;
        SET Par_ErrMen := CONCAT('La Factura :',Par_NoFactura,'fue Cancelada.');
        SET Par_Consecutivo:=Var_Poliza;
    END IF;
  ELSE
    IF(Par_Salida = SalidaSI) THEN
        SELECT Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Aud_NumTransaccion AS control,
                Var_Poliza AS consecutivo;
    END IF;
    IF(Par_Salida =SalidaNO) THEN
        SET Par_NumErr := Par_NumErr;
        SET Par_ErrMen := 'La Factura fue Agregada.';
    END IF;
  END IF;

END TerminaStore$$