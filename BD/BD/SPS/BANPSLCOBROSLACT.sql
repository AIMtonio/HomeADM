DELIMITER ;

DROP PROCEDURE IF EXISTS `BANPSLCOBROSLACT`;

DELIMITER $$

CREATE PROCEDURE `BANPSLCOBROSLACT`(

	Par_CobroID 					BIGINT(20),
	Par_PolizaID 					BIGINT(20),

	Par_NumAct 						INT(11),

	Par_Salida						CHAR(1),
	INOUT Par_NumErr				INT(11),
	INOUT Par_ErrMen 				VARCHAR(400),

	Aud_EmpresaID 					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal 					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore:BEGIN

	DECLARE Entero_Cero				INT;
	DECLARE Decimal_Cero 			DECIMAL(2, 1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATETIME;
	DECLARE SalidaSI				CHAR(1);
	DECLARE SalidaNO				CHAR(1);



    DECLARE Var_Consecutivo 		BIGINT(20);
	DECLARE Var_Control	    		VARCHAR(400);


	SET Entero_Cero					:= 0;
	SET Decimal_Cero 				:= 0.0;
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET SalidaSI					:= 'S';
	SET SalidaNO					:= 'N';


	SET Var_Consecutivo 			:= Entero_Cero;
	SET Var_Control		 			:= Cadena_Vacia;


	SET Par_CobroID 				:= IFNULL(Par_CobroID, Entero_Cero);
	SET Par_PolizaID 				:= IFNULL(Par_PolizaID, Entero_Cero);

	SET Aud_EmpresaID				:= IFNULL(Aud_EmpresaID, Entero_Cero);
    SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
    SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
       			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-BANPSLCOBROSLACT');
                SET Var_Control = 'SQLEXCEPTION';
			END;

            CALL PSLCOBROSLACT( Par_CobroID,                    Par_PolizaID,                   Par_NumAct,                 SalidaNO,                   Par_NumErr,
                                Par_ErrMen,                     Aud_EmpresaID,                  Aud_Usuario,                Aud_FechaActual,            Aud_DireccionIP,
                                Aud_ProgramaID,                 Aud_Sucursal,                   Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero) THEN
		    	SET Var_Consecutivo  := Entero_Cero;
		    	SET Var_Control 	 := Cadena_Vacia;
		        LEAVE ManejoErrores;
		    END IF;

		    SET Var_Control 	:= 'productoID';
		    SET Var_Consecutivo := Entero_Cero;
	END ManejoErrores;


	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   Var_Control	 	AS control,
			   Var_Consecutivo	AS consecutivo;
	END IF;


END TerminaStore$$
