-- BANPSLCOBROSLALT

DELIMITER ;

DROP PROCEDURE IF EXISTS BANPSLCOBROSLALT;

DELIMITER $$

CREATE PROCEDURE `BANPSLCOBROSLALT`(

	Par_ProductoID 					INT(11),
	Par_ServicioID 					INT(11),
	Par_ClasificacionServ 			CHAR(2),
	Par_TipoUsuario 				CHAR(1),
	Par_NumeroTarjeta 				VARCHAR(30),
	Par_ClienteID 					INT(11),
	Par_CuentaAhoID 				BIGINT(12),
	Par_Producto 					VARCHAR(200),
	Par_FormaPago 					CHAR(1),
	Par_Precio 						DECIMAL(14,2),
	Par_Telefono					VARCHAR(13),
	Par_Referencia					VARCHAR(30),
	Par_ComisiProveedor 			DECIMAL(14,2),
	Par_ComisiInstitucion 			DECIMAL(14,2),
	Par_IVAComision 				DECIMAL(14,2),
	Par_TotalComisiones 			DECIMAL(14,2),
	Par_TotalPagar 					DECIMAL(14,2),

	Par_Canal 						CHAR(1),
	Par_PolizaID 					BIGINT(20),


	Par_Salida						CHAR(1),
	INOUT Par_NumErr				INT(11),
	INOUT Par_ErrMen 				VARCHAR(400),
	INOUT Par_CobroID 				BIGINT(20),

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
	DECLARE Var_FechaDate			DATETIME;



	SET Entero_Cero					:= 0;
	SET Decimal_Cero 				:= 0.0;
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET SalidaSI					:= 'S';
	SET SalidaNO					:= 'N';


	SET Var_Consecutivo 			:= Entero_Cero;
	SET Var_Control		 			:= Cadena_Vacia;



	SET Par_ProductoID 				:= IFNULL(Par_ProductoID, Entero_Cero);
	SET Par_ServicioID 				:= IFNULL(Par_ServicioID, Entero_Cero);
	SET Par_ClasificacionServ 		:= IFNULL(Par_ClasificacionServ, Entero_Cero);
	SET Par_TipoUsuario				:= IFNULL(Par_TipoUsuario, Cadena_Vacia);
	SET Par_NumeroTarjeta 			:= IFNULL(Par_NumeroTarjeta, Cadena_Vacia);
	SET Par_ClienteID 				:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_CuentaAhoID 			:= IFNULL(Par_CuentaAhoID, Decimal_Cero);
    SET Par_Producto 				:= IFNULL(Par_Producto, Cadena_Vacia);
    SET Par_FormaPago 				:= IFNULL(Par_FormaPago, Cadena_Vacia);
    SET Par_Precio 					:= IFNULL(Par_Precio, Decimal_Cero);
    SET Par_Telefono 				:= IFNULL(Par_Telefono, Cadena_Vacia);
    SET Par_Referencia 				:= IFNULL(Par_Referencia, Cadena_Vacia);
	SET Par_ComisiProveedor 		:= IFNULL(Par_ComisiProveedor, Decimal_Cero);
	SET Par_ComisiInstitucion 		:= IFNULL(Par_ComisiInstitucion, Decimal_Cero);
	SET Par_IVAComision 			:= IFNULL(Par_IVAComision, Decimal_Cero);
	SET Par_TotalComisiones 		:= IFNULL(Par_TotalComisiones, Decimal_Cero);
	SET Par_TotalPagar 				:= IFNULL(Par_TotalPagar, Decimal_Cero);
	SET Par_Canal 					:= IFNULL(Par_Canal, Cadena_Vacia);

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
				SET Par_NumErr 	= 999;
       			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-BANPSLCOBROSLALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SELECT FechaSistema INTO Var_FechaDate
		FROM PARAMETROSSIS;

		CALL PSLCOBROSLALT (    Par_ProductoID,                 Par_ServicioID,                 Par_ClasificacionServ,              Par_TipoUsuario,                Par_NumeroTarjeta,
                                Par_ClienteID,                  Par_CuentaAhoID,                Par_Producto,                       Par_FormaPago,                  Par_Precio,
                                Par_Telefono,                   Par_Referencia,                 Par_ComisiProveedor,                Par_ComisiInstitucion,          Par_IVAComision,
                                Par_TotalComisiones,            Par_TotalPagar,                 Var_FechaDate,                      Aud_Sucursal,                 	1,
                                1,                   	Par_Canal,                      Par_PolizaID,                       SalidaNO,                       Par_NumErr,
                                Par_ErrMen,                     Par_CobroID,                    Aud_EmpresaID,                      Aud_Usuario,                    Aud_FechaActual,
                                Aud_DireccionIP,                Aud_ProgramaID,                 Aud_Sucursal,                       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			SET Var_Consecutivo  := Entero_Cero;
			SET Var_Control 	 := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Producto registrado correctamente';
		SET Var_Control 	:= 'productoID';
		SET Var_Consecutivo := Par_CobroID;
	END ManejoErrores;


	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr			AS NumErr,
			   Par_ErrMen			AS ErrMen,
			   Var_Control	 		AS control,
			   Var_Consecutivo	    AS consecutivo;
	END IF;


END TerminaStore$$
