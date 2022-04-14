-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUROCREDINTFREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUROCREDINTFREP`;
DELIMITER $$

CREATE PROCEDURE `BUROCREDINTFREP`(
#SP QUE GENERA LAS CINTAS DE BURO DE CREDITO PARA PERSONAS FISICAS Y MORALES
	Par_Fecha 				DATE,			-- Fecha de Generacion del Reporte
	Par_TiempoReporte		CHAR(1),		-- Tipo de Reporte "S".- Semanal "M".- Mensual "D".- Diario
	Par_TipoPersona			INT(5),			-- Tipo de Persona 1.- Fisica 2- Moral
	Par_TipoFormatoCinta	INT(11),		-- Tipo de Formato de la cinta de buro 1.-Formato CSV, 2.-Formato INTL, 3._Formato EXT

	/* Parametros de Auditoria */
	Par_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),

	Aud_FechaActual 		DATETIME,
	Aud_DireccionIP 		VARCHAR(15),
	Aud_ProgramaID 			VARCHAR(50),
	Aud_Sucursal 			INT(11),
	Aud_NumTransaccion 		BIGINT(20)
)
TerminaStore: BEGIN

#DECLARACION DE VARIABLES
DECLARE NumCintas 				INT;
DECLARE Var_UltFechaCorte		DATE;			-- Fecha de Ultimo Corte
DECLARE Var_fechaUltDia			DATE;			-- Ultimo dia del Mes
DECLARE Var_CintaID				INT;			-- ID de Cinta
DECLARE Var_ClaveOtorgante		VARCHAR(20);	-- Clave del Otorgante
DECLARE Var_NombreReporte		VARCHAR(40);	-- Nombre del Reporte
DECLARE Var_CliProEsp   		INT;			-- Almacena el Numero de Cliente para Procesos Especificos
DECLARE Var_Llamada 			VARCHAR(1000);	-- Almacena la llamada a realizar el proceso
DECLARE Var_ProcPersonalizado 	VARCHAR(200);   -- Almacena el nombre del SP para generar los detalles de los creditos
DECLARE Var_ProcPersonalizadoSM	VARCHAR(200);   -- Almacena el nombre del SP para generar los detalles de los creditos
DECLARE Var_ProcDefault		 	VARCHAR(200);   -- Almacena el nombre del SP para generar los detalles de los creditos
DECLARE Var_ProcDefaultSM 		VARCHAR(200);   -- Almacena el nombre del SP para generar los detalles de los creditos

#DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia 		CHAR(1);		-- Constante Cadena Vacia
DECLARE Fecha_Vacia 		DATE;			-- Constante Fecha Vacia
DECLARE Entero_Cero 		INT;			-- Constante Entero Vacio
DECLARE ReporteDiario 		CHAR(1);		-- Reporte Diario
DECLARE ReporteMensual 		CHAR(1);		-- Reporte Mensual
DECLARE ReporteSemanal 		CHAR(1);		-- Reporte Semanal
DECLARE ReporteVtaCartera	CHAR(1);		-- Reporte Venta Cartera
DECLARE Entero_Uno			INT;			-- Constante Entero Uno
DECLARE PerFisica			INT;			-- Constante Persona Fisica
DECLARE PerMoral			INT;			-- Constante Persona Moral
DECLARE FormatoFecha		VARCHAR(10);	-- Formato de Fecha
DECLARE Var_FechaReporte	DATE;			-- Fecha del Reporte
DECLARE Con_CliProcEspe     VARCHAR(20);	-- Numero de Cliente para Procesos Especificos
DECLARE CintaBuroPFMensual	INT;			-- Numero de Procedimiento para la cinta de Buro de Persona Fisica mensual
DECLARE CintaBuroPFSemanal	INT;			-- Numero de Procedimiento para la cinta de Buro de Persona Fisica Semanal
DECLARE NumClienteTLR		INT;			-- Numero de Cliente para Tu Lanita Rapida Procesos Especificos: 14
DECLARE NumClienteConsol	INT;			-- Numero de Cliente para Consol Procesos Especificos: 10
DECLARE NumClienteCrediClub INT;			-- Numero de Cliente para CREDICLUB Procesos Especificos: 24

#ASIGNACION DE CONSTANTES
SET Cadena_Vacia 			:= '';
SET Fecha_Vacia	 			:= '1900-01-01';
SET Entero_Cero 			:= 	0;
SET ReporteDiario 			:= 'D';
SET ReporteMensual			:= 'M';
SET ReporteSemanal 			:= 'S';
SET ReporteVtaCartera		:= 'V';
SET Entero_Uno				:=	1;
SET PerFisica				:=  1;
SET PerMoral				:=  2;
SET FormatoFecha			:= '%d%m%Y';
SET Con_CliProcEspe			:= 'CliProcEspecifico';
SET CintaBuroPFMensual 		:=  12;
SET CintaBuroPFSemanal 		:=  23;
SET NumClienteTLR	 		:=  14;
SET NumClienteConsol		:=  10;
SET NumClienteCrediClub     :=  24;

ManejoErrores:BEGIN

	# SE OBTIENE LA CLAVE DEL OTORGANTE PARA ARMAR EL NOMBRE DEL ARCHIVO GENERADO
	SELECT ClaveInstitID
		  INTO Var_ClaveOtorgante
			FROM BUCREPARAMETROS;

	-- Validacion de datos nulo
	SET Par_TipoFormatoCinta := IFNULL(Par_TipoFormatoCinta, Entero_Cero);

	/* SE OBTIENE EL NUMERO DE CLIENTE PARA PROCESOS ESPECIFICOS
	 * 7  SANA TUS FINANZAS
	 * 9  ACCION Y EVOLUCION
	 * 14 TLR
	 * 15 SOFIEXPRESS
	 * 24 CREDI CLUB
	 */
	SET Var_CliProEsp 	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
	SET Var_CliProEsp 	:= IFNULL(Var_CliProEsp,Entero_Cero);

	/* SE OBTIENE EL NOMBRE DEL SP A REALIZAR EL PROCESO MENSUAL DEFAULT */
	SET Var_ProcDefault		:= (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = CintaBuroPFMensual AND CliProEspID = Entero_Cero);
	SET Var_ProcDefaultSM	:= (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = CintaBuroPFSemanal AND CliProEspID = Entero_Cero);

	/* SE OBTIENE EL NOMBRE DEL SP A REALIZAR EL PROCESO MENSUAL*/

	SET Var_ProcPersonalizado	:= Var_ProcDefault;
	SET Var_ProcPersonalizadoSM	:= Var_ProcDefaultSM;

	-- SI EL CLIENTE ES TRL, ENTONCES SE REPORTA LA CINTA CON LA VERSION DEL SAFI 1.39
	IF(Var_CliProEsp=NumClienteTLR)THEN
		SET Var_ProcPersonalizado 	:= (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = CintaBuroPFMensual AND CliProEspID = NumClienteTLR);
		SET Var_ProcPersonalizadoSM	:= (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = CintaBuroPFSemanal AND CliProEspID = NumClienteTLR);
	END IF;

	/*LLamada especial para cliente consol contiene los datos de creditos contingentes creados apartir de creditos agro*/
	IF(Var_CliProEsp=NumClienteConsol)THEN
		SET Var_ProcPersonalizado 	:= (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = CintaBuroPFMensual AND CliProEspID = NumClienteConsol);
		SET Var_ProcPersonalizadoSM	:= (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = CintaBuroPFSemanal AND CliProEspID = NumClienteConsol);
	END IF;

	-- LLamada especial para cliente Crediblub
	IF(Var_CliProEsp=NumClienteCrediClub)THEN
		SET Var_ProcPersonalizado   := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = CintaBuroPFMensual AND CliProEspID = NumClienteCrediClub);
		SET Var_ProcPersonalizadoSM  := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = CintaBuroPFSemanal AND CliProEspID = NumClienteCrediClub);
	END IF;

	SET Var_ProcPersonalizado 	:= IFNULL(Var_ProcPersonalizado,Var_ProcDefault);
	SET Var_ProcPersonalizadoSM	:= IFNULL(Var_ProcPersonalizadoSM,Var_ProcDefaultSM);

	#LLENA LA TABLA CON LOS DATOS PERSONA FISICA
	IF( Par_TipoPersona = PerFisica)THEN

		-- Reporte Diario
		IF(Par_TiempoReporte = ReporteDiario) THEN
			SET Var_FechaReporte := Par_Fecha;
			SET Var_CintaID:= (SELECT COALESCE(MAX(CintaID),Entero_Cero) FROM BUROCREDINTF ) + Entero_Uno;
			-- LLAMA SP QUE GENERA LA CINTA DIARIA PF
			CALL CINTAINTFPRO(	Par_Fecha,    		Par_EmpresaID,  	Aud_Usuario, 		Aud_FechaActual ,
								Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion );

		END IF;

		-- Reporte Mensual
		IF(Par_TiempoReporte = ReporteMensual) THEN
			SET Var_CintaID := (SELECT COALESCE(MAX(CintaID),Entero_Cero) FROM BUROCREDINTFMEN ) + Entero_Uno;
			SET Var_fechaUltDia := LAST_DAY(Par_Fecha);
			SET Var_FechaReporte := Var_fechaUltDia;
			SELECT MAX(FechaCorte) INTO Var_UltFechaCorte FROM SALDOSCREDITOS WHERE FechaCorte <= Var_fechaUltDia;
			SET Var_UltFechaCorte := IFNULL(Var_UltFechaCorte, Fecha_Vacia);

			-- LLAMA SP QUE GENERA LA CINTA MENSUAL PF
			SET Var_Llamada := CONCAT('CALL ',Var_ProcPersonalizado,'(',
										'\'', Var_UltFechaCorte,	 '\',',Var_CintaID,   		',',Par_EmpresaID,   ',',Aud_Usuario,
										',\'',Aud_FechaActual, '\',', '\'',Aud_DireccionIP, '\',\'',Aud_ProgramaID,'\',',Aud_Sucursal, ',',Aud_NumTransaccion,');');
			SET @Sentencia	:= (Var_Llamada);
			PREPARE STCINTAMENSUALPF FROM @Sentencia;
			EXECUTE STCINTAMENSUALPF;
			DEALLOCATE PREPARE STCINTAMENSUALPF;

			SET Par_Fecha := Var_UltFechaCorte;

		END IF;

		-- Reporte Semanal
		IF(Par_TiempoReporte = ReporteSemanal) THEN

			SET Var_CintaID := (SELECT COALESCE(MAX(CintaID),Entero_Cero) FROM BUROCREDINTFMEN ) + Entero_Uno;
			-- LLAMA SP QUE GENERA LA CINTA SEMANAL PF
			SET Var_Llamada := CONCAT('CALL ',Var_ProcPersonalizadoSM,'(',
										'\'', Par_Fecha,	   		'\',',Var_CintaID,',', Par_TipoFormatoCinta,   	',',Par_EmpresaID,	',',Aud_Usuario,
										',\'',Aud_FechaActual, '\',','\'',Aud_DireccionIP, '\',\'',Aud_ProgramaID,'\',',Aud_Sucursal, ',',Aud_NumTransaccion,');');
			SET @Sentencia	:= (Var_Llamada);

			PREPARE STCINTAMENSUALPF FROM @Sentencia;
			EXECUTE STCINTAMENSUALPF;
			DEALLOCATE PREPARE STCINTAMENSUALPF;

		END IF;
	END IF;

	#LLENA LA TABLA CON LOS DATOS PERSONA MORAL
	IF( Par_TipoPersona = PerMoral)THEN

		-- Reporte Mensual
		IF( Par_TiempoReporte = ReporteMensual ) THEN
			SET Var_CintaID := (SELECT COALESCE(MAX(CintaID),Entero_Cero) FROM BUROCREDINTFPM ) + Entero_Uno;
			SET Var_fechaUltDia := LAST_DAY(Par_Fecha);
			SET Var_FechaReporte := Var_fechaUltDia;
			SELECT MAX(FechaCorte) INTO Var_UltFechaCorte FROM SALDOSCREDITOS WHERE FechaCorte <= Var_fechaUltDia;
			SET Var_UltFechaCorte := IFNULL(Var_UltFechaCorte, Fecha_Vacia);

			-- LLAMA SP QUE GENERA LA CINTA MENSUAL PM
			CALL CINTABNCPMPRO(	Var_UltFechaCorte,	ReporteMensual,		Var_CintaID,		Par_TipoFormatoCinta,		Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
								Aud_NumTransaccion);

			SET Par_Fecha := Var_UltFechaCorte;

		END IF;

		-- Reporte Semanal
		IF( Par_TiempoReporte = ReporteSemanal ) THEN

			SET Var_CintaID := (SELECT COALESCE(MAX(CintaID),Entero_Cero) FROM BUROCREDINTFPM ) + Entero_Uno;

			-- LLAMA SP QUE GENERA LA CINTA SEMANAL PM
			CALL CINTABNCPMPRO(	Par_Fecha,			ReporteSemanal,		Var_CintaID,		Par_TipoFormatoCinta,			Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,					Aud_Sucursal,
								Aud_NumTransaccion);

		END IF;
	END IF;

	IF(Par_Fecha = Fecha_Vacia)THEN
		SET Par_Fecha := (SELECT MAX(Fecha) FROM BUROCREDINTF);
	END IF;

	IF(Par_TipoFormatoCinta = 3)THEN
		# SE ARMA EL NOMBRE DEL REPORTE A GENERAR
		SET Var_NombreReporte := CONCAT(IFNULL(Var_ClaveOtorgante,Cadena_Vacia),'_',DATE_FORMAT(IFNULL(Par_Fecha,Fecha_Vacia),FormatoFecha));
		SET Var_NombreReporte := IFNULL(Var_NombreReporte,Cadena_Vacia);
		ELSE
			# SE ARMA EL NOMBRE DEL REPORTE A GENERAR
			SET Var_NombreReporte := CONCAT(IFNULL(Var_ClaveOtorgante,Cadena_Vacia),'_',DATE_FORMAT(IFNULL(Var_FechaReporte,Fecha_Vacia),FormatoFecha));
			SET Var_NombreReporte := IFNULL(Var_NombreReporte,Cadena_Vacia);
	END IF;


	-- Reporte Diario para Persona Fisica
	IF(Par_TiempoReporte = ReporteDiario AND Par_TipoPersona = PerFisica) THEN
		SELECT Cinta, Var_NombreReporte AS NombreArchivoCinta,	Cadena_Vacia AS HeaderINTL
		FROM BUROCREDINTF
		WHERE Fecha = Par_Fecha
		  AND IFNULL(Cinta,Cadena_Vacia) <> Cadena_Vacia;
	END IF;

	-- Reporte Mensual para Persona Fisica
	IF (Par_TiempoReporte = ReporteMensual AND Par_TipoPersona = PerFisica) THEN
		SELECT Cinta, Var_NombreReporte AS NombreArchivoCinta,	Cadena_Vacia AS HeaderINTL
		FROM BUROCREDINTFMEN
		WHERE Fecha = Par_Fecha
		  AND IFNULL(Cinta,Cadena_Vacia) <> Cadena_Vacia;
	END IF;

	-- Reporte Semanal para Persona Fisica
	IF (Par_TiempoReporte = ReporteSemanal AND Par_TipoPersona = PerFisica) THEN
		SELECT Cinta, Var_NombreReporte AS NombreArchivoCinta,	Cadena_Vacia AS HeaderINTL
		FROM BUROCREDINTFMEN
		WHERE Fecha = Par_Fecha
		  AND IFNULL(Cinta,Cadena_Vacia) <> Cadena_Vacia;
	END IF;

	-- Reporte Mensual para Persona Moral
	IF (Par_TiempoReporte = ReporteMensual AND Par_TipoPersona = PerMoral AND Par_TipoFormatoCinta = Entero_Uno) THEN
		SELECT Cinta, Var_NombreReporte AS NombreArchivoCinta,	Cadena_Vacia AS HeaderINTL
		FROM BUROCREDINTFPM
		WHERE Fecha = Par_Fecha
		  AND CintaID = Var_CintaID AND IFNULL(Cinta,Cadena_Vacia)<>Cadena_Vacia;
	END IF;

	-- Reporte Semanal para Persona Moral
	IF (Par_TiempoReporte = ReporteSemanal AND Par_TipoPersona = PerMoral AND Par_TipoFormatoCinta = Entero_Uno) THEN
		SELECT Cinta, Var_NombreReporte AS NombreArchivoCinta,	Cadena_Vacia AS HeaderINTL
		FROM BUROCREDINTFPM
		WHERE Fecha = Par_Fecha
		  AND CintaID = Var_CintaID AND IFNULL(Cinta,Cadena_Vacia)<>Cadena_Vacia;
	END IF;


	-- Reporte Venta de Cartera
	IF (Par_TiempoReporte = ReporteVtaCartera AND Par_TipoFormatoCinta = Entero_Uno) THEN

		SET Var_CintaID := (SELECT COALESCE(MAX(CintaID),Entero_Cero) FROM BUROCREDINTFMEN ) + Entero_Uno;
		SET Var_fechaUltDia := LAST_DAY(Par_Fecha);
		SET Var_FechaReporte := Var_fechaUltDia;
		SET Var_UltFechaCorte := IFNULL(Var_UltFechaCorte, Fecha_Vacia);

		CALL CINTAINTFMENSUALVTAPRO(
			Par_Fecha,			Var_CintaID,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP, 	Aud_ProgramaID,		Aud_Sucursal, 	Aud_NumTransaccion);

		SELECT Cinta, Var_NombreReporte AS NombreArchivoCinta,	Cadena_Vacia AS HeaderINTL
		FROM BUROCREDINTFMEN
		WHERE Fecha = Par_Fecha
		  AND IFNULL(Cinta,Cadena_Vacia) <> Cadena_Vacia;
	END IF;
END ManejoErrores;

END TerminaStore$$