-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZALINEACREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZALINEACREPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZALINEACREPRO`(

    Par_PolizaID        BIGINT,
    Par_EmpresaID       INT,
    Par_Fecha           DATE,
    Par_LineaCreditoID  BIGINT,
    Par_ProdCreditoID   INT,

    Par_ConceptoOpera   INT,
    Par_Cargos          DECIMAL(14,4),
    Par_Abonos          DECIMAL(14,4),
    Par_Moneda          INT(11),
    Par_Descripcion     VARCHAR(100),

    Par_Referencia      VARCHAR(50),
    Par_SucursalID      INT(11),
INOUT   Par_NumErr      INT(11),
INOUT   Par_ErrMen      VARCHAR(400),
    Aud_Usuario         INT(11),

    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Var_Cuenta          VARCHAR(50);
DECLARE Var_Instrumento     VARCHAR(20);
DECLARE Var_CentroCostosID  INT(11);
DECLARE Var_ClienteID       INT;
DECLARE Var_SucursalCliente INT;
DECLARE Var_Nomenclatura    VARCHAR(30);
DECLARE Var_NomenclaturaCR  VARCHAR(3);
DECLARE Var_CuentaMayor     VARCHAR(4);
DECLARE Var_NomenclaturaSO  INT;
DECLARE Var_NomenclaturaSC  INT;
DECLARE Var_SubCuentaTP     VARCHAR(5);
DECLARE Var_SubCuentaTM     VARCHAR(5);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Cuenta_Vacia        CHAR(25);
DECLARE Decimal_Cero        DECIMAL(14,2);
DECLARE Entero_Cero         INT;
DECLARE Salida_NO           CHAR(1);

DECLARE For_CueMayor        CHAR(3);
DECLARE For_TipProduc       CHAR(3);
DECLARE For_Moneda          CHAR(3);
DECLARE For_SucOrigen       CHAR(3);
DECLARE For_SucCliente      CHAR(3);

DECLARE Procedimiento       VARCHAR(20);
DECLARE TipoInstrumentoID   INT(11);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Cuenta_Vacia        := '0000000000000000000000000';
SET Decimal_Cero        := 0.0;
SET Entero_Cero         := 0;
SET Salida_NO           := 'N';

SET For_CueMayor        := '&CM';
SET For_TipProduc       := '&TP';
SET For_Moneda          := '&TM';
SET For_SucOrigen       := '&SO';
SET For_SucCliente      := '&SC';

SET Procedimiento       := 'POLIZALINEACREPRO';
SET TipoInstrumentoID   := 26;


SET Var_Cuenta          := '0000000000000000000000000';
SET Var_Instrumento     := CONVERT(Par_LineaCreditoID, CHAR);

SET Var_CentroCostosID  := 0;

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                     'esto le ocasiona. Ref: SP-POLIZALINEACREPRO');
        END;

SET Var_ClienteID := (SELECT ClienteID
                        FROM LINEASCREDITO
                        WHERE LineaCreditoID = Par_LineaCreditoID);

SET Var_SucursalCliente := (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Var_ClienteID);

SELECT  Nomenclatura,       Cuenta,             NomenclaturaCR  INTO
        Var_Nomenclatura,   Var_CuentaMayor,    Var_NomenclaturaCR
    FROM  CUENTASMAYORCAR Ctm
    WHERE Ctm.ConceptoCarID = Par_ConceptoOpera;

SET Var_Nomenclatura    := IFNULL(Var_Nomenclatura, Cadena_Vacia);
SET Var_NomenclaturaCR  := IFNULL(Var_NomenclaturaCR, Cadena_Vacia);

IF(Var_Nomenclatura = Cadena_Vacia) THEN
    SET Var_Cuenta := Cuenta_Vacia;
ELSE
    SET Var_Cuenta  := Var_Nomenclatura;
    IF LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0 THEN
        SET Var_NomenclaturaSC  := Var_SucursalCliente;
        SET Var_NomenclaturaSC  := IFNULL(Var_NomenclaturaSC, Entero_Cero);
        IF (Var_NomenclaturaSC != Entero_Cero) THEN
            SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
        END IF;
    ELSE
        IF LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0 THEN
            SET Var_NomenclaturaSO := Aud_Sucursal;
            IF (Var_NomenclaturaSO != Entero_Cero) THEN
                SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
            END IF;
        ELSE
            SET Var_CentroCostosID:= FNCENTROCOSTOS(Aud_Sucursal);
        END IF;
    END IF;

    IF LOCATE(For_CueMayor, Var_Cuenta) > 0 THEN
        SET Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
    END IF;

    IF LOCATE(For_TipProduc, Var_Cuenta) > 0 THEN
        SELECT SubCuenta INTO Var_SubCuentaTP
            FROM SUBCTAPRODUCCART
            WHERE ProducCreditoID   = Par_ProdCreditoID
              AND ConceptoCarID = Par_ConceptoOpera;
        SET Var_SubCuentaTP := IFNULL(Var_SubCuentaTP, Cadena_Vacia);

        IF (Var_SubCuentaTP != Cadena_Vacia) THEN
            SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipProduc, Var_SubCuentaTP);
        END IF;
    END IF;

    IF LOCATE(For_Moneda, Var_Cuenta) > 0 THEN
        SELECT  SubCuenta INTO Var_SubCuentaTM
            FROM  SUBCTAMONEDACART Sub
            WHERE Sub.MonedaID      = Par_Moneda
              AND Sub.ConceptoCarID = Par_ConceptoOpera;
        SET Var_SubCuentaTM := IFNULL(Var_SubCuentaTM, Cadena_Vacia);
        IF (Var_SubCuentaTM != Cadena_Vacia) THEN
            SET Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
        END IF;
    END IF;
END IF;

SET Var_Cuenta := REPLACE(Var_Cuenta, '-', Cadena_Vacia);

CALL DETALLEPOLIZAALT(
    Par_EmpresaID,          Par_PolizaID,           Par_Fecha,          Var_CentroCostosID,  Var_Cuenta,
    Var_Instrumento,        Par_Moneda,             Par_Cargos,         Par_Abonos,         Par_Descripcion,
    Par_Referencia,         Procedimiento,          TipoInstrumentoID,  Cadena_Vacia,       Decimal_Cero,
    Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Aud_Usuario,
    Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

END ManejoErrores;


END TerminaStore$$