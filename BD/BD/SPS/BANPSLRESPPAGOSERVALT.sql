-- BANPSLRESPPAGOSERVALT

DELIMITER ;

DROP PROCEDURE IF EXISTS BANPSLRESPPAGOSERVALT;

DELIMITER $$

CREATE PROCEDURE `BANPSLRESPPAGOSERVALT`(

	Par_CobroID 			BIGINT(20),
	Par_CodigoRespuesta		VARCHAR(10),
	Par_MensajeRespuesta	VARCHAR(2000),
	Par_NumTransaccionP		VARCHAR(20),
	Par_NumAutorizacion		BIGINT(20),
	Par_Monto				DECIMAL(14,2),
	Par_Comision			DECIMAL(14,2),
	Par_Referencia 			VARCHAR(70),
	Par_SaldoRecarga		DECIMAL(14,2),
	Par_SaldoServicio		DECIMAL(14,2),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen 		VARCHAR(400),

	Par_EmpresaID 			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal 			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero 			DECIMAL(14,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Var_SalidaSI			CHAR(1);
	DECLARE Var_SalidaNO			CHAR(1);


	DECLARE Var_Consecutivo 		BIGINT(20);
	DECLARE Var_Control				VARCHAR(50);


	SET Entero_Cero					:= 0;
	SET Decimal_Cero 				:= 0.0;
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Var_SalidaSI				:= 'S';
	SET Var_SalidaNO				:= 'N';


	SET Var_Consecutivo 			:= Entero_Cero;
	SET Var_Control		 			:= Cadena_Vacia;


	SET Par_CobroID 				:= IFNULL(Par_CobroID, Decimal_Cero);
	SET Par_CodigoRespuesta 		:= IFNULL(Par_CodigoRespuesta, Cadena_Vacia);
	SET Par_MensajeRespuesta 		:= IFNULL(Par_MensajeRespuesta, Cadena_Vacia);
	SET Par_NumTransaccionP 		:= IFNULL(Par_NumTransaccionP, Cadena_Vacia);
	SET Par_NumAutorizacion			:= IFNULL(Par_NumAutorizacion, Entero_Cero);
	SET Par_Monto 					:= IFNULL(Par_Monto, Decimal_Cero);
	SET Par_Comision 				:= IFNULL(Par_Comision, Decimal_Cero);
	SET Par_Referencia				:= IFNULL(Par_Referencia, Cadena_Vacia);
	SET Par_SaldoRecarga 			:= IFNULL(Par_SaldoRecarga, Decimal_Cero);
	SET Par_SaldoServicio 			:= IFNULL(Par_SaldoServicio, Decimal_Cero);

	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-BANPSLRESPPAGOSERVALT');
			SET Var_Control = 'sqlException';
		END;

		CALL PSLRESPPAGOSERVALT (   Par_CobroID,                Par_CodigoRespuesta,                Par_MensajeRespuesta,               Par_NumTransaccionP,            Par_NumAutorizacion,
                                    Par_Monto,                  Par_Comision,                       Par_Referencia,                     Par_SaldoRecarga,               Par_SaldoServicio,
                                    Var_SalidaNO,               Par_NumErr,                         Par_ErrMen,                         Par_EmpresaID,                  Aud_Usuario,
                                    Aud_FechaActual,            Aud_DireccionIP,                    Aud_ProgramaID,                     Aud_Sucursal,                   Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero) THEN
			SET Var_Consecutivo  := Entero_Cero;
			SET Var_Control 	 := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Respuesta de consumo de WS agregada exitosamente';
		SET Var_Control 	:= 'cobroID';
		SET Var_Consecutivo := Entero_Cero;
	END ManejoErrores;


	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_Consecutivo AS consecutivo;
	END IF;


END TerminaStore$$
