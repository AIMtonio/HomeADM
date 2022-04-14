-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDENTIFICACTEWSVBCALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `IDENTIFICACTEWSVBCALT`;DELIMITER $$

CREATE PROCEDURE `IDENTIFICACTEWSVBCALT`(
	/*SP para Alta de Identificacion del Clientes para Web Service de ZAFI*/
	Par_ClienteID			INT(11),			-- CLIENTE
    Par_IdentificaID		INT(11),			-- IDENTIFICA
    Par_TipoIdentiID		INT(11),			-- TIPO IDENTI
	Par_NumIdentifica		VARCHAR(30),		-- NUM IDEN
    Par_FechaExpedicion		DATE,				-- FEC EX IDEN

    Par_FechaVencimiento	DATE,				-- FECHA DE VENCIMIENTO
	Par_Usuario				VARCHAR(15),    	-- USUARIO
    Par_Clave				VARCHAR(100),   	-- CLAVE
    Par_Salida				CHAR(1),   			-- SALIDA
	INOUT Par_NumErr		INT(11),   			-- NUM ERR
	INOUT Par_ErrMen		VARCHAR(400),   	-- MENSAJE

	Par_EmpresaID			INT(11),			-- AUDITORIA
	Aud_Usuario				INT(11),			-- AUDITORIA
	Aud_FechaActual			DATETIME,			-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal			INT(11),			-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)			-- AUDITORIA
    )
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Estatus_Activo		CHAR(1);			-- ESTATUS ACTIVO
DECLARE Cadena_Vacia		CHAR(1);			-- CADENA VACIA
DECLARE Fecha_Vacia			DATE;				-- FECHA VACIA
DECLARE Entero_Cero			INT;				-- ENTERO CERO
DECLARE SiOficial			CHAR(1);			-- SI OFICIAL
DECLARE Salida_SI			CHAR(1);			-- SALIDA SI
DECLARE Salida_No			CHAR(1);			-- SALIDA NO
DECLARE Var_SI				CHAR(1);			-- VAR SI
DECLARE Var_NO				CHAR(1);			-- VAR NO
DECLARE Inactivo			CHAR(1);			-- INACTIVO
DECLARE TipoDirecID			INT(11);			-- TIPO DIR
DECLARE Var_PerfilWsVbc		INT(11);			-- PERFIL

-- Declaracion de Variables
DECLARE	Var_DirID   		CHAR(1);			-- DIR ID
DECLARE Var_DirIDF    		CHAR(1);			-- DIR OF
DECLARE Var_Estatus   		CHAR(1);			-- ESTATUS
DECLARE Var_Control   		VARCHAR(25);		-- CONTROL
DECLARE Var_NombreColonia	VARCHAR(150);		-- NOMBRE COLONIA

DECLARE Var_NumErr			INT(11);			-- Numero de Error
DECLARE Var_MenErr			VARCHAR(400);		-- Mensaje de Error
DECLARE Var_IdentificaID	INT(11);			-- IDENTIFICA
DECLARE Var_CodigoResp		VARCHAR(5);			-- CODIGO RESP
DECLARE Var_MensajeResp		VARCHAR(150);		-- MENSAJE RESP

DECLARE NumeroDireccion		INT(11);			-- NUMERO DIR
DECLARE DirecCompleta		VARCHAR(500);		-- DIR COMPLETA
DECLARE NombEstado			VARCHAR(50);		-- NOM ESTADO
DECLARE NombMunicipio		VARCHAR(50);		-- NOM MUNICIPIO
DECLARE SimbInterrogacion	CHAR(1);			-- SIM INTERROGA
DECLARE Elector				INT(11);			-- ELECTOR
DECLARE Pasaporte			INT(11);			-- PASAPORTE
DECLARE Cartilla			INT(11);			-- CARTILLA
DECLARE Licencia			INT(11);			-- LICENCIA
DECLARE Cedula				INT(11);			-- CEDULA
DECLARE MinElector			INT(11);			-- MIN ELECTOR
DECLARE MinPasaporte		INT(11);			-- MIN PASAPORTE
DECLARE MinCartilla			INT(11);			-- MIN CARTILLA
DECLARE MinLicencia			INT(11);			-- MIN LIC
DECLARE MinCedula			INT(11);			-- MIN CEDULA
DECLARE MaxElector			INT(11);			-- MAX ELECTOR
DECLARE MaxPasaporte		INT(11);			-- MAX PASAPORTE
DECLARE MaxCartilla			INT(11);			-- MAX CARTILLA
DECLARE MaxLicencia			INT(11);			-- MAX LIC
DECLARE MaxCedula			INT(11);			-- MAX CEDULA

-- Asignacion de Constantes
SET Estatus_Activo	:= 'A';       -- Estatus Activo
SET Cadena_Vacia    := '';        -- Cadena vacia
SET Fecha_Vacia     := '1900-01-01';  -- Fecha Vacia
SET Entero_Cero     := 0;       -- Entero Cero
SET Salida_SI     	:= 'S';       -- Salida SI
SET Salida_No     	:= 'N';       -- Salida No
SET Var_SI        	:= 'S';       -- Si
SET Var_NO        	:= 'N';       -- Si
SET Inactivo      	:= 'I';           -- Estatus inactivo del cliente
SET TipoDirecID		:= 1;		-- Tipo de Direccion Oficial
SET Elector			:= 1;		-- Tipo de Identificacion Elector
SET Pasaporte		:= 2;		-- Tipo de Identificacion Pasaporte
SET Cartilla		:= 3;		-- Tipo de Identificacion Cartilla
SET Licencia		:= 4;		-- Tipo de Identificacion Licencia
SET Cedula			:= 5;		-- Tipo de Identificacion Cedula
SET MinElector		:= 13;		-- Minimo de Caracteres para Elector
SET MinPasaporte	:= 9;		-- Minimo de Caracteres para Pasaporte
SET MinCartilla		:= 5;		-- Minimo de Caracteres para Cartilla
SET MinLicencia		:= 5;		-- Minimo de Caracteres para Licencia
SET MinCedula		:= 5;		-- Minimo de Caracteres para Cedula
SET MaxElector		:= 13;		-- Maximo de Caracteres para Elector
SET MaxPasaporte	:= 9;		-- Maximo de Caracteres para Pasaporte
SET MaxCartilla		:= 15;		-- Maximo de Caracteres para Cartilla
SET MaxLicencia		:= 15;		-- Maximo de Caracteres para Licencia
SET MaxCedula		:= 15;		-- Maximo de Caracteres para Cedula

SET NumeroDireccion   := 0;       -- Numero de Direccion para dar de alta una nueva
SET DirecCompleta   := '';        -- DireccionCompleta
SET NombEstado      := '';        -- NombEstado
SET NombMunicipio   := '';        -- NombMunicipio
SET SimbInterrogacion	:= '?';			-- Simbolo de interrogación


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := '999';
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-IDENTIFICACTEWSVBCALT');
	END;

	SET Par_NumIdentifica	:= REPLACE(Par_NumIdentifica, SimbInterrogacion, Cadena_Vacia);
    SET Par_NumIdentifica	:= RTRIM(LTRIM(IFNULL(Par_NumIdentifica, Cadena_Vacia)));
	SET Par_NumIdentifica	:= UPPER(Par_NumIdentifica);
	SET Par_Usuario			:= REPLACE(Par_Usuario, SimbInterrogacion, Cadena_Vacia);
    SET Par_Clave			:= REPLACE(Par_Clave, SimbInterrogacion, Cadena_Vacia);

    SET Var_PerfilWsVbc		:= (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
    SET Var_PerfilWsVbc		:= IFNULL(Var_PerfilWsVbc,Entero_Cero);

    IF(Var_PerfilWsVbc = Entero_Cero)THEN
    	SET Par_NumErr		:= '60';
		SET Par_ErrMen		:= 'No existe perfil definido para el usuario.';
		LEAVE ManejoErrores;
    END IF;

     IF IFNULL(Par_Usuario, Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr		:= '25';
		SET Par_ErrMen		:= 'El Usuario esta Vacio.';
		LEAVE ManejoErrores;
	END IF;
	IF IFNULL(Par_Clave, Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr		:= '26';
		SET Par_ErrMen		:= 'La Clave del Usuario esta Vacia.';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT Clave
					FROM USUARIOS
					WHERE Clave = Par_Usuario AND Contrasenia = Par_Clave
							AND Estatus = Estatus_Activo AND RolID = Var_PerfilWsVbc ) THEN
		SET Par_NumErr		:= '27';
		SET Par_ErrMen		:= 'El Usuario o la Clave Son Incorrectos.';
		LEAVE ManejoErrores;
	END IF;


	IF NOT EXISTS(SELECT ClienteID FROM CLIENTES
					   WHERE ClienteID = Par_ClienteID) THEN
		SET Par_NumErr      := '14';
		SET Par_ErrMen     := 'El Cliente Especificado No Existe.';
		LEAVE ManejoErrores;
	END IF;

	SELECT Estatus INTO Var_Estatus
		FROM CLIENTES
		WHERE ClienteID=Par_ClienteID;

	IF(Var_Estatus=Inactivo)THEN
        SET Par_NumErr		:= '01';
		SET Par_ErrMen		:= 'El Cliente se Encuentra Inactivo.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoIdentiID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr		:= '01';
		SET Par_ErrMen		:= 'El Tipo de Identificacion esta Vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS(SELECT TipoIdentiID
					FROM TIPOSIDENTI
					WHERE TipoIdentiID = Par_TipoIdentiID ) THEN
		SET Par_NumErr      := '14';
		SET Par_ErrMen     := 'El Tipo de Identificacion No Existe.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NumIdentifica,Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr		:= '02';
		SET Par_ErrMen		:= 'El Numero de Identificacion esta Vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF Par_TipoIdentiID = Elector THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) < MinElector)THEN
			SET Par_NumErr		:= '06';
			SET Par_ErrMen		:= 'Se requieren Minimo 13 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;
    IF Par_TipoIdentiID = Elector THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) > MaxElector)THEN
			SET Par_NumErr		:= '06';
			SET Par_ErrMen		:= 'Se requieren Maximo 13 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

    IF Par_TipoIdentiID = Pasaporte THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) < MinPasaporte)THEN
			SET Par_NumErr		:= '06';
			SET Par_ErrMen		:= 'Se requieren Minimo 9 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;
    IF Par_TipoIdentiID = Pasaporte THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) > MaxPasaporte)THEN
			SET Par_NumErr		:= '06';
			SET Par_ErrMen		:= 'Se requieren Maximo 9 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;
    IF Par_TipoIdentiID = Cartilla THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) < MinCartilla)THEN
			SET Par_NumErr		:= '07';
			SET Par_ErrMen		:= 'Se requieren Minimo 5 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;
    IF Par_TipoIdentiID = Cartilla THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) > MaxCartilla)THEN
			SET Par_NumErr		:= '07';
			SET Par_ErrMen		:= 'Se requieren Maximo 15 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;
    IF Par_TipoIdentiID = Licencia THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) < MinLicencia)THEN
			SET Par_NumErr		:= '08';
			SET Par_ErrMen		:= 'Se requieren Minimo 5 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;
	IF Par_TipoIdentiID = Licencia THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) > MaxLicencia)THEN
			SET Par_NumErr		:= '08';
			SET Par_ErrMen		:= 'Se requieren Maximo 15 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;
    IF Par_TipoIdentiID = Cedula THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) < MinCedula)THEN
			SET Par_NumErr		:= '09';
			SET Par_ErrMen		:= 'Se requieren Minimo 5 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;
    IF Par_TipoIdentiID = Cedula THEN
		IF(CHARACTER_LENGTH(Par_NumIdentifica) > MaxCedula)THEN
			SET Par_NumErr		:= '09';
			SET Par_ErrMen		:= 'Se requieren Maximo 15 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Aud_FechaActual = NOW();

	CALL IDENTIFICACIONCTEALT(
    	Par_ClienteID,			Par_TipoIdentiID,	Var_SI,			Par_NumIdentifica,	Par_FechaExpedicion,
		Par_FechaVencimiento,	Par_EmpresaID,		Salida_No,		Var_NumErr,			Var_MenErr,
        Var_IdentificaID, 		Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,
        Aud_Sucursal,			Aud_NumTransaccion);

	IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
		SET Var_IdentificaID	:= 00;
		SET Par_NumErr		:= CAST(Var_NumErr AS CHAR);
		SET Par_ErrMen		:= Var_MenErr;
		LEAVE ManejoErrores;
	ELSE
		SET Par_NumErr		:= '00';
		SET Par_ErrMen		:= 'Identificacion Agregada Exitosamente.';
	END IF;

END ManejoErrores;

IF Par_Salida = Salida_SI THEN
	SELECT
	 Par_NumErr		AS codigoRespuesta,
	 Par_ErrMen     AS mensajeRespuesta,
	 Var_IdentificaID  AS identificaID;

END IF;

END TerminaStore$$