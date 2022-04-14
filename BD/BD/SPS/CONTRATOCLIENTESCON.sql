-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOCLIENTESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOCLIENTESCON`;
DELIMITER $$

CREATE PROCEDURE `CONTRATOCLIENTESCON`(
-- SP PARA CONSULTAR LOS DATOS DE LOS CLIENTES DIVIDIDOS POR TIPO DE REPORTE
	Par_ClienteID	BIGINT(20),			-- Numero de Cliente
	Par_NumCon		TINYINT UNSIGNED,	-- Numero de Consulta

	-- AUDITORIA GENERAL
    Aud_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
-- DECLARACION DE CONSTANTES
    DECLARE	Cadena_Vacia	CHAR(1);		-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;			-- Fecha vacia
	DECLARE	Entero_Cero		INT(11);		-- Entero en cero
    DECLARE	Decimal_Cero	DECIMAL(12,2);	-- Decimal en cero
    DECLARE NOENCONTRADO	VARCHAR(100);	-- Valor que indica que no existe

	DECLARE Con_SegA	INT(2);	-- CONSULTA DEL REPORTE RECA ANEXO A
    DECLARE Con_SegB	INT(2);	-- CONSULTA DEL REPORTE RECA ANEXO B
    DECLARE Con_SegC	INT(2);	-- CONSULTA DEL REPORTE RECA ANEXO C
    DECLARE Con_SegD	INT(2);	-- CONSULTA DEL REPORTE RECA CONTRATO APERTURA DE CREDITO AViO AGROPECUARIO
    DECLARE Con_SegE	INT(2);	-- CONSULTA DEL REPORTE RECA PRECEPTOS LEGALES

    DECLARE Con_SegF	INT(2);	-- CONSULTA DEL REPORTE RECA SOLICITUD DE CREDITO DE PERSONA FISICA
    DECLARE Con_SegG	INT(2);	-- CONSULTA DEL REPORTE RECA SOLICITUD DE CREDITO DE PERSONA MORAL
    DECLARE Con_SegH	INT(2);	-- CONSULTA DEL REPORTE AUTORIZACION DE CARGO AUTOMATICO
    DECLARE Con_SegI	INT(2);	-- CONSULTA DEL REPORTE CESION DE DERECHOS
    DECLARE Con_SegJ	INT(2);	-- CONSULTA DEL REPORTE DECLARATORIA DUD

    DECLARE Con_SegK	INT(2);	-- CONSULTA DEL REPORTE PAGARE PAGO UNICO INTERES MENSUALDUD
    DECLARE Con_SegL	INT(2);	-- CONSULTA DEL REPORTE PAGARE PAGO UNICO
    DECLARE Con_SegM	INT(2);	-- CONSULTA DEL REPORTE PAGOS ADELANTADOS OK

-- DECLARACION DE VARIABLES
    DECLARE TipoPer			CHAR(2);		-- Tipo Persona
    DECLARE Var_TipoPerDes	VARCHAR(50);	-- Descripcion del Tipo Persona
    DECLARE Fisica			VARCHAR(50);	-- Persona Fisica
    DECLARE Moral			VARCHAR(50);	-- Persona Moral
    DECLARE TipoPerF		CHAR(2);		-- Tipo de Persona Fisica

    DECLARE TipoPerM			CHAR(2);		-- Tipo de Persona Moral
    DECLARE Var_NomComp			VARCHAR(250);	-- Nombre Completo del Cliente
	DECLARE Var_ClienteID		BIGINT(20);		-- ID del CLiente

    -- numCon 6
    DECLARE Var_LugReg			VARCHAR(250);	-- Lugar de Registro del Cliente
    DECLARE Var_FolMerc			VARCHAR(250);	-- Folio Mercantil del Cliente
    DECLARE Var_EscPub			VARCHAR(250);	-- Escritura Publica del Cliente

    -- numCon 1
    DECLARE Var_EnvioEdoCta		CHAR(1);		-- Envios del Estado de Cuenta
    DECLARE Var_EnvioSucursal	CHAR(1);		-- Envio del Estado de Cuenta a la Sucursal NUEVO
    DECLARE Var_EnvioCorreo 	CHAR(1);		-- Envio del Estado de Cuenta por Correo NUEVO
    
    DECLARE Var_Ocupacion	INT(5);			-- Ocupacion del Cliente

    DECLARE Var_OcuDesc		VARCHAR(250);	-- Descripcion de la Ocupacion del Cliente
    DECLARE Var_FechaNac	DATE;			-- Fecha de Nacimiento del Cliente
    DECLARE Var_PaisID		INT(11);		-- Pais del Cliente
    DECLARE Var_PaisNombre	VARCHAR(250);	-- Descripcion del Pais del Cliente
    DECLARE Var_EstadoID	INT(11);		-- Estado del Cliente

    DECLARE Var_EstadoNom	VARCHAR(250);	-- Descripcion del Estado del Cliente
    DECLARE Var_LugarNacID	INT(11);		-- Lugar Nacimiento del Cliente
    DECLARE Var_LugarNom	VARCHAR(250);	-- Descripcion Lugar Nacimiento del Cliente
    DECLARE Var_EdoCivil	CHAR(2);		-- Estado Civil del Cliente
    DECLARE Var_EdoCivilDes	VARCHAR(250);	-- Descripcion Estado Civil del Cliente

    DECLARE EdoCivilS	CHAR(2);	-- Estado Civil S
    DECLARE EdoCivilCS	CHAR(2);	-- Estado Civil CS
    DECLARE EdoCivilCM	CHAR(2);	-- Estado Civil CM
    DECLARE EdoCivilCC	CHAR(2);	-- Estado Civil CC
    DECLARE EdoCivilV	CHAR(2);	-- Estado Civil V

    DECLARE EdoCivilD	CHAR(2);		-- Estado Civil D
    DECLARE EdoCivilSE	CHAR(2);		-- Estado Civil SE
    DECLARE EdoCivilU	CHAR(2);		-- Estado Civil U
    DECLARE EdoCivSDes	VARCHAR(250);	-- Descripcion Estado Civil S
    DECLARE EdoCivCSDes	VARCHAR(250);	-- Descripcion Estado Civil CS

    DECLARE EdoCivCMDes	VARCHAR(250);	-- Descripcion Estado Civil CM
    DECLARE EdoCivCCDes	VARCHAR(250);	-- Descripcion Estado Civil CC
    DECLARE EdoCivVDes	VARCHAR(250);	-- Descripcion Estado Civil V
    DECLARE EdoCivDDes	VARCHAR(250);	-- Descripcion Estado Civil D
    DECLARE EdoCivSEDes	VARCHAR(250);	-- Descripcion Estado Civil SE

    DECLARE EdoCivUDes	VARCHAR(250);	-- Descripcion Estado Civil U
    DECLARE Var_Sexo	CHAR(1);		-- Sexo del Cliente
    DECLARE Var_SexoDes	VARCHAR(100);	-- Descripcion del Sexo del Cliente
    DECLARE SexoF		CHAR(1);		-- Sexo F
    DECLARE SexoM		CHAR(1);		-- Sexo M

    DECLARE SexoFDes		VARCHAR(100);	-- Descripcion Sexo F
    DECLARE SexoMDeS		VARCHAR(100);	-- Descripcion Sexo M
	DECLARE Var_RFC			CHAR(13);		-- RFC del Cliente
    DECLARE Var_FechaActual	DATE;			-- Fecha Actual
    DECLARE Var_Edad		INT(5);			-- Edad del Cliente

    DECLARE Var_CURP		VARCHAR(20);	-- CURP del Cliente
    
    DECLARE Var_DomCalCasa	VARCHAR(200);	-- Dom  Calle y NumeroCasa
    DECLARE Var_DomCP		CHAR(5);		-- Dom Codigo Postal
    DECLARE Var_DomColonia	VARCHAR(200);	-- Dom Colonia
    DECLARE Var_DomEstadoID	INT(11);		-- Dom Estado

	DECLARE Var_DomEdoIDDes	VARCHAR(200);	-- Dom Descripcion Estado
    DECLARE Var_DomLocID	INT(11);		-- Dom Localidad
    DECLARE Var_DomCiuDes   VARCHAR(200);   -- Dom Ciudad   NUEVO
    DECLARE Var_DomLocIDDes	VARCHAR(200);	-- Dom Descripcion Localidad
    DECLARE Var_DomPrimera	VARCHAR(100);	-- Dom Primera Entre Calle
    DECLARE Var_DomSegunda	VARCHAR(100);	-- Dom Segunda Entre Calle

    DECLARE Var_DomMunID	INT(11);		-- Dom Municipio
	DECLARE Var_DomMunIDDes	VARCHAR(200);	-- Dom Descripcion Municipio
	DECLARE Var_Telefono	VARCHAR(20);	-- Telefono
    DECLARE Var_TraLugar	VARCHAR(100);	-- Trabajo Lugar
    DECLARE Var_TraTelefono	VARCHAR(20);	-- Trabajo Telefono

    DECLARE Var_TraAntig	DECIMAL(12,2);	-- Trabajo Antiguedad
    DECLARE Var_TraPuesto	VARCHAR(200);	-- Trabajo Puesto
    DECLARE Var_TraDomic	VARCHAR(500);	-- Trabajo Domicilio
    DECLARE Var_RazonSocial	VARCHAR(200);	-- Moral Razon Social
    DECLARE Var_RFCPM		CHAR(13);		-- Moral RFC

    DECLARE Var_FechaConst	DATE;			-- Moral Fecha Constitucion
    DECLARE Var_NumNotario	INT(11);		-- Moral Numero Notario
    DECLARE Var_PaisCons	INT(11);		-- Moral Pais Constitucion
    DECLARE Var_PaisConsDes	VARCHAR(200);	-- Moral Descripcion Pais Constitucion
    DECLARE Var_FechaAlta	DATE;			-- Moral Fecha Alta

    DECLARE Var_EjecCap     VARCHAR(200);
    DECLARE Var_Giro	    VARCHAR(200);	-- Moral Giro

-- LLAVES PARAMETROS
	-- numCon 1
    DECLARE NombreCompl		VARCHAR(20);	-- Llave Parametro NombreCompleto
    DECLARE EnvioEdoCta		VARCHAR(20);	-- Llave Parametro EnvioEdoCta
    DECLARE EnvioSucursal	VARCHAR(20);	-- Llave Parametro EnvioEdoCta Sucursal NUEVO
	DECLARE EnvioCorreo 	VARCHAR(20);	-- Llave Parametro EnvioEdoCta Correo NUEVO
    
    DECLARE LugReg			VARCHAR(20);
    DECLARE FolMerc			VARCHAR(20);
    DECLARE EscPub			VARCHAR(20);

    DECLARE Cliente		VARCHAR(20);	-- Llave Parametro ClienteID
    DECLARE Ocupacion	VARCHAR(20);	-- Llave Parametro Ocupacion

    DECLARE FechaNacimi	VARCHAR(20);	-- Llave Parametro FechaNacimiento
    DECLARE Pais		VARCHAR(20);	-- Llave Parametro Pais
    DECLARE Estado		VARCHAR(20);	-- Llave Parametro Estado
    DECLARE LugarNacimi	VARCHAR(20);	-- Llave Parametro LugarNacimiento
    DECLARE EstadoCiv	VARCHAR(20);	-- Llave Parametro EstadoCivil

    DECLARE TipoPers	VARCHAR(20);	-- Llave Parametro TipoPersona
    DECLARE Sex			VARCHAR(20);	-- Llave Parametro Sexo
    DECLARE RF			VARCHAR(20);	-- Llave Parametro RFC
    DECLARE Edad		VARCHAR(20);	-- Llave Parametro Edad
    DECLARE CUR			VARCHAR(20);	-- Llave Parametro CURP
    
    DECLARE DomCalCasa		VARCHAR(20);	-- Llave Parametro DomCalCasa
    DECLARE DomCP			VARCHAR(20);	-- Llave Parametro DomCP
    DECLARE DomColonia		VARCHAR(20);	-- Llave Parametro DomColonia
    DECLARE DomEstado		VARCHAR(20);	-- Llave Parametro DomEstado
    DECLARE DomLocalidad	VARCHAR(20);	-- Llave Parametro DomLocalidad
    DECLARE DomCiuDes       VARCHAR(20);    -- Llave Parametro DomCiuDes NUEVO    
    DECLARE DomPrimeraCa	VARCHAR(20);	-- Llave Parametro DomPrimeraCa
    DECLARE DomSegundaCa	VARCHAR(20);	-- Llave Parametro DomSegundaCa
    DECLARE DomMunicipio	VARCHAR(20);	-- Llave Parametro DomMunicipio
    DECLARE Telefon			VARCHAR(20);	-- Llave Parametro Telefono
    DECLARE TraLugar		VARCHAR(20);	-- Llave Parametro TraLugar

    DECLARE TraTelefono		VARCHAR(20);	-- Llave Parametro TraTelefono
    DECLARE TraAntiguedad	VARCHAR(20);	-- Llave Parametro TraAntiguedad
    DECLARE TraPuesto		VARCHAR(20);	-- Llave Parametro TraPuesto
    DECLARE TraDomicilio	VARCHAR(20);	-- Llave Parametro TraDomicilio
    DECLARE RazonSoci		VARCHAR(20);	-- Llave Parametro RazonSocial

    DECLARE RFCPERM			VARCHAR(20);	-- Llave Parametro RFCPM
    DECLARE FechaConstit	VARCHAR(20);	-- Llave Parametro FechaConstitucion
    DECLARE NumeroNotar		VARCHAR(20);	-- Llave Parametro NumeroNotario
    DECLARE PaisConstit		VARCHAR(20);	-- Llave Parametro PaisConstitucion
    DECLARE FechaAlt		VARCHAR(20);	-- Llave Parametro FechaAlta
    DECLARE EjecCap         VARCHAR(20);

    DECLARE Gir			VARCHAR(20);	-- Llave Parametro Giro
    DECLARE Transaccion	BIGINT(20);		-- Transaccion

-- ASIGNACION DE CONSTANTES
    SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
    SET Decimal_Cero	:= 0.00;
    SET NOENCONTRADO	:= 'NO ENCONTRADO';

    SET Con_SegA	:= 1;	-- VALOR DEL REPORTE RECA ANEXO A
    SET Con_SegB	:= 2;	-- VALOR DEL REPORTE RECA ANEXO B
    SET Con_SegC	:= 3;	-- VALOR DEL REPORTE RECA ANEXO C
    SET Con_SegD	:= 4;	-- VALOR DEL REPORTE RECA CONTRATO APERTURA DE CREDITO AViO AGROPECUARIO
    SET Con_SegE	:= 5;	-- VALOR DEL REPORTE RECA PRECEPTOS LEGALES

    SET Con_SegF	:= 6;	-- VALOR DEL REPORTE RECA SOLICITUD DE CREDITO DE PERSONA FISICA
    SET Con_SegG	:= 7;	-- VALOR DEL REPORTE RECA SOLICITUD DE CREDITO DE PERSONA MORAL
    SET Con_SegH	:= 8;	-- VALOR DEL REPORTE AUTORIZACION DE CARGO AUTOMATICO
    SET Con_SegI	:= 9;	-- VALOR DEL REPORTE CESION DE DERECHOS
    SET Con_SegJ	:= 10;	-- VALOR DEL REPORTE DECLARATORIA DUD

    SET Con_SegK	:= 11;	-- VALOR DEL REPORTE PAGARE PAGO UNICO INTERES MENSUALDUD
    SET Con_SegL	:= 12;	-- VALOR DEL REPORTE PAGARE PAGO UNICO
    SET Con_SegM	:= 13;	-- VALOR DEL REPORTE PAGOS ADELANTADOS OK

    SET Fisica		:= 'FISICA';
    SET Moral		:= 'MORAL';
    SET TipoPerF	:= 'F';
    SET TipoPerM	:= 'M';
    SET EdoCivilS	:= 'S';

    SET EdoCivilCS	:= 'CS';
    SET EdoCivilCM	:= 'CM';
    SET EdoCivilCC	:= 'CC';
    SET EdoCivilV	:= 'V';
    SET EdoCivilD	:= 'D';

    SET EdoCivilSE	:= 'SE';
    SET EdoCivilU	:= 'U';
    SET EdoCivSDes	:= 'SOLTERO';
    SET EdoCivCSDes	:= 'CASADO BIENES SEPARADOS';
    SET EdoCivCMDes	:= 'CASADO BIENES MANCOMUNADOS';

    SET EdoCivCCDes	:= 'CASADO BIENES MANCOMUNADOS CON CAPITULACION';
    SET EdoCivVDes	:= 'VIUDO';
    SET EdoCivDDes	:= 'DIVORCIADO';
    SET EdoCivSEDes	:= 'SEPARADO';
    SET EdoCivUDes	:= 'UNION LIBRE';

    SET SexoF		:= 'F';
    SET SexoM		:= 'M';
    SET SexoFDes	:= 'FEMENINO';
    SET SexoMDes	:= 'MASCULINO';
    
    -- numCon 1
    SET Cliente			:= 'customerNumber';
    SET EnvioEdoCta		:= 'accountStatement'; -- Flujo interno
    SET EnvioSucursal 	:= 'subsidiaryDelivery';
    SET EnvioCorreo 	:= 'emailDelivery';
    
    -- Datos personales - Persona Fisica
    SET NombreCompl	:= 'fullName';
    SET Ocupacion	:= 'occupation';
    SET FechaNacimi	:= 'birthDate';
    SET Pais		:= 'nationality';
    SET Estado		:= 'state';
    -- Escolaridad
    SET LugarNacimi	:= 'birthPlace';
    SET EstadoCiv	:= 'maritalStatus';
    SET Edad		:= 'age';
    SET TipoPers	:= 'personType'; 
    SET Sex			:= 'gender';
    SET CUR			:= 'curp';
    SET RF			:= 'rfc';
    
	-- Datos laborales - Persona Fisica
    SET TraLugar		:= 'workplace';
    SET TraTelefono		:= 'workTelephone';
    SET TraDomicilio	:= 'workDirection';
    SET TraAntiguedad	:= 'workSeniority';
    SET TraPuesto		:= 'workPosition';
    
    -- Datos generales - Persona Moral
    SET RazonSoci		:= 'businessName';    
    SET FechaAlt		:= 'businessRegDate';
    SET LugReg			:= 'businessRegPlace';
    SET RFCPERM			:= 'businessRfc';
    SET PaisConstit		:= 'businessConsPlace';
    SET FechaConstit	:= 'businessConsDate'; 
    SET FolMerc			:= 'businessFolio';
    SET EscPub			:= 'businessPubDeed';
    SET EjecCap         := 'executiveName';
	
    -- Folio Mercantil
    SET NumeroNotar		:= 'notaryNumber';
    SET Gir				:= 'businessScope';
    -- Escritura publica
    -- Nacionalidad
    
    -- Datos del domicilio
    SET DomCalCasa	    := 'homeDirection';
    SET DomCP		    := 'homeZipCode';
    SET DomColonia		:= 'homeSuburb';
    SET DomEstado		:= 'homeState';
    SET DomLocalidad	:= 'homeLocality';
    SET DomPrimeraCa	:= 'homeFirstStreet';
	SET DomCiuDes       := 'homeCity';
    SET DomSegundaCa	:= 'homeSecondStreet';
    SET DomMunicipio	:= 'homeMunicipality';
    SET Telefon			:= 'homeTelephone';
    
    SET Var_FechaActual := NOW();

-- CONSULTAS EN WS
    -- numCon 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13
    IF (Par_NumCon = Con_SegA	|| Par_NumCon = Con_SegB	|| Par_NumCon = Con_SegC	|| Par_NumCon = Con_SegD	|| Par_NumCon = Con_SegE	||
		Par_NumCon = Con_SegF	|| Par_NumCon = Con_SegG	|| Par_NumCon = Con_SegH	|| Par_NumCon = Con_SegJ	|| Par_NumCon = Con_SegK	||
        Par_NumCon = Con_SegL	|| Par_NumCon = Con_SegM) THEN
		SET TipoPer	:= (SELECT TipoPersona FROM CLIENTES WHERE ClienteID = Par_ClienteID);
		SET Var_TipoPerDes	:= NOENCONTRADO;

		IF (TipoPer = TipoPerF) THEN
			SET Var_NomComp		:= IFNULL((SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Par_ClienteID), Cadena_Vacia);
            SET Var_TipoPerDes	:= Fisica;
		END IF;

		IF (TipoPer = TipoPerM) THEN
			SET Var_NomComp		:= IFNULL((SELECT RazonSocial FROM CLIENTES WHERE ClienteID = Par_ClienteID), Cadena_Vacia);
            SET Var_TipoPerDes	:= Moral;
        END IF;       
    END IF;

    -- numCon 1, 2, 3, 13 - customerNumber
	IF (Par_NumCon = Con_SegA	|| Par_NumCon = Con_SegB	|| Par_NumCon = Con_SegC	|| Par_NumCon = Con_SegM) THEN
		SET Var_ClienteID	:= IFNULL((SELECT CLienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID), Entero_Cero);
    END IF;

    -- numCon 1 - 
    IF (Par_NumCon = Con_SegA) THEN
		SET Var_EnvioEdoCta	:= IFNULL((SELECT EstadoCta FROM CUENTASAHO WHERE ClienteID = Par_ClienteID AND EsPrincipal = EdoCivilS), Cadena_Vacia);
        
        IF (Var_EnvioEdoCta = 'S') THEN
			SET Var_EnvioSucursal = 'X';
            SET Var_EnvioCorreo = '';
		ELSE
			SET Var_EnvioSucursal = '';
            SET Var_EnvioCorreo = 'X';
        END IF;
        
    END IF;

    -- numCon 6 - 
    IF (Par_NumCon = Con_SegF) THEN
		SELECT	OcupacionID,		FechaNacimiento,	PaisNacionalidad,	EstadoID,		LugarNacimiento,
				EstadoCivil,		Sexo,				RFC,				CURP
		INTO	Var_Ocupacion,		Var_FechaNac,		Var_PaisID,			Var_EstadoID,	Var_LugarNacID,
				Var_EdoCivil,		Var_Sexo,			Var_RFC,			Var_CURP
		FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

        SET Var_OcuDesc		:= IFNULL((SELECT Descripcion FROM OCUPACIONES WHERE OcupacionID = Var_Ocupacion), Cadena_Vacia);
        SET Var_PaisNombre	:= IFNULL((SELECT Nombre FROM PAISES WHERE PaisID = Var_PaisID), Cadena_Vacia);
        SET Var_EstadoNom	:= IFNULL((SELECT Nombre FROM ESTADOSREPUB WHERE EstadoID = Var_EstadoID), Cadena_Vacia);
        SET Var_LugarNom	:= IFNULL((SELECT Nombre FROM PAISES WHERE PaisID = Var_LugarNacID), Cadena_Vacia);
		SET Var_EdoCivilDes	:=	CASE Var_EdoCivil
									WHEN EdoCivilS	THEN EdoCivSDes
									WHEN EdoCivilCS	THEN EdoCivCSDes
									WHEN EdoCivilCM	THEN EdoCivCMDes
									WHEN EdoCivilCC	THEN EdoCivCCDes
									WHEN EdoCivilV	THEN EdoCivVDes
									WHEN EdoCivilD	THEN EdoCivDDes
									WHEN EdoCivilSE	THEN EdoCivSEDes
									WHEN EdoCivilU	THEN EdoCivUDes
									ELSE NOENCONTRADO
								END;
        SET Var_SexoDes	:=	CASE Var_Sexo
								WHEN SexoF THEN SexoFDes
								WHEN SexoM THEN SexoMDes
								ELSE NOENCONTRADO
							END;
		SET Var_FechaNac	:= IFNULL(Var_FechaNac, Fecha_Vacia);

		IF (Var_FechaNac != Fecha_Vacia) THEN
			SET Var_Edad	:= (SELECT CAST(TIMESTAMPDIFF(YEAR, Var_FechaNac, Var_FechaActual)AS UNSIGNED));
		END IF;

		SET Var_Edad	:= IFNULL(Var_Edad, Entero_Cero);
        SET Var_RFC		:= IFNULL(Var_RFC, Cadena_Vacia);
        SET Var_CURP	:= IFNULL(Var_CURP, Cadena_Vacia);

        SELECT	LugardeTrabajo,	TelTrabajo,			AntiguedadTra,	Puesto,			DomicilioTrabajo
        INTO	Var_TraLugar,	Var_TraTelefono,	Var_TraAntig,	Var_TraPuesto,	Var_TraDomic
        FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

		SET Var_TraLugar	:= IFNULL(Var_TraLugar, Cadena_Vacia);
		SET Var_TraTelefono	:= IFNULL(Var_TraTelefono, Cadena_Vacia);
		SET Var_TraAntig	:= IFNULL(Var_TraAntig, Decimal_Cero);
		SET Var_TraPuesto	:= IFNULL(Var_TraPuesto, Cadena_Vacia);
		SET Var_TraDomic	:= IFNULL(Var_TraDomic, Cadena_Vacia);
    END IF;

    -- numCon 6, 7, 11, 12 -  
    IF (Par_NumCon = Con_SegF	|| Par_NumCon = Con_SegG	|| Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		SELECT	CONCAT(Calle, " ", NumeroCasa),	CP,					Colonia,		EstadoID,			LocalidadID,
				PrimeraEntreCalle,				SegundaEntreCalle,	MunicipioID
        INTO	Var_DomCalCasa,					Var_DomCP,			Var_DomColonia,	Var_DomEstadoID,	Var_DomLocID,
				Var_DomPrimera,					Var_DomSegunda,		Var_DomMunID
		FROM DIRECCLIENTE
			WHERE ClienteID = Par_ClienteID
				AND Oficial = EdoCivilS
			LIMIT 1;

        SET Var_DomEdoIDDes	:= IFNULL((SELECT Nombre FROM ESTADOSREPUB WHERE EstadoID = Var_DomEstadoID), Cadena_Vacia);
        SET Var_DomLocIDDes	:= IFNULL((SELECT NombreLocalidad FROM LOCALIDADREPUB WHERE LocalidadID = Var_DomLocID AND EstadoID = Var_DomEstadoID AND MunicipioID = Var_DomMunID), Cadena_Vacia);
        SET Var_DomCiuDes   := IFNULL(Var_DomLocIDDes, Cadena_Vacia);
        SET Var_DomMunIDDes	:= IFNULL((SELECT Nombre FROM MUNICIPIOSREPUB WHERE MunicipioID = Var_DomMunID AND EstadoID = Var_DomEstadoID), Cadena_Vacia);
        SET Var_Telefono	:= IFNULL((SELECT Telefono FROM CLIENTES WHERE ClienteID = Par_ClienteID), Cadena_Vacia);

		SET Var_DomCalCasa	:= IFNULL(Var_DomCalCasa, Cadena_Vacia);
        SET Var_DomCP		:= IFNULL(Var_DomCP, Cadena_Vacia);
        SET Var_DomColonia	:= IFNULL(Var_DomColonia, Cadena_Vacia);
        SET Var_DomPrimera	:= IFNULL(Var_DomPrimera, Cadena_Vacia);
        SET Var_DomSegunda	:= IFNULL(Var_DomSegunda, Cadena_Vacia);
    END IF;

    -- numCon 7, 9
	IF (Par_NumCon = Con_SegG || Par_NumCon = Con_SegI) THEN
		SELECT	RazonSocial,		RFC,		FechaConstitucion,	NumNotario,		PaisConstitucionID,
				FechaAlta,          EscrituraPubPM
		INTO	Var_RazonSocial,	Var_RFCPM,	Var_FechaConst,		Var_NumNotario,	Var_PaisCons,
				Var_FechaAlta, Var_EscPub
        FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

		SET Var_PaisConsDes	:= IFNULL((SELECT Nombre FROM PAISES WHERE PaisID = Var_PaisCons), Cadena_Vacia);
		SET Var_LugReg      := IFNULL(Var_PaisConsDes, Cadena_Vacia);
        SET Var_Giro		:= IFNULL((SELECT Giro FROM CONOCIMIENTOCTE WHERE ClienteID = Par_ClienteID), Cadena_Vacia);
		SET Var_RazonSocial	:= IFNULL(Var_RazonSocial, Cadena_Vacia);
		SET Var_RFCPM		:= IFNULL(Var_RFCPM, Cadena_Vacia);
		SET Var_FechaConst	:= IFNULL(Var_FechaConst, Fecha_Vacia);
		SET Var_NumNotario	:= IFNULL(Var_NumNotario, Entero_Cero);
		SET Var_FechaAlta	:= IFNULL(Var_FechaAlta, Fecha_Vacia);
        SET Var_EscPub	    := IFNULL(Var_EscPub, Cadena_Vacia);
        SET Var_FolMerc	    := IFNULL((SELECT FolioMercantil FROM DIRECTIVOS WHERE ClienteID = Par_ClienteID LIMIT 1), Cadena_Vacia);
        SET Var_EjecCap     := Cadena_Vacia;
    END IF;

    -- numCon 11, 12
    IF (Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		SET Var_PaisID 		:= IFNULL((SELECT PaisNacionalidad FROM CLIENTES WHERE ClienteID = Par_ClienteID), Entero_Cero);
        SET Var_PaisNombre	:= IFNULL((SELECT Nombre FROM PAISES WHERE PaisID = Var_PaisID), Cadena_Vacia);
    END IF;

	-- CREACION
    DROP TEMPORARY TABLE IF EXISTS `TMPCONTRATOSCLIENTES`;

	CREATE TEMPORARY TABLE `TMPCONTRATOSCLIENTES` (
		NumTransaccion	BIGINT(20),		-- NumTransaccion para identificar n procesos a la vez
        LlaveParametro	VARCHAR(100),	-- Nombre de la columna
        ValorParametro	VARCHAR(500)	-- Valor de la columna
	);

	CALL TRANSACCIONESPRO(Transaccion);

	-- INSERCIONES
    IF (Par_NumCon = Con_SegA) THEN
		INSERT INTO TMPCONTRATOSCLIENTES(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, NombreCompl,		Var_NomComp),
				(Transaccion, EnvioSucursal,	Var_EnvioSucursal),
				(Transaccion, EnvioCorreo,		Var_EnvioCorreo);
    END IF;

    IF (Par_NumCon = Con_SegD	|| Par_NumCon = Con_SegE	|| Par_NumCon = Con_SegH	|| Par_NumCon = Con_SegJ) THEN
        INSERT INTO TMPCONTRATOSCLIENTES(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, NombreCompl,	Var_NomComp);
    END IF;

    IF (Par_NumCon = Con_SegB	|| Par_NumCon = Con_SegC	|| Par_NumCon = Con_SegM) THEN
		INSERT INTO TMPCONTRATOSCLIENTES(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, NombreCompl,	Var_NomComp),
				(Transaccion, Cliente,		Var_ClienteID);
    END IF;

    IF (Par_NumCon = Con_SegF) THEN
		INSERT INTO TMPCONTRATOSCLIENTES(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, NombreCompl,		Var_NomComp),
				(Transaccion, Ocupacion,		Var_OcuDesc),
                (Transaccion, FechaNacimi,		Var_FechaNac),
                (Transaccion, Pais,				Var_PaisNombre),
                (Transaccion, Estado,			Var_EstadoNom),
                (Transaccion, LugarNacimi,		Var_LugarNom),
                (Transaccion, EstadoCiv,		Var_EdoCivilDes),
                (Transaccion, TipoPers,			Var_TipoPerDes),
                (Transaccion, Sex,				Var_SexoDes),
                (Transaccion, RF,				Var_RFC),
                (Transaccion, Edad,				Var_Edad),
                (Transaccion, CUR,				Var_CURP),
                (Transaccion, DomCalCasa,		Var_DomCalCasa),
                (Transaccion, DomCP,			Var_DomCP),
                (Transaccion, DomColonia,		Var_DomColonia),
                (Transaccion, DomEstado,		Var_DomEdoIDDes),
                (Transaccion, DomLocalidad,		Var_DomLocIDDes),
                (Transaccion, DomCiuDes,        Var_DomCiuDes),
                (Transaccion, DomPrimeraCa,		Var_DomPrimera),
                (Transaccion, DomSegundaCa,		Var_DomSegunda),
                (Transaccion, DomMunicipio,		Var_DomMunIDDes),
                (Transaccion, Telefon,			Var_Telefono),
                (Transaccion, TraLugar,			Var_TraLugar),
                (Transaccion, TraTelefono,		Var_TraTelefono),
                (Transaccion, TraAntiguedad,	Var_TraAntig),
                (Transaccion, TraPuesto,		Var_TraPuesto),
                (Transaccion, TraDomicilio,		Var_TraDomic);
    END IF;

    IF (Par_NumCon = Con_SegG) THEN
		INSERT INTO TMPCONTRATOSCLIENTES(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, RazonSoci,	Var_RazonSocial),
                (Transaccion, FechaAlt,		Var_FechaAlta),
				(Transaccion, RFCPERM,		Var_RFCPM),
                (Transaccion, LugReg,		Var_LugReg),
                (Transaccion, FechaConstit,	Var_FechaConst),
                (Transaccion, FolMerc,      Var_FolMerc),
                (Transaccion, NumeroNotar,	Var_NumNotario),
                (Transaccion, PaisConstit,	Var_PaisConsDes),
                (Transaccion, Gir,			Var_Giro),
                (Transaccion, EscPub,       Var_EscPub),
				(Transaccion, DomCalCasa,	Var_DomCalCasa),
                (Transaccion, DomCP,		Var_DomCP),
                (Transaccion, DomColonia,	Var_DomColonia),
                (Transaccion, DomEstado,	Var_DomEdoIDDes),
                (Transaccion, DomLocalidad,	Var_DomLocIDDes),
                (Transaccion, DomCiuDes,    Var_DomCiuDes),
                (Transaccion, DomPrimeraCa,	Var_DomPrimera),
                (Transaccion, DomSegundaCa,	Var_DomSegunda),
                (Transaccion, DomMunicipio,	Var_DomMunIDDes),
                (Transaccion, Telefon,		Var_Telefono),
                (Transaccion, EjecCap,       Var_EjecCap),
                (Transaccion, NombreCompl,	Var_NomComp);
    END IF;

    IF (Par_NumCon = Con_SegI) THEN
		INSERT INTO TMPCONTRATOSCLIENTES(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, RazonSoci,	Var_RazonSocial);
	END IF;

	IF (Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		INSERT INTO TMPCONTRATOSCLIENTES(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, DomCalCasa,	Var_DomCalCasa),
                (Transaccion, DomColonia,	Var_DomColonia),
                (Transaccion, DomLocalidad,	Var_DomLocIDDes),
                (Transaccion, DomMunicipio,	Var_DomMunIDDes),
                (Transaccion, DomEstado,	Var_DomEdoIDDes),
                (Transaccion, Pais,			Var_PaisNombre),
                (Transaccion, DomCP,		Var_DomCP),
                (Transaccion, NombreCompl,	Var_NomComp);
	END IF;

    SELECT NumTransaccion, LlaveParametro, ValorParametro FROM TMPCONTRATOSCLIENTES;

    DROP TEMPORARY TABLE IF EXISTS `TMPCONTRATOSCLIENTES`;
END TerminaStore$$