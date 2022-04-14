-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASACEDESUCURSALESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASACEDESUCURSALESALT`;DELIMITER $$

CREATE PROCEDURE `TASACEDESUCURSALESALT`(
# =====================================================================================
# -----SP PARA DAR DE ALTA SUCURSALES EN LAS QUE ESTARA DISPONIBLE UN TIPO DE CEDE-----
# =====================================================================================
	Par_TasaCedeID			INT(11),	# Id de la tasa,
	Par_TipoCedeID			INT(11),    # id del Tipo de CEDES
	Par_SucursalID			INT(11),	# ID de la sucursal
	Par_EstadoID			INT(11),	# ID del estado de la republica
	Par_Estatus				CHAR(1),	# Estatus

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN 	#bloque main del sp

	-- Declaracion de variables
	DECLARE varControl 		    VARCHAR(20);	# almacena el elmento que es incorrecto
	DECLARE Var_TipCuentaSucID	INT(11);

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);		# entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);	# DECIMAL cero
	DECLARE Cadena_Vacia		CHAR(1);		# cadena vacia
	DECLARE Salida_SI			CHAR(1);		# salida SI
	DECLARE Estatus_Activo 		CHAR(1);		# Estatus activo
	DECLARE Estatus_Inactivo 	CHAR(1);		# Estatus inactivo
	DECLARE EliminarExistentes	CHAR(1);		# Indica si elimina los registros existente para el tipo de producto de credito indicado

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Cadena_Vacia		:='';
	SET Estatus_Activo		:= 'A';
	SET Estatus_Inactivo	:= 'I';
	SET Salida_SI			:= 'S';
	SET EliminarExistentes	:= 'S';



	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TASACEDESUCURSALESALT');
				SET varControl = 'SQLEXCEPTION' ;
			END;


		IF(IFNULL(Par_TipoCedeID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Indique el Tipo de CEDES.';
			SET varControl  := 'tipoCedeID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TasaCedeID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero de Tasa esta vacio.';
			SET varControl  := 'tasaCedeID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_SucursalID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'La Sucursal esta Vacia.';
			SET varControl  := 'sucursalID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EstadoID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 005;
			SET Par_ErrMen  := 'El Estado esta Vacio.';
			SET varControl  := 'estadoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Estatus,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := 006;
			SET Par_ErrMen  := 'Indique el Estatus.';
			SET varControl  := 'estatus' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Estatus = Estatus_Activo)THEN

			/* efectuamos la insercion  */
			SET Aud_FechaActual 	:= NOW();
			SET Var_TipCuentaSucID 	:= (SELECT MAX(TasaCedeSucID)FROM TASACEDESUCURSALES);
			SET Var_TipCuentaSucID 	:= IFNULL(Var_TipCuentaSucID,Entero_Cero)+1;

			INSERT INTO TASACEDESUCURSALES(
				TasaCedeSucID,		TipoCedeID,			TasaCedeID,			SucursalID,			EstadoID,
                Estatus,			EmpresaID,			Usuario,			FechaActual,		DireccionIP,
                ProgramaID,			Sucursal,			NumTransaccion)

			VALUES(
				Var_TipCuentaSucID,	Par_TipoCedeID,		Par_TasaCedeID,		Par_SucursalID,		Par_EstadoID,
                Par_Estatus,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		END IF;


		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Sucursal(es) Grabada(s) Exitosamente.';
		SET varControl  := 'tasaCedeID' ;


	END ManejoErrores; /*fin del manejador de errores*/

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr		 	AS NumErr,
				Par_ErrMen		 	AS ErrMen,
				varControl		 	AS control,
				Var_TipCuentaSucID 	AS consecutivo;
	END IF;
END TerminaStore$$