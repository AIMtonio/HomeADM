-- CRCBCLIENTESVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCLIENTESVAL`;

DELIMITER $$
CREATE PROCEDURE `CRCBCLIENTESVAL`(
	-- --------------------------------------------------------------------
	-- SP QUE REALIZA LA VALIDACION DE DATOS DEL CLIENTE PARA ENCONTRAR COINCIDENCIAS
	-- --------------------------------------------------------------------
	Par_TipoConsulta	INT(1),         -- 1.- Validacion en Cartera, 2.- Validacion Batch
	Par_RFC				CHAR(13),		-- RFC del Cliente
	Par_CURP			CHAR(18),		-- CURP del Cliente
	Par_CP				CHAR(5),        -- Codigo Postal del Cliente

	Par_Salida			CHAR,           -- Indica si se regresa los datos
	INOUT Par_ClienteId INT(11),        -- ClienteID con coincidencia por CURP,RCF,CP
	INOUT Par_NumErr	INT(11),        -- Parametro Par_NumErr
	INOUT Par_ErrMen	VARCHAR(400),   -- Parametro Par_ErrMen

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),        -- Parametro de Auditoria
	Aud_Usuario			INT(11),        -- Auditoria
	Aud_FechaActual		DATETIME,       -- Auditoria
	Aud_DireccionIP		VARCHAR(15), 	-- Auditoria
	Aud_ProgramaID		VARCHAR(50), 	-- Auditoria
	Aud_Sucursal		INT(11), 		-- Auditoria
	Aud_NumTransaccion	BIGINT(20) 		-- Auditoria
	)
TerminaStore: BEGIN
	--  Declracion de constantes
	DECLARE Entero_Cero				INT(1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE Con_Cartera				INT(1);
	DECLARE Con_CarteraPM			INT(1);
	DECLARE Con_Batch 				INT(1);

	DECLARE Var_TipoDirOficial		INT(11);

	--  Declaracion de variables
	DECLARE Var_ClienteID		INT(11);		-- Variable para obtener el Cliente
	DECLARE Var_Existe			INT(2);			-- Variable para indicar si el cliente existe
	DECLARE Var_Consecutivo 	INT(11);		-- Variable para regresar el consecutivo
	DECLARE Var_Control 		VARCHAR(30);	-- Var Control del Manejo de Errores

	--  Asignacion de valores a contantes
	SET Entero_Cero         := 0;					-- Entero Cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET SalidaSI            := 'S';					-- Salida Si
	SET Con_Cartera         := 1;					-- Consulta para el WS de Alta Captacion
	SET Con_Batch			:= 2;					-- Consulta para proceso Batch
	SET Con_CarteraPM       := 3;
	SET Var_TipoDirOficial 	:= 1;					-- Tipo de Direccion Oficial

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBCLIENTESVAL');
				SET Var_Control := 'sqlException';

			END;

		IF( Par_TipoConsulta = Con_Cartera) THEN
			SELECT IFNULL(ClienteID,Entero_Cero)
			INTO  Var_ClienteID
			FROM   CLIENTES
				WHERE CURP = Par_CURP
				  AND RFC = Par_RFC;

			SELECT  COUNT(ClienteID)
			INTO    Var_Existe
				FROM DIRECCLIENTE
				WHERE   ClienteID = Var_ClienteID
					AND CP = Par_CP
					AND OFICIAL = 'S';

			IF(Var_Existe > Entero_Cero) THEN
				SET Par_NumErr		:=  1;
				SET Par_ErrMen		:=  'El cliente existe en Cartera.';
				SET Var_Consecutivo :=  Var_ClienteID;
				SET Par_ClienteID	:=  Var_ClienteID;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr		:=  0;
			SET Par_ErrMen		:= 'El cliente no existe en Cartera.';
			SET Var_Consecutivo :=  Entero_Cero;
			SET Par_ClienteID	:=  Entero_Cero;
		END IF;

		IF(Par_TipoConsulta = Con_Batch) THEN
			/* BUSQUEDA por CURP y CP*/

			IF IFNULL(Par_CURP,Cadena_Vacia) != Cadena_Vacia THEN
				SELECT	Cli.ClienteID
							INTO Var_ClienteID
						FROM CLIENTES Cli INNER JOIN DIRECCLIENTE Dir
							ON  Dir.ClienteID 		= Cli.ClienteID
							AND Dir.TipoDireccionID = Var_TipoDirOficial
						WHERE Cli.CURP 			= Par_CURP
						  AND Dir.CP 			= Par_CP
						  LIMIT 1;
			END IF;

			IF (IFNULL(Var_ClienteID,Entero_Cero) = Entero_Cero) THEN
				/* Buscar Cliente por RFC SIN HOMOCLAVE Y CP.*/
				IF IFNULL(Par_RFC,Cadena_Vacia) != Cadena_Vacia THEN
					SELECT	COUNT(DISTINCT Cli.ClienteID), MAX(Cli.ClienteID)
							INTO Var_Existe,			Var_ClienteID
						FROM CLIENTES Cli INNER JOIN DIRECCLIENTE Dir
							ON  Dir.ClienteID 		= Cli.ClienteID
							AND Dir.TipoDireccionID = Var_TipoDirOficial
						WHERE TRIM(SUBSTRING(Cli.RFCOFicial,1,10))	= TRIM(SUBSTRING(Par_RFC,1,10))
						  AND Dir.CP 			= Par_CP;
				END IF;
				/* Si exite el RFC sin Homoclave registrado en varios clientes se consulta con el RFC completo */
				IF Var_Existe > 1 THEN
					SET Var_ClienteID := Entero_Cero;

					SELECT	COUNT(DISTINCT Cli.ClienteID), MAX(Cli.ClienteID)
						INTO Var_Existe,			Var_ClienteID
					FROM CLIENTES Cli INNER JOIN DIRECCLIENTE Dir
						ON  Dir.ClienteID 		= Cli.ClienteID
						AND Dir.TipoDireccionID = Var_TipoDirOficial
					WHERE Cli.RFCOFicial	= Par_RFC
					  AND Dir.CP 			= Par_CP;

				END IF;
			END IF;

			SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);

			IF Var_ClienteID != Entero_Cero THEN
				SET Par_ClienteID 	:= Var_ClienteID;
				SET Par_NumErr 		:= 001;
				SET Par_ErrMen 		:= 'EL Cliente ya existe';
				SET Var_Control		:= 'clienteID' ;
				SET Var_Consecutivo :=  Var_ClienteID;
				LEAVE ManejoErrores;

			END IF;

			SET Par_ClienteID 	:= Entero_Cero;
			SET Par_NumErr		:=  0;
			SET Par_ErrMen		:= 'El Cliente no existe.';
			SET Var_Control		:= 'clienteID' ;
			SET Var_Consecutivo :=  Entero_Cero;

		END IF;

		IF(Par_TipoConsulta = Con_CarteraPM) THEN
			SELECT IFNULL(ClienteID,Entero_Cero)
			INTO  Var_ClienteID
			FROM   CLIENTES
				WHERE RFC = Par_RFC;

			SELECT  COUNT(ClienteID)
			INTO    Var_Existe
				FROM DIRECCLIENTE
				WHERE   ClienteID = Var_ClienteID
					AND CP = Par_CP
					AND OFICIAL = 'S';

			IF(Var_Existe > Entero_Cero) THEN
				SET Par_NumErr		:=  1;
				SET Par_ErrMen		:=  'El cliente existe en Cartera.';
				SET Var_Consecutivo :=  Var_ClienteID;
				SET Par_ClienteID	:=  Var_ClienteID;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr		:=  0;
			SET Par_ErrMen		:= 'El cliente no existe en Cartera.';
			SET Var_Consecutivo :=  Entero_Cero;
			SET Par_ClienteID	:=  Entero_Cero;
		END IF;

END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT  Par_NumErr AS codigoRespuesta,
				Par_ErrMen AS mensajeRespuesta,
				Var_Consecutivo AS clienteID;
	END IF;

END TerminaStore$$