-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMCONDONAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMSALDOPROMCONDONAPRO`;
DELIMITER $$


CREATE PROCEDURE `COMSALDOPROMCONDONAPRO`(
	/*SP PARA REALIZAR CONDONACION DEL SALDO PROMEDIO*/
    Par_ComisionID                  INT(11),                -- ID DE LA COMISION
    Par_ClienteID                   INT(11),                -- CLIENTE ID
    Par_CuentaAhoID                 BIGINT(20),             -- CUENTA DE AHORRO DEL CLIENTE
    Par_SaldoComPendiente           DECIMAL(18,2),          -- SALDO DE COMISION PENDIENTE DE COBRO
    Par_IVAComision                 DECIMAL(18,2),          -- IVA DE LA COMISION

    Par_TipoCondonacion             INT(11),                -- TIPO DE CONDONACION
    Par_MotivoProceso               VARCHAR(200),           -- MOTIVO DEL PROCESO
    Par_UsuarioAutoriza             INT(11),                -- USUARIO QUE AUTORIZA EL PROCESO

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
    DECLARE Var_FechaRegistro       DATE;                   -- FECHA DE REGISTRO
    DECLARE Var_SaldoTotal          DECIMAL(14,2);          -- SALDO TOTAL DE LA OPERACION
    DECLARE Var_SaldoTotalRev       DECIMAL(14,2);          -- SALDO TOTAL DE LA REVERSA
    DECLARE Var_SaldoActual         DECIMAL(14,2);          -- SALDO PENDIENTE DE COBRO
    DECLARE Var_IVASaldoActual      DECIMAL(14,2);          -- IVA PENDIENTE DE COBRO
    DECLARE Var_Estatus             CHAR(1);                -- ESTATUS
    DECLARE Var_NumeroRegistro      INT(11);                -- NUMERO DE REGISTRO
    DECLARE Var_FechaCobro          DATE;                   -- FECHA DE COBRO
    DECLARE Var_TotalReversa        DECIMAL(14,2);          -- TOTAL DE LA REVERSA

    -- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia            CHAR(1);                -- CADENA VACIA
    DECLARE Entero_Cero             INT(11);                -- ENTERO CERO
    DECLARE Decimal_Cero            DECIMAL(12,2);          -- DICIMAL CERO
    DECLARE SalidaSI                CHAR(1);                 -- SALIDA SI
    DECLARE SalidaNO                CHAR(1);                 -- SALIDA SI

    DECLARE Act_Reversa             INT(11);                -- REVERSA DE COMISION
    DECLARE Act_Condonacion         INT(11);                -- CONDONACION

    -- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia                := "";
    SET Entero_Cero                 := 0;
    SET Decimal_Cero                := 0.0;
    SET SalidaSI                    := "S";
    SET SalidaNO                    := "N";

    SET Act_Condonacion             := 1;
    SET Act_Reversa                 := 2;



    ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
                            'esto le ocasiona. Ref: SP-COMSALDOPROMCONDONAPRO');
            SET Var_Control = 'sqlException' ;
        END;

     SELECT FechaSistema INTO  Var_FechaRegistro
        FROM PARAMETROSSIS LIMIT 1;


        IF(Par_ClienteID = Entero_Cero)THEN
            SET Par_NumErr := 01;
            SET Par_ErrMen := 'El cliente esta vacio.';
            SET Var_Control := 'clienteID';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_CuentaAhoID = Entero_Cero)THEN
            SET Par_NumErr := 02;
            SET Par_ErrMen := 'La cuenta esta vacia.';
            SET Var_Control := 'cuentaAhoID';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_UsuarioAutoriza = Entero_Cero)THEN
            SET Par_NumErr := 03;
            SET Par_ErrMen := 'El usaurio que autoriza esta vacio.';
            SET Var_Control := 'usuarioAutoriza';
            LEAVE ManejoErrores;
        END IF;

        SELECT   ComSaldoPromAct,           IVAComSalPromAct,           Estatus
                INTO Var_SaldoActual,       Var_IVASaldoActual,         Var_Estatus
            FROM COMSALDOPROMPEND
            WHERE ComisionID  = Par_ComisionID;

        SET Var_SaldoTotal := IFNULL(Var_SaldoActual, Entero_Cero)+IFNULL(Var_IVASaldoActual, Entero_Cero);

        IF(Par_SaldoComPendiente = Decimal_Cero)THEN
            SET Par_NumErr := 04;
            SET Par_ErrMen := 'El saldo de la comision pendiente de cobro esta vacio.';
            SET Var_Control := 'saldoComPendiente';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_TipoCondonacion = Entero_Cero)THEN
            SET Par_NumErr := 05;
            SET Par_ErrMen := 'El el tipo de condonacion esta vacio.';
            SET Var_Control := 'tipoCondonacion';
            LEAVE ManejoErrores;
        END IF;

        IF(Var_Estatus != 'V')THEN
            SET Par_NumErr := 06;
            SET Par_ErrMen := 'La comision no se encuentra <b>VIGENTE</b>.';
            SET Var_Control := 'estatus';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_SaldoComPendiente!= Var_SaldoTotal)THEN
            SET Par_NumErr := 07;
            SET Par_ErrMen := CONCAT('El total a condonar no coincide con el saldo pendiente de cobro. <br>[Sal. Pendiente: $',
                                        FORMAT(Var_SaldoTotal,2)," Monto Condona: $",FORMAT(Par_SaldoComPendiente,2),']');
            SET Var_Control := 'estatus';
            LEAVE ManejoErrores;
        END IF;

        CALL COMSALDOPROMCONDONAALT(Par_ComisionID,             Par_CuentaAhoID,                Var_FechaRegistro,              Par_SaldoComPendiente,          Par_IVAComision,
                                    Var_SaldoTotal,             Par_UsuarioAutoriza,            Par_MotivoProceso,              Par_TipoCondonacion,            SalidaNO,
                                    Par_NumErr,                 Par_ErrMen,                     Aud_EmpresaID,                  Aud_Usuario,                    Aud_FechaActual,
                                    Aud_DireccionIP,            Aud_ProgramaID,                 Aud_Sucursal,                   Aud_NumTransaccion);

        IF(Par_NumErr!=Entero_Cero)THEN
                LEAVE ManejoErrores;
        END IF;

        UPDATE COMSALDOPROMPEND
            SET Estatus             = "C",
                ComSaldoPromCond    = Par_SaldoComPendiente,
                IVAComSalPromCond   = Par_IVAComision,
                ComSaldoPromAct     = Entero_Cero,
                IVAComSalPromAct    = Entero_Cero,

                EmpresaID		    = Aud_EmpresaID,
                Usuario             = Aud_Usuario,
                FechaActual 	    = Aud_FechaActual,
                DireccionIP 	    = Aud_DireccionIP,
                ProgramaID  	    = Aud_ProgramaID,
                Sucursal		    = Aud_Sucursal,
                NumTransaccion	    = Aud_NumTransaccion
        WHERE ComisionID        = Par_ComisionID
        AND Estatus = "V";


        -- Se da de alta al Historico
        CALL COMSALDOPROMPENDHISALT(
            Par_ComisionID,     SalidaNO,           Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        IF(Par_NumErr!=Entero_Cero)THEN
                LEAVE ManejoErrores;
        END IF;

        SET Par_ErrMen  := CONCAT('Condonacion Realizada Exitosamente: Cuenta[<b>',Par_CuentaAhoID,'</b>]');
        SET Var_Consecutivo:= Par_ClienteID;
        SET Par_NumErr  := 000;
        SET Var_Control  := 'clienteID' ;
        LEAVE ManejoErrores;


	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$