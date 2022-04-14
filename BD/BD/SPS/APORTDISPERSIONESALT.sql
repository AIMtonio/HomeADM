

-- APORTDISPERSIONESALT --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTDISPERSIONESALT`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTDISPERSIONESALT`(
/* SP DE ALTA DE DISPERSIONES PARA APORTACIONES */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_AmortizacionID			INT(11),		-- Id de la Amortizacion.
	Par_ClienteID				INT(11),		-- Cliente ID.
	Par_CuentaAhoID				BIGINT(12),		-- Numero de la Cuenta de ahorro.
	Par_Capital					DECIMAL(18,2),	-- Monto del Capital.

	Par_Interes					DECIMAL(18,2),	-- Interes.
	Par_InteresRetener			DECIMAL(18,2),	-- Interes a Retener ISR.
	Par_Total					DECIMAL(18,2),	-- Total Capital + Interes - ISR .
	Par_FechaVencimiento		DATE,			-- Fecha de Vencimiento.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No

	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     CHAR(15);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Cons_SI			CHAR(1);
DECLARE	Cons_NO			CHAR(1);
DECLARE	EstatusPend		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET	EstatusPend			:= 'P'; 			-- Estatus Pendiente de Dispersión.
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTDISPERSIONESALT');
			SET Var_Control:= 'sqlException' ;
		END;

	-- CALCULO DEL TOTAL
	SET Par_Total := (Par_Capital+Par_Interes)-Par_InteresRetener;

	INSERT IGNORE INTO APORTDISPERSIONES(
		AportacionID,		AmortizacionID,		ClienteID,			CuentaAhoID,		Capital,
		Interes,			InteresRetener,		Total,				Estatus,			FechaVencimiento,
		EmpresaID,			UsuarioID,			FechaActual,		DireccionIP,		ProgramaID,
		Sucursal,			NumTransaccion)
	VALUES(
		Par_AportacionID,	Par_AmortizacionID,	Par_ClienteID,		Par_CuentaAhoID,	Par_Capital,
		Par_Interes,		Par_InteresRetener,	Par_Total,			EstatusPend,		Par_FechaVencimiento,
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

	IF EXISTS (SELECT CuentaAhoID FROM APORTCTADISPERSIONES WHERE CuentaAhoID = Par_CuentaAhoID) THEN 
		UPDATE APORTCTADISPERSIONES 
			SET Total = Total + Par_Total, MontoPendiente = MontoPendiente + Par_Total 
			WHERE CuentaAhoID = Par_CuentaAhoID;
	ELSE
		INSERT INTO APORTCTADISPERSIONES (ClienteID, 		CuentaAhoID,			Total,				 MontoPendiente,  		 Estatus,
										  FechaVencimiento,
							    		  EmpresaID,	    UsuarioID, 			 	FechaActual, 		 DireccionIP, 			 ProgramaID,
							    		  Sucursal, 	    NumTransaccion)
								SELECT	  Par_ClienteID, 	Par_CuentaAhoID, 		Par_Total, 			 Par_Total,				 EstatusPend,
										  Par_FechaVencimiento,
									   	  Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	 Aud_DireccionIP,		 Aud_ProgramaID,
									   	  Aud_Sucursal,		Aud_NumTransaccion;

	END IF;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Dispersiones Grabada Exitosamente.';
	SET Var_Control:= 'aportacionID' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_AportacionID AS Consecutivo;
END IF;

END TerminaStore$$