-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNFOLIOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVIFUNFOLIOSMOD`;DELIMITER $$

CREATE PROCEDURE `SERVIFUNFOLIOSMOD`(
	Par_ServiFunFolioID			INT(11),
	Par_ClienteID				INT(11),
	Par_TipoServicio			CHAR(1),
	Par_DifunClienteID			INT(11),
	Par_DifunPrimerNombre		VARCHAR(200),
	Par_DifunSegundoNombre		VARCHAR(200),

	Par_DifunTercerNombre		VARCHAR(200),
	Par_DifunApePaterno			VARCHAR(200),
	Par_DifunApeMaterno			VARCHAR(200),
	Par_DifunFechaNacim			DATE,
	Par_DifunParentesco			INT(11),

	Par_TramClienteID			INT(11),
	Par_TramPrimerNombre		VARCHAR(200),
	Par_TramSegundoNombre		VARCHAR(200),
	Par_TramTercerNombre		VARCHAR(200),
	Par_TramApePaterno			VARCHAR(200),

	Par_TramApeMaterno			VARCHAR(200),
	Par_TramFechaNacim			DATE,
	Par_TramParentesco			INT(11),
	Par_NoCertificadoDefun		CHAR(100),
	Par_FechaCertiDefun			DATE,

	Par_Salida					CHAR(1),
	inout Par_NumErr			INT,
	inout Par_ErrMen			VARCHAR(500),

	Par_EmpresaID				INT(11),
	Aud_Usuario					INT,
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			bigINT
	)
TerminaStore:BEGIN

DECLARE Var_ServiFunFolioID		INT(11);
DECLARE Var_FechaSistema		DATE;
DECLARE Var_Control				VARCHAR(50);
DECLARE Var_MontoApoyoSRVFUN 	DECIMAL(14,2);
DECLARE Var_MonApoFamSRVFUN 	DECIMAL(14,2);

DECLARE Var_EdadMaximaSRVFUN 	INT(11);
DECLARE Var_TiempoMinimoSRVFUN 	INT(11);
DECLARE Var_MesesValAhoSRVFUN 	INT(11);
DECLARE Var_FechaNacimiento		DATE;
DECLARE Var_FechaAlta			DATE;
DECLARE Var_EdadCliente			INT;
DECLARE	Var_TiempoSocio			INT;
DECLARE Var_NombreCompleto		VARCHAR(200);
DECLARE	Var_ClienteID			INT;
DECLARE	Var_Folio				INT;


DECLARE Cadena_Vacia		CHAR;
DECLARE Entero_Cero			INT;
DECLARE SalidaSI			CHAR(1);

DECLARE Decimal_Cero		DECIMAL;
DECLARE Fecha_Vacia			DATE;
DECLARE ServicioCte			CHAR(1);
DECLARE ServicioFam			CHAR(1);
DECLARE EstatusRechazado	CHAR(1);
DECLARE AreaProteccion		CHAR(3);


SET Cadena_Vacia	:= '';
SET Entero_Cero		:= 0;
SET SalidaSI		:= 'S';
SET Fecha_Vacia		:= '1900-01-01';
SET Decimal_Cero	:= 0.0;
SET ServicioCte		:= 'C';
SET ServicioFam		:= 'F';
SET EstatusRechazado:= 'R';
SET AreaProteccion	:= 'Pro';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN	SET Par_NumErr = 999;
        SET	Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
			concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-SERVIFUNFOLIOSMOD');
		SET Var_Control = 'sqlException' ;

		END;

		IF(Par_ClienteID=Entero_Cero) then
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Se requiere el ID del Cliente';
			SET Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		END IF;
		IF(Par_TipoServicio=Cadena_Vacia) then
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Se requiere el tipo de servicio';
			SET Var_Control := 'tipoServicio';
			LEAVE ManejoErrores;
		END IF;
		IF (IFNULL(Par_NoCertificadoDefun,Cadena_Vacia  ) = Cadena_Vacia)then
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'El Numero de Certificado de Defuncion se encuentra Vacio';
			SET Var_Control := 'noCertificadoDefun';
			LEAVE ManejoErrores;
		END IF;
		IF (IFNULL(Par_FechaCertiDefun,Fecha_Vacia  ) = Fecha_Vacia)then
			SET Par_NumErr  := 004;
			SET Par_ErrMen  := 'La Fecha del Certificado de Defuncion se encuentra vacia';
			SET Var_Control := 'fechaCertiDefun';
			LEAVE ManejoErrores;
		END IF;


		IF (Par_TipoServicio = ServicioCte)then
			SET Par_DifunClienteID := (SELECT ClienteID FROM CLIENTESCANCELA WHERE ClienteID = Par_ClienteID
											  and AreaCancela = AreaProteccion);
			if(IFNULL(Par_DifunClienteID, Entero_Cero) = Entero_Cero) then
				SET Par_NumErr   := 06;
				SET Par_ErrMen   := 'El safilocale.cliente No Tiene una Solicitud de Cancelacion.';
				SET Var_Control		:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			SET Par_DifunClienteID	:= Par_ClienteID;
		END IF;
		IF(IFNULL(Par_DifunClienteID,Entero_Cero ) >Entero_Cero)then
			IF not exists(SELECT clienteID
							FROM CLIENTES Cli
							WHERE Cli.ClienteID = Par_DifunClienteID)then
				SET Par_NumErr  := 003;
				SET Par_ErrMen  := concat('El Numero de Cliente ', convert(Par_DifunClienteID,CHAR),' no existe');
				SET Var_Control := 'difunClienteID ';
				LEAVE ManejoErrores;
			END if;

			SELECT ServifunFolioID, DifunClienteID INTO Var_Folio,	Var_ClienteID
					FROM SERVIFUNFOLIOS
					WHERE DifunClienteID = Par_DifunClienteID
					and Estatus != EstatusRechazado;

			IF(IFNULL(Var_ClienteID,Entero_Cero) > Entero_Cero and Var_Folio != Par_ServiFunFolioID)then
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := concat('El Cliente ya esta Registrado en la Solicitud con Folio: ',Var_Folio );
				SET Var_Control := 'clienteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_TipoServicio = ServicioFam)then
			if(IFNULL(Par_DifunClienteID,Entero_Cero ) >Entero_Cero)then
				if(Par_DifunClienteID = Par_ClienteID) then
					SET Par_NumErr  := 003;
					SET Par_ErrMen  := concat('Unicamente se puede Registrar a un Familiar.');
					SET Var_Control := 'difunClienteID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			if(IFNULL(Par_DifunPrimerNombre,Cadena_Vacia)=Cadena_Vacia) then
				SET Par_NumErr  := 002;
				SET Par_ErrMen  := 'El Nombre del Difunto esta Vacio';
				SET Var_Control := 'difunPrimerNombre';
				LEAVE ManejoErrores;
			END IF;

			if(IFNULL(Par_DifunApePaterno,Cadena_Vacia)=Cadena_Vacia) then
				SET Par_NumErr  := 002;
				SET Par_ErrMen  := 'El Apellido Paterno del Difunto esta Vacio';
				SET Var_Control := 'difunApePaterno';
				LEAVE ManejoErrores;
			END IF;



			IF(IFNULL(Par_DifunClienteID,Entero_Cero ) >Entero_Cero)then
				SET Par_DifunFechaNacim :=(SELECT IFNULL(FechaNacimiento, Fecha_Vacia) FROM CLIENTES WHERE ClienteID = Par_DifunClienteID);
			ELSE
				if(IFNULL(Par_DifunFechaNacim,Fecha_Vacia)=Fecha_Vacia) then
					SET Par_NumErr  := 002;
					SET Par_ErrMen  := 'La Fecha de Nacimiento del Difunto esta Vacia';
					SET Var_Control := 'difunFechaNacim';
					LEAVE ManejoErrores;
				END IF;
			END IF;
			IF(IFNULL(Par_DifunParentesco,Entero_Cero) =Entero_Cero)then
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := concat('El Parentesco del Cliente con el Difunto esta Vacio');
				SET Var_Control := 'difunParentesco';
				LEAVE ManejoErrores;
			END IF;

			if not exists(SELECT TipoRelacionID
							FROM TIPORELACIONES
								WHERE TipoRelacionID = Par_DifunParentesco)then
				SET Par_NumErr  := 005;
				SET Par_ErrMen  := concat('El Parentesco ',convert(Par_DifunParentesco,CHAR) ,' no existe');
				SET Var_Control := 'difunParentesco';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(IFNULL(Par_TramClienteID,Entero_Cero ) >Entero_Cero)then
			IF (Par_TipoServicio = ServicioCte)then
				IF(Par_TramClienteID = Par_ClienteID) then
					SET Par_NumErr  := 003;
					SET Par_ErrMen  := concat('Unicamente un Familiar puede Realizar el Tramite.');
					SET Var_Control := 'tramClienteID';
					LEAVE ManejoErrores;
				END IF;
			END IF;
			IF not exists(SELECT clienteID
							FROM CLIENTES Cli
							WHERE Cli.ClienteID = Par_TramClienteID)then
				SET Par_NumErr  := 003;
				SET Par_ErrMen  := concat('El Numero de Cliente ', convert(Par_TramClienteID,CHAR),' no existe');
				SET Var_Control := 'tramClienteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_TipoServicio = ServicioCte)then
			IF(IFNULL(Par_TramPrimerNombre,Cadena_Vacia) =Cadena_Vacia)then
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := concat('El Nombre de quien Realiza el Tramite esta vacio.');
				SET Var_Control := 'tramPrimerNombre';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_TramApePaterno,Cadena_Vacia) =Cadena_Vacia)then
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := concat('El Apellido Paterno de quien Realiza el Tramite esta vacio.');
				SET Var_Control := 'tramApePaterno';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TramParentesco,Entero_Cero) =Entero_Cero)then
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := concat('El Parentesco de quien Realiza el Tramite esta vacio.');
				SET Var_Control := 'tramParentesco';
				LEAVE ManejoErrores;
			END IF;

			if not exists(SELECT TipoRelacionID
							FROM TIPORELACIONES
								WHERE TipoRelacionID = Par_TramParentesco)then
				SET Par_NumErr  := 005;
				SET Par_ErrMen  := concat('El Parentesco ',convert(Par_TramParentesco,CHAR) ,' no existe');
				SET Var_Control := 'tramParentesco';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SELECT MontoApoyoSRVFUN,			EdadMaximaSRVFUN,		TiempoMinimoSRVFUN,		MesesValAhoSRVFUN,		MonApoFamSRVFUN
				INTO Var_MontoApoyoSRVFUN,	Var_EdadMaximaSRVFUN,	Var_TiempoMinimoSRVFUN,	Var_MesesValAhoSRVFUN,	Var_MonApoFamSRVFUN
				FROM PARAMETROSCAJA limit 1;



		IF (Par_TipoServicio = ServicioFam)THEN
				SET Var_MontoApoyoSRVFUN	:=IFNULL(Var_MonApoFamSRVFUN,Decimal_Cero);
			ELSE
				SET Var_MontoApoyoSRVFUN	:=IFNULL(Var_MontoApoyoSRVFUN,Decimal_Cero);
		END IF;



		IF (Par_TipoServicio = ServicioCte)then
				SET Var_NombreCompleto	= IFNULL((SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Par_ClienteID),Cadena_Vacia);
			ELSE
				if(Par_DifunClienteID > Entero_Cero)then
					SET Var_NombreCompleto	= IFNULL((SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Par_DifunClienteID),Cadena_Vacia);
				ELSE
					SET Var_NombreCompleto := concat(rtrim(ltrim(IFNULL(Par_DifunPrimerNombre, '')))
							,case when CHAR_LENGTH(rtrim(ltrim(IFNULL(Par_DifunSegundoNombre, '')))) > 0 then concat(" ", rtrim(ltrim(IFNULL(Par_DifunSegundoNombre, '')))) ELSE '' END
							,case when CHAR_LENGTH(rtrim(ltrim(IFNULL(Par_DifunTercerNombre, '')))) > 0 then concat(" ", rtrim(ltrim(IFNULL(Par_DifunTercerNombre, '')))) ELSE '' END
							,case when CHAR_LENGTH(rtrim(ltrim(IFNULL(Par_DifunApePaterno, '')))) > 0 then concat(" ", rtrim(ltrim(IFNULL(Par_DifunApePaterno, '')))) ELSE '' END
							,case when CHAR_LENGTH(rtrim(ltrim(IFNULL(Par_DifunApeMaterno, '')))) > 0 then concat(" ", rtrim(ltrim(IFNULL(Par_DifunApeMaterno, '')))) ELSE '' END
						);
				END IF;
		END IF;
		SET Var_FechaSistema:= (SELECT FechaSistema FROM PARAMETROSSIS limit 1);

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE SERVIFUNFOLIOS SET
			ClienteID			= Par_ClienteID,
			TipoServicio 		= Par_TipoServicio,
 			DifunClienteID 		=Par_DifunClienteID,
			DifunPrimerNombre 	=Par_DifunPrimerNombre,
			DifunSegundoNombre 	= Par_DifunSegundoNombre,
			DifunTercerNombre 	= Par_DifunTercerNombre,
			DifunApePaterno		=Par_DifunApePaterno,
			DifunApeMaterno		=Par_DifunApeMaterno,
			DifunFechaNacim		=Par_DifunFechaNacim,
			DifunParentesco		=Par_DifunParentesco,
			TramClienteID		= Par_TramClienteID,
			TramPrimerNombre	= Par_TramPrimerNombre,
			TramSegundoNombre	= Par_TramSegundoNombre,
			TramTercerNombre	=Par_TramTercerNombre,
			TramApePaterno		=Par_TramApePaterno,
			TramApeMaterno		=Par_TramApeMaterno,
			TramFechaNacim		= Par_TramFechaNacim,
			TramParentesco		=Par_TramParentesco,
			NoCertificadoDefun	=Par_NoCertificadoDefun,
			FechaCertifDefun	=Par_FechaCertiDefun,
			MontoApoyo			= Var_MontoApoyoSRVFUN,
			DifunNombreComp		= Var_NombreCompleto,

			EmpresaID			=Par_EmpresaID,
			Usuario				=Aud_Usuario,
			FechaActual			=Aud_FechaActual,
			DireccionIP			=Aud_DireccionIP,
			ProgramaID			=Aud_ProgramaID,
			Sucursal			=Aud_Sucursal,
			NumTransaccion		=Aud_NumTransaccion
		WHERE ServiFunFolioID = Par_ServiFunFolioID;

		SET Par_NumErr  := 000;
        SET Par_ErrMen  := concat('Folio de Servicios Funerarios ' ,convert(Par_ServiFunFolioID,CHAR) ,', Modificado  Exitosamente.');
        SET Var_Control := 'serviFunFolioID';

	END ManejoErrores;
	IF (Par_Salida = SalidaSI) then
		SELECT  Par_NumErr as NumErr,
        Par_ErrMen as ErrMen,
        Var_Control as control,
        Par_ServiFunFolioID as consecutivo;
	END IF;

END TerminaStore$$