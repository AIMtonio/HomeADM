-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACAJAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACAJAPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZACAJAPRO`(

    Par_Empresa             INT,
    Par_Poliza              BIGINT,
    Par_Fecha               DATE,
    Par_ConceptoOpera       INT,
    Par_Instrumento         VARCHAR(20),

    Par_Moneda              INT,
    Par_Cargos              DECIMAL(12,2),
    Par_Abonos              DECIMAL(12,2),
    Par_DescripcionMov      VARCHAR(100),
    Par_ReferDetPol         VARCHAR(50),

    Par_SucCliente          INT(11),
    Par_RemesaCatalogoID    INT,
    Par_TipoInstrumentoID   INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),

    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore:BEGIN

DECLARE Var_Nomenclatura    VARCHAR(30);
DECLARE Var_CuentaMayor     VARCHAR(12);
DECLARE Var_NomenclaturaCR  VARCHAR(30);
DECLARE Var_NomenclaturaSO  CHAR(2);
DECLARE Var_NomenclaturaSC  CHAR(3);
DECLARE Var_CCostosRemesa   VARCHAR(30);


DECLARE Procedimiento       VARCHAR(20);
DECLARE Cuenta_Vacia        CHAR(15);
DECLARE Var_Cuenta          VARCHAR(50);
DECLARE Var_CentroCostosID  INT(11);
DECLARE Entero_Cero         INT;
DECLARE Salida_NO           CHAR(1);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE For_CueMayor        CHAR(3);
DECLARE For_SucOrigen       CHAR(3);
DECLARE For_SucCliente      CHAR(3);
DECLARE SalidaSI                CHAR(1);
DECLARE Decimal_Cero        DECIMAL(14,2);


SET Procedimiento       :='POLIZACAJAPRO';
SET Cuenta_Vacia        := '000000000000000';
SET Var_Cuenta          := '000000000000000';
SET Var_CentroCostosID  := 0;
SET Entero_Cero         := 0;
SET Cadena_Vacia        :='';
SET For_CueMayor        := '&CM';
SET For_SucOrigen       := '&SO';
SET For_SucCliente      := '&SC';
SET SalidaSI            :='S';
SET Decimal_Cero        := 0.00;

SET Par_RemesaCatalogoID := IFNULL(Par_RemesaCatalogoID, Entero_Cero);

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                 'esto le ocasiona. Ref: SP-POLIZACAJAPRO');
        END;


IF(Par_RemesaCatalogoID != Entero_Cero ) THEN

    SELECT  CuentaCompleta, CCostosRemesa
     INTO   Var_Cuenta,Var_CCostosRemesa
            FROM REMESACATALOGO
            WHERE RemesaCatalogoID = Par_RemesaCatalogoID;

        SET Var_Cuenta      := IFNULL(Var_Cuenta, Cuenta_Vacia);


    IF LOCATE(For_SucOrigen, Var_CCostosRemesa) > Entero_Cero THEN
        SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
    ELSE
        IF LOCATE(For_SucCliente, Var_CCostosRemesa) > Entero_Cero THEN
            SET Var_CentroCostosID := FNCENTROCOSTOS(Par_SucCliente);
        ELSE
            SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
        END IF;
    END IF;


ELSE

    SELECT  Cuenta,             Nomenclatura,       NomenclaturaCR
     INTO   Var_CuentaMayor,    Var_Nomenclatura,   Var_NomenclaturaCR
        FROM  CUENTASMAYORCAJA Ctm
        WHERE Ctm.ConceptoCajaID    = Par_ConceptoOpera;

    SET Var_Nomenclatura := IFNULL(Var_Nomenclatura, Cadena_Vacia);
    SET Var_NomenclaturaCR := IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

    IF(Var_Nomenclatura = Cadena_Vacia) THEN
        SET Var_Cuenta := Cuenta_Vacia;
    ELSE
        SET Var_Cuenta  := Var_Nomenclatura;

        IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero THEN
            SET Var_NomenclaturaSO := Aud_Sucursal;
            IF (Var_NomenclaturaSO != Cadena_Vacia) THEN
                SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
            END IF;
        ELSE
            IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero THEN
                     SET Var_NomenclaturaSC := Par_SucCliente;
                    IF (Var_NomenclaturaSC != Cadena_Vacia AND Par_SucCliente >Entero_Cero) THEN
                        SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
                    ELSE
                        SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
                    END IF;

            ELSE
                SET Var_CentroCostosID:= FNCENTROCOSTOS(Aud_Sucursal);
            END IF;
        END IF;
    END IF;


    IF LOCATE(For_CueMayor, Var_Cuenta) > Entero_Cero THEN
            SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
    END IF;
END IF;

SET Var_Cuenta = REPLACE(Var_Cuenta, '-', Cadena_Vacia);

CALL DETALLEPOLIZAALT (
    Par_Empresa,        Par_Poliza,         Par_Fecha,              Var_CentroCostosID,           Var_Cuenta,
    Par_Instrumento,    Par_Moneda,         Par_Cargos,             Par_Abonos,             Par_DescripcionMov,
    Par_ReferDetPol,    Procedimiento,      Par_TipoInstrumentoID,  Cadena_Vacia,           Decimal_Cero,
    Cadena_Vacia,       Par_Salida,         Par_NumErr,             Par_ErrMen,             Aud_Usuario,
    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_PolizaID AS consecutivo;
END IF;

END TerminaStore$$