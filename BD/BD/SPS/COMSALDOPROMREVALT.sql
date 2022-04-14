-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMREVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMSALDOPROMREVALT`;
DELIMITER $$

CREATE PROCEDURE `COMSALDOPROMREVALT`(
 # ========== SP PARA EL ALTA DE LAS REVERSAS DE LA COMISION SALDO PROMEDIO================================
    Par_CuentaAhoID                 BIGINT(20),             -- CUENTA DE AHORRO DEL CLIENTE
    Par_FechaReversa                DATE,                   -- FECHA DE LA REVERSA
    Par_FechaCobro                  DATE,                   -- FECHA DE EN LA QUE SE COBRO LA COMISION
    Par_ComSaldoPromRev             DECIMAL(14,2),          -- SALDO DE REVERSA
    Par_IVAComSalPromRev            DECIMAL(14,2),          -- IVA DE LA REVERSA

    Par_TotalReversa                DECIMAL(14,2),          -- MONTO TOTAL DE LA REVERSA
    Par_UsuarioReversa              INT(11),                -- ID DEL USUARIO QUE AUTORIZA LA REVERSA
    Par_MotivoReversa               VARCHAR(200),           -- MOTIVO DE LA REVERSA
    Par_TipoReversaID               INT(11),                -- TIPO DE REVERSA
    Par_Salida                      CHAR(1),                -- SALIDA

    INOUT Par_NumErr                INT(11),                -- NUMERO DE ERROR
    INOUT Par_ErrMen                VARCHAR(400),           -- MENSAJE DE ERROR

    Aud_EmpresaID                   INT(11),                -- AUDITORIA
    Aud_Usuario                     INT(11),                -- AUDITORIA
    Aud_FechaActual                 DATETIME,               -- AUDITORIA
    Aud_DireccionIP                 VARCHAR(15),            -- AUDITORIA
    Aud_ProgramaID                  VARCHAR(50),            -- AUDITORIA
    Aud_Sucursal                    INT(11),                -- AUDITORIA
    Aud_NumTransaccion              BIGINT(20)              -- AUDITORIA
	)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
    DECLARE Var_Control             VARCHAR(50);            -- CONTROL
    DECLARE Var_Consecutivo         INT(11);                -- CONSICUTIVO



    -- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia            CHAR(1);                -- CADENA VACIA
    DECLARE Entero_Cero             INT(11);                -- ENTERO CERO
    DECLARE Decimal_Cero            DECIMAL(12,2);          -- DICIMAL CERO
    DECLARE Fecha_Vacia             DATE;
    DECLARE SalidaSI                CHAR(1);                 -- SALIDA SI

    -- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia                := "";
    SET Entero_Cero                 := 0;
    SET Decimal_Cero                := 0.0;
    SET Fecha_Vacia                 := '1900-01-01';
    SET SalidaSI                    := "S";
ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr   := 999;
            SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                'esto le ocasiona. Ref: SP-COMSALDOPROMREVALT');
            SET Var_Control  := 'SQLEXCEPTION';
        END;

    IF(Par_CuentaAhoID = Entero_Cero)THEN
        SET Par_NumErr := 01;
        SET Par_ErrMen := 'La cuenta esta vacia.';
        SET Var_Control := 'cuentaAhoID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_FechaReversa = Fecha_Vacia)THEN
        SET Par_NumErr := 02;
        SET Par_ErrMen := 'La fecha de la revesa esta vacia.';
        SET Var_Control := 'fechaReversa';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_FechaCobro = Fecha_Vacia)THEN
        SET Par_NumErr := 02;
        SET Par_ErrMen := 'La fecha de cobro esta vacia.';
        SET Var_Control := 'fechaCobro';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_TotalReversa = Decimal_Cero)THEN
        SET Par_NumErr := 03;
        SET Par_ErrMen := 'El saldo total de la reversa esta vacia.';
        SET Var_Control := 'totalReversa';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_TipoReversaID = Entero_Cero)THEN
        SET Par_NumErr := 04;
        SET Par_ErrMen := 'El tipo de reversa esta vacia.';
        SET Var_Control := 'tipoCondonacionID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_UsuarioReversa = Decimal_Cero)THEN
        SET Par_NumErr := 05;
        SET Par_ErrMen := 'El usaurio que autoriza esta vacio.';
        SET Var_Control := 'usuarioID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_MotivoReversa = Cadena_Vacia)THEN
        SET Par_NumErr := 06;
        SET Par_ErrMen := 'El motivo de la reversa esta vacio.';
        SET Var_Control := 'motivoReversa';
        LEAVE ManejoErrores;
    END IF;


    SELECT IFNULL(MAX(ReversaID),0)+1 INTO Var_Consecutivo
        FROM COMSALDOPROMREV;


    INSERT INTO COMSALDOPROMREV
                (ReversaID,                     CuentaAhoID,                FechaReversa,               FechaCobro,                 ComSaldoPromRev,
                IVAComSalPromRev,               TotalReversa,               UsuarioReversa,             MotivoReversa,              TipoReversaID,
                 EmpresaID,                     Usuario,                    FechaActual,                DireccionIP,                ProgramaID,
                 Sucursal,                      NumTransaccion)
         VALUES(Var_Consecutivo,                Par_CuentaAhoID,            Par_FechaReversa,           Par_FechaCobro,             Par_ComSaldoPromRev,
                Par_IVAComSalPromRev,           Par_TotalReversa,           Par_UsuarioReversa,         Par_MotivoReversa,          Par_TipoReversaID,
                Aud_EmpresaID,                  Aud_Usuario,                Aud_FechaActual,            Aud_DireccionIP,            Aud_ProgramaID,
                Aud_Sucursal,                   Aud_NumTransaccion);


    SET Par_NumErr := 000;
    SET Par_ErrMen := 'Operacion realizada exitosamente.';
    SET Var_Control := 'clienteID';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$
