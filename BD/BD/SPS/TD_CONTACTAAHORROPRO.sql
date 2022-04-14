
-- TD_CONTACTAAHORROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_CONTACTAAHORROPRO`;
DELIMITER $$


CREATE PROCEDURE `TD_CONTACTAAHORROPRO`(
    -- ----------------------------------------------------------------------------------
    -- Realiza el Registro contable de operaciones de Tarjetas de Debito
    -- ----------------------------------------------------------------------------------
    Par_CtaAhoTarDebID      BIGINT(12),         -- Indica el numero de cta ahorro
    Par_NumeroTarjeta       VARCHAR(16),        -- Numero de tarjeta de Credito
    Par_ClienteID           BIGINT(12),         -- Cliente del credito
    Par_FechaOperacion      DATE,               -- Fecha de Operacion
    Par_FechaAplicacion     DATE,               -- Fecha de Aplicacion
    
    Par_Monto               DECIMAL(14,4),      -- Monto
    Par_MonedaID            INT(11),            -- moneda
    Par_Descripcion         VARCHAR(100),       -- Descripcion del movimiento
    Par_Referencia          VARCHAR(50),        -- Referencia del movimiento
    Par_AltaEncPoliza       CHAR(1),            -- Alta de la poliza de encabezado

    Par_ConceptoCon         INT(11),            -- Concepto contable
	INOUT Par_Poliza        BIGINT(20),         -- Numero de poliza
    Par_AltaPolizaCtaAho    CHAR(1),            -- Alta de Poliza de Credito
    Par_AltaMovCtaAho       CHAR(1),            -- Alta de Movimiento en la cta ahorro
    Par_TipoMovAho          INT(11),            -- Tipo de movimiento de la cta de ahorro
    
    Par_NatAhorro           CHAR(1),            -- Naturaleza del movimiento de la linea
    Par_NumAutorizacion     CHAR(6),            -- Numero de la autorizacion COPAYMENT
    Par_AltaMovBitacora     CHAR(1),            -- Alta en Bitacora
    Par_DescripcionBita     VARCHAR(150),       -- Descripcion Bitacora
	Par_TipoOperacionID		VARCHAR(2),

    Par_Salida                  CHAR(1),            -- Salida
	INOUT   Par_NumErr          INT(11),            -- Numero de error
	INOUT   Par_ErrMen          VARCHAR(400),       -- Mensaje
	INOUT   Par_Consecutivo     BIGINT,             -- Consecutivo

    Par_Empresa             INT(11),            -- Auditoria

    Aud_Usuario             INT(11),            -- Auditoria
    Aud_FechaActual         DATETIME,           -- Auditoria
    Aud_DireccionIP         VARCHAR(15),        -- Auditoria
    Aud_ProgramaID          VARCHAR(50),        -- Auditoria
    Aud_Sucursal            INT(11),            -- Auditoria

    Aud_NumTransaccion      BIGINT(20)          -- Auditoria
    )

TerminaStore: BEGIN

	DECLARE Var_Cargos              DECIMAL(14,4);
	DECLARE Var_Abonos              DECIMAL(14,4);

	DECLARE Var_CuentaStr           VARCHAR(150);
	DECLARE Var_Control             VARCHAR(50);
	DECLARE Var_RefTarjeta          VARCHAR(150);
	DECLARE Var_EstadoSucursal      VARCHAR(150);
	DECLARE Var_TarDebMovID         INT(11);



	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Fecha_Vacia             DATE;
	DECLARE Entero_Cero             INT;
	DECLARE Decimal_Cero            DECIMAL(12, 2);
	DECLARE AltaPoliza_SI           CHAR(1);
	DECLARE AltaMovAho_SI           CHAR(1);
	DECLARE AltaMovCtaAho_SI        CHAR(1);
	DECLARE AltaPolCre_SI           CHAR(1);
	DECLARE Nat_Cargo               CHAR(1);
	DECLARE Nat_Abono               CHAR(1);
	DECLARE Pol_Automatica          CHAR(1);
	DECLARE Salida_NO               CHAR(1);
	DECLARE Con_AhoCapital          INT;
	DECLARE Con_LineaOrden          INT;
	DECLARE Con_LineaCorrOrden      INT;
	DECLARE Cons_SI                 CHAR(1);
	DECLARE Origen_SAFI             CHAR(1);
	DECLARE Operacion_SAFI          VARCHAR(5);
	DECLARE TipoOperaTarjeta        VARCHAR(2);
	DECLARE OperacionExito          VARCHAR(2);
	DECLARE Cod_MonedaPesos         VARCHAR(3);
	DECLARE Trans_Linea             CHAR(1);
	DECLARE Tipo_CheckIn            CHAR(1);
	DECLARE Tran_Exitosa            VARCHAR(50);
	DECLARE Pais_Mex                VARCHAR(3);
	DECLARE Un_Peso                 INT(3);
	DECLARE Act_EstPro              INT(3);



	SET Cadena_Vacia            := '';
	SET Fecha_Vacia             := '1900-01-01';
	SET Entero_Cero             := 0;
	SET Decimal_Cero            := 0.00;
	SET AltaPoliza_SI           := 'S';
	SET AltaMovAho_SI           := 'S';
	SET AltaMovCtaAho_SI        := 'S';
	SET AltaPolCre_SI           := 'S';
	SET Nat_Cargo               := 'C';
	SET Nat_Abono               := 'A';
	SET Pol_Automatica          := 'A';
	SET Salida_NO               := 'N';
	SET Con_AhoCapital          := 1;
	SET Con_LineaOrden          := 53;
	SET Con_LineaCorrOrden      := 54;
	SET Cons_SI                 := 'S';

	SET Var_CuentaStr           := CONCAT("Tarjeta.",CONVERT(Par_NumeroTarjeta, CHAR));
	SET Aud_FechaActual         := NOW();
	SET Origen_SAFI             := 'S';
	SET Operacion_SAFI          := '1000';
	SET TipoOperaTarjeta        := '19';
	SET Cod_MonedaPesos         := '484';
	SET Trans_Linea             := 'N';
	SET Tipo_CheckIn            := '0';
	SET OperacionExito          := '00';
	SET Tran_Exitosa            := 'TRANSACCION DE TARJETA EXITOSA';
	SET Pais_Mex                := 'MEX';
	SET Var_RefTarjeta          := CONCAT('TAR*** ',RIGHT(Par_NumeroTarjeta,4));
	SET Un_Peso                 := 1;
	SET Act_EstPro              := 1;


ManejoErrores: BEGIN
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP-TD_CONTACTAAHORROPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;


        IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
            CALL MAESTROPOLIZASALT(
                Par_Poliza,         Par_Empresa,     Par_FechaAplicacion,   Pol_Automatica,         Par_ConceptoCon,
                Par_Descripcion,    Salida_NO,       Par_NumErr,            Par_ErrMen,             Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP, Aud_ProgramaID,        Aud_Sucursal,           Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;


        IF (Par_AltaMovCtaAho = AltaMovCtaAho_SI) THEN

            CALL CUENTASAHORROMOVALT(
                Par_CtaAhoTarDebID,     Aud_NumTransaccion, Par_FechaAplicacion,     Par_NatAhorro,      Par_Monto,
                Par_Descripcion,        Par_Referencia,     Par_TipoMovAho,          Salida_NO,          Par_NumErr,
                Par_ErrMen,             Par_Empresa,        Aud_Usuario,             Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

        IF (Par_AltaPolizaCtaAho = AltaPolCre_SI) THEN

            IF(Par_NatAhorro = Nat_Cargo) THEN
                SET Var_Cargos  := Par_Monto;
                SET Var_Abonos  := Decimal_Cero;
            ELSE
                SET Var_Cargos  := Decimal_Cero;
                SET Var_Abonos  := Par_Monto;
            END IF;
            
            CALL POLIZAAHORROPRO(
                Par_Poliza,             Par_Empresa,        Par_FechaAplicacion,    Par_ClienteID,          Con_AhoCapital,
                Par_CtaAhoTarDebID,     Par_MonedaID,       Var_Cargos,             Var_Abonos,             Par_Descripcion,
                Aud_NumTransaccion,     Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
                Aud_Sucursal,           Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;

        IF Par_AltaMovBitacora = Cons_SI  THEN

            SELECT e.Nombre
            INTO Var_EstadoSucursal
            FROM CUENTASAHO c, SUCURSALES s, ESTADOSREPUB e 
            WHERE c.SucursalID = s.SucursalID
                AND s.EstadoID = e.EstadoID
                AND c.CuentaAhoID  = Par_CtaAhoTarDebID;
                
            CALL TD_BITACORAMOVSALT(
                Origen_SAFI,        Operacion_SAFI,     Par_TipoOperacionID,	Par_NumeroTarjeta,  Par_Monto,
                Entero_Cero,        Entero_Cero,        Entero_Cero,            Entero_Cero,        Cod_MonedaPesos,
                Par_Monto,          Entero_Cero,        Entero_Cero,            Entero_Cero,        Entero_Cero,
                Par_FechaOperacion, TIME(NOW()),        Cadena_Vacia,           Cadena_Vacia,       Par_DescripcionBita,
                Var_EstadoSucursal, Pais_Mex,           Var_RefTarjeta,         Cadena_Vacia,       Par_CtaAhoTarDebID,
                Trans_Linea,        Tipo_CheckIn,       Nat_Cargo,              Un_Peso,            Var_TarDebMovID,
                Salida_NO,          Par_NumErr,         Par_ErrMen,             Par_Empresa,        Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;

            CALL TD_BITACORAMOVSACT(
                Var_TarDebMovID,    Act_EstPro,         Salida_NO,          Par_NumErr,                 Par_ErrMen,
                Par_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,            Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            IF Par_NumErr != Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;

            CALL TD_BITACORARESPALT(
                Par_NumeroTarjeta,   Operacion_SAFI,        Par_TipoOperacionID,	Par_FechaOperacion, TIME(NOW()),
                Par_Monto,           Var_RefTarjeta,        Aud_NumTransaccion,     Entero_Cero,        Entero_Cero,
                OperacionExito,      Tran_Exitosa,          Salida_NO,              Par_NumErr,         Par_ErrMen,
                Par_Empresa,         Aud_Usuario,           Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,        Aud_NumTransaccion
                );

            IF Par_NumErr != Entero_Cero THEN
                LEAVE ManejoErrores;
            END IF;

        END IF;


        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Movimiento Realizado Exitosamente';

END ManejoErrores;


    IF Par_Salida = 'S' THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen;

    END IF;

END TerminaStore$$
