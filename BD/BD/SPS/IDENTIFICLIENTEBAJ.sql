-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDENTIFICLIENTEBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `IDENTIFICLIENTEBAJ`;
DELIMITER $$


CREATE PROCEDURE `IDENTIFICLIENTEBAJ`(
/*SP Para dar de alta la Identificacion del Cliente Estandarizado*/
	Par_ClienteID		INT(11),		-- CLIENTE
	Par_IdentificID		INT(11),		-- IDENTIFICA
	Par_Salida			CHAR(1),		-- SALIDA
	INOUT	Par_NumErr  INT,			-- NUM ERR
	INOUT	Par_ErrMen  VARCHAR(400),	-- MENSAJE

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
DECLARE Var_Estatus			CHAR(1);		-- ESTATUS
DECLARE	Estatus_Activo		CHAR(1);		-- ESTATUS ACTIVO
DECLARE	Cadena_Vacia		CHAR(1);		-- CADENA VACIA
DECLARE	Fecha_Vacia			DATE;			-- FECHA VACIA
DECLARE	Entero_Cero			INT;			-- ENTERO CERO
DECLARE	Descrip				VARCHAR(45);	-- DESCRIPCION
DECLARE Inactivo			CHAR(1);		-- INACTIVO
DECLARE Var_Control   		VARCHAR(25);	-- CONTROL
DECLARE Salida_SI			CHAR(1);		-- SALIDA SI
DECLARE Salida_NO			CHAR(1);		-- SALIDA NO
DECLARE Var_FechaSis		DATE;			-- FECHA SISTEMA
DECLARE Alta_Identificaciones	INT(11);			-- Alta de Identificaciones del Cliente
-- JQUINTAL
DECLARE Cliente_Vigua_Serv_Pat 	INT(11); 		-- CLIENTE VIGUA SERVICIOS PATRIMONIALES
DECLARE Var_CliEsp  			INT (11);		-- CLIENTE ESPECIFICO
DECLARE Var_ParamCli			VARCHAR(50);	-- PARAMETRO PARA BUSCAR CLIENTE ESPECIFICO EN PARAMGENERALES
DECLARE Var_Consecutivo   		INT(11);
-- MMARTINEZ  MEXI
DECLARE Var_RolPerf             VARCHAR(50);        -- PARAMETRO PARA VALIDAR ROL
DECLARE Var_RolA                INT(11);
DECLARE Var_RolUsuario          INT(11);



-- ASIGNACION  DE VARIABLES
SET	Estatus_Activo			:= 'A';			-- ESTATUS ACTIVO
SET	Cadena_Vacia			:= '';			-- CADENA VACIA
SET	Fecha_Vacia				:= '1900-01-01';-- FECHA VACIA
SET	Entero_Cero				:= 0;			-- ENTERO CERO
SET	Descrip					:='';			-- DESCRIPCION
SET Inactivo				:='I';			-- INACTIVO
Set Salida_SI				:= 'S';			-- Salida si
Set Salida_NO				:= 'N';			-- Salida NO
SET Alta_Identificaciones	:= 4;				-- Alta de Identificaciones del Cliente
SET Cliente_Vigua_Serv_Pat	:=38;
SET Var_ParamCli			:='CliProcEspecifico';
-- MMARTINEZ  MEXI
SET Var_RolPerf             :='RolActPerfil';


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := '999';
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-IDENTIFICLIENTEBAJ');
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


    -- JQuintal NARRATIVA 0010 MEXI
        SELECT ValorParametro
			INTO Var_CliEsp
			FROM PARAMGENERALES
				WHERE LlaveParametro = Var_ParamCli;

        SELECT ValorParametro
			INTO Var_RolA
			FROM PARAMGENERALES
				WHERE LlaveParametro = Var_RolPerf;

        SELECT RolID INTO Var_RolUsuario FROM USUARIOS WHERE  UsuarioID = Aud_Usuario;


			SET Var_CliEsp:=IFNULL(Var_CliEsp,Entero_Cero);

			SET Var_RolUsuario:=IFNULL(Var_RolUsuario,Entero_Cero);

			IF (Var_CliEsp=Cliente_Vigua_Serv_Pat) THEN

                IF(Var_RolA != Var_RolUsuario)THEN
                    CALL VALIDADATOSCTEVAL(
                            Par_ClienteID,			Salida_No,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
                            Aud_Usuario ,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                            Aud_NumTransaccion);

                            IF( Par_NumErr<>Entero_Cero) THEN
                                SET Par_NumErr  := Par_NumErr;
                                SET Par_ErrMen  := Par_ErrMen;
                                SET Var_Control := 'clienteID ';
                                SET Var_Consecutivo := Entero_Cero;
                                LEAVE ManejoErrores;
                            END IF;
                END IF;
			END IF;


	SET Aud_FechaActual := CURRENT_TIMESTAMP();

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
	DELETE
	FROM IDENTIFICLIENTE
		WHERE ClienteID = Par_ClienteID
		AND IdentificID = Par_IdentificID;


		SET Par_NumErr = '00';
		SET Par_ErrMen = concat("Identificacion Eliminada Exitosamente: ",Par_IdentificID );
	END ManejoErrores;
	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_IdentificID AS Consecutivo;
	END IF;
END TerminaStore$$
