-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLCOBROSLACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLCOBROSLACT`;DELIMITER $$

CREATE PROCEDURE `PSLCOBROSLACT`(
	-- Stored procedure para actualizar los registros de cobro de servicios en linea
	Par_CobroID 					BIGINT(20), 			-- ID del Cobro de Servicio
	Par_PolizaID 					BIGINT(20),				-- Identificador de la poliza contable

	Par_NumAct 						INT(11), 				-- Numero de actualizacion

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen 				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Decimal_Cero 			DECIMAL(2, 1); 			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE SalidaNO				CHAR(1);				-- Salida no
	DECLARE Var_SI 					CHAR(1);				-- Variable con valor si
	DECLARE Var_NO 					CHAR(1);				-- Variable con valor no
	DECLARE Var_EstTransito 		CHAR(1);				-- Estatus de cobro de servicio En Transito
	DECLARE Var_EstEfectuado 		CHAR(1);				-- Estatus de cobro de servicio Efectuado
	DECLARE Var_EstCancelado 		CHAR(1);				-- Estatus de cobro de servicio Cancelado
	DECLARE Var_ActCancelaCob 		INT(11);				-- Actualizacion para cancelar el Cobro de un servicio
	DECLARE Var_ConfirmCob 			INT(11);				-- Actualizacion para finalizar cobro de Servicio

	-- Declaracion de variables
	DECLARE Var_CobroID 			BIGINT(20); 			-- Identificador del Cobro
	DECLARE Var_Estatus 			CHAR(1); 				-- Estatus de cobro de servicio

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero 				:= 0.0; 				-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_SI 						:= 'S';					-- Asignacion de salida si
	SET Var_NO 						:= 'N';					-- Asignacion de salida no
	SET Var_EstTransito 			:= 'T';					-- Estatus de cobro de servicio En Transito
	SET Var_EstEfectuado 			:= 'E'; 				-- Estatus de cobro de servicio Efectuado
	SET Var_EstCancelado 			:= 'C'; 				-- Estatus de cobro de servicio Cancelado
	SET Var_ActCancelaCob 			:= 1; 					-- Actualizacion para cancelar el Cobro de un servicio
	SET Var_ConfirmCob 				:= 2;					-- Actualizacion para finalizar cobro de Servicio

	-- Valores por default
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
				SET Par_NumErr = 999;
       			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-PSLCOBROSLACT');
			END;

		IF(Par_NumAct = Var_ActCancelaCob) THEN
			SELECT 		CobroID, 		Estatus
				INTO 	Var_CobroID, 	Var_Estatus
				FROM PSLCOBROSL
				WHERE CobroID = Par_CobroID;

			SET Var_CobroID := IFNULL(Var_CobroID, Entero_Cero);
			SET Var_Estatus := IFNULL(Var_Estatus, Cadena_Vacia);

			IF(Var_CobroID = Entero_Cero) THEN
				SET Par_NumErr	:= 1;
				SET Par_ErrMen	:= 'ID del Cobro de Servicios en linea no valido.';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Var_EstCancelado) THEN
				SET Par_NumErr	:= 3;
				SET Par_ErrMen	:= 'El cobro ya se encuentra cancelado.';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Var_EstTransito) THEN
				SET Par_NumErr	:= 3;
				SET Par_ErrMen	:= 'El cobro no puede ser cancelado.';
				LEAVE ManejoErrores;
			END IF;

			UPDATE PSLCOBROSL
				SET Estatus 		= Var_EstCancelado,
					PolizaID 		= Par_PolizaID,
					EmpresaID		= Aud_EmpresaID,
					Usuario 		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal 		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
				WHERE CobroID = Par_CobroID;

			SET Par_NumErr		:= 0;
			SET Par_ErrMen		:= 'Baja de Cobro de Servicio realizada correctamente.';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = Var_ConfirmCob) THEN
			SELECT 		CobroID, 		Estatus
				INTO 	Var_CobroID, 	Var_Estatus
				FROM PSLCOBROSL
				WHERE CobroID = Par_CobroID;

			SET Var_CobroID := IFNULL(Var_CobroID, Entero_Cero);
			SET Var_Estatus := IFNULL(Var_Estatus, Cadena_Vacia);

			IF(Var_CobroID = Entero_Cero) THEN
				SET Par_NumErr	:= 1;
				SET Par_ErrMen	:= 'ID del Cobro de Servicios en linea no valido.';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus = Var_EstEfectuado) THEN
				SET Par_NumErr	:= 2;
				SET Par_ErrMen	:= 'El cobro ya se encuentra marcado como exitoso.';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_Estatus <> Var_EstTransito) THEN
				SET Par_NumErr	:= 3;
				SET Par_ErrMen	:= 'El cobro no puede ser actualizado como exitoso.';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_PolizaID = Decimal_Cero) THEN
				SET Par_NumErr	:= 4;
				SET Par_ErrMen	:= 'Identificador de la poliza vacio.';
				LEAVE ManejoErrores;
			END IF;

			UPDATE PSLCOBROSL
				SET Estatus 		= Var_EstEfectuado,
					PolizaID 		= Par_PolizaID,
					EmpresaID		= Aud_EmpresaID,
					Usuario 		= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal 		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
				WHERE CobroID = Par_CobroID;

			SET Par_NumErr		:= 0;
			SET Par_ErrMen		:= 'Confirmacion de Cobro de Servicio realizada correctamente.';
			LEAVE ManejoErrores;
		END IF;

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 1;
		SET Par_ErrMen		:= 'Numero de actualizacion no encontrada.';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr		AS NumErr,
			   Par_ErrMen		AS ErrMen,
			   'productoID' 	AS control,
			   Par_CobroID	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$