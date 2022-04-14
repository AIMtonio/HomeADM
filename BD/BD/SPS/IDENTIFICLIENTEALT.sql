-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDENTIFICLIENTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `IDENTIFICLIENTEALT`;DELIMITER $$

CREATE PROCEDURE `IDENTIFICLIENTEALT`(
	-- Registro de Identificaciones del Cliente
	Par_ClienteID		INT(11),		-- Numero del Cliente
	Par_TipoIdentID		INT(11),		-- ID de el tipo de identificacion del cliente
	Par_Oficial			VARCHAR(1),		-- Indica si el tipo de identificacion es oficial
	Par_NumIndentif		VARCHAR(30),	-- Numero de identificacion del documento del cliente
	Par_FecExIden		DATE,			-- Fecha de Expedicion de la Identificacion

	Par_FecVenIden   	DATE,			-- Fecha de Vencimiento de la Identificacion
	Par_EmpresaID		INT(11),		-- Numero de Empresa

	Par_Salida         	CHAR(1), 		-- Indica si en el STORE existe mensaje de Salida
	INOUT Par_NumErr  	INT(11),		-- Numero de Error
	INOUT Par_ErrMen  	VARCHAR(400),	-- Descripcion del Error

	Aud_Usuario			INT(11),		-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal		INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de Auditoria
		)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Estatus		CHAR(1);
	DECLARE Var_FechaSis	DATE;
	DECLARE Var_Control     VARCHAR(20);

	-- Declaracion de Constantes
	DECLARE	noIdentificID	INT;
	DECLARE	Estatus_Activo	CHAR(1);
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;

	DECLARE	Descrip			VARCHAR(45);
	DECLARE Inactivo		CHAR(1);
	DECLARE	Salida_SI		CHAR(1);
	DECLARE	Salida_No		CHAR(1);
	DECLARE Alta_Identificaciones	INT(11);			-- Alta de Identificaciones del Cliente
	-- Asignacion de Constantes
	SET	noIdentificID		:= 0;				-- Numero de Identifiacion de Cliente
	SET	Estatus_Activo		:= 'A';				-- Esatus de Cliente Activo
	SET	Cadena_Vacia		:= '';				-- Cadena o String Vacio
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Entero en Cero

	SET	Descrip				:= '';				-- Descripcion de Identificacion
	SET Inactivo			:= 'I';				-- Esttus de Cliente Inactivo
	SET	Salida_SI			:= 'S';				-- Salida SI
	SET	Salida_No			:= 'N';				-- Salida No
	SET Alta_Identificaciones		:= 4;				-- Alta de Identificaciones del Cliente

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr   = 999;
			SET Par_ErrMen   = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-IDENTIFICLIENTEALT');
		END;

		SELECT Estatus INTO Var_Estatus
			FROM CLIENTES
				WHERE ClienteID = Par_ClienteID;

		SELECT FechaSistema INTO Var_FechaSis
			FROM PARAMETROSSIS;

		IF(Var_Estatus=Inactivo)THEN
			SET Par_NumErr 	:=   001;
			SET Par_ErrMen 	:= 'El Cliente se Encuentra Inactivo.';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(EXISTS(SELECT TipoIdentiID FROM IDENTIFICLIENTE
					WHERE ClienteID = Par_ClienteID AND TipoIdentiID = Par_TipoIdentID)) THEN
			SET Par_NumErr 	:=   002;
			SET Par_ErrMen 	:= 'El Cliente ya cuenta con el Tipo de Identificacion.';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumIndentif, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 	:=   003;
			SET Par_ErrMen 	:= 'El Numero de Identificacion esta Vaci­o.';
			SET Var_Control := 'numIdentificacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FecExIden, Fecha_Vacia) <> Fecha_Vacia) THEN
			IF(DATEDIFF(Var_FechaSis, Par_FecExIden) < Entero_Cero)THEN
				SET Par_NumErr 	:=   004;
				SET Par_ErrMen 	:= 'La Fecha de Expedicion es Mayor a la Fecha Actual.';
				SET Var_Control := 'fecExIden';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Se obtiene la Descripcion del Tipo de Identifricacion
		SET	Descrip := (SELECT Nombre
						FROM TIPOSIDENTI
						WHERE TipoIdentiID = Par_TipoIdentID);

		-- Se obtiene l Numero de Identificacion del Cliente
		SET noIdentificID := (SELECT IFNULL(MAX(IdentificID),Entero_Cero)+1
								FROM IDENTIFICLIENTE
								WHERE ClienteID = Par_ClienteID);

		-- Se obtiene la Fecha Actual
		SET Aud_FechaActual := NOW();

		-- Se inserta las Identificaciones de los Clentes en IDENTIFICLIENTE
		INSERT INTO IDENTIFICLIENTE (
			ClienteID,			IdentificID,		EmpresaID,			TipoIdentiID,			Descripcion,
			Oficial,			NumIdentific,		FecExIden,			FecVenIden,				Usuario,
			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,				NumTransaccion)
		VALUES (
			Par_ClienteID,		noIdentificID, 		Par_EmpresaID,		Par_TipoIdentID,	 	Descrip,
			Par_Oficial,		Par_NumIndentif,	Par_FecExIden,		Par_FecVenIden,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
		CALL BITACORAHISTPERSALT(
			Aud_NumTransaccion,			Alta_Identificaciones,		Par_ClienteID,				Entero_Cero,			Entero_Cero,
			noIdentificID,				Salida_No,					Par_NumErr,					Par_ErrMen,				Par_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		/*FIN de Respaldo de Bitacora Historica ########################################################################################### */

		SET Par_NumErr 	:= Entero_Cero;
		SET	Par_ErrMen 	:= CONCAT("Identificacion Agregada Exitosamente: ", CONVERT(noIdentificID, CHAR));
		SET Var_Control := 'identificID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				noIdentificID AS consecutivo;
	END IF;


END TerminaStore$$