-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCIONCTEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECCIONCTEMOD`;
DELIMITER $$

CREATE PROCEDURE `DIRECCIONCTEMOD`(
	/*SP de Alta de Direccion de Cliente Estandarizado */
	Par_ClienteID   	INT(11),  		-- CLIENTE ID
	Par_DireccionID   	INT(11),  		-- DIREC
	Par_TipoDirecID   	INT(11),		-- TIPO DIREC
	Par_EstadoID    	INT(11),		-- ESTADO
	Par_MunicipioID   	INT(11),		-- MUNICIPIO

	Par_LocalidadID  	INT(11),		-- LOCALIDAD
	Par_ColoniaID   	INT(11),		-- COLINIA
	Par_NombreColonia 	VARCHAR(200),	-- NOMBRE COLONIA
	Par_Calle    	 	VARCHAR(50),	-- CALLE
	Par_NumeroCasa    	CHAR(10),		-- CASA NUMERO

	Par_NumInterior   	CHAR(10),		-- NUM INTERIOR
	Par_Piso      		CHAR(50),		-- PISO
	Par_PrimECalle    	VARCHAR(50),	-- CALLE
	Par_SegECalle     	VARCHAR(50),	-- SEGUNDA CALLE
	Par_CP        		CHAR(5),		-- CP

	Par_Descripcion   	VARCHAR(500),	-- DESCRIPCION
	Par_Latitud			VARCHAR(45),	-- LATITUD
	Par_Longitud		VARCHAR(45),	-- LONGITUD
	Par_Oficial			CHAR(1),		-- OFICIAL
	Par_Fiscal			CHAR(1),		-- FISCAL

	Par_Lote			CHAR(50),		-- LOTE
	Par_Manzana			CHAR(50),		-- MANZANA
	Par_Salida			CHAR(1), 		-- SALIDA
	INOUT Par_NumErr	INT(11),		-- NUM ERR

	INOUT Par_ErrMen	VARCHAR(400),	-- ERR MEN
	INOUT Par_DirecID	INT(11),		-- ID DIR

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),		-- AUDITORIA
	Aud_Usuario			INT(11),		-- AUDITORIA
	Aud_FechaActual		DATETIME,		-- AUDITORIA
	Aud_DireccionIP		VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID		VARCHAR(50),	-- AUDITORIA

	Aud_Sucursal		INT(11),    	-- AUDITORIA
	Aud_NumTransaccion	BIGINT(20)		-- AUDITORIA
  )
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Estatus_Activo  	CHAR(1);			-- ESTATUS ACTIVO
DECLARE Cadena_Vacia  		CHAR(1);			-- CADENA VACIA
DECLARE Fecha_Vacia   		DATE;				-- FECHA VACIA
DECLARE Entero_Cero   		INT;				-- ENTERO CERO
DECLARE DirecCompleta 		VARCHAR(500);		-- DIREC COMPLETA
DECLARE NombEstado    		VARCHAR(50);		-- NOMBRE ESTADO
DECLARE NombMunicipio 		VARCHAR(50);		-- NOMBRE MUNICIPIO
DECLARE Doficial    		INT;				-- DO OFICIAL
DECLARE DirID       		INT(11);			-- DIR ID
DECLARE Inactivo    		CHAR(1);			-- INACTIVO
DECLARE Str_SI      		CHAR(1);			-- ST SI
DECLARE Salida_SI   		CHAR(1);			-- SI
DECLARE Salida_NO   		CHAR(1);			-- NO
DECLARE Str_NO      		CHAR(1);			-- NO
DECLARE Alt_Direcciones		INT(11);			-- Alta de Direcciones

-- Declaracion de Variables
DECLARE Var_DirID   		INT(11);			-- ID
DECLARE Var_DirIDF    		INT(11);			-- DIR OF
DECLARE Var_Estatus   		CHAR(1);			-- ESTATUS
DECLARE Var_Control   		VARCHAR(25);  		-- CONTROL

DECLARE Var_PaisIDDom		INT(11);		-- País ID de la dirección
DECLARE Var_AniosRes		INT(11);		-- Años de residencia

-- Asignacion de Constantes
SET Estatus_Activo    	:= 'A';     			-- ESTATUS ACTIVO
SET Cadena_Vacia    	:= '';      			-- CADENA VACIA
SET Fecha_Vacia     	:= '1900-01-01';  		-- FECHA VACIA
SET Entero_Cero     	:= 0;     				-- ENTERO CERO
SET DirecCompleta		:= '';      			-- DIREC COMPLETA
SET NombEstado			:= '';      			-- NOMBRE ESTADO
SET NombMunicipio		:= '';      			-- NOMBRE MUNICIPIO
SET Doficial			:= 0;     				-- DO OFICIAL
SET Inactivo			:='I';  				-- INACTIVO
SET Salida_SI			:= 'S';       			-- Salida SI
SET Salida_NO			:= 'N';       			-- Salida NO
SET Str_NO				:= 'N';					-- NO
SET Str_SI				:= 'S';       			-- Si
SET Alt_Direcciones		:= 2;					-- Alta de direcciones
SET Var_PaisIDDom		:= 0;					-- Valor asignado por defecto
SET Var_AniosRes		:= 0;					-- Valor asignado por defecto

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-DIRECCIONCTEMOD');
	END;

	SELECT Estatus INTO Var_Estatus
		FROM CLIENTES
		WHERE ClienteID=Par_ClienteID;


	IF(Var_Estatus=Inactivo)THEN

		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El safilocale.cliente se Encuentra Inactivo' ;
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;


	SET Par_ClienteID := IFNULL(Par_ClienteID,-1);

	IF(NOT EXISTS(SELECT ClienteID
						FROM CLIENTES
						WHERE ClienteID = Par_ClienteID)) THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := CONCAT('El Numero de safilocale.cliente No Existe: ', CONVERT(Par_ClienteID,CHAR(20)));
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_DireccionID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'La Direccion ID esta Vacio.' ;
		SET Var_Control := 'direccionID';
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT DireccionID
						FROM DIRECCLIENTE
						WHERE ClienteID = Par_ClienteID AND DireccionID = Par_DireccionID )) THEN
		SET Par_NumErr := 12;
		SET Par_ErrMen := CONCAT('El Numero de Direccion del safilocale.cliente No Existe: ', CONVERT(Par_DireccionID,CHAR(5)));
		SET Var_Control := 'direccionID';
		LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_EstadoID,Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El Estado esta Vacio.' ;
		SET Var_Control := 'estadoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MunicipioID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'El Municipio esta Vacio.' ;
		SET Var_Control := 'municipioID';
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 5;
		SET Par_ErrMen := 'La Calle esta Vacia.' ;
		SET Var_Control := 'calle';
		LEAVE ManejoErrores;
	END IF;

	SET Par_Lote := IFNULL(Par_Lote, Cadena_Vacia);
	SET Par_Manzana := IFNULL(Par_Manzana, Cadena_Vacia);

	IF(Par_Lote = Cadena_Vacia AND Par_Manzana = Cadena_Vacia) THEN
		IF(IFNULL(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'El Numero esta Vacio.' ;
			SET Var_Control := 'numeroCasa';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'La Colonia Esta Vacia.' ;
		SET Var_Control := 'coloniaID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CP, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 8;
		SET Par_ErrMen := 'El Codigo Postal esta Vacio.' ;
		SET Var_Control := 'CP';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_LocalidadID,Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'La Localidad esta Vacia.' ;
		SET Var_Control := 'localidadID';
		LEAVE ManejoErrores;
	END IF;


	SET Var_DirID   := (SELECT DireccionID FROM DIRECCLIENTE WHERE ClienteID= Par_ClienteID AND Oficial=Str_SI);
	SET Par_Oficial := IF(IFNULL(Par_Oficial,Cadena_Vacia)=Cadena_Vacia, Str_NO, IFNULL(UPPER(Par_Oficial),Str_NO));

	IF(IFNULL(Var_DirID,Entero_Cero) > Entero_Cero AND IFNULL(Var_DirID,Entero_Cero) != Par_DireccionID AND Par_Oficial = Str_SI) THEN
		SET Par_NumErr := 10;
		SET Par_ErrMen := 'El safilocale.cliente ya tiene una Direccion Oficial.' ;
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	SET Var_DirIDF := (SELECT DireccionID FROM DIRECCLIENTE WHERE ClienteID= Par_ClienteID AND Fiscal=Str_SI);
	SET Par_Fiscal := IF(IFNULL(Par_Fiscal,Cadena_Vacia)=Cadena_Vacia, Str_NO, IFNULL(UPPER(Par_Fiscal),Str_NO));

	IF(IFNULL(Var_DirIDF,Entero_Cero) > Entero_Cero AND IFNULL(Var_DirIDF,Entero_Cero) != Par_DireccionID AND Par_Fiscal = Str_SI ) THEN
		SET Par_NumErr := 11;
		SET Par_ErrMen := 'El safilocale.cliente ya tiene una Direccion Fiscal.' ;
		SET Var_Control := 'clienteID';
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

	SET Aud_FechaActual := NOW();

	UPDATE DIRECCLIENTE SET
		TipoDireccionID   	= Par_TipoDirecID,
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
		PaisID				= Var_PaisIDDom,
		AniosRes			= Var_AniosRes,
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
		Aud_NumTransaccion,			Alt_Direcciones,		Par_ClienteID,				Entero_Cero,			Par_DireccionID,
		Entero_Cero,				Salida_No,				Par_NumErr,					Par_ErrMen,					Par_EmpresaID,
		Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,
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

IF(Par_Salida = Salida_NO) THEN
	SET Par_NumErr := CONVERT(Par_NumErr, CHAR(10));
	SET Par_ErrMen := Par_ErrMen;
	SET Par_DirecID := Par_DireccionID;
END IF;

END TerminaStore$$