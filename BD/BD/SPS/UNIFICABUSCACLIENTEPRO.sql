-- UNIFICABUSCACLIENTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `UNIFICABUSCACLIENTEPRO`;

DELIMITER $$

CREATE PROCEDURE UNIFICABUSCACLIENTEPRO(
# =====================================================================================
# ------- STORE DE BUSQUEDA PARA UNIFICAR EL CLIENTE ---------
# =====================================================================================
	Par_DBReplica 				VARCHAR(40),	-- DB a Donde se Replica la Informacion (Cartera)

	Par_Salida					CHAR(1), 		-- Indica mensaje de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Descripcion de Error

/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),		-- Parametro de Auditoria
	Aud_Usuario					INT(11),		-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

-- Declaracion de Variables
 	DECLARE Var_Control 			VARCHAR(30);	-- Var Control del Manejo de Errores
	DECLARE Var_ClienteID 			INT(11);
	DECLARE Var_RFC 				CHAR(13);
	DECLARE Var_CURP				CHAR(18);
	DECLARE Var_CP 					CHAR(5);
	DECLARE Var_ClienteIDUpd		INT(11);


	DECLARE Var_Sentencia			VARCHAR(5000);
	DECLARE Var_Bitacora			VARCHAR(5000);

	DECLARE Var_NombreTabla			VARCHAR(40);
	DECLARE Var_Consecutivo			INT(11);			-- Consecutivo
	DECLARE Var_TotalRegistros		INT(11);			-- Variable para el total de registros a iterar
	DECLARE Var_Existe 				CHAR(1);			-- Variable para Identificar si no Existe el cliente para buscarlo

-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Fecha_Vacia				DATE;
	DECLARE SalidaSI				CHAR(1);

	DECLARE SalidaNO 				CHAR(1);
	DECLARE Var_TipoDirOficial		INT(1);
	DECLARE Var_ValidaCliente 		INT(1);
	DECLARE Var_StrNo				CHAR(1);

-- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Decimal_Cero		:= 0.00;				-- DECIMAL Cero
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET SalidaSI			:= 'S';        			-- El Store SI genera una Salida
	SET SalidaNO			:= 'N';					-- Salida no

	SET Var_TipoDirOficial 	:= 1;					-- Tipo de Direccion Oficial
	SET Var_ClienteID 		:= 0;					-- Inicializa el ID en cero
	SET Var_ValidaCliente	:= 2;					-- Validacion Bacth si el cliente existe.
	SET Var_StrNo 			:= 'N';					-- String N=No

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr 	:= '999';
				SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-UNIFICACLIENTEPRO');
				SET Var_Control := 'sqlException';

			END;


		IF IFNULL(Par_DBReplica,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr 		:= 001;
			SET Par_ErrMen 		:= 'El parametro de la DB esta vacio';
			SET Var_Control		:= 'clienteID' ;
			SET Var_Consecutivo :=  Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		/*INICIO Busqueda para identificar si el cliente existe en la otra base*/
		SELECT	COUNT(ClienteID)
			INTO Var_TotalRegistros
			FROM TMPUNIFICABUSQUEDACLI;

		IF IFNULL(Var_TotalRegistros, Entero_Cero) = Entero_Cero THEN
			SET @RegistroClientesID := 0;

			INSERT INTO TMPUNIFICABUSQUEDACLI(
				NumRegistro, ClienteID, RFC, CURP, CP)
			SELECT (@RegistroClientesID := @RegistroClientesID +1),
					Cli.ClienteID,
					Cli.RFCOficial,
					Cli.CURP,
					Dir.CP
				FROM CLIENTES Cli INNER JOIN DIRECCLIENTE Dir
					ON Cli.ClienteID 		= Dir.ClienteID
					AND Dir.TipoDireccionID = Var_TipoDirOficial;
		END IF;

		SET Var_TotalRegistros := 0;

		SELECT	COUNT(ClienteID)
			INTO Var_TotalRegistros
			FROM TMPUNIFICABUSQUEDACLI;

		SET Var_Consecutivo := 1;

		IteraBusqueda: WHILE (Var_Consecutivo <= Var_TotalRegistros) DO
			SET Var_ClienteIDUpd 	:= Entero_Cero;
			SET Var_RFC 			:= Cadena_Vacia;
			SET Var_CURP			:= Cadena_Vacia;
			SET Var_CP 				:= Cadena_Vacia;

			SELECT ClienteID, 		RFC, 		CURP, 	CP,		Existe
				INTO Var_ClienteID,	Var_RFC, Var_CURP, 	Var_CP, 	Var_Existe
			FROM TMPUNIFICABUSQUEDACLI
			WHERE NumRegistro = Var_Consecutivo;


			SET Var_ClienteID 	:= IFNULL(Var_ClienteID, Entero_Cero);
			SET Var_RFC 		:= IFNULL(Var_RFC, Cadena_Vacia);
			SET Var_CURP 		:= IFNULL(Var_CURP, Cadena_Vacia);
			SET Var_CP 			:= IFNULL(Var_CP, Cadena_Vacia);
			SET Var_Existe 		:= IFNULL(Var_Existe, Var_StrNo);

			IF Var_Existe = Var_StrNo THEN

				--  Ejecucion de la busqueda de CALL Par_DBReplica.CRCBCLIENTESVAL en la otra base
				SET Var_Sentencia := CONCAT('CALL ',Par_DBReplica,'.CRCBCLIENTESVAL(',Var_ValidaCliente);
				SET Var_Sentencia := CONCAT(Var_Sentencia,",'",Var_RFC,"','",Var_CURP,"','",Var_CP,"','",SalidaNO,"',");
				SET Var_Sentencia := CONCAT(Var_Sentencia,'@Var_ClienteIDUpd',",",'@Par_NumErr',",", '@Par_ErrMen',",");
				SET Var_Sentencia := CONCAT(Var_Sentencia,Par_EmpresaID,",",Aud_Usuario,",'",Aud_FechaActual,"','");
				SET Var_Sentencia := CONCAT(Var_Sentencia,Aud_DireccionIP,"','",Aud_ProgramaID,"',",Aud_Sucursal,",");
				SET Var_Sentencia := CONCAT(Var_Sentencia,Aud_NumTransaccion);
				SET Var_Sentencia := CONCAT(Var_Sentencia,');');

				SET @Sentencia  		:= (Var_Sentencia);
				SET @Var_ClienteIDUpd 	:= Entero_Cero;
				SET @Par_NumErr 		:= Entero_Cero;
				SET @Par_ErrMen 		:= Cadena_Vacia;

				PREPARE UNIFICAVAL FROM @Sentencia;
				EXECUTE UNIFICAVAL;
				DEALLOCATE PREPARE UNIFICAVAL;

				SET Var_ClienteIDUpd 	:= @Var_ClienteIDUpd;
				SET Par_NumErr 			:= @Par_NumErr;
				SET Par_ErrMen 			:= @Par_ErrMen;

				IF Var_ClienteIDUpd != Entero_Cero AND Par_NumErr > Entero_Cero THEN
					UPDATE TMPUNIFICABUSQUEDACLI SET
							Existe 			= SalidaSI,
							ClienteIDUpd 	= Var_ClienteIDUpd,
							Sentencia 		= Var_Sentencia,
							NumErr 			= Par_NumErr,
							ErrMen 			= Par_ErrMen
						WHERE NumRegistro = Var_Consecutivo;
				ELSE
					UPDATE TMPUNIFICABUSQUEDACLI SET
							Existe 			= SalidaNO,
							Sentencia 		= Var_Sentencia,
							NumErr 			= Par_NumErr,
							ErrMen 			= Par_ErrMen
						WHERE NumRegistro = Var_Consecutivo;
				END IF;

			END IF; -- Fin De No Existe

			SET Var_Consecutivo := Var_Consecutivo +1;

		END WHILE IteraBusqueda;

		/*FIN Busqueda*/
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso Busqueda para Unificar Clientes terminos Exitosamente.';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT 	Par_NumErr			AS codigoRespuesta,
				Par_ErrMen			AS mensajeRespuesta;
	END IF;

END TerminaStore$$