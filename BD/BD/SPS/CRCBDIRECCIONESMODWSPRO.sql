-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBDIRECCIONESMODWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBDIRECCIONESMODWSPRO`;
DELIMITER $$


CREATE PROCEDURE `CRCBDIRECCIONESMODWSPRO`(
# =======================================================================
# ------- STORE PARA MODIFCAR DIRECCIONES POR WS----
# =======================================================================
	Par_ClienteID				INT(11), 		-- Id del cliente
	Par_DireccionID				INT(11), 		-- ID de la direccion a modificar
	Par_TipoDireccionID			INT(11), 		-- tipo de direccion
	Par_EstadoID				INT(11),		-- identificador del estado
	Par_MunicipioID				INT(11),		-- identificador del municipio

    Par_LocalidadID				INT(11),		-- identificador de la localidad
	Par_ColoniaID				INT(11),		-- identificador de la colonia
	Par_Calle					VARCHAR(50),	-- Calle del domicilio
	Par_NumeroCasa				VARCHAR(10),	-- Numero de casa
	Par_NumInterior				VARCHAR(10),	-- Numero interior

    Par_Piso					VARCHAR(50), 	-- piso
	Par_PrimeraEntreCalle		VARCHAR(50),    -- primera entre calle
	Par_SegundaEntreCalle		VARCHAR(50),    -- segunda entre calle
	Par_Oficial					CHAR(1), 		-- indica si es oficial
	Par_Fiscal					CHAR(1),		-- indica si es fiscal

	Par_Salida					CHAR(1),		-- Salida
	INOUT Par_NumErr			INT(11),		-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de error
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11) ,		-- EmpresaID
	Aud_Usuario					INT(11) ,		-- Usuario ID

    Aud_FechaActual				DATETIME,		-- Fecha Actual
	Aud_DireccionIP				VARCHAR(15),	-- Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Nombre de programa
	Aud_Sucursal				INT(11) ,		-- Sucursal ID
	Aud_NumTransaccion			BIGINT(20)		-- Numero de transaccion
)

TerminaStore: BEGIN

    -- DECLARACION DE VARIABLES
	DECLARE Var_NombreColonia	VARCHAR(200);		-- Nombre de la colonia
	DECLARE Var_Descripcion		VARCHAR(500);		-- Descripcion del domicilio
	DECLARE Var_Latitud			VARCHAR(45);		-- Latitud
	DECLARE Var_Longitud 		VARCHAR(45); 		-- longitud
	DECLARE Var_Lote 			CHAR(50); 			-- numero de lote
	DECLARE Var_Manzana 		CHAR(50);			-- numero de manzana
	DECLARE Var_CP 				CHAR(5);			-- codigo postal
	DECLARE Var_Control			VARCHAR(50);		-- variable de control
    DECLARE Var_DirectID		INT; 				-- numero de direccion
    DECLARE Var_EjecutaCierre	CHAR(1);			-- indica si se esta realizando el cierre de dia

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia      	CHAR(1);			-- cadena vacia
	DECLARE Espacio_Bco      	VARCHAR(2);			-- Espacio en blanco
	DECLARE Entero_Cero        	INT(11);			-- entero cero
	DECLARE Fecha_Vacia         DATE;				-- fecha vacia
	DECLARE Salida_SI			CHAR(1); 			-- salida si
	DECLARE Salida_NO			CHAR(1); 			-- salida no
    DECLARE Car_Interroga		CHAR(1);
	DECLARE ValorCierre			VARCHAR(30);
	DECLARE Loc_NoCatalogada	INT(11);			-- Constante Localidad no catalogada 999999999

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia    		:= '1900-01-01';
	SET Entero_Cero        	:= 0;
	SET Salida_SI        	:= 'S';
	SET Salida_NO        	:= 'N';
	SET Espacio_Bco			:= ' ';
    SET Car_Interroga		:= '?';
	SET ValorCierre			:= 'EjecucionCierreDia';  -- INDICA SI SE REALIZA EL CIERRE DE DIA.
	SET Loc_NoCatalogada	:= 999999999;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr    := 999;
				SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBDIRECCIONESMODWSPRO');
				SET Var_Control   := 'SQLEXCEPTION';
			END;

		-- Limpiar campos vacios
        SET Par_Calle				:= REPLACE(Par_Calle,Car_Interroga,Cadena_Vacia);
        SET Par_NumeroCasa			:= REPLACE(Par_NumeroCasa,Car_Interroga,Cadena_Vacia);
        SET Par_NumInterior			:= REPLACE(Par_NumInterior,Car_Interroga,Cadena_Vacia);
        SET Par_Piso				:= REPLACE(Par_Piso,Car_Interroga,Cadena_Vacia);
        SET Par_PrimeraEntreCalle	:= REPLACE(Par_PrimeraEntreCalle,Car_Interroga,Cadena_Vacia);

        SET Par_SegundaEntreCalle	:= REPLACE(Par_SegundaEntreCalle,Car_Interroga,Cadena_Vacia);
        SET Par_Oficial				:= REPLACE(Par_Oficial,Car_Interroga,Cadena_Vacia);
        SET Par_Fiscal				:= REPLACE(Par_Fiscal,Car_Interroga,Cadena_Vacia);
		SET Var_EjecutaCierre 		:= (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

		-- Validamos que no se este ejecutando el cierre de dia
		IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=Salida_SI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS ( SELECT TipoDireccionID
								FROM TIPOSDIRECCION
                                WHERE TipoDireccionID = Par_TipoDireccionID ) THEN
				SET	Par_NumErr 			:=  20;
				SET	Par_ErrMen 			:= CONCAT('El Tipo de Direccion no Existe');
				SET Var_Control			:= 'tipoDireccionID';
                LEAVE ManejoErrores;

		END IF;

		IF NOT EXISTS ( SELECT EstadoID
							FROM ESTADOSREPUB
                            WHERE EstadoID=Par_EstadoID) THEN
				SET	Par_NumErr 			:=  21;
				SET	Par_ErrMen 			:= CONCAT('El Estado no Existe');
				SET Var_Control			:= 'estadoID';
                LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS ( SELECT MunicipioID
							FROM MUNICIPIOSREPUB
                            WHERE EstadoID=Par_EstadoID
                            AND MunicipioID=Par_MunicipioID) THEN
				SET	Par_NumErr 			:=  22;
				SET	Par_ErrMen 			:= CONCAT('El Municipio no Existe');
				SET Var_Control			:= 'municipioID';
                LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS ( SELECT LocalidadID
							FROM LOCALIDADREPUB
                            WHERE EstadoID=Par_EstadoID
                            AND MunicipioID=Par_MunicipioID
                            AND LocalidadID = Par_LocalidadID) THEN
				SET	Par_NumErr 			:=  23;
				SET	Par_ErrMen 			:= CONCAT('La Localidad no Existe');
				SET Var_Control			:= 'localidadID';
                LEAVE ManejoErrores;
		END IF;

		IF (Par_LocalidadID = Loc_NoCatalogada) THEN
			SELECT LocalidadID INTO Par_LocalidadID
			FROM LOCALIDADREPUB
			WHERE EstadoID = Par_EstadoID
			AND MunicipioID = Par_MunicipioID LIMIT 1;

			SET Par_LocalidadID := IFNULL(Par_LocalidadID, Entero_Cero);
		END IF;

        IF NOT EXISTS ( SELECT ColoniaID
							FROM COLONIASREPUB
                            WHERE EstadoID=Par_EstadoID
                            AND MunicipioID=Par_MunicipioID
                            AND ColoniaID = Par_ColoniaID) THEN
				SET	Par_NumErr 			:=  24;
				SET	Par_ErrMen 			:= CONCAT('La Colonia no Existe');
				SET Var_Control			:= 'coloniaID';
                LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT UsuarioID
						FROM USUARIOS
                        WHERE UsuarioID = Aud_Usuario) THEN
			SET Par_NumErr  := 26;
			SET Par_ErrMen  := CONCAT('El usuario de Auditoria no existe');
			SET Var_Control := 'usuarioID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS(SELECT SucursalID
						FROM SUCURSALES
                        WHERE SucursalID = Aud_Sucursal) THEN
			SET Par_NumErr  := 27;
			SET Par_ErrMen  := CONCAT('La Sucursal de Auditoria no existe');
			SET Var_Control := 'sucursalID';
			LEAVE ManejoErrores;
		END IF;

		SELECT 	Asentamiento, CodigoPostal
			INTO 	Var_NombreColonia, Var_CP
			FROM	COLONIASREPUB
			WHERE 	EstadoID =  Par_EstadoID
			AND 	MunicipioID = Par_MunicipioID
			AND 	ColoniaID = Par_ColoniaID;

		SET Var_Lote			:= Cadena_Vacia;
		SET Var_Manzana			:= Cadena_Vacia;
        SET Var_Descripcion 	:= Cadena_Vacia;


		SELECT 	Latitud, 		Longitud
			INTO   	Var_Latitud, 	Var_Longitud
			FROM 	DIRECCLIENTE
			WHERE 	ClienteID 	= Par_ClienteID
			AND 	DireccionID = Par_DireccionID;

		SET Var_Latitud 	:= IFNULL(Var_Latitud,Cadena_Vacia);
		SET Var_Longitud 	:= IFNULL(Var_Longitud,Cadena_Vacia);

		CALL `DIRECCIONCTEMOD`( Par_ClienteID,		Par_DireccionID,		Par_TipoDireccionID,	Par_EstadoID,			Par_MunicipioID	,
								Par_LocalidadID,	Par_ColoniaID,			Var_NombreColonia,		Par_Calle,				Par_NumeroCasa,
								Par_NumInterior,	Par_Piso,				Par_PrimeraEntreCalle,	Par_SegundaEntreCalle,	Var_CP,
								Var_Descripcion,	Var_Latitud,			Var_Longitud,			Par_Oficial,			Par_Fiscal,
								Var_Lote,			Var_Manzana,			Salida_NO,				Par_NumErr,				Par_ErrMen,
                                Var_DirectID,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
                                Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;

		SET	Par_NumErr 	:=  Entero_Cero;
		SET	Par_ErrMen 	:= CONCAT('Direccion Modificada Exitosamente');
        SET Var_Control	:= 'direccionID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr      AS NumErr,
				Par_ErrMen      AS ErrMen,
				Var_Control		AS Control;
	END IF;

END TerminaStore$$