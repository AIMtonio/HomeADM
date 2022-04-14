-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAAUTFIRMAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAAUTFIRMAALT`;

DELIMITER $$
CREATE PROCEDURE `ESQUEMAAUTFIRMAALT`(
  # ========================================================================================================================
  # --------------------- SP PARA AUTORIZAR FIRMAS DE COMITE Y AUTORIZAR SOLICITUD DE CREDITO ------------------------------
  # ========================================================================================================================
  Par_Solicitud     	BIGINT(20),     # Numero de la Solicitud de Credito
  Par_Esquema       	INT(11),      # Numero de Esquema de Autorizacion de la Solicitud de Credito
  Par_NumFirma      	INT(11),      # Numero de Firma de Autorizacion de la Solicitud de Credito
  Par_Organo        	INT(11),      # Numero de Organo de Autorizacion de la Solicitud de Credito
  Par_MontoAutor      	DECIMAL(18,2),  # Monto Autorizado de la Solicitud de Credito

  Par_AporteCli     	DECIMAL(18,2),	# Monto de Aportacion del Cliente de la Solicitud de Credito
  Par_ComentMesaControl	VARCHAR(500),   # Comentario Mesa de Control
  Par_Salida        	CHAR(1),      # Parametro de Salida
  INOUT Par_NumErr   	INT,        # Numero de Error
  INOUT Par_ErrMen    	VARCHAR(400),   # Descripcion de Error

  # Parametros de Auditoria
  Aud_Empresa       	INT(11) ,
  Aud_Usuario       	INT(11) ,
  Aud_FechaActual     	DATETIME,
  Aud_DireccionIP     	VARCHAR(15),
  Aud_ProgramaID      	VARCHAR(50),
  Aud_SucursalID      	INT(11) ,
  Aud_NumTransaccion    BIGINT(20)

	)
TerminaStore:BEGIN

	# Declaracion de Variables
	DECLARE Var_FechaSistema    	DATE;     # Almacena la Fecha del Sistema
	DECLARE Var_OrganoDescri    	VARCHAR(100); # Almacena el Organo facultado para la Autorizacion de la Solicitud de Credito
	DECLARE Var_NumFirmaOto     	INT(11);    # Almacena el Numero de Firmas Otorgadas
	DECLARE Var_NumTransaccion    	BIGINT(20);   # Almacena el Numero de Transaccion
	DECLARE Var_EstatusSolici   	CHAR(1);    # Almacena el Estatus de la Solicitud

	DECLARE Var_CicloActual    		INT(11);    # Almacena el Ciclo Actual del Credito
	DECLARE Var_Cliente       		INT(11);    # Almacena el Numero del Cliente
	DECLARE Var_Prospecto     		INT(11);    # Almacena el Numero del Prospecto
	DECLARE Var_Esquema       		INT(11);    # Almacena el Numero del Esquema
	DECLARE Var_MontoSolicitado   	DECIMAL(18,2);  # Almacena el Monto Solicitado
	DECLARE Var_MontoMaximo     	DECIMAL(18,2);  # Almacena el Monto Maximo de la Solicitud

	DECLARE Var_EsGrupal      		CHAR(1);    # Indica si el Producto de Credito es Grupal
	DECLARE Var_NumGrupo      	  	INT(11);    # Almacena el Numero de Grupo
	DECLARE Var_SucursalSolici    	INT(11);    # Almacena el Numero de Sucursal de la Solicitud de Credito
	DECLARE Var_SucursalUsuario   	INT(11);    # Almacena el Numero de Sucursal del Usuario
	DECLARE Var_EstatusUsuario    	CHAR(1);    # Almacena el Estatus del Usuario

	DECLARE Var_CantFirmasReq   	INT(11);    # Almacena la Cantidad de Firmas Requeridas
	DECLARE Var_CantFirmasOto   	INT(11);    # Almacena la Cantidad de Firmas Otorgadas
	DECLARE Var_PuestoUsuario   	VARCHAR(10);  # Almacena el Puesto del Usuario
	DECLARE Var_EstatusPuesto  	 	CHAR(1);    # Almacena el Estatus del Puesto del Usuario
	DECLARE Var_AtiendeSucursales 	CHAR(1);    # Indica si el Usuario atiende Sucursales

	DECLARE Var_TipoActualizaSol  	INT(11);    # Almacena el Tipo de Actualizacion de la Solicitud de Credito
	DECLARE Var_ComentariosMesaCont VARCHAR(6000);  # Almacena el Comentario de la Mesa de Control
	DECLARE Var_Producto      		INT(11);    # Almacena el Numero de Producto de Credito
	DECLARE Var_CicloBase           INT(11);    # Almacena el Ciclo Base del Cliente
	DECLARE Var_Control         	CHAR(20);   # Almacena el Elmento que es Incorrecto

	DECLARE Var_TipoCredito    	 	CHAR(1);    # Almacena el Tipo de credito: NUEVO, RENOVACION, REESTRUCTURA
	DECLARE Var_NumDiasAtraOri    	INT(11);    # Almacena el Numero de Dias de Atraso del Credito
	DECLARE Var_NumRenovacion   	INT(5);     # Almacena el Numero de Renovacion sobre el Credito Original
	DECLARE Var_SaldoExigible   	DECIMAL(14,2);  # Almacena el Saldo Exigible del Credito
	DECLARE Var_EstatusCrea     	CHAR(1);    # Almacena el Estatus de Creacion del Credito

	DECLARE Var_NumPagoSostenido  	INT(5);     # Almacena el Numero de Pagos Sostenidos
	DECLARE Var_EstRelacionado    	CHAR(1);    # Almacena el Estatus del Credito Relacionado
	DECLARE Var_PeriodCap     		INT(11);    # Almacena el Periodo de Capital del Credito
	DECLARE Var_PeriodCapSol    	INT(11);    # Almacena el Periodo de Capital de la Solicitud
	DECLARE Var_Relacionado    		BIGINT(12);   # Almacena el Numero de Credito Relacionado

	DECLARE Var_CliProEsp       	INT;      # Almacena el Numero de Cliente para Procesos Especificos
	DECLARE Var_EsquemaID         	INT;      # Almacena el Maximo Esquema del Producto de Credito
	DECLARE Var_FrecCapital     	CHAR(1);    # Almacena la frecuencia de Capital
	DECLARE Var_FrecInteres     	CHAR(1);    # Almacena la frecuencia de Interes
	DECLARE Var_MontoReg      		DECIMAL(12,2);  # Almacena el Monto que corresponde al 20% del Monto Original
	DECLARE Var_PeriodInt     		INT(11);    # Almacena la Periodicidad del Interes
	DECLARE Var_EvaluaRiesgoComun 	CHAR(1);    # Indica si evalua riesgo comun
	DECLARE Var_CapitalContableNeto DECIMAL(14,2);  # Indica el monto de capital contable (Riesgo Comun)
	DECLARE Var_MontoCreditosRiesgo	DECIMAL(14,2);  # Monto Total de Creditos en Riesgo

	DECLARE Var_EsAgropecuario		CHAR(1);		# Define si la solicitud de credito es de un producto de credito agropecuario
	DECLARE Var_TipoFondeo			CHAR(1);		# Tipo de Fondeo R:Recursos Propios   F:Institucion de Fondeo

	DECLARE Par_CreditoFonID		BIGINT(20);
	DECLARE Var_EstCredPas			CHAR(1);
	DECLARE Var_TipoPersona			CHAR(1);		# Indica el tipo de persona que realiza la solicitud
	DECLARE Var_PorcPersonaFisica	DECIMAL(12,2);
	DECLARE Var_PorcPersonaMoral	DECIMAL(12,2);
	DECLARE Var_ParticipanteID		BIGINT(20);			-- Numero de Participante
	DECLARE Var_TipoParticipante	CHAR(1);			-- Tipo de Participante
	DECLARE Var_RequiereCheckList 	CHAR(1);			-- Requiere Check List

	# Declaracion de Constantes
	DECLARE Cadena_Vacia      		CHAR(1);
	DECLARE Fecha_Vacia      		DATETIME;
	DECLARE Entero_Cero       		INT(11);
	DECLARE Str_SI          		CHAR(1);
	DECLARE Str_NO          		CHAR(1);

	DECLARE Sol_StaInactiva     	CHAR(1);
	DECLARE Sol_StaLiberada     	CHAR(1);
	DECLARE Sol_StaAutorizada   	CHAR(1);
	DECLARE Sol_StaCancelada    	CHAR(1);
	DECLARE Cre_StaPagado     		CHAR(1);

	DECLARE Cre_StaVigente      	CHAR(1);
	DECLARE Cre_StaVencido      	CHAR(1);
	DECLARE Usu_StaActivo     		CHAR(1);
	DECLARE Act_AutorizaSolicitud 	INT(11);
	DECLARE Act_MontoAutorizadoSol  INT(11);

	DECLARE Act_AutSolCreReest    	INT(11);
	DECLARE Usu_PuestoVigente   	CHAR(1);
	DECLARE CreReestructura     	CHAR(1);
	DECLARE Num_PagRegula     		INT(11);
	DECLARE Estatus_Alta      		CHAR(1);

	DECLARE OrigenReestructura    	CHAR(1);
	DECLARE Est_Desembolso      	CHAR(1);
	DECLARE CreRenovacion     		CHAR(1);
	DECLARE Con_CliProcEspe       	VARCHAR(20);
	DECLARE NumClienteYanga     	INT;
	DECLARE FrecUnico       		CHAR(1);
	DECLARE FrecLibre       		CHAR(1);
	DECLARE FrecPeriod        		CHAR(1);

	DECLARE Est_Vigente				CHAR(1);
	DECLARE Tipo_InstitFon			CHAR(1);
	DECLARE Est_Castigado			CHAR(1);
	DECLARE Tipo_PersonaFisica		CHAR(1);
	DECLARE Tipo_PersonaMoral		CHAR(1);
	DECLARE Tipo_PersonaActEmp		CHAR(1);
	DECLARE Ope_Participante		TINYINT UNSIGNED;	-- Numero de Operacion para obtener el ID del participante
	DECLARE Inst_SolicitudCredito	INT(11);			-- Instrumento Solicitud de Credito
	DECLARE Var_MensajeNotificacion	VARCHAR(400);		-- Mensaje de Notificacion
	DECLARE Var_FolioConsolidacionID BIGINT(12);	-- Folio de Consolidacion para creditos consolidados AGRO
	DECLARE Var_EsConsolidacionAgro CHAR(1);		-- Es consolidacion Agro
	DECLARE Var_MensajeSalida 		VARCHAR(400);


	DECLARE Var_ReqGarantia			CHAR(1);
	DECLARE Var_RelGarCred			DECIMAL(14,2);
	DECLARE Indistinto				CHAR(1);
	DECLARE Var_NumGarCap			INT(11);
	DECLARE Var_GaraInCap			INT(11); -- Almacena si se Capturaron Garantias cuando Requiere Garantias es Indistinto
	DECLARE Est_AutGaran			CHAR(1);
	DECLARE Var_SumGarAsi			DECIMAL(14,2);
	DECLARE Var_NumGarAut			INT(11);
	DECLARE Var_ResMonGaran 		DECIMAL(14,2);
	-- Declaracion de Actualizaciones
	DECLARE Act_EstCabecera			TINYINT UNSIGNED;-- Actualizacion de Cabecera de la tabla CRECONSOLIDAAGROENC
	DECLARE Est_Pagado				CHAR(1);			-- Estatus de Pagado de Credito
	DECLARE Var_RiesgoComun        INT(11);

	# Asignacion de constantes
	SET Cadena_Vacia        	:= '';          # Cadena Vacia
	SET Fecha_Vacia         	:= '1900-01-01';    # Fecha Vacia
	SET Entero_Cero         	:= 0;         # Entero Cero
	SET Str_SI            		:= 'S';         # Salida: SI
	SET Str_NO            		:= 'N';         # Salida: NO

	SET Sol_StaInactiva       	:= 'I';         # Estatus de la Solicitud: INACTIVA
	SET Sol_StaLiberada       	:= 'L';         # Estatus de la Solicitud: LIBERADA
	SET Sol_StaAutorizada     	:= 'A';         # Estatus de la Solicitud: AUTORIZADA
	SET Sol_StaCancelada      	:= 'C';         # Estatus de la Solicitud: CANCELADA
	SET Cre_StaPagado       	:= 'P';         # Estatus del Credito: PAGADO

	SET Cre_StaVigente        	:= 'V';         # Estatus del Credito: VIGENTE
	SET Cre_StaVencido        	:= 'B';         # Estatus del Credito: VENCIDO
	SET Usu_StaActivo       	:= 'A';         # Estatus del Usuario: ACTIVO
	SET Usu_PuestoVigente     	:= 'V';         # Estatus del Puesto del Usuario: VIGENTE
	SET Act_AutorizaSolicitud   := 1;         # Tipo Actualizacion: Autorizacion de Solicitud de Credito

	SET Act_MontoAutorizadoSol	:= 2;         # Tipo Actualizacion: Autorizacion del Monto Autorizado de Solicitud de Credito
	SET Act_AutSolCreReest      := 8;         # Tipo Actualizacion: Autorizacion de Solicitud de Credito de Reestructura
	SET CreReestructura       	:= 'R';         # Tipo Credito: REESTRUCTURA
	SET Num_PagRegula       	:= 3;           # Numero de pagos sostenidos requerido segun CNBV
	SET Estatus_Alta        	:= 'A';         # Estatus: ALTA para reestructura

	SET OrigenReestructura      := 'R';         # Tratamiento de credito: Reestructura
	SET Est_Desembolso        	:= 'D';         # Estatus Credito: DESEMBOLSADO
	SET CreRenovacion       	:= 'O';           # Tipo Credito: RENOVACION
	SET Con_CliProcEspe         := 'CliProcEspecifico'; # Parametro de Cliente para Procesos Especificos
	SET NumClienteYanga       	:= 3;         # Numero de Cliente Yanga para Procesos Especificos: 3


	SET Aud_FechaActual       	:= NOW();
	SET Var_FechaSistema      	:= (SELECT FechaSistema FROM PARAMETROSSIS); -- Fecha del Sistema

	SET Var_NumFirmaOto       	:= Entero_Cero;
	SET Var_OrganoDescri      	:= Cadena_Vacia;
	SET FrecUnico         		:= 'U';
	SET FrecLibre         		:= 'L';
	SET FrecPeriod          	:= 'P';   	-- Frecuencia Periodo
	SET Est_Vigente				:= 'N';		-- Estatus Vigente CREDITO PASIVO
	SET Tipo_InstitFon			:= 'F';		-- Institucion de Fondeo
	SET Est_Castigado			:= 'K';		-- Estatus Castigado
	SET Tipo_PersonaFisica		:= 'F';		-- Persona Fisica
	SET Tipo_PersonaMoral		:= 'M';		-- Persona Moral
	SET Tipo_PersonaActEmp		:= 'A';		-- Persona Fisica con Actividad Empresarial
	SET Ope_Participante		:= 1;
	SET Inst_SolicitudCredito	:= 5;
	SET Indistinto	 			:= 'I';		-- Requiere  Garantias : Indistinto
	SET Var_GaraInCap			:= 0;		-- Almacena si se Capturaron Garantias cuando Requiere Garantias es Indistinto
	SET Est_AutGaran			:= 'U';		-- Estatus de la Garantia: Autorizada
	SET Est_Pagado				:= 'P';

	-- Asignacion de Actualizaciones
	SET Act_EstCabecera			:= 2;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									 ' esto le ocasiona. Ref: SP-ESQUEMAAUTFIRMAALT');
		END;

		# Se obtiene informacion de la Solicitud de Credito
	SELECT	Sol.ClienteID,				Sol.MontoSolici,    	Pro.EsGrupal,   	Sol.SucursalID,     Sol.Estatus,
			Sol.ComentarioMesaControl,  Pro.ProducCreditoID,	Sol.TipoCredito,	Sol.Relacionado,    Sol.PeriodicidadCap,
			ProspectoID,        		FrecuenciaCap,      	FrecuenciaInt,    	PeriodicidadInt,	Pro.RequiereCheckList,
			Pro.RequiereGarantia,		Pro.RelGarantCred,		Sol.EsConsolidacionAgro
	INTO    Var_Cliente,        		Var_MontoSolicitado,  	Var_EsGrupal,     	Var_SucursalSolici,	Var_EstatusSolici,
			Var_ComentariosMesaCont,  	Var_Producto,     		Var_TipoCredito,  	Var_Relacionado,	Var_PeriodCapSol,
			Var_Prospecto,        		Var_FrecCapital,    	Var_FrecInteres,	Var_PeriodInt,		Var_RequiereCheckList,
			Var_ReqGarantia,			Var_RelGarCred,			Var_EsConsolidacionAgro
	FROM SOLICITUDCREDITO Sol
	  INNER JOIN PRODUCTOSCREDITO Pro ON Sol.ProductoCreditoID = Pro.ProducCreditoID
	WHERE SolicitudCreditoID = Par_Solicitud;

	SET Var_Cliente       		:= IFNULL(Var_Cliente, Entero_Cero);
	SET Var_MontoSolicitado   	:= IFNULL(Var_MontoSolicitado, Entero_Cero);
	SET Var_EsGrupal      		:= IFNULL(Var_EsGrupal, Cadena_Vacia);
	SET Var_SucursalSolici    	:= IFNULL(Var_SucursalSolici, Entero_Cero);
	SET Var_EstatusSolici   	:= IFNULL(Var_EstatusSolici, Cadena_Vacia);
	SET Par_ComentMesaControl	:= IFNULL(Par_ComentMesaControl, Cadena_Vacia);
	SET Var_Producto      		:= IFNULL(Var_Producto, Entero_Cero);
	SET Var_PeriodCapSol    	:= IFNULL(Var_PeriodCapSol, Entero_Cero);
	SET Var_PeriodInt     		:= IFNULL(Var_PeriodInt, Entero_Cero);
	SET	Var_PeriodCapSol		:= IFNULL(Var_PeriodCapSol, Entero_Cero);
	SET	Var_PeriodInt			:= IFNULL(Var_PeriodInt, Entero_Cero);
	SET Var_ReqGarantia			:= IFNULL(Var_ReqGarantia, Cadena_Vacia);
	SET Var_RelGarCred			:= IFNULL(Var_RelGarCred,Entero_Cero);

	SET  Var_CicloBase   := ( SELECT CicloBase FROM CICLOBASECLIPRO
							  WHERE ClienteID 	= Var_Cliente
								AND ProspectoID = Var_Prospecto
								AND  ProductoCreditoID = Var_Producto);

	SET  Var_CicloBase   := IFNULL(Var_CicloBase, Entero_Cero);

	# Se obtiene el Numero de Firma y el Organo facultado para la
		# Autorizacion de la Solicitud de Credito
	SELECT  Fir.NumFirma,     Org.Descripcion,    Fir.NumTransaccion
	INTO  	Var_NumFirmaOto,  Var_OrganoDescri,   Var_NumTransaccion
	FROM ESQUEMAAUTFIRMA Fir
	  LEFT JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
	WHERE Fir.SolicitudCreditoID = Par_Solicitud
	  AND NumFirma = Par_NumFirma;

	SET Var_NumFirmaOto   := IFNULL(Var_NumFirmaOto, Entero_Cero);
	SET Var_OrganoDescri  := IFNULL(Var_OrganoDescri, Cadena_Vacia);

		# Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);

	SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

	SELECT  EvaluaRiesgoComun,		CapitalContableNeto,		PorcPersonaFisica,		PorcPersonaMoral
	INTO  Var_EvaluaRiesgoComun,	Var_CapitalContableNeto,	Var_PorcPersonaFisica,	Var_PorcPersonaMoral
	FROM PARAMETROSSIS;

	SET Var_TipoPersona := (SELECT TipoPersona FROM CLIENTES WHERE ClienteID = Var_Cliente);

	IF (IFNULL(Var_EstatusSolici, Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_ErrMen  := 'La Solicitud de Credito No Existe.';
		SET Par_NumErr  := 1;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Var_EstatusSolici, Cadena_Vacia) = Sol_StaAutorizada) THEN
		SET Par_ErrMen  := 'La Solicitud de Credito ya se Encuentra Autorizada.';
		SET Par_NumErr  := 2;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Var_EstatusSolici, Cadena_Vacia) <> Sol_StaLiberada) THEN
		SET Par_ErrMen  := 'La Solicitud de Credito No esta Liberada.';
		SET Par_NumErr  := 3;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS(  SELECT OrganoID
			  FROM ORGANODESICION
			  WHERE OrganoID = Par_Organo) THEN
		SET Par_ErrMen  := 'El Organo de Desicion No Existe.';
		SET Par_NumErr  := 4;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_NumFirma, Entero_Cero) <= Entero_Cero) THEN
		SET Par_ErrMen  := 'El Numero de Firma No es Valido.';
		SET Par_NumErr  := 5;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS(SELECT EsquemaID
			FROM ORGANOAUTORIZA
			WHERE   EsquemaID    = Par_Esquema
			  AND   NumFirma   = Par_NumFirma
			  AND   OrganoID   = Par_Organo) THEN
	  SET Par_ErrMen  := 'No Existe la Combinacion de Esquema, Num. de Firma y Organo.';
	  SET Par_NumErr  := 6;
	  SET Var_Control := 'solicitudCreditoID';
	  LEAVE ManejoErrores;
	END IF;

	IF (Var_NumFirmaOto > Entero_Cero) THEN
		IF(Aud_ProgramaID LIKE '/microfin/autorizaSolicitudGrupal.htm') THEN
			SET Par_ErrMen := 'Firma de Autorizacion Otorgada con Exito.';
			SET Par_NumErr := 0;
			LEAVE ManejoErrores;
		END IF;

		IF (Var_NumTransaccion = Aud_NumTransaccion) THEN
			SET Par_ErrMen  := CONCAT('No Puede Otorgar Dos Veces la Misma Firma <', CAST(Var_NumFirmaOto AS CHAR), '>, Seleccione solo Una.' );
		ELSE
			SET Par_ErrMen  := CONCAT('La Solicitud ya tiene Otorgada la Firma <', CAST(Var_NumFirmaOto AS CHAR), '> Otorgada Por:',Var_OrganoDescri );
		END IF;

		SET Par_NumErr := 7;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	ELSE

	# Si no tiene Firmas Asignadas
	IF (IFNULL(Var_EsGrupal, Cadena_Vacia) = Str_NO) THEN
		SET Var_MontoMaximo := Var_MontoSolicitado;

		-- ============== NUEVA SECCION PARA OBTENER EL CICLO ============== --
		IF(Var_Cliente <> Entero_Cero)THEN
			SELECT CicloBase
				INTO Var_CicloActual
				FROM CICLOBASECLIPRO
					WHERE ProductoCreditoID=Var_Producto
						AND ClienteID=Var_Cliente
                        ORDER BY NumTransaccion DESC
                        LIMIT 1;
		ELSE
			SELECT CicloBase
			INTO Var_CicloActual
			FROM CICLOBASECLIPRO
					WHERE ProductoCreditoID=Var_Producto
					AND ProspectoID=Var_Prospecto
                    ORDER BY NumTransaccion DESC
					LIMIT 1;
		END IF;

		SET	Var_CicloActual	:= IFNULL(Var_CicloActual , Entero_Cero);

			IF(Var_CicloActual = Entero_Cero) THEN
				SET Var_CicloActual := (SELECT COUNT(CreditoID)
								FROM CREDITOS
								WHERE ClienteID = Var_Cliente
								  AND ProductoCreditoID = Var_Producto
								  AND Estatus IN (Cre_StaPagado, Cre_StaVigente, Cre_StaVencido) );
				SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero) + 1 + Var_CicloBase;
		END IF;
	ELSE

		SELECT Gru.GrupoID,   Gru.CicloActual
		INTO  Var_NumGrupo,   Var_CicloActual
		FROM INTEGRAGRUPOSCRE Inte
			INNER JOIN GRUPOSCREDITO Gru ON Inte.GrupoID = Gru.GrupoID
		WHERE Inte.SolicitudCreditoID = Par_Solicitud;

		SET Var_MontoMaximo :=(SELECT SUM(Sol.MontoSolici)
								FROM INTEGRAGRUPOSCRE Inte
									INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
								WHERE Inte.GrupoID = Var_NumGrupo
								AND Sol.Estatus IN (Sol_StaAutorizada, Sol_StaLiberada, Sol_StaCancelada));

	END IF;

	SET Var_CicloActual   := IFNULL(Var_CicloActual, Entero_Cero);
	SET Var_Esquema     := Entero_Cero;

	SELECT  Pue.ClavePuestoID,   Pue.Estatus,   		Pue.AtiendeSuc,     	Usu.SucursalUSuario,	Usu.Estatus
	INTO    Var_PuestoUsuario,   Var_EstatusPuesto,		Var_AtiendeSucursales,  Var_SucursalUsuario,  	Var_EstatusUsuario
	FROM USUARIOS Usu
		INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID = Usu.ClavePuestoID
	WHERE UsuarioID = Aud_Usuario;

	IF (IFNULL(Var_PuestoUsuario, Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_ErrMen  := 'El Usuario No tiene un Puesto Asignado.';
		SET Par_NumErr  := 8;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Var_EstatusPuesto, Cadena_Vacia) <> Usu_PuestoVigente) THEN
		SET Par_ErrMen  := 'El Puesto del Usuario No se Encuentra Vigente.';
		SET Par_NumErr  := 9;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	  # Se obtiene el Esquema para Solicitudes de REESTRUCTURA Y RENOVACION para el cliente YANGA
	IF(Var_CliProEsp = NumClienteYanga AND Var_TipoCredito IN(CreReestructura,CreRenovacion)) THEN
		SET Var_EsquemaID := (SELECT MAX(EsquemaID) FROM ESQUEMAAUTORIZA WHERE ProducCreditoID = Var_Producto);
		SELECT  Esq.EsquemaID INTO Var_Esquema
		FROM ESQUEMAAUTORIZA Esq
			INNER JOIN ORGANOAUTORIZA Fir ON Esq.EsquemaID = Fir.EsquemaID
			INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
		WHERE   Esq.ProducCreditoID = Var_Producto
			AND Esq.EsquemaID = Var_EsquemaID
			AND   Par_Organo  = Fir.OrganoID
			AND   Par_NumFirma = Fir.NumFirma
			AND   Fir.OrganoID IN ( SELECT Orga.OrganoID
						FROM ORGANOINTEGRA Orga
						WHERE Orga.ClavePuestoID = Var_PuestoUsuario);
	ELSE
		  # Se obtiene el Esquema para solicitudes Nuevas
		SELECT  Esq.EsquemaID INTO Var_Esquema
		FROM ESQUEMAAUTORIZA Esq
			INNER JOIN ORGANOAUTORIZA Fir ON Esq.EsquemaID = Fir.EsquemaID
			INNER JOIN ORGANODESICION Org ON Fir.OrganoID = Org.OrganoID
		WHERE   Esq.ProducCreditoID = Var_Producto
			AND   Var_CicloActual >= Esq.CicloInicial
			AND   Var_CicloActual <= Esq.CicloFinal
			AND   Var_MontoSolicitado  >= Esq.MontoInicial
			AND   Var_MontoSolicitado  <= Esq.MontoFinal
			AND   Var_MontoMaximo <= Esq.MontoMaximo
			AND   Par_Organo  = Fir.OrganoID
			AND   Par_NumFirma = Fir.NumFirma
			AND   Fir.OrganoID IN ( SELECT Orga.OrganoID
						FROM ORGANOINTEGRA Orga
						WHERE Orga.ClavePuestoID = Var_PuestoUsuario);
	END IF;


	IF (IFNULL(Var_Esquema, Entero_Cero) = Entero_Cero) THEN
		SET Par_ErrMen  := CONCAT('No Tiene los Privilegios para Otorgar la Firma: ', CAST(Par_NumFirma AS CHAR));
		SET Par_NumErr  := 10;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Var_EstatusUsuario, Cadena_Vacia) <> Usu_StaActivo) THEN
		SET Par_ErrMen  := 'El Usuario se Encuentra Inactivo.';
		SET Par_NumErr  := 11;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Var_SucursalUsuario, Entero_Cero) = Entero_Cero) THEN
		SET Par_ErrMen  := 'El Usuario No tiene una Sucursal Asignada.';
		SET Par_NumErr  := 12;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Var_SucursalUsuario, Entero_Cero) <> Var_SucursalSolici AND Var_AtiendeSucursales = Str_SI) THEN
		SET Par_ErrMen  := 'No Puede Autorizar Solicitudes de otras Sucursales.';
		SET Par_NumErr  := 13;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	-- INICIO VALIDACION ANALISIS RIESGO COMUN
	IF(IFNULL(Var_EvaluaRiesgoComun,Cadena_Vacia) = Str_SI)THEN

		 IF EXISTS(SELECT SolicitudCreditoID
			  FROM RIESGOCOMUNCLICRE
			  WHERE Procesado = Str_NO
				AND SolicitudCreditoID = Par_Solicitud)THEN

		  SET Par_NumErr := 104;
		  SET Par_ErrMen := CONCAT('No se realizo el proceso de analisis de riesgo comun para el solicitante.');
		  SET Var_Control:= 'solicitudCreditoID';
		  LEAVE ManejoErrores;

		END IF;

		-- VALIDACION CAPITAL CONTABLE
		DELETE FROM TMPCREDRIESGOS WHERE SolCreditoID = Par_Solicitud;
		INSERT INTO TMPCREDRIESGOS(
			CreditoID,		MontoCredito,	SolCreditoID)
		SELECT DISTINCT RIE.CreditoID,	CRE.MontoCredito,	RIE.SolicitudCreditoID
		FROM RIESGOCOMUNCLICRE RIE
		  INNER JOIN CREDITOS CRE
			ON RIE.CreditoID = CRE.CreditoID
		WHERE RIE.SolicitudCreditoID = Par_Solicitud
			AND RIE.RiesgoComun = Str_SI;

        SET  Var_RiesgoComun :=(  SELECT COUNT(RiesgoComun)  FROM  RIESGOCOMUNCLICRE WHERE SolicitudCreditoID = Par_Solicitud AND RiesgoComun = Str_SI);

		SET Var_MontoCreditosRiesgo :=(SELECT SUM(MontoCredito) FROM TMPCREDRIESGOS WHERE SolCreditoID = Par_Solicitud);
		SET Var_MontoCreditosRiesgo := IFNULL(Var_MontoCreditosRiesgo,Entero_Cero) + Par_MontoAutor;

		IF(Var_TipoPersona = Tipo_PersonaFisica OR Var_TipoPersona = Tipo_PersonaActEmp) THEN
			SET Var_CapitalContableNeto := ((Var_CapitalContableNeto * Var_PorcPersonaFisica)/100);
		ELSE
			SET Var_CapitalContableNeto := ((Var_CapitalContableNeto * Var_PorcPersonaMoral)/100);
		END IF;

		IF(Var_RiesgoComun > Entero_Cero  AND Var_MontoCreditosRiesgo > Var_CapitalContableNeto)THEN

		  SET Par_NumErr  := 105;
		  SET Par_ErrMen  := 'El monto excede el porcentaje del capital contable neto por Riesgo Comun.' ;
		  SET Var_Control := 'solicitudCreditoID';
		  LEAVE ManejoErrores;

		END IF;

	END IF;
	-- FIN VALIDACION ANALISIS RIESGO COMUN

	-- Validacion para Creditos Consolidados
	IF(Var_EsConsolidacionAgro = Str_SI AND Par_MontoAutor != Var_MontoSolicitado ) THEN
		SET Par_NumErr  := 106;
		SET Par_ErrMen  := 'El Monto a Autorizar debe de ser igual al Solicitado' ;
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	# Se registra las Firmas Autorizadas de la Solicitud de Credito
	INSERT INTO ESQUEMAAUTFIRMA(
		SolicitudCreditoID,	EsquemaID,      NumFirma,       	OrganoID,     	UsuarioFirma,
		FechaFirma,       	EmpresaID,      Usuario,			FechaActual,    DireccionIP,
		ProgramaID,       	Sucursal,     	NumTransaccion)
	VALUES(
		Par_Solicitud,      Par_Esquema,    Par_NumFirma,     Par_Organo,     	Aud_Usuario,
		Var_FechaSistema,   Aud_Empresa,    Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,
		Aud_ProgramaID,     Aud_SucursalID,	Aud_NumTransaccion);

	END IF;  -- IF (Var_NumFirmaOto > Entero_Cero) THEN

	# Se obtiene el Numero de las Firmas Requeridas y Firmas Otorgadas en la Solicitud de Credito
	SET Var_CantFirmasReq   := ( SELECT COUNT( DISTINCT(NumFirma)) FROM ORGANOAUTORIZA WHERE EsquemaID = Var_Esquema);
	SET Var_CantFirmasOto   := ( SELECT COUNT( DISTINCT(NumFirma)) FROM ESQUEMAAUTFIRMA WHERE SolicitudCreditoID = Par_Solicitud);

	SET Var_CantFirmasReq   := IFNULL(Var_CantFirmasReq, Entero_Cero);
	SET Var_CantFirmasOto   := IFNULL(Var_CantFirmasOto, Entero_Cero);


	# Verifica si ya se autorizaron todas las firmas requeridas, se manda autorizar la solicitud
	IF (Var_CantFirmasReq = Var_CantFirmasOto) THEN
		# Si es una solicitud de credito para reestructura se dara el tratamiento al credito reestructurado
		IF(Var_TipoCredito = CreReestructura ) THEN
			SET Var_TipoActualizaSol    := Act_AutSolCreReest;
		ELSE
			# Si es una solicitud para credito nuevo o renovacion, se manda a autorizar la solicitud de credito
			SET Var_TipoActualizaSol    := Act_AutorizaSolicitud;
		END IF;

	ELSE
		SET Var_TipoActualizaSol    := Act_MontoAutorizadoSol;
	END IF;

	-- ===== INICIO DE VALIDACION DE LAS GARANTIAS AUTORIZADA SI ES QUE SON REQUERIDAS, SI EL MONTO DE LA GARANTIA
	-- ===== ASOCIADA A LA SOLICITUD ES MENOR AL MONTO DEL GRADO COBERTURA REQUERIDO

	IF(Var_ReqGarantia = Str_SI OR Var_ReqGarantia = Indistinto) THEN
		IF(Var_ReqGarantia = Indistinto) THEN
			SELECT COUNT(SolicitudCreditoID)
				INTO Var_NumGarCap
				FROM ASIGNAGARANTIAS
					WHERE SolicitudCreditoID = Par_Solicitud;

			SET Var_NumGarCap	:= IFNULL(Var_NumGarCap, Entero_Cero);

			IF(Var_NumGarCap > Entero_Cero) THEN
				SET Var_GaraInCap = 1;
			END IF;
		END IF;

		IF(Var_ReqGarantia = Str_SI OR Var_GaraInCap > Entero_Cero) THEN
			SELECT COUNT(SolicitudCreditoID),
					SUM(CASE Estatus WHEN Est_AutGaran THEN 1 ELSE 0 END),
					SUM(CASE Estatus WHEN Est_AutGaran THEN MontoAsignado ELSE 0 END)
				INTO Var_NumGarCap,		Var_NumGarAut,		Var_SumGarAsi
				FROM	ASIGNAGARANTIAS
				WHERE SolicitudCreditoID = Par_Solicitud;

			SET Var_NumGarCap	:= IFNULL(Var_NumGarCap, Entero_Cero);
			SET Var_NumGarAut	:= IFNULL(Var_NumGarAut, Entero_Cero);
			SET Var_SumGarAsi	:= IFNULL(Var_SumGarAsi, Entero_Cero);

			-- Calcula el monto de relacion de la garantia
			SET Var_ResMonGaran := (Par_MontoAutor * (Var_RelGarCred/100.00));

			IF(Var_SumGarAsi < Var_ResMonGaran AND Var_NumGarAut > Entero_Cero AND Var_NumGarCap > 0) THEN
				SET Par_ErrMen  := CONCAT("El Monto de la(s) Garanti­a(s) Asociada(s) a la Solicitud ", CONVERT(Par_Solicitud, CHAR), " es menor al Grado de Cobertura Requerido");
				SET Par_NumErr  := 20;
				SET Var_Control := 'montoGarantiaReq';
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;
	-- ===== FIN DE VALIDACION DE LAS GARANTIAS SI ES QUE SON REQUERIDAS

	# Se realiza la Autorizacion de la Solicitud de Credito
	CALL SOLICITUDCREACT (
	  Par_Solicitud,    Par_MontoAutor,       	Var_FechaSistema,   	Aud_Usuario,      	Par_AporteCli,
	  Cadena_Vacia,   	Par_ComentMesaControl,	Cadena_Vacia,           Cadena_Vacia,       Var_TipoActualizaSol,
	  Str_NO,         	Par_NumErr,             Par_ErrMen,     	    Aud_Empresa,        Aud_Usuario,
	  Aud_FechaActual,  Aud_DireccionIP,        Aud_ProgramaID,         Aud_SucursalID,     Aud_NumTransaccion);

	IF (Par_NumErr > Entero_Cero) THEN
		SET Var_Control := 'solicitudCreditoID';
		LEAVE ManejoErrores;
	END IF;

	# Se verifica la Cantidad de Firmas Requeridas
	IF (Var_CantFirmasReq = Var_CantFirmasOto) THEN
		# si es solicitud para credito reestructura y todas las firman ya fueron autorizadas se aplica la reestructura al credito
		IF(Var_TipoCredito = CreReestructura ) THEN

			SELECT Estatus,				PeriodicidadCap,		EsAgropecuario,		TipoFondeo
			INTO Var_EstRelacionado,	Var_PeriodCap,			Var_EsAgropecuario,	Var_TipoFondeo
			FROM CREDITOS WHERE CreditoID = Var_Relacionado;

			# Revision de Estatus de Nacimiento
			SELECT  FUNCIONEXIGIBLE(Var_Relacionado) INTO Var_SaldoExigible;
			SET Var_SaldoExigible  := IFNULL(Var_SaldoExigible, Entero_Cero);


			/***** VALIDACION PARA ASIGNAR EL ESTATUS AL CREDITO REESTRUCTURADO *****/

			CALL ESTATUSCREDITOACT(Var_Relacionado,	Var_EstRelacionado,	Var_EstatusCrea,	Str_NO,				Par_NumErr,
								  Par_ErrMen,     	Aud_Empresa,    	Aud_Usuario,    	Aud_FechaActual,    Aud_DireccionIP,
								  Aud_ProgramaID,   Aud_SucursalID,   	Aud_NumTransaccion);


			# Revision del Numero de Pagos Sostenidos para ser Regularizado.

			# Se valida si el Tipo Frecuencia es diferente de Unica y Libre
			IF(Var_FrecCapital != FrecUnico) THEN
				# Si la periodicidad del Capital es mayor a 60 dias el numero de pagos sostenidos sera 1
				IF(Var_PeriodCapSol >60) THEN
					SET Var_NumPagoSostenido  = 1;
				ELSE
					-- Var_PeriodCap: Periodicidad de Capital del Credito Anterior
					-- Var_PeriodCapSol: Periodicidad de Capital del Credito Nuevo
					IF(Var_FrecCapital != FrecLibre) THEN
						IF(Var_PeriodCapSol > Entero_Cero)THEN
							SET Var_NumPagoSostenido := CEILING((Var_PeriodCap/Var_PeriodCapSol) * Num_PagRegula);
						ELSE
							SET Var_NumPagoSostenido := Entero_Cero;
						END IF;
					ELSE
						SET Var_NumPagoSostenido  = Num_PagRegula;
					END IF;
				END IF;
			ELSE

				IF(Var_FrecCapital = FrecUnico AND  Var_FrecInteres = FrecUnico) THEN
					SET Var_NumPagoSostenido  = 1;
				ELSE
					IF(Var_FrecInteres != FrecPeriod) THEN
						IF(Var_PeriodInt > Entero_Cero)THEN
							SET Var_NumPagoSostenido := CEILING((90/Var_PeriodInt));
						ELSE
							SET Var_NumPagoSostenido := Entero_Cero;
						END IF;
					ELSE
						SET Var_NumPagoSostenido  = 1;
					END IF;

				END IF;
			END IF;


			# Calculo de los Dias de Atraso
			SELECT  (DATEDIFF(Var_FechaSistema, IFNULL(MIN(FechaExigible), Var_FechaSistema)))
			INTO Var_NumDiasAtraOri
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Var_Relacionado
				AND Amo.Estatus != Cre_StaPagado
				AND Amo.FechaExigible <= Var_FechaSistema;

			# Revision del Numero de Renovaciones sobre el Credito Original
			SELECT  NumeroReest
			INTO Var_NumRenovacion
			FROM REESTRUCCREDITO
			WHERE CreditoOrigenID = Var_Relacionado
				AND EstatusReest = Est_Desembolso;

			SET Var_NumRenovacion := IFNULL(Var_NumRenovacion, Entero_Cero) + 1;

			IF(Var_EsAgropecuario = Str_NO) THEN

				CALL REESTRUCCREDITOALT (
				Var_FechaSistema,   Aud_Usuario,        Var_Relacionado,      	Var_Relacionado,      	Par_MontoAutor,
				Var_EstRelacionado, Var_EstatusCrea,    Var_NumDiasAtraOri,   	Var_NumPagoSostenido,   Entero_Cero,
				Str_NO,         	Fecha_Vacia,        Var_NumRenovacion,      Entero_Cero,      		Entero_Cero,
				Entero_Cero,    	Entero_Cero,    	OrigenReestructura,		Str_NO,           		Par_NumErr,
				Par_ErrMen,         Aud_Empresa,        Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,
				Aud_ProgramaID,     Aud_SucursalID,     Aud_NumTransaccion );

				IF(Par_NumErr > Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			ELSE
				# SE REALIZA LA REESTRUCTURA DEL CREDITO ACTIVO
				CALL REESTRUCCREDAGROALT (
					Var_FechaSistema,  	Aud_Usuario,      	Var_Relacionado,    	Var_Relacionado,  		Par_MontoAutor,
					Var_EstRelacionado, Var_EstatusCrea,    Var_NumDiasAtraOri, 	Var_NumPagoSostenido, 	Entero_Cero,
					Str_NO,      		Fecha_Vacia,        Var_NumRenovacion,    	Entero_Cero,			Entero_Cero,
					Entero_Cero,		Entero_Cero,		OrigenReestructura,		Str_NO,      			Par_NumErr,
					Par_ErrMen,         Aud_Empresa,      	Aud_Usuario,    		Aud_FechaActual, 		Aud_DireccionIP,
					Aud_ProgramaID,     Aud_SucursalID,     Aud_NumTransaccion );

				IF(Par_NumErr > Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

						# SE VALIDA SI EL CREDITO FUE FONDEADO POR UNA INSTITUCION DE FONDEO
				SET Par_CreditoFonID 	:= (SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO
											WHERE CreditoID = Var_Relacionado);

				SET Var_EstCredPas 		:= (SELECT Estatus FROM CREDITOFONDEO WHERE CreditoFondeoID = Par_CreditoFonID);

				IF(Var_TipoFondeo = Tipo_InstitFon AND Var_EstCredPas <> Cre_StaPagado AND Var_EstCredPas <> Est_Castigado) THEN

					# SE REALIZA LA REESTRUCTURA DEL CREDITO PASIVO
					CALL REESTCREDPASAGROALT (
						Var_FechaSistema,  	Aud_Usuario,      	Var_Relacionado,    	Var_Relacionado,  		Par_MontoAutor,
						Est_Vigente, 		Est_Vigente,    	Entero_Cero, 			Entero_Cero, 			Entero_Cero,
						Str_NO,      		Fecha_Vacia,        Entero_Cero,    		Entero_Cero,			Entero_Cero,
						Entero_Cero,		Entero_Cero,		OrigenReestructura,		Str_NO,      			Par_NumErr,
						Par_ErrMen,         Aud_Empresa,      	Aud_Usuario,    		Aud_FechaActual, 		Aud_DireccionIP,
						Aud_ProgramaID,     Aud_SucursalID,     Aud_NumTransaccion );

					IF(Par_NumErr > Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			-- SE MARCAN COMO PAGADAS LAS CUOTAS DE LA TABLA REAL
			-- SI ES REESTRUCTURA O RENOVACION
			IF EXISTS (SELECT * FROM AMORTCRENOMINAREAL WHERE CreditoID = Var_Relacionado)THEN
				UPDATE AMORTCRENOMINAREAL SET
					Estatus = Est_Pagado,
					NumTransaccion  = Aud_NumTransaccion
				WHERE CreditoID = Var_Relacionado
				  AND Estatus <> Est_Pagado;
			END IF;

			IF (Par_NumErr != Entero_Cero) THEN
				SET Var_Control := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

		ELSE -- si es una solicitud para credito nuevo o renovacion, solo se envia mensaje de autorizacion

			SET Par_ErrMen := CONCAT('Ultima Firma de Autorizacion Otorgada con Exito.<br>',Par_ErrMen);

            #VALIDAR EL CAPITAL NETO DE LA IDENTIDAD
			CALL OPERCAPITALNETOVALPRO(Par_Solicitud,			Par_MontoAutor, 		"S", 					"AS",						Str_NO,
									Par_NumErr,				Var_MensajeSalida,		Aud_Empresa,			Aud_Usuario,    		Aud_FechaActual,
									Aud_DireccionIP,		Aud_ProgramaID,			Aud_SucursalID,          Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_ErrMen := CONCAT(Par_ErrMen,' <br><br> ',Var_MensajeSalida);
			END IF;
	 	END IF; -- Termina: IF(Var_TipoCredito = CreReestructura ) THEN


		SET Var_MensajeSalida := Par_ErrMen;


		IF( IFNULL(Var_EsConsolidacionAgro, Str_NO) = Str_SI ) THEN

			SELECT FolioConsolida
			INTO Var_FolioConsolidacionID
			FROM CRECONSOLIDAAGROENC
			WHERE SolicitudCreditoID = Par_Solicitud;

			CALL CRECONSOLIDAAGROACT(
				Var_FolioConsolidacionID,	Par_Solicitud,		Entero_Cero,		Fecha_Vacia,	Act_EstCabecera,
				Str_NO,						Par_NumErr,			Par_ErrMen,			Aud_Empresa,	Aud_Usuario,
				Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_SucursalID,	Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_ErrMen := Var_MensajeSalida;
		END IF;

		IF(Var_RequiereCheckList = Str_SI) THEN
			-- Notificacion de Documentos de Guarda Valores
			SET Var_ParticipanteID := IFNULL(FNPARTICIPANTEGRDVALORES(Inst_SolicitudCredito, Par_Solicitud, Ope_Participante), Entero_Cero);
			SET Var_TipoParticipante := IFNULL(FNTIPOPARTICIPANTEGRDVALORES(Inst_SolicitudCredito, Par_Solicitud), Cadena_Vacia);
			CALL NOTIFCACORREOGRDVALPRO (
				Var_ParticipanteID,		Var_TipoParticipante,	Str_NO,				Par_NumErr, 		Var_MensajeNotificacion,
				Aud_Empresa,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_SucursalID,			Aud_NumTransaccion);
			SET Par_NumErr := Entero_Cero;

		END IF;

    ELSE -- Solo se autoriza una firma
      	SET Par_ErrMen := 'Firma de Autorizacion Otorgada con Exito.';
    END IF; -- Termina: IF (Var_CantFirmasReq = Var_CantFirmasOto) THEN





    SET Par_NumErr := 0;
    SET Var_Control := 'solicitudCreditoID';


  END ManejoErrores;


  IF (Par_Salida = Str_SI) THEN
    SELECT  Par_NumErr  AS NumErr,
        Par_ErrMen  AS ErrMen,
        Var_Control AS control,
        Entero_Cero AS consecutivo;
  END IF;


END TerminaStore$$
