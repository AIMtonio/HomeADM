-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOSGENWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGOSGENWSLIS`;DELIMITER $$

CREATE PROCEDURE `CATALOGOSGENWSLIS`(
	/* SP para consulta de Catalogos desde WS ZAFI*/
	Par_NomCatalogo	    VARCHAR(50),	-- NOMBRE DE CATALOGO
	Par_Usuario			VARCHAR(45),	-- USUARIO
	Par_Clave			VARCHAR(100),	-- CLAVE

	Par_EmpresaID		INT,			-- AUDITORIA
	Aud_Usuario			INT,			-- AUDITORIA
	Aud_FechaActual		DATETIME,		-- AUDITORIA
	Aud_DireccionIP		VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID		VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal		INT,			-- AUDITORIA
	Aud_NumTransaccion	BIGINT			-- AUDITORIA

	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero   		INT;			-- ENTERO CERO

	-- DECLARACION DE VARIABLES
	DECLARE Var_Sucur			VARCHAR(30);	-- SUCURSAL
	DECLARE Var_Promotores		VARCHAR(30);	-- PROMOTORES
	DECLARE	Var_ProdCred		VARCHAR(30);	-- PRODUCTO CREDITO
	DECLARE Var_CredPlazos		VARCHAR(30);	-- CREDITO PLAZOS
	DECLARE Var_EmpNomina 		VARCHAR(30);	-- EMPRESA NOMINA
	DECLARE Var_Paises			VARCHAR(30);	-- PAISES
	DECLARE Var_Estados			VARCHAR(30);	-- ESTADOS
	DECLARE Var_Municipios		VARCHAR(30);	-- MUNICIPIOS
	DECLARE Var_Localidad		VARCHAR(30);	-- LOCALIDAD
	DECLARE Var_Colonias		VARCHAR(30);	-- COLONIAS
	DECLARE Var_Sectores		VARCHAR(30);	-- SECTORES
	DECLARE Var_ActBMX			VARCHAR(30);	-- ACT BMX
	DECLARE Var_TiposDirec		VARCHAR(30);	-- TIPOS DIREC
	DECLARE Var_Clientes		VARCHAR(30);	-- CLIENTES
	DECLARE Var_DestCred		VARCHAR(30);	-- DEST CRE
	DECLARE Var_TiposIdenti		VARCHAR(30);	-- TIPOS IDENTI

	DECLARE Var_EstatusA		CHAR(1);		-- ESTATUS ACTIVO
	DECLARE Var_Padre        	CHAR(1);		-- VAR PADRE
	DECLARE Var_Sexo         	VARCHAR(6);		-- SEXO
	DECLARE Var_Femenino     	VARCHAR(20);	-- FEMENINO
	DECLARE Var_Masculino    	VARCHAR(20);	-- MASCULINO
	DECLARE Cadena_Vacia     	VARCHAR(10);	-- CADENA VACIA
	DECLARE Var_Femen        	CHAR(1);		-- FEMENINO
	DECLARE Var_Mascu        	CHAR(1);		-- MASCULINO
	DECLARE Var_Destinos     	VARCHAR(20);	-- DESTINOS
	DECLARE Var_Plazos       	VARCHAR(20);	-- PLAZOS
	DECLARE NumExito			VARCHAR(20); 	-- EXITO
	DECLARE MenExito			VARCHAR(20); 	-- ERROR
	DECLARE Var_PerfilWsVbc		INT(11);		-- PERFIL OPERACIONES VBC


	-- ASIGNACION DE CONSTANTES
	SET	Entero_Cero 		:= 0;						-- ENTERO CERO

	-- ASIGNACION DE VARIABLES
	SET	Var_Sucur 			:= 'Sucursales';			-- SUCURSAL
	SET	Var_Promotores 		:= 'Promotores';			-- PROMOTORES
	SET	Var_ProdCred 		:= 'ProductosCredito';		-- PRODUCTO CREDITO
	SET	Var_CredPlazos		:= 'CreditosPlazos';		-- CREDITO PLAZOS
	SET	Var_EmpNomina 		:= 'EmpresasNomina';		-- EMPRESA NOMINA
	SET Var_Paises    		:= 'Paises';				-- PAISES
	SET Var_Estados			:= 'Estados';				-- ESTADOS
	SET Var_Municipios		:= 'Municipios';			-- MUNICIPIOS
	SET	Var_Localidad		:= 'Localidades';			-- LOCALIDAD
	SET	Var_Colonias		:= 'Colonias';				-- COLONIAS
	SET Var_Sectores		:= 'SectorGeneral';			-- SECTORES
	SET	Var_ActBMX			:= 'ActividadesBMX';		-- ACT BMX
	SET	Var_TiposDirec		:= 'TiposDireccion';		-- TIPOS DIREC
	SET	Var_Clientes		:= 'Clientes';				-- CLIENTES
	SET	Var_DestCred		:= 'DestinosCredito';		-- DEST CRE
	SET	Var_TiposIdenti		:= 'TiposIdentificaciones';	-- TIPOS IDENTI

	SET Var_Sexo      		:= 'Sexo';					-- SEXO
	SET Var_EstatusA  		:= 'A';						-- ESTATUS
	SET Var_Padre     		:= '';						-- PADRE
	SET Var_Femenino  		:= 'Femenino';				-- FEMENINO
	SET Var_Masculino 		:= 'Masculino';				-- MASCULINO
	SET Var_Femen     		:= 'f'; 					-- FEMENINO
	SET Var_Mascu     		:= 'm'; 					-- MASCULINO
	SET Cadena_Vacia  		:= '';  					-- CADENA VACIA
	SET NumExito			:= '00';					-- EXITO
	SET MenExito			:= 'Consulta Exitosa';		-- MENSAJE

	SET Var_PerfilWsVbc		:= (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
	SET Var_PerfilWsVbc		:= IFNULL(Var_PerfilWsVbc,Entero_Cero);

	IF(Var_PerfilWsVbc = Entero_Cero)THEN
		SELECT 	Cadena_Vacia AS Id_Campo,
				Cadena_Vacia AS NombreCampo,
				Cadena_Vacia AS Id_Padre,
	            '60' AS NumErr,
				'No existe perfil definido para el usuario.' AS ErrMen;
		LEAVE TerminaStore;
	END IF;

	IF IFNULL(Par_Usuario, Cadena_Vacia) = Cadena_Vacia THEN
		SELECT 	Cadena_Vacia AS Id_Campo,
				Cadena_Vacia AS NombreCampo,
				Cadena_Vacia AS Id_Padre,
	            '01' AS NumErr,
				'El Usuario esta Vacio' AS ErrMen;
		LEAVE TerminaStore;
	END IF;
	IF IFNULL(Par_Clave, Cadena_Vacia) = Cadena_Vacia THEN
		SELECT 	Cadena_Vacia AS Id_Campo,
				Cadena_Vacia AS NombreCampo,
				Cadena_Vacia AS Id_Padre,
	            '02' AS NumErr,
				'La Clave del Usuario esta Vacia' AS ErrMen;
		LEAVE TerminaStore;
	END IF;

	IF NOT EXISTS (SELECT Clave
					FROM USUARIOS
					WHERE Clave = Par_Usuario AND Contrasenia = Par_Clave And Estatus = Var_EstatusA AND RolID = Var_PerfilWsVbc) THEN
		SELECT 	Cadena_Vacia AS Id_Campo,
				Cadena_Vacia AS NombreCampo,
				Cadena_Vacia AS Id_Padre,
	            '03' AS NumErr,
				'El Usuario o la Clave Son Incorrectos.' AS ErrMen;
		LEAVE TerminaStore;
	END IF;


	IF (Par_NomCatalogo = Var_Sucur) THEN
		SELECT SucursalID AS Id_Campo, NombreSucurs AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM SUCURSALES
	    WHERE Estatus = Var_EstatusA;
	END IF;
	IF (Par_NomCatalogo = Var_Promotores) THEN
		SELECT PromotorID AS Id_Campo, NombrePromotor AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM PROMOTORES
	    WHERE Estatus = Var_EstatusA;
	END IF;
	IF (Par_NomCatalogo = Var_ProdCred) THEN
		SELECT ProducCreditoID AS Id_Campo, Descripcion AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
	    FROM PRODUCTOSCREDITO;
	END IF;
	IF (Par_NomCatalogo = Var_CredPlazos) THEN
		SELECT plazoID AS Id_Campo, Dias AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
	    FROM CREDITOSPLAZOS;
	END IF;
	IF (Par_NomCatalogo = Var_EmpNomina) THEN
		SELECT InstitNominaID AS Id_Campo, NombreInstit AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
	    FROM INSTITNOMINA WHERE Estatus = Var_EstatusA;
	END IF;
	IF (Par_NomCatalogo = Var_Paises) THEN
		SELECT PaisID AS Id_Campo, Nombre AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM PAISES;
	END IF;
	IF (Par_NomCatalogo = Var_Estados) THEN
		SELECT EstadoID AS Id_Campo, Nombre AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM ESTADOSREPUB;
	END IF;
	IF (Par_NomCatalogo = Var_Municipios) THEN
		SELECT MunicipioID AS Id_Campo, Nombre AS NombreCampo, EstadoID AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM MUNICIPIOSREPUB WHERE EstadoID = 20;
	END IF;
	IF (Par_NomCatalogo = Var_Localidad) THEN
		SELECT LocalidadID AS Id_Campo, NombreLocalidad AS NombreCampo, EstadoID AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM LOCALIDADREPUB WHERE EstadoID = 20; -- Solo Localidades de oaxaca
	END IF;
	IF (Par_NomCatalogo = Var_Colonias) THEN
		SELECT ColoniaID AS Id_Campo, Asentamiento as NombreCampo, EstadoID AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM COLONIASREPUB WHERE EstadoID = 20; -- Solo Colonias de oaxaca
	END IF;
	IF (Par_NomCatalogo = Var_Sectores) THEN
		SELECT SectorID AS Id_Campo, Descripcion AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM SECTORES;
	END IF;
	IF (Par_NomCatalogo = Var_ActBMX) THEN
		SELECT ActividadBMXID AS Id_Campo, Descripcion AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM ACTIVIDADESBMX WHERE Estatus = Var_EstatusA;
	END IF;
	IF (Par_NomCatalogo = Var_TiposDirec) THEN
		SELECT TipoDireccionID AS Id_Campo, Descripcion AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
		FROM TIPOSDIRECCION;
	END IF;
	IF (Par_NomCatalogo = Var_Clientes) THEN
		SELECT ClienteID AS Id_Campo, CONCAT(IFNULL(PrimerNombre,Cadena_Vacia)," ",IFNULL(SegundoNombre, Cadena_Vacia)," ",IFNULL(TercerNombre,Cadena_Vacia)," ",
	    IFNULL(ApellidoPaterno,Cadena_Vacia)," ",IFNULL(ApellidoMaterno,Cadena_Vacia))AS NombreCampo,
				PromotorActual AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
	        FROM CLIENTES where Estatus = Var_EstatusA;
	END IF;
	IF (Par_NomCatalogo = Var_DestCred) THEN
		SELECT DestinoCreID AS Id_Campo, Descripcion AS NombreCampo, Cadena_Vacia AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
			FROM DESTINOSCREDITO;
	END IF;

	IF (Par_NomCatalogo = Var_TiposIdenti) THEN
		SELECT TipoIdentiID AS Id_Campo, Nombre AS NombreCampo, Var_Padre AS Id_Padre, NumExito AS NumErr, MenExito AS ErrMen
	    FROM TIPOSIDENTI;
	END IF;

END TerminaStore$$