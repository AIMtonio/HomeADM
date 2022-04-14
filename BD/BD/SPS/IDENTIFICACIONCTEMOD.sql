-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDENTIFICACIONCTEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `IDENTIFICACIONCTEMOD`;
DELIMITER $$


CREATE PROCEDURE `IDENTIFICACIONCTEMOD`(
/*SP Para dar de alta la Identificacion del Cliente Estandarizado*/
	Par_ClienteID		INT(11),		-- CLIENTE
	Par_IdentificID		INT(11),		-- IDENTIFICA
	Par_TipoIdentID		INT(11),		-- TIPO IDENTI
	Par_Oficial			VARCHAR(1),		-- OFICIAL
	Par_NumIndentif		VARCHAR(30),	-- NUM IDENTI

	Par_FecExIden		DATE,			-- FECHA EX IDEN
	Par_FecVenIden		DATE,			-- FEC VENCIM
	Par_Salida			CHAR(1),		-- SALIDA
	INOUT	Par_NumErr  INT,			-- NUM ERR
	INOUT	Par_ErrMen  VARCHAR(400),	-- MENSAJE

	INOUT	Par_IdenID	INT(11),		-- ID
	Par_EmpresaID		INT,			-- AUDITORIA
	Aud_Usuario			INT,			-- AUDITORIA
	Aud_FechaActual		DATETime,		-- AUDITORIA
	Aud_DireccionIP		VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID		VARCHAR(50),	-- AUDITORIA

	Aud_Sucursal		INT,			-- AUDITORIA
	Aud_NumTransaccion	BIGINT			-- AUDITORIA
		)

TerminaStore:BEGIN
-- DECLARACION DE VARIABLES
DECLARE Var_Estatus			CHAR(1);			-- ESTATUS
DECLARE	Estatus_Activo		CHAR(1);			-- ESTATUS ACTIVO
DECLARE	Cadena_Vacia		CHAR(1);			-- CADENA VACIA
DECLARE	Fecha_Vacia			DATE;				-- FECHA VACIA
DECLARE	Entero_Cero			INT;				-- ENTERO CERO
DECLARE	Descrip				VARCHAR(45);		-- DESCRIPCION
DECLARE Inactivo			CHAR(1);			-- INACTIVO
DECLARE Var_Control   		VARCHAR(25);		-- CONTROL
DECLARE Salida_SI			CHAR(1);			-- SALIDA SI
DECLARE Salida_NO			CHAR(1);			-- SALIDA NO
DECLARE Var_FechaSis		DATE;				-- FECHA SISTEMA
DECLARE Alta_Identificaciones	INT(11);		-- Alta de Identificaciones del Cliente


-- ASIGNACION  DE VARIABLES
SET	Estatus_Activo			:= 'A';			-- ESTATUS ACTIVO
SET	Cadena_Vacia			:= '';			-- CADENA VACIA
SET	Fecha_Vacia				:= '1900-01-01';-- FECHA VACIA
SET	Entero_Cero				:= 0;			-- ENTERO CERO
SET	Descrip					:='';			-- DESCRIPCION
SET Inactivo				:='I';			-- INACTIVO
SET Salida_SI				:= 'S';			-- Salida si
SET Salida_NO				:= 'N';			-- Salida NO
SET Alta_Identificaciones		:= 4;				-- Alta de Identificaciones del Cliente

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := '999';
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-IDENTIFICACIONCTEMOD');
	END;

	SELECT FechaSistema INTO Var_FechaSis
		FROM PARAMETROSSIS;

	SELECT Estatus into Var_Estatus
		FROM CLIENTES
			WHERE ClienteID=Par_ClienteID;


	IF(NOT EXISTS(SELECT ClienteID
				FROM CLIENTES
				WHERE ClienteID = Par_ClienteID)) THEN
		SET Par_NumErr := '04';
		SET Par_ErrMen := 'El Numero de safilocale.cliente no existe';
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_Estatus=Inactivo)THEN
		SET Par_NumErr := '01';
		SET Par_ErrMen := 'El safilocale.cliente se Encuentra Inactivo: ';
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;


	IF(IFnull(Par_IdentificID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := '03';
		SET Par_ErrMen := 'El ID de Identificacion esta Vacio';
		SET Var_Control := 'identificacionID';
		LEAVE ManejoErrores;
	END IF;


	IF(NOT EXISTS(SELECT IdentificID FROM IDENTIFICLIENTE WHERE ClienteID = Par_ClienteID
			AND IdentificID = Par_IdentificID))THEN
		SET Par_NumErr := '02';
		SET Par_ErrMen := 'El Id de Identificacion del Cliente No Existe';
		SET Var_Control := 'identifiID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoIdentID, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := '05';
		SET Par_ErrMen := 'El Tipo de Identificacion esta Vacio';
		SET Var_Control := 'tipoIdentificaID';
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentID))THEN
		SET Par_NumErr := '02';
		SET Par_ErrMen := 'El Tipo de Identificacion no Existe';
		SET Var_Control := 'tipoIdentificaID';
		LEAVE ManejoErrores;
	END IF;

	IF(EXISTS(SELECT IdentificID FROM IDENTIFICLIENTE
				WHERE TipoIdentiID = Par_TipoIdentID
				AND ClienteID = Par_ClienteID))THEN
		IF(NOT EXISTS(SELECT TipoIdentiID FROM IDENTIFICLIENTE
						WHERE TipoIdentiID = Par_TipoIdentID
						AND ClienteID = Par_ClienteID
						AND IdentificID= Par_IdentificID))THEN
			SET Par_NumErr := '02';
			SET Par_ErrMen := 'El safilocale.cliente ya cuenta con el tipo de identificacion';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFnull(Par_NumIndentif, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := '05';
		SET Par_ErrMen := 'El Numero de Identificacion esta Vacio';
		SET Var_Control := 'numIdentificacion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FecExIden, Fecha_Vacia) <> Fecha_Vacia) THEN
		IF(DATEDIFF(Var_FechaSis, Par_FecExIden) < Entero_Cero)THEN
			SET Par_NumErr := '05';
			SET Par_ErrMen := 'La Fecha de Expedición es Mayor a la Fecha Actual.';
			SET Var_Control := 'fecExIden';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET	Descrip := (SELECT Nombre
				FROM TIPOSIDENTI
				WHERE TipoIdentiID = Par_TipoIdentID);



	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	UPDATE IDENTIFICLIENTE SET
		TipoIdentiID	= Par_TipoIdentID,
		Oficial			= Par_Oficial,
		Descripcion		= Descrip,
		NumIdentific	= Par_NumIndentif,
		FecExIden		= Par_FecExIden,
		FecVenIden		= Par_FecVenIden,
		EmpresaID		= Par_EmpresaID,

		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE ClienteID = Par_ClienteID AND IdentificID = Par_IdentificID ;

		/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
		CALL BITACORAHISTPERSALT(
			Aud_NumTransaccion,			Alta_Identificaciones,		Par_ClienteID,				Entero_Cero,			Entero_Cero,
			Par_IdentificID,			Salida_No,					Par_NumErr,					Par_ErrMen,				Par_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		/*FIN de Respaldo de Bitacora Historica ########################################################################################### */

		SET Par_NumErr = '00';
		SET Par_ErrMen = 'Identificacion Modificada Exitosamente';

	END ManejoErrores;
	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_IdentificID AS Consecutivo;
	END IF;

	IF(Par_Salida = Salida_NO) THEN
		SET Par_NumErr := CONVERT(Par_NumErr, CHAR(10));
		SET Par_ErrMen := Par_ErrMen;
		SET Par_IdenID := Par_IdentificID;
	END IF;


END TerminaStore$$
