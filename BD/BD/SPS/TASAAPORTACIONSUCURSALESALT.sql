-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASAAPORTACIONSUCURSALESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASAAPORTACIONSUCURSALESALT`;DELIMITER $$

CREATE PROCEDURE `TASAAPORTACIONSUCURSALESALT`(
# ============================================================================================
# -----SP PARA DAR DE ALTA SUCURSALES EN LAS QUE ESTARA DISPONIBLE UN TIPO DE APORTACION -----
# ============================================================================================
	Par_TasaAportacionID	INT(11),		-- ID de la tasa
	Par_TipoAportacionID	INT(11),    	-- id del Tipo de Aportacion
	Par_SucursalID			INT(11),		-- ID de la sucursal
	Par_EstadoID			INT(11),		-- ID del estado de la republica
	Par_Estatus				CHAR(1),		-- Estatus

	Par_Salida				CHAR(1), 		-- Especifica salida
	INOUT Par_NumErr		INT(11),		-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE varControl 		    VARCHAR(20);	-- Almacena control
	DECLARE Var_TipCuentaSucID	INT(11);		-- ID del tipo de cuenta de sucursal

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);		-- Entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Decimal cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE Salida_SI			CHAR(1);		-- Salida SI
	DECLARE Estatus_Activo 		CHAR(1);		-- Estatus activo
	DECLARE Estatus_Inactivo 	CHAR(1);		-- Estatus inactivo
	DECLARE EliminarExistentes	CHAR(1);		-- Indica si elimina los registros existentes

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
									    'Disculpe las molestias que esto le ocasiona. Ref: SP-TASAAPORTACIONSUCURSALESALT');
				SET varControl = 'SQLEXCEPTION' ;
			END;


		IF(IFNULL(Par_TipoAportacionID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Indique el Tipo de Aportacion.';
			SET varControl  := 'tipoAportacionID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TasaAportacionID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero de Tasa esta vacio.';
			SET varControl  := 'tasaAportacionID' ;
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
			SET Var_TipCuentaSucID 	:= (SELECT MAX(TasaAportSucID)FROM TASAAPORTSUCURSALES);
			SET Var_TipCuentaSucID 	:= IFNULL(Var_TipCuentaSucID,Entero_Cero)+1;

			INSERT INTO TASAAPORTSUCURSALES(
				TasaAportSucID,	TipoAportacionID,	TasaAportacionID,		SucursalID,			EstadoID,
                Estatus,				EmpresaID,			Usuario,				FechaActual,		DireccionIP,
                ProgramaID,				Sucursal,			NumTransaccion)

			VALUES(
				Var_TipCuentaSucID,	Par_TipoAportacionID,	Par_TasaAportacionID,	Par_SucursalID,		Par_EstadoID,
                Par_Estatus,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		END IF;


		SET Par_NumErr  := 000;
		SET Par_ErrMen  := 'Sucursal(es) Grabada(s) Exitosamente.';
		SET varControl  := 'tasaAportacionID' ;


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr		 	AS NumErr,
				Par_ErrMen		 	AS ErrMen,
				varControl		 	AS control,
				Var_TipCuentaSucID 	AS consecutivo;
	END IF;
END TerminaStore$$