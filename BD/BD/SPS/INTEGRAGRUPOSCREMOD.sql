-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSCREMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSCREMOD`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPOSCREMOD`(
Par_GrupoID				int(11),
	Par_SolicitudCreditoID 	int(11),
	Par_Ciclo 				int(11),
	Par_Cargo 				int(11),

	Par_Salida				char(1),
	inout Par_NumErr    	int,
	inout Par_ErrMen    	varchar(200),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN

	DECLARE Var_HisPuestoGpoID	varchar(20);
	DECLARE Var_Control		    varchar(100);
	DECLARE FechaRegistra       date;
	DECLARE UsuarioRegistra     varchar(20);
	DECLARE Var_Cliente		    varchar(20);
	DECLARE Var_Prospecto		varchar(20);
	DECLARE Var_EstSolicitud    varchar(20);
	DECLARE Var_Cargo           varchar(20);
	DECLARE Var_Credito         varchar(20);
	DECLARE Var_NumSolicitud    int(11);
	DECLARE Var_EstGrupo        varchar(20);


	DECLARE Cadena_Vacia	 char(1);
	DECLARE Entero_Cero		 int;
	DECLARE SalidaSI 		 char(1);
	DECLARE SolCancelada     char(1);
	DECLARE SolRechazada     char(1);
	DECLARE SolDesembolsada  char(1);
	DECLARE EstCredPagado    char(1);
	DECLARE EstCredCastigado char(1);
	DECLARE EstGrupoCerrado  char(1);
	DECLARE CargoPresidente   int(11);
	DECLARE CargoTesorero     int(11);
	DECLARE CargoSecretario   int(11);
	DECLARE CargoIntegrante   int(11);


	Set Cadena_Vacia     := '';
	Set Entero_Cero      := 0;
	Set SalidaSI         := 'S';
	Set SolCancelada     := 'C';
	Set SolRechazada     := 'R';
	Set SolDesembolsada  := 'D';
	Set EstCredPagado    := 'P';
	Set EstCredCastigado := 'K';
	Set EstGrupoCerrado  := 'C';
	Set CargoPresidente   := 1;
	Set CargoTesorero     := 2;
	Set CargoSecretario   := 3;
	Set CargoIntegrante   := 4;


	set FechaRegistra := (select FechaSistema from PARAMETROSSIS);
	set UsuarioRegistra := (select UsuarioID from USUARIOS where UsuarioID = Aud_Usuario);

	set Var_NumSolicitud := (select count(SolicitudCreditoID) from INTEGRAGRUPOSCRE
							where GrupoID=Par_GrupoID);

	set Var_EstGrupo := (select EstatusCiclo from GRUPOSCREDITO
							where GrupoID=Par_GrupoID);

	set Var_Cliente := (select ClienteID from INTEGRAGRUPOSCRE
							where SolicitudCreditoID = Par_SolicitudCreditoID);

	set Var_Prospecto := (select ProspectoID from INTEGRAGRUPOSCRE
							where SolicitudCreditoID = Par_SolicitudCreditoID);

	set Var_EstSolicitud := (select Estatus from SOLICITUDCREDITO
							where SolicitudCreditoID = Par_SolicitudCreditoID);

	set Var_Cargo :=(select Cargo from INTEGRAGRUPOSCRE
						 where SolicitudCreditoID = Par_SolicitudCreditoID);

	set Var_Credito := (select Estatus from  CREDITOS
						where SolicitudCreditoID = Par_SolicitudCreditoID);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
					BEGIN
						SET Par_NumErr = 999;
						SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
												 'estamos trabajando para resolverla. Disculpe las molestias que ',
												 'esto le ocasiona. Ref: SP-INTEGRAGRUPOSCREMOD');
						SET Var_Control = 'sqlException' ;
					END;

		if(ifnull(Par_GrupoID,Entero_Cero)) = Entero_Cero then
				set Par_NumErr  := 001;
				set Par_ErrMen  := 'El Grupo Esta Vacio';
				set Var_Control := 'grupoID';
			LEAVE ManejoErrores;
		end if;

		if(not exists(select GrupoID
						from GRUPOSCREDITO
							where GrupoID = GrupoID)) then
				set Par_NumErr  := 002;
				set Par_ErrMen  := 'El Grupo No Existe';
				set Var_Control := 'grupoID';
				LEAVE ManejoErrores;
		end if;

		if(not exists(select UsuarioID
						from USUARIOS
							where UsuarioID = Aud_Usuario)) then
				set Par_NumErr  := 003;
				set Par_ErrMen  := 'El Numero de Usuario no Existe';
				set Var_Control := 'grupoID';
				LEAVE ManejoErrores;
		end if;

		if(Par_Cargo=Entero_Cero)then
				set Par_NumErr  := 004;
				set Par_ErrMen  := 'El Cargo no Debe Estar Vacio';
				set Var_Control := 'grupoID';
			LEAVE ManejoErrores;
		end if;


		if(Var_EstSolicitud = SolRechazada and Par_Cargo!=CargoIntegrante)then
				set Par_NumErr  := 005;
				set Par_ErrMen  := 'No se Permite Cambiar Puestos a Solicitudes Rechazadas';
				set Var_Control := 'grupoID';
				LEAVE ManejoErrores;
		end if;

		if(Var_EstSolicitud = SolCancelada and Par_Cargo!=CargoIntegrante)then
				set Par_NumErr  := 006;
				set Par_ErrMen  := 'No se Permite Cambiar Puestos a Solicitudes Canceladas';
				set Var_Control := 'grupoID';
				LEAVE ManejoErrores;
		end if;


		if(Var_NumSolicitud = 1 and Var_EstGrupo=EstGrupoCerrado
					and Par_Cargo!=CargoPresidente)then
				set Par_NumErr  := 007;
				set Par_ErrMen  := 'El Puesto del Integrante Debe ser Presidente';
				set Var_Control := 'grupoID';
				LEAVE ManejoErrores;
		end if;

		IF EXISTS (SELECT SolicitudCreditoID  FROM INTEGRAGRUPOSCRE Cre
					WHERE SolicitudCreditoID = Par_SolicitudCreditoID
						AND Cargo != Par_Cargo)THEN

			call FOLIOSAPLICAACT('HISPUESTOSGPOCRE', Var_HisPuestoGpoID);
			Set Aud_FechaActual := now();

			insert into HISPUESTOSGPOCRE(
				HisPuestoGpoCreID, 	GrupoID,        ClienteID, 			ProspectoID,
				Ciclo, 				Cargo,			FechaRegistro, 		UsuarioRegistro,
				EmpresaID,    		Usuario,		FechaActual,      	DireccionIP,
				ProgramaID,   		Sucursal,     	NumTransaccion)
				values (
				Var_HisPuestoGpoID, Par_GrupoID,    Var_Cliente, 		Var_Prospecto,
				Par_Ciclo, 			Var_Cargo,		FechaRegistra, 		UsuarioRegistra,
				Par_EmpresaID,    	Aud_Usuario,	Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,   	Aud_Sucursal,   Aud_NumTransaccion);


			update INTEGRAGRUPOSCRE set
						Cargo = Par_Cargo
				where SolicitudCreditoID = Par_SolicitudCreditoID;
		END IF;

			set Par_NumErr  := 000;
			set Par_ErrMen  :=  concat("Puestos Actualizados Exitosamente: ", convert(Par_GrupoID, CHAR));
			set Var_Control := 'grupoID';
			set Entero_Cero := Par_GrupoID;

	END ManejoErrores;

	if (Par_Salida = SalidaSI) then
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Entero_Cero as consecutivo;
	end if;

END TerminaStore$$