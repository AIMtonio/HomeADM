-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMCONDONAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMSALDOPROMCONDONAALT`;
DELIMITER $$

CREATE PROCEDURE `COMSALDOPROMCONDONAALT`(
 # ========== SP PARA EL ALTA DE LAS COMISONES CONDONADAS================================
    Par_ComisionID                  INT(11),                -- ID QUE CORRESPONDE A LA TABLA COMISIONESSALPROAHOHEAD
    Par_CuentaAhoID                 BIGINT(20),             -- CUENTA DE AHORRO DEL CLIENTE
    Par_FechaCondonacion            DATE,                   -- FECHA DE LA CONDONACION
    Par_ComSaldoPromCond            DECIMAL(14,2),          -- SALDO A CONDONAR
    Par_IVAComSalPromCond           DECIMAL(14,2),          -- IVA A CONDONAR

    Par_TotalCondonacion            DECIMAL(14,2),          -- MONTO TOTAL DE LA CONDONACIONL
    Par_UsuarioCondona              INT(11),                -- ID DEL USUARIO QUE AUTORIZA LA CONDONACION
    Par_MotivoCondonacion           VARCHAR(200),           -- MOTIVO DE LA CONDONACION
    Par_TipoCondonacionID           INT(11),                -- TIPO DE CONDONACION
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
    DECLARE SalidaSI                CHAR(1);                 -- SALIDA SI

    -- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia                := "";
    SET Entero_Cero                 := 0;
    SET Decimal_Cero                := 0.0;
    SET SalidaSI                    := "S";
ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr   := 999;
            SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                'esto le ocasiona. Ref: SP-COMSALDOPROMCONDONAALT');
            SET Var_Control  := 'SQLEXCEPTION';
        END;


    IF(Par_ComisionID = Entero_Cero)THEN
        SET Par_NumErr := 01;
        SET Par_ErrMen := 'La comision esta vacia.';
        SET Var_Control := 'comisionID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_CuentaAhoID = Entero_Cero)THEN
        SET Par_NumErr := 02;
        SET Par_ErrMen := 'La cuenta esta vacia.';
        SET Var_Control := 'cuentaAhoID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_TotalCondonacion = Decimal_Cero)THEN
        SET Par_NumErr := 03;
        SET Par_ErrMen := 'El saldo total a condonar esta vacio.';
        SET Var_Control := 'totalCondonacion';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_TipoCondonacionID = Entero_Cero)THEN
        SET Par_NumErr := 04;
        SET Par_ErrMen := 'El tipo de la condonacion esta vacio';
        SET Var_Control := 'tipoCondonacionID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_UsuarioCondona = Decimal_Cero)THEN
        SET Par_NumErr := 05;
        SET Par_ErrMen := 'El usaurio que autoriza esta vacio';
        SET Var_Control := 'usuarioID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_MotivoCondonacion = Cadena_Vacia)THEN
        SET Par_NumErr := 06;
        SET Par_ErrMen := 'El motivo de condonacion esta vacio.';
        SET Var_Control := 'motivoCondonacion';
        LEAVE ManejoErrores;
    END IF;


    SELECT IFNULL(MAX(CondonacionID),0)+1 INTO Var_Consecutivo
        FROM COMSALDOPROMCONDONA;


    INSERT INTO COMSALDOPROMCONDONA
                (CondonacionID,                 ComisionID,                 CuentaAhoID,                FechaCondonacion,           ComSaldoPromCond,
                 IVAComSalPromCond,             TotalCondonacion,           UsuarioCondona,             MotivoCondonacion,          TipoCondonacionID,
                 EmpresaID,                     Usuario,                    FechaActual,                DireccionIP,                ProgramaID,
                 Sucursal,                      NumTransaccion)
         VALUES(Var_Consecutivo,                Par_ComisionID,             Par_CuentaAhoID,            Par_FechaCondonacion,       Par_ComSaldoPromCond,
                Par_IVAComSalPromCond,          Par_TotalCondonacion,       Par_UsuarioCondona,         Par_MotivoCondonacion,      Par_TipoCondonacionID,
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
