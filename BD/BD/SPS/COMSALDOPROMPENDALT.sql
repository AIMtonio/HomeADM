-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMPENDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMSALDOPROMPENDALT`;
DELIMITER $$

CREATE PROCEDURE `COMSALDOPROMPENDALT`(
 # ========== SP PARA EL ALTA DE LAS COMISIONES PENDIENTES DE COBRO================================
    Par_FechaCorte                  DATE,               -- FECHA DE CORTE
    Par_CuentaAhoID                 BIGINT(20),         -- CUENTA DE AHORRO
    Par_ComSaldoPromOri             DECIMAL(14,2),      -- COMISION DE SALDO PROMEDIO ORIGINAL
    Par_IVAComSalPromOri            DECIMAL(14,2),      -- IVA COMISION DE SALDO PROMEDIO ORIGINAL
    Par_ComSaldoPromAct             DECIMAL(14,2),      -- SALDO COMISION PROMEDIO ACTUAL

    Par_IVAComSalPromAct            DECIMAL(14,2),      -- IVA SALDO COMISION PROMEDIO ACTUAL
    Par_ComSaldoPromCob             DECIMAL(14,2),      -- SALDO COMISION PROMEDIO COBRADO
    Par_IVAComSalPromCob            DECIMAL(14,2),      -- IVA SALDO COMISION PROMEDIO COBRADO
    Par_ComSaldoPromCond            DECIMAL(14,2),      -- SALDO COMISION PROMEDIO CONDONADO
    Par_IVAComSalPromCond           DECIMAL(14,2),      -- IVA SALDO COMISION PROMEDIO CONDONADO

    Par_Estatus                     CHAR(1),            -- ESTATUS V - VIGENTE, P - PAGADO EN SU TOTALIDAD, C - CONDONADO
    Par_OrigenComision              CHAR(1),            -- ORIGEN DE LA COMISION C.-CIERRE, A.-ABONOA  CUENTA
    Par_Salida                      CHAR(1),            -- SALIDA
    INOUT Par_NumErr                INT(11),            -- NUMERO DE ERROR
    INOUT Par_ErrMen                VARCHAR(400),       -- MENSAJE DE ERROR

    Aud_EmpresaID                   INT(11),            -- AUDITORIA
    Aud_Usuario                     INT(11),            -- AUDITORIA
    Aud_FechaActual                 DATETIME,           -- AUDITORIA
    Aud_DireccionIP                 VARCHAR(15),        -- AUDITORIA
    Aud_ProgramaID                  VARCHAR(50),        -- AUDITORIA
    Aud_Sucursal                    INT(11),            -- AUDITORIA
    Aud_NumTransaccion              BIGINT(20)          -- AUDITORIA
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
    DECLARE SalidaSI                CHAR(1);                -- SALIDA SI

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
                'esto le ocasiona. Ref: SP-COMSALDOPROMPENDALT');
            SET Var_Control  := 'SQLEXCEPTION';
        END;

    IF(Par_CuentaAhoID = Entero_Cero)THEN
        SET Par_NumErr := 01;
        SET Par_ErrMen := 'La cuenta esta vacia.';
        SET Var_Control := 'cuentaAhoID';
        LEAVE ManejoErrores;
    END IF;



    SELECT IFNULL(MAX(ReversaID),0)+1 INTO Var_Consecutivo
        FROM COMSALDOPROMPEND;


    INSERT INTO COMSALDOPROMPEND
                (ComisionID,                FechaCorte,             CuentaAhoID,            ComSaldoPromOri,                IVAComSalPromOri,
                ComSaldoPromAct,            IVAComSalPromAct,       ComSaldoPromCob,        IVAComSalPromCob,               ComSaldoPromCond,
                IVAComSalPromCond,          Estatus,                OrigenComision,
                EmpresaID,                  Usuario,                FechaActual,            DireccionIP,
                ProgramaID,                 Sucursal,               NumTransaccion)
         VALUES(Var_Consecutivo,            Par_FechaCorte,         Par_CuentaAhoID,        Par_ComSaldoPromOri,            Par_IVAComSalPromOri,
                Par_ComSaldoPromAct,        Par_IVAComSalPromAct,   Par_ComSaldoPromCob,    Par_IVAComSalPromCob,           Par_ComSaldoPromCond,
                Par_IVAComSalPromCond,      Par_Estatus,            Par_OrigenComision,
                Aud_EmpresaID,              Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,                Aud_ProgramaID,
                Aud_Sucursal,               Aud_NumTransaccion);


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
