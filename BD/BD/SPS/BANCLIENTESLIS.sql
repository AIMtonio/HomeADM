-- BANCLIENTESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS BANCLIENTESLIS;
DELIMITER $$

CREATE PROCEDURE BANCLIENTESLIS (

	Par_NombreComp			VARCHAR(50),			-- Nombre del Cliente
	Par_ClienteID       	INT(11),                -- Cliente ID para consultar
	Par_PromotorID			INT(11),				-- Promotor ID
	Par_Estatus				CHAR(1),				-- Estatus de los clientes a consultar
	Par_TamanioLista		INT(11),				-- Parametro tamanio de la lista
	Par_PosicionInicial		INT(11),				-- Parametro posicion inicial de la lista
    Par_NumLis          	TINYINT UNSIGNED,   	-- Numero de consulta

	Aud_EmpresaID			INT(11),				-- Parametros de auditoria
	Aud_Usuario				INT(11),				-- Parametros de auditoria
	Aud_FechaActual			DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal			INT(11),				-- Parametros de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametros de auditoria
)
TerminaStore: BEGIN

	-- Declaracion d evariables
	DECLARE Var_CantidadRegistro	INT(11);		-- Variable para Guardar  la cantidad de registro

	-- Declaracion de Constantes
	DECLARE Var_NumLisPrincipal		TINYINT UNSIGNED;				-- Lista principal
	DECLARE Var_ListaCLiente		TINYINT UNSIGNED;				-- Lista de ayuda del toda la imformacion del cliente
	DECLARE Var_ListaClientesBanca  TINYINT UNSIGNED;				-- lista para bancas
	DECLARE Entero_Cero				INT(1);							-- Entero cero
	DECLARE Cadena_Vacia			CHAR(1);						-- Cadena Vacia
	DECLARE Entero_Uno				INT(1);							-- Entero uno

	-- Asignacion de Constantes
	SET Var_NumLisPrincipal		:= 1;									-- Lista principal
	SET Var_ListaCLiente		:= 2;									-- Lista de ayuda del toda la imformacion del cliente
	SET Var_ListaClientesBanca  := 3;									-- lista para bancas
	SET Entero_Cero				:= 0;									-- Entero cero
	SET Cadena_Vacia			:= '';									-- Cadena Vacia
	SET Entero_Uno				:= 1;									-- Entero uno

	SET Par_TamanioLista 		:= IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial 	:= IFNULL(Par_PosicionInicial, Entero_Cero);
	SET Par_NombreComp			:= IFNULL(Par_NombreComp, Cadena_Vacia);
	SET Par_Estatus				:= IFNULL(Par_Estatus, Cadena_Vacia);

	IF (Par_NumLis = Var_NumLisPrincipal) THEN
		SET @Var_QueryListaClientes	:= 'SELECT  ClienteID,           SucursalOrigen,          TipoPersona,         Titulo,            PrimerNombre,
        										SegundoNombre,       TercerNombre,            ApellidoPaterno,     ApellidoMaterno,   FechaNacimiento,
        										CURP,                Nacion,                  PaisResidencia,      GrupoEmpresarial,  RazonSocial,
        										TipoSociedadID,      Fax,                     Correo,              RFC,               RFCpm,
        										RFCOficial,          SectorGeneral,           ActividadBancoMX,    ActividadINEGI,    ActividadFR,
        										ActividadFOMURID,    SectorEconomico,         Sexo,                EstadoCivil,       LugarNacimiento,
        										EstadoID,            OcupacionID,             LugardeTrabajo,      Puesto,            DomicilioTrabajo,
        										TelTrabajo,          AntiguedadTra,           TelefonoCelular,     Telefono,          Clasificacion,
        										MotivoApertura,      PagaISR,                 PagaIVA,             PagaIDE,           NivelRiesgo,
        										PromotorInicial,     PromotorActual,          FechaAlta,           Estatus,           CONCAT(CONCAT(NombreCompleto,' - '),Observaciones) as NombreCompleto,
        										TipoInactiva,        MotivoInactiva,          EsMenorEdad,         CorpRelacionado,   CalificaCredito,
        										RegistroHacienda,    FechaBaja,               Observaciones,       NoEmpleado,        TipoEmpleado,
        										ExtTelefonoPart,     ExtTelefonoTrab,         EjecutivoCap,        PromotorExtInv,    TipoPuesto,
        										FechaIniTrabajo,     UbicaNegocioID,          FechaConstitucion,   FEA,               PaisFEA,
        										PaisConstitucionID,  CorreoAlterPM,           NombreNotario,       NumNotario,        InscripcionReg,
        										EscrituraPubPM,      SoloNombres,             SoloApellidos,       FechaSigEvalPLD
										FROM CLIENTES';
		IF (Par_ClienteID >  Entero_Cero) THEN
				SET @Var_QueryListaClientes := CONCAT(@Var_QueryListaClientes, ' WHERE ClienteID = ', Par_ClienteID);
		END IF;
		IF (Par_ClienteID = Entero_Cero) THEN

				IF (Par_NombreComp != Cadena_Vacia) THEN
					SET @Var_QueryListaClientes := CONCAT(@Var_QueryListaClientes, ' WHERE NombreCompleto LIKE "%', Par_NombreComp,'%"');
				END IF;

				SET @Var_QueryListaClientes := CONCAT(@Var_QueryListaClientes, ' ORDER BY ClienteID ');
				IF (Par_TamanioLista > Entero_Cero) THEN
					SET @Var_QueryListaClientes := CONCAT(@Var_QueryListaClientes, ' LIMIT ', Par_PosicionInicial, ' , ', Par_TamanioLista);
				END IF;
				IF (Par_TamanioLista = Entero_Cero AND Par_PosicionInicial > Entero_Cero ) THEN
					SELECT COUNT(ClienteID)
						INTO Par_TamanioLista
						FROM CLIENTES;
					SET @Var_QueryListaClientes := CONCAT(@Var_QueryListaClientes, ' LIMIT ', Par_PosicionInicial, ' , ', Par_TamanioLista);
				END IF;
		END IF;
		PREPARE sentenciaListaClientes FROM @Var_QueryListaClientes;
		EXECUTE sentenciaListaClientes;
		DEALLOCATE PREPARE sentenciaListaClientes;
	END IF;


	IF(Par_NumLis = Var_ListaCLiente) THEN

		DROP TABLE IF EXISTS TMPCLIENTES;
		CREATE TEMPORARY TABLE TMPCLIENTES
			SELECT	CLI.ClienteID,						CLI.SucursalOrigen,						SUC.NombreSucurs,						CLI.TipoPersona,					CASE WHEN CLI.TipoPersona = 'M' THEN 'Persona Moral' WHEN CLI.TipoPersona = 'A' THEN 'Persona Fisica' WHEN CLI.TipoPersona = 'F' THEN 'Persona Fisica Sin Actividad Empresarial' END AS DescTipoPersona,
					CLI.Titulo,							CLI.PrimerNombre,						CLI.SegundoNombre,						CLI.TercerNombre,					CLI.ApellidoPaterno,
					CLI.ApellidoMaterno,				CLI.FechaNacimiento,					CLI.CURP,								CLI.Nacion,							CASE WHEN CLI.Nacion = 'N' THEN 'Nacional' WHEN CLI.Nacion = 'E' THEN 'Extranjero' END AS DescNacionalidad,
					CLI.PaisResidencia,					PAIS.Nombre AS NombrePais,				CLI.GrupoEmpresarial,					GRUP.NombreGrupo,					CLI.RazonSocial,
					CLI.TipoSociedadID,					'' AS DescTipoSociedad,					CLI.Fax,								CLI.Correo,							CLI.RFC,
					CLI.SectorGeneral,					'' AS DescSectorGeneral,				CLI.ActividadBancoMX,					'' AS DescActividadBancoMX,			CLI.ActividadINEGI,
					'' AS DescActividadINEGI,			CLI.ActividadFR,						'' AS DesActividadFR,					CLI.ActividadFOMURID,				'' AS DescActividadFOMURID,
					CLI.SectorEconomico,				'' AS DescSectorEconomico,				CLI.Sexo,								CASE WHEN CLI.Sexo = 'M' THEN 'Masculino' WHEN CLI.Sexo = 'F' THEN 'Femenino' END AS DescSexo,
					CLI.EstadoCivil,					CLI.LugarNacimiento,					'' AS NombrePaisNacimiento,				CLI.EstadoID,						'' AS NombreEstado,
					CLI.OcupacionID,					'' AS DescOcupacion,					CLI.LugardeTrabajo,						CLI.Puesto,							CLI.DomicilioTrabajo,
					CLI.TelTrabajo,						CLI.AntiguedadTra,						CLI.TelefonoCelular,					CLI.Telefono,						CLI.Clasificacion,
					CLI.MotivoApertura,					CLI.PagaISR,							CLI.PagaIVA,							CLI.PagaIDE,						CASE WHEN CLI.NivelRiesgo = 'A' THEN 'Alto' WHEN CLI.NivelRiesgo = 'M' THEN 'Medio' WHEN CLI.NivelRiesgo = 'B' THEN 'Bajo'  END AS DescNivelRiesgo,
					CLI.NivelRiesgo,					CLI.PromotorInicial,					'' AS NombrePromInicial,				CLI.PromotorActual,					'' AS NombrePromActual,
					CLI.FechaAlta,						CLI.Estatus,							CASE WHEN CLI.Estatus = 'I' THEN 'Inactivo' WHEN CLI.Estatus = 'A' THEN 'Activo' END AS DescEstatus,
					CLI.NombreCompleto,					CLI.TipoInactiva,						CASE WHEN CLI.TipoInactiva = '1' THEN 'Activacion' WHEN CLI.TipoInactiva = '2' THEN 'Inactivacion' END AS DescTipoInctividad,
					CLI.MotivoInactiva,					CLI.EsMenorEdad,						CLI.CorpRelacionado,					CLI.CalificaCredito,				CASE WHEN CLI.CalificaCredito = 'N' THEN 'No Asignada' WHEN CLI.CalificaCredito = 'A' THEN 'Excelente' WHEN CLI.CalificaCredito = 'B' THEN 'Buena' WHEN CLI.CalificaCredito = 'C' THEN 'Regular'   END AS DescCalificaCredito,
					CLI.RegistroHacienda,				CLI.FechaBaja,							CLI.Observaciones,						CLI.NoEmpleado,						CLI.TipoEmpleado,
					CLI.ExtTelefonoPart,				CLI.ExtTelefonoTrab,					CLI.EjecutivoCap,						'' AS NombreEjecuCap,					CLI.PromotorExtInv,
					'' AS NombrePromExtInv,				CLI.TipoPuesto,							CLI.FechaIniTrabajo,					CLI.UbicaNegocioID,					'' AS DescUbicacionNeg,
					CLI.FechaConstitucion,				CLI.FEA,								CLI.PaisFEA,							'' AS DescPaisFEA,					CLI.PaisConstitucionID,
					'' AS DescPaisConstitucion,			CLI.CorreoAlterPM,						CLI.NombreNotario,						CLI.NumNotario,						CLI.InscripcionReg,
					CLI.EscrituraPubPM,					CLI.SoloNombres,						CLI.SoloApellidos,						CLI.FechaSigEvalPLD,				CLI.PaisNacionalidad,
					'' AS DescPaisNacionalidad,			CLI.TamanioAcreditado,					DIR.Longitud,							DIR.Latitud,
				CASE	WHEN CLI.EstadoCivil = 'S' THEN 'Soltero'
						WHEN CLI.EstadoCivil = 'CS' THEN 'Casado Bienes Separado'
						WHEN CLI.EstadoCivil = 'CM' THEN 'Casado Bienes Mancomunados'
						WHEN CLI.EstadoCivil = 'CC' THEN 'Casado Bienes Mancomunados Con Capitulacion'
						WHEN CLI.EstadoCivil = 'V' THEN 'Viudo'
						WHEN CLI.EstadoCivil = 'D' THEN 'Divorciado'
						WHEN CLI.EstadoCivil = 'SE' THEN 'Separado'
						WHEN CLI.EstadoCivil = 'U' THEN 'Union Libre'
				END AS DescEstadoCivil,
				CASE	WHEN CLI.Clasificacion = 'I' THEN 'Cliente independiente'
						WHEN CLI.Clasificacion = 'N' THEN 'Cliente Empresa de Nomina'
						WHEN CLI.Clasificacion = 'E' THEN 'Cliente Empleado'
						WHEN CLI.Clasificacion = 'C' THEN 'Cliente Corportativo'
						WHEN CLI.Clasificacion = 'R' THEN 'Relacionado a Corporativo'
						WHEN CLI.Clasificacion = 'F' THEN 'Negocio Afiliado'
						WHEN CLI.Clasificacion = 'M' THEN 'Empleado de Nomina'
						WHEN CLI.Clasificacion = 'O' THEN 'Cliente Funcionario'
				END AS DescClasificacion,
				CASE	WHEN CLI.MotivoApertura = '1' THEN 'Credito'
						WHEN CLI.MotivoApertura = '2' THEN 'Recomendado'
						WHEN CLI.MotivoApertura = '3' THEN 'Publicidad  Campaña Promocion'
						WHEN CLI.MotivoApertura = '4' THEN 'Necesidad Proveedor'
						WHEN CLI.MotivoApertura = '5' THEN 'Cercania de Sucursal'
						WHEN CLI.MotivoApertura = '6' THEN 'Cuenta de Captacion'
				END AS DescMotivoApertura
			FROM CLIENTES CLI
			INNER JOIN SUCURSALES SUC ON SUC.SucursalID = CLI.SucursalOrigen
			LEFT JOIN PAISES PAIS ON PAIS.PaisID = CLI.PaisResidencia
			LEFT JOIN GRUPOSEMP GRUP ON GRUP.GrupoEmpID = CLI.GrupoEmpresarial
			LEFT JOIN DIRECCLIENTE DIR ON DIR.ClienteID = CLI.ClienteID AND DIR.Oficial = 'S'
			WHERE CLI.ClienteID = IF(Par_ClienteID > Entero_Cero, Par_ClienteID, CLI.ClienteID)
			AND CLI.NombreCompleto LIKE IF(Par_NombreComp <> Cadena_Vacia, CONCAT("%",Par_NombreComp,"%"), CLI.NombreCompleto)
			AND CLI.PromotorActual = IF(Par_PromotorID > Entero_Cero, Par_PromotorID, CLI.PromotorActual)
			AND CLI.Estatus = IF(Par_Estatus != Cadena_Vacia, Par_Estatus, CLI.Estatus);

			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescTipoSociedad DescTipoSociedad VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescSectorGeneral DescSectorGeneral VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescActividadBancoMX DescActividadBancoMX VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescActividadINEGI DescActividadINEGI VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DesActividadFR DesActividadFR VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescActividadFOMURID DescActividadFOMURID VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescSectorEconomico DescSectorEconomico VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN NombrePaisNacimiento NombrePaisNacimiento VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN NombreEstado NombreEstado VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescOcupacion DescOcupacion VARCHAR(300);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN NombrePromInicial NombrePromInicial VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN NombrePromActual NombrePromActual VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN NombreEjecuCap NombreEjecuCap VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN NombrePromExtInv NombrePromExtInv VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescUbicacionNeg DescUbicacionNeg VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescPaisFEA DescPaisFEA VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescPaisConstitucion DescPaisConstitucion VARCHAR(160);
			ALTER TABLE TMPCLIENTES CHANGE COLUMN DescPaisNacionalidad DescPaisNacionalidad VARCHAR(160);

			-- Update de la descripcion de tipo de sociedad
			UPDATE TMPCLIENTES TMP
				INNER JOIN TIPOSOCIEDAD TIPO ON TIPO.TipoSociedadID = TMP.TipoSociedadID
				SET TMP.DescTipoSociedad = TIPO.Descripcion;

			-- Update de la descripcion Sector general
			UPDATE TMPCLIENTES TMP
				INNER JOIN SECTORES SEC ON SEC.SectorID = TMP.SectorGeneral
				SET TMP.DescSectorGeneral = SEC.Descripcion;

			-- Update de la descripcion Actividad  banco mexico
			UPDATE TMPCLIENTES TMP
				INNER JOIN ACTIVIDADESBMX ACBX ON ACBX.ActividadBMXID = TMP.ActividadBancoMX
				SET TMP.DescActividadBancoMX = ACBX.Descripcion;

			UPDATE TMPCLIENTES TMP
				INNER JOIN ACTIVIDADESINEGI ACINE ON ACINE.ActividadINEGIID = TMP.ActividadINEGI
				SET TMP.DescActividadINEGI = ACINE.Descripcion;

			UPDATE TMPCLIENTES TMP
				INNER JOIN ACTIVIDADESFR ACFR ON ACFR.ActividadFRID = TMP.ActividadFR
				SET TMP.DesActividadFR = ACFR.Descripcion;

			UPDATE TMPCLIENTES TMP
				INNER JOIN ACTIVIDADESFOMUR ACFORM ON ACFORM.ActividadFOMURID = TMP.ActividadFOMURID
				SET TMP.DescActividadFOMURID = ACFORM.Descripcion;

			UPDATE TMPCLIENTES TMP
				INNER JOIN SECTORESECONOM SEC ON SEC.SectorEcoID = TMP.SectorEconomico
				SET TMP.DescSectorEconomico = SEC.Descripcion;

			UPDATE TMPCLIENTES TMP
				INNER JOIN PAISES PAIS ON PAIS.PaisID = TMP.LugarNacimiento
				SET TMP.NombrePaisNacimiento = PAIS.Nombre;

			UPDATE TMPCLIENTES TMP
				INNER JOIN ESTADOSREPUB REP ON REP.EstadoID = TMP.EstadoID
				SET TMP.NombreEstado = REP.Nombre;

			UPDATE TMPCLIENTES TMP
				INNER JOIN OCUPACIONES OCUP ON OCUP.OcupacionID = TMP.OcupacionID
				SET TMP.DescOcupacion = OCUP.Descripcion;

			UPDATE TMPCLIENTES TMP
				INNER JOIN PROMOTORES PRO ON PRO.PromotorID = TMP.PromotorInicial
				SET TMP.NombrePromInicial = PRO.NombrePromotor;

			UPDATE TMPCLIENTES TMP
				INNER JOIN PROMOTORES PRO ON PRO.PromotorID = TMP.PromotorActual
				SET TMP.NombrePromActual = PRO.NombrePromotor;

			UPDATE TMPCLIENTES TMP
				INNER JOIN PROMOTORES PRO ON PRO.PromotorID = TMP.EjecutivoCap
				SET TMP.NombreEjecuCap = PRO.NombrePromotor;

			UPDATE TMPCLIENTES TMP
				INNER JOIN PROMOTORES PRO ON PRO.PromotorID = TMP.PromotorExtInv
				SET TMP.NombrePromExtInv = PRO.NombrePromotor;

			UPDATE TMPCLIENTES TMP
				INNER JOIN CATUBICANEGOCIO UBI ON UBI.UbicaNegocioID = TMP.UbicaNegocioID
				SET TMP.DescUbicacionNeg = UBI.Ubicacion;

			UPDATE TMPCLIENTES TMP
				INNER JOIN PAISES PAIS ON PAIS.PaisID = TMP.PaisFEA
				SET TMP.DescPaisFEA = PAIS.Nombre;

			UPDATE TMPCLIENTES TMP
				INNER JOIN PAISES PAIS ON PAIS.PaisID = TMP.PaisConstitucionID
				SET TMP.DescPaisConstitucion = PAIS.Nombre;

			UPDATE TMPCLIENTES TMP
				INNER JOIN PAISES PAIS ON PAIS.PaisID = TMP.PaisNacionalidad
				SET TMP.DescPaisNacionalidad = PAIS.Nombre;

			SELECT COUNT(ClienteID)
				INTO Var_CantidadRegistro
				FROM TMPCLIENTES;

			IF(Par_TamanioLista = Entero_Cero) THEN
				SET Par_TamanioLista		:= Var_CantidadRegistro;
			END IF;

			SELECT	ClienteID,												IFNULL(SucursalOrigen,Entero_Cero) AS SucursalOrigen,	NombreSucurs,													TipoPersona,												DescTipoPersona,
					Titulo,													PrimerNombre,											SegundoNombre,													TercerNombre,												ApellidoPaterno,
					ApellidoMaterno,										FechaNacimiento,										CURP,															Nacion,														DescNacionalidad,
					IFNULL(PaisResidencia,Entero_Cero) AS PaisResidencia,	NombrePais,												IFNULL(GrupoEmpresarial,Entero_Cero) AS GrupoEmpresarial,		NombreGrupo,												RazonSocial,
					IFNULL(TipoSociedadID,Entero_Cero) AS TipoSociedadID,	DescTipoSociedad,										Fax,															Correo,														RFC,
					IFNULL(SectorGeneral,Entero_Cero) AS SectorGeneral,		DescSectorGeneral,										IFNULL(ActividadBancoMX,Entero_Cero) AS ActividadBancoMX,		DescActividadBancoMX,										IFNULL(ActividadINEGI,Entero_Cero) AS ActividadINEGI,
					DescActividadINEGI,										IFNULL(ActividadFR,Entero_Cero) AS ActividadFR,			DesActividadFR,													IFNULL(ActividadFOMURID,Entero_Cero) AS ActividadFOMURID,	DescActividadFOMURID,
					IFNULL(SectorEconomico,Entero_Cero) AS SectorEconomico,	DescSectorEconomico,									Sexo,															DescSexo,													EstadoCivil,
					DescEstadoCivil,										IFNULL(LugarNacimiento,Entero_Cero) AS LugarNacimiento,	NombrePaisNacimiento,											IFNULL(EstadoID, Entero_Cero) AS EstadoID,					NombreEstado,
					IFNULL(OcupacionID,Entero_Cero) AS OcupacionID,			DescOcupacion,											LugardeTrabajo,													Puesto,														DomicilioTrabajo,
					TelTrabajo,												IFNULL(AntiguedadTra,Entero_Cero) AS AntiguedadTra,		TelefonoCelular,												Telefono,													Clasificacion,
					DescClasificacion,										MotivoApertura,											DescMotivoApertura,												PagaISR,													PagaIVA,
					PagaIDE,												NivelRiesgo,											DescNivelRiesgo,												IFNULL(PromotorInicial,Entero_Cero) AS PromotorInicial,		NombrePromInicial,
					IFNULL(PromotorActual,Entero_Cero) AS PromotorActual,	NombrePromActual,										FechaAlta,														Estatus,													DescEstatus,
					CONCAT(CONCAT(NombreCompleto,' - '),Observaciones) as NombreCompleto,											TipoInactiva,											DescTipoInctividad,												MotivoInactiva,												EsMenorEdad,
					CorpRelacionado,										CalificaCredito,										DescCalificaCredito,											RegistroHacienda,											FechaBaja,
					Observaciones,											NoEmpleado,												TipoEmpleado,													ExtTelefonoPart,											ExtTelefonoTrab,
					IFNULL(EjecutivoCap,Entero_Cero) AS EjecutivoCap,		NombreEjecuCap,											IFNULL(PromotorExtInv,Entero_Cero) AS PromotorExtInv,			NombrePromExtInv,											IFNULL(TipoPuesto,Entero_Cero) AS TipoPuesto,
					FechaIniTrabajo,										IFNULL(UbicaNegocioID,Entero_Cero) AS UbicaNegocioID,	DescUbicacionNeg,												FechaConstitucion,											FEA,
					IFNULL(PaisFEA,Entero_Cero) AS PaisFEA,					DescPaisFEA,											IFNULL(PaisConstitucionID,Entero_Cero) AS PaisConstitucionID,	DescPaisConstitucion,										CorreoAlterPM,
					NombreNotario,											IFNULL(NumNotario, Entero_Cero) AS NumNotario,			InscripcionReg,													EscrituraPubPM,												SoloNombres,
					SoloApellidos,											FechaSigEvalPLD,										IFNULL(PaisNacionalidad,Entero_Cero) AS PaisNacionalidad,		DescPaisNacionalidad,										IFNULL(TamanioAcreditado, Entero_Cero) AS TamanioAcreditado,
					Longitud,  												Latitud
			FROM TMPCLIENTES
			ORDER BY ClienteID
			LIMIT Par_PosicionInicial, Par_TamanioLista;

		DROP TABLE IF EXISTS TMPCLIENTES;
	END IF;

	IF (Par_NumLis = Var_ListaClientesBanca) THEN

		SELECT  SucursalOrigen,		PromotorActual, CalificaCredito
				FROM CLIENTES
				WHERE ClienteID = Par_ClienteID
				ORDER BY ClienteID;


	END IF;
END TerminaStore$$

