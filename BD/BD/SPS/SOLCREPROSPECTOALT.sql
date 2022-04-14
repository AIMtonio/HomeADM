-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLCREPROSPECTOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLCREPROSPECTOALT`;DELIMITER $$

CREATE PROCEDURE `SOLCREPROSPECTOALT`(
    Par_ProspectoID         BIGINT(20),
    Par_ClienteID           INT,
    Par_ProduCredID         INT,
    Par_FechaReg            DATE,
    Par_Promotor            INT,
    Par_TipoCredito         CHAR(1),
    Par_NumCreditos         INT,
    Par_Relacionado         BIGINT(12),
    Par_AporCliente         DECIMAL(12,4),
    Par_Moneda              INT,
    Par_DestinoCre          INT,
    Par_Proyecto            VARCHAR(400),
    Par_SucursalID          INT,
    Par_MontoSolic          DECIMAL(12,4),
    Par_PlazoID             INT,
    Par_FactorMora          DECIMAL(8,4),
    Par_ComApertura         DECIMAL(12,4),
    Par_IVAComAper          DECIMAL(12,4),
    Par_TipoDisper          CHAR(1),
    Par_CalcInteres         INT,
    Par_TasaBase            DECIMAL(12,4),
    Par_TasaFija            DECIMAL(12,4),
    Par_SobreTasa           DECIMAL(12,4),
    Par_PisoTasa            DECIMAL(12,4),
    Par_TechoTasa           DECIMAL(12,4),
    Par_FechInhabil         CHAR(1),
    Par_AjuFecExiVe         CHAR(1),
    Par_CalIrreg            CHAR(1),
    Par_AjFUlVenAm          CHAR(1),
    Par_TipoPagCap          CHAR(1),
    Par_FrecInter           CHAR(1),
    Par_FrecCapital         CHAR(1),
    Par_PeriodInt           INT,
    Par_PeriodCap           INT,
    Par_DiaPagInt           CHAR(1),
    Par_DiaPagCap           CHAR(1),
    Par_DiaMesInter         INT,
    Par_DiaMesCap           INT,
    Par_NumAmorti           INT,
    Par_NumTransacSim       BIGINT(20),
    Par_CAT                 DECIMAL(12,4),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE  Entero_Cero    INT;
DECLARE  Decimal_Cero   DECIMAL(12,2);
DECLARE  Cadena_Vacia   CHAR(1);
DECLARE  Fecha_Vacia    DATE;
DECLARE  SalidaNO           CHAR(1);
DECLARE  SalidaSI           CHAR(1);
DECLARE  SiPagaIVA          CHAR(1);
DECLARE  NoPagaIVA          CHAR(1);
DECLARE  EstInactiva        CHAR(1);


DECLARE  Var_ProspectoID    INT;
DECLARE  Var_ClienteID      INT;
DECLARE  Var_SolicitudCre   INT;



SET     Entero_Cero     :=0;
SET     Decimal_Cero    :=0.0;
SET     Fecha_Vacia     := '1900-01-01';
SET     Cadena_Vacia    :='';
SET     SalidaSI        := 'S';
SET     SalidaNO        := 'N';
SET     SiPagaIVA       := 'S';
SET     NoPagaIVA       := 'N';
SET     EstInactiva     := 'I';

IF(Par_ProspectoID = Entero_Cero AND Par_ClienteID = Entero_Cero) THEN
    SELECT '001' AS NumErr,
        'El Prospecto o Cliente estan vacios.' AS ErrMen,
        'prospectoID' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
ELSE
    IF(Par_ProspectoID <> Entero_Cero) THEN
        SET Var_ProspectoID := (SELECT ProspectoID
                                FROM PROSPECTOS
                                WHERE ProspectoID = Par_ProspectoID );

        IF(IFNULL(Var_ProspectoID, Entero_Cero))= Entero_Cero THEN
            SELECT '002' AS NumErr,
                'El prospecto indicado no Existe.' AS ErrMen,
                'prospectoID' AS control,
                Entero_Cero AS conse4cutivo;
            LEAVE TerminaStore;
        END IF;
    ELSE
        IF(Par_ClienteID <> Entero_Cero) THEN
            SET Var_ClienteID := (SELECT ClienteID
                                    FROM CLIENTES
                                    WHERE ClienteID = Par_ClienteID );

            IF(IFNULL(Var_ClienteID, Entero_Cero))= Entero_Cero THEN
                SELECT '003' AS NumErr,
                    'El cliente indicado no Existe.' AS ErrMen,
                    'clienteID' AS control,
                    Entero_Cero AS consecutivo;
                LEAVE TerminaStore;
            END IF;

        END IF;

    END IF;

END IF;


IF(IFNULL(Par_FechaReg, Fecha_Vacia))= Fecha_Vacia THEN
    SELECT '004' AS NumErr,
        'La Fecha de Registro esta Vacia.' AS ErrMen,
        'fechaInicio' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_MontoSolic, Decimal_Cero))= Decimal_Cero THEN
    SELECT '005' AS NumErr,
        'El monto solicitado esta Vacio.' AS ErrMen,
        'montoSolici' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_ProduCredID, Entero_Cero))= Entero_Cero THEN
    SELECT '006' AS NumErr,
        'El Producto de Credito solicitado esta Vacio.' AS ErrMen,
        'productoCreditoID' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Promotor, Entero_Cero))= Entero_Cero THEN
    SELECT '007' AS NumErr,
        'El Promotor esta Vacio.' AS ErrMen,
        'promotorID' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Moneda, Entero_Cero))= Entero_Cero THEN
    SELECT '008' AS NumErr,
        'La Moneda esta Vacia.' AS ErrMen,
        'monedaID' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_DestinoCre, Entero_Cero))= Entero_Cero THEN
    SELECT '009' AS NumErr,
        'El Destino  de Credito esta Vacia.' AS ErrMen,
        'destinoCreID' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_PlazoID, Cadena_Vacia))= Cadena_Vacia THEN
    SELECT '010' AS NumErr,
        'El Destino  de Credito esta Vacia.' AS ErrMen,
        'destinoCreID' AS control,
        Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;





SET Var_SolicitudCre:= (SELECT IFNULL(MAX(SolCredProsID),Entero_Cero) + 1
                        FROM SOLCREPROSPECTO);


        INSERT INTO SOLCREPROSPECTO (
            SolCredProsID,      ProspectoID,        ClienteID,          FechaRegistro,      FechaAutoriza,
            MontoSolici,        MontoAutorizado,    MonedaID,           ProductoCreditoID,  PlazoID,
            Estatus,            TipoDispersion,     CuentaCLABE,        SucursalID,         ForCobroComAper,
            MontoPorComAper,    IVAComAper,         DestinoCreID,       PromotorID,         TasaFija,
            TasaBase,           SobreTasa,          PisoTasa,           TechoTasa,          FactorMora,
            FrecuenciaCap,      PeriodicidadCap,    FrecuenciaInt,      PeriodicidadInt,    TipoPagoCapital,
            NumAmortizacion,    CalendIrregular,    DiaPagoInteres,     DiaPagoCapital,     DiaMesInteres,
            DiaMesCapital,      AjusFecUlVenAmo,    AjusFecExiVen,      NumTransacSim,      ValorCAT,
            FechaInhabil,       AporteCliente,      UsuarioAutoriza,    FechaRechazo,       UsuarioRechazo,
            ComentarioRech,     MotivoRechazo,      TipoCredito,        NumCreditos,        Relacionado,
            Proyecto,           EmpresaID,          Usuario,            FechaActual,        DireccionIP,
            ProgramaID,         NumTransaccion)
        VALUES (
            Var_SolicitudCre,   Par_ProspectoID,    Par_ClienteID,      Par_FechaReg,       Fecha_Vacia,
            Par_MontoSolic,     Decimal_Cero,       Par_Moneda,         Par_ProduCredID,    Par_PlazoID,
            EstInactiva,        Par_TipoDisper,     Cadena_Vacia,       Par_SucursalID,     Cadena_Vacia,
            Par_ComApertura,    Par_IVAComAper,     Par_DestinoCre,     Par_Promotor,       Par_TasaFija,
            Par_TasaBase,       Par_SobreTasa,      Par_PisoTasa,       Par_TechoTasa,      Par_FactorMora,
            Par_FrecCapital,    Par_PeriodCap,      Par_FrecInter,      Par_PeriodInt,      Par_TipoPagCap,
            Par_NumAmorti,      Par_CalIrreg,       Par_DiaPagInt,      Par_DiaPagCap,      Par_DiaMesInter,
            Par_DiaMesCap,      Par_AjFUlVenAm,     Par_AjuFecExiVe,    Par_NumTransacSim,  Par_CAT,
            Par_FechInhabil,    Par_AporCliente,    Entero_Cero,        Fecha_Vacia,        Entero_Cero,
            Cadena_Vacia,       Entero_Cero,        Par_TipoCredito,    Par_NumCreditos,    Par_Relacionado,
            Par_Proyecto,       Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_NumTransaccion);




        IF(Par_Salida =SalidaSI) THEN
                SELECT '000' AS NumErr,
                    'La Solicitud de Credito fue Agregada.' AS ErrMen,
                    'solCredProsID' AS control,
                     Var_SolicitudCre AS consecutivo;
        END IF;
        IF(Par_Salida =SalidaNO) THEN
                SET     Par_NumErr := 0;
                SET Par_ErrMen := 'La Solicitud de Credito fue Agregada.';
                LEAVE TerminaStore;
        END IF;



END TerminaStore$$