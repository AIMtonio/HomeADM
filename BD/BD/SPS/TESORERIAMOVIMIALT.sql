-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESORERIAMOVIMIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESORERIAMOVIMIALT`;DELIMITER $$

CREATE PROCEDURE `TESORERIAMOVIMIALT`(



    Par_CuentaAhoID     	BIGINT(12),
    Par_FechaMov        	DATE,
    Par_MontoMov        	DECIMAL(12,2),
    Par_DescripcionMov		VARCHAR(150),
    Par_ReferenciaMov   	VARCHAR(150),

    Par_Status          	CHAR(2),
    Par_NatMovimiento   	CHAR(1),
    Par_TipoRegristro   	CHAR(1),
    Par_TipoMov         	CHAR(4),
    Par_NumeroMov       	INT,
    OUT	Par_Consecutivo		BIGINT,

	Par_Salida 				CHAR(1),
	OUT	Par_NumErr			INT,
	OUT	Par_ErrMen			VARCHAR(400),

    Aud_EmpresaID        	INT,
    Aud_Usuario          	INT,
    Aud_FechaActual      	DATETIME,
    Aud_DireccionIP      	VARCHAR(20),
    Aud_ProgramaID       	VARCHAR(50),
    Aud_Sucursal         	INT,
    Aud_NumTransaccion   	BIGINT(20)
	)
TerminaStore: BEGIN


	DECLARE Var_Control	    	VARCHAR(100);
	DECLARE Var_Consecutivo		BIGINT(20);

	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Conciliado_NO       CHAR(1);
	DECLARE Var_FolioMovimiento INT;
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Salida_SI			CHAR(1);

	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Conciliado_NO       := 'N';
	SET	Salida_NO       	:= 'N';
	SET Salida_SI           := 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TESORERIAMOVIMIALT');
				SET Var_Control = 'sqlException';
			END;

		SET Par_TipoMov     := IFNULL(Par_TipoMov, Cadena_Vacia);
		SET Par_NumeroMov   := IFNULL(Par_NumeroMov, Entero_Cero);
		SET Par_Status      := IFNULL(Par_Status, Conciliado_NO);

		SET Var_FolioMovimiento  := (SELECT MAX(FolioMovimiento) FROM TESORERIAMOVS);
		SET Var_FolioMovimiento  := IFNULL(Var_FolioMovimiento,0)+1;

		INSERT INTO TESORERIAMOVS(
			FolioMovimiento,    CuentaAhoID,    NumeroMov,      FechaMov,       NatMovimiento,
			MontoMov,           TipoMov,        DescripcionMov, ReferenciaMov,  TipoRegristro,
			Status,             EmpresaID,      Usuario,        FechaActual,    DireccionIP,
			ProgramaID,         Sucursal,       NumTransaccion)
		VALUES(
			Var_FolioMovimiento,    Par_CuentaAhoID,    Par_NumeroMov,      Par_FechaMov,       Par_NatMovimiento,
			Par_MontoMov,           Par_TipoMov,        Par_DescripcionMov, Par_ReferenciaMov,  Par_TipoRegristro,
			Par_Status,             Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT("Movimiento No Identificado Guardado Exitosamente: ", CONVERT(Var_FolioMovimiento, CHAR));
		SET Var_Control		:= 'cuentaAhoID';
		SET Var_Consecutivo := Par_CuentaAhoID;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$