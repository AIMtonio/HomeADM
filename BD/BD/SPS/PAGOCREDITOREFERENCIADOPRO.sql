
-- PAGOCREDITOREFERENCIADOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS PAGOCREDITOREFERENCIADOPRO;
DELIMITER $$


CREATE PROCEDURE PAGOCREDITOREFERENCIADOPRO (
    -- SP DE PROCESO QUE REALIZA EL PAGO DE CREDITO REFERENCIADO
    Par_ClienteID           INT(11),
    Par_CreditoID           BIGINT(12),
    Par_NumCtaInstit        BIGINT(12),
    Par_InstitucionID       INT(11),
    Par_TipoDeposito        CHAR(1),
    
    Par_MontoPagar          DECIMAL(12,2),
    Par_Origen              CHAR(1),
    Par_ModoPago            CHAR(1),
    INOUT Var_Poliza        BIGINT(12),
    INOUT Var_MontoPago     DECIMAL(12,2),

    Par_Salida              CHAR(1),    
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    INOUT Par_Consecutivo   BIGINT,    
    
    -- Parametros de Auditoria
    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),

    Aud_NumTransaccion      BIGINT(20)
)

TerminaStore: BEGIN
    -- DECLACRACION DE VARIABLES
    DECLARE Var_MonedaID            INT(11);                    -- Identificador de la moneda
    DECLARE Var_CuentaID            BIGINT(12);                 -- Identificador de la cuenta de ahorro ligada al crédito
    DECLARE Var_ClienteID           INT(11);                    -- Identificador de cliente ligado al crédito
    DECLARE Var_DescripMov          VARCHAR(50);                -- Descripción del movimiento
    DECLARE Var_Control             VARCHAR(100);               -- Variable de Control

    -- DECLARACION DE CONSTANTES
    DECLARE SalidaSI                CHAR(1);                    -- Salida SI
    DECLARE SalidaNO                CHAR(1);                    -- Salida NO
    
    DECLARE ValorSI                 CHAR(1);                    -- Valor SI
    DECLARE ValorNO                 CHAR(1);                    -- Valor NO
    DECLARE Entero_Cero             INT(11);                    -- Entero Cero
    DECLARE Entero_Cerows           INT(11);                    -- Entero Cero ws
    
    DECLARE Cadena_Vacia            VARCHAR(2);                 -- Cuando el origen del credito es mediante Web Service
    DECLARE NatAbono                CHAR(1);

    DECLARE Var_FechaSistema        DATE;                       -- Fecha del sistema
    DECLARE Var_TipoCanal           INT(11);                    -- Tipo de canal
    DECLARE TipoDepositoCCTA        CHAR(1);

    -- ASIGNACION DE CONSTANTES
    SET SalidaSI                    := 'S';                     -- Salida SI
    SET SalidaNO                    := 'N';                     -- Salida NO
    SET ValorSI                     := 'S';                     -- Valor SI
    SET ValorNO                     := 'N';                     -- Valor NO
    SET Entero_Cero                 := 0;                       -- Entero Cero
    SET Entero_Cerows               := 000;                     -- Entero Cero
    SET Cadena_Vacia				:= '';

    SET NatAbono                    := 'A';
    SET TipoDepositoCCTA            := 'C';
    SET Var_TipoCanal               := 2;

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SET Par_NumErr := 999;
      SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDITOREFERENCIADOPRO');
    END;

    SELECT FechaSistema
        INTO Var_FechaSistema 
    FROM PARAMETROSSIS
        limit 1;

    IF IFNULL(Par_TipoDeposito,Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr    := '01';
        SET Par_ErrMen    := 'El tipo de pago es obligatorio.';
        SET Par_Consecutivo := 0;
        SET Var_Control   :=  'tipoDeposito';
        LEAVE ManejoErrores;
    END IF;

    IF IFNULL(Par_InstitucionID,Entero_Cero) = Entero_Cero THEN
        SET Par_NumErr    := '02';
        SET Par_ErrMen    := 'La Institución bancaria no puede estar vacio.';
        SET Par_Consecutivo := 0;
        SET Var_Control   :=  'institucionID';
        LEAVE ManejoErrores;
    END IF;
    
    -- SE OBTIENE LOS DATOS DEL CREDITO PARA VALIDAR LA RELACIÓN CON EL CLIENTE
    SELECT  Cre.ClienteID, Cre.CuentaID, Cre.MonedaID
        INTO Var_ClienteID, Var_CuentaID,   Var_MonedaID
    FROM CREDITOS Cre,
         PRODUCTOSCREDITO Pro
    WHERE Pro.ProducCreditoID = Cre.ProductoCreditoID
    AND Cre.CreditoID = Par_CreditoID;

    IF IFNULL(Var_ClienteID,Entero_Cero) <> Par_ClienteID THEN
        SET Par_NumErr      := '04';
        SET Par_ErrMen      := 'El Credito proporcionado no corresponde al cliente especificado.';
        SET Par_Consecutivo := 0;
        SET Var_Control     := 'clienteID';
        LEAVE ManejoErrores;
    END IF;

    IF IFNULL(Var_CuentaID,Entero_Cero) = Entero_Cero THEN
        SET Par_NumErr      := '05';
        SET Par_ErrMen      := 'El Credito no esta ligado a una cuenta de ahorro.';
        SET Par_Consecutivo := 0;
        SET Var_Control     := 'cuentaID';
        LEAVE ManejoErrores;
    END IF;

    IF IFNULL(Par_TipoDeposito,Cadena_Vacia) = Cadena_Vacia OR Par_TipoDeposito != TipoDepositoCCTA THEN
        SET Par_NumErr      := '06';
        SET Par_ErrMen      := 'El Tipo de deposito no valido.';
        SET Par_Consecutivo := 0;
        SET Var_Control     := 'tipoDeposito';
        LEAVE ManejoErrores;
    END IF;

    SET Var_DescripMov := CONCAT('DEPOSITO CTA ',(CAST(Var_CuentaID AS CHAR(20))));
    -- SP: PROCESO DE DEPOSITO REFERENCIADO
    CALL DEPOSITOREFEREPRO (Par_InstitucionID,      Par_NumCtaInstit,       Var_FechaSistema,       Var_CuentaID,           Var_DescripMov,
                            NatAbono,               Par_MontoPagar,         Entero_Cero,            Var_TipoCanal,          Par_TipoDeposito,
                            Var_MonedaID,           ValorSI,                Cadena_Vacia,           Cadena_Vacia,           Var_Poliza,
                            SalidaNO,               Par_NumErr,             Par_ErrMen,             Par_Consecutivo,        Aud_EmpresaID,          
                            Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           
                            Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero) THEN
        LEAVE ManejoErrores;
    END IF;

    -- SP: PROCESO DE PAGO DE CRÉDITO
    CALL PAGOPREPAGOCREDITOPRO (Par_CreditoID,  Var_CuentaID,       Par_MontoPagar,     Var_MonedaID,   Aud_EmpresaID,
                                SalidaNO,       ValorSI,            Entero_Cero,        Var_Poliza,     Par_NumErr,
                                Par_ErrMen,     Par_Consecutivo,    Par_ModoPago,       Par_Origen,     ValorSI,
                                Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
                                Aud_NumTransaccion);

    IF (Par_NumErr <> 000) THEN
        LEAVE ManejoErrores;
    END IF;

    CALL TOTALAPLICADOSWSPAGALT(Par_ClienteID,  Par_CreditoID,  Par_NumCtaInstit,   Par_InstitucionID,      Par_MontoPagar,
                                Par_Origen,     Par_ModoPago,   Var_Poliza,         SalidaNO,               Par_NumErr,
                                Par_ErrMen,     Aud_EmpresaID,  Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                                Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

    IF (Par_NumErr <> 000) THEN
        LEAVE ManejoErrores;
    END IF;
        
    SET Par_NumErr      := '000';
    SET Par_ErrMen      := 'Pago Referenciado Aplicado Exitosamente';
    SET Par_Consecutivo := Aud_NumTransaccion;
    SET Var_Control     := 'creditoID';
  
  END ManejoErrores;

IF (Par_Salida = ValorSI) THEN
  SELECT  Par_NumErr      AS NumErr,
          Par_ErrMen      AS ErrMen,
          Var_Control     AS Control,
          Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$
