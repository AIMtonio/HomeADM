-- SP NOMDETCAPACIDADPAGOSOLBAJ

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMDETCAPACIDADPAGOSOLBAJ;

DELIMITER $$


CREATE PROCEDURE NOMDETCAPACIDADPAGOSOLBAJ(
	-- Stored Procedure para dar de Baja los Detalle de claves presupuestales por sus numero de capacidad de pago por solicitud de Credito
	Par_NomCapacidadPagoSolID			BIGINT(12),			-- Numero o ID de la Tabla de Capacidad de pago por Solicitud de Credito.
	Par_NumBaj							TINYINT UNSIGNED,	-- Numero de baja

	Par_Salida							CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr					INT(11),			-- Parametro de Numero de Error
	INOUT Par_ErrMen					VARCHAR(400),		-- Parametro de Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),			-- ID de la Empresa
	Aud_Usuario							INT(11),			-- ID del Usuario que creo el Registro
	Aud_FechaActual						DATETIME,			-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP						VARCHAR(15),		-- Direccion IP de la computadora
	Aud_ProgramaID						VARCHAR(50),		-- Identificador del Programa
	Aud_Sucursal						INT(11),			-- Identificador de la Sucursal
	Aud_NumTransaccion					BIGINT(20)			-- Numero de Transaccion
)TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero					INT(11);			-- Entero vacio
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;			-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);			-- Salida Si
	DECLARE Var_BajaMasiva				TINYINT UNSIGNED;	-- Proceso para eliminar los detalles de los datos socioeconomicos por convenio de nomina para la solicitud de credito

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);			-- Variable Consecutivo

	-- Asignacion de Constantes
	SET Entero_Cero						:= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					:= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de Fecha Vacia
	SET SalidaSI						:= 'S';				-- Asignacion de Salida SI
	SET Var_BajaMasiva					:= 1;				-- Proceso para eliminar los detalles de los datos socioeconomicos por convenio de nomina para la solicitud de credito

	-- Declaracion de Valores Default
	SET Par_NomCapacidadPagoSolID			:= IFNULL(Par_NomCapacidadPagoSolID, Entero_Cero);

ManejoErrores:BEGIN

	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-NOMDETCAPACIDADPAGOSOLBAJ");
		SET Var_Control = 'sqlException';
	END;

	-- Proceso para eliminar los tipos de claves Presupuestales por su ID
	IF(Par_NumBaj = Var_BajaMasiva) THEN

		DELETE FROM NOMDETCAPACIDADPAGOSOL
			WHERE NomCapacidadPagoSolID = Par_NomCapacidadPagoSolID;

		-- Notificamos el mensaje de exito en borrado de tipos de claves Presupuestales por su ID
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Baja Realizado exitosamente';
		SET Var_Consecutivo	:= Entero_Cero;
		SET Var_Control	:= 'registroCompleto';
		LEAVE ManejoErrores;
	END IF;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	control,
				Var_Consecutivo			AS	consecutivo;
	END IF;
END TerminaStore$$
