-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSCREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSCREDITOACT`;
DELIMITER $$


CREATE PROCEDURE `GRUPOSCREDITOACT`(
/*ACTUALIZA LOS GRUPOS*/
    Par_GrupoID         int(10),		-- ID del grupo
    Par_TipoAct         int(11),		-- Tipo de actualizacion

    Par_Salida          char(1),		-- indica una salida
    inout Par_NumErr    int(11),		-- numero de error
    inout Par_ErrMen    varchar(400),	-- mensaje de error

    Aud_EmpresaID       int(11),		-- Auditoria
    Aud_Usuario         int(11),        -- Auditoria
    Aud_FechaActual     datetime,       -- Auditoria
    Aud_DireccionIP     varchar(15),    -- Auditoria
    Aud_ProgramaID      varchar(50),	-- Auditoria
    Aud_Sucursal        int(11),        -- Auditoria
    Aud_NumTransaccion  bigint(20)      -- Auditoria
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE FechaUlt          	datetime;
	DECLARE Var_Ciclo          	int;
	DECLARE Var_EstGrupo      	char(1);
	DECLARE Var_MaxIntegran 	int; 		-- Se usa para obtener los datos de maximo de integrantes para comparar y validar los grupos de credito
	DECLARE Var_MinIntegran  	int; 		-- Se usa para obtener los datos de minimo de integrantes para comparar y validar los grupos de credito
	DECLARE Var_MaxHombres 		int;  		-- Se usa para obtener los datos de maximo de hombres para comparar y validar los grupos de credito
	DECLARE Var_MinHombres  	int;  		-- Se usa para obtener los datos de minimo de hombres para comparar y validar los grupos de credito
	DECLARE Var_MaxMujeres   	int;  		-- Se usa para obtener los datos de maximo de mujeres para comparar y validar los grupos de credito
	DECLARE Var_MinMujeres    	int;  		-- Se usa para obtener los datos de minimo de mujeres para comparar y validar los grupos de credito
	DECLARE Var_MaxMujeresS 	int;  		-- Se usa para obtener los datos de maximo de mujeres solteras para comparar y validar los grupos de credito
	DECLARE Var_MinMujeresS  	int;  		-- Se usa para obtener los datos de minimo de mujeres solteras para comparar y validar los grupos de credito
	DECLARE Var_TotalInteg      int; 		-- Se usa para obtener los datos total de integrates para comparar y validar los grupos de credito
	DECLARE Var_TotaHomb      	int;  		-- Se usa para obtener los datos total de hombres para comparar y validar los grupos de credito
	DECLARE Var_TotaMujer       int;  		-- Se usa para obtener los datos total de mujeres para comparar y validar los grupos de credito
	DECLARE Var_TotaMujerS     	int;  		-- Se usa para obtener los datos total de mujeres solteras para comparar y validar los grupos de credito
	DECLARE Var_Presidente     	int;  		-- Se usa para obtener al presidente del grupo
	DECLARE Var_Secretario     	int;  		-- Se usa para obtener al tesorero del grupo
	DECLARE Var_Tesorero     	INT;  		-- Se usa para obtener al secretario del grupo
	DECLARE Ver_CrePaga         int;
	DECLARE Var_Control          varchar(30);
	DECLARE Var_ProducCredID    int;
	DECLARE Var_ReqAvales       char(1);
	DECLARE Num_CredActual      int;
	DECLARE Var_CicloActual     int;
	-- Declaracion Variables CURSORINTEGRA
	DECLARE VarAv_Grupo         int;
	DECLARE VarAv_Solicitud     bigint;
	DECLARE Var_SolEstatus      char(1);
	-- Declaracion de Constantes
	declare Entero_Cero     	int;
	declare Cadena_Vacia        char(1);
	declare Fecha_Vacia     	date;
	declare SalidaSI        	char(1);
	declare SalidaNO       	 	char(1);
	declare Gru_Abierto     	char(1);
	declare Gru_Cerrado     	char(1);
	declare Gru_NoIniciado  	char(1);
	declare Act_Inicia      	int;
	declare Act_Cierra      	int;
	declare Est_Act         	char;
	declare Est_SolCancela  	char;
	declare Est_Pagado      	char(1);
	declare Var_EstatusAut  	char(1);
	declare Integ_Activo    	char(1);
	declare Si_Prorratea    	char(1);
	declare Sex_F  				char(1);
	declare Sex_M  				char(1);
	declare EdoSoltero  		char(2);
	declare Tipo_Presidente 	int;
	declare Tipo_Tesorero 		int;
	declare Tipo_Secretario 	int;
    DECLARE Act_CierraAgro		INT;
	DECLARE CLI_SFG      			INT(11);
	DECLARE Cli_Especifi			INT(11);
	DECLARE Var_FechaSistema		DATE;		-- Fecha del sistema
	DECLARE Var_FechaSistemaHora	DATETIME;	-- Fecha del sistema con Hora

	DECLARE  CURSORINTEGRA  CURSOR FOR
		SELECT  Ing.GrupoID,    Ing.SolicitudCreditoID, Sol.Estatus
			FROM INTEGRAGRUPOSCRE Ing,
				 SOLICITUDCREDITO Sol
			WHERE Ing.GrupoID               = Par_GrupoID
			  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
			  AND Ing.Estatus               = Integ_Activo;

	-- Asignacion de Constantes
	Set Entero_Cero     	:= 0;
	Set Cadena_Vacia       	:= '';
	Set Fecha_Vacia     	:= '1900-01-01';
	Set SalidaSI        	:= 'S';            -- Salida del Store: SI
	Set SalidaNO        	:= 'N';            -- Salida del Store: NO
	Set Gru_Abierto     	:= 'A';            -- Estatus del Ciclo: Abierto
	Set Gru_Cerrado     	:= 'C';            -- Estatus del Ciclo: Cerrado
	Set Gru_NoIniciado  	:= 'N';            -- Estatus del Ciclo: No Iniciado
	Set Act_Inicia      	:= 1;              -- Tipo de Actualizacion: Inicio del Ciclo
	Set Act_Cierra      	:= 2;              -- Tipo de Actualizacion: Cerrar el Ciclo
	Set Est_Act         	:= 'A';            -- Estatus de la Solicitud de Credito: Activa o Autorizada
	Set Est_Pagado      	:= 'P';            -- Estatus del Credito: Pagado
	Set Est_SolCancela  	:= 'C';            -- Estatus de la Solicitud de Credito: Cancelada
	Set Var_EstatusAut  	:= 'U';            -- Estatus de la Asignacion del Aval: Autorizado
	Set Integ_Activo    	:= 'A';            -- Integrante de la Solicitud: Activo
	Set Si_Prorratea    	:= 'S';            -- Si Prorratea el Pago
	Set Sex_F			    := 'F'; 		   -- Sexo Femenino
	Set Sex_M			    := 'M'; 		   -- Sexo maculino
	Set EdoSoltero		 	:= 'S'; 		   -- Estado Civil asignado como soltero
	Set Tipo_Presidente 	:= 1;   		   -- Presidente del grupo
	Set Tipo_Tesorero   	:= 2;   		   -- Tesorero del grupo
	Set Tipo_Secretario 	:= 3;   		   -- Secretario del grupo
	SET Act_CierraAgro		:= 3;			   -- Cierre grupo agropecuario
	SET CLI_SFG				:= 29;				-- Cliente especifico Santa Fe
	SET Cli_Especifi  		:= 0;	 			-- Cliente especifico por default
	SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FechaSistemaHora := CONCAT(Var_FechaSistema,' ',SUBSTRING(NOW(),12));

ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-GRUPOSCREDITOACT');
				SET Var_Control:= 'SQLEXCEPTION';
			END;


		if(ifnull(Par_GrupoID, Entero_Cero)) = Entero_Cero then
			set Par_NumErr	:= '001';
			set Par_ErrMen	:= 'El Numero de Grupo esta vacio';
			set Var_Control	:= 'nombreGrupo' ;
			LEAVE ManejoErrores;
		end if;

		Set FechaUlt	:=	CURRENT_TIMESTAMP();

		-- Tipo de Actualizacion de Inicio de Ciclo del Grupo
		if(Par_TipoAct = Act_Inicia) then

			-- Obtenemos el Numero de Ciclo Actual
			select CicloActual, EstatusCiclo into Var_Ciclo, Var_EstGrupo
				from GRUPOSCREDITO
			where GrupoID   = Par_GrupoID;

			set Var_CicloActual := Var_Ciclo;
			set Var_Ciclo   	:= ifnull(Var_Ciclo, Entero_Cero) + 1;
			set Var_CicloActual := ifnull(Var_CicloActual, Entero_Cero);
			set Var_EstGrupo    := ifnull(Var_EstGrupo, Cadena_Vacia);

			-- Es el 1er Ciclo
			if (Var_Ciclo = 1 ) then

				if(Var_EstGrupo != Gru_NoIniciado) then
					set Par_NumErr	:= '30';
					set Par_ErrMen	:= 'El Estatus Actual del Grupo debe ser No Iniciado';
					set Var_Control	:= 'grupoID' ;
					LEAVE ManejoErrores;
				end if;
			else
				if(Var_EstGrupo != Gru_Cerrado) then
					set Par_NumErr	:= '31';
					set Par_ErrMen	:= 'El Estatus Actual del Grupo debe ser Cerrado';
					set Var_Control	:= 'grupoID' ;
					LEAVE ManejoErrores;
				end if;
			end if;

			-- -----------------------------------------------------------
			-- Actualizamos el Estatus y Ciclo Actual
			update GRUPOSCREDITO set
				CicloActual     = ifnull(CicloActual, Entero_Cero) + 1,
				CicloPonderado  = Entero_Cero,
				EstatusCiclo    = Gru_Abierto,
				FechaUltCiclo   = Var_FechaSistemaHora,

				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion

			where GrupoID	=	Par_GrupoID;
			-- -----------------------------------------------------------
			-- Mandamos a Historico la Relacion de los Integrantes Actuales



			INSERT INTO `HIS-INTEGRAGRUPOSCRE`	(
					`GrupoID`,					`SolicitudCreditoID`,					`ClienteID`,					`ProspectoID`,					`Estatus`,
					`ProrrateaPago`,			`FechaRegistro`,						`Ciclo`,						`Cargo`,						`EmpresaID`,
					`Usuario`,					`FechaActual`,							`DireccionIP`,					`ProgramaID`,					`Sucursal`,		`NumTransaccion`)
				select  GrupoID,        SolicitudCreditoID, ClienteID,      ProspectoID,
						Estatus,        ProrrateaPago,      FechaRegistro,  Var_CicloActual,
						Cargo,          EmpresaID,          Usuario,        FechaActual,
						DireccionIP,    ProgramaID,         Sucursal,       NumTransaccion
			from INTEGRAGRUPOSCRE
				where GrupoID = Par_GrupoID;

			-- -----------------------------------------------------------
			-- Dejamos el Grupo Actual Vacio (Sin Integrantes)
			delete from INTEGRAGRUPOSCRE
				where GrupoID = Par_GrupoID;

		end if; -- End del tipo de Actualizacion de Iniciar Grupo

		-- Tipo de Actualizacion: Cerrar el Grupo
		if(Par_TipoAct = Act_Cierra) then

			-- Obtenemos el Total de Integrantes, asi como los limites de minimo y maximo de acuerdo al producto
			select	max(Pro.MaxIntegrantes),	max(Pro.MinIntegrantes),	max(Pro.MaxMujeres),		max(Pro.MinMujeres),			max(Pro.MaxMujeresSol),
					max(Pro.MinMujeresSol),		max(Pro.MaxHombres),		max(Pro.MinHombres),		count(Ing.SolicitudCreditoID),	max(Pro.ProducCreditoID),
					max(RequiereAvales)
			into 	Var_MaxIntegran,			Var_MinIntegran,			Var_MaxMujeres,				Var_MinMujeres,					Var_MaxMujeresS,
					Var_MinMujeresS,			Var_MaxHombres,				Var_MinHombres,				Var_TotalInteg,					Var_ProducCredID,
                    Var_ReqAvales
				from	INTEGRAGRUPOSCRE Ing,
						PRODUCTOSCREDITO Pro,
						SOLICITUDCREDITO Sol,
						CLIENTES Cli
			where 	Ing.GrupoID               = Par_GrupoID
				and Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
					and Sol.ProductoCreditoID = Pro.ProducCreditoID
						and Sol.Estatus = Est_Act
							and Ing.Estatus = Integ_Activo
								and Sol.ClienteID = Cli.ClienteID
								group by Ing.GrupoID;

			-- se obtiene el numero de mujeres solteras
			select count(Ing.ClienteID) into Var_TotaMujerS
				from	CLIENTES Cli,
						INTEGRAGRUPOSCRE Ing,
						SOLICITUDCREDITO Sol
				where	Ing.SolicitudCreditoID  = Sol.SolicitudCreditoID
					and Sol.ClienteID= Cli.ClienteID
						and Ing.ClienteID= Sol.ClienteID
							and Sol.Estatus= Est_Act
								and Ing.Estatus= Integ_Activo
									and Cli.Sexo = Sex_F
										and Cli.EstadoCivil= EdoSoltero
											and Ing.GrupoID= Par_GrupoID;


			-- se obtiene el numero de mujeres
			select  count(Ing.ClienteID)  into Var_TotaMujer
				from	INTEGRAGRUPOSCRE Ing,
						SOLICITUDCREDITO Sol,
						CLIENTES Cli
				where Ing.GrupoID= Par_GrupoID
					and Ing.SolicitudCreditoID  = Sol.SolicitudCreditoID
						and Sol.ClienteID= Cli.ClienteID
							and Ing.ClienteID= Sol.ClienteID
								and Sol.Estatus = Est_Act
									and Ing.Estatus= Integ_Activo
										and Cli.Sexo= Sex_F;

			-- se obtiene el numero de hombres
			select  count(Ing.ClienteID)  into Var_TotaHomb
				from	INTEGRAGRUPOSCRE Ing,
						SOLICITUDCREDITO Sol,
						CLIENTES Cli
				where Ing.GrupoID               = Par_GrupoID
					and Ing.SolicitudCreditoID  = Sol.SolicitudCreditoID
					and Sol.ClienteID			= Cli.ClienteID
					and Ing.ClienteID			= Sol.ClienteID
					and Sol.Estatus             = Est_Act
					and Ing.Estatus             = Integ_Activo
					and Cli.Sexo 				= Sex_M;

			-- se obtiene al presidente del grupo
			select  Ing.Cargo into Var_Presidente
				from	INTEGRAGRUPOSCRE Ing,
						SOLICITUDCREDITO Sol
			where Ing.GrupoID               = Par_GrupoID
				and Ing.SolicitudCreditoID  = Sol.SolicitudCreditoID
				and Ing.Cargo               =  Tipo_Presidente
				and Sol.Estatus             = Est_Act
				and Ing.Estatus             = Integ_Activo;

			-- se obtiene al tesorero del grupo
			select  Ing.Cargo into Var_Tesorero
				from	INTEGRAGRUPOSCRE Ing,
						SOLICITUDCREDITO Sol
			where Ing.GrupoID               = Par_GrupoID
				and Ing.SolicitudCreditoID  = Sol.SolicitudCreditoID
				and Ing.Cargo               =  Tipo_Tesorero
				and Sol.Estatus             = Est_Act
				and Ing.Estatus             = Integ_Activo;

			-- se obtiene al secretario del grupo
			select  Ing.Cargo into Var_Secretario
				from	INTEGRAGRUPOSCRE Ing,
						SOLICITUDCREDITO Sol
			where Ing.GrupoID               = Par_GrupoID
				and Ing.SolicitudCreditoID  = Sol.SolicitudCreditoID
				and Ing.Cargo               =  Tipo_Secretario
				and Sol.Estatus             = Est_Act
				and Ing.Estatus             = Integ_Activo;

			set Var_MinIntegran     := ifnull(Var_MinIntegran, Entero_Cero);
			set Var_MaxIntegran     := ifnull(Var_MaxIntegran, Entero_Cero);
			-- Minimo y Maximo de mujeres M, mujeres solteras MS y hombres H
			set Var_MinMujeres		:= ifnull(Var_MinMujeres, Entero_Cero);
			set Var_MaxMujeres		:= ifnull(Var_MaxMujeres, Entero_Cero);
			set Var_MinMujeresS		:= ifnull(Var_MinMujeresS, Entero_Cero);
			set Var_MaxMujeresS		:= ifnull(Var_MaxMujeresS, Entero_Cero);
			set Var_MinHombres		:= ifnull(Var_MinHombres, Entero_Cero);
			set Var_MaxHombres	   	:= ifnull(Var_MaxHombres, Entero_Cero);
			set Var_TotalInteg		:= ifnull(Var_TotalInteg, Entero_Cero);
			set Var_TotaMujerS		:= ifnull(Var_TotaMujerS, Entero_Cero);
			set Var_TotaMujer		:= ifnull(Var_TotaMujer, Entero_Cero);
			set Var_TotaHomb		:= ifnull(Var_TotaHomb, Entero_Cero);
			set Var_Presidente    	:= ifnull(Var_Presidente, Entero_Cero);
			set Var_Tesorero      	:= ifnull(Var_Tesorero, Entero_Cero);
			set Var_Secretario    	:= ifnull(Var_Secretario, Entero_Cero);

			if(Var_MinIntegran = Entero_Cero)   then
				set Par_NumErr	:=	'003';
				set Par_ErrMen	:=	concat("No hay Integrantes Autorizados Asociados al Grupo" , Par_GrupoID);
				set Var_Control	:=	'nombreGrupo' ;
				LEAVE ManejoErrores;
			end if;

			if(Var_TotalInteg < Var_MinIntegran)then
				set Par_NumErr :='004';
				set Par_ErrMen := concat("Minimo ", Var_MinIntegran," integrantes Autorizados para el Grupo ",Par_GrupoID);
				set Var_Control:= 'nombreGrupo' ;
				LEAVE ManejoErrores;
			end if;

			if(Var_TotalInteg > Var_MaxIntegran) then
				set Par_NumErr :='005';
				set Par_ErrMen := concat("Maximo ", Var_MaxIntegran," integrantes Autorizados para el grupo ",Par_GrupoID);
				set Var_Control:= 'nombreGrupo' ;
				LEAVE ManejoErrores;
			end if;

			if(Var_TotaHomb > Var_MaxHombres) then
				set Par_NumErr :='006';
				set Par_ErrMen := concat("Maximo ", Var_MaxHombres," de hombres que sean integrantes Autorizados para el grupo ",Par_GrupoID);
				set Var_Control:= 'nombreGrupo' ;
				LEAVE ManejoErrores;
			end if;

			if(Var_TotaHomb < Var_MinHombres) then
				set Par_NumErr :='007';
				set Par_ErrMen := concat("Minimo ", Var_MinHombres," integrante(s) hombre(s) Autorizado(s) para el grupo ",Par_GrupoID);
				set Var_Control:= 'nombreGrupo' ;
				LEAVE ManejoErrores;
			end if;

			if(Var_TotaMujer > Var_MaxMujeres) then
				set Par_NumErr :='008';
				set Par_ErrMen := concat("Maximo ", Var_MaxMujeres," integrante(s) mujer(es) Autorizado(s) para el grupo  ",Par_GrupoID);
				set Var_Control:= 'nombreGrupo' ;
				LEAVE ManejoErrores;
			end if;

			if(Var_TotaMujer < Var_MinMujeres) then
				set Par_NumErr :='009';
				set Par_ErrMen := concat("Minimo ", Var_MinMujeres," integrante(s) mujer(es) Autorizado(s) para el grupo ",Par_GrupoID);
				set Var_Control:= 'nombreGrupo' ;
				LEAVE ManejoErrores;
			end if;

			if(Var_TotaMujerS > Var_MaxMujeresS) then
				set Par_NumErr :='010';
				set Par_ErrMen := concat("Maximo ", Var_MaxMujeresS," integrante(s) mujer(es) soltera(s) Autorizado(s) para el grupo",Par_GrupoID);
				set Var_Control:= 'nombreGrupo' ;
				LEAVE ManejoErrores;
			end if;

			if(Var_TotaMujerS < Var_MinMujeresS) then
				set Par_NumErr :='011';
				set Par_ErrMen := concat("Minimo ", Var_MinMujeresS," integrante(s) mujer(es) soltera(s) Autorizado(s) para el grupo ",Par_GrupoID);
				set Var_Control:= 'nombreGrupo' ;
				LEAVE ManejoErrores;
			end if;

			if(Var_TotalInteg = 2)   then

				if(Var_Presidente = Entero_Cero and Var_Tesorero = Entero_Cero) then
					set Par_NumErr	:=	'012';
					set Par_ErrMen	:=	concat("Debe existir 1 Presidente y 1 Tesorero");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;

				if(Var_Presidente = Entero_Cero and Var_Tesorero = Tipo_Tesorero) then
					set Par_NumErr	:=	'013';
					set Par_ErrMen	:=	concat("Debe existir 1 Presidente");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;

				if(Var_Presidente = Tipo_Presidente and Var_Tesorero =  Entero_Cero) then
					set Par_NumErr	:=	'014';
					set Par_ErrMen	:=	concat("Debe existir 1 Tesorero");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;
			end if;

			if(Var_TotalInteg >= 3)   then
				if(Var_Presidente = Entero_Cero and Var_Tesorero = Entero_Cero and Var_Secretario=Entero_Cero) then
					set Par_NumErr	:=	'015';
					set Par_ErrMen	:=	concat("Debe Existir 1 Presidente, 1 Tesorero y 1 Secretario");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;

				if(Var_Presidente = Entero_Cero and Var_Tesorero = Entero_Cero and Var_Secretario=Tipo_Secretario) then
					set Par_NumErr	:=	'016';
					set Par_ErrMen	:=	concat("Debe existir 1 Presidente y 1 Tesorero");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;

				if(Var_Presidente = Entero_Cero and Var_Tesorero =  Tipo_Tesorero and Var_Secretario=Tipo_Secretario) then
					set Par_NumErr	:=	'017';
					set Par_ErrMen	:=	concat("Debe existir 1 Presidente");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;

				if(Var_Presidente = Tipo_Presidente and Var_Tesorero =  Entero_Cero and Var_Secretario=Entero_Cero) then
					set Par_NumErr	:=	'018';
					set Par_ErrMen	:=	concat("Debe existir 1 Tesorero y 1 Secretario");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;

				if(Var_Presidente = Tipo_Presidente and Var_Tesorero =  Tipo_Tesorero and Var_Secretario=Entero_Cero) then
					set Par_NumErr	:=	'019';
					set Par_ErrMen	:=	concat("Debe existir 1 Secretario");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;

				if(Var_Presidente = Tipo_Presidente and Var_Tesorero =  Entero_Cero and Var_Secretario=Tipo_Secretario) then
					set Par_NumErr	:=	'020';
					set Par_ErrMen	:=	concat("Debe existir 1 Tesorero");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;

				if(Var_Presidente = Entero_Cero and Var_Tesorero =  Tipo_Tesorero and Var_Secretario=Entero_Cero) then
					set Par_NumErr	:=	'021';
					set Par_ErrMen	:=	concat("Debe existir 1 Presidente y 1 Secretario");
					set Var_Control	:=	'nombreGrupo' ;
					LEAVE ManejoErrores;
				end if;
			end if;

			-- Abrimos el Cursor de Integrantes con Solicitud Autorizada
			Open CURSORINTEGRA;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
						CICLO: LOOP
					Fetch CURSORINTEGRA  Into
						VarAv_Grupo, VarAv_Solicitud, Var_SolEstatus;

						if(Var_SolEstatus != Est_Act and Var_SolEstatus != Est_SolCancela ) then

							set Par_NumErr :='012';
							set Par_ErrMen := concat("La Solicitud ", convert(VarAv_Solicitud, char),
											  ", esta pendiente de ser Autorizada o Cancelada.");
							set Var_Control:= 'nombreGrupo';

					LEAVE CICLO;
					end if;

					call AVALESPORGRUPOPRO(
						VarAv_Grupo,        VarAv_Solicitud,    Var_TotalInteg,          Var_ProducCredID,
						Var_ReqAvales,      SalidaNO,           Par_NumErr,         	 Par_ErrMen,
						Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,
						Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

					if (Par_NumErr <> Entero_Cero)then
						LEAVE CICLO;
					end if;
				End LOOP CICLO;
			END;
			Close CURSORINTEGRA;    -- Fin del Cursor

			-- Si hubo Errores en el Cursor Previo, entonces Salimos
			if (Par_NumErr <> Entero_Cero)then
				LEAVE ManejoErrores;
			end if;

			-- Actualizamos el Estatus del Grupo a: Cerrado
			update GRUPOSCREDITO set
				EstatusCiclo    = Gru_Cerrado,

				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
			where GrupoID	=	Par_GrupoID;

			-- Actualizamos las Solicitudes con el Grupo y Ciclo
			update SOLICITUDCREDITO Sol, INTEGRAGRUPOSCRE Ing, GRUPOSCREDITO Gru set
				Sol.GrupoID = Gru.GrupoID,
				Sol.CicloGrupo = Gru.CicloActual
			where Gru.GrupoID	= Par_GrupoID
				and Ing.GrupoID   = Gru.GrupoID
				and Sol.SolicitudCreditoID = Ing.SolicitudCreditoID
				and Ing.Estatus   = Integ_Activo
				and Sol.Estatus   = Est_Act;
		end if;

        		-- Tipo de Actualizacion: Cerrar el Grupo
		if(Par_TipoAct = Act_CierraAgro) then
			-- Abrimos el Cursor de Integrantes con Solicitud Autorizada
			Open CURSORINTEGRA;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
						CICLO: LOOP
					Fetch CURSORINTEGRA  Into
						VarAv_Grupo, VarAv_Solicitud, Var_SolEstatus;

						if(Var_SolEstatus != Est_Act and Var_SolEstatus != Est_SolCancela ) then

							set Par_NumErr :='012';
							set Par_ErrMen := concat("La Solicitud ", convert(VarAv_Solicitud, char),
											  ", esta pendiente de ser Autorizada o Cancelada.");
							set Var_Control:= 'nombreGrupo';

					LEAVE CICLO;
					end if;

				End LOOP CICLO;
			END;
			Close CURSORINTEGRA;    -- Fin del Cursor

			-- Si hubo Errores en el Cursor Previo, entonces Salimos
			if (Par_NumErr <> Entero_Cero)then
				LEAVE ManejoErrores;
			end if;

			-- Actualizamos el Estatus del Grupo a: Cerrado
			update GRUPOSCREDITO set
				EstatusCiclo    = Gru_Cerrado,

				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
			where GrupoID	=	Par_GrupoID;

			-- Actualizamos las Solicitudes con el Grupo y Ciclo
			update SOLICITUDCREDITO Sol, INTEGRAGRUPOSCRE Ing, GRUPOSCREDITO Gru set
				Sol.GrupoID = Gru.GrupoID,
				Sol.CicloGrupo = Gru.CicloActual
			where Gru.GrupoID	= Par_GrupoID
				and Ing.GrupoID   = Gru.GrupoID
				and Sol.SolicitudCreditoID = Ing.SolicitudCreditoID
				and Ing.Estatus   = Integ_Activo
				and Sol.Estatus   = Est_Act;
		end if;


		set	Par_NumErr  := Entero_Cero;
		set	Par_ErrMen  := concat("El Ciclo del Grupo ",Par_GrupoID," se ha Actualizado");
		SET Var_Control := 'grupoID';

END ManejoErrores;  -- End del Handler de Errores

if	(Par_Salida = SalidaSI) then
		select 	Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Par_GrupoID as consecutivo;
end if;

END TerminaStore$$
