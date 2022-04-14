-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDENTIFICACIONCTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `IDENTIFICACIONCTEALT`;DELIMITER $$

CREATE PROCEDURE `IDENTIFICACIONCTEALT`(
/* SP de Alta de Identificacion del Cliente Estandarizado */
	Par_ClienteID		INT(11),			-- CLIENTE
	Par_TipoIdentID		INT(11),			-- TIPO IDENTI
	Par_Oficial			VARCHAR(1),			-- OFICIAL
	Par_NumIndentif		VARCHAR(30),		-- NUM IDEN
	Par_FecExIden		DATE,				-- FEC EX IDEN

	Par_FecVenIden   	DATE,				-- FEC VENCIM
	Par_EmpresaID		INT,				-- AUDITORIA
	Par_Salida         	CHAR(1), 			-- SALIDA

	INOUT	Par_NumErr  INT,				-- NUM ERR
	INOUT	Par_ErrMen  VARCHAR(400),		-- MENSJAE
	INOUT	Par_IdenID	INT(11),			-- ID

	Aud_Usuario			INT,				-- AUDITORIA
	Aud_FechaActual		DATETime,			-- AUDITORIA
	Aud_DireccionIP		VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID		VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal		INT,				-- AUDITORIA
	Aud_NumTransaccion	BIGINT				-- AUDITORIA
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Estatus				CHAR(1);			-- ESTATUS
	DECLARE Var_FechaSis			DATE;				-- FECAH SISTEMA
	DECLARE Var_Control				VARCHAR(50);		-- Variable con el ID del control de Pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);		-- Variable campo de pantalla

	-- Declaracion de Constantes
	DECLARE	noIdentificID			INT;				-- NUM IDENTI
	DECLARE	Estatus_Activo			CHAR(1);			-- ESTATUS ACTIVO
	DECLARE	Cadena_Vacia			CHAR(1);			-- CADENA VACIA
	DECLARE	Fecha_Vacia				DATE;				-- FECHA VACIA
	DECLARE	Entero_Cero				INT;				-- ENTERO CERO
	DECLARE	Descrip					VARCHAR(45);		-- DESCRIP
	DECLARE Inactivo				CHAR(1);			-- INACTIVO
	DECLARE	Salida_SI				CHAR(1);			-- SALIDA SI
	DECLARE	Salida_No				CHAR(1);			-- SALIDA NO
	DECLARE Alta_Identificaciones	INT(11);			-- Alta de Identificaciones del Cliente


	-- Asignacion de Constantes
	SET	noIdentificID				:= 0;				-- Numero de Identifiacion de Cliente
	SET	Estatus_Activo				:= 'A';				-- Esatus de Cliente Activo
	SET	Cadena_Vacia				:= '';				-- Cadena o String Vacío
	SET	Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacía
	SET	Entero_Cero					:= 0;				-- Entero en Cero
	SET	Descrip						:='';				-- Descripcion de Identificacion
	SET Inactivo					:='I';				-- Esttus de Cliente Inactivo
	SET	Salida_SI					:= 'S';				-- Salida SI
	SET	Salida_No					:= 'N';				-- Salida No
	SET Alta_Identificaciones		:= 4;				-- Alta de Identificaciones del Cliente


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := '999';
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-IDENTIFICACIONCTEALT');
			SET Var_Control := 'sqlException';
		END;
		SELECT Estatus INTO Var_Estatus
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

		SELECT FechaSistema INTO Var_FechaSis
			FROM PARAMETROSSIS;

		SET Par_ClienteID := IFNULL(Par_ClienteID,-1);

		IF(NOT EXISTS(SELECT ClienteID
						FROM CLIENTES
						WHERE ClienteID = Par_ClienteID)) THEN
			SET	Par_NumErr := 1;
			SET	Par_ErrMen := 'El Numero de safilocale.cliente No Existe.' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Estatus = Inactivo)THEN
			SET	Par_NumErr := 1;
			SET	Par_ErrMen := 'El safilocale.cliente se Encuentra Inactivo.' ;
			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_TipoIdentID, Cadena_Vacia) = Cadena_Vacia) THEN
			SET	Par_NumErr := 4;
			SET	Par_ErrMen := 'El Tipo de Identificación esta Vacío.' ;
			LEAVE ManejoErrores;
		END IF;

		IF(NOT EXISTS(SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID =  Par_TipoIdentID)) THEN
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'El Tipo de Identificación No Existe' ;
			LEAVE ManejoErrores;
		END IF;

		IF(EXISTS(SELECT TipoIdentiID FROM IDENTIFICLIENTE WHERE ClienteID = Par_ClienteID AND TipoIdentiID = Par_TipoIdentID)) THEN
			SET	Par_NumErr := 2;
			SET	Par_ErrMen := 'El safilocale.cliente ya cuenta con el Tipo de Identificacion' ;
			LEAVE ManejoErrores;
		END IF;

		IF(ifnull(Par_NumIndentif, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'El Número de Identificación esta Vacío.' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FecExIden, Fecha_Vacia) <> Fecha_Vacia) THEN
			IF(DATEDIFF(Var_FechaSis, Par_FecExIden) < Entero_Cero)THEN
				SET	Par_NumErr := 4;
				SET	Par_ErrMen := 'La Fecha de Expedición es Mayor a la Fecha Actual.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET	Descrip := (SELECT Nombre FROM TIPOSIDENTI WHERE TipoIdentiID = Par_TipoIdentID);

		SET noIdentificID := (SELECT IFNULL(MAX(IdentificID),Entero_Cero)+1  FROM IDENTIFICLIENTE WHERE ClienteID=Par_ClienteID );

		SET Aud_FechaActual := CURRENT_TIMESTAMP();


		INSERT INTO IDENTIFICLIENTE(
			ClienteID,			IdentificID,		EmpresaID,			TipoIdentiID,		Descripcion,
			Oficial,			NumIdentific,		FecExIden,			FecVenIden,			Usuario,
			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion
		) VALUES (
			Par_ClienteID,		noIdentificID, 		Par_EmpresaID,		Par_TipoIdentID,	 Descrip,
			Par_Oficial,		Par_NumIndentif,	Par_FecExIden,		Par_FecVenIden,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

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

		SET	Par_NumErr	:= '00';
		SET	Par_ErrMen	:= CONCAT("Identificacion Agregada Exitosamente: ", CONVERT(noIdentificID, CHAR));
		SET Par_IdenID	:= noIdentificID;

	END ManejoErrores;
	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_IdentificID AS Consecutivo;
	END IF;
END TerminaStore$$