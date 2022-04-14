-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUTFONDEOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUTFONDEOALT`;DELIMITER $$

CREATE PROCEDURE `INSTITUTFONDEOALT`(
# =====================================================================
# ----- STORE QUE REALIZA ALTA DE INSTITUCIONES DE FONDEO------
# =====================================================================
	Par_TipoFondeador   	CHAR(1),
	Par_CobraISR			CHAR(1),
    Par_RazonSocInstFo 		VARCHAR(200),
    Par_NombreInstitFon 	VARCHAR(200),
    Par_Estatus         	CHAR(1),

    Par_InstitucionID   	INT(11),
	Par_ClienteID			INT(11),
	Par_NombreCliente		VARCHAR(200),
	Par_NumCtaInstit		VARCHAR(20),
	Par_CuentaClabe			VARCHAR(18),

	Par_NombreTitular		VARCHAR(50),
	Par_IDInstitucion		INT(11),
	Par_CentroCostos		INT(11),		-- Centro de Costos
	Par_RFC                 CHAR(13),     	-- RFC
    Par_EstadoID			INT(11),		-- ESTADO

	Par_MunicipioID			INT(11),		-- MUNICIPIO
    Par_LocalidadID			INT(11),		-- LOCALIDAD
	Par_ColoniaID			INT(11),		-- COLINIA
	Par_Calle				VARCHAR(350),	-- CALLE
	Par_NumeroCasa			CHAR(10),		-- CASA NUMERO

    Par_NumInterior			CHAR(10),		-- NUM INTERIOR
	Par_Piso				CHAR(50),		-- PISO
	Par_PrimECalle			VARCHAR(50),	-- CALLE
	Par_SegECalle			VARCHAR(50),  	-- SEGUNDA CALLE
	Par_CP					CHAR(5),		-- CP
    Par_RepresenLegal		VARCHAR(100),   -- NOMBRE DEL REPRESENTANTE LEGAL
    Par_CapturaIndica		VARCHAR(50),	-- Indica si captura credito, acreditado FIRA
    Par_Salida          	CHAR(1),
	INOUT Par_NumErr    	INT(11),
	INOUT Par_ErrMen    	VARCHAR(400),

    Aud_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_InstitucionID	INT(11);
	DECLARE Var_Control			VARCHAR(200);
	DECLARE Var_NombreInstitFon	VARCHAR(200);
	DECLARE Var_Consecutivo		INT(11);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Decimal_Cero	DECIMAL(14,2);
	DECLARE	PersonaMoral	CHAR(1);
	DECLARE	PersonaGub	    CHAR(1);
	DECLARE	PersonaFis		CHAR(1);
	DECLARE	PersonaFisAct	CHAR(1);
	DECLARE Salida_SI		CHAR(1);
	DECLARE NombEstado		VARCHAR(50);
	DECLARE NombMunicipio	VARCHAR(50);
	DECLARE DirecCompleta	VARCHAR(500);
	DECLARE Valida_RFC      CHAR(13);
	DECLARE NombreColonia   VARCHAR(200);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET PersonaMoral    	:= 'M';
	SET PersonaGub      	:= 'G';
	SET PersonaFis      	:= 'F';
	SET PersonaFisAct   	:= 'A';
	SET Salida_SI 			:= 'S';
	SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-INSTITUTFONDEOALT');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

		IF(IFNULL(Par_TipoFondeador, Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Tipo Fondeador esta vacio.';
			SET Var_Control := 'tipoFondeador';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CentroCostos, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El Centro de Costos esta vacio.';
			SET Var_Control := 'centroCostos';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CobraISR, Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'La Retencion esta vacia.';
			SET Var_Control := 'cobraISR';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Estatus, Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'El Estatus esta vacio.';
			SET Var_Control := 'estatus';
			LEAVE ManejoErrores;
		END IF;

		SET Var_InstitucionID := (SELECT IFNULL( InstitucionID,Entero_Cero) FROM INSTITUCIONES
									WHERE InstitucionID = Par_InstitucionID);

		IF(IFNULL(Var_InstitucionID, Entero_Cero))< Entero_Cero THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := 'El Numero de Institucion no Existe.';
			SET Var_Control := 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoFondeador = PersonaMoral OR Par_TipoFondeador = PersonaGub)THEN
			IF(IFNULL(Par_RazonSocInstFo, Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr := 006;
				SET Par_ErrMen := 'La Razon Social esta vacia.';
				SET Var_Control := 'razonSocInstFo';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoFondeador = PersonaGub) THEN
			IF(IFNULL(Var_InstitucionID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 007;
				SET Par_ErrMen := 'El Numero de Institucion esta vacio.';
				SET Var_Control := 'institucionID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_NombreInstitFon := Par_NombreInstitFon;
		ELSE
			IF(Par_TipoFondeador = PersonaMoral)THEN
				SET Var_NombreInstitFon := Par_RazonSocInstFo;
			ELSE
				SET Var_NombreInstitFon := Par_NombreCliente;
			END IF;
		END IF;

		IF(Par_TipoFondeador = PersonaFis OR Par_TipoFondeador = PersonaFisAct) THEN
			IF(Par_ClienteID= Entero_Cero) THEN
				IF(IFNULL(Par_NombreCliente, Cadena_Vacia)=Cadena_Vacia)THEN
					SET Par_NumErr := 008;
					SET Par_ErrMen := 'El Nombre del Fondeador esta vacio.';
					SET Var_Control := 'clienteID';
					LEAVE ManejoErrores;
                END IF;
			ELSE
				IF NOT EXISTS (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID) THEN
					SET Par_NumErr := 009;
					SET Par_ErrMen := 'El cliente no Existe.';
					SET Var_Control := 'clienteID';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(IFNULL(Par_EstadoID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 10;
			SET Par_ErrMen := 'El Estado esta Vacio.' ;
			SET Var_Control := 'estadoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MunicipioID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := 'El Municipio esta Vacio.' ;
			SET Var_Control := 'municipioID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 12;
			SET Par_ErrMen := 'La Calle esta Vacia.' ;
			SET Var_Control := 'calle';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 13;
			SET Par_ErrMen := 'La Colonia Esta Vacia.' ;
			SET Var_Control := 'coloniaID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CP, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 14;
			SET Par_ErrMen := 'El Codigo Postal esta Vacio.' ;
			SET Var_Control := 'CP';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_LocalidadID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 15;
			SET Par_ErrMen := 'La Localidad esta Vacia.' ;
			SET Var_Control := 'localidadID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 16;
			SET Par_ErrMen := 'El Numero esta Vacio.' ;
			SET Var_Control := 'numeroCasa';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 017;
			SET Par_ErrMen := 'El RFC esta vacio.';
			SET Var_Control := 'RFC';
			LEAVE ManejoErrores;
		END IF;

        IF(Par_TipoFondeador = PersonaMoral)THEN
			IF(IFNULL(Par_RepresenLegal, Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr := 018;
				SET Par_ErrMen := 'EL Representante Legal esta vacio.';
				SET Var_Control := 'repLegal';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET NombEstado := (SELECT Nombre
			FROM ESTADOSREPUB
		WHERE EstadoID = Par_EstadoID);

		SET NombMunicipio := (SELECT M.Nombre
			FROM MUNICIPIOSREPUB M,ESTADOSREPUB E
		WHERE E.EstadoID=M.EstadoID AND E.EstadoID=Par_EstadoID AND M.MunicipioID=Par_MunicipioID);

		SELECT CONCAT(TipoAsenta," ", Asentamiento) INTO NombreColonia
			FROM COLONIASREPUB
		WHERE EstadoID 	= Par_EstadoID
	  		AND MunicipioID	= Par_MunicipioID
	  		AND ColoniaID   = Par_ColoniaID;

		SET Par_NumeroCasa  := IFNULL(Par_NumeroCasa, Cadena_Vacia);
		SET Par_NumInterior := IFNULL(Par_NumInterior, Cadena_Vacia);
		SET Par_Piso 		:= IFNULL(Par_Piso, Cadena_Vacia);
		SET DirecCompleta 	:= Par_Calle;

		IF(Par_NumeroCasa != Cadena_Vacia) THEN
			SET DirecCompleta := CONCAT(DirecCompleta,", No. ",Par_NumeroCasa);
		END IF;

		IF(Par_NumInterior != Cadena_Vacia) THEN
			SET DirecCompleta := CONCAT(DirecCompleta,", INTERIOR ",Par_NumInterior);
		END IF;

		IF(Par_Piso != Cadena_Vacia) THEN
			SET DirecCompleta := CONCAT(DirecCompleta,", PISO ",Par_Piso);
		END IF;

		SET DirecCompleta := UPPER(CONCAT(DirecCompleta,", COL. ",NombreColonia,", C.P ",Par_CP,", ",NombMunicipio,", ",NombEstado,"."));

		SET Var_Consecutivo := (SELECT IFNULL(COUNT(*),Entero_Cero)+1 FROM INSTITUTFONDEO);

		INSERT INTO INSTITUTFONDEO(
			InstitutFondID,		TipoFondeador,		CobraISR,				RazonSocInstFo, 	NombreInstitFon,
			Estatus,	   		InstitucionID,		ClienteID,				NumCtaInstit,		CuentaClabe,
			NombreTitular, 		IDInstitucion,		CentroCostos,			RFC,				EstadoID,
			MunicipioID,   		LocalidadID,     	ColoniaID,    			Calle, 				NumeroCasa,
			NumInterior,		Piso,          		PrimeraEntreCalle,   	SegundaEntreCalle,  CP,
			DireccionCompleta,	RepresentanteLegal,	CapturaIndica,			EmpresaID,			Usuario,
			FechaActual,		DireccionIP,   		ProgramaID,				Sucursal,	  		NumTransaccion)
		VALUES(
			Var_Consecutivo,    Par_TipoFondeador,    	Par_CobraISR,	    Par_RazonSocInstFo, Var_NombreInstitFon,
			Par_Estatus,  	   	Par_InstitucionID,    	Par_ClienteID,		Par_NumCtaInstit,	Par_CuentaClabe,
			Par_NombreTitular,  Par_IDInstitucion,		Par_CentroCostos,	Par_RFC,			Par_EstadoID,
			Par_MunicipioID,  	Par_LocalidadID,   		Par_ColoniaID,    	Par_Calle,      	Par_NumeroCasa,
			Par_NumInterior,    Par_Piso,     			Par_PrimECalle,   	Par_SegECalle,    	Par_CP,
			DirecCompleta,		Par_RepresenLegal,		Par_CapturaIndica,	Aud_EmpresaID,    	Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr  	:= 0;
		SET Par_ErrMen  	:= CONCAT("Institucion de Fondeo Agregada Exitosamente: ", CONVERT(Var_Consecutivo, CHAR));
		SET Var_Control 	:= 'institutFondID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$