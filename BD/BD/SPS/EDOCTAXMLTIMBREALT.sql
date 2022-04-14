-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAXMLTIMBREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAXMLTIMBREALT`;DELIMITER $$

CREATE PROCEDURE `EDOCTAXMLTIMBREALT`(
	-- Stored Procedure para dar de alta la cadena xml que corresponde al timbrado del estado de cuenta
	Par_AnioMes						INT(11),				-- Periodo del estado de cuenta
	Par_ClienteID					INT(11),				-- ID de Cliente
	Par_Xml							TEXT,					-- Cadena XML
	Par_TipoTimbrado 				CHAR(1), 				-- Tipo de Timbrado I = Ingreso, E = Egreso

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;					-- Entero vacio
	DECLARE Decimal_Cero			DECIMAL(2, 1);			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE SalidaNO				CHAR(1);				-- Salida no
	DECLARE Var_TipoIngreso 		CHAR(1);				-- Tipo timbrado Ingreso
	DECLARE Var_TipoEgreso	 		CHAR(1);				-- Tipo timbrado Egreso

	-- Declaracion de variables
	DECLARE Var_Consecutivo 		INT(11);				-- Consecutivo
	DECLARE Var_ClienteID 			INT(11);				-- ID del cliente
	DECLARE Var_AnioMes 			INT(11); 				-- Anio y Mes del Periodo

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero vacio
	SET Decimal_Cero				:= 0.0;					-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET SalidaNO					:= 'N';					-- Asignacion de salida no
	SET Var_TipoIngreso 			:= 'I';				-- Tipo timbrado Ingreso
	SET Var_TipoEgreso	 			:= 'E';				-- Tipo timbrado Egreso


	-- Valores por default
	SET Par_AnioMes					:= IFNULL(Par_AnioMes, Entero_Cero);
	SET Par_ClienteID				:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_Xml						:= IFNULL(Par_Xml, Cadena_Vacia);
	SET Par_TipoTimbrado 			:= IFNULL(Par_TipoTimbrado, Cadena_Vacia);

	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
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
											'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAXMLTIMBREALT');
			END;

		IF(Par_AnioMes = Entero_Cero) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El anio y mes esta vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClienteID = Entero_Cero) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El ID del cliente esta vacio';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Xml = Cadena_Vacia) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'La cadena xml esta vacia.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT NULL INTO Var_ClienteID;

		SELECT ClienteID INTO Var_ClienteID
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

		IF(Var_ClienteID IS NULL) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'No se encontro el cliente especificado.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoTimbrado NOT IN (Var_TipoIngreso, Var_TipoEgreso)) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'Tipo de timbrado no valido';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT AnioMes
			INTO Var_AnioMes
			FROM EDOCTAXMLTIMBRE
			WHERE AnioMes = Par_AnioMes
			AND ClienteID = Par_ClienteID
			AND TipoTimbrado = Par_TipoTimbrado;

		IF(Var_AnioMes IS NOT NULL) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'Ya existe un timbre con la informacion proporcionada';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		INSERT INTO EDOCTAXMLTIMBRE (		AnioMes,				ClienteID,				Xml,					TipoTimbrado, 			EmpresaID,
											Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
											NumTransaccion
			)
			VALUES (						Par_AnioMes, 			Par_ClienteID, 			Par_Xml,				Par_TipoTimbrado, 		Par_EmpresaID,
											Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
											Aud_NumTransaccion
			);

		-- El registro se inserto exitosamente
		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Cadena XML guardada correctamente';
		SET Var_Consecutivo := Par_ClienteID;
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				'clienteID'		AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

-- Fin del SP
END TerminaStore$$