-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACARABOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACARABOALT`;DELIMITER $$

CREATE PROCEDURE `BITACORACARABOALT`(
# =====================================================================================
# ------- STORE PARA LLENAR LA BITACORA DE CARGOS Y ABONOS  ---------
# ------- AL FALLAR EL SP CRCBCARGOABONOCTAWSPRO   CLIENTE CREDICLUB ---------
# =====================================================================================
	Par_CuentaAhoID		BIGINT(12),			-- numero de la cuenta, ID de la talba CUENTASAHO
	Par_Monto			DECIMAL(14,2),		-- monto a abonar
	Par_NumeroError   	INT(11),			-- Numero de Error
	Par_MensajeError	VARCHAR(400),		-- Descripcion del Error
  	Par_Transaccion		BIGINT(20),         -- Numero de transaccion

    Par_Salida			CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr   	INT(11),			-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),		-- Descripcion del Error

	Par_EmpresaID		INT(11),			-- EmpresaID
	Aud_Usuario			INT(11),	        -- Usuario ID
	Aud_FechaActual		DATETIME,           -- Fecha Actual
	Aud_DireccionIP		VARCHAR(15),        -- Direccion IP
	Aud_ProgramaID		VARCHAR(50),        -- Nombre de programa
	Aud_Sucursal		INT(11),            -- Sucursal ID
	Aud_NumTransaccion	BIGINT(20)          -- Numero de transaccion
)
TerminaStore:BEGIN

	DECLARE Var_FechaSis		DATE;					-- fecha del sistema
   	DECLARE Var_Control	    	VARCHAR(100);			-- variable de control
    DECLARE Salida_NO			CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Entero_Cero			INT(11);

	SET Salida_NO			:= 'N';						-- salida NO
    SET Salida_SI			:= 'S';						-- salida SI
    SET Entero_Cero			:= 0;						-- entero cero

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORACARABOALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	SELECT FechaSistema INTO	Var_FechaSis
			FROM PARAMETROSSIS  LIMIT 1;

   INSERT INTO BITACORACRCBCARGOABONO(
		Fecha, 			CuentaAhoID, 	Monto, 			NumeroError, 		MensajeError,
		Transaccion,	Par_EmpresaID, 	Aud_Usuario, 	Aud_FechaActual, 	Aud_DireccionIP,
		Aud_ProgramaID, Aud_Sucursal, 	Aud_NumTransaccion)
	VALUES(
		Var_FechaSis, 		Par_CuentaAhoID, 	Par_Monto, 		Par_NumeroError, 	Par_MensajeError,
		Par_Transaccion,	Par_EmpresaID, 		Aud_Usuario, 	Aud_FechaActual, 	Aud_DireccionIP,
		Aud_ProgramaID, 	Aud_Sucursal, 		Aud_NumTransaccion);


        SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= 'Bitacora Grabada Exitosamente.';


END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr  AS NumErr,
				Par_ErrMen 	AS ErrMen;
	END IF;


END TerminaStore$$