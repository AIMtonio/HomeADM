-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOAPORTSUCURSALESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOAPORTSUCURSALESALT`;DELIMITER $$

CREATE PROCEDURE `TIPOAPORTSUCURSALESALT`(
# =======================================================================================
# -- SP PARA DAR DE ALTA SUCURSALES EN LAS QUE ESTARA DISPONIBLE UN TIPO DE APORTACION --
# =======================================================================================
	Par_InstrumentoID		INT(11),	# Id del tipo de producto,
	Par_TipoInstrumentoID	INT(11),    # id de la tabla TIPOINSTRUMENTOS
    Par_SucursalID			INT(11),	# ID de la sucursal
	Par_EstadoID			INT(11),	# ID del estado de la republica
	Par_Estatus				CHAR(1),	# Estatus

	Par_EsPrimero			CHAR(1),	# indica si es el primer registro del grid para q elimine todos los existentes

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
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

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Entero_Uno				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Estatus_Activo 			CHAR(1);
	DECLARE Estatus_Inactivo 		CHAR(1);
	DECLARE EliminarExistentes		CHAR(1);
	DECLARE TipoInstrumentoInver 	INT(11);
	DECLARE TipoInstrumentoAPORT 	INT(11);
	DECLARE TipoInstrumentoAhorr 	INT(11);

	-- Declaracion de variables
	DECLARE varControl 		    	VARCHAR(20);	# almacena el elmento que es incorrecto
	DECLARE Var_TipCuentaSucID		INT(11);

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;		# entero cero
	SET Entero_Uno					:= 1;		# entero uno
	SET Cadena_Vacia				:= '';		# cadena vacia
	SET Estatus_Activo				:= 'A';		# Estatus Activo
	SET Estatus_Inactivo			:= 'I';		# Estatus Inactivo
	SET Salida_SI					:= 'S';		# salida SI
	SET EliminarExistentes			:= 'S';     # Indica si elimina los registros existente para el tipo de producto de credito indicado
	SET TipoInstrumentoInver		:= 13; 		/*Tipo InstrumentoID de la tabla TIPOSINSTRUMENTOS*/
	SET TipoInstrumentoAPORT		:= 31; 		/*Tipo InstrumentoID de la tabla TIPOSINSTRUMENTOS*/
	SET TipoInstrumentoAhorr		:= 2; 		/*Tipo InstrumentoID de la tabla TIPOSINSTRUMENTOS*/

	ManejoErrores:BEGIN 	#bloque para manejar los posibles errores

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TIPOAPORTSUCURSALESALT');
				SET varControl :='SQLEXCEPTION';
			END;

		# Verifica si eliminara los registros existentes para el producto de credito indicado
		IF (Par_EsPrimero = EliminarExistentes) THEN
			DELETE FROM TIPOAPORTSUCURSALES
				WHERE InstrumentoID = Par_InstrumentoID AND TipoInstrumentoID=Par_TipoInstrumentoID;
		END IF;

		IF Par_TipoInstrumentoID=TipoInstrumentoAhorr THEN
			SET varControl  := 'tipoCuentaID' ;
		ELSEIF Par_TipoInstrumentoID=TipoInstrumentoInver THEN
			SET varControl  := 'tipoInversionID' ;
		ELSEIF  Par_TipoInstrumentoID=TipoInstrumentoAPORT THEN
            SET varControl  := 'tipoAportacionID' ;
		END IF;

		IF(IFNULL(Par_InstrumentoID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'Indique el Tipo de Producto.';
			SET varControl  := 'tipoCuentaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_SucursalID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '002';
			SET Par_ErrMen  := 'La Sucursal esta Vacia.';
			SET varControl  := 'sucursalID' ;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_EstadoID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := '005';
			SET Par_ErrMen  := 'El Estado esta Vacio.';
			SET varControl  := 'estadoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Estatus,Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr  := '006';
			SET Par_ErrMen  := 'Indique el Estatus.';
			SET varControl  := 'estatus' ;
			LEAVE ManejoErrores;
		END IF;

		IF (Par_TipoInstrumentoID = TipoInstrumentoAhorr) THEN
			IF NOT EXISTS(SELECT TipoCuentaID
						FROM TIPOSCUENTAS
						WHERE TipoCuentaID = Par_InstrumentoID)THEN
				SET Par_NumErr  := '007';
				SET Par_ErrMen  := 'NO existe el Tipo de Cuenta.';
				SET varControl  := 'tipoCuentaID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_TipoInstrumentoID =TipoInstrumentoInver) THEN
			IF NOT EXISTS(SELECT TipoInversionID
						FROM CATINVERSION
						WHERE TipoInversionID = Par_InstrumentoID)THEN
				SET Par_NumErr  := '007';
				SET Par_ErrMen  := 'NO existe el Tipo de Inversion.';
				SET varControl  := 'tipoInversionID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF (Par_TipoInstrumentoID =TipoInstrumentoAPORT) THEN
			IF NOT EXISTS(SELECT TipoAportacionID
						FROM TIPOSAPORTACIONES
						WHERE TipoAportacionID = Par_InstrumentoID)THEN
				SET Par_NumErr  := '007';
				SET Par_ErrMen  := 'NO existe el Tipo de Aportacion.';
				SET varControl  := 'tipoAportacionID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF EXISTS(SELECT InstrumentoID
					FROM TIPOAPORTSUCURSALES
					WHERE	SucursalID			= Par_SucursalID
					AND 	InstrumentoID		= Par_InstrumentoID
					AND 	Estatus 			= Estatus_Activo
                    AND 	TipoInstrumentoID	= Par_TipoInstrumentoID)THEN
			SET Par_NumErr  := '008';
			SET Par_ErrMen  := CONCAT('El Tipo de Producto ya se Encuentra Registrado para la Sucursal: ',Par_SucursalID) ;
			LEAVE ManejoErrores;
		END IF;



		IF(Par_Estatus = Estatus_Activo)THEN

			IF (Par_TipoInstrumentoID =TipoInstrumentoAhorr) THEN
				UPDATE TIPOSCUENTAS SET Estatus = Estatus_Activo WHERE TipoCuentaID = Par_InstrumentoID;
			END IF;
			/* efectuamos la insercion  */
			SET Aud_FechaActual := NOW();

			SET Var_TipCuentaSucID	:= (SELECT IFNULL(MAX(TipProdSucID),Entero_Cero)+Entero_Uno
										FROM TIPOAPORTSUCURSALES);

			 INSERT INTO TIPOAPORTSUCURSALES(
				TipProdSucID,		InstrumentoID,		TipoInstrumentoID,		SucursalID,			EstadoID,
				Estatus,			EmpresaID,			Usuario,				FechaActual,		DireccionIP,
                ProgramaID,			Sucursal,			NumTransaccion)

			 VALUES(
				Var_TipCuentaSucID,	Par_InstrumentoID,	Par_TipoInstrumentoID,	Par_SucursalID,		Par_EstadoID,
                Par_Estatus,		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		ELSE
			DELETE FROM TIPOAPORTSUCURSALES
				WHERE InstrumentoID 		= 	Par_InstrumentoID
					AND SucursalID 			= 	Par_SucursalID
					AND Estatus 			= 	Estatus_Inactivo
					AND TipoInstrumentoID	=	Par_TipoInstrumentoID;
		END IF;


		SET Par_NumErr  := '000';
		SET Par_ErrMen  := 'Sucursal(es) Grabada(s) Exitosamente.';
		SET varControl  :=varControl;
		LEAVE ManejoErrores;


	END ManejoErrores; /*fin del manejador de errores*/

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
				varControl		AS control,
				Par_InstrumentoID AS consecutivo;
	END IF;
END TerminaStore$$