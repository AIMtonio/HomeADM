-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMISIONESSALPROAHOCIEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMISIONESSALPROAHOCIEPRO`;
DELIMITER $$

CREATE PROCEDURE `COMISIONESSALPROAHOCIEPRO`(
-- ========== SP PARA EL ALTA DE LAS COMISONES================================
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
    DECLARE Var_Consecutivo         INT(11);                -- Consecutivo
    DECLARE Var_FechaRegistro       DATE;               -- Fecha de Sistema

    -- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia            CHAR(1);                -- Cadena Vacia
    DECLARE Entero_Cero             INT(11);                -- Entero Cero
    DECLARE Decimal_Cero            DECIMAL(12,2);          -- Decimal Cero
    DECLARE SalidaSI                CHAR(1);                -- Salida SI
    DECLARE Var_Si                  CHAR(1);                -- Constante SI
    DECLARE Est_Vigente             CHAR(1);                -- Estatus VIGENTE
    DECLARE Ori_Cierre              CHAR(1);                -- Origen Proceso Cierre

    -- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia                := "";
    SET Entero_Cero                 := 0;
    SET Decimal_Cero                := 0.0;
    SET SalidaSI                    := "S";
    SET Var_Si                      := 'S';
    SET Est_Vigente                 := 'V';
    SET Ori_Cierre                  := 'C';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr   := 999;
            SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                            'esto le ocasiona. Ref: SP-COMISIONESSALPROAHOCIEPRO');
            SET Var_Control  := 'SQLEXCEPTION';
        END;


        SELECT FechaSistema INTO  Var_FechaRegistro
        FROM PARAMETROSSIS LIMIT 1;

        -- Insertamos los Datos a la Tabla de Cobros Pendientes de Comisiones por Saldo Promedio
        SET @Consecutivo := Entero_Cero;
        SET @Consecutivo := (SELECT MAX(ComisionID) FROM COMSALDOPROMPEND);
		SET @Consecutivo := IFNULL(@Consecutivo, Entero_Cero);

        INSERT INTO COMSALDOPROMPEND (
                ComisionID,             FechaCorte,         CuentaAhoID,            ComSaldoPromOri,        IVAComSalPromOri,
                ComSaldoPromAct,        IVAComSalPromAct,   ComSaldoPromCob,        IVAComSalPromCob,       ComSaldoPromCond,
                IVAComSalPromCond,      Estatus,            OrigenComision,         EmpresaID,              Usuario,
                FechaActual,            DireccionIP,        ProgramaID,             Sucursal,               NumTransaccion)
        SELECT
            (@Consecutivo  := @Consecutivo  +1 ),   Var_FechaRegistro,          CuentaAhoID,        ComSalProm,       IVAComSalProm,
            (ComSalProm - ComSalPromCob),       (ComSalProm - ComSalPromCob)*Iva,                   Decimal_Cero,     Decimal_Cero,       Decimal_Cero,
            Decimal_Cero,           Est_Vigente,            Ori_Cierre,         Aud_EmpresaID,      Aud_Usuario,
            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
        FROM TMPCUENTASAHOCI
        WHERE CobraSalProm = Var_Si
            AND ComSalPromCob < ComSalProm;

        -- Insertamos los Datos a la Tabla de Cobros Exitosos de Comisiones por Saldo Promedio
        SET @Consecutivo := Entero_Cero;
        SET @Consecutivo := (SELECT MAX(CobroID) FROM COMSALDOPROMCOBRADO);
		SET @Consecutivo := IFNULL(@Consecutivo, Entero_Cero);

        INSERT INTO COMSALDOPROMCOBRADO (
            CobroID,            ComisionID,         CuentaAhoID,        SaldoDispon,        FechaCobro,
            ComSaldoPromPend,   IVAComSalPromPend,  ComSaldoPromCob,    IVAComSalPromCob,   TotalCobrado,
            OrigenCobro,        EmpresaID,          Usuario,            FechaActual,        DireccionIP,
            ProgramaID,         Sucursal,           NumTransaccion)
        SELECT
            (@Consecutivo  := @Consecutivo  +1 ),   Entero_Cero,        CuentaAhoID,       SaldoDispon,      Var_FechaRegistro,
            (ComSalProm - ComSalPromCob),    (ComSalProm - ComSalPromCob)*Iva,             ComSalPromCob,    IVAComSalPromCob,        (ComSalPromCob + IVAComSalPromCob),
            Ori_Cierre,         Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,   Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
        FROM TMPCUENTASAHOCI
        WHERE CobraSalProm = Var_Si
            AND ComSalPromCob > Entero_Cero;

        SET Par_NumErr      := Entero_Cero;
	    SET Par_ErrMen      := 'Proceso de Cobro de Comisiones por Saldo Promedio';
	    SET Var_Consecutivo := Entero_Cero;
	    SET Var_Control		:= 'cuentaAhoID';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$
