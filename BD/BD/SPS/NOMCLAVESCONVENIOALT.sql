-- SP NOMCLAVESCONVENIOALT

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLAVESCONVENIOALT;

DELIMITER $$


CREATE PROCEDURE NOMCLAVESCONVENIOALT(
	-- Stored Procedure para dar de alta las claves presupuestales por convenio de nomina
	Par_InstitNominaID					INT(11),		-- ID o Numero de Institucion de Nomina
	Par_ConvenioNominaID				BIGINT(20),		-- Id o numero de  Convenio de Institucion de Nomina
	Par_NomClavePresupID				VARCHAR(3000),	-- Id o numero de las Claves Presupuestales

	Par_Salida							CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr					INT(11),		-- Parametro de Numero de Error
	INOUT Par_ErrMen					VARCHAR(400),	-- Parametro de Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),		-- ID de la Empresa
	Aud_Usuario							INT(11),		-- ID del Usuario que creo el Registro
	Aud_FechaActual						DATETIME,		-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP						VARCHAR(15),	-- Direccion IP de la computadora
	Aud_ProgramaID						VARCHAR(50),	-- Identificador del Programa
	Aud_Sucursal						INT(11),		-- Identificador de la Sucursal
	Aud_NumTransaccion					BIGINT(20)		-- Numero de Transaccion
)TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero					INT(11);		-- Entero vacio
	DECLARE Cadena_Vacia				CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia					DATETIME;		-- Fecha Vacia
	DECLARE SalidaSI					CHAR(1);		-- Salida Si
	DECLARE Cons_SI						CHAR(1);		-- Salida Si
	DECLARE Cons_NO						CHAR(1);		-- Salida Si

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);	-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);		-- Variable Consecutivo
	DECLARE Var_NomClaveConvenioID		INT(11);		-- Numero o Id de la Tabla del Claves por convenio de nomina
	DECLARE Var_InstitNominaID			INT(11);		-- Variable de la institucion de nomina
	DECLARE Var_ConvenioNominaID		BIGINT(11);		-- Variable de Convenio de Nomina
	DECLARE Var_ContClaveConvenioID		INT(11);		-- Variable de cantidad de convenio  asignadas a claves
	DECLARE Var_ContCadena				INT(11);		-- Variable del contador del cliclo while
	DECLARE Var_CantCadena				INT(11);		-- Variable que tiene la cantidad de caracteres en al cadena
	DECLARE Var_NomClavePresupID		INT(11);		--  Variable para GUardar el id de la clave presupuestal
	DECLARE Var_ClavePresupID			INT(11);		--  Variable para GUardar el id de la clave presupuestal
	DECLARE Var_Clave					CHAR(8);		-- Variable Indica el Clave que corresponde al registro presupuestal 
	DECLARE Var_Descripcion				VARCHAR(80);	-- Variable Descripcion o nombre del clave presupuestal
	DECLARE Var_ClavesPresupuestales	VARCHAR(3001);	-- Cadema de los numero o ID de la Tabla del Claves Presupuestales
	DECLARE Var_ClavesFinales 			VARCHAR(3001);	-- Cadema de los numero o ID de la Tabla del Claves Presupuestales


	-- Asignacion de Constantes
	SET Entero_Cero						= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						= '1900-01-01';		-- Asignacion de Fecha Vacia
	SET SalidaSI						= 'S';				-- Asignacion de Salida SI
	SET Cons_SI							= 'S';				-- Salida Si
	SET Cons_NO							= 'N';				-- Salida Si

	-- Declaracion de Valores Default
	SET Par_InstitNominaID				:= IFNULL(Par_InstitNominaID, Entero_Cero);
	SET Par_ConvenioNominaID			:= IFNULL(Par_ConvenioNominaID, Entero_Cero);
	SET Par_NomClavePresupID			:= IFNULL(Par_NomClavePresupID, Cadena_Vacia);

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que esto le ocasiona. Ref: SP-NOMCLAVESCONVENIOALT");
		SET Var_Control = 'sqlException';
	END;

	IF(Par_InstitNominaID = Entero_Cero) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'Especifique el Numero de la Empresa de Nomina.';
		SET Var_Control := 'institucionID';
		LEAVE ManejoErrores;
	END IF;

	SELECT InstitNominaID
		INTO Var_InstitNominaID
		FROM INSTITNOMINA
		WHERE InstitNominaID = Par_InstitNominaID;

	IF(IFNULL(Var_InstitNominaID , Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Numero de la Empresa de Nomina no Existe.';
		SET Var_Control := 'institucionID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ConvenioNominaID < Entero_Cero) THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'Especifique el Numero de Convenio de Nomina.';
		SET Var_Control := 'convenioID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ConvenioNominaID > Entero_Cero) THEN
		SELECT ConvenioNominaID
			INTO Var_ConvenioNominaID
			FROM CONVENIOSNOMINA 
			WHERE InstitNominaID = Par_InstitNominaID
			AND ConvenioNominaID = Par_ConvenioNominaID;

		IF(IFNULL(Var_ConvenioNominaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El Numero de Convenio de Nomina no Existe o no se Encuentra Asignada a la Institucion de Nomina.';
			SET Var_Control := 'convenioID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Par_ConvenioNominaID = Entero_Cero) THEN
		SELECT COUNT(NomClaveConvenioID)
			INTO Var_ContClaveConvenioID
			FROM NOMCLAVESCONVENIO
			WHERE InstitNominaID = Par_InstitNominaID;
	END IF;

	IF (Par_ConvenioNominaID > Entero_Cero) THEN
		SELECT COUNT(NomClaveConvenioID)
			INTO Var_ContClaveConvenioID
			FROM NOMCLAVESCONVENIO
			WHERE InstitNominaID = Par_InstitNominaID
			AND ConvenioNominaID = IF(ConvenioNominaID <> Entero_Cero, Par_ConvenioNominaID ,ConvenioNominaID);
	END IF;

	IF(Var_ContClaveConvenioID > Entero_Cero) THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'La Institucion de Nomina ya tiene Convenio de Nomina Asignadas Claves Presupuestales.';
		SET Var_Control := 'convenioID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_NomClavePresupID = Cadena_Vacia) THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'Se requiere al menos una Clave Presupuestal.';
		SET Var_Control := 'nomClavePresupID';
		LEAVE ManejoErrores;
	END IF;

	SET Var_ClavesPresupuestales	:= CONCAT(Par_NomClavePresupID,",");
	SET Var_ClavesFinales := Cadena_Vacia;

	-- si por alguna razón se intenta asignar a otra clasificación el sistema deberá de mostrar una alerta indicando que ya la clase ya se tienen asignado a otra clasificación. 
	SET Var_ContCadena = 1;
	SELECT POSITION("," IN Var_ClavesPresupuestales) INTO Var_CantCadena;

	WHILE Var_CantCadena > Var_ContCadena  DO
		SET Var_ClavePresupID := NULL;

		-- Obtenemos el Primer valor de la cadena ante del delimitador coma
		SELECT LEFT(Var_ClavesPresupuestales,Var_CantCadena - 1) INTO Var_NomClavePresupID;

		SELECT NomClavePresupID, Clave,Descripcion
			INTO Var_ClavePresupID, Var_Clave, Var_Descripcion
			FROM NOMCLAVEPRESUP
			WHERE NomClavePresupID = Var_NomClavePresupID;

			SET Var_Clave		:= IFNULL(Var_Clave, Cadena_Vacia);
			SET Var_Descripcion	:= IFNULL(Var_Descripcion, Cadena_Vacia);

			IF( IFNULL (Var_ClavePresupID , Entero_Cero) <> Entero_Cero) THEN
				SET Var_ClavesFinales := CONCAT(Var_ClavesFinales, Var_NomClavePresupID, ",");
			END IF;

			SELECT SUBSTRING(Var_ClavesPresupuestales, Var_CantCadena + 1, LENGTH(Var_ClavesPresupuestales)) INTO Var_ClavesPresupuestales ;
			SELECT POSITION(',' IN Var_ClavesPresupuestales) INTO Var_CantCadena;
	END WHILE;

	IF(LENGTH(Var_ClavesFinales) > Entero_Cero) THEN
		SET Var_ClavesFinales := SUBSTRING(Var_ClavesFinales, 1, LENGTH(Var_ClavesFinales) - 1);
	END IF;
	

	IF(LENGTH(Var_ClavesFinales) = Entero_Cero) THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := CONCAT("No se encontraron las claves presupuestales a registrar.");
		SET Var_Control := 'nomClavePresupID';
		LEAVE ManejoErrores;
	END IF;

	SELECT 	MAX(NomClaveConvenioID)
			INTO Var_NomClaveConvenioID	
		FROM NOMCLAVESCONVENIO;

	SET Var_NomClaveConvenioID := IFNULL(Var_NomClaveConvenioID, Entero_Cero) + 1;

	INSERT INTO NOMCLAVESCONVENIO(	NomClaveConvenioID,			InstitNominaID,				ConvenioNominaID,		NomClavePresupID,			EmpresaID,
									Usuario,					FechaActual,				DireccionIP,			ProgramaID,					Sucursal,
									NumTransaccion)

							VALUES(	Var_NomClaveConvenioID,		Par_InstitNominaID,			Par_ConvenioNominaID,	Var_ClavesFinales,			Aud_EmpresaID,
									Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
									Aud_NumTransaccion);


		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Claves por Convenio de Nomina Registradas Correctamente';
		SET Var_Consecutivo	:= Par_InstitNominaID;
		SET Var_Control	:= 'registroCompleto';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida =SalidaSI) THEN
		SELECT 	Par_NumErr				AS 	NumErr,
				Par_ErrMen				AS	ErrMen,
				Var_Control				AS	control,
				Var_Consecutivo			AS	consecutivo;
	END IF;
END TerminaStore$$
