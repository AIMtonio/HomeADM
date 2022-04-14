-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRMASIMPRESIONFITPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FIRMASIMPRESIONFITPRO`;DELIMITER $$

CREATE PROCEDURE `FIRMASIMPRESIONFITPRO`(
# ===============================================================================================================
# ---------- PROCEDIMIENTO PARA LLAMAR ALTA O ACTUALIZACION DE RESGITROS A LA TABLA FIRMASIMPRESIONFIT ----------
# ===============================================================================================================
    Par_Cuenta                  BIGINT(12),     -- no. de cuenta para cual se genera la caratula de contrato Par_CuentaAhoID
    Par_Opcion                  TINYINT,        -- Desde donde se llama el procedimiento 1) Pantalla de impresion de formato, 2) Modificacion del registro

    Par_Salida                  CHAR(1),        -- Manejo de Errores
    INOUT   Par_NumErr          INT(11),        -- Manejo de Errores
    INOUT   Par_ErrMen          VARCHAR(400),   -- Manejo de Errores

    Aud_EmpresaID               INT,            -- Parametro de Auditoria
    Aud_Usuario                 INT,            -- Parametro de Auditoria
    Aud_FechaActual             DATETIME,       -- Parametro de Auditoria
    Aud_DireccionIP             VARCHAR(15),    -- Parametro de Auditoria
    Aud_ProgramaID              VARCHAR(50),    -- Parametro de Auditoria
    Aud_Sucursal                INT(11),        -- Parametro de Auditoria
    Aud_NumTransaccion          BIGINT          -- Parametro de Auditoria
    )
TerminaStore: BEGIN

# Declaracion de variables
DECLARE Var_Fecha               DATE;           -- Fecha de Impresion/Modificacion dependiendo del caso
DECLARE Var_RegistroExiste      TINYINT;        -- 0: si el registro no Exixste
DECLARE Var_Control             VARCHAR(200);   -- Manejo de Errores
DECLARE Var_Consecutivo         INT(11);        -- Manejo de Errores

# Declaracion de Constantes
DECLARE Entero_Cero             TINYINT;
DECLARE Opcion_Insertar         TINYINT;
DECLARE Opcion_Actualizar       TINYINT;
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Str_SI                  CHAR(1);
DECLARE Str_NO                  CHAR(1);



# Asigancion de Constantes
SET Entero_Cero         :=  0;
SET Cadena_Vacia        := '';
SET Opcion_Insertar     :=  1;
SET Opcion_Actualizar   :=  2;
SET Str_SI              :=  'S';
SET Str_NO              :=  'N';


ManejoErrores:BEGIN     #bloque para manejar los posibles errores
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que ',
                                        'esto le ocasiona. Ref: SP-FIRMASIMPRESIONFITPRO ');
                SET Var_Control = 'SQLEXCEPTION' ;
            END;
    /*-- VALIDACION DE CAMPOS OBLIGATORIOS */

    IF(Par_Cuenta = Cadena_Vacia) THEN
        SET Par_NumErr   := 01;
        SET Par_ErrMen   := 'La Cuenta Esta Vacia';
        SET Var_Control   := 'clienteID';
        LEAVE ManejoErrores;
    END IF;



    SELECT  PS.FechaSistema
    INTO Var_Fecha
    FROM PARAMETROSSIS PS LIMIT 1;


    SET Var_RegistroExiste := (SELECT  COUNT((SELECT CuentaAhoID FROM FIRMASIMPRESIONFIT  WHERE CuentaAhoID = Par_Cuenta)));

    IF(Par_Opcion = Opcion_Insertar) THEN
    -- desde la Pantalla de Imprimir contrato
        IF(Var_RegistroExiste = Entero_Cero) THEN
            CALL FIRMASIMPRESIONFITALT(Par_Cuenta,   Var_Fecha, Str_NO, Par_NumErr, Par_ErrMen,  Aud_EmpresaID, Aud_Usuario, Aud_FechaActual, Aud_DireccionIP,
            Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);

             IF(Par_NumErr != Entero_Cero) THEN
                    LEAVE ManejoErrores;
                END IF;
        END IF;
    END IF;

    IF (Par_Opcion = Opcion_Actualizar)  THEN
        -- Relacionados a la cuenta
            IF(Var_RegistroExiste != Entero_Cero) THEN
            CALL FIRMASIMPRESIONFITACT(Par_Cuenta, Var_Fecha, Str_NO, Par_NumErr, Par_ErrMen,  Aud_EmpresaID, Aud_Usuario, Aud_FechaActual, Aud_DireccionIP,
                Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);

                 IF(Par_NumErr != Entero_Cero) THEN
                    LEAVE ManejoErrores;
                END IF;
        END IF;
    END IF;


    SET Par_NumErr      := 0;
        SET Par_ErrMen      := CONCAT('Proceso relizado exitosamente');
        SET Var_Control     := 'CuentaAhoID';
        SET Var_Consecutivo := 0;
END ManejoErrores; #fin del manejador de errores


IF (Par_Salida = Str_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen   AS ErrMen,
            Var_Control  AS control,
            Entero_Cero  AS consecutivo;
END IF;


END TerminaStore$$