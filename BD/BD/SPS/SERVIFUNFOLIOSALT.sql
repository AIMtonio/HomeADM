-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNFOLIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVIFUNFOLIOSALT`;DELIMITER $$

CREATE PROCEDURE `SERVIFUNFOLIOSALT`(

	Par_ClienteID				int(11),
	Par_TipoServicio			char(1),
	Par_DifunClienteID			int(11),
	Par_DifunPrimerNombre		varchar(200),
	Par_DifunSegundoNombre		varchar(200),

	Par_DifunTercerNombre		varchar(200),
	Par_DifunApePaterno			varchar(200),
	Par_DifunApeMaterno			varchar(200),
	Par_DifunFechaNacim			date,
	Par_DifunParentesco			int(11),

	Par_TramClienteID			int(11),
	Par_TramPrimerNombre		varchar(200),
	Par_TramSegundoNombre		varchar(200),
	Par_TramTercerNombre		varchar(200),
	Par_TramApePaterno			varchar(200),

	Par_TramApeMaterno			varchar(200),
	Par_TramFechaNacim			date,
	Par_TramParentesco			int(11),
	Par_NoCertificadoDefun		char(100),
	Par_FechaCertiDefun			date,

	Par_Salida					char(1),
	inout Par_NumErr			int,
	inout Par_ErrMen			varchar(500),

	Par_EmpresaID				int(11),
	Aud_Usuario					int,
	Aud_FechaActual				DateTime,
	Aud_DireccionIP				varchar(15),
	Aud_ProgramaID				varchar(50),
	Aud_Sucursal				int(11),
	Aud_NumTransaccion			bigint
)
TerminaStore:BEGIN

DECLARE Var_ServiFunFolioID		int(11);
DECLARE Var_FechaSistema		date;
DECLARE Var_Control				varchar(50);
DECLARE Var_MontoApoyoSRVFUN 	decimal(14,2);
DECLARE Var_MonApoFamSRVFUN 	decimal(14,2);
DECLARE Var_MonApoSocSRVFUN 	decimal(14,2);
DECLARE Var_EdadMaximaSRVFUN 	int(11);
DECLARE Var_TiempoMinimoSRVFUN 	int(11);
DECLARE Var_MesesValAhoSRVFUN 	int(11);
DECLARE Var_FechaNacimiento		date;
DECLARE Var_FechaAlta			date;
DECLARE Var_EdadCliente			int;
DECLARE	Var_TiempoSocio			int;
DECLARE	Var_ClienteID			int;
DECLARE	Var_Folio				int;
DECLARE Var_NombreCompleto		varchar(200);
DECLARE AreaCancelaPro			char(3);


DECLARE Cadena_Vacia	char;
DECLARE Entero_Cero		int;
DECLARE SalidaSI		char(1);
DECLARE Con_Estatus		char(1);
DECLARE Decimal_Cero	decimal;
DECLARE Fecha_Vacia		date;
DECLARE ServicioCte		char(1);
DECLARE ServicioFam		char(1);
DECLARE EstatusRechazado	char(1);


SET Cadena_Vacia	:='';
SET Entero_Cero		:=0;
SET SalidaSI		:='S';
SET Con_Estatus		:='C';
set Fecha_Vacia		:='1900-01-01';
set Decimal_Cero	:=0.0;
set ServicioCte		:='C';
set ServicioFam		:='F';
set AreaCancelaPro	:= 'Pro';
set EstatusRechazado:= 'R';

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ',
						'estamos trabajando para resolverla. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-SERVIFUNFOLIOSALT');
		SET Var_Control = 'sqlException' ;
		END;

		if(Par_ClienteID=Entero_Cero) then
			set Par_NumErr  := 001;
			set Par_ErrMen  := 'Se requiere el ID del Cliente';
			set Var_Control := 'clienteID';
			LEAVE ManejoErrores;
		end if;
		if(Par_TipoServicio=Cadena_Vacia) then
			set Par_NumErr  := 002;
			set Par_ErrMen  := 'Se requiere el tipo de servicio';
			set Var_Control := 'tipoServicio';
			LEAVE ManejoErrores;
		end if;
		if (ifnull(Par_NoCertificadoDefun,Cadena_Vacia  ) = Cadena_Vacia)then
			set Par_NumErr  := 003;
			set Par_ErrMen  := 'El Numero de Certificado de Defuncion se encuentra Vacio';
			set Var_Control := 'noCertificadoDefun';
			LEAVE ManejoErrores;
		end if;
		if (ifnull(Par_FechaCertiDefun,Fecha_Vacia  ) = Fecha_Vacia)then
			set Par_NumErr  := 004;
			set Par_ErrMen  := 'La Fecha del Certificado de Defuncion se encuentra vacia';
			set Var_Control := 'fechaCertiDefun';
			LEAVE ManejoErrores;
		end if;
		if (Par_TipoServicio = ServicioCte)then

			set Par_DifunClienteID := (select ClienteID from CLIENTESCANCELA where ClienteID = Par_ClienteID and AreaCancela = AreaCancelaPro);
			if(ifnull(Par_DifunClienteID, Entero_Cero) = Entero_Cero) then
				set Par_NumErr   := 06;
				set Par_ErrMen   := 'El safilocale.cliente No Tiene una Solicitud de Cancelación.';
				set Var_Control		:= 'clienteID';
				LEAVE ManejoErrores;
			end if;

			set Par_DifunClienteID	:= Par_ClienteID;
		end if;
		if(ifnull(Par_DifunClienteID,Entero_Cero ) >Entero_Cero)then

			if not exists(select clienteID
							from CLIENTES Cli
							where Cli.ClienteID = Par_DifunClienteID)then
				set Par_NumErr  := 003;
				set Par_ErrMen  := concat('El Numero de Cliente ', convert(Par_DifunClienteID,char),' no existe');
				set Var_Control := 'difunClienteID ';
				LEAVE ManejoErrores;
			end if;

			select ServifunFolioID, DifunClienteID into Var_Folio,	Var_ClienteID
					from SERVIFUNFOLIOS
					where DifunClienteID = Par_DifunClienteID
						and Estatus != EstatusRechazado;

			if(ifnull(Var_ClienteID,Entero_Cero) > Entero_Cero)then
				set Par_NumErr  := 004;
				set Par_ErrMen  := concat('El Difunto ya esta Registrado en la Solicitud con Folio: ',Var_Folio );
				set Var_Control := 'clienteID';
				LEAVE ManejoErrores;
			end if;
		end if;


		select MontoApoyoSRVFUN,MonApoFamSRVFUN,EdadMaximaSRVFUN,TiempoMinimoSRVFUN,MesesValAhoSRVFUN
				into Var_MonApoSocSRVFUN,Var_MonApoFamSRVFUN,Var_EdadMaximaSRVFUN,Var_TiempoMinimoSRVFUN,Var_MesesValAhoSRVFUN
				from PARAMETROSCAJA limit 1;

		if (Par_TipoServicio = ServicioFam)then

			set Var_MontoApoyoSRVFUN	:=ifnull(Var_MonApoFamSRVFUN,Decimal_Cero);

			if(ifnull(Par_DifunClienteID,Entero_Cero ) >Entero_Cero)then
				if(Par_DifunClienteID = Par_ClienteID) then
					set Par_NumErr  := 003;
					set Par_ErrMen  := concat('Unicamente se puede Registrar a un Familiar.');
					set Var_Control := 'difunClienteID';
					LEAVE ManejoErrores;
				end if;

			end if;


			if(ifnull(Par_DifunPrimerNombre,Cadena_Vacia)=Cadena_Vacia) then
				set Par_NumErr  := 002;
				set Par_ErrMen  := 'El Nombre del Difunto esta Vacio';
				set Var_Control := 'difunPrimerNombre';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_DifunApePaterno,Cadena_Vacia)=Cadena_Vacia) then
				set Par_NumErr  := 002;
				set Par_ErrMen  := 'El Apellido Paterno del Difunto esta Vacio';
				set Var_Control := 'difunApePaterno';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_DifunFechaNacim,Fecha_Vacia)=Fecha_Vacia) then
				set Par_NumErr  := 002;
				set Par_ErrMen  := 'La Fecha de Nacimiento del Difunto esta Vacia';
				set Var_Control := 'difunFechaNacim';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_DifunParentesco,Entero_Cero) =Entero_Cero)then
				set Par_NumErr  := 004;
				set Par_ErrMen  := concat('El Parentesco del Cliente con el Difunto esta Vacio');
				set Var_Control := 'difunParentesco';
				LEAVE ManejoErrores;
			end if;

			if not exists(select TipoRelacionID
							from TIPORELACIONES
								where TipoRelacionID = Par_DifunParentesco)then
				set Par_NumErr  := 005;
				set Par_ErrMen  := concat('El Parentesco ',convert(Par_DifunParentesco,char) ,' no existe');
				set Var_Control := 'difunParentesco';
				LEAVE ManejoErrores;
			end if;



		end if;

		if(ifnull(Par_TramClienteID,Entero_Cero ) >Entero_Cero)then
			if (Par_TipoServicio = ServicioCte)then
				if(Par_TramClienteID = Par_ClienteID) then
					set Par_NumErr  := 003;
					set Par_ErrMen  := concat('Unicamente un Familiar puede Realizar el Tramite.');
					set Var_Control := 'tramClienteID';
					LEAVE ManejoErrores;
				end if;
			else
				set Par_TramClienteID := Par_ClienteID;
			end if;
			if not exists(select clienteID
							from CLIENTES Cli
							where Cli.ClienteID = Par_TramClienteID)then
				set Par_NumErr  := 003;
				set Par_ErrMen  := concat('El Numero de Cliente ', convert(Par_TramClienteID,char),' no existe');
				set Var_Control := 'tramClienteID';
				LEAVE ManejoErrores;
			end if;
		end if;

		if (Par_TipoServicio = ServicioCte)then

			set Var_MontoApoyoSRVFUN	:=ifnull(Var_MonApoSocSRVFUN,Decimal_Cero);
			if(ifnull(Par_TramPrimerNombre,Cadena_Vacia) =Cadena_Vacia)then
				set Par_NumErr  := 004;
				set Par_ErrMen  := concat('El Nombre de quien Realiza el Tramite esta vacio.');
				set Var_Control := 'tramPrimerNombre';
				LEAVE ManejoErrores;
			end if;
			if(ifnull(Par_TramApePaterno,Cadena_Vacia) =Cadena_Vacia)then
				set Par_NumErr  := 004;
				set Par_ErrMen  := concat('El Apellido Paterno de quien Realiza el Tramite esta vacio.');
				set Var_Control := 'tramApePaterno';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_TramParentesco,Entero_Cero) =Entero_Cero)then
				set Par_NumErr  := 004;
				set Par_ErrMen  := concat('El Parentesco de quien Realiza el Tramite esta vacio.');
				set Var_Control := 'tramParentesco';
				LEAVE ManejoErrores;
			end if;

			if not exists(select TipoRelacionID
							from TIPORELACIONES
								where TipoRelacionID = Par_TramParentesco)then
				set Par_NumErr  := 005;
				set Par_ErrMen  := concat('El Parentesco ',convert(Par_TramParentesco,char) ,' no existe');
				set Var_Control := 'tramParentesco';
				LEAVE ManejoErrores;
			end if;
		end if;


		set Var_EdadMaximaSRVFUN	:=ifnull(Var_EdadMaximaSRVFUN, Entero_Cero);
		set Var_TiempoMinimoSRVFUN	:=ifnull(Var_TiempoMinimoSRVFUN, Entero_Cero);
		set Var_MesesValAhoSRVFUN	:=ifnull(Var_MesesValAhoSRVFUN, Entero_Cero);



		if (Par_TipoServicio = ServicioCte)then

			set Var_NombreCompleto	:= ifnull((select NombreCompleto from CLIENTES where ClienteID = Par_ClienteID),Cadena_Vacia);
			set Par_DifunClienteID	:= Par_ClienteID;
		else
			if(Par_DifunClienteID > Entero_Cero)then
				set Var_NombreCompleto	= ifnull((select NombreCompleto from CLIENTES where ClienteID = Par_DifunClienteID),Cadena_Vacia);
			else
				set Var_NombreCompleto := concat(rtrim(ltrim(ifnull(Par_DifunPrimerNombre, '')))
						,case when CHAR_LENGTH(rtrim(ltrim(ifnull(Par_DifunSegundoNombre, '')))) > 0 then concat(" ", rtrim(ltrim(ifnull(Par_DifunSegundoNombre, '')))) else '' end
						,case when CHAR_LENGTH(rtrim(ltrim(ifnull(Par_DifunTercerNombre, '')))) > 0 then concat(" ", rtrim(ltrim(ifnull(Par_DifunTercerNombre, '')))) else '' end
						,case when CHAR_LENGTH(rtrim(ltrim(ifnull(Par_DifunApePaterno, '')))) > 0 then concat(" ", rtrim(ltrim(ifnull(Par_DifunApePaterno, '')))) else '' end
						,case when CHAR_LENGTH(rtrim(ltrim(ifnull(Par_DifunApeMaterno, '')))) > 0 then concat(" ", rtrim(ltrim(ifnull(Par_DifunApeMaterno, '')))) else '' end
					);
			end if;
		end if;

		set Var_FechaSistema:= (select FechaSistema from PARAMETROSSIS limit 1);

		call FOLIOSAPLICAACT('SERVIFUNFOLIOS', Var_ServiFunFolioID);
		Set Aud_FechaActual := CURRENT_TIMESTAMP();

		insert into SERVIFUNFOLIOS (
			ServifunFolioID,	ClienteID,			TipoServicio , 		FechaRegistro , Estatus,
 			DifunClienteID , 	DifunPrimerNombre,	DifunSegundoNombre,	DifunTercerNombre, 	DifunApePaterno,
			DifunApeMaterno, 	DifunFechaNacim,	DifunParentesco,	TramClienteID,		TramPrimerNombre,
			TramSegundoNombre,	TramTercerNombre, 	TramApePaterno, 	TramApeMaterno,		TramFechaNacim,
			TramParentesco, 	NoCertificadoDefun, FechaCertifDefun, 	UsuarioAutoriza,	FechaAutoriza,
			UsuarioRechaza, 	FechaRechazo, 		MotivoRechazo,		MontoApoyo, 		DifunNombreComp,
			EmpresaID,			Usuario,			FechaActual, 		DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion
		)VALUES(
			Var_ServiFunFolioID,	Par_ClienteID, 			Par_TipoServicio ,		Var_FechaSistema, 		Con_Estatus,
 			Par_DifunClienteID, 	Par_DifunPrimerNombre, 	Par_DifunSegundoNombre, Par_DifunTercerNombre, 	Par_DifunApePaterno,
			Par_DifunApeMaterno, 	Par_DifunFechaNacim,	Par_DifunParentesco, 	Par_TramClienteID, 		Par_TramPrimerNombre,
			Par_TramSegundoNombre, 	Par_TramTercerNombre, 	Par_TramApePaterno, 	Par_TramApeMaterno, 	Par_TramFechaNacim,
			Par_TramParentesco, 	Par_NoCertificadoDefun, Par_FechaCertiDefun, 	Entero_Cero, 			Fecha_Vacia,
			Entero_Cero,			Fecha_Vacia, 			Cadena_Vacia, 			Var_MontoApoyoSRVFUN, 	Var_NombreCompleto,
			Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal, 			Aud_NumTransaccion
		);
		set Par_NumErr  := 000;
        set Par_ErrMen  := concat('Solicitud de Servicios Funerarios del Cliente: ',Par_ClienteID,', Agregada Exitosamente con el Folio: ',Var_ServiFunFolioID );
        set Var_Control := 'serviFunFolioID';

	END ManejoErrores;
	if (Par_Salida = SalidaSI) then
		select  Par_NumErr as NumErr,
        Par_ErrMen as ErrMen,
        Var_Control as control,
        Var_ServiFunFolioID as consecutivo;
	end if;
END TerminaStore$$