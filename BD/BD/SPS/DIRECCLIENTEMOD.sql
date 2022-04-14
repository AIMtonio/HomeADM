-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCLIENTEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS DIRECCLIENTEMOD;

DELIMITER $$
CREATE PROCEDURE `DIRECCLIENTEMOD`(
	Par_ClienteID   	INT(11),
	Par_DireccionID   	INT(11),
	Par_TipoDirecID   	INT(11),
	Par_EstadoID    	INT(11),
	Par_MunicipioID   	INT(11),

	Par_LocalidadID   	INT(11),
	Par_ColoniaID   	INT(11),
	Par_NombreColonia 	VARCHAR(200),
	Par_Calle    	 	VARCHAR(50),
	Par_NumeroCasa    	CHAR(10),

	Par_NumInterior   	CHAR(10),
	Par_Piso      		CHAR(50),
	Par_PrimECalle    	VARCHAR(50),
	Par_SegECalle     	VARCHAR(50),
	Par_CP        		CHAR(5),

	Par_Descripcion   	VARCHAR(500),
	Par_Latitud     	VARCHAR(45),
	Par_Longitud    	VARCHAR(45),
	Par_Oficial     	CHAR(1),
	Par_Fiscal      	CHAR(1),

	Par_EmpresaID   	INT(11),
	Par_Lote      		CHAR(50),
	Par_Manzana     	CHAR(50),
	Par_DirecCompleta	VARCHAR(500),
	Par_PaisID			INT(11),		-- PAIS
	Par_AnioRes			INT(11),		-- AÑOS DE RESIDENCIA

	Par_Salida        	CHAR(1),
	INOUT Par_NumErr  	INT(11),

	INOUT Par_ErrMen  	VARCHAR(400),
		/* Parametros de Auditoria */
	Aud_Usuario     	INT(11),
	Aud_FechaActual   	DATETIME,
	Aud_DireccionIP   	VARCHAR(15),
	Aud_ProgramaID    	VARCHAR(50),

	Aud_Sucursal    	INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_DirID   		INT(11);
	DECLARE Var_DirIDF    		INT(11);
	DECLARE Var_Estatus   		CHAR(1);
	DECLARE Var_Control   		VARCHAR(25);
	DECLARE Var_ValorParametro	CHAR(1);
	DECLARE Var_PaisResidencia	INT(11);		-- Valor del Pais de Residencia del Cliente
	DECLARE Cli_Nacional		CHAR(1);		-- Constante Nacionalidad Nacional

	-- Declaracion de Constantes
	DECLARE Estatus_Activo  CHAR(1);
	DECLARE Cadena_Vacia  	CHAR(1);
	DECLARE Fecha_Vacia   	DATE;
	DECLARE Entero_Cero   	INT;
	DECLARE DirecCompleta 	VARCHAR(500);
	DECLARE NombEstado    	VARCHAR(50);
	DECLARE NombMunicipio 	VARCHAR(50);
	DECLARE Doficial    	INT;
	DECLARE DirID       	INT(11);
	DECLARE Inactivo    	CHAR(1);
	DECLARE Str_SI      	CHAR(1);
	DECLARE Salida_SI   	CHAR(1);
	DECLARE Str_NO      	CHAR(1);
	DECLARE Alt_Direcciones			INT(11);				-- Alta de Direcciones
	DECLARE PermiteResidExt		VARCHAR(100);	-- Llave Parametro: Indica si la institucion podra registrar personas residentes en el extranjero
	DECLARE Con_Longitud	INT(11);
	-- JQUINTAL NARRATIVA 0010 MEXI
	DECLARE Cliente_Vigua_Serv_Pat 	INT(11); 		-- CLIENTE VIGUA SERVICIOS PATRIMONIALES
	DECLARE Var_CliEsp  			INT (11);		-- CLIENTE ESPECIFICO
	DECLARE Var_ParamCli			VARCHAR(50);	-- PARAMETRO PARA BUSCAR CLIENTE ESPECIFICO EN PARAMGENERALES
	DECLARE Var_Consecutivo   		INT(11);
	-- MMARTINEZ  MEXI
	DECLARE Var_RolPerf             VARCHAR(50);        -- PARAMETRO PARA VALIDAR ROL
	DECLARE Var_RolA                INT(11);
	DECLARE Var_RolUsuario          INT(11);
	DECLARE Var_Nacion			CHAR(1);		-- Variable Nacionalidad del Cliente

	-- Asignacion de Constantes
	SET Estatus_Activo    	:= 'A';
	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Entero_Cero     	:= 0;
	SET DirecCompleta   	:= '';
	SET NombEstado      	:= '';
	SET NombMunicipio   	:= '';
	SET Doficial      		:= 0;
	SET Inactivo      		:='I';
	SET Salida_SI     		:= 'S';       -- Salida SI
	SET Str_NO        		:= 'N';
	SET Str_SI        		:= 'S';       -- Si
	SET Alt_Direcciones		:= 2;					# Alta de Direcciones
	SET PermiteResidExt		:= 'PermiteResidentesExt';	-- Llave Parametro: Indica si la institucion podra registrar personas residentes en el extranjero
	SET Con_Longitud		:= 5;
	-- JQUINTAL NARRATIVA 0010 MEXI
	SET Cliente_Vigua_Serv_Pat	:=38;
	SET Var_ParamCli			:='CliProcEspecifico';
	-- MMARTINEZ  MEXI
	SET Var_RolPerf             :='RolActPerfil';
	SET Cli_Nacional		:= 'N';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DIRECCLIENTEMOD');
		END;

		-- Valida que exista el tipo de dirección
		IF(NOT EXISTS(SELECT TipoDireccionID
						FROM TIPOSDIRECCION
					   WHERE TipoDireccionID = Par_TipoDirecID)) THEN
			SET Par_NumErr := 15;
			SET Par_ErrMen := CONCAT('El Tipo de Dirección No Existe: ', CONVERT(Par_TipoDirecID,CHAR(20)));
			SET Var_Control := 'tipoDireccionID';
			LEAVE ManejoErrores;
		END IF;


		-- Valida que exista el estado en el catálogo de estados
		IF(NOT EXISTS(SELECT EstadoID
						FROM ESTADOSREPUB
					   WHERE EstadoID = Par_EstadoID)) THEN
			SET Par_NumErr := 16;
			SET Par_ErrMen := CONCAT('El Estado Definido No Existe: ', CONVERT(Par_EstadoID,CHAR(20)));
			SET Var_Control := 'estadoID';
			LEAVE ManejoErrores;
		END IF;


		-- Valida que exista el municipio en el catálogo de municipios
		IF(NOT EXISTS(SELECT MunicipioID
						FROM MUNICIPIOSREPUB
					   WHERE MunicipioID = Par_MunicipioID)) THEN
			SET Par_NumErr := 17;
			SET Par_ErrMen := CONCAT('El Municipio Definido No Existe: ', CONVERT(Par_MunicipioID,CHAR(20)));
			SET Var_Control := 'municipioID';
			LEAVE ManejoErrores;
		END IF;


		-- Valida que exista la localidad en el catálogo de localidades
		IF(NOT EXISTS(SELECT LocalidadID
						FROM LOCALIDADREPUB
					   WHERE LocalidadID = Par_LocalidadID)) THEN
			SET Par_NumErr := 18;
			SET Par_ErrMen := CONCAT('La localidad Definida No Existe: ', CONVERT(Par_LocalidadID,CHAR(20)));
			SET Var_Control := 'localidadID';
			LEAVE ManejoErrores;
		END IF;

		-- Valida que exista la colonia en el catálogo de colonias
		IF(NOT EXISTS(SELECT ColoniaID
						FROM COLONIASREPUB
					   WHERE ColoniaID = Par_ColoniaID)) THEN
			SET Par_NumErr := 19;
			SET Par_ErrMen := CONCAT('La Colionia Definida No Existe: ', CONVERT(Par_ColoniaID,CHAR(20)));
			SET Var_Control := 'coloniaID';
			LEAVE ManejoErrores;
		END IF;

		-- Valida que exista CP en el catálogo de colonias
		IF(SELECT length(Par_CP) < Con_Longitud) THEN
			SET Par_NumErr := 20;
			SET Par_ErrMen := CONCAT('El Código Postal Definido no es Válido: ', CONVERT(Par_CP,CHAR(20)));
			SET Var_Control := 'codigoPostal';
			LEAVE ManejoErrores;
		END IF;

		-- Valida que exista País en el catálogo de paises
		IF(NOT EXISTS(SELECT PaisID
						FROM PAISES
					   WHERE PaisID = Par_PaisID)) THEN
			SET Par_NumErr := 21;
			SET Par_ErrMen := CONCAT('El País Definido No Existe: ', CONVERT(Par_PaisID,CHAR(20)));
			SET Var_Control := 'paisID';
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
                    Par_ClienteID,			Str_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
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

		SELECT 	Estatus,		PaisResidencia,		Nacion
		INTO 	Var_Estatus,	Var_PaisResidencia,	Var_Nacion
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;

		SELECT ValorParametro INTO Var_ValorParametro
		FROM PARAMGENERALES
		WHERE LlaveParametro = PermiteResidExt;

		IF(Var_Estatus=Inactivo)THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El safilocale.cliente se Encuentra Inactivo' ;
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(NOT EXISTS(SELECT ClienteID
					FROM CLIENTES
					WHERE ClienteID = Par_ClienteID)) THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := CONCAT('El Numero de safilocale.cliente No Existe: ', CONVERT(Par_ClienteID,CHAR(20)));
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_Nacion = Cli_Nacional )THEN

			IF(IFNULL(Par_EstadoID,Entero_Cero)) = Entero_Cero AND Var_ValorParametro = Str_NO THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'El Estado esta Vacio.' ;
				SET Var_Control := 'estadoID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_MunicipioID, Entero_Cero)) = Entero_Cero AND Var_ValorParametro = Str_NO THEN
				SET Par_NumErr := 4;
				SET Par_ErrMen := 'El Municipio esta Vacio.' ;
				SET Var_Control := 'municipioID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia AND Var_ValorParametro = Str_NO THEN
				SET Par_NumErr := 5;
				SET Par_ErrMen := 'La Calle esta Vacia.' ;
				SET Var_Control := 'calle';
				LEAVE ManejoErrores;
			END IF;

			SET Par_Lote := IFNULL(Par_Lote, Cadena_Vacia);
			SET Par_Manzana := IFNULL(Par_Manzana, Cadena_Vacia);

			IF(Var_ValorParametro = Str_NO)THEN
				IF(Par_Lote = Cadena_Vacia AND Par_Manzana = Cadena_Vacia) THEN
					IF(IFNULL(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia THEN
						SET Par_NumErr := 6;
						SET Par_ErrMen := 'El Numero esta Vacio.' ;
						SET Var_Control := 'numeroCasa';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero AND Var_ValorParametro = Str_NO THEN
				SET Par_NumErr := 7;
				SET Par_ErrMen := 'La Colonia Esta Vacia.' ;
				SET Var_Control := 'coloniaID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CP, Entero_Cero)) = Entero_Cero AND Var_ValorParametro = Str_NO THEN
				SET Par_NumErr := 8;
				SET Par_ErrMen := 'El Codigo Postal esta Vacio.' ;
				SET Var_Control := 'CP';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_LocalidadID,Entero_Cero)) = Entero_Cero AND Var_ValorParametro = Str_NO THEN
				SET Par_NumErr := 9;
				SET Par_ErrMen := 'La Localidad esta Vacia.' ;
				SET Var_Control := 'localidadID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_DirID   := (SELECT DireccionID FROM DIRECCLIENTE WHERE ClienteID= Par_ClienteID AND Oficial=Str_SI);
		SET Par_Oficial := IF(IFNULL(Par_Oficial,Cadena_Vacia)=Cadena_Vacia, Str_NO, IFNULL(UPPER(Par_Oficial),Str_NO));

		IF(IFNULL(Var_DirID,Entero_Cero) > Entero_Cero AND IFNULL(Var_DirID,Entero_Cero) != Par_DireccionID
			AND Par_Oficial = Str_SI) THEN
			SET Par_NumErr := 10;
			SET Par_ErrMen := 'El safilocale.cliente ya tiene una Direccion Oficial.' ;
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_DirIDF := (SELECT DireccionID FROM DIRECCLIENTE WHERE ClienteID= Par_ClienteID AND Fiscal=Str_SI);
		SET Par_Fiscal := IF(IFNULL(Par_Fiscal,Cadena_Vacia)=Cadena_Vacia, Str_NO, IFNULL(UPPER(Par_Fiscal),Str_NO));

		IF(IFNULL(Var_DirIDF,Entero_Cero) > Entero_Cero AND IFNULL(Var_DirIDF,Entero_Cero) != Par_DireccionID
			AND Par_Fiscal = Str_SI ) THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := 'El safilocale.cliente ya tiene una Direccion Fiscal.' ;
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_DirecCompleta,Cadena_Vacia)) = Cadena_Vacia AND Var_ValorParametro = Str_SI
	    	AND (Var_PaisResidencia != 700 AND Var_PaisResidencia != 999)THEN
				SET Par_NumErr := 10;
				SET Par_ErrMen := 'La Direccion Completa esta Vacia.' ;
				SET Var_Control := 'direccionCompleta';
				LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PaisID, Entero_Cero)) = Entero_Cero AND Var_ValorParametro = Str_NO THEN
			SET Par_NumErr := 13;
			SET Par_ErrMen := 'El País esta Vacio.' ;
			SET Var_Control := 'paisID';
			LEAVE ManejoErrores;
		END IF;

		SET NombEstado := (SELECT Nombre
						FROM ESTADOSREPUB
						WHERE EstadoID=Par_EstadoID);

		SET NombMunicipio := (SELECT M.Nombre
						 FROM MUNICIPIOSREPUB M,ESTADOSREPUB E
						 WHERE E.EstadoID=M.EstadoID AND E.EstadoID=Par_EstadoID AND M.MunicipioID=Par_MunicipioID);

		SET Par_NumeroCasa := IFNULL(Par_NumeroCasa, Cadena_Vacia);
		SET Par_NumInterior := IFNULL(Par_NumInterior, Cadena_Vacia);
		SET Par_Piso := IFNULL(Par_Piso, Cadena_Vacia);
		SET Par_Lote := IFNULL(Par_Lote, Cadena_Vacia);
		SET Par_Manzana := IFNULL(Par_Manzana, Cadena_Vacia);

		SET DirecCompleta := Par_Calle;

		IF(Par_NumeroCasa != Cadena_Vacia) THEN
			SET DirecCompleta := CONCAT(DirecCompleta,', NO. ',Par_NumeroCasa);
		END IF;

		IF(Par_NumInterior != Cadena_Vacia) THEN
			SET DirecCompleta := CONCAT(DirecCompleta,', INTERIOR ',Par_NumInterior);
		END IF;

		IF(Par_Piso != Cadena_Vacia) THEN
			SET DirecCompleta := CONCAT(DirecCompleta,', PISO ',Par_Piso);
		END IF;

		IF(Par_Lote != Cadena_Vacia) THEN
			SET DirecCompleta := CONCAT(DirecCompleta,', LOTE ',Par_Lote);
		END IF;

		IF(Par_Manzana != Cadena_Vacia) THEN
			SET DirecCompleta := CONCAT(DirecCompleta,', MANZANA ',Par_Manzana);
		END IF;

		SET DirecCompleta := UPPER(CONCAT(DirecCompleta,', COL. ',Par_NombreColonia,', C.P. ',Par_CP,', ',NombMunicipio,', ',NombEstado,'.'));

		SET Par_Calle     := UPPER(Par_Calle);
		SET Par_Descripcion := UPPER(Par_Descripcion);
		SET Par_PrimECalle  := UPPER(Par_PrimECalle);
		SET Par_SegECalle   := UPPER(Par_SegECalle);

	    IF(Var_ValorParametro = Str_SI AND (Var_PaisResidencia != 700 AND Var_PaisResidencia != 999))THEN
			SET DirecCompleta := Par_DirecCompleta;
		END IF;

		SET Aud_FechaActual := NOW();

		UPDATE DIRECCLIENTE SET
			TipoDireccionID   	= Par_TipoDirecID,
			PaisID				= Par_PaisID,
			EstadoID      		= Par_EstadoID,
			MunicipioID     	= Par_MunicipioID,
			LocalidadID     	= Par_LocalidadID,
			ColoniaID     		= Par_ColoniaID,

			Colonia       		= Par_NombreColonia,
			Calle       		= Par_Calle,
			NumeroCasa      	= Par_NumeroCasa,
			NumInterior     	= Par_NumInterior,
			Piso        		= Par_Piso,

			PrimeraEntreCalle 	= Par_PrimECalle,
			SegundaEntreCalle   = Par_SegECalle,
			CP          		= Par_CP,
			DireccionCompleta 	= DirecCompleta,
			Descripcion     	= Par_Descripcion,

			Latitud       		= Par_Latitud,
			Longitud      		= Par_Longitud,
			Oficial      		= Par_Oficial,
			Fiscal        		= Par_Fiscal,
			Lote        		= Par_Lote  ,

			Manzana       		= Par_Manzana,
			AniosRes			= Par_AnioRes,
			EmpresaID     		= Par_EmpresaID,
			Usuario       		= Aud_Usuario,
			FechaActual     	= Aud_FechaActual,
			DireccionIP     	= Aud_DireccionIP,

			ProgramaID      	= Aud_ProgramaID,
			Sucursal      		= Aud_Sucursal,
			NumTransaccion    	= Aud_NumTransaccion

		WHERE ClienteID = Par_ClienteID AND DireccionID = Par_DireccionID ;

		CALL RIESGOPLDCTEPRO(
			Par_ClienteID,      	Str_NO,         	Par_NumErr,       	Par_ErrMen,   Par_EmpresaID,      Aud_Usuario,
			Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
		CALL BITACORAHISTPERSALT(
			Aud_NumTransaccion,			Alt_Direcciones,		Par_ClienteID,				Entero_Cero,		Par_DireccionID,
			Entero_Cero,				Str_NO,					Par_NumErr,					Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		/*FIN de Respaldo de Bitacora Historica ########################################################################################### */

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Direccion Modificada Exitosamente: ', CONVERT(Par_DireccionID, CHAR));
		SET Var_Control := 'direccionID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_DireccionID AS Consecutivo;
	END IF;

END TerminaStore$$