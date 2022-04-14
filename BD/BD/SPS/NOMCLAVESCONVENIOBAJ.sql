-- SP NOMCLAVESCONVENIOBAJ

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLAVESCONVENIOBAJ;

DELIMITER $$


CREATE PROCEDURE NOMCLAVESCONVENIOBAJ(
	-- Stored Procedure para Eliminar las claves presupuestales por convenio de nomina
	Par_NomClaveConvenioID				INT(11),			-- Id de la Tabla del Claves Presupuestales por Convenios de Nomina.
	Par_InstitNominaID					INT(11),			-- ID o Numero de Institucion de Nomina
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
	DECLARE Entero_Cero					INT(11);			-- Entero vacio
	DECLARE Cadena_Vacia				CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;			-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);			-- Salida Si
	DECLARE Var_BajaClavConve			TINYINT UNSIGNED;	-- Proceso para eliminar los registro por convenio de nomina

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);		-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);			-- Variable Consecutivo
	DECLARE Var_NomClaveConvenioID		INT(11);		-- Numero o Id de la Tabla del Claves por convenio de nomina

	-- Asignacion de Constantes
	SET Entero_Cero						= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';		-- Asignacion de Fecha Vacia
	SET SalidaSI						= 'S';				-- Asignacion de Salida SI
	SET Var_BajaClavConve				:= 1;				-- Proceso para eliminar los registro por convenio de nomina

	-- Declaracion de Valores Default
	SET Par_NomClaveConvenioID			:= IFNULL(Par_NomClaveConvenioID, Entero_Cero);
	SET Par_InstitNominaID				:= IFNULL(Par_InstitNominaID, Entero_Cero);

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-NOMCLAVESCONVENIOBAJ");
		SET Var_Control = 'sqlException';
	END;

	-- Proceso para eliminar los registro por convenio de nomina
	IF(Par_NumBaj = Var_BajaClavConve) THEN

		IF(Par_NomClaveConvenioID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especifique el Numero de Clave por Convenio de Nomina a Eliminar.';
			SET Var_Control := 'nomClaveConvenioID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_InstitNominaID = Entero_Cero) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'Especifique el Numero de la Empresa de Nomina a Eliminar.';
			SET Var_Control := 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT NomClaveConvenioID
			INTO Var_NomClaveConvenioID
				FROM NOMCLAVESCONVENIO
				WHERE NomClaveConvenioID = Par_NomClaveConvenioID
				AND InstitNominaID = Par_InstitNominaID;

		IF(IFNULL(Var_NomClaveConvenioID,Entero_Cero ) = Entero_Cero) THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El Numero de Tipo Clave Presupuestal Para la Empresa de Nomina a Eliminar no Existe.';
			SET Var_Control := 'nomClaveConvenioID';
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM NOMCLAVESCONVENIO
			WHERE NomClaveConvenioID = Par_NomClaveConvenioID
			AND InstitNominaID = Par_InstitNominaID;

		-- Notificamos el mensaje de exito en borrado de tipos de claves Presupuestales por su ID
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Claves por Convenio de Nomina Eliminadas Exitosamente';
		SET Var_Consecutivo	:= Par_InstitNominaID;
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
