
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASPERSONAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASPERSONAALT`;

DELIMITER $$
CREATE PROCEDURE `CUENTASPERSONAALT`(
/** ***** STORE ENCARGADO DE DAR DE ALTA EN LA TABLA CUENTASPERSONA   ***** */
	Par_CuentaAhoID 		BIGINT(12),
	Par_EsApoderado			CHAR(1),
	Par_EsTitular			CHAR(1),
	Par_EsCotitular			CHAR(1),
	Par_EsBeneficiario		CHAR(1),

	Par_EsProvRecurso		CHAR(1),
	Par_EsPropReal			CHAR(1),
	Par_EsFirmante			CHAR(1),
	Par_Titulo 				VARCHAR(10),
	Par_PrimerNom 			VARCHAR(50),

	Par_SegundoNom 			VARCHAR(50),
	Par_TercerNom 			VARCHAR(50),
	Par_ApellidoPat			VARCHAR(50),
	Par_ApellidoMat 		VARCHAR(50),
	Par_FechaNac 			DATE,

	Par_PaisNac 			INT(5),
	Par_EdoNac				INT(11),
	Par_EdoCivil 			CHAR(2),
	Par_Sexo 				CHAR(1),
	Par_Nacion 				CHAR(1),

	Par_CURP 				CHAR(18),
	Par_RFC 				CHAR(13),
	Par_OcupacionID 		INT(5),
	Par_FEA					VARCHAR(250),
    Par_PaisFEA				INT(11),

	Par_PaisRFC				INT(11),
	Par_PuestoA				VARCHAR(100),
	Par_SectorGral 			INT(3),
	Par_ActBancoMX 			VARCHAR(15),
	Par_ActINEGI 			INT(5),

	Par_SecEcono			INT(3),
	Par_TipoIdentiID		INT(11),
	Par_OtraIden 			VARCHAR(20),
	Par_NumIden				VARCHAR(20),
	Par_FecExIden 			DATE,

	Par_FecVenIden 			DATE,
	Par_Domicilio 			VARCHAR(200),
	Par_TelCasa 			VARCHAR(20),
	Par_TelCel 				VARCHAR(20),
	Par_Correo 				VARCHAR(50),

	Par_PaisRes				INT(5),
	Par_DocEstLegal 		VARCHAR(3),
	Par_DocExisLegal		VARCHAR(30),
	Par_FechaVenEst			DATE,
	Par_NumEscPub 			VARCHAR(50),

	Par_FechaEscPub 		DATE,
	Par_EstadoID 			INT(11),
	Par_MunicipioID 		INT(11),
	Par_NotariaID 			INT(11),
	Par_TitularNotaria		VARCHAR(100),

	Par_RazonSocial 		VARCHAR(150),
	Par_Fax 				VARCHAR(30),
	Par_ParentescoID		INT(11),
	Par_Porcentaje 			FLOAT,
	Par_ClienteID			INT(11),

	Par_ExtTelefonoPart		VARCHAR(6),
	Par_IngreRealoRecur		DECIMAL(14,2),

    Par_CorreoPM			VARCHAR(50),			-- Correo de Persona Moral
    Par_TelefonoPM        	VARCHAR(20),			-- Telefono fijo del cliente	Persona Moral
    Par_ExtTelefonoPM       VARCHAR(6),				-- Extencion Telefono fijo del cliente	Persona Moral
    Par_DomicilioOfiPM		VARCHAR(200),			-- Domicilio oficial de Persona Moral
    Par_RazonSocialPM		VARCHAR(200),			-- Razon Social de PM

    Par_FechaRegistroPM		DATE,
    Par_PaisConstitucion	INT(5),
    Par_RFCpm               CHAR(12),
	Par_EsAccionista		CHAR(1),
	Par_PorcentajeAcc		DECIMAL(12,4),

    Par_FeaPM				VARCHAR(250),
    Par_PaisFeaPM			INT(11),

	Par_Salida    			CHAR(1),
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(400),

    /* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_nombrePersona		VARCHAR(200);
	DECLARE	Var_numeroCuenta		BIGINT(12);
	DECLARE Var_PaisID				INT(11);
	DECLARE Var_EstadoID			INT(11);
	DECLARE Var_Fecha_Actual 		DATE;
	DECLARE Var_AnioAct 			INT;
	DECLARE Var_MesAct  			INT;
	DECLARE Var_DiaAct  			INT;
	DECLARE Var_AnioNac 			INT;
	DECLARE Var_MesNac  			INT;
	DECLARE Var_DiaNac  			INT;
	DECLARE Var_Anios   			INT;
	DECLARE Var_EstatusRel			CHAR(1);
	DECLARE Var_PersonaID			INT(11);
	DECLARE varEstadoID				INT(11);
	DECLARE Var_Control             VARCHAR(200);
	DECLARE	Var_Consecutivo		    INT(11);
	DECLARE Var_CampoGenerico		INT(11);
	DECLARE Var_TipoPersSAFI		VARCHAR(3);
	DECLARE Var_Correo				VARCHAR(50);
	DECLARE Var_Telefono			VARCHAR(20);
	DECLARE Var_ExtTelefono			VARCHAR(6);
	DECLARE Var_Domicilio			VARCHAR(200);
	DECLARE Var_PaisResID           INT(11);

    DECLARE	Var_FechaNac			DATE;
    DECLARE Var_RFC             	CHAR(13);
    DECLARE Var_MunicipioID			INT(11);
    DECLARE Var_RazonSocial			VARCHAR(150);
	DECLARE Var_TipoPersonaCta		CHAR(1);
    DECLARE	Var_Fea					VARCHAR(250);
    DECLARE	Var_PaisFea				INT(11);
    DECLARE Var_TipoPers 			CHAR(3);
    DECLARE Var_IdentificadorID		INT(11);
	DECLARE	Var_SoloNombres			VARCHAR(500);
	DECLARE	Var_SoloApellidos		VARCHAR(500);
	DECLARE	Var_RazonSocialPLD		VARCHAR(200);

	-- Declaracion de Constantes
	DECLARE	NumPersona			INT;
	DECLARE	Var_NombreCompleto	VARCHAR(200);
	DECLARE	Estatus_Activo		CHAR(1);
	DECLARE	Cadena_Vacia		CHAR(1);

	DECLARE	Fecha				DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Float_Vacio			FLOAT;
	DECLARE	Si					CHAR(1);
	DECLARE	SumaPor				FLOAT;
	DECLARE	Fisica				CHAR(1);
	DECLARE	Moral				CHAR(1);
	DECLARE PaisMexico			INT(11);
	DECLARE Huella_SI			CHAR(1);
	DECLARE Vigente				CHAR(1);
	DECLARE	Cancelado			CHAR(1);
	DECLARE Extranjero			CHAR(1);
	DECLARE Constante_No		CHAR(1);
	DECLARE	EsCliente			VARCHAR(3);
	DECLARE	EsUsServ			VARCHAR(3);
	DECLARE	EsNA				VARCHAR(3);
	DECLARE Cons_Si				CHAR(1);
	DECLARE SumaPorAcc			DECIMAL(12,4);
	DECLARE Mayusculas			CHAR(2);
	

    DECLARE Num_Actualizar		TINYINT;

	--  Asignacion De Constantes
	SET	Var_NombreCompleto	:= ''; 			-- Nombre Completo de la persona
	SET	Estatus_Activo		:= 'A';			-- Estatus activo
	SET	Cadena_Vacia		:= '';			-- Cadena Vacia
	SET	Fecha				:= '1900-01-01';-- Fecha DEFAULT
	SET	Entero_Cero			:= 0;			-- Entero Cero
	SET	Float_Vacio			:= 0;			-- Flotante Cero
	SET	Si					:= 'S';			-- Si =S
	SET	SumaPor				:= 0;			-- suma  porcentaje
	SET SumaPorAcc			:= 0;			-- Suma de porcentaje de acciones

	SET	Fisica				:= 'F';			-- Persona Fisica
	SET	Moral				:= 'M';			-- PErsona Moral
	SET PaisMexico			:= 700;			-- valor en la tabla de paised de Mexico
	SET Par_PrimerNom       := TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
	SET Par_SegundoNom      := TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
	SET Par_TercerNom       := TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
	SET Par_ApellidoPat     := TRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia));
	SET Par_ApellidoMat     := TRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia));
	SET Huella_SI			:="S";
	SET Vigente				:='V';
	SET Cancelado			:='C';
	SET Extranjero			:= 'E';
	SET Constante_No		:= 'N'; 		-- Constante NO
	SET Var_CampoGenerico	:= 0;
	SET	EsCliente			:= 'CTE';		-- Se trata de un cliente
	SET	EsUsServ			:= 'USU';		-- Se trata de un usuario de servicios
	SET	EsNA				:= 'NA';		-- No se trata ni de un cliente ni de un usuario de servicios
	SET Cons_Si				:= 'S';
	SET Mayusculas			:= 'MA';	   -- Obtener el resultado en Mayusculas
    SET Num_Actualizar		:=	2;			-- opcion de Actualizacion del registro de firmas
    

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
								' esto le ocasiona. Ref: SP-CUENTASPERSONAALT');
				SET Var_Control := 'SQLEXCEPTION';
			END;



        -- Eliminar mascara telefono
		SET Par_TelCel			:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_TelCel, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);

		-- /***** PARA CALCULAR LA EDAD **************
		 SET Var_Fecha_Actual := (SELECT FechaSistema
											FROM PARAMETROSSIS
												WHERE EmpresaID=1);
		IF(Par_ClienteID > Entero_Cero)THEN
			SET Var_TipoPersonaCta := (SELECT Cli.TipoPersona
				FROM	CLIENTES Cli
				WHERE 	Cli.ClienteID = Par_ClienteID
				LIMIT 1);
		ELSE
			SET Var_TipoPersonaCta := Fisica;
		END IF;

		SET Var_AnioAct := YEAR(Var_Fecha_Actual);
		SET Var_MesAct 	:= MONTH(Var_Fecha_Actual);
		SET Var_DiaAct 	:= DAY(Var_Fecha_Actual);
		SET Var_AnioNac := YEAR(Par_FechaNac);
		SET Var_MesNac  := MONTH(Par_FechaNac);
		SET Var_DiaNac  := DAY(Par_FechaNac);
		SET Var_Anios   := Var_AnioAct-Var_AnioNac;

		IF(Var_MesAct<Var_MesNac) THEN
			  SET Var_Anios := Var_Anios-1;
		END IF;

		IF(Var_MesAct = Var_MesNac)THEN
			  IF(Var_DiaAct<Var_DiaNac) THEN
					SET Var_Anios := Var_Anios-1;
			   END IF;
		END IF;

		IF(Par_EsBeneficiario=Si)THEN
			SET SumaPor:= (
				SELECT SUM(Porcentaje)+Par_Porcentaje
					FROM CUENTASPERSONA
					WHERE CuentaAhoID=Par_CuentaAhoID
					AND EstatusRelacion = Vigente);

			IF(SumaPor>100)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  :='El Porcentaje se excede.';
				SET Var_Control := 'porcentaje';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El numero de Cuenta de ahorro esta Vacio.';
			SET Var_Control := 'cuentaAhoID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		-- Validaciones para peronas fisicas y pfae
		IF(Var_TipoPersonaCta <> Moral) THEN
			IF(IFNULL(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := 'El Primer Nombre esta Vacio.';
				SET Var_Control := 'cuentaAhoID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ApellidoPat, Cadena_Vacia) = Cadena_Vacia AND
				IFNULL(Par_ApellidoMat, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := 'Se requiere al menos uno de los Apellidos.';
				SET Var_Control := 'apellidoParterno';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaNac, Fecha)) = Fecha THEN
				SET Par_NumErr  := 5;
				SET Par_ErrMen  :=  'La fecha de Nacimiento esta Vacia.';
				SET Var_Control := 'fechaNacimiento';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  :='La Nacionalidad esta vacia.';
			SET Var_Control := 'Nacion';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Anios >= 18 AND Par_ClienteID != Entero_Cero )THEN
			IF(IFNULL(Par_TipoIdentiID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 9;
				SET Par_ErrMen  :='El Tipo de Identificacion esta Vacio ';
				SET Var_Control := 'tipoIdentiID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_EsApoderado=Si)THEN

			IF(IFNULL(Par_EstadoID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 6;
				SET Par_ErrMen  :='El Estado esta Vacio.';
				SET Var_Control := 'estadoID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_MunicipioID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 7;
				SET Par_ErrMen  :='El Municipio esta Vacio.';
				SET Var_Control := 'municipioID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumEscPub, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 10;
				SET Par_ErrMen  := 'El Numero de Escritura Publica esta Vacio.';
				SET Var_Control := 'numEscPub';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaEscPub, Fecha)) = Fecha THEN
				SET Par_NumErr  := 11;
				SET Par_ErrMen  := 'La Fecha de Escritura Publica esta Vacia.';
				SET Var_Control := 'fechaEscPub';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NotariaID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 12;
				SET Par_ErrMen  := 'La Notaria esta Vacia.';
				SET Var_Control := 'notariaID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TitularNotaria, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 13;
				SET Par_ErrMen  := 'El Titular de Notaria esta Vacio.';
				SET Var_Control := 'titularNotaria';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TipoPersonaCta <> Moral AND Par_ClienteID != Entero_Cero) THEN
				IF(IFNULL(Par_PuestoA, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr  := 14;
					SET Par_ErrMen  :='El Puesto esta Vacio.';
					SET Var_Control := 'puestoA';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(Par_EsBeneficiario=Si)THEN
			IF(IFNULL(Par_ParentescoID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 15;
				SET Par_ErrMen  := 'El Parentesco esta Vacio.';
				SET Var_Control := 'parentescoID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Porcentaje, FLOAT_Vacio)) = FLOAT_Vacio THEN
				SET Par_NumErr  := 16;
				SET Par_ErrMen  := 'El Porcentaje esta Vacio.';
				SET Var_Control := 'porcentaje';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Var_TipoPersonaCta = Fisica) THEN
			IF(IFNULL(Par_OcupacionID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 17;
				SET Par_ErrMen  := 'La ocupacion esta vacia.';
				SET Var_Control := 'ocupacionID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Var_TipoPersonaCta != Moral) THEN
			IF(IFNULL(Par_PaisNac, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 18;
				SET Par_ErrMen  := 'El Pais Especificado como el Lugar de Nacimiento esta Vacio.';
				SET Var_Control := 'paisNacimiento';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			ELSE
				SELECT PaisID INTO Var_PaisID FROM PAISES WHERE PaisID = Par_PaisNac;
				IF(IFNULL(Var_PaisID, Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr  := 19;
					SET Par_ErrMen  := 'El Pais Especificado como el Lugar de Nacimiento no existe.';
					SET Var_Control := 'Par_PaisNac';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				ELSE
					IF(Var_PaisID)= PaisMexico THEN
						SELECT EstadoID INTO Var_EstadoID FROM ESTADOSREPUB WHERE EstadoID = Par_EdoNac;
						IF(IFNULL(Var_EstadoID, Entero_Cero))= Entero_Cero THEN
							SET Par_NumErr  := 20;
							SET Par_ErrMen  := 'El estado especificado como Entidad Federativa no existe.';
							SET Var_Control := 'Par_EdoNac';
							SET Var_Consecutivo := Entero_Cero;
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;

		IF(Var_TipoPersonaCta = Moral) THEN
			SET Var_Domicilio		:= Par_DomicilioOfiPM;
			SET Var_FechaNac		:= Par_FechaRegistroPM;
			SET Var_RFC				:= Par_RFCpm;
			SET Var_PaisID			:= Par_PaisConstitucion;
			SET Var_Correo			:= Par_CorreoPM;
			SET Var_Telefono		:= Par_TelefonoPM;
			SET Var_ExtTelefono		:= Par_ExtTelefonoPM;
			SET Var_EstadoID		:= Par_EstadoID;
			SET Var_MunicipioID		:= Par_MunicipioID;
			SET Var_RazonSocial		:= Par_RazonSocialPM;
			SET Var_NombreCompleto 	:= Par_RazonSocialPM;
			SET Var_SoloNombres		:= Cadena_Vacia;
			SET Var_SoloApellidos	:= Cadena_Vacia;
			SET Var_RazonSocialPLD	:= LEFT(FNLIMPIACARACTERESGEN(Par_RazonSocialPM,'MA'),200);
			SET Var_Fea				:= Par_FeaPM;
			SET Var_PaisFea			:= Par_PaisFeaPM;
			SET Var_Telefono		:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Var_Telefono, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);

		ELSE
			SET Var_NombreCompleto	:= FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Par_ApellidoPat,Par_ApellidoMat);
			SET Var_SoloNombres		:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom, Cadena_Vacia, Cadena_Vacia),'MA'),500);
			SET Var_SoloApellidos	:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia, Cadena_Vacia, Par_ApellidoPat,Par_ApellidoMat),'MA'),500);
			SET Var_RazonSocialPLD	:= Cadena_Vacia;

			SET Var_Correo			:= Par_Correo;
			SET Var_Telefono		:= Par_TelCasa;
			SET Var_ExtTelefono		:= Par_ExtTelefonoPart;
			SET Var_Domicilio		:= Par_Domicilio;
			SET Var_EstadoID		:= Par_EstadoID;
			SET Var_MunicipioID		:= Par_MunicipioID;
			SET Var_RazonSocial		:= Par_RazonSocial;
			SET Var_FechaNac		:= Par_FechaNac;
			SET Var_RFC				:= Par_RFC;
			SET Var_PaisID			:= Par_PaisNac;
			SET Var_Fea				:= Par_FEA;
			SET Var_PaisFea			:= Par_PaisFEA;
			SET Var_Telefono		:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Var_Telefono, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);

		END IF;

		SELECT CP.NombreCompleto, CP.CuentaAhoID, CP.EstatusRelacion INTO Var_nombrePersona, Var_numeroCuenta, Var_EstatusRel
						FROM	CUENTASPERSONA CP
						WHERE		CP.CuentaAhoID 				= Par_CuentaAhoID
						AND			CP.NombreCompleto 			= Var_NombreCompleto
						AND 		IFNULL(CP.ClienteID,Entero_Cero)	=IFNULL(Par_ClienteID,Entero_Cero) LIMIT 1;
		SET Var_EstatusRel :=IFNULL(Var_EstatusRel,Cadena_Vacia);

		IF(IFNULL(Var_numeroCuenta,Entero_Cero) != Entero_Cero AND Var_EstatusRel = Vigente)THEN
			SET Par_NumErr  := 21;
			SET Par_ErrMen  :=  CONCAT('La Persona ya esta relacionada a la Cuenta:', Var_numeroCuenta);
			SET Var_Control := 'personaID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Extranjero THEN
			IF(IFNULL( Par_PaisRFC, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr  := 22;
				SET Par_ErrMen  :='El Pais de Registro de RFC No Existe';
				SET Var_Control := 'paisRFC';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			ELSE
				IF NOT EXISTS(SELECT PaisID FROM PAISES
						WHERE PaisID = Par_PaisRFC)THEN
					SET Par_NumErr  := 23;
					SET Par_ErrMen  :='El Pais de Registro de RFC No Existe';
					SET Var_Control := 'paisRFC';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		ELSE
			SET Par_PaisRFC := PaisMexico;
		END IF;

		IF(Par_EsAccionista=Cons_Si )THEN
			IF(Par_PorcentajeAcc = Float_Vacio OR Par_PorcentajeAcc> 100)THEN
				SET Par_NumErr  := 24;
				SET Par_ErrMen  :='El Porcentaje de Acciones debe ser mayor a Cero y menor de 100.';
				SET Var_Control := 'porcentajeAcc';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			ELSE
				SET SumaPorAcc:= (SELECT (SUM(IFNULL(PorcentajeAcciones,Entero_Cero))+Par_PorcentajeAcc)
					FROM CUENTASPERSONA
					WHERE CuentaAhoID = Par_CuentaAhoID AND EstatusRelacion = Vigente);

				IF(SumaPorAcc>100)THEN
					SET	Par_NumErr	:= 25;
					SET	Par_ErrMen	:= 'El Porcentaje de Acciones Excede el 100%.';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(IFNULL(Par_PaisRes, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  :=  26;
			SET Par_ErrMen  := 'El Pais de Residencia esta vacio.';
			SET Var_Control := 'paisResidencia';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET NumPersona := (SELECT IFNULL(MAX(PersonaID),Entero_Cero) + 1
								FROM CUENTASPERSONA
									WHERE CuentaAhoID=Par_CuentaAhoID);

		
		IF IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero THEN
			SET Var_TipoPers := EsCliente;
			SET Var_IdentificadorID := Par_ClienteID;
		ELSE
			SET Var_TipoPers := EsNA;
			SET Var_IdentificadorID := NumPersona;
		END IF;

		/*SECCION PLD: Deteccion de operaciones inusuales*/
		CALL PLDDETECCIONPRO(
			Var_IdentificadorID,			Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,			Par_ApellidoPat,
			Par_ApellidoMat,		Var_TipoPersonaCta,		Var_RazonSocial,		Var_RFC,				Var_RFC,
			Par_FechaNac,			Par_CuentaAhoID,		Par_PaisNac,			Par_EstadoID,			Var_NombreCompleto,
			Var_TipoPers,			Cons_Si,				Cons_Si,				Cons_Si,				Constante_No,
			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN

			SET Par_NumErr			:= 50; # NO CAMBIAR ESTE NUMERO DE ERROR
			SET Var_Control			:= 'avalID';
			LEAVE ManejoErrores;
		END IF;
		/*FIN SECCION PLD: Deteccion de operaciones inusuales*/

		IF(Var_EstatusRel = Cadena_Vacia )THEN
			INSERT INTO CUENTASPERSONA (
				CuentaAhoID,		PersonaID,			EsApoderado,		EsTitular,			EsCotitular,
				EsBeneficiario,		EsProvRecurso,		EsPropReal,			EsFirmante,			EsAccionista,
				Titulo,				PrimerNombre,		SegundoNombre,		TercerNombre,		ApellidoPaterno,
				ApellidoMaterno, 	NombreCompleto,		FechaNac,			PaisNacimiento,		EdoNacimiento,
				EstadoCivil,		Sexo,				Nacionalidad,		CURP,				RFC,
				OcupacionID,		FEA,				PaisFEA,			PaisRFC,			PuestoA,
				SectorGeneral,		ActividadBancoMX,	ActividadINEGI,		SectorEconomico,	TipoIdentiID,
				OtraIdentifi,		NumIdentific,		FecExIden,			FecVenIden,			Domicilio,
				TelefonoCasa,		TelefonoCelular,	Correo,				PaisResidencia,		DocEstanciaLegal,
				DocExisLegal,		FechaVenEst,		NumEscPub,			FechaEscPub,		EstadoID,
				MunicipioID,		NotariaID,			TitularNotaria,		RazonSocial,		Fax,
				ParentescoID,		Porcentaje,			ClienteID,			ExtTelefonoPart,	EstatusRelacion,
				IngresoRealoRecur,	PorcentajeAcciones,	SoloNombres,		SoloApellidos,		RazonSocialPLD,
				EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
			VALUES (
				Par_CuentaAhoID, 	NumPersona,			Par_EsApoderado,	Par_EsTitular,		Par_EsCotitular,
				Par_EsBeneficiario,	Par_EsProvRecurso,	Par_EsPropReal,		Par_EsFirmante,		Par_EsAccionista,
				Par_Titulo,			Par_PrimerNom,		Par_SegundoNom,		Par_TercerNom,		Par_ApellidoPat,
				Par_ApellidoMat,	Var_NombreCompleto,	Var_FechaNac, 		Var_PaisID,			Par_EdoNac,
				Par_EdoCivil,		Par_Sexo,			Par_Nacion,			Par_CURP,			Var_RFC,
				Par_OcupacionID,	Var_Fea,			Var_PaisFea,		Par_PaisRFC,		Par_PuestoA,
				Par_SectorGral,		Par_ActBancoMX,		Par_ActINEGI,		Par_SecEcono,		Par_TipoIdentiID,
				Par_OtraIden,		Par_NumIden,		Par_FecExIden,		Par_FecVenIden,		Var_Domicilio,
				Var_Telefono,		Par_TelCel,			Var_Correo,			Par_PaisRes,		Par_DocEstLegal,
				Par_DocExisLegal,	Par_FechaVenEst,	Par_NumEscPub,		Par_FechaEscPub,	Var_EstadoID,
				Var_MunicipioID,	Par_NotariaID,		Par_TitularNotaria,	Var_RazonSocial,	Par_Fax,
				Par_ParentescoID,	Par_Porcentaje,		Par_ClienteID,		Var_ExtTelefono,	Vigente,
				Par_IngreRealoRecur,Par_PorcentajeAcc,	Var_SoloNombres,	Var_SoloApellidos,	Var_RazonSocialPLD,
				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			SET Par_NumErr      := 000;
			SET Par_ErrMen      := CONCAT("Persona Agregada: ", CONVERT(NumPersona, CHAR)) ;
			SET Var_Control     := 'personaID';
			SET Var_Consecutivo := NumPersona;


            IF(Par_EsFirmante = Si OR Par_EsApoderado = Si) THEN
				CALL FIRMASIMPRESIONFITPRO(Par_CuentaAhoID, Num_Actualizar, Constante_No, Par_NumErr, Par_ErrMen,  Par_EmpresaID, Aud_Usuario,
                Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);

                IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
                END IF;

			END IF;


		END IF;

		IF(Var_EstatusRel = Cancelado)THEN
			UPDATE CUENTASPERSONA SET
				EsApoderado		=	Par_EsApoderado,
				EsTitular 		=	Par_EsTitular,
				EsCotitular		=	Par_EsCotitular,
				EsBeneficiario 	=	Par_EsBeneficiario,
				EsProvRecurso 	=	Par_EsProvRecurso,
				EsPropReal 		=	Par_EsPropReal,
				EsFirmante		=	Par_EsFirmante,
				Titulo 			=	Par_Titulo,
				PrimerNombre 	=	Par_PrimerNom,
				SegundoNombre 	=	Par_SegundoNom,
				TercerNombre 	=	Par_TercerNom,
				ApellidoPaterno	=	Par_ApellidoPat,
				ApellidoMaterno	=	Par_ApellidoMat,
				NombreCompleto 	=	Var_NombreCompleto,
				FechaNac 		=	Par_FechaNac,
				PaisNacimiento	=	Par_PaisNac,
				EdoNacimiento	=	Par_EdoNac,
				EstadoCivil 	=	Par_EdoCivil,
				Sexo 			=	Par_Sexo,
				Nacionalidad 	=	Par_Nacion,
				CURP 			=	Par_CURP,
				RFC				=	Par_RFC,
				OcupacionID		=	Par_OcupacionID,
				FEA				=	Var_Fea,
				PaisFEA			=	Var_PaisFea,
				PaisRFC			=	Par_PaisRFC,
				PuestoA			=	Par_PuestoA,
				SectorGeneral 	=	Par_SectorGral,
				ActividadBancoMX=	Par_ActBancoMX,
				ActividadINEGI 	=	Par_ActINEGI,
				SectorEconomico =	Par_SecEcono,
				TipoIdentiID 	=	Par_TipoIdentiID,
				OtraIdentifi	=	Par_OtraIden,
				NumIdentific 	=	Par_NumIden,
				FecExIden 		=	Par_FecExIden,
				FecVenIden 		=	Par_FecVenIden,
				Domicilio 		=	Par_Domicilio,
				TelefonoCasa 	=	Par_TelCasa,
				TelefonoCelular =	Par_TelCel,
				Correo 			=	Par_Correo,
				PaisResidencia 	=	Par_PaisRes,
				DocEstanciaLegal=	Par_DocEstLegal,
				DocExisLegal	=	Par_DocExisLegal,
				FechaVenEst 	=	Par_FechaVenEst,
				NumEscPub 		=	Par_NumEscPub,
				FechaEscPub 	=	Par_FechaEscPub,
				EstadoID 		=	Par_EstadoID,
				MunicipioID 	=	Par_MunicipioID,
				NotariaID 		=	Par_NotariaID,
				TitularNotaria 	=	Par_TitularNotaria,
				RazonSocial 	=	Par_RazonSocial,
				Fax 			=	Par_Fax,
				ParentescoID 	= 	Par_ParentescoID,
				Porcentaje		= 	Par_Porcentaje,
				ClienteID		=	Par_ClienteID,
				ExtTelefonoPart	=	Par_ExtTelefonoPart,
				EstatusRelacion	= 	Vigente,

				EsAccionista	= Par_EsAccionista,
				PorcentajeAcciones = Par_PorcentajeAcc,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE	CuentaAhoID		= Par_CuentaAhoID
				AND		NombreCompleto	= Var_NombreCompleto
				AND		IFNULL(ClienteID,Entero_Cero)	=IFNULL(Par_ClienteID,Entero_Cero);

			SELECT PersonaID INTO Var_PersonaID
				FROM CUENTASPERSONA
					WHERE	CuentaAhoID 	= Par_CuentaAhoID
					  AND	EstatusRelacion = Vigente
					  AND	NombreCompleto 	= Var_NombreCompleto
					  AND	IFNULL(ClienteID,Entero_Cero) = IFNULL(Par_ClienteID,Entero_Cero) LIMIT 1;

			SET Par_NumErr      := 0;
			SET Par_ErrMen      := CONCAT('Persona Relacionada a la Cuenta: ', CONVERT(Par_CuentaAhoID, CHAR), ' Agregada Exitosamente');
			SET Var_Control     := 'personaID';
			SET Var_Consecutivo := Var_PersonaID;

		END IF;

	END ManejoErrores;

	IF (Par_Salida = Si) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS Control,
				Var_Consecutivo	AS Consecutivo,
				Var_CampoGenerico AS CampoGenerico;
	END IF;

END TerminaStore$$

