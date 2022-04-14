-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCON`;
DELIMITER $$

CREATE PROCEDURE `CLIENTESCON`(
	# ========== SP PARA CONSULTA DE CLIENTES =============================================
    Par_ClienteID       INT(11),                -- Cliente ID para consultar
    Par_RFC             CHAR(13),           	-- RFC para consultar al cliente
    Par_CURP            CHAR(18),           	-- CURP para consultar al cliente
    Par_NumCon          TINYINT UNSIGNED,   	-- Numero de consulta
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Estat				CHAR(1);
	DECLARE Var_UltimoCredito		BIGINT(12);			 -- Id del ultimo credito
	DECLARE Var_AtrasoCredito		INT(11);			 -- Fecha de atraso de credito ultima fecha exigible
	DECLARE Var_DiasMaximoAtra		DECIMAL(12,2);		 -- Dias maximo de atraso
	DECLARE Var_SaldoTotalCtas		DECIMAL(14,2);		 -- Saldo total disponible
	DECLARE Var_MontoInvGarantia	DECIMAL(14,2);		 -- Monto total de inversion garantia
	DECLARE Var_MontoInversiones	DECIMAL(14,2);		 -- Monto total de inversiones
	DECLARE Var_TotalAdeudoCred		DECIMAL(14,2);		 -- Total de adeudo de credito
	DECLARE Var_DirecCliente		VARCHAR(100);
	DECLARE Var_TipoDireccion		CHAR(1);
	DECLARE Var_CodCooperativa		VARCHAR(9);
	DECLARE Var_CodMoneda			VARCHAR(5);
	DECLARE Var_CodUsuario			VARCHAR(19);
	DECLARE Var_CuentaAhoID			BIGINT(12);
	DECLARE Var_PaisIDBase			INT(11);			 -- Pais ID de Base.
	DECLARE Var_CliConfiadora 		INT(11);
	DECLARE Var_cliEsp        		INT(11);
	DECLARE NumCreditos				INT(11);			-- Numero de Creditos Con 26

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE	Con_Principal			INT;
	DECLARE	Con_Foranea				INT;
	DECLARE	Con_Correo				INT;
	DECLARE	Con_RFC					INT;
	DECLARE	Con_OtraPant			INT;
	DECLARE	Con_Inversion			INT;
	DECLARE	Con_ResumenCte			INT;
	DECLARE	Con_PagoCred			INT;
	DECLARE	Con_TipoPersona			INT;
	DECLARE	Con_ProspecCli			INT;
	DECLARE Con_ApoyoEsc			INT;
	DECLARE Con_Calif				INT;
	DECLARE  Con_CURP				INT;
	DECLARE  Con_Corp				INT;
	DECLARE  Cons_Corp				CHAR(1);
	DECLARE  Cons_TipoPer			CHAR(1);
	DECLARE Est_Vigente				CHAR(1);
	DECLARE Est_Vencido  			CHAR(1);
	DECLARE Con_EstatusCred 		INT(11);
	DECLARE Con_ClienteWS 	    	INT;
	DECLARE Var_FechaSis			DATE;
	DECLARE	Fisica_Empresa			CHAR(1);
	DECLARE Fisica_NoEmpresa		CHAR(1);
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Con_Valida_CURP			INT(11);
	DECLARE Con_NombreCl        	INT(11);
	DECLARE EstatusCastigado  		CHAR(1);
	DECLARE EstatusPagado	  		CHAR(1);
	DECLARE EstatusVigente			CHAR(1);
	DECLARE Con_DatosGeneral		INT;
	DECLARE Decimal_Cero			DECIMAL;
	DECLARE Con_AsociaEntura		INT(1);
	DECLARE TipoDocumento			INT(1);
	DECLARE CodMoneda				INT(3);
	DECLARE TipoTelefono			CHAR(1);
	DECLARE TipoCuentaEntura		INT(2);
	DECLARE Esta_Activa				CHAR(1);
	DECLARE CadenaSI				CHAR(1);
	DECLARE CadenaNO				CHAR(1);
	DECLARE Esta_Vigente			CHAR(1);
	DECLARE Con_ConocimientoCte		INT(1);
    DECLARE Con_PersonaFisica		INT(11);
    	DECLARE Con_Aportaciones		INT(11);
    DECLARE PersonaMoral			CHAR(1);
    DECLARE Con_CliCreditoConsolidado	TINYINT UNSIGNED;-- Lista de Cliente Para la pantalla Solicitud de Credito Consolidada

 -- Asignacion de constantes
    SET Cadena_Vacia                := '';              -- Cadena vacia
    SET Fecha_Vacia                 := '1900-01-01';    -- Fecha vacia
    SET Entero_Cero                 := 0;               -- Entero cero
    SET Con_Principal               := 1;               -- Consulta principal
    SET Con_Foranea                 := 2;               -- Consulta foranea
    SET Con_Correo                  := 3;               -- Consulta del correo
    SET Con_RFC                     := 4;               -- Consulta del RFC
    SET Con_OtraPant                := 5;               -- Consulta para la pantallas externas(cuentaPersona)
    SET Con_Inversion               := 6;               -- Consulta de Inversiones del cliente
    SET Con_ResumenCte              := 7;               -- Consulta para la pantalla de resumen de cliente
    SET Con_PagoCred                := 8;               -- Consulta para pantalla de pago de credito
    SET Con_TipoPersona             := 9;               -- Consulta de tipo de persona
    SET Con_ProspecCli              := 10;              -- Consulta para prospecto de cliente
    SET Con_CURP                    := 11;              -- Consulta curp
    SET Con_Corp                    := 12;              -- Consulta para el nombre corporativo
    SET Cons_Corp                   := 'C';             -- Empleado de Nomina
    SET Cons_TipoPer                := 'M';             -- Tipo de persona moral
    SET Con_EstatusCred             := 13;              -- Consulta para el estatus de credito
    SET Con_ClienteWS               := 14;              -- Consulta de cliente del WS
    SET Con_ApoyoEsc                := 15;              -- Consulta para apoyo escolar
    SET Con_Calif                   := 16;              -- Consulta para obtener calificacion y clasificacion del cliente
    SET Con_Valida_CURP             := 17;              -- Consulta para validar la curp y el estatus del cliente
    SET Con_NombreCl                := 18;              -- consulta nombre estatus y si es menor de edad para el grid de grupos no solidarios
    SET Con_DatosGeneral            := 19;              -- Consutla para datos generales
    SET Con_AsociaEntura            := 22;              -- Consulta Asociacion Entura
	SET Con_ConocimientoCte			:= 23;
    SET Con_PersonaFisica			:= 24;				-- Consulta a los clientes que sean persona fisica o fisica con actividad empresarial
	SET Con_Aportaciones			:= 25;
	SET Con_CliCreditoConsolidado	:= 26;				-- Lista para la pantalla Solicitud de Credito Consolidada
	SET Est_Vigente	    				:= 'V';
	SET Est_Vencido						:= 'B';
	SET Var_FechaSis    				:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET	Fisica_Empresa					:= 'A';
	SET Fisica_NoEmpresa				:= 'F';
	SET Estatus_Activo					:= 'A';
	SET EstatusCastigado				:= 'K';
	SET EstatusPagado					:= 'P';
	SET EstatusVigente					:= 'N';
	SET Decimal_Cero					:=	0.0;
	SET TipoDocumento					:=  1;	   -- Utilizada para Asociar una Tarjeta Debito con Entura.
	SET CodMoneda						:=  484;   -- Utilizada para Asociar una Tarjeta Debito con Entura.
	SET TipoTelefono					:= 'P';    -- Utilizada para Asociar una Tarjeta Debito con Entura.
	SET TipoCuentaEntura				:=  10;	   -- Utilizada para Asociar una Tarjeta Debito con Entura.
	SET Esta_Activa						:= 'A';	   -- Estatus Activo --
	SET CadenaSI						:= 'S';    -- Cadena SI --
	SET CadenaNO						:= 'N';    -- Cadena NO --
	SET Esta_Vigente					:= 'V';    -- Estatus Vigente --
	SET PersonaMoral					:= 'M';	   -- Persona Moral
	SET Var_CliConfiadora   			:= 46;

	SET Var_CliEsp :=(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CliProcEspecifico');

	IF(Par_NumCon = Con_Principal) THEN
		-- CONSULTA PARA SABER SI EL CLIENTE TIENE REGISTRADOS LOS DATOS DEL CONYUGE


	   SELECT 	ClienteID,			SucursalOrigen,		TipoPersona,		Titulo,  			PrimerNombre,
				SegundoNombre, 		TercerNombre, 		ApellidoPaterno, 	ApellidoMaterno,	FechaNacimiento,
				LugarNacimiento, 	EstadoID,			Nacion, 			PaisResidencia,		Sexo,
				CURP,				RFC,				EstadoCivil,		TelefonoCelular,	Telefono,
				Correo,				RazonSocial,		TipoSociedadID,		RFCpm,				GrupoEmpresarial,
				Fax,				OcupacionID,		Puesto,				LugardeTrabajo,		ROUND(AntiguedadTra,1) AS AntiguedadTra,
				TelTrabajo,			Clasificacion,		MotivoApertura,		PagaISR,			PagaIVA,
				PagaIDE,			NivelRiesgo,		SectorGeneral,		ActividadBancoMX,	ActividadINEGI,
				SectorEconomico,	PromotorInicial,	PromotorActual,
				CASE WHEN (Var_CliEsp = Var_CliConfiadora) THEN
        			CONCAT(CONCAT(NombreCompleto,' - '),Observaciones)
	            ELSE
	            	NombreCompleto
	            END AS NombreCompleto,															ActividadFR,
				ActividadFOMURID,	Estatus, 			TipoInactiva, 		MotivoInactiva, 	EsMenorEdad,
				CorpRelacionado,	CalificaCredito,	RegistroHacienda,	FechaAlta,			Observaciones,
				NoEmpleado,       	TipoEmpleado,		ExtTelefonoPart,	ExtTelefonoTrab,    EjecutivoCap,
				PromotorExtInv,		TipoPuesto,			FechaIniTrabajo,	UbicaNegocioID,		FEA,
				PaisFEA,			(YEAR (Var_FechaSis)- YEAR (FechaNacimiento)) - (RIGHT(Var_FechaSis,5)<RIGHT(FechaNacimiento,5)) AS Edad,
				CASE FechaConstitucion
					WHEN Fecha_Vacia THEN Cadena_Vacia ELSE FechaConstitucion END FechaConstitucion,
				PaisConstitucionID,	CorreoAlterPM,		NombreNotario,		NumNotario,			InscripcionReg,
                EscrituraPubPM,		DomicilioTrabajo,	PaisNacionalidad
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;
	END IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT ClienteID,NombreCompleto
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;
	END IF;


	IF(Par_NumCon = Con_RFC) THEN
		SELECT  ClienteID, RFCOFicial
			FROM CLIENTES
			WHERE RFCOFicial = Par_RFC;
	END IF;


	IF(Par_NumCon = Con_Correo) THEN
		SELECT  ClienteID, NombreCompleto, Correo
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;
	END IF;


	IF(Par_NumCon = Con_OtraPant) THEN

		SELECT	ClienteID, NombreCompleto, RazonSocial, TipoPersona,
				CASE WHEN TipoPersona = Cons_TipoPer THEN
				RFCOficial ELSE RFC  END AS 	RFC,
				Telefono, SucursalOrigen, ExtTelefonoPart, EsMenorEdad, Estatus
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

	END IF;


	IF(Par_NumCon = Con_Inversion) THEN
		SELECT
			C.ClienteID,	C.NombreCompleto,	C.Telefono,		C.PagaISR,	C.Clasificacion,
			C.EsMenorEdad,	C.CalificaCredito,	S.TasaISR
		FROM CLIENTES C
			INNER JOIN SUCURSALES S ON C.SucursalOrigen = S.SucursalID
		WHERE C.ClienteID = Par_ClienteID;
	END IF;


	IF(Par_NumCon = Con_ResumenCte) THEN
		SELECT	ClienteID,			TipoPersona,		PromotorActual,	SucursalOrigen,		FechaAlta,
				TipoSociedadID, 	GrupoEmpresarial,	Sexo,			FechaNacimiento,	Nacion,
				EstadoCivil,		Telefono,			Correo,			ActividadBancoMX,	ActividadINEGI,
				SectorEconomico,	OcupacionID,		Puesto,			NombreCompleto,		RFC,
				Estatus
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;
	END IF;


	IF(Par_NumCon = Con_PagoCred) THEN
		SELECT  ClienteID, NombreCompleto, PagaIVA
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;
	END IF;

	IF(Par_NumCon = Con_TipoPersona) THEN
		SELECT ClienteID,NombreCompleto, TipoPersona
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;
	END IF;


	IF(Par_NumCon = Con_ProspecCli) THEN
	 SELECT	IFNULL(Pro.ClienteID,Entero_Cero),	IFNULL(Pro.ProspectoID,Entero_Cero), IFNULL(Cli.NombreCompleto,Cadena_Vacia), IFNULL(Pro.NombreCompleto,Cadena_Vacia)
		FROM	PROSPECTOS Pro,
				CLIENTES Cli
		WHERE	Cli.ClienteID = Pro.ClienteID
		AND		Pro.ClienteID = Par_ClienteID;
	END IF;
	IF(Par_NumCon = Con_CURP) THEN
		SELECT  ClienteID, CURP, TipoPersona
			FROM CLIENTES
			WHERE CURP = Par_CURP
			AND (TipoPersona = Fisica_Empresa OR TipoPersona=Fisica_NoEmpresa);
	END IF;


	IF(Par_NumCon = Con_Corp) THEN
		SELECT ClienteID,NombreCompleto
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID
			AND ClasIFicacion = Cons_Corp
			AND TipoPersona = Cons_TipoPer ;
	END IF;


	IF(Par_NumCon= Con_EstatusCred) THEN
	SELECT COUNT(Estatus) AS Estatus
			FROM CREDITOS
				WHERE ClienteID=Par_ClienteID
					AND Estatus IN( Est_Vigente, Est_Vencido );
	END IF;


	IF(Par_NumCon = Con_ClienteWS) THEN
	   SELECT 	ClienteID,            PrimerNombre,  SegundoNombre, ApellidoPaterno, ApellidoMaterno,
				NombreCompleto,       Correo,        TelefonoCelular
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;
	END IF;


	IF(Par_NumCon = Con_ApoyoEsc) THEN
		SELECT	ClienteID,			TipoPersona,		SucursalOrigen,		FechaAlta,		FechaNacimiento,
				NombreCompleto,		RFC,				EsMenorEdad,
				(YEAR (Var_FechaSis)- YEAR (FechaNacimiento)) - (RIGHT(Var_FechaSis,5)<RIGHT(FechaNacimiento,5)) AS Edad
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID
			AND (TipoPersona = Fisica_Empresa OR TipoPersona=Fisica_NoEmpresa)
			AND Estatus = Estatus_Activo;
	END IF;

	IF(Par_NumCon= Con_Calif) THEN
	SELECT Cli.ClienteID, Cli.CalificaCredito, IFNULL(Cal.Calificacion,Entero_Cero ) AS Calificacion, IFNULL(PagaIVA, Cadena_Vacia) AS PagaIVA,
		   Cli.EsMenorEdad
			FROM CLIENTES Cli
				 LEFT JOIN CALIFICACIONCLI Cal ON  Cli.ClienteID =  Cal.ClienteID
				 WHERE Cli.ClienteID = Par_ClienteID
				 AND Cli.Estatus = Estatus_Activo;
	END IF;

	IF(Par_NumCon=Con_Valida_CURP)THEN
		SELECT  ClienteID,CURP,IFNULL(CASE WHEN EsMenorEdad = "N" AND Estatus ="I"  THEN
												   "La CURP Indicada Pertenece a un Cliente Inactivo, \n"
														  "Cliente: "
										 ELSE CASE WHEN EsMenorEdad ="N" AND Estatus ="A" THEN
												   "La Curp Indicada Pertenece a un Cliente Activo, \n"
														  "Cliente: "
										 ELSE CASE WHEN EsMenorEdad ="S" AND Estatus ="A" THEN
												   "La CURP Indicada Pertenece a un Cliente Menor Activo, \n"
														  "Cliente: "
										 END  END END, '')AS DescripcionCURP,
								IFNULL(CASE  WHEN Estatus ="I"  THEN
											"El RFC Indicado Pertenece a un Cliente Inactivo,\n"
											"Cliente: "
										ELSE CASE WHEN Estatus ="A" THEN
											"El RFC Indicado Pertenece a un Cliente Activo,\n"
											"Cliente: "
										END END ,'')AS DescripcionRFC

			FROM CLIENTES
			WHERE ClienteID =Par_ClienteID
			AND (TipoPersona = Fisica_Empresa OR TipoPersona = Fisica_NoEmpresa);

	END IF;


	IF(Par_NumCon=Con_NombreCl)THEN
		SELECT ClienteID,NombreCompleto, Estatus, EsMenorEdad , SucursalOrigen
			FROM CLIENTES
				WHERE ClienteID =Par_ClienteID;
	END IF;



	IF(Par_NumCon = Con_DatosGeneral)THEN
		SET Var_UltimoCredito	:=( SELECT CreditoID FROM CREDITOS
									WHERE ClienteID = Par_ClienteID
									AND Estatus IN(Est_Vigente,Est_Vencido,EstatusPagado,EstatusCastigado)
									ORDER BY FechaInicio DESC LIMIT 1 );

		SET Var_AtrasoCredito	:=(SELECT MAX(DATEDIFF(IFNULL(FechaLiquida,Var_FechaSis),  FechaExigible))
									FROM AMORTICREDITO Cre
									WHERE CreditoID = Var_UltimoCredito
									AND IFNULL(FechaLiquida,Var_FechaSis) >= FechaExigible);

		SET Var_DiasMaximoAtra :=(SELECT IFNULL( MAX(DATEDIFF(IFNULL(FechaLiquida,Var_FechaSis),  FechaExigible)),Entero_Cero)
									FROM AMORTICREDITO
									WHERE ClienteID = Par_ClienteID
									AND  IFNULL(FechaLiquida,Var_FechaSis) >= FechaExigible);


		SET Var_SaldoTotalCtas	:= (SELECT  SUM(SaldoDispon)
										FROM CUENTASAHO
											WHERE ClienteID = Par_ClienteID
											AND Estatus = Estatus_Activo);

		SET Var_MontoInvGarantia := (SELECT SUM(MontoEnGar)
											FROM CREDITOINVGAR Gar
												INNER JOIN CREDITOS Cre ON Cre.CreditoID = Gar.CreditoID
												WHERE Cre.ClienteID = Par_ClienteID);
		SET Var_MontoInvGarantia	:=IFNULL(Var_MontoInvGarantia, Entero_Cero);
		SET Var_MontoInversiones	:=(SELECT ( SUM(Monto) - Var_MontoInvGarantia)
										FROM INVERSIONES
										WHERE ClienteID = Par_ClienteID
										AND Estatus = EstatusVigente);

		SET Var_TotalAdeudoCred		:=(SELECT SUM(FUNCIONTOTDEUDACRE(IFNULL(Cre.CreditoID,0))) AS TotalAdeudoCreditos
										FROM CREDITOS Cre
											WHERE Cre.ClienteID = Par_ClienteID
											AND Estatus IN(Est_Vigente,Est_Vencido,EstatusPagado,EstatusCastigado));




			SELECT IFNULL(Var_AtrasoCredito, Entero_Cero) AS Mora,			IFNULL(ROUND((Var_DiasMaximoAtra/30),2), Decimal_Cero) AS MaximoMora,
					IFNULL(Var_SaldoTotalCtas, Decimal_Cero) AS SaldoTotCtas,IFNULL(Var_MontoInversiones, Decimal_Cero) AS MontoInversiones,
					IFNULL(Var_TotalAdeudoCred, Decimal_Cero) AS AdeudoTotal;

	END IF;


	IF(Par_NumCon=Con_AsociaEntura)THEN


		SELECT substring(CONCAT(IFNULL(loc.NombreLocalidad,Cadena_Vacia),',',IFNULL(edo.Nombre,Cadena_Vacia),',',IFNULL(dir.Calle,Cadena_Vacia),',',IFNULL(dir.NumeroCasa,Cadena_Vacia)),1,100) AS DierccionCliente, 'P' AS TipoDireccion
			INTO Var_DirecCliente,Var_TipoDireccion
			FROM DIRECCLIENTE dir
				INNER JOIN ESTADOSREPUB edo
					ON dir.EstadoID = edo.EstadoID
				INNER JOIN LOCALIDADREPUB loc
					ON dir.LocalidadID = loc.LocalidadID AND dir.MunicipioID = loc.MunicipioID AND dir.EstadoID = loc.EstadoID
		WHERE dir.ClienteID = Par_ClienteID AND dir.TipoDireccionID = 1
		LIMIT 1;

		IF(IFNULL(Var_DirecCliente,Cadena_Vacia)=Cadena_Vacia)THEN

			SELECT substring(CONCAT(IFNULL(loc.NombreLocalidad,Cadena_Vacia),',',IFNULL(edo.Nombre,Cadena_Vacia),',',IFNULL(dir.Calle,Cadena_Vacia),',',dir.NumeroCasa),1,100) AS DierccionCliente, 'C' AS TipoDireccion
				INTO Var_DirecCliente,Var_TipoDireccion
				FROM DIRECCLIENTE dir
					INNER JOIN ESTADOSREPUB edo
						ON dir.EstadoID = edo.EstadoID
					INNER JOIN LOCALIDADREPUB loc
						ON dir.LocalidadID = loc.LocalidadID AND dir.MunicipioID = loc.MunicipioID AND dir.EstadoID = loc.EstadoID
			WHERE dir.ClienteID = Par_ClienteID AND dir.TipoDireccionID = 3
			LIMIT 1;


		END IF;

		IF(IFNULL(Var_DirecCliente,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Var_DirecCliente  = Cadena_Vacia;
			SET Var_TipoDireccion = Cadena_Vacia;
		END IF;


		SELECT CodCooperativa, CodMoneda, CodUsuario
			INTO Var_CodCooperativa, Var_CodMoneda, Var_CodUsuario
			FROM PARAMETROSCAJA;

		SELECT cte.ClienteID, IFNULL(cte.CURP,Cadena_Vacia) AS CURP,	TipoDocumento AS TipoDocumento,
		substring(CONCAT(IFNULL(cte.PrimerNombre,Cadena_Vacia),' ',IFNULL(cte.SegundoNombre,Cadena_Vacia),' ',IFNULL(cte.TercerNombre,Cadena_Vacia)),1,30) AS NombresCliente,
			substring(CONCAT(IFNULL(cte.ApellidoPaterno,Cadena_Vacia),' ',IFNULL(cte.ApellidoMaterno,Cadena_Vacia)),1,30) AS ApellidosCliente, CodMoneda AS CodMoneda,
			Var_DirecCliente AS DirecCliente,	Var_TipoDireccion AS TipoDireccion,		IFNULL(cte.Correo,Cadena_Vacia) AS Correo, IFNULL(cte.Telefono,Cadena_Vacia) AS Telefono,
			TipoTelefono AS TipoTelefono,
			CASE cte.EstadoCivil WHEN 'CS' THEN 'C'
								 WHEN 'CM' THEN 'C'
								 WHEN 'CC' THEN 'C'
								 WHEN 'SE' THEN 'S'
								 ELSE cte.EstadoCivil END AS EstadoCivil, cte.Sexo AS Genero, IFNULL(cte.FechaNacimiento,Cadena_Vacia) AS FechaNacimiento,
			Var_CodCooperativa AS CodCooperativa,	Var_CodMoneda AS CodMoneda,	Var_CodUsuario AS CodUsuario, TipoCuentaEntura AS TipoCuenta
				FROM CLIENTES cte
		WHERE cte.ClienteID=Par_ClienteID;

	END IF;

	-- Consulta 23: para pantalla de Conocimiento del Cliente
	IF(Par_NumCon=Con_ConocimientoCte)THEN

		SELECT ClienteID,  NombreCompleto, NivelRiesgo, EsMenorEdad, Nacion, ActividadBancoMX
			FROM CLIENTES
				WHERE ClienteID = Par_ClienteID;
	END IF;


    -- Consulta 24: para pantalla de Inconsistencias
	IF(Par_NumCon = Con_PersonaFisica)THEN

		SELECT ClienteID,  NombreCompleto
			FROM CLIENTES
				WHERE ClienteID = Par_ClienteID
                AND TipoPersona <> PersonaMoral;
	END IF;

	-- Consulta 25: Consulta datos del cliente así como la tasa ISR para Aportaciones.
	IF(Par_NumCon = Con_Aportaciones) THEN
		SET Var_PaisIDBase := FNPARAMGENERALES('PaisIDBase');
		SELECT
			C.ClienteID,	C.NombreCompleto,	C.Telefono,			C.PagaISR,	C.Clasificacion,
			C.EsMenorEdad,	C.CalificaCredito,	UPPER(P.Nombre) AS PaisResidencia,
			IF(C.PaisResidencia = Var_PaisIDBase,CadenaNO,CadenaSI) AS ValidaTasa,
			IF(C.PagaISR = CadenaSI,IF(C.PaisResidencia = Var_PaisIDBase, S.TasaISR, FNTASAISREXT(C.PaisResidencia,1,Fecha_Vacia,Entero_Cero)),Entero_Cero) AS TasaISR
		FROM CLIENTES C
			INNER JOIN SUCURSALES S ON C.SucursalOrigen = S.SucursalID
			INNER JOIN PAISES P ON C.PaisResidencia = P.PaisID
		WHERE C.ClienteID = Par_ClienteID;
	END IF;

	--  Consulta 26 de Cliente Para la pantalla Solicitud de Credito Consolidada
	IF( Par_NumCon = Con_CliCreditoConsolidado ) THEN
		SELECT 	 COUNT(Cre.ClienteID)
			INTO NumCreditos
			FROM CREDITOS Cre
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
				WHERE Cre.ClienteID = Par_ClienteID
				AND Cre.Estatus IN (Est_Vigente, Est_Vencido)
				AND Cre.EsAgropecuario = CadenaSI;

		SET NumCreditos := IFNULL(NumCreditos,Entero_Cero);


		IF(NumCreditos > Entero_Cero)THEN
			SELECT 	 DISTINCT(Cre.ClienteID) AS ClienteID,	Cli.NombreCompleto
			FROM CREDITOS Cre
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
				WHERE Cre.ClienteID = Par_ClienteID
				AND Cre.Estatus IN (Est_Vigente, Est_Vencido)
				AND Cre.EsAgropecuario = CadenaSI;
		ELSE
			SELECT Cli.ClienteID AS ClienteID,	Cli.NombreCompleto
			FROM CLIENTES Cli
				WHERE Cli.ClienteID = Par_ClienteID;
		END IF;
	END IF;
END TerminaStore$$