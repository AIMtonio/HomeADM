-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMPENDHISALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMSALDOPROMPENDHISALT`;
DELIMITER $$

CREATE PROCEDURE `COMSALDOPROMPENDHISALT`(
 -- ========== SP PARA EL ALTA DE LAS REVERSAS DE LA COMISION SALDO PROMEDIO================================
    Par_ComisionID                  INT(11),                -- Parametro de Comision Identificador de COMSALDOPROMPEND

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
    DECLARE Var_ComisionID          INT(11);                -- Variable de Comision

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia            CHAR(1);                -- Cadena Vacia
    DECLARE Entero_Cero             INT(11);                -- Entero Cero
    DECLARE Decimal_Cero            DECIMAL(12,2);          -- Decimal Cero
    DECLARE Fecha_Vacia             DATE;                   -- Fecha Vacia
    DECLARE SalidaSI                CHAR(1);                -- Salida Si

    -- Seteo de Constantes
    SET Cadena_Vacia                := '';
    SET Entero_Cero                 := 0;
    SET Decimal_Cero                := 0.0;
    SET Fecha_Vacia                 := '1900-01-01';
    SET SalidaSI                    := 'S';


ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr   := 999;
            SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                'esto le ocasiona. Ref: SP-COMSALDOPROMPENDHISALT');
            SET Var_Control  := 'SQLEXCEPTION';
        END;


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

    SELECT MAX(ComisionID) INTO Var_Consecutivo
        FROM COMSALDOPROMPENDHIS;

    SET Var_Consecutivo := IFNULL(Var_Consecutivo, Entero_Cero) + 1;

    INSERT INTO COMSALDOPROMPENDHIS(
        ComisionID,         FechaCorte,         CuentaAhoID,        ComSaldoPromOri,    IVAComSalPromOri,
        ComSaldoPromAct,    IVAComSalPromAct,   ComSaldoPromCob,    IVAComSalPromCob,   ComSaldoPromCond,
        IVAComSalPromCond,  Estatus,            OrigenComision,     FechaHistorico,     EmpresaID,
        Usuario,            FechaActual,        DireccionIP,        ProgramaID,         Sucursal,
        NumTransaccion)
    SELECT
        Var_Consecutivo,    FechaCorte,         CuentaAhoID,        ComSaldoPromOri,    IVAComSalPromOri,
        ComSaldoPromAct,    IVAComSalPromAct,   ComSaldoPromCob,    IVAComSalPromCob,   ComSaldoPromCond,
        IVAComSalPromCond,  Estatus,            OrigenComision,     Var_FechaSis,       Aud_EmpresaID,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion
    FROM COMSALDOPROMPEND
    WHERE ComisionID = Par_ComisionID;

    -- Se elimina el registro de la tabla Base
    DELETE COMSALDOPROMPEND
        FROM COMSALDOPROMPEND
        WHERE ComisionID = Par_ComisionID;

    SET Par_NumErr := 000;
    SET Par_ErrMen := 'Historico de Pagos Pendientes Agregado Exitosamente.';
    SET Var_Control := 'clienteID';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$