-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCIONCTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECCIONCTEALT`;
DELIMITER $$


CREATE PROCEDURE `DIRECCIONCTEALT`(
	/*SP para Alta de Direcciones del Clientes Estandarizado*/
	Par_ClienteID			INT(11),		-- CLIENTE ID
	Par_TipoDirecID			INT(11),		-- TIPO DIREC
	Par_EstadoID			INT(11),		-- ESTADO
	Par_MunicipioID			INT(11),		-- MUNICIPIO
	Par_LocalidadID			INT(11),		-- LOCALIDAD

	Par_ColoniaID			INT(11),		-- COLINIA
	Par_NombreColonia		VARCHAR(200),	-- NOMBRE COLONIA
	Par_Calle				VARCHAR(350),	-- CALLE
	Par_NumeroCasa			CHAR(10),		-- CASA NUMERO
	Par_NumInterior			CHAR(10),		-- NUM INTERIOR

	Par_Piso				CHAR(50),		-- PISO
	Par_PrimECalle			VARCHAR(50),	-- CALLE
	Par_SegECalle			VARCHAR(50),  	-- SEGUNDA CALLE
	Par_CP					CHAR(5),		-- CP
	Par_Descripcion			VARCHAR(500),	-- DESCRIPCION

	Par_Latitud				VARCHAR(45),	-- LATITUD
	Par_Longitud			VARCHAR(45),	-- LONGITUD
	Par_Oficial				CHAR(1),		-- OFICIAL
	Par_Fiscal				CHAR(1),		-- FISCAL
	Par_Lote				CHAR(50),		-- LOTE

	Par_Manzana				CHAR(50),		-- MANZANA
	Par_Salida				CHAR(1), 		-- SALIDA
	INOUT Par_NumErr		INT(11),		-- NUM ERROR
	INOUT Par_ErrMen		VARCHAR(400),	-- ERR MEN
	INOUT Par_DirecID		INT(11),		-- DIREC

	Par_EmpresaID			INT(11),		-- AUDITORIA
	Aud_Usuario				INT(11),		-- AUDITORIA
	Aud_FechaActual			DATETIME,		-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal			INT(11),		-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)		-- AUDITORIA
	)

TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Estatus_Activo		CHAR(1);		-- ESTATUS ACTIVO
DECLARE Cadena_Vacia		CHAR(1);		-- CADENA VACIA
DECLARE Fecha_Vacia			DATE;			-- FECHA VACIA
DECLARE Entero_Cero			INT;			-- ENTERO CERO
DECLARE SiOficial			CHAR(1);		-- SI OFICIAL
DECLARE Salida_SI			CHAR(1);		-- SALIDA SI
DECLARE Salida_No			CHAR(1);		-- SALIDA NO
DECLARE Var_SI				CHAR(1);		-- SI
DECLARE Inactivo			CHAR(1);		-- INACTIVO

-- Declaracion de Variables
DECLARE	Var_DirID   		CHAR(1);		-- DIR ID
DECLARE Var_DirIDF    		CHAR(1);		-- DIR OFICIAL
DECLARE Var_Estatus  		CHAR(1);		-- ESTATUS
DECLARE Var_Control			VARCHAR(25);	-- CONTROL
DECLARE NumeroDireccion		INT(11);		-- NUMERO DIREC
DECLARE DirecCompleta		VARCHAR(500);	-- DIREC COMPLETA
DECLARE NombEstado			VARCHAR(50);	-- NOMB ESTADO
DECLARE NombMunicipio		VARCHAR(50);	-- MUNICIPIO
DECLARE Alt_Direcciones		INT(11);		-- Alta de Direcciones
DECLARE Var_CliRocktech		INT(11);		-- Numero Cliente Rocktech
DECLARE Var_LlaveCliProEsp	VARCHAR(50);	-- Llave para filtrar el cliente parametrizado
DECLARE Var_CliProcEspecifico	INT(11);	-- Almacena el numero del cliente parametrizado
DECLARE Var_PaisIDDom		INT(11);		-- País ID de la dirección
DECLARE Var_AniosRes		INT(11);		-- Años de residencia

-- Asignacion de Constantes
SET Estatus_Activo		:= 'A';   		    -- Estatus Activo
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';  	-- Fecha Vacia
SET Entero_Cero			:= 0;       		-- Entero Cero
SET Salida_SI			:= 'S';       		-- Salida SI
SET Salida_NO			:= 'N';       		-- Salida No
SET Var_SI 				:= 'S';       		-- Si
SET Inactivo			:= 'I';           	-- Estatus inactivo del cliente

SET NumeroDireccion		:= 0;				-- Numero de Direccion para dar de alta una nueva
SET DirecCompleta		:= '';				-- DireccionCompleta
SET NombEstado			:= '';				-- NombEstado
SET NombMunicipio		:= '';				-- NombMunicipio
SET Alt_Direcciones		:= 2;				-- Alta de direcciones
SET Var_PaisIDDom		:= 0;				-- Valor asignado por defecto
SET Var_AniosRes		:= 0;				-- Valor asignado por defecto

-- Asignacion de Variables
SET Var_LlaveCliProEsp	:=	'CliProcEspecifico';	-- Llave para filtrar el cliente parametrizado
SET Var_CliRocktech		:= 44;						-- Numero de cliente registrado en el SAFI

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-DIRECCIONCTEALT');
	END;

	SELECT Estatus INTO Var_Estatus
		FROM CLIENTES
		WHERE ClienteID=Par_ClienteID;

	SELECT 	ValorParametro
	INTO	Var_CliProcEspecifico
	FROM PARAMGENERALES
	WHERE LlaveParametro = Var_LlaveCliProEsp;

	SET Var_CliProcEspecifico := IFNULL(Var_CliProcEspecifico, Entero_Cero);

	IF(Var_Estatus=Inactivo)THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := 'El safilocale.cliente se Encuentra Inactivo' ;
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoID,Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 2;
		SET Par_ErrMen := 'El Estado esta Vacio.' ;
		SET Var_Control := 'estadoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MunicipioID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 3;
		SET Par_ErrMen := 'El Municipio esta Vacio.' ;
		SET Var_Control := 'municipioID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 4;
		SET Par_ErrMen := 'La Calle esta Vacia.' ;
		SET Var_Control := 'calle';
		LEAVE ManejoErrores;
	END IF;

	SET Par_Lote := IFNULL(Par_Lote, Cadena_Vacia);
	SET Par_Manzana := IFNULL(Par_Manzana, Cadena_Vacia);

	IF(Par_Lote = Cadena_Vacia AND Par_Manzana = Cadena_Vacia) THEN
		IF(IFNULL(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'El Numero esta Vacio.' ;
			SET Var_Control := 'numeroCasa';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 6;
		SET Par_ErrMen := 'La Colonia Esta Vacia.' ;
		SET Var_Control := 'coloniaID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CP, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 7;
		SET Par_ErrMen := 'El Codigo Postal esta Vacio.' ;
		SET Var_Control := 'CP';
		LEAVE ManejoErrores;
	END IF;

	-- El cliente rocktech no necesita la validacion de localidad
	IF(Var_CliProcEspecifico <> Var_CliRocktech) THEN
		IF(IFNULL(Par_LocalidadID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := 'La Localidad esta Vacia.' ;
			SET Var_Control := 'localidadID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Var_DirID := (SELECT DireccionID FROM DIRECCLIENTE WHERE ClienteID= Par_ClienteID AND Oficial=Var_SI);

	IF(IFNULL(Var_DirID,Entero_Cero) <> Entero_Cero AND  Par_Oficial = Var_SI ) THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'El safilocale.cliente ya tiene una Direccion Oficial.' ;
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	SET Var_DirIDF := (SELECT DireccionID FROM DIRECCLIENTE WHERE ClienteID= Par_ClienteID AND Fiscal=Var_SI);

	IF(IFNULL(Var_DirIDF,Entero_Cero) <> Entero_Cero AND  Par_Fiscal = Var_SI ) THEN
		SET Par_NumErr := 9;
		SET Par_ErrMen := 'El safilocale.cliente ya tiene una Direccion Fiscal.' ;
		SET Var_Control := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

	SET NombEstado := (SELECT Nombre
		FROM ESTADOSREPUB
		WHERE EstadoID = Par_EstadoID);

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
		SET DirecCompleta := CONCAT(DirecCompleta,", No. ",Par_NumeroCasa);
	END IF;

	IF(Par_NumInterior != Cadena_Vacia) THEN
		SET DirecCompleta := CONCAT(DirecCompleta,", INTERIOR ",Par_NumInterior);
	END IF;

	IF(Par_Piso != Cadena_Vacia) THEN
		SET DirecCompleta := CONCAT(DirecCompleta,", PISO ",Par_Piso);
	END IF;

	IF(Par_Lote != Cadena_Vacia) THEN
		SET DirecCompleta := CONCAT(DirecCompleta,", LOTE ",Par_Lote);
	END IF;

	IF(Par_Manzana != Cadena_Vacia) THEN
		SET DirecCompleta := CONCAT(DirecCompleta,", MANZANA ",Par_Manzana);
	END IF;

	SET DirecCompleta := UPPER(CONCAT(DirecCompleta,", COL. ",Par_NombreColonia,", C.P ",Par_CP,", ",NombMunicipio,", ",NombEstado,"."));

	SET NumeroDireccion := (SELECT IFNULL(MAX(DireccionID),Entero_Cero)+1  FROM DIRECCLIENTE WHERE ClienteID=Par_ClienteID );

	SET Aud_FechaActual = NOW();

	INSERT INTO DIRECCLIENTE (
		`ClienteID`,    	`DireccionID`,      	`EmpresaID`,     `TipoDireccionID`,     `EstadoID`,
		`MunicipioID`,   	`LocalidadID`,     		`ColoniaID`,     `Colonia`,        		`Calle`,
		`NumeroCasa`,   	`NumInterior`,      	`Piso`,          `PrimeraEntreCalle`,   `SegundaEntreCalle`,
		`CP`,       		`DireccionCompleta`,  	`Descripcion`,   `Latitud`,        		`Longitud`,
		`Oficial`,      	`Fiscal`,      	 		`Lote`,          `Manzana`,        		`PaisID`,
		`AniosRes`,			`Usuario`,				`FechaActual`,   `DireccionIP`,      	`ProgramaID`,
		`Sucursal`,       	`NumTransaccion`)
	VALUES (
		Par_ClienteID,    	NumeroDireccion,    Par_EmpresaID,    	Par_TipoDirecID,  	Par_EstadoID,
		Par_MunicipioID,  	Par_LocalidadID,    Par_ColoniaID,    	Par_NombreColonia,  Par_Calle,
		Par_NumeroCasa,   	Par_NumInterior,    Par_Piso,     		Par_PrimECalle,   	Par_SegECalle,
		Par_CP,       		DirecCompleta,      Par_Descripcion,  	Par_Latitud,    	Par_Longitud,
		Par_Oficial,    	Par_Fiscal,       	Par_Lote,     		Par_Manzana,    	Var_PaisIDDom,
		Var_AniosRes,		Aud_Usuario,		Aud_FechaActual,  	Aud_DireccionIP,    Aud_ProgramaID,
		Aud_Sucursal,   	Aud_NumTransaccion);

	SET Par_NumErr	:=	Entero_Cero;
	SET Par_ErrMen	:=	Cadena_Vacia;
	CALL RIESGOPLDCTEPRO(
		Par_ClienteID,      	Salida_NO,        	Par_NumErr,       	Par_ErrMen,   Par_EmpresaID,      Aud_Usuario,
		Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion);

	IF(Par_NumErr!=Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
	CALL BITACORAHISTPERSALT(
		Aud_NumTransaccion,			Alt_Direcciones,		Par_ClienteID,				Entero_Cero,			NumeroDireccion,
		Entero_Cero,				Salida_No,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,
		Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr!=Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;
	/*FIN de Respaldo de Bitacora Historica ########################################################################################### */

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Direccion Agregada Exitosamente: ', CONVERT(NumeroDireccion, CHAR));
	SET Var_Control := 'direccionID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		NumeroDireccion AS Consecutivo;
END IF;
IF (Par_Salida = Salida_No) THEN
	SET Par_NumErr := CONVERT(Par_NumErr, CHAR(10));
	SET Par_ErrMen := Par_ErrMen;
	SET Par_DirecID := NumeroDireccion;
END IF;
END TerminaStore$$
