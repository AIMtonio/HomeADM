-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOAPOYOESCOLARPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOAPOYOESCOLARPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOAPOYOESCOLARPRO`(

    Par_ApoyoEscSolID       INT(11),
    Par_TransaccionPago     BIGINT(20),
    Par_CajaID              INT(11),
    Par_SucursalCajaID      INT(11),
    Par_PersonaRecibe       VARCHAR(200),
    Par_PolizaID            BIGINT(20),

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
TerminaStore:BEGIN

DECLARE Var_Poliza              BIGINT(20);
DECLARE Var_FechaSistema        DATE;
DECLARE Var_MonedaBaseID        INT(11);
DECLARE Var_Control             VARCHAR(50);
DECLARE Var_CentroCostosID      INT(11);
DECLARE Var_CtaContaApoyoEsc    VARCHAR(25);
DECLARE Var_MontoPagar          DECIMAL(14,2);
DECLARE Var_ClienteID           INT(11);
DECLARE Var_SucCliente          INT(11);
DECLARE Var_CCApoyoEscolar      VARCHAR(30);


DECLARE SalidaSI                CHAR(1);
DECLARE SalidaNO                CHAR(1);
DECLARE Pol_Automatica          CHAR(1);
DECLARE ConceptoCon             INT(11);
DECLARE DescripcionMov          VARCHAR(100);
DECLARE DescripcionMovDet       VARCHAR(100);
DECLARE Decimal_Cero            DECIMAL;
DECLARE Programa                VARCHAR(100);
DECLARE Entero_Cero             INT;
DECLARE Cadena_Vacia            CHAR;
DECLARE Fecha_Vacia             DATE;
DECLARE Estatus_Pagado          CHAR(1);
DECLARE ActPagado               INT;
DECLARE TipoInstrumentoID       INT(11);
DECLARE For_SucOrigen           CHAR(3);
DECLARE For_SucCliente          CHAR(3);


SET SalidaSI                :='S';
SET SalidaNO                :='N';
SET Pol_Automatica          :='A';
SET ConceptoCon             :=803;
SET DescripcionMov          :='APOYO ESCOLAR';
SET DescripcionMovDet       :='PAGO APOYO ESCOLAR';
SET Decimal_Cero            :=0.0;
SET Programa                :='PAGOAPOYOESCOLARPRO';
SET Entero_Cero             :=0;
SET Cadena_Vacia            :='';
SET Fecha_Vacia             :='1900-01-01';
SET Estatus_Pagado          :='P';
SET ActPagado               :=2;
SET TipoInstrumentoID       :=4;
SET For_SucOrigen           := '&SO';
SET For_SucCliente          := '&SC';

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                 'esto le ocasiona. Ref: SP-PAGOAPOYOESCOLARPRO');
            SET Var_Control :='apoyoEscSolID';
        END;


    SELECT FechaSistema, MonedaBaseID INTO Var_FechaSistema, Var_MonedaBaseID
            FROM PARAMETROSSIS LIMIT 1;
    SET Var_FechaSistema    := IFNULL(Var_FechaSistema, Fecha_Vacia);
    SET Var_MonedaBaseID    :=IFNULL(Var_MonedaBaseID, Entero_Cero);
    SET Var_CentroCostosID  := FNCENTROCOSTOS(Aud_Sucursal);


    IF(IFNULL(Par_ApoyoEscSolID,Entero_Cero )= Entero_Cero)THEN
        SET Par_NumErr  :=1;
        SET Par_ErrMen  :=' El Folio de Apoyo Escolar se encuentra Vacio';
        SET Var_Control :='apoyoEscSolID';
        LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS (SELECT ApoyoEscSolID
                FROM APOYOESCOLARSOL
                    WHERE ApoyoEscSolID =Par_ApoyoEscSolID)THEN
        SET Par_NumErr  :=2;
        SET Par_ErrMen  :=CONCAT('El Folio ', CONVERT(Par_ApoyoEscSolID,CHAR) ,' Indicado no Existe');
        SET Var_Control :='apoyoEscSolID';
        LEAVE ManejoErrores;
    END IF;
    SELECT CtaContaApoyoEsc,        CCApoyoEscolar
        INTO Var_CtaContaApoyoEsc, Var_CCApoyoEscolar
        FROM PARAMETROSCAJA
        WHERE  EmpresaID = Par_EmpresaID;

    SET Var_CtaContaApoyoEsc :=IFNULL(Var_CtaContaApoyoEsc,Cadena_Vacia);
    SET Var_CCApoyoEscolar :=IFNULL(Var_CCApoyoEscolar,Cadena_Vacia);

    SELECT  Ap.Monto,       Ap.ClienteID,   Cli.SucursalOrigen
        INTO  Var_MontoPagar,Var_ClienteID, Var_SucCliente
                FROM APOYOESCOLARSOL Ap
                    INNER JOIN CLIENTES Cli ON Cli.ClienteID = Ap.ClienteID
                WHERE ApoyoEscSolID = Par_ApoyoEscSolID;

        SET Var_ClienteID   := IFNULL(Var_ClienteID,Entero_Cero);
        SET Var_MontoPagar  := IFNULL(Var_MontoPagar,Decimal_Cero);
        SET Var_SucCliente  :=IFNULL(Var_SucCliente, Entero_Cero);


            IF LOCATE(For_SucOrigen, Var_CCApoyoEscolar) > 0 THEN
                SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
            ELSE
                IF LOCATE(For_SucCliente, Var_CCApoyoEscolar) > 0 THEN
                        IF (Var_SucCliente > 0) THEN
                            SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
                        ELSE
                            SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
                        END IF;
                ELSE
                    SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
                END IF;
            END IF;


    CALL DETALLEPOLIZAALT(
        Par_EmpresaID,          Par_PolizaID,       Var_FechaSistema,       Var_CentroCostosID, Var_CtaContaApoyoEsc,
        Var_ClienteID,          Var_MonedaBaseID,   Var_MontoPagar,         Entero_Cero,        DescripcionMovDet,
        Par_ApoyoEscSolID,      Programa,           TipoInstrumentoID,      Cadena_Vacia,       0,
        Cadena_Vacia,           SalidaNO,           Par_NumErr,             Par_ErrMen,         Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);




SET Par_PersonaRecibe := IFNULL(Par_PersonaRecibe,Cadena_Vacia);
IF(Par_PersonaRecibe = Cadena_Vacia)THEN
    SET Par_PersonaRecibe :=(SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Var_ClienteID);
END IF;
    CALL APOYOESCOLARSOLACT(
            Var_ClienteID,          Par_ApoyoEscSolID,  Estatus_Pagado, Entero_Cero,        Cadena_Vacia,
            Aud_NumTransaccion,     Par_PolizaID,           Par_CajaID,     Par_SucursalCajaID, Par_PersonaRecibe,
            ActPagado,              SalidaNO,           Par_NumErr,     Par_ErrMen,         Par_EmpresaID,
            Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr  :=0;
        SET Par_ErrMen  :=' Apoyo Escolar Aplicado Correctamente.';
        SET Var_Control :='apoyoEscSolID';
        LEAVE ManejoErrores;

END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            '' AS control,
            Par_PolizaID AS consecutivo;
END IF;

END TerminaStore$$