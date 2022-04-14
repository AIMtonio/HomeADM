-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESORERIAMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESORERIAMOVALT`;DELIMITER $$

CREATE PROCEDURE `TESORERIAMOVALT`(
/*SP para dar de alta los movimientos de tesoreria*/
    Par_CuentaAhoID         BIGINT(12),
    Par_FechaMov            DATE,
    Par_MontoMov            DECIMAL(12,2),
    Par_DescripcionMov      VARCHAR(150),
    Par_ReferenciaMov       VARCHAR(150),

    Par_Status              CHAR(2),
    Par_NatMovimiento       CHAR(1),
    Par_TipoRegristro       CHAR(1),
    Par_TipoMov             CHAR(4),
    Par_NumeroMov           INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    INOUT Par_Consecutivo   BIGINT(12),

    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(20),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)

)
TerminaStore: BEGIN

    -- Declaracion de variables
    DECLARE Var_FolioMovimiento		INT(11);
    DECLARE Var_Control             VARCHAR(20);

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Fecha_Vacia             DATE;
    DECLARE Entero_Cero             INT(3);
    DECLARE Conciliado_NO           CHAR(1);
    DECLARE Salida_SI               CHAR(1);

	-- Asignacion de constantes
    SET Par_Consecutivo 			:= Entero_Cero;
    SET Var_Control     			:= 'FolioMovimiento';
	SET Cadena_Vacia        		:= '';
	SET Fecha_Vacia         		:= '1900-01-01';
	SET Entero_Cero         		:= 0;
	SET Conciliado_NO       		:= 'N';
	SET Salida_SI           		:= 'S';
	SET Aud_FechaActual    			:= NOW();


    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr      = 999;
			SET Par_ErrMen      = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TESORERIAMOVALT');
			SET Par_Consecutivo = Entero_Cero;
			SET Var_Control     = 'FolioMovimiento';
		END;

		SET Par_TipoMov         	:= IFNULL(Par_TipoMov, Cadena_Vacia);
		SET Par_NumeroMov       	:= IFNULL(Par_NumeroMov, Entero_Cero);
		SET Par_Status          	:= IFNULL(Par_Status, Conciliado_NO);
		SET Var_FolioMovimiento 	:= ( SELECT IFNULL(MAX(FolioMovimiento), 0) + 1 FROM TESORERIAMOVS);

		INSERT INTO TESORERIAMOVS(
            FolioMovimiento,        CuentaAhoID,        NumeroMov,              FechaMov,           NatMovimiento,
            MontoMov,               TipoMov,            DescripcionMov,         ReferenciaMov,      TipoRegristro,
            Status,                 EmpresaID,          Usuario,                FechaActual,        DireccionIP,
            ProgramaID,             Sucursal,           NumTransaccion)
		VALUES(
            Var_FolioMovimiento,    Par_CuentaAhoID,    Par_NumeroMov,          Par_FechaMov,       Par_NatMovimiento,
            Par_MontoMov,           Par_TipoMov,        Par_DescripcionMov,     Par_ReferenciaMov,  Par_TipoRegristro,
            Par_Status,             Aud_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

		SET Par_NumErr          := 000;
        SET Par_ErrMen          := 'Movimiento de Tesoreria Realizado Exitosamente.';
        SET Par_Consecutivo     := Var_FolioMovimiento;
        SET Var_Control         := 'FolioMovimiento';

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr  AS NumErr,
                Par_ErrMen  AS ErrMen,
                Var_Control AS control,
                Par_Consecutivo     AS consecutivo;
    END IF;

END TerminaStore$$