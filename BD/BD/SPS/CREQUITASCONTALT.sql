-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREQUITASCONTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREQUITASCONTALT`;
DELIMITER $$

CREATE PROCEDURE `CREQUITASCONTALT`(
    Par_CreditoID       BIGINT,         -- Id del credito
    Par_UsuarioID       INT,            -- Id del usuario
    Par_PuestoID        VARCHAR(10),    -- Id del puesto
    Par_FechaRegistro   DATE,           -- Fecha registro
    Par_MontoComisiones DECIMAL(12,2),  -- Monto comisiones
    Par_PorceComisiones DECIMAL(12,4),  -- Porcentaje de comisiones
    Par_MontoMoratorios DECIMAL(12,2),  -- Monto de moratorios
    Par_PorceMoratorios DECIMAL(12,4),  -- Porcentaje de moratorios
    Par_MontoInteres    DECIMAL(12,2),  -- Monto intereses
    Par_PorceInteres    DECIMAL(12,4),  -- Porcentaje intereses
    Par_MontoCapital    DECIMAL(12,2),  -- Monto capital
    Par_PorceCapital    DECIMAL(12,4),  -- Porcentaje capital

    Par_Salida          CHAR(1),            -- Campo a la qu hace referencia
    INOUT Par_NumErr    INT,                -- Parametro del numero de Error
    INOUT Par_ErrMen    VARCHAR(400),       -- Parametro del Mensaje de Error

    Par_EmpresaID       INT(11),            -- Parametro de auditoria ID de la empresa
    Aud_Usuario         INT(11),            -- Parametro de auditoria ID del usuario
    Aud_FechaActual     DATETIME,           -- Parametro de auditoria Fecha actual
    Aud_DireccionIP     VARCHAR(15),        -- Parametro de auditoria Direccion IP
    Aud_ProgramaID      VARCHAR(50),        -- Parametro de auditoria Programa

    Aud_Sucursal        INT(11),            -- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  BIGINT(20)          -- Parametro de auditoria Numero de la transaccion
     )
TerminaStore: BEGIN

-- VARIABLES
DECLARE Var_ProdCred    INT;               -- Variable para guardar el producto credito
DECLARE Var_SaldoCap    DECIMAL(12,2);     -- Variable para guardar el saldo capital
DECLARE Var_SaldoInt    DECIMAL(12,2);     -- Varuiable para guardar el saldo interes
DECLARE Var_SaldoMora   DECIMAL(12,2);     -- Variable para guardar el saldo moratorio
DECLARE Var_SaldoAcces  DECIMAL(12,2);     -- VAriable para guardar el saldo Acces

DECLARE Var_Consecutivo INT;               -- Variable para el consecutivo de la tabla
DECLARE Var_DescriPues  char(150);         -- Variable par la descripcion del puesto

-- CONSTANTES
DECLARE Cadena_Vacia    char(1);          -- Cadena vacia
DECLARE Entero_Cero     INT;              -- Entero Cero
DECLARE SalidaNO        char(1);          -- Salida No
DECLARE SalidaSI        char(1);          -- SAlida Si
DECLARE Dif_Interes     DECIMAL(12,2);    -- Diferente interes
DECLARE esContingente   VARCHAR(50);      -- es de tipo contingente
DECLARE Var_Control     VARCHAR(100);         -- control 


SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET SalidaNO        := 'N';
SET SalidaSI        := 'S';
SET Dif_Interes     := 0.50;
SET esContingente   := "CondonacionCarteraContingente";


ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
   SET Par_NumErr  = 999;
   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
              'Disculpe las molestias que esto le ocasiona. Ref: SP-CREQUITASCONTALT');
   SET Var_Control := 'sqlException' ;

END;

SELECT FechaSistema into Par_FechaRegistro
    FROM PARAMETROSSIS;

        SELECT  ProductoCreditoID,
            (ifnull(SaldCapVenNoExi, 0) + ifnull(SaldoCapVencido, 0) +
             ifnull(SaldoCapAtrasad, 0) + ifnull(SaldoCapVigent, 0)  ),

            (ifnull(SaldoInterOrdin, 0) + ifnull(SaldoInterAtras, 0) +
             ifnull(SaldoInterProvi, 0) + ifnull(SaldoIntNoConta, 0) +
             ifnull(SaldoInterVenc, 0)  ),

            (ifnull(SaldoMoratorios,0) + ifnull(SaldoMoraVencido,0) +
            ifnull(SaldoMoraCarVen,0)),

            (ifnull(SaldComFaltPago, 0) +
             ifnull(SaldoOtrasComis, 0) )
        INTO
            Var_ProdCred,   Var_SaldoCap, Var_SaldoInt, Var_SaldoMora, Var_SaldoAcces

        FROM CREDITOSCONT
        WHERE CreditoID = Par_CreditoID;


SET Var_ProdCred    := ifnull(Var_ProdCred, Entero_Cero);
SET Var_SaldoCap    := ifnull(Var_SaldoCap, Entero_Cero);
SET Var_SaldoInt    := ifnull(Var_SaldoInt, Entero_Cero);
SET Var_SaldoMora   := ifnull(Var_SaldoMora, Entero_Cero);
SET Var_SaldoAcces  := ifnull(Var_SaldoAcces, Entero_Cero);

SET Var_SaldoInt    := round(Var_SaldoInt, 2);

IF(Var_ProdCred = Entero_Cero) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '001' AS NumErr,
               'Credito Incorrecto.' AS ErrMen,
               'ProducCreditoID' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 1;
        SET Par_ErrMen := 'Credito Incorrecto' ;
        LEAVE TerminaStore;
    END IF;
END IF;

SELECT Descripcion into Var_DescriPues
    FROM PUESTOS
    WHERE ClavePuestoID = Par_PuestoID;

SET Var_DescriPues  := ifnull(Var_DescriPues, Cadena_Vacia);


IF(Var_DescriPues = Cadena_Vacia) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '002' AS NumErr,
               concat('Puesto Incorrecto. ', Par_PuestoID) AS ErrMen,
               'ClavePuestoID' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 2;
        SET Par_ErrMen := 'Puesto Incorrecto.' ;
        LEAVE TerminaStore;
    END IF;
END IF;

SET Par_MontoComisiones := ifnull(Par_MontoComisiones, Entero_Cero);

IF(Par_MontoComisiones < Entero_Cero or Par_MontoComisiones > Var_SaldoAcces) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '003' AS NumErr,
               'Monto de Condonacion de Accesorios Incorrecto.' AS ErrMen,
               'MontoComisiones' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 3;
        SET Par_ErrMen := 'Monto de Condonacion de Accesorios Incorrecto.' ;
        LEAVE TerminaStore;
    END IF;
END IF;

SET Par_PorceComisiones := ifnull(Par_PorceComisiones, Entero_Cero);

IF(Par_PorceComisiones < Entero_Cero) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '004' AS NumErr,
               'Porcentaje de Accesorios Incorrecto.' AS ErrMen,
               'PorceComisiones' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 4;
        SET Par_ErrMen := 'Porcentaje de Accesorios Incorrecto.' ;
        LEAVE TerminaStore;
    END IF;

END IF;

SET Par_MontoMoratorios := ifnull(Par_MontoMoratorios, Entero_Cero);

IF(Par_MontoMoratorios < Entero_Cero or Par_MontoMoratorios > Var_SaldoMora) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '005' AS NumErr,
               'Monto de Condonacion de Moratorios Incorrecto.' AS ErrMen,
               'MontoMoratorios' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 5;
        SET Par_ErrMen := 'Monto de Condonacion de Moratorios Incorrecto.' ;
        LEAVE TerminaStore;
    END IF;
END IF;

SET Par_PorceMoratorios := ifnull(Par_PorceMoratorios, Entero_Cero);

IF(Par_PorceMoratorios < Entero_Cero) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '006' AS NumErr,
               'Porcentaje de Moratorios Incorrecto.' AS ErrMen,
               'PorceMoratorios' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 6;
        SET Par_ErrMen := 'Porcentaje de Moratorios Incorrecto.' ;
        LEAVE TerminaStore;
    END IF;

END IF;

SET Par_MontoInteres := ifnull(Par_MontoInteres, Entero_Cero);

IF(Par_MontoInteres < Entero_Cero or (Par_MontoInteres - Var_SaldoInt > Dif_Interes )) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '007' AS NumErr,
               'Monto de Condonacion de Interes Incorrecto.' AS ErrMen,
               'MontoInteres' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 7;
        SET Par_ErrMen := 'Monto de Condonacion de Interes Incorrecto.' ;
        LEAVE TerminaStore;
    END IF;
END IF;

SET Par_PorceInteres := ifnull(Par_PorceInteres, Entero_Cero);

IF(Par_PorceInteres < Entero_Cero) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '008' AS NumErr,
               'Porcentaje de Interes Incorrecto.' AS ErrMen,
               'PorceInteres' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 8;
        SET Par_ErrMen := 'Porcentaje de Interes Incorrecto.' ;
        LEAVE TerminaStore;
    END IF;

END IF;

SET Par_MontoCapital := ifnull(Par_MontoCapital, Entero_Cero);

IF(Par_MontoCapital < Entero_Cero or Par_MontoCapital > Var_SaldoCap) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '009' AS NumErr,
               'Monto de Condonacion de Capital Incorrecto.' AS ErrMen,
               'MontoCapital' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 9;
        SET Par_ErrMen := 'Monto de Condonacion de Capital Incorrecto.' ;
        LEAVE TerminaStore;
    END IF;
END IF;

SET Par_PorceCapital := ifnull(Par_PorceCapital, Entero_Cero);

IF(Par_PorceCapital < Entero_Cero) THEN
    IF(Par_Salida = SalidaSI) THEN
        SELECT '010' AS NumErr,
               'Porcentaje de Capital Incorrecto.' AS ErrMen,
               'PorceInteres' AS control,
                0 AS consecutivo;
        LEAVE TerminaStore;
    END IF;
    IF(Par_Salida = SalidaNO) THEN
        SET Par_NumErr := 10;
        SET Par_ErrMen := 'Porcentaje de Capital Incorrecto.' ;
        LEAVE TerminaStore;
    END IF;

END IF;

SELECT MAX(Consecutivo) INTO Var_Consecutivo
    FROM CREQUITASCONT
    WHERE CreditoID = Par_CreditoID;

SET Var_Consecutivo := IFNULL(Var_Consecutivo, Entero_Cero);
SET Var_Consecutivo := Var_Consecutivo + 1;

INSERT INTO CREQUITASCONT VALUES(
    Par_CreditoID,          Var_Consecutivo,        Par_UsuarioID,          Par_PuestoID,
    Par_FechaRegistro,      Par_MontoComisiones,    Par_PorceComisiones,    Par_MontoMoratorios,
    Par_PorceMoratorios,    Par_MontoInteres,       Par_PorceInteres,       Par_MontoCapital,
    Par_PorceCapital,       Var_SaldoCap,           Var_SaldoInt,           Var_SaldoMora,
    Var_SaldoAcces,         Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,
    Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion  );

    
    SET Par_NumErr  := Entero_Cero;
    SET Var_Control := 'creditoID';
    SET Par_ErrMen  := 'Condonacion Realizada Exitosamente.' ;

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_CreditoID AS consecutivo;
END IF;

END TerminaStore$$