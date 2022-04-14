-- Creacion del Proceso USUARIOSERVICIOREMESASWSPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS `USUARIOSERVICIOREMESASWSPRO`;

DELIMITER $$

CREATE PROCEDURE `USUARIOSERVICIOREMESASWSPRO`(
-- =====================================================================================
-- ------- STORED DE USUARIOS DE SERVICIO DE REMESAS POR WS ---------
-- =====================================================================================
	Par_RemesaWSID				BIGINT(20),			-- ID Consecutivo de la remesa
	INOUT Par_UsuarioServicioID	INT(11),			-- Identificador del Usuario de Servicio

    Par_Salida    				CHAR(1),			-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 			INT(11),			-- Parametro de salida numero de error
    INOUT Par_ErrMen  			VARCHAR(400),		-- Parametro de salida mensaje de error

    Par_EmpresaID       		INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         		INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     		DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     		VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      		VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        		INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo			VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         	VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema		DATE;				-- Fecha de sistema
	DECLARE Var_ClienteID			INT(11);			-- Indica el cliente que recibira el pago de la remesa.
	DECLARE	Var_TipoPersona			CHAR(1);			-- Indica el tipo de persona  Fisica(F) , Fisica con Actividad Empresarial(A) y Moral (M) para el cliente o usuario

    DECLARE	Var_CURP				CHAR(18);			-- Indica la clave CURP del cliente o usuario
	DECLARE	Var_RFC					CHAR(13);			-- Indica el RFC del cliente o usuario
	DECLARE Var_ExisteUsuario		INT(11);			-- Valida si existe el Usuario de Servicio
	DECLARE	Var_NivelRiesgo			CHAR(1);			-- Nivel de Riesgo del Usuario de Servicio: B.- Bajo M.- Medio A.- Alto
	DECLARE Var_FechaNacimiento		DATE;				-- Indica la Fecha de nacimiento del cliente o usuario formato valido (aaaa-MM-dd)

	DECLARE Var_Nacionalidad		CHAR(1);			-- Indica la Nacionalidad del cliente o usuario N.- Nacional, E.- Extranjero
	DECLARE	Var_PaisID				INT(11);			-- Indica el Pais de Nacimiento del cliente o usuario este valor debe existir en el catalogo del PAISES del SAFI
	DECLARE	Var_EstadoID			INT(11);			-- Indica la Entidad Federativa del cliente o usuario este valor debe existir en el catalogo de ESTADOS del SAFI
	DECLARE	Var_Genero				CHAR(1);			-- Indica el genero del cliente o usuario valores validos M (Masculino) F(Femenino)
	DECLARE Var_RazonSocial			VARCHAR(150);		-- Indica la Razon social del cliente o usuario

    DECLARE Var_TipoSociedadID 		INT(11);			-- Tipo de Sociedad, tiene llave foranea a la tabla  TIPOSOCIEDAD, para personas Morales
	DECLARE	Var_FechaConstitucion	DATE;				-- Indica la fecha de constitucion de la persona moral formato valido (aaaa-MM-dd)
	DECLARE Var_OcupacionID	 		INT(5);				-- Profesión del cliente
	DECLARE	Var_Email				VARCHAR(50);		-- Indica el correo electronico del cliente o usuario
	DECLARE	Var_NumTelefonico		VARCHAR(20);		-- Indica el telefono del beneficiario

    DECLARE Var_PaisResi        	INT(11);			-- Pais Residencia
    DECLARE Var_TelefonoCelular		VARCHAR(20);		-- Indica el telefono celular
	DECLARE Var_ExtTelefono			VARCHAR(7);			-- Numero de extension del telefono
	DECLARE Var_TipoDirecID     	INT(11);			-- Tipo de Direccion
    DECLARE	Var_TipoIdentiID		INT(11);			-- Indica el ID del tipo de identificacion

	DECLARE	Var_FolioIdentific		VARCHAR(45);		-- Indica el numero de identificacion
	DECLARE Var_ExisteCheckList		INT(11);			-- Valida si existe el CheckList de Remesas del Usuario Servicio
	DECLARE Var_UsuarioServicioID	INT(11);			-- Identificador del Usuario de Servicio
	DECLARE Var_ExisteCtoUsuario	INT(11);			-- Valida si existe el Conocimiento de Usuario de Servicio
	DECLARE Var_NombreCompleto		VARCHAR(200);		-- Indica el nombre completo del cliente o usuario

	DECLARE Var_NomGrupo			VARCHAR(100);		-- Almacena el nombre del Grupo
	DECLARE	Var_GiroMercantil		VARCHAR(200);		-- Indica el giro mercantil solo aplica para personas morales
	DECLARE	Var_Monto				DECIMAL(14,2);		-- Indica el monto a pagar
	DECLARE Var_IngAproxMes			VARCHAR(10);		-- Almacena el valor del Ingreso Aproximado por Mes
	DECLARE	Var_RemitenteID			INT(11);			-- Indica el Numero del Remitente

	DECLARE Var_NombreCompletoRemit	VARCHAR(200);		-- Indica el nombre de la persona que envia el pago.
	DECLARE Var_TipoIdentiIDRemit	INT(11);			-- Indica el tipo de identificacion utilizada para el envio de la remesa
	DECLARE Var_FolioIdentificRemit	BIGINT(20);			-- Indica el numero de indentificador del remitente
	DECLARE Var_CurpRemitente		CHAR(18);			-- Curp del remitente
	DECLARE Var_RfcRemitente		CHAR(13);			-- Indica RFC del remitente

	DECLARE Var_NombreRemite		VARCHAR(200);		-- Valida si existe el Nombre del Remitente
	DECLARE Var_CURPRemite			CHAR(18);			-- Valida si existe la CURP del Remitente
	DECLARE Var_RFCRemite			CHAR(13);			-- Valida si existe el RFC del Remitente
	DECLARE Var_UsuarioServID 		INT(11);			-- Numero del Usuario de Servicio
	DECLARE Var_UsuarioSerArchiID	INT(11);			-- Almacena el Identificador de la tabla USUARIOSERARCHIVO

	DECLARE Var_ConsecutivoID		INT(11);   			-- Variable consecutivo
	DECLARE Var_NumRegistros		INT(11);			-- Almacena el Numero de Registros
	DECLARE Var_Contador			INT(11);			-- Contador
	DECLARE Var_TipoDocumentoID		INT(11);			-- Identificador de Tipo de Documento
	DECLARE Var_Recurso				VARCHAR(1000);		-- Indica el Documento a cargar

	DECLARE Var_Extension			VARCHAR(50);		-- Extension del Archivo digitalizado
    DECLARE Var_PrimerNombre       	VARCHAR(50);		-- Almacena el primer Nombre del Usuario
	DECLARE Var_SegundoNombre      	VARCHAR(50);		-- Almacena el Segundo Nombre del Usuario
	DECLARE Var_TercerNombre       	VARCHAR(50);		-- Almacena el Tercer Nombre del Usuario
	DECLARE Var_ApellidoPaterno	    VARCHAR(50);		-- Almacena el Apellido Paterno

	DECLARE Var_ApellidoMaterno	    VARCHAR(50);		-- Almacena el Apellido Materno
	DECLARE Var_DirCalle			VARCHAR(500);		-- Almacena la calle del detalle de la direccion
	DECLARE Var_DirNumero			INT(11);			-- Almacena el numero del domicilio
	DECLARE Var_DirColoniaID		INT(11);			-- Almacena la colonia del domicilio
	DECLARE Var_DirMunicipioID		INT(11);			-- Almacena el municipio del domicilio

    DECLARE Var_DirCiudadID			INT(11);			-- Almacena la ciudad del domicilio
	DECLARE Var_DirEstadoID			INT(11);			-- Almacena el estado
	DECLARE Var_DirCodigoPostal		CHAR(5);			-- Almacena el codigo postal
	DECLARE Var_DirPaisID			INT(11);			-- Almacena el pais
	DECLARE	Var_DirCompleta			VARCHAR(1000);		-- Almacena la direccion completa

    DECLARE	Var_NomColonia			VARCHAR(200);		-- Almacena el nombre de la colonia
	DECLARE	Var_NomMunicipio		VARCHAR(200);		-- Almacena el nombre del municipio
	DECLARE	Var_NomEstado			VARCHAR(200);		-- Almacena el nombre del estado
	DECLARE Var_ExisteTipoDocumento	INT(11);			-- Valida si existe el Tipo de Documento del Usuario Servicio

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante Cadena Vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha Vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero Cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal Cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de Salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de Salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no
    DECLARE PersonaFisica		CHAR(1);			-- Tipo Persona: FISICA

    DECLARE PersonaFisicaActEmp	CHAR(1); 			-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL
    DECLARE PersonaMoral		CHAR(1);			-- Tipo Persona: MORAL
    DECLARE IngAproxMes1		VARCHAR(10);		-- Ingreso Aproximado por Mes Menos de 20,000.00
    DECLARE IngAproxMes2		VARCHAR(10);		-- Ingreso Aproximado por Mes de 20,001.00 a 50,000.00
    DECLARE IngAproxMes3		VARCHAR(10);		-- Ingreso Aproximado por Mes de 50,001.00 a 100,000.00

    DECLARE IngAproxMes4		VARCHAR(10);		-- Ingreso Aproximado por Mes Mayor a 100,000.00
	DECLARE DefaultPais 		INT(11);			-- Pais de Nacimiento del Remitente, corresponde a la tabla PAISES
    DECLARE DefaultOcupacion	INT(11);			-- Ocupacion del Remitente, corrresponde a la tabla OCUPACIONES
	DECLARE DefaultActividadBMX	VARCHAR(15);		-- Actividad Principal del Remitente, segun Banco de Mexico, corresponde a la tabla ACTIVIDADESBMX
	DECLARE DefaultActividadINEGI	INT(11);		-- Actividad Principal del Remitente, segun INEGI, corresponde a la tabla ACTIVIDADESINEGI

	DECLARE DefaultSector		INT(11);			-- Sector General, corresponde a la tabla SECTORES
	DECLARE DescObservacion		VARCHAR(200);		-- Comentario por default para el registro de Expediente del Usuario de Servicio

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';
    SET PersonaFisica			:= 'F';

    SET PersonaFisicaActEmp		:= 'A';
    SET PersonaMoral			:= 'M';
    SET IngAproxMes1			:= 'Ing1';
    SET IngAproxMes2			:= 'Ing2';
    SET IngAproxMes3			:= 'Ing3';

    SET IngAproxMes4			:= 'Ing4';
    SET DefaultPais				:= 999;
    SET DefaultOcupacion		:= 9999;
    SET DefaultActividadBMX		:= '9999999999';
    SET DefaultActividadINEGI	:= 99999;

    SET DefaultSector			:= 998;
    SET DescObservacion			:= 'DOCUMENTO DEL USUARIO DE SERVICIO ENVIADO POR WS';

    -- ASIGNACION DE VARIABLES
	SET Var_TipoSociedadID 	:= 6;
	SET Var_OcupacionID		:= Entero_Cero;
	SET Var_PaisResi		:=	999;
	SET Var_TelefonoCelular	:= Cadena_Vacia;
	SET Var_ExtTelefono		:= Cadena_Vacia;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen = LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-USUARIOSERVICIOREMESASWSPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Aud_FechaActual 	:= NOW();
        SET Aud_ProgramaID		:= 'USUARIOSERVICIOREMESASWSPRO';
        SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

        -- SE VALIDA SI ES CLIENTE
        SET Var_ClienteID	:= (SELECT ClienteID FROM REMESASWS WHERE RemesaWSID = Par_RemesaWSID);
        SET Var_ClienteID	:= IFNULL(Var_ClienteID,Entero_Cero);

        -- SI EL CLIENTE ES CERO ENTONCES ES UN USUARIO DE SERVICIO
		IF(Var_ClienteID = Entero_Cero)THEN
			-- SE OBTIENEN LOS DATOS NECESARIOS DEL USUARIO DE SERVICIO
			SELECT 	TipoPersona,			CURP,				RFC,				NivelRiesgo,			FechaNacimiento,
					Nacionalidad,			PaisID,				EstadoID,			Genero,					RazonSocial,
                    FechaConstitucion,		Email,				NumTelefonico,		TipoIdentiID,			FolioIdentific,
                    NombreCompleto,			GiroMercantil,		Monto,				NombreCompletoRemit,	TipoIdentiIDRemit,
                    FolioIdentificRemit,	CurpRemitente,		RfcRemitente,		PrimerNombre,			SegundoNombre,
                    TercerNombre,			ApellidoPaterno,	ApellidoMaterno
            INTO   	Var_TipoPersona,		Var_CURP,			Var_RFC,			Var_NivelRiesgo,		Var_FechaNacimiento,
					Var_Nacionalidad,		Var_PaisID,			Var_EstadoID,		Var_Genero,				Var_RazonSocial,
                    Var_FechaConstitucion,	Var_Email,			Var_NumTelefonico,	Var_TipoIdentiID,		Var_FolioIdentific,
                    Var_NombreCompleto,		Var_GiroMercantil,	Var_Monto,			Var_NombreCompletoRemit,Var_TipoIdentiIDRemit,
                    Var_FolioIdentificRemit,Var_CurpRemitente,	Var_RfcRemitente,	Var_PrimerNombre,		Var_SegundoNombre,
                    Var_TercerNombre,		Var_ApellidoPaterno,Var_ApellidoMaterno
            FROM REMESASWS
            WHERE RemesaWSID = Par_RemesaWSID;

			-- SI EL TIPO DE PERSONA ES FISICA O FISICA CON ACTIVIDAD EMPRESARIAL SE VALIDA SI EL USUARIO ESTA REGISTRADO VALIDANDO LA CURP
            IF(Var_TipoPersona IN(PersonaFisica,PersonaFisicaActEmp))THEN
				SET Var_ExisteUsuario	:= (SELECT COUNT(CURP) FROM  USUARIOSERVICIO WHERE TipoPersona IN (PersonaFisica,PersonaFisicaActEmp) AND CURP = Var_CURP);
				SET Var_UsuarioServID	:= (SELECT UsuarioServicioID FROM USUARIOSERVICIO WHERE TipoPersona IN (PersonaFisica,PersonaFisicaActEmp) AND CURP = Var_CURP LIMIT 1);
				SET Var_UsuarioServID   := IFNULL(Var_UsuarioServID,Entero_Cero);
				SET Var_NomGrupo		:= (SUBSTRING(Var_NombreCompleto,1,100));
				SET Var_TipoDirecID		:= 1;

                -- SE OBTIENE LA DIRECCION DEL USUARIO
				SELECT 	Calle, 				Numero,					ColoniaID,				MunicipioID, 			CiudadID,
						EstadoID, 			CodigoPostal, 			PaisID
				INTO 	Var_DirCalle,		Var_DirNumero,			Var_DirColoniaID,		Var_DirMunicipioID,		Var_DirCiudadID,
						Var_DirEstadoID,	Var_DirCodigoPostal,	Var_DirPaisID
				FROM DETALLEDIRECREMESAWS
                WHERE RemesaWSID = Par_RemesaWSID;
            END IF;

            -- SI EL TIPO DE PERSONA ES MORAL SE VALIDA SI EL USUARIO ESTA REGISTRADO VALIDANDO EL RFC
            IF(Var_TipoPersona = PersonaMoral)THEN
				SET Var_ExisteUsuario	:= (SELECT COUNT(RFCOficial) FROM USUARIOSERVICIO WHERE TipoPersona = PersonaMoral AND RFCOficial = Var_RFC);
				SET Var_UsuarioServID	:= (SELECT UsuarioServicioID FROM USUARIOSERVICIO WHERE TipoPersona = PersonaMoral AND RFCOficial = Var_RFC LIMIT 1);
				SET Var_UsuarioServID   := IFNULL(Var_UsuarioServID,Entero_Cero);
				SET Var_NomGrupo		:= (SUBSTRING(Var_RazonSocial,1,100));
				SET Var_TipoDirecID		:= 2;

                -- SE OBTIENE LA DIRECCION FISCAL DEL USUARIO
                SELECT 	Calle, 				Numero,					ColoniaID,				MunicipioID, 			CiudadID,
						EstadoID, 			CodigoPostal, 			PaisID
				INTO 	Var_DirCalle,		Var_DirNumero,			Var_DirColoniaID,		Var_DirMunicipioID,		Var_DirCiudadID,
						Var_DirEstadoID,	Var_DirCodigoPostal,	Var_DirPaisID
				FROM DETDIRECFISCALREMESASWS
                WHERE RemesaWSID = Par_RemesaWSID;
            END IF;

            -- SE SETEAN VALORES NULOS
            SET Var_DirCalle		:= IFNULL(Var_DirCalle,Cadena_Vacia);
			SET Var_DirNumero		:= IFNULL(Var_DirNumero,Entero_Cero);
            SET Var_DirColoniaID	:= IFNULL(Var_DirColoniaID,Entero_Cero);
			SET Var_DirMunicipioID	:= IFNULL(Var_DirMunicipioID,Entero_Cero);
            SET Var_DirCiudadID		:= IFNULL(Var_DirCiudadID,Entero_Cero);
            SET Var_DirEstadoID		:= IFNULL(Var_DirEstadoID,Entero_Cero);
            SET Var_DirCodigoPostal	:= IFNULL(Var_DirCodigoPostal,Cadena_Vacia);
            SET Var_DirPaisID		:= IFNULL(Var_DirPaisID,Entero_Cero);

            -- SI NO EXISTE EL USUARIO DE SERVICIO
			IF(Var_ExisteUsuario = Entero_Cero)THEN

				SET Var_PrimerNombre    := RTRIM(LTRIM(IFNULL(Var_PrimerNombre, Cadena_Vacia)));
				SET Var_SegundoNombre   := RTRIM(LTRIM(IFNULL(Var_SegundoNombre, Cadena_Vacia)));
				SET Var_TercerNombre    := RTRIM(LTRIM(IFNULL(Var_TercerNombre, Cadena_Vacia)));
				SET Var_ApellidoPaterno	:= RTRIM(LTRIM(IFNULL(Var_ApellidoPaterno, Cadena_Vacia)));
				SET Var_ApellidoMaterno	:= RTRIM(LTRIM(IFNULL(Var_ApellidoMaterno, Cadena_Vacia)));

				SET Var_PrimerNombre	:= UPPER(Var_PrimerNombre);
				SET Var_SegundoNombre	:= UPPER(Var_SegundoNombre);
				SET Var_TercerNombre	:= UPPER(Var_TercerNombre);
				SET Var_ApellidoPaterno	:= UPPER(Var_ApellidoPaterno);
				SET Var_ApellidoMaterno	:= UPPER(Var_ApellidoMaterno);

				IF(Var_TipoPersona <> PersonaMoral)THEN
					SET Var_NombreCompleto :=IFNULL(Var_NombreCompleto,Cadena_Vacia);
					IF(Var_NombreCompleto = Cadena_Vacia)THEN
						SET Var_NombreCompleto 	:= FNGENNOMBRECOMPLETO(Var_PrimerNombre, Var_SegundoNombre,Var_TercerNombre,Var_ApellidoPaterno,Var_ApellidoMaterno);
					END IF;
				END IF;

				SET	Var_RFC				:= UPPER(Var_RFC);
				SET	Var_CURP			:= UPPER(Var_CURP);
				SET Var_DirCalle		:= UPPER(Var_DirCalle);
				SET Var_FolioIdentific	:= UPPER(Var_FolioIdentific);

                -- SE OBTIENE EL NOMBRE DEL ESTADO
                SELECT Nombre INTO Var_NomEstado
				FROM ESTADOSREPUB
				WHERE EstadoID = Var_DirEstadoID;

                -- SE OBTIENE EL NOMBRE DEL MUNICIPIO
				SELECT Nombre INTO Var_NomMunicipio
				FROM MUNICIPIOSREPUB
				WHERE EstadoID = Var_DirEstadoID
				AND MunicipioID = Var_DirMunicipioID;

                -- SE OBTIENE EL NOMBRE DE LA COLONIA
				SELECT Asentamiento INTO Var_NomColonia
				FROM COLONIASREPUB
				WHERE EstadoID = Var_DirEstadoID
				AND MunicipioID = Var_DirMunicipioID
				AND ColoniaID = Var_DirColoniaID
				LIMIT 1;

                IF(Var_DirCalle != Cadena_Vacia) THEN
					SET Var_DirCompleta := Var_DirCalle;
				END IF;

				IF(Var_DirNumero != Entero_Cero) THEN
					SET Var_DirCompleta := CONCAT(Var_DirCompleta,", No. ",Var_DirNumero);
				END IF;

				SET Var_DirCompleta := CONCAT(Var_DirCompleta,", COL. ",Var_NomColonia,", C.P ",Var_DirCodigoPostal,", ",Var_NomMunicipio,", ",Var_NomEstado);
                SET Var_DirCompleta	:= (SUBSTRING(Var_DirCompleta,1,500));

                -- SE OBTIENE EL NUMERO CONSECUTIVO DEL USUARIO DE SERVICIO
				SET Par_UsuarioServicioID := (SELECT IFNULL(MAX(UsuarioServicioID),Entero_Cero) + 1 FROM USUARIOSERVICIO);

				-- SE REALIZA EL REGISTRO DEL USUARIO DE SERVICIO
                INSERT INTO USUARIOSERVICIO (
					UsuarioServicioID,			TipoPersona,				PrimerNombre,				SegundoNombre,				TercerNombre,
					ApellidoPaterno,			ApellidoMaterno,			FechaNacimiento,			Nacionalidad,				PaisNacimiento,
					EstadoNacimiento,			Sexo,						CURP,						RazonSocial,				TipoSociedadID,
					RFC,						RFCpm,						RFCOficial,					FEA,						FechaConstitucion,
					PaisRFC,					OcupacionID,				Correo,						TelefonoCelular,			Telefono,
					ExtTelefonoPart,			NombreCompleto,				SucursalOrigen,				PaisResidencia,				TipoDireccionID,
					EstadoID,					MunicipioID,				LocalidadID,				ColoniaID,					Calle,
					NumExterior,				NumInterior,				CP,							Piso,						Manzana,
					Lote,						DirCompleta,				TipoIdentiID,				NumIdenti,					FecExIden,
					FecVenIden,					DocEstanciaLegal,			DocExisLegal,				FechaVenEst,				NivelRiesgo,
					EmpresaID,					Usuario,					FechaActual,				DireccionIP,				ProgramaID,
					Sucursal,					NumTransaccion)
				VALUES(
					Par_UsuarioServicioID,		Var_TipoPersona,			Var_PrimerNombre,			Var_SegundoNombre,			Var_TercerNombre,
                    Var_ApellidoPaterno,		Var_ApellidoMaterno,		Var_FechaNacimiento,		Var_Nacionalidad,			Var_PaisID,
                    Var_EstadoID,				Var_Genero,					Var_CURP,					Var_RazonSocial,			Var_TipoSociedadID,
                    Var_RFC,					Var_RFC,					Var_RFC,					Cadena_Vacia,				Var_FechaConstitucion,
                    Var_PaisID,					Var_OcupacionID,			Var_Email,					Var_TelefonoCelular,		Var_NumTelefonico,
                    Var_ExtTelefono,			Var_NombreCompleto,			Aud_Sucursal,				Var_PaisID,					Var_TipoDirecID,
                    Var_DirEstadoID,			Var_DirMunicipioID,			Entero_Cero,				Var_DirColoniaID,			Var_DirCalle,
                    Var_DirNumero,				Cadena_Vacia,				Var_DirCodigoPostal,		Cadena_Vacia,				Cadena_Vacia,
                    Cadena_Vacia,				Var_DirCompleta,			Var_TipoIdentiID,			Var_FolioIdentific,			Fecha_Vacia,
                    Fecha_Vacia,				Cadena_Vacia,				Cadena_Vacia,				Fecha_Vacia,				Var_NivelRiesgo,
                    Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
                    Aud_Sucursal,				Aud_NumTransaccion);

				SET Var_IngAproxMes	:= IngAproxMes1;

				IF(Var_Monto >= 20001.00 AND Var_Monto <= 50000.00)THEN
					SET Var_IngAproxMes	:= IngAproxMes2;
				END IF;

				IF(Var_Monto >= 50001.00 AND Var_Monto <= 100000.00)THEN
					SET Var_IngAproxMes	:= IngAproxMes3;
				END IF;

				IF(Var_Monto > 100000.00)THEN
					SET Var_IngAproxMes	:= IngAproxMes4;
				END IF;

				-- SE REALIZA EL REGISTRO DEL CONOCIMIENTO DEL USUARIO
				INSERT INTO CONOCIMIENTOUSUSERV (
					UsuarioServicioID,		NombreGrupo,            RFC,               		Participacion,   		Nacionalidad,
					RazonSocial,            Giro,                   AniosOperacion,    		AniosGiro,       		PEPs,
					FuncionID,              FechaNombramiento,      PorcentajeAcciones,		PeriodoCargo,    		MontoAcciones,
					ParentescoPEP,          NombreFamiliar,         APaternoFamiliar,  		AMaternoFamiliar,		NumeroEmpleados,
					ServiciosProductos,     CoberturaGeografica,    EstadosPresencia,  		ImporteVentas,   		Activos,

					Pasivos,                CapitalContable,        CapitalNeto,            Importa,        		DolaresImporta,
					PaisesImporta1,         PaisesImporta2,         PaisesImporta3,         Exporta,        		DolaresExporta,
					PaisesExporta1,         PaisesExporta2,         PaisesExporta3,         TiposClientes,  		InstrMonetarios,
					NombreRefCom1,          NoCuentaRefCom1,        DireccionRefCom1,       TelefonoRefCom1,		ExtTelefonoRefCom1,
					NombreRefCom2,          NoCuentaRefCom2,        DireccionRefCom2,       TelefonoRefCom2,		ExtTelefonoRefCom2,

					BancoRefBanc1,         	TipoCuentaRefBanc1, 	NoCuentaRefBanc1,      	SucursalRefBanc1,   	NoTarjetaRefBanc1,
					InstitucionRefBanc1,   	CredOtraEntRefBanc1,	InstitucionEntRefBanc1,	BancoRefBanc2,      	TipoCuentaRefBanc2,
					NoCuentaRefBanc2,      	SucursalRefBanc2,   	NoTarjetaRefBanc2,     	InstitucionRefBanc2,	CredOtraEntRefBanc2,
					InstitucionEntRefBanc2,	NombreRefPers1,     	DomicilioRefPers1,     	TelefonoRefPers1,   	ExtTelefonoRefPers1,
					TipoRelacionRefPers1,  	NombreRefPers2,     	DomicilioRefPers2,     	TelefonoRefPers2,   	ExtTelefonoRefPers2,

					TipoRelacionRefPers2,	PreguntaUsuario1, 		RespuestaUsuario1,		PreguntaUsuario2, 		RespuestaUsuario2,
					PreguntaUsuario3,    	RespuestaUsuario3,		PreguntaUsuario4, 		RespuestaUsuario4,		PrincipalFuenteIng,
					IngAproxPorMes,      	EvaluaXMatriz,    		ComentarioNivel,  		EmpresaID,        		Usuario,
					FechaActual,         	DireccionIP,      		ProgramaID,       		Sucursal,         		NumTransaccion
				) VALUES (
					Par_UsuarioServicioID,	Var_NomGrupo,    		Var_RFC,    			Decimal_Cero,    		Cadena_Vacia,
					Var_RazonSocial,    	Var_GiroMercantil,    	Entero_Cero,    		Entero_Cero,    		Cadena_Vacia,
					Entero_Cero,    		Fecha_Vacia,    		Decimal_Cero,    		Cadena_Vacia,    		Decimal_Cero,
					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Entero_Cero,
					Cadena_Vacia,    		Cadena_Vacia,    		Entero_Cero,    		Decimal_Cero,    		Decimal_Cero,

					Decimal_Cero,    		Decimal_Cero,    		Decimal_Cero,    		Cadena_Vacia,    		Cadena_Vacia,
					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,
					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,
					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,
					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,

					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,
					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,
					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,
					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,
					Entero_Cero,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,

					Entero_Cero,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,
					Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,    		Cadena_Vacia,
					Var_IngAproxMes,    	Cons_SI,    			Cadena_Vacia,    		Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
				);

				-- SE VALIDA SI YA EXISTE EL REMITENTE POR EL NOMBRE, RFC O CURP
				SET Var_NombreRemite	:= (SELECT NombreCompleto FROM REMITENTESUSUARIOSERV WHERE NombreCompleto = Var_NombreCompletoRemit LIMIT 1);

				IF(Var_CurpRemitente != Cadena_Vacia)THEN
					SET Var_CURPRemite	:= (SELECT CURP FROM REMITENTESUSUARIOSERV WHERE CURP = Var_CurpRemitente LIMIT 1);
				END IF;

				IF(Var_RfcRemitente != Cadena_Vacia)THEN
					SET Var_RFCRemite		:= (SELECT RFC FROM REMITENTESUSUARIOSERV WHERE RFC = Var_RfcRemitente LIMIT 1);
				END IF;

				SET Var_NombreRemite	:=IFNULL(Var_NombreRemite,Cadena_Vacia);
				SET Var_CURPRemite		:=IFNULL(Var_CURPRemite,Cadena_Vacia);
				SET Var_RFCRemite		:=IFNULL(Var_RFCRemite,Cadena_Vacia);

				-- SI NO EXISTE EL REMITENTE POR EL NOMBRE, RFC O CURP SE REALIZA EL REGISTRO DEL REMITENTE
				IF(Var_NombreRemite = Cadena_Vacia AND Var_CURPRemite = Cadena_Vacia AND Var_RFCRemite = Cadena_Vacia)THEN
					-- SE OBTIENE EL NUMERO CONSECUTIVO DEL REMITENTE DEL USUARIO DE SERVICIO
					SET Var_RemitenteID 	:= (SELECT IFNULL(MAX(RemitenteID),Entero_Cero) + 1 FROM REMITENTESUSUARIOSERV WHERE UsuarioServicioID = Par_UsuarioServicioID);

					INSERT INTO REMITENTESUSUARIOSERV(
						UsuarioServicioID,		Fecha,					RemitenteID,			Titulo,					TipoPersona,
						NombreCompleto,			FechaNacimiento,		PaisNacimiento,			EdoNacimiento,			EstadoCivil,
						Sexo,					CURP,					RFC,					FEA,					PaisFEA,
						OcupacionID,			Puesto,					SectorID,				ActividadBMXID,			ActividadINEGIID,
						SectorEcoID,			TipoIdentiID,			NumIdentific,			FecExIden,				FecVenIden,
						TelefonoCasa,			ExtTelefonoPart,		TelefonoCelular,		Correo,					Domicilio,
						Nacionalidad,			PaisResidencia,			EmpresaID,				Usuario,				FechaActual,
						DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
					VALUES(
						Par_UsuarioServicioID,	Var_FechaSistema,		Var_RemitenteID,		Cadena_Vacia,			Cadena_Vacia,
						Var_NombreCompletoRemit,Fecha_Vacia,			DefaultPais,			Entero_Cero,			Cadena_Vacia,
						Cadena_Vacia,			Var_CurpRemitente,		Var_RfcRemitente,		Cadena_Vacia,			DefaultPais,
						DefaultOcupacion,		Cadena_Vacia,			DefaultSector,			DefaultActividadBMX,	DefaultActividadINEGI,
						Entero_Cero,			Var_TipoIdentiIDRemit,	Var_FolioIdentificRemit,Fecha_Vacia,			Fecha_Vacia,
						Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
						Cadena_Vacia,			DefaultPais,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
				END IF; -- FIN SI NO EXISTE EL REMITENTE POR EL NOMBRE, RFC O CURP SE REALIZA EL REGISTRO DEL REMITENTE

				-- SE OBTIENE EL CHECK LIST DE LA REMESA
				SET Var_ExisteCheckList	:=(SELECT COUNT(RemesaWSID) FROM CHECKLISTREMESASWS WHERE RemesaWSID = Par_RemesaWSID AND NumeroID > Entero_Cero);
				-- SI EL CHECK LIST DE LA REMESA ES MAYOR A CERO
				IF(Var_ExisteCheckList > Entero_Cero)THEN

					-- SE ELIMINA LA TABLA TEMPORAL
					DELETE FROM TMPCHECKLISTREMESASWS;
					SET @Var_ConsecutivoID := 0;

					-- SE OBTIENE INFORMACION DE CHECK LIST DE LA REMESA
					INSERT INTO TMPCHECKLISTREMESASWS(
						ConsecutivoID,		UsuarioServicioID,		TipoDocumentoID,		Recurso,			Extension,
						EmpresaID,			Usuario,				FechaActual,			DireccionIP,	    ProgramaID,
						Sucursal,			NumTransaccion)
					SELECT
						@Var_ConsecutivoID:=@Var_ConsecutivoID+1,	Par_UsuarioServicioID,	NumeroID,			Archivo,				CONCAT('.',SUBSTRING_INDEX(Archivo, '.', -1)),
						Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion
					FROM CHECKLISTREMESASWS
					WHERE RemesaWSID = Par_RemesaWSID
					AND NumeroID > Entero_Cero;

					-- SE OBTIENE EL NUMERO DE REGISTROS
					SET Var_NumRegistros := (SELECT COUNT(TipoDocumentoID) FROM TMPCHECKLISTREMESASWS);
					SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

					-- SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO
					IF(Var_NumRegistros > Entero_Cero)THEN
						-- SE INICIALIZA EL CONTADOR
						SET Var_Contador := 1;

						-- SE REALIZA EL REGISTRO DEL EXPEDIENTE DEL USUARIO EN LA TABLA USUARIOSERARCHIVO
						WHILE(Var_Contador <= Var_NumRegistros) DO

							SELECT	TipoDocumentoID,			Recurso,		Extension
							INTO 	Var_TipoDocumentoID,		Var_Recurso,	Var_Extension
							FROM TMPCHECKLISTREMESASWS
							WHERE ConsecutivoID = Var_Contador
							AND UsuarioServicioID = Par_UsuarioServicioID;

							SET Var_Recurso 	:= IFNULL(Var_Recurso,Cadena_Vacia);
							SET Var_Extension 	:= IFNULL(Var_Extension,Cadena_Vacia);

							CALL USUARIOSERARCHIVOALT (
								Par_UsuarioServicioID,		Var_TipoDocumentoID,		DescObservacion, 	Var_Recurso,		Var_Extension,
								Salida_NO,					Par_NumErr,					Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
								Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							SET Var_Contador := Var_Contador + 1;

						END WHILE; -- FIN DEL WHILE
					END IF; -- FIN SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO
				END IF; -- FIN SI EL CHECK LIST DE LA REMESA ES MAYOR A CERO

                -- SE REALIZA LA DETECCION DE COINCIDENCIAS POR RFC Y CURP PARA EL USUARIO DE SERVICIO REGISTRADO
                CALL COINCIDEREMESASUSUSERPRO (
					Par_UsuarioServicioID,		Var_TipoPersona,		Var_CURP,			Var_RFC,			Salida_NO,
                    Par_NumErr,					Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
                    Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

                IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF; -- FIN SI NO EXISTE EL USUARIO DE SERVICIO

			-- SI EXISTE EL USUARIO DE SERVICIO
			IF(Var_ExisteUsuario > Entero_Cero AND Var_UsuarioServID > Entero_Cero)THEN

				SET Par_UsuarioServicioID	:= Var_UsuarioServID;

				-- SE VALIDA SI YA EXISTE EL REMITENTE POR EL NOMBRE, RFC O CURP
				SET Var_NombreRemite	:= (SELECT NombreCompleto FROM REMITENTESUSUARIOSERV WHERE NombreCompleto = Var_NombreCompletoRemit LIMIT 1);

				IF(Var_CurpRemitente != Cadena_Vacia)THEN
					SET Var_CURPRemite	:= (SELECT CURP FROM REMITENTESUSUARIOSERV WHERE CURP = Var_CurpRemitente LIMIT 1);
				END IF;

				IF(Var_RfcRemitente != Cadena_Vacia)THEN
					SET Var_RFCRemite	:= (SELECT RFC FROM REMITENTESUSUARIOSERV WHERE RFC = Var_RfcRemitente LIMIT 1);
				END IF;

				SET Var_NombreRemite	:=IFNULL(Var_NombreRemite,Cadena_Vacia);
				SET Var_CURPRemite		:=IFNULL(Var_CURPRemite,Cadena_Vacia);
				SET Var_RFCRemite		:=IFNULL(Var_RFCRemite,Cadena_Vacia);

				-- SI NO EXISTE EL REMITENTE POR EL NOMBRE, RFC O CURP SE REALIZA EL REGISTRO DEL REMITENTE
				IF(Var_NombreRemite = Cadena_Vacia AND Var_CURPRemite = Cadena_Vacia AND Var_RFCRemite = Cadena_Vacia)THEN
					-- SE OBTIENE EL NUMERO CONSECUTIVO DEL REMITENTE DEL USUARIO DE SERVICIO
					SET Var_RemitenteID 	:= (SELECT IFNULL(MAX(RemitenteID),Entero_Cero) + 1 FROM REMITENTESUSUARIOSERV WHERE UsuarioServicioID = Par_UsuarioServicioID);

					-- SE REALIZA EL REGISTRO DEL REMITENTE
					INSERT INTO REMITENTESUSUARIOSERV(
						UsuarioServicioID,		Fecha,					RemitenteID,			Titulo,					TipoPersona,
						NombreCompleto,			FechaNacimiento,		PaisNacimiento,			EdoNacimiento,			EstadoCivil,
						Sexo,					CURP,					RFC,					FEA,					PaisFEA,
						OcupacionID,			Puesto,					SectorID,				ActividadBMXID,			ActividadINEGIID,
						SectorEcoID,			TipoIdentiID,			NumIdentific,			FecExIden,				FecVenIden,
						TelefonoCasa,			ExtTelefonoPart,		TelefonoCelular,		Correo,					Domicilio,
						Nacionalidad,			PaisResidencia,			EmpresaID,				Usuario,				FechaActual,
						DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
					VALUES(
						Par_UsuarioServicioID,	Var_FechaSistema,		Var_RemitenteID,		Cadena_Vacia,			Cadena_Vacia,
						Var_NombreCompletoRemit,Fecha_Vacia,			DefaultPais,			Entero_Cero,			Cadena_Vacia,
						Cadena_Vacia,			Var_CurpRemitente,		Var_RfcRemitente,		Cadena_Vacia,			DefaultPais,
						DefaultOcupacion,		Cadena_Vacia,			DefaultSector,			DefaultActividadBMX,	DefaultActividadINEGI,
						Entero_Cero,			Var_TipoIdentiIDRemit,	Var_FolioIdentificRemit,Fecha_Vacia,			Fecha_Vacia,
						Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
						Cadena_Vacia,			DefaultPais,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
				END IF; -- FIN SI NO EXISTE EL REMITENTE POR EL NOMBRE, RFC O CURP SE REALIZA EL REGISTRO DEL REMITENTE

				-- SE OBTIENE EL CHECK LIST DE LA REMESA
				SET Var_ExisteCheckList	:=(SELECT COUNT(RemesaWSID) FROM CHECKLISTREMESASWS WHERE RemesaWSID = Par_RemesaWSID AND NumeroID > Entero_Cero);

				-- SI EL CHECK LIST DE LA REMESA ES MAYOR A CERO
				IF(Var_ExisteCheckList > Entero_Cero)THEN
					-- SE ELIMINA LA TABLA TEMPORAL
					DELETE FROM TMPCHECKLISTREMESASWS;
					SET @Var_ConsecutivoID := 0;

					-- SE OBTIENE INFORMACION DE CHECK LIST DE LA REMESA
					INSERT INTO TMPCHECKLISTREMESASWS(
						ConsecutivoID,		UsuarioServicioID,		TipoDocumentoID,		Recurso,			Extension,
						EmpresaID,			Usuario,				FechaActual,			DireccionIP,	    ProgramaID,
						Sucursal,			NumTransaccion)
					SELECT
						@Var_ConsecutivoID:=@Var_ConsecutivoID+1,	Par_UsuarioServicioID,	NumeroID,			Archivo,				CONCAT('.',SUBSTRING_INDEX(Archivo, '.', -1)),
						Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion
					FROM CHECKLISTREMESASWS
					WHERE RemesaWSID = Par_RemesaWSID
					AND NumeroID > Entero_Cero;

					-- SE OBTIENE EL NUMERO DE REGISTROS
					SET Var_NumRegistros := (SELECT COUNT(TipoDocumentoID) FROM TMPCHECKLISTREMESASWS);
					SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

					-- SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO
					IF(Var_NumRegistros > Entero_Cero)THEN
						-- SE INICIALIZA EL CONTADOR
						SET Var_Contador := 1;

						-- SE REALIZA LA ACTUALIZACION DEL EXPEDIENTE DEL USUARIO EN LA TABLA USUARIOSERARCHIVO
						WHILE(Var_Contador <= Var_NumRegistros) DO
							SELECT	TipoDocumentoID,			Recurso,		Extension
							INTO 	Var_TipoDocumentoID,		Var_Recurso,	Var_Extension
							FROM TMPCHECKLISTREMESASWS
							WHERE ConsecutivoID = Var_Contador
							AND UsuarioServicioID = Par_UsuarioServicioID;

							SET Var_Recurso 	:= IFNULL(Var_Recurso,Cadena_Vacia);
							SET Var_Extension 	:= IFNULL(Var_Extension,Cadena_Vacia);

							-- SE VALIDA SI EL TIPO DE DOCUMENTO DEL USUARIO YA EXISTE
							SET Var_ExisteTipoDocumento	:=(SELECT COUNT(TipoDocumento) FROM USUARIOSERARCHIVO WHERE UsuarioServicioID = Par_UsuarioServicioID AND TipoDocumento = Var_TipoDocumentoID);

							IF(Var_ExisteTipoDocumento = Entero_Cero)THEN
								CALL USUARIOSERARCHIVOALT (
									Par_UsuarioServicioID,	Var_TipoDocumentoID,		DescObservacion, 	Var_Recurso,		Var_Extension,
									Salida_NO,				Par_NumErr,					Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
									Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;
							END IF;

							IF(Var_ExisteTipoDocumento > Entero_Cero)THEN
								CALL USUARIOSERARCHIVOACT (
									Par_UsuarioServicioID,	Var_TipoDocumentoID,		DescObservacion, 	Var_Recurso,		Var_Extension,
									Salida_NO,				Par_NumErr,					Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
									Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;
							END IF;

							SET Var_Contador := Var_Contador + 1;

						END WHILE; -- FIN DEL WHILE
					END IF; -- FIN SE VALIDA QUE EL NUMERO DE REGISTROS SEA MAYOR A CERO
				END IF; -- FIN SI EL CHECK LIST DE LA REMESA ES MAYOR A CERO
			END IF; -- FIN SI EXISTE EL USUARIO DE SERVICIO

			-- SE ACTUALIZA EL NUMERO DE USUARIO DE SERVICIO
			UPDATE REMESASWS
			SET UsuarioServicioID = Par_UsuarioServicioID
			WHERE RemesaWSID = Par_RemesaWSID;

		END IF; -- FIN SI EL CLIENTE ES CERO ENTONCES ES UN USUARIO DE SERVICIO

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Usuario de Servicio de Remesas Procesado Exitosamente.';
		SET Var_Control		:= Cadena_Vacia;
		SET Var_Consecutivo	:= Par_RemesaWSID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$