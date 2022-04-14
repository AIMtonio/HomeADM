-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVDEPGARANTIALIQ
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVDEPGARANTIALIQ`;
DELIMITER $$


CREATE PROCEDURE `REVDEPGARANTIALIQ`(
    Par_CuentaAhoID         BIGINT(12),
    Par_ClienteID           BIGINT,
    Par_NumeroMov           BIGINT,
    Par_Fecha               DATE,
    Par_FechaAplicacion     DATE,

    Par_NatMovimiento       CHAR(1),
    Par_CantidadMov         DECIMAL(12,2),
    Par_DescripcionMov      VARCHAR(150),
    Par_ReferenciaMov       VARCHAR(35),
    Par_TipoMovAhoID        CHAR(4),

    Par_MonedaID            INT,
    Par_SucCliente          INT,
    Par_AltaEncPoliza       CHAR(1),
    Par_ConceptoCon         INT,
    INOUT Par_Poliza        BIGINT,

    Par_AltaPoliza          CHAR(1),
    Par_ConceptoAho         INT,
    Par_NatConta            CHAR(1),
    Par_TranGarantia        BIGINT,
    Par_FormaPagoGL         VARCHAR(20),

    Par_NumErr              INT(11),
    Par_ErrMen              VARCHAR(400),
    Par_Consecutivo         BIGINT,

    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)

    )

TerminaStore: BEGIN

DECLARE Con_BloqGarantiaLiq     INT;
DECLARE Nat_Bloqueo             CHAR(1);
DECLARE Nat_Desbloqueo          CHAR(1);
DECLARE Entero_Cero             INT;
DECLARE Con_BloqRevGarLiq       INT;
DECLARE DesDesbloqGarantiLiq    VARCHAR(50);
DECLARE SalidaPantallaNo        CHAR(1);
DECLARE SalidaPantallaSi        CHAR(1);
DECLARE Efectivo                VARCHAR(15);
DECLARE EstatusCreditoInactivo  CHAR(1);


DECLARE Var_BloqueoID           INT(11);
DECLARE Var_Control             VARCHAR(50) ;
DECLARE Cadena_Vacia            CHAR(1);

SET Con_BloqGarantiaLiq     :=8;
SET Nat_Bloqueo             :='B';
SET Nat_Desbloqueo          :='D';
SET Entero_Cero             :=0;
SET Cadena_Vacia            :='';
SET Con_BloqRevGarLiq       :=8;
SET DesDesbloqGarantiLiq    :='REVERSA DEPOSITO GARANTIA LIQUIDA';
SET SalidaPantallaNo        :='N';
SET SalidaPantallaSi        :='S';
SET Efectivo                :='DE';
SET EstatusCreditoInactivo  :='I';


ManejoErrores: BEGIN
            DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr := 999;
                    SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                ' esto le ocasiona. Ref: SP-REVDEPGARANTIALIQ');
                END;

SELECT BloqueoID  INTO Var_BloqueoID
    FROM BLOQUEOS
        WHERE IFNULL(FolioBloq,Entero_Cero)=Entero_Cero
        AND NatMovimiento=Nat_Bloqueo
        AND TiposBloqID=Con_BloqGarantiaLiq
        AND Referencia=Par_ReferenciaMov
        AND Par_TranGarantia=NumTransaccion;

SET Var_BloqueoID   :=IFNULL(Var_BloqueoID,Entero_Cero);
IF(Var_BloqueoID =Entero_Cero)THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  := CONCAT("No Existe un Bloqueo que corresponda con la Garantia Liquida");
        SET Var_Control := 'tipoOperacion' ;
        LEAVE ManejoErrores;
END IF;

IF EXISTS(SELECT Cre.CreditoID FROM CREDITOS Cre
                WHERE Cre.CreditoID=   Par_ReferenciaMov
                AND Cre.Estatus !=EstatusCreditoInactivo)THEN

        SET Par_NumErr  := 2;
        SET Par_ErrMen  := CONCAT("El Credito ya fue Autorizado");
        SET Var_Control := 'tipoOperacion' ;
        LEAVE ManejoErrores;

END IF;

CALL BLOQUEOSPRO(Var_BloqueoID, Nat_Desbloqueo,     Par_CuentaAhoID,        Par_Fecha,          Par_CantidadMov,
                Par_Fecha,      Con_BloqRevGarLiq,  DesDesbloqGarantiLiq,   Par_ReferenciaMov,      Cadena_Vacia,
            Cadena_Vacia,   SalidaPantallaNo, Par_NumErr, Par_ErrMen,   Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
            Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);


    IF(Par_NumErr <>  Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;




 IF(Par_FormaPagoGL = Efectivo)THEN
    CALL CONTAAHORROPRO(Par_CuentaAhoID,        Par_ClienteID   ,       Par_NumeroMov   ,       Par_Fecha,          Par_FechaAplicacion,
                        Par_NatMovimiento,      Par_CantidadMov,        Par_DescripcionMov,     Par_ReferenciaMov,  Par_TipoMovAhoID,
                        Par_MonedaID,           Par_SucCliente,         Par_AltaEncPoliza,      Par_ConceptoCon,    Par_Poliza,
                        Par_AltaPoliza,         Par_ConceptoAho,        Par_NatConta,           Par_NumErr,         Par_ErrMen,
                        Par_Consecutivo,        Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
 END IF;
    SET Par_NumErr := 0;
    SET Par_ErrMen := "Reversa Realizada con Exito";
    SET Var_Control  := 'tipoOperacion' ;





END ManejoErrores;

 SELECT  Par_NumErr AS NumErr,
        Par_ErrMen AS ErrMen,
        Var_Control AS control,
        Par_Poliza AS consecutivo;


END TerminaStore$$