
-- CUENTAAHOTARDEBACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTAAHOTARDEBACT`;

DELIMITER $$
CREATE PROCEDURE `CUENTAAHOTARDEBACT`(
-- ---------------------------------------------------------------------------------
-- SP PARA ACTUALIZAR EL BLOQUEO DE SALDOS
-- ---------------------------------------------------------------------------------
    Par_CuentaAhoID             BIGINT(20),     -- Identificador de la cuenta de ahorro
    Par_Fecha                   DATE,           -- Fecha de actualizacion
    Par_MontoOperacion          DECIMAL(12,2),  -- Monto en pesos de la transaccion
    Par_NumAct                  TINYINT(1),     -- Tipo de actualizacion a realizar

    Par_Salida                  CHAR    (1),
    INOUT Par_NumErr            INT     (11),   -- PARAMETRO DE SALIDA CON EL NUMERO DE ERROR
    INOUT Par_ErrMen            VARCHAR (400),  -- PARAMETRO DE SALIDA CON EL MENSAJE DE ERROR
    Aud_EmpresaID               INT     (11),   -- Auditoria
    Aud_Usuario                 INT     (11),   -- Auditoria

    Aud_FechaActual             DATE,           -- Auditoria
    Aud_DireccionIP             VARCHAR (20),   -- Auditoria
    Aud_ProgramaID              VARCHAR (50),   -- Auditoria
    Aud_Sucursal                INT     (11),   -- Auditoria
    Aud_NumTransaccion          BIGINT  (20)    -- Auditoria
)

TerminaStore:BEGIN

    -- DECLARACION DE VARIBALES
    DECLARE Var_Control             VARCHAR(20);
    DECLARE Var_FechaSistema        DATE;

    -- DECLARACION DE CONSTANTES
    DECLARE Fecha_Vacia             DATE;           -- Fecha vacia
    DECLARE Entero_Cero             INT(11);        -- Entero  cero
    DECLARE SalidaSI                CHAR(1);        -- Genera una salida
    DECLARE SalidaNO                CHAR(1);
    DECLARE Act_BloqueoSaldo        INT(11);        -- Actualizacion de Bloqueo de Saldo
    DECLARE Act_DesbloqueoSaldo     INT(11);        -- Actualizacion de Desbloqueo de Saldo

    -- ASIGNACION DE CONSTANTES
    SET Fecha_Vacia             :=  '1900-01-01';   -- Fecha Vacia
    SET Entero_Cero             :=  0;              -- Entero 0
    SET SalidaSI                :=  'S';            -- El Store SI genera una Salida
    SET SalidaNO                :=  'N';
    SET Act_BloqueoSaldo        :=  1;
    SET Act_DesbloqueoSaldo     :=  2;

    ManejoErrores: BEGIN

       DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-CUENTAAHOTARDEBACT');
            SET Var_Control = 'SQLEXCEPTION';
        END;

        SELECT FechaSistema INTO Var_FechaSistema
            FROM PARAMETROSSIS WHERE EmpresaID = Aud_EmpresaID;

        IF(Par_CuentaAhoID = Entero_Cero) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'La Cuenta de Ahorro esta vacia';
            SET Var_Control := 'cuentaAhoID';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_Fecha = Fecha_Vacia) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'La fecha esta vacia';
            SET Var_Control := 'Fecha';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_NumAct = Entero_Cero) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'El Numero de Actualizacion esta vacio';
            SET Var_Control := 'NumAct';
            LEAVE ManejoErrores;
        END IF;

        -- Validacion de Monto
        IF( Par_MontoOperacion = Entero_Cero OR Par_MontoOperacion < Entero_Cero) THEN
            SET Par_NumErr  := 1312;
            SET Par_ErrMen  := 'La Cantidad debe de ser mayor que cero.';
            SET Var_Control := 'cuentaAhoID';
            LEAVE ManejoErrores;
        END IF;

        IF( Par_NumAct = Act_BloqueoSaldo ) THEN            

            UPDATE CUENTASAHO SET
                SaldoDispon     = SaldoDispon - Par_MontoOperacion,
                SaldoBloq       = SaldoBloq + Par_MontoOperacion,
                EmpresaID       = Aud_EmpresaID,
                Usuario         = Aud_Usuario,
                FechaActual     = Aud_FechaActual,
                DireccionIP     = Aud_DireccionIP,
                ProgramaID      = Aud_ProgramaID,
                Sucursal        = Aud_Sucursal,
                NumTransaccion  = Aud_NumTransaccion
            WHERE CuentaAhoID = Par_CuentaAhoID;
        END IF;

        IF( Par_NumAct = Act_DesbloqueoSaldo ) THEN

            UPDATE CUENTASAHO SET
                SaldoDispon     = SaldoDispon + Par_MontoOperacion,
                SaldoBloq       = SaldoBloq - Par_MontoOperacion,
                EmpresaID       = Aud_EmpresaID,
                Usuario         = Aud_Usuario,
                FechaActual     = Aud_FechaActual,
                DireccionIP     = Aud_DireccionIP,
                ProgramaID      = Aud_ProgramaID,
                Sucursal        = Aud_Sucursal,
                NumTransaccion  = Aud_NumTransaccion
            WHERE CuentaAhoID = Par_CuentaAhoID;
        END IF;

    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
        Par_ErrMen AS ErrMen,
        Var_Control AS control,
        IFNULL(Par_CuentaAhoID, Entero_Cero) AS consecutivo;
    END IF;

END TerminaStore$$
