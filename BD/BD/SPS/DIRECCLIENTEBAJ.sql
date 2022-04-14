-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCLIENTEBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECCLIENTEBAJ`;
DELIMITER $$


CREATE PROCEDURE `DIRECCLIENTEBAJ`(
	Par_ClienteID			INT(11),		-- CLIENTE ID
	Par_NumDirec			int(11),
	Par_Salida				CHAR(1), 		-- SALIDA
	INOUT Par_NumErr		INT(11),		-- NUM ERROR
	INOUT Par_ErrMen		VARCHAR(400),	-- ERR MEN

	Aud_EmpresaID			INT(11),		-- AUDITORIA
	Aud_Usuario				INT(11),		-- AUDITORIA
	Aud_FechaActual			DATETIME,		-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal			INT(11),		-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)		-- AUDITORIA
)

TerminaStore:BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia			char(1);
	DECLARE	Salida_SI				char(1);
	DECLARE	Salida_No				char(1);
	DECLARE	Fecha_Vacia				date;
	DECLARE	Entero_Cero				int;
	DECLARE TipoAct_Coord			int(11);
	DECLARE Alt_Direcciones			INT(11);				# Alta de Direcciones
	DECLARE Var_Control				VARCHAR(50);
    -- JQUINTAL
	DECLARE Cliente_Vigua_Serv_Pat 	INT(11); 		-- CLIENTE VIGUA SERVICIOS PATRIMONIALES
	DECLARE Var_CliEsp  			INT (11);		-- CLIENTE ESPECIFICO
	DECLARE Var_ParamCli			VARCHAR(50);	-- PARAMETRO PARA BUSCAR CLIENTE ESPECIFICO EN PARAMGENERALES
	DECLARE Var_Consecutivo   		INT(11);
	-- MMARTINEZ  MEXI
    DECLARE Var_RolPerf             VARCHAR(50);        -- PARAMETRO PARA VALIDAR ROL
    DECLARE Var_RolA                INT(11);
    DECLARE Var_RolUsuario          INT(11);


	-- VALORES A CONSTATES
	Set	Cadena_Vacia				:= '';					-- Cadena Vacia
	Set	Salida_No					:= 'N';					-- Salida Si
	Set	Salida_SI					:= 'S';					-- Salida No
	Set	Fecha_Vacia					:= '1900-01-01';		-- Fecha vacia
	Set	Entero_Cero					:= 0;					-- Entero Cero
	Set TipoAct_Coord				:= 4;					-- ActualizaciÃ³n de Coordenadas
	SET Alt_Direcciones				:= 2;					# Alta de Direcciones
    SET Cliente_Vigua_Serv_Pat	:=38;
	SET Var_ParamCli			:='CliProcEspecifico';
	-- MMARTINEZ  MEXI
	SET Var_RolPerf             :='RolActPerfil';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DIRECCLIENTEBAJ');
			SET Var_Control := 'sqlException';
		END;

		if(ifnull(Par_ClienteID, Entero_Cero)) = Entero_Cero then
			SET Par_NumErr :=001;
			SET Par_ErrMen := 'El Numero de Cliente esta Vacio';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		end if;

		if(ifnull(Par_NumDirec, Entero_Cero)) = Entero_Cero then
			SET Par_NumErr :=002;
			SET Par_ErrMen := 'El Numero de Direccion esta Vacio.';
			SET Var_Control := 'direccionID';
			LEAVE ManejoErrores;
		end if;

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
                            Par_ClienteID,			Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
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

		/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
		CALL BITACORAHISTPERSALT(
			Aud_NumTransaccion,			Alt_Direcciones,		Par_ClienteID,				Entero_Cero,			Par_NumDirec,
			Entero_Cero,				Salida_No,				Par_NumErr,					Par_ErrMen,				Aud_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		/*FIN de Respaldo de Bitacora Historica ########################################################################################### */
		DELETE FROM DIRECCLIENTE WHERE ClienteID = Par_ClienteID AND DireccionID = Par_NumDirec;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := "Direccion Eliminada Exitosamente.";
		SET Var_Control := 'direccionID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_NumDirec AS Consecutivo;
	END IF;
END TerminaStore$$
