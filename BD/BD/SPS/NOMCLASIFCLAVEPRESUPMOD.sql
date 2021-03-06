-- SP NOMCLASIFCLAVEPRESUPMOD

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLASIFCLAVEPRESUPMOD;

DELIMITER $$


CREATE PROCEDURE NOMCLASIFCLAVEPRESUPMOD(
	-- Stored Procedure para la Modificacion de los Clasificaciones de claves presupuestales
	Par_NomClasifClavPresupID			INT(11),		-- Numero o Id de la Tabla del Clasificacion de Claves Presupuestales
	Par_Estatus							CHAR(1),		-- Indica el Estatus de la Clasificacion de clave presupuestal  Nace A=Activo,I=Inactivo
	Par_Descripcion						VARCHAR(100),	-- Indica el tipo de clasificacion de clave presupuestal
	Par_Prioridad						INT(11),		-- Numero de la Prioridad de la Clasificacion de Clave Presupuestal
	Par_NomClavePresupID				VARCHAR(3000),	-- Cadema de los numero o ID de la Tabla del Claves Presupuestales

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
	DECLARE EstatusActivo				CHAR(1);		-- Indica el Estatus de la Clasificacion de clave presupuestal  Nace A=Activo
	DECLARE EstatusInactiva				CHAR(1);		-- Indica el Estatus de la Clasificacion de clave presupuestal  Nace I=Inactivo

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);	-- Variable de Control SQL
	DECLARE	Var_Consecutivo				BIGINT(20);		-- Variable Consecutivo
	DECLARE Var_NomClasifClavPresupID	INT(11);		-- Id de la Tabla del Clasificacion de Claves Presupuestales
	DECLARE Var_CountClasifClavPresupID	INT(11);		-- Comtador si existe clasificacion asignada con la misma prioridad

	DECLARE Var_ContCadena				INT(11);		-- Variable del contador del cliclo while
	DECLARE Var_CantCadena				INT(11);		-- Variable que tiene la cantidad de caracteres en al cadena
	DECLARE Var_NomClavePresupID		INT(11);		--  Variable para GUardar el id de la clave presupuestal
	DECLARE Var_Longitud				INT(11);		-- Variable para guardar la longitud de la cadena obtenida
	DECLARE Var_ClavePresupID			INT(11);		--  Variable para GUardar el id de la clave presupuestal
	DECLARE Var_Clave					CHAR(8);		-- Variable Indica el Clave que corresponde al registro presupuestal 
	DECLARE Var_Descripcion				VARCHAR(80);	-- Variable Descripcion o nombre del clave presupuestal
	DECLARE Var_ConClasifClave			INT(11);		-- Variable para guardar si ya existe la clave ligada auna clasificacion
	DECLARE Var_ClavesPresupuestales	VARCHAR(3001);	-- Cadema de los numero o ID de la Tabla del Claves Presupuestales

	-- Asignacion de Constantes
	SET Entero_Cero						:= 0;				-- Asignacion de Entero Vacio
	SET	Cadena_Vacia					:= '';				-- Asignacion de Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Asignacion de Fecha Vacia
	SET SalidaSI						:= 'S';				-- Asignacion de Salida SI
	SET Cons_SI							:= 'S';				-- Salida Si
	SET Cons_NO							:= 'N';				-- Salida Si
	SET EstatusActivo					:= 'A';				-- Indica el Estatus de la Clasificacion de clave presupuestal  Nace A=Activo
	SET EstatusInactiva					:= 'I';				-- Indica el Estatus de la Clasificacion de clave presupuestal  Nace I=Inactivo

	-- Declaracion de Valores Default
	SET Par_NomClasifClavPresupID		:= IFNULL(Par_NomClasifClavPresupID, Entero_Cero);
	SET Par_Estatus						:= IFNULL(Par_Estatus, Cadena_Vacia);
	SET Par_Descripcion					:= IFNULL(Par_Descripcion, Cadena_Vacia);
	SET Par_Prioridad					:= IFNULL(Par_Prioridad, Entero_Cero);
	SET Par_NomClavePresupID			:= IFNULL(Par_NomClavePresupID, Cadena_Vacia);

ManejoErrores:BEGIN

	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat("El SAFI ha tenido un problema al concretar la operaci??n. Disculpe las molestias que esto le ocasiona. Ref: SP-NOMCLASIFCLAVEPRESUPMOD");
		SET Var_Control = 'sqlException';
	END;

	IF(Par_NomClasifClavPresupID = Entero_Cero) THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'Especifique el Numero de la Clasificacion de Clave Presupuestal.';
		SET Var_Control := 'nomClasifClavPresupID';
		LEAVE ManejoErrores;
	END IF;

	SELECT NomClasifClavPresupID
		INTO Var_NomClasifClavPresupID
			FROM NOMCLASIFCLAVEPRESUP
			WHERE NomClasifClavPresupID = Par_NomClasifClavPresupID;

	SET Var_NomClasifClavPresupID		:= IFNULL(Var_NomClasifClavPresupID, Entero_Cero);

	IF(Var_NomClasifClavPresupID = Entero_Cero) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Numero de la Clasificacion de Clave Presupuestal no Existe.';
		SET Var_Control := 'nomClasifClavPresupID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Estatus = Cadena_Vacia) THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'Especifique el Estatus de Clasificacion de Clave Presupuestal.';
		SET Var_Control := 'estatus';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Estatus NOT IN(EstatusActivo, EstatusInactiva)) THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'Especifique el Estatus de Clasificacion de Clave Presupuestal Valido : A=Activo, I=Inactivo.';
		SET Var_Control := 'estatus';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Descripcion = Cadena_Vacia) THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'Especifique la Descripcion de la Clasificacion de Clave Presupuestal.';
		SET Var_Control := 'descripcion';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Prioridad = Entero_Cero) THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'Especifique la Prioridad de la Clasificacion de la Clave Presupuestal.';
		SET Var_Control := 'prioridad';
		LEAVE ManejoErrores;
	END IF;

	SELECT COUNT(NomClasifClavPresupID)
		INTO Var_CountClasifClavPresupID
			FROM NOMCLASIFCLAVEPRESUP
			WHERE Prioridad = Par_Prioridad
			AND NomClasifClavPresupID <> Par_NomClasifClavPresupID;

	IF(Var_CountClasifClavPresupID > Entero_Cero) THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'El Numero de Prioridad Indicada ya se Encuentra Asignada a una Clasificacion.';
		SET Var_Control := 'nomTipoClavePresupID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_NomClavePresupID = Cadena_Vacia) THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen := 'Selecione al Meno un Clave Presupuestal.';
		SET Var_Control := 'nomClavePresupID';
		LEAVE ManejoErrores;
	END IF;

	SET Var_ClavesPresupuestales	:= CONCAT(Par_NomClavePresupID,",");

	-- si por alguna raz??n se intenta asignar a otra clasificaci??n el sistema deber?? de mostrar una alerta indicando que ya la clase ya se tienen asignado a otra clasificaci??n. 
	SET Var_ContCadena = 1;
	SELECT POSITION("," IN Var_ClavesPresupuestales) INTO Var_CantCadena;

	WHILE Var_CantCadena > Var_ContCadena DO
		-- Obtenemos el Primer valor de la cadena ante del delimitador coma
		SELECT LEFT(Var_ClavesPresupuestales,Var_CantCadena - 1) INTO Var_NomClavePresupID;

		SELECT NomClavePresupID, Clave,Descripcion
			INTO Var_ClavePresupID, Var_Clave, Var_Descripcion
			FROM NOMCLAVEPRESUP
			WHERE NomClavePresupID = Var_NomClavePresupID;

			SET Var_Clave		:= IFNULL(Var_Clave, Cadena_Vacia);
			SET Var_Descripcion	:= IFNULL(Var_Descripcion, Cadena_Vacia);

			IF( IFNULL (Var_ClavePresupID , Entero_Cero)= Entero_Cero) THEN
				SET Par_NumErr := 5;
				SET Par_ErrMen := CONCAT("La Clave Presupuestal: ",Var_Clave,"-",Var_Descripcion, "No Existe.");
				SET Var_Control := 'nomClavePresupID';
				LEAVE ManejoErrores;
			END IF;

			SELECT COUNT(NomClasifClavPresupID)
				INTO Var_ConClasifClave
				FROM NOMCLASIFCLAVEPRESUP
				WHERE FIND_IN_SET(Var_ClavePresupID, NomClavePresupID)
				AND NomClasifClavPresupID <> Par_NomClasifClavPresupID;

			IF( IFNULL (Var_ConClasifClave , Entero_Cero) > Entero_Cero) THEN
				SET Par_NumErr := 6;
				SET Par_ErrMen := CONCAT("La Clave Presupuestal: ",Var_Clave,"-",Var_Descripcion, " Ya se Encuentra Asociada con Una Clasificacion.");
				SET Var_Control := 'nomClavePresupID';
				LEAVE ManejoErrores;
			END IF;

			SELECT SUBSTRING(Var_ClavesPresupuestales, Var_CantCadena + 1, LENGTH(Var_ClavesPresupuestales)) INTO Var_ClavesPresupuestales ;
			SELECT POSITION(',' IN Var_ClavesPresupuestales) INTO Var_CantCadena;
	END WHILE;

	UPDATE NOMCLASIFCLAVEPRESUP
		SET NomClasifClavPresupID	= Par_NomClasifClavPresupID,
			Descripcion				= Par_Descripcion,
			Estatus					= Par_Estatus,
			Prioridad				= Par_Prioridad,
			NomClavePresupID		= Par_NomClavePresupID,
			EmpresaID				= Aud_EmpresaID,
			Usuario					= Aud_Usuario,
			FechaActual				= Aud_FechaActual,
			DireccionIP				= Aud_DireccionIP,
			ProgramaID				= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
	WHERE NomClasifClavPresupID = Par_NomClasifClavPresupID;

		-- El registro se inserto correctamente
		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Clasificacion de Claves Presupuestales Modificada Correctamente';
		SET Var_Consecutivo	:= Par_NomClasifClavPresupID;
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
