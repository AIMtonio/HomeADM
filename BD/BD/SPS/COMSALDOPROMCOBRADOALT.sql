-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMCOBRADOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMSALDOPROMCOBRADOALT`;
DELIMITER $$

CREATE PROCEDURE `COMSALDOPROMCOBRADOALT`(
 -- ========== SP PARA EL ALTA DE COBROS DE LA COMISION SALDO PROMEDIO================================
    Par_ComisionID                  INT(11),                -- Parametro de Comision Identificador de COMSALDOPROMPEND
    Par_CuentaAhoID                 BIGINT(20),             -- Parametro Cuenta de Ahorro
    Par_ClienteID                   INT(11),                -- Parametro Identificador Cliente
    Par_SaldoDispon                 DECIMAL(16,2),          -- Saldo Disponible en la Cta antes del Cobro
    Par_ComSaldoProm                DECIMAL(14,2),          -- Saldo Comision a Cobrar
    Par_IVAComSalProm               DECIMAL(14,2),          -- Saldo IVA de Comision a Cobrar

    Par_Salida                      CHAR(1),                -- Parametro de Salida
    INOUT Par_NumErr                INT(11),                -- Parametro Numero de Error
    INOUT Par_ErrMen                VARCHAR(400),           -- Parametro Mensaje de Error

    Aud_EmpresaID                   INT(11),                -- Parametro de Auditoria
    Aud_Usuario                     INT(11),                -- Parametro de Auditoria
    Aud_FechaActual                 DATETIME,               -- Parametro de Auditoria
    Aud_DireccionIP                 VARCHAR(15),            -- Parametro de Auditoria
    Aud_ProgramaID                  VARCHAR(50),            -- Parametro de Auditoria
    Aud_Sucursal                    INT(11),                -- Parametro de Auditoria
    Aud_NumTransaccion              BIGINT(20)              -- Parametro de Auditoria
	)
TerminaStore: BEGIN
    -- Declaracion de Variables
    DECLARE Var_Control             VARCHAR(50);            -- Variable Control
    DECLARE Var_Consecutivo         INT(11);                -- Variable Consecutivo
    DECLARE Var_FechaSis            DATE;                   -- Fecha del Sistema
    DECLARE Var_ComSaldoPend        DECIMAL(14,2);          -- Monto de comision que aun no ha sido cubierta antes del cobro
    DECLARE Var_IVAComSalPend       DECIMAL(14,2);          -- IVA Monto de comision que aun no ha sido cubierta antes del cobro
    DECLARE Var_TotalCob            DECIMAL(14,2);          -- Total a Cobrar
    DECLARE Var_ComisionID          INT(11);                -- Variable de Comision

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia            CHAR(1);                -- Cadena Vacia
    DECLARE Entero_Cero             INT(11);                -- Entero Cero
    DECLARE Decimal_Cero            DECIMAL(12,2);          -- Decimal Cero
    DECLARE Fecha_Vacia             DATE;
    DECLARE SalidaSI                CHAR(1);                -- Salida Si
    DECLARE Con_AbonoCta            CHAR(1);                -- Constante Abono a Cta
    -- Seteo de Constantes
    SET Cadena_Vacia                := '';
    SET Entero_Cero                 := 0;
    SET Decimal_Cero                := 0.0;
    SET Fecha_Vacia                 := '1900-01-01';
    SET SalidaSI                    := 'S';
    SET Con_AbonoCta                := 'A';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr   := 999;
            SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                'esto le ocasiona. Ref: SP-COMSALDOPROMCOBRADOALT');
            SET Var_Control  := 'SQLEXCEPTION';
        END;

    -- Seteo de Parametros en caso de venir nulos
    SET Par_ComisionID := IFNULL(Par_ComisionID, Entero_Cero);
    SET Par_SaldoDispon := IFNULL(Par_SaldoDispon, Entero_Cero);
    SET Par_ComSaldoProm := IFNULL(Par_ComSaldoProm, Entero_Cero);
    SET Par_IVAComSalProm := IFNULL(Par_IVAComSalProm, Entero_Cero);

    SELECT FechaSistema
    INTO Var_FechaSis
    FROM PARAMETROSSIS
    LIMIT 1;

    IF(Par_ComisionID = Entero_Cero)THEN
        SET Par_NumErr := 01;
        SET Par_ErrMen := 'La Comision esta Vacia.';
        SET Var_Control := 'comisionID';
        LEAVE ManejoErrores;
    END IF;

    SELECT ComisionID
    INTO Var_ComisionID
    FROM COMSALDOPROMPEND
    WHERE ComisionID = Par_ComisionID;

    SET Var_ComisionID := IFNULL(Var_ComisionID, Entero_Cero);

     IF(Var_ComisionID = Entero_Cero)THEN
        SET Par_NumErr := 02;
        SET Par_ErrMen := 'La Comision No Existe.';
        SET Var_Control := 'comisionID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_CuentaAhoID = Entero_Cero)THEN
        SET Par_NumErr := 03;
        SET Par_ErrMen := 'La cuenta esta vacia.';
        SET Var_Control := 'cuentaAhoID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_ClienteID = Entero_Cero)THEN
        SET Par_NumErr := 04;
        SET Par_ErrMen := 'El Cliente se encuentra Vacio.';
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_SaldoDispon = Entero_Cero)THEN
        SET Par_NumErr := 05;
        SET Par_ErrMen := 'El Saldo Disponible de la Cuenta esta Vacio.';
        SET Var_Control := 'cuentaAhoID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_ComSaldoProm = Entero_Cero)THEN
        SET Par_NumErr := 06;
        SET Par_ErrMen := 'El Saldo de Comision por Saldo Promedio esta Vacio.';
        SET Var_Control := 'comisionID';
        LEAVE ManejoErrores;
    END IF;

    -- Se obtine los Montos antes de Realizar el cobro
    SELECT ComSaldoPromAct, IVAComSalPromAct
    INTO Var_ComSaldoPend,  Var_IVAComSalPend
    FROM COMSALDOPROMPEND
    WHERE ComisionID = Par_ComisionID;

    SET Var_ComSaldoPend := IFNULL(Var_ComSaldoPend, Decimal_Cero);
    SET Var_IVAComSalPend := IFNULL(Var_IVAComSalPend, Decimal_Cero);

    SET Var_TotalCob := (Par_ComSaldoProm + Par_IVAComSalProm);

    SELECT MAX(CobroID) INTO Var_Consecutivo
        FROM COMSALDOPROMCOBRADO;

    SET Var_Consecutivo := IFNULL(Var_Consecutivo, Entero_Cero) + 1;

    INSERT INTO COMSALDOPROMCOBRADO(
        CobroID,                ComisionID,             CuentaAhoID,            SaldoDispon,            FechaCobro,
        ComSaldoPromPend,       IVAComSalPromPend,      ComSaldoPromCob,        IVAComSalPromCob,       TotalCobrado,
        OrigenCobro,            EmpresaID,              Usuario,                FechaActual,            DireccionIP,
        ProgramaID,             Sucursal,               NumTransaccion)
    VALUES(
        Var_Consecutivo,        Par_ComisionID,         Par_CuentaAhoID,        Par_SaldoDispon,        Var_FechaSis,
        Var_ComSaldoPend,       Var_IVAComSalPend,      Par_ComSaldoProm,       Par_IVAComSalProm,      Var_TotalCob,
        Con_AbonoCta,           Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);


    SET Par_NumErr := 000;
    SET Par_ErrMen := 'Comision de Pago Agregado Exitosamente.';
    SET Var_Control := 'clienteID';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$