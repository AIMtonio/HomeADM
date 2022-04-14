-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AJUSTESOBRANTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `AJUSTESOBRANTEPRO`;
DELIMITER $$

CREATE PROCEDURE `AJUSTESOBRANTEPRO`(

    Par_Monto               DECIMAL(14,2),
    Par_CajaID              INT(11),
    Par_Sucursal            INT(11),
    Par_MonedaID            INT(11),
    Par_Clave               VARCHAR(45),
    Par_Contrasenia         VARCHAR(45),
    Par_PolizaID            BIGINT(20),

    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),

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
DECLARE Var_Control             VARCHAR(100);
DECLARE Var_CtaContaSobrante    VARCHAR(50);
DECLARE Var_UsuarioID           INT(11);
DECLARE Var_Contrasenia         VARCHAR(45);
DECLARE Var_UsuarioLogueado     INT(11);
DECLARE Var_MontoMaximoSobra    DECIMAL(14,2);
DECLARE VarControl              VARCHAR(200);


DECLARE Pol_Automatica      CHAR(1);
DECLARE ConceptoCon         INT;
DECLARE DescripcionMov      VARCHAR(100);
DECLARE SalidaNO            CHAR(1);
DECLARE DescripcionMovDet   VARCHAR(100);
DECLARE Programa            VARCHAR(100);
DECLARE SalidaSI            CHAR(1);
DECLARE Entero_Cero         INT;
DECLARE Cadena_Vacia        CHAR;
DECLARE Decimal_Cero        DECIMAL;
DECLARE TipoInstrumentoID   INT(11);
DECLARE Var_CentroCostosID  INT(11);


SET Pol_Automatica          :='A';
SET ConceptoCon             := 410;
SET DescripcionMov          :='AJUSTE POR SOBRANTE';
SET SalidaNO                :='N';
SET DescripcionMovDet       :='SOBRANTES DE CAJEROS';
SET Programa                :='AJUSTESOBRANTEPRO';
SET SalidaSI                :='S';
SET Entero_Cero             :=0;
SET Cadena_Vacia            :='';
SET Decimal_Cero            :=0.0;
SET TipoInstrumentoID       :=7;
SET Var_CentroCostosID      :=0;

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                        'esto le ocasiona. Ref: SP-AJUSTESOBRANTEPRO');
            SET VarControl := 'sqlException';
        END;


    SELECT  MontoMaximoSobra INTO Var_MontoMaximoSobra
        FROM PARAMFALTASOBRA
            WHERE SucursalID = Par_Sucursal;

    SELECT  FechaSistema, CtaContaSobrante
        INTO Var_FechaSistema, Var_CtaContaSobrante
        FROM PARAMETROSSIS
            WHERE EmpresaID = Par_EmpresaID;

    SELECT UsuarioID, Contrasenia INTO Var_UsuarioID, Var_Contrasenia
        FROM USUARIOS
            WHERE Clave = Par_Clave;

    SELECT UsuarioID INTO Var_UsuarioLogueado
        FROM CAJASVENTANILLA
            WHERE CajaID    = Par_CajaID
            AND SucursalID  = Par_Sucursal;

    SET Var_CtaContaSobrante    :=IFNULL(Var_CtaContaSobrante,Cadena_Vacia);
    SET Var_Contrasenia         :=IFNULL(Var_Contrasenia,Cadena_Vacia);
    SET Var_UsuarioID           :=IFNULL(Var_UsuarioID,Entero_Cero);
    SET Var_UsuarioLogueado     :=IFNULL(Var_UsuarioLogueado,Entero_Cero);

    IF(IFNULL(Par_Clave, Cadena_Vacia) = Cadena_Vacia)THEN
        SET Par_NumErr  := 2;
        SET Par_ErrMen  := CONCAT("La Clave del Usuario que Autoriza se encuentra Vacia ");
        SET Var_Control  := 'claveUsuarioAut' ;
        LEAVE ManejoErrores;
    END IF;
    IF(Par_Contrasenia = Cadena_Vacia)THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  := CONCAT("La ContraseÃ±a del Usuario que Autoriza se Encuentra Vacia ");
        SET Var_Control  := 'contraseniaAut' ;
        LEAVE ManejoErrores;
    END IF;
    IF(Var_Contrasenia != Par_Contrasenia)THEN
        SET Par_NumErr  := 3;
        SET Par_ErrMen  := CONCAT("La ContraseÃ±a no Coincide con el Usuario Indicado ");
        SET Var_Control  := 'claveUsuarioAut' ;
        LEAVE ManejoErrores;
    END IF;

    IF(Var_UsuarioLogueado = Var_UsuarioID)THEN
        SET Par_NumErr  := 4;
        SET Par_ErrMen  := CONCAT("El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza");
        SET Var_Control := 'claveUsuarioAut' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Monto, Decimal_Cero) > Var_MontoMaximoSobra )THEN
        SET Par_NumErr  := 5;
        SET Par_ErrMen  := CONCAT("Se Excede el Monto Maximo  por Sobrante");
        SET Var_Control := 'montoSobrante' ;
        LEAVE ManejoErrores;
    END IF;

    SET Var_CentroCostosID := FNCENTROCOSTOS(Par_Sucursal);

    CALL DETALLEPOLIZAALT(
        Par_EmpresaID,          Par_PolizaID,       Var_FechaSistema,       Var_CentroCostosID, Var_CtaContaSobrante,
        Var_UsuarioLogueado,    Par_MonedaID,       Entero_Cero,            Par_Monto,          DescripcionMovDet,
        Par_CajaID,             Programa,           TipoInstrumentoID,      Cadena_Vacia,       Decimal_Cero,
        Cadena_Vacia,           SalidaNO,           Par_NumErr,             Par_ErrMen,         Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

        SET Par_NumErr  := 0;
        SET Par_ErrMen  := CONCAT("Ajuste Realizado Correctamente");
        SET Var_Control := 'tipoOperacion' ;

END ManejoErrores;
IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_PolizaID AS consecutivo;
END IF;


END TerminaStore$$