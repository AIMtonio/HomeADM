-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CINTACIRCULOCREPMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CINTACIRCULOCREPMREP`;

DELIMITER $$
CREATE PROCEDURE `CINTACIRCULOCREPMREP`(
	-- Reporte de la Cinta para Envio a Circulo de Credito.para personas Morales y con Actividad Fisica
	Par_Fecha 			DATE,           -- Fecha del Reporte
	Par_TipoReporte		INT(11),        -- Tipo de Reporte

	Par_EmpresaID       INT(11),        -- Parametro de auditoria ID de la empresa
	Aud_Usuario         INT(11),        -- Parametro de auditoria ID del usuario
	Aud_FechaActual     DATETIME,       -- Parametro de auditoria Feha actual
	Aud_DireccionIP     VARCHAR(15),    -- Parametro de auditoria Direccion IP
	Aud_ProgramaID      VARCHAR(50),    -- Parametro de auditoria Programa
	Aud_Sucursal        INT(11),        -- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion  BIGINT(20)      -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaInicio				DATE;			-- Fecha de Inicio
	DECLARE Var_FechaPago 				DATE;			-- Fecha de Pago
	DECLARE Var_FechaCorte				DATE;			-- Maxima Fecha de Corte del Credito
	DECLARE Var_Intereses				INT(11);		-- Numero de Intereses Moratorios
	DECLARE Var_ContadorDirectivo 		INT(11);		-- Numero de Directivos
	DECLARE Var_ContadorAval 			INT(11);		-- Numero de Avales
	DECLARE Var_MaxIteracion 			INT(11);		-- Numero de Creditos a Recorrer
	DECLARE Var_Contador 				INT(11);		-- Contador de Cilo Principal
	DECLARE Var_RegistroID 				INT(11);		-- Registro de Tabla Principal
	DECLARE Var_IteracionCreditos		INT(11);		-- Iteracion de Credito para la Tabla Principal
	DECLARE Var_ClienteID 				INT(11);		-- Numero de Cliente
	DECLARE Var_NumeroRegistros 		INT(11);		-- Numero de Registros a recorrer en el While Secundario
	DECLARE Var_ParticipanteID 			INT(11);		-- Numero de Participante
	DECLARE Var_DirectivoID 			INT(12);		-- Numero de Participante
	DECLARE Var_EstadoID 				INT(11);		-- Estado del Accionista o Aval
	DECLARE Var_MunicipioID 			INT(11);		-- Municipio del Accionista o Aval
	DECLARE Var_RegistroDirectivo		INT(11);		-- Registro de Directivos
	DECLARE Var_RegistroAval			INT(11);		-- Registro de Avales
	DECLARE Var_MontoCredito 			INT(20);		-- Monto de Credito
	DECLARE Var_MontoTotalPago			INT(20);		-- Monto de Pago Credito
	DECLARE Var_CreditoMaximo			INT(20);		-- Monto Maximo Autorizado de Credito al cliente
	DECLARE Var_ImportePago 			INT(20);		-- Importe de Pago por Amortizacion de credito
	DECLARE Var_Condonaciones 			INT(20);		-- Importe de Condonaciones
	DECLARE Var_MontoCastigo 			INT(20);		-- Importe de Castgo
	DECLARE Var_SaldoInsoluto			INT(20);		-- Saldo Total de Credito
	DECLARE Var_SaldoInteres			INT(20);		-- Saldo Total de Interes de Credito
	DECLARE Var_MontoPago 				DECIMAL(14,2);	-- Monto de Pago de la primer Amortizacion
	DECLARE Var_DiasAtraso 				INT(3);			-- Numero de Dias de Atraso
	DECLARE Var_PlazoID 				INT(6);			-- Plazo del Credito
	DECLARE Var_PlazoCredito 			INT(11);			-- Plazo del Credito
	DECLARE Var_NumPagos 				INT(4);			-- Numero de Pagos
	DECLARE Var_CreditoID 				BIGINT(12);		-- Numero de Credito
	DECLARE Var_SolicitudCreditoID		BIGINT(20);		-- Numero de Solicitud de Credito Asociada al Cliente
	DECLARE Var_NumTransaccion	 		BIGINT(20);		-- Numero de transaccion de pago de credito
	DECLARE Var_EstatusCredito			CHAR(1);		-- Estatus del Crediot
	DECLARE Var_TablaBase 				CHAR(1);		-- Tabla base de consulta
	DECLARE Var_Tabla 					CHAR(1);		-- Tabla base de consulta
	DECLARE Var_Frecuencia	 			CHAR(1);		-- Frecuencia de Pago de Creditos
	DECLARE Var_MonedaID 				INT(11);		-- Moneda del Credito
	DECLARE Var_FechaTerminacion 		VARCHAR(8);		-- Fecha de Terminacion de Credito
	DECLARE Var_FechaTraspasoVenc 		VARCHAR(8);		-- Fecha de Paso a Vencido de Credito
	DECLARE Var_FechaRestructura		VARCHAR(8);		-- Fecha de Reestructura de Credito
	DECLARE Var_FechaIncumplimiento 	VARCHAR(8);		-- Fecha de Primer Incumplimiento de Credito
	DECLARE Var_FechaInicioCre 			VARCHAR(8);		-- Fecha de Inicio del Credito
	DECLARE Var_EqBuroCred 				CHAR(3);		-- Equivalencia de moneda en circulo de credito
	DECLARE Var_PeriodicidadCap 		INT(5);			-- Periodiciada de Pago de Credito


	DECLARE Var_RFCAccionista 			VARCHAR(13);	-- RFC del Accionista
	DECLARE Var_CURPAccionista 			VARCHAR(18);	-- CURP del Accionista
	DECLARE Var_RazonSocAccionista 		VARCHAR(150);	-- Razon Social del Accionista
	DECLARE Var_PrimerNomAccionista 	VARCHAR(30);	-- Primer Nombre  del Accionista
	DECLARE Var_SegundoNomAccionista 	VARCHAR(30);	-- Segundo Nombre  del Accionista
	DECLARE Var_ApePaternoAccionista 	VARCHAR(25);	-- Apellido Paterno del Accionista
	DECLARE Var_ApeMaternoAccionista 	VARCHAR(25);	-- Apellido Materno del Accionista
	DECLARE Var_Relacionado 			VARCHAR(25);	-- Credito Relacionado a la Reestructura
	DECLARE Var_NumeroContratoAnt 		VARCHAR(25);	-- Credito Relacionado a la Reestructura
	DECLARE Var_Porcentaje				CHAR(2);		-- Porcentaje del Accionista
	DECLARE Var_DireccionAccionista1	VARCHAR(40);	-- Direccion 1 del Accionista
	DECLARE Var_DireccionAccionista2	VARCHAR(40);	-- Direccion 1 del Accionista
	DECLARE Var_ColoniaAccionistaID		INT(11);		-- Colonia del Accionista
	DECLARE Var_ColoniaAccionista		VARCHAR(60);	-- Colonia del Accionista
	DECLARE Var_MunicipioAccionista		VARCHAR(40);	-- Municipio del Accionista
	DECLARE Var_CiudadAccionista		VARCHAR(40);	-- Ciudad del Accionista
	DECLARE Var_EstadoAccionista		VARCHAR(4);		-- Estado del Accionista
	DECLARE Var_CPAccionista			VARCHAR(10);	-- Codigo Postal del Accionista
	DECLARE Var_TelefonoAccionista		VARCHAR(20);	-- Telefono del Accionista
	DECLARE Var_ExtAccionista			VARCHAR(8);		-- Extension del Accionista
	DECLARE Var_FaxAccionista			VARCHAR(11);	-- Fax del Accionista
	DECLARE Var_TipClieAccionista		CHAR(1);		-- Tipo de Cliente del Accionista
	DECLARE Var_EdoExtAccionista		VARCHAR(40);	-- Estado Extranjero del Accionista
	DECLARE Var_TipoAccionista 			CHAR(1);		-- Tipo de Accionista

	DECLARE Var_RFCAval 				VARCHAR(13);	-- RFC del Aval
	DECLARE Var_CURPAval 				VARCHAR(18);	-- CURP del Aval
	DECLARE Var_RazonSocAval 			VARCHAR(150);	-- Razon Social del Aval
	DECLARE Var_PrimerNomAval 			VARCHAR(30);	-- Primer Nombre  del Aval
	DECLARE Var_SegundoNomAval 			VARCHAR(30);	-- Segundo Nombre  del Aval
	DECLARE Var_ApePaternoAval 			VARCHAR(25);	-- Apellido Paterno del Aval
	DECLARE Var_ApeMaternoAval 			VARCHAR(25);	-- Apellido Materno del Aval
	DECLARE Var_DireccionAval1			VARCHAR(40);	-- Direccion 1 del Aval
	DECLARE Var_DireccionAval2			VARCHAR(40);	-- Direccion 1 del Aval
	DECLARE Var_ColoniaAval				VARCHAR(60);	-- Colonia del Aval
	DECLARE Var_MunicipioAval			VARCHAR(40);	-- Municipio del Aval
	DECLARE Var_CiudadAval				VARCHAR(40);	-- Ciudad del Aval
	DECLARE Var_EstadoAval				VARCHAR(4);		-- Estado del Aval
	DECLARE Var_CPAval					VARCHAR(10);	-- Codigo Postal del Aval
	DECLARE Var_TelefonoAval			VARCHAR(20);	-- Telefono del Aval
	DECLARE Var_ExtAval					VARCHAR(8);		-- Extension del Aval
	DECLARE Var_FaxAval					VARCHAR(11);	-- Fax del Aval
	DECLARE Var_TipClieAval				CHAR(1);		-- Tipo de Cliente del Aval
	DECLARE Var_TipoCredito				CHAR(1);		-- Tipo de Credito
	DECLARE Var_EdoExtAval				VARCHAR(40);	-- Estado Extranjero del Aval

	DECLARE Var_Direccion		VARCHAR(40);	-- Direccion del Acreditado
	DECLARE Var_Colonia			VARCHAR(60);	-- Colonia del Acreditado
	DECLARE Var_Municipio		VARCHAR(40);	-- Municipio del Acreditado
	DECLARE Var_Ciudad			VARCHAR(40);	-- Ciudad del Acreditado
	DECLARE Var_Estado			VARCHAR(4);		-- Estado del Acreditado
	DECLARE Var_CodigoPostal	VARCHAR(11);	-- CodigoPostal del Acreditado

	-- Declaracion de Constantes
	DECLARE Entero_Cero			CHAR(1);		-- Constante Entero Cero
	DECLARE Entero_Uno			INT(11);		-- Constante Entero Uno
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			VARCHAR(20);	-- Constante Fecha Vacia

	-- Caracteres
	DECLARE Sol_Autorizada		CHAR(1);		-- Estatus de Solicitud Autorizado
	DECLARE CreditoCancela 		CHAR(1);		-- Credito Cancelado
	DECLARE CreditoPagado 		CHAR(1);		-- Credito Pagado
	DECLARE Persona_Moral		CHAR(1);		-- Persona Moral
	DECLARE Persona_Fisica		CHAR(1);		-- Persona Fisica
	DECLARE Persona_Actividad	CHAR(1);		-- Persona Con Actividad Empresarial
	DECLARE Persona_Gobierno 	CHAR(1);		-- Persona Gobierno
	DECLARE Con_SI 				CHAR(1);		-- Constante SI
	DECLARE Con_NO 				CHAR(1);		-- Constante NO
	DECLARE Domicilio_MX		CHAR(2);		-- Domicilio Mexico
	DECLARE Grado_A1 			CHAR(2);		-- Grado A1
	DECLARE Tabla_Directivo		CHAR(1);		-- Tabla de Directivos
	DECLARE Tabla_Cliente		CHAR(1);		-- Tabla de Cliente
	DECLARE Tabla_Garante		CHAR(1);		-- Tabla de Garantes
	DECLARE Tabla_Aval 			CHAR(1);		-- Tabla de Avales
	DECLARE Tabla_Prospecto		CHAR(1);		-- Tabla de Prospectos
	DECLARE LimpiaAlfaNumerico	VARCHAR(2);		-- Limpiar texto Alfa Numerico
	DECLARE Cliente_Moral 		CHAR(1);		-- Cliente Moral
	DECLARE Cliente_Fisico		CHAR(1);		-- Cliente Fisico
	DECLARE ExpresionRegular 	VARCHAR(20);	-- Expresion Regular
	DECLARE CodigoNABanxico 	VARCHAR(11);	-- Codigo de Banxico no Aplica
	DECLARE Con_Domicilio 		VARCHAR(20);	-- Domicio Default
	DECLARE Tipo_Reestructura 	CHAR(1);		-- Credito de Tipo Reestructura
	DECLARE Fecha_Cadena		VARCHAR(8);		-- Fecha en Cadena 01011900
	DECLARE FormatoBuro 		VARCHAR(6);		-- Formato de Fecha para Buro(01011900)
	DECLARE FrecSemanal			CHAR(1);		-- Frecuencia de Pagos Semanal
	DECLARE FrecCatorcenal		CHAR(1);		-- Frecuencia de Pagos Catorcenal
	DECLARE FrecQuincenal		CHAR(1);		-- Frecuencia de Pagos Quincenal
	DECLARE FrecMensual			CHAR(1);		-- Frecuencia de Pagos Mensual
	DECLARE FrecBimestral		CHAR(1);		-- Frecuencia de Pagos Bimestral
	DECLARE FrecTrimestral		CHAR(1);		-- Frecuencia de Pagos Trimestral
	DECLARE FrecSemestral		CHAR(1);		-- Frecuencia de Pagos Semestral
	DECLARE FrecAnual			CHAR(1);		-- Frecuencia de Pagos Anual
	DECLARE FrecTetraMestral 	CHAR(1);		-- Frecuencia de Pagos TetraMestral
	DECLARE FrecPeriodo			CHAR(1);		-- Frecuencia de Pagos Periodo
	DECLARE FrecUnica 			CHAR(1);		-- Frecuencia de Pagos Unico
	DECLARE FrecLibre 			CHAR(1);		-- Frecuencia de Pagos Libre
	DECLARE FrecDecimal 		CHAR(1);		-- Frecuencia de Pagos Decimal

	-- Asignacion de Tipo de Reporte
	DECLARE Reporte_Semanal 	INT(11);		-- Reporte Semanal
	DECLARE Reporte_Mensual		INT(11);		-- Reporte Mensual

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';

	SET Cliente_Moral		:= '1';
	SET Cliente_Fisico 		:= '2';
	SET Sol_Autorizada		:= 'U';
	SET CreditoCancela		:= 'C';
	SET CreditoPagado 		:= 'P';
	SET Persona_Moral		:= 'M';
	SET Persona_Fisica		:= 'F';
	SET Persona_Actividad 	:= 'A';
	SET Persona_Gobierno 	:= 'G';
	SET Con_SI				:= 'S';
	SET Con_NO				:= 'N';
	SET Domicilio_MX		:= 'MX';
	SET Grado_A1			:= 'A1';
	SET Tabla_Directivo		:= 'D';
	SET Tabla_Cliente		:= 'C';
	SET Tabla_Garante		:= 'G';
	SET Tabla_Aval			:= 'A';
	SET Tabla_Prospecto 	:= 'P';
	SET LimpiaAlfaNumerico	:= 'AN';
	SET ExpresionRegular 	:= '^[a-zA-Z0-9_]*$';
	SET CodigoNABanxico 	:= '00009999999';
	SET Con_Domicilio		:= 'DOMICILIO CONOCIDO';
	SET Tipo_Reestructura 	:= 'R';
	SET Fecha_Cadena		:= '01011900';
	SET FormatoBuro 		:= '%d%m%Y';

	SET FrecSemanal			:= 'S';
	SET FrecDecimal			:= 'D';
	SET FrecCatorcenal		:= 'C';
	SET FrecQuincenal		:= 'Q';
	SET FrecMensual			:= 'M';
	SET FrecBimestral		:= 'B';
	SET FrecTrimestral		:= 'T';
	SET FrecSemestral		:= 'E';
	SET FrecAnual			:= 'A';
	SET FrecTetraMestral 	:= 'R';
	SET FrecPeriodo 		:= 'P';
	SET FrecUnica 			:= 'U';
	SET FrecLibre 			:= 'L';

	-- Seteo de Tipo de Reporte
	SET Reporte_Semanal 	:= 1;
	SET Reporte_Mensual		:= 2;

	-- Creacion de Tabla Pivote
	DROP TABLE IF EXISTS TMP_REPORTECIRCULOCREDITO;
	CREATE TEMPORARY TABLE TMP_REPORTECIRCULOCREDITO(
	RegistroID			INT(11),
	ClienteID			INT(11),
	CreditoID			BIGINT(12),
	SolicitudCreditoID	BIGINT(20),
	Fecha 				DATE,
	NumeroDirectivos	INT(11),
	NumeroAvales		INT(11),
	PRIMARY KEY (RegistroID),
	INDEX TMP_REPORTECIRCULOCREDITO_IDX_1(ClienteID),
	INDEX TMP_REPORTECIRCULOCREDITO_IDX_2(CreditoID),
	INDEX TMP_REPORTECIRCULOCREDITO_IDX_3(SolicitudCreditoID),
	INDEX TMP_REPORTECIRCULOCREDITO_IDX_4(ClienteID,CreditoID));

	-- Creacion de Tabla de Avales
	DROP TABLE IF EXISTS TMP_REPORTECIRCULOCREDITOAVAL;
	CREATE TEMPORARY TABLE TMP_REPORTECIRCULOCREDITOAVAL(
	SolicitudCreditoID	BIGINT(20),
	NumeroAvales		INT(11),
	PRIMARY KEY (SolicitudCreditoID));

	-- Creacion de Tabla de Directivos
	DROP TABLE IF EXISTS TMP_REPORTECIRCULOCREDITODIRECTIVO;
	CREATE TEMPORARY TABLE TMP_REPORTECIRCULOCREDITODIRECTIVO(
	ClienteID			INT(11),
	NumeroDirectivos	INT(11),
	PRIMARY KEY (ClienteID));

	-- Tabla de Segmento Directivo
	DROP TABLE IF EXISTS TMP_DIRECTIVOREPORTECIRCULOCREDITO;
	CREATE TEMPORARY TABLE TMP_DIRECTIVOREPORTECIRCULOCREDITO(
	RegistroID			INT(11),
	Transaccion			BIGINT(20),
	DirectivoID			INT(12),
	ParticipanteID		INT(11),
	Tabla				CHAR(1),
	PRIMARY KEY (RegistroID,Transaccion));

	-- Tabla de Segmento Aval
	DROP TABLE IF EXISTS TMP_AVALREPORTECIRCULOCREDITO;
	CREATE TEMPORARY TABLE TMP_AVALREPORTECIRCULOCREDITO(
	RegistroID			INT(11),
	Transaccion			BIGINT(20),
	ParticipanteID		INT(11),
	Tabla				CHAR(1),
	PRIMARY KEY (RegistroID,Transaccion));


	-- Reporte Semanal
	IF( Par_TipoReporte = Reporte_Semanal ) THEN

		-- Se calcula la fecha de Inicio
		SET Var_FechaInicio := DATE_SUB(Par_Fecha, INTERVAL 7 DAY);

		-- Insercion de Tabla pivote
		SET @RegistroID := Entero_Cero;
		INSERT INTO TMP_REPORTECIRCULOCREDITO(RegistroID, ClienteID, CreditoID, SolicitudCreditoID, Fecha, NumeroDirectivos, NumeroAvales)
		SELECT @RegistroID :=(@RegistroID +Entero_Uno), Sal.ClienteID, Sal.CreditoID, Entero_Cero, MAX(FechaCorte), Entero_Cero, Entero_Cero
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre ON Sal.CreditoID = Cre.CreditoID
		INNER JOIN CLIENTES Cli ON Sal.ClienteID = Cli.ClienteID
		WHERE Cre.FechTerminacion BETWEEN Var_FechaInicio AND Par_Fecha
		  AND Cre.FechTerminacion < Cre.FechaVencimien
		  AND Sal.FechaCorte = Cre.FechTerminacion
		  AND Cli.TipoPersona IN (Persona_Moral , Persona_Actividad)
		  AND Cre.Estatus = CreditoPagado
		GROUP BY CreditoID, ClienteID;
        
        DROP TEMPORARY TABLE IF EXISTS TMPDATOSCLI;
		CREATE TEMPORARY TABLE TMPDATOSCLI(
			`CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
			`Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto capturado en pantalla',
			`FechaIngreso` date DEFAULT NULL COMMENT 'Fecha de ingreso');
		INSERT INTO TMPDATOSCLI 
		SELECT 
			Sal.CreditoID,
			IFNULL(MAX(CliEco.Monto), Entero_Cero) AS Monto,
			IFNULL(MAX(NomiEmp.FechaIngreso), Fecha_Vacia) AS FechaIngreso
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre ON Cre.CreditoID = Sal.CreditoID
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Sal.ClienteID
		LEFT JOIN CLIDATSOCIOE CliEco ON CliEco.ClienteID = Cli.ClienteID
		LEFT JOIN NOMINAEMPLEADOS NomiEmp ON NomiEmp.ClienteID = Cli.ClienteID
        WHERE Cre.FechTerminacion BETWEEN Var_FechaInicio AND Par_Fecha
		  AND Cre.FechTerminacion < Cre.FechaVencimien
		  AND Sal.FechaCorte = Cre.FechTerminacion
		  AND Cli.TipoPersona IN (Persona_Moral , Persona_Actividad)
		  AND Cre.Estatus = CreditoPagado
		GROUP BY Sal.CreditoID;
        
		UPDATE TMPREPCIRCULOPM AS TEMPCIRPM
        INNER JOIN TMPDATOSCLI AS TEMPDCLI ON TEMPCIRPM.CreditoID = TEMPDCLI.CreditoID
        SET TEMPCIRPM.Monto = TEMPDCLI.Monto,
        TEMPCIRPM.FechaIngreso = TEMPDCLI.FechaIngreso
        WHERE TEMPCIRPM.CreditoID = TEMPDCLI.CreditoID;

	END IF;

	-- Reporte Mensual
	IF( Par_TipoReporte = Reporte_Mensual ) THEN

		-- Se calcula la fecha de Inicio
		SET Var_FechaInicio := DATE_SUB(Par_Fecha, INTERVAL Entero_Uno MONTH);

		-- Insercion de Tabla pivote
		SET @RegistroID := Entero_Cero;
		INSERT INTO TMP_REPORTECIRCULOCREDITO(RegistroID, ClienteID, CreditoID, SolicitudCreditoID, Fecha, NumeroDirectivos, NumeroAvales)
		SELECT @RegistroID :=(@RegistroID +Entero_Uno), Sal.ClienteID, Sal.CreditoID, Entero_Cero, MAX(FechaCorte),Entero_Cero, Entero_Cero
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre ON Sal.CreditoID = Cre.CreditoID
		INNER JOIN CLIENTES Cli ON Sal.ClienteID = Cli.ClienteID
		WHERE Sal.FechaCorte = Par_Fecha
		  AND Cli.TipoPersona IN (Persona_Moral, Persona_Actividad )
		  AND Cre.Estatus <> CreditoCancela
		GROUP BY CreditoID, ClienteID;
        
		DROP TEMPORARY TABLE IF EXISTS TMPDATOSCLI;
		CREATE TEMPORARY TABLE TMPDATOSCLI(
			`CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
			`Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto capturado en pantalla',
			`FechaIngreso` date DEFAULT NULL COMMENT 'Fecha de ingreso');

	END IF;

	UPDATE TMP_REPORTECIRCULOCREDITO Tmp, CREDITOS Cre SET
		Tmp.SolicitudCreditoID = IFNULL(Cre.SolicitudCreditoID, Entero_Cero)
	WHERE Tmp.CreditoID = Cre.CreditoID;

	INSERT INTO TMP_REPORTECIRCULOCREDITOAVAL(SolicitudCreditoID, NumeroAvales)
	SELECT SolicitudCreditoID, IFNULL(COUNT(SolicitudCreditoID), Entero_Cero)
	FROM AVALESPORSOLICI
	WHERE SolicitudCreditoID IN (SELECT SolicitudCreditoID FROM TMP_REPORTECIRCULOCREDITO) AND Estatus = Sol_Autorizada
	GROUP BY SolicitudCreditoID;

	UPDATE TMP_REPORTECIRCULOCREDITO Tmp, TMP_REPORTECIRCULOCREDITOAVAL Cre SET
		Tmp.NumeroAvales = IFNULL(Cre.NumeroAvales, Entero_Cero)
	WHERE Tmp.SolicitudCreditoID = Cre.SolicitudCreditoID;

	INSERT INTO TMP_REPORTECIRCULOCREDITODIRECTIVO(ClienteID, NumeroDirectivos)
	SELECT ClienteID, IFNULL(COUNT(ClienteID), Entero_Cero)
	FROM DIRECTIVOS
	WHERE ClienteID IN (SELECT ClienteID FROM TMP_REPORTECIRCULOCREDITO)
	  AND EsAccionista = Con_SI
	GROUP BY ClienteID;

	UPDATE TMP_REPORTECIRCULOCREDITO Tmp, TMP_REPORTECIRCULOCREDITODIRECTIVO Cre SET
		Tmp.NumeroDirectivos = IFNULL(Cre.NumeroDirectivos, Entero_Cero)
	WHERE Tmp.ClienteID = Cre.ClienteID;

	SET Var_Contador := Entero_Uno;
	SET Var_RegistroID := Entero_Uno;

	DROP TABLE IF EXISTS TMP_REGISTROTABLA_ERROR;
	CREATE TEMPORARY TABLE TMP_REGISTROTABLA_ERROR(
	Contador			INT(11),
	IteracionCreditos	INT(11),
	RegistroID			INT(11),
	ClienteID			INT(11),
	CreditoID			BIGINT(20),
	SolicitudCreditoID	BIGInT(20),
	Transaccion			BIGINT(20));

	SELECT IFNULL(MAX(RegistroID), Entero_Cero)
	INTO Var_MaxIteracion
	FROM TMP_REPORTECIRCULOCREDITO;
	-- Se elimina los registros de la tabla temporal
	SET Aud_NumTransaccion := ROUND(RAND()*1000000);
	DELETE FROM TMPREPCIRCULOPM WHERE Transaccion = Aud_NumTransaccion;

	-- Inicio el ciclo para insertar Credito - Cliente -Aval o Directivo
	WHILE ( Var_Contador <= Var_MaxIteracion) DO

		-- Se obtienen los datos base para el llenado del reporte
		SELECT 	ClienteID,		CreditoID,		SolicitudCreditoID,
				CASE WHEN NumeroDirectivos > NumeroAvales THEN NumeroDirectivos
					ELSE NumeroAvales END,	Fecha
		INTO 	Var_ClienteID,	Var_CreditoID,	Var_SolicitudCreditoID,	Var_NumeroRegistros, Var_FechaCorte
		FROM TMP_REPORTECIRCULOCREDITO
		WHERE RegistroID = Var_Contador;
		-- Se ingresan los directivo
		SET @RegistroID := Entero_Cero;
		DELETE FROM TMP_DIRECTIVOREPORTECIRCULOCREDITO WHERE Transaccion = Aud_NumTransaccion;

		INSERT INTO TMP_DIRECTIVOREPORTECIRCULOCREDITO(
			RegistroID, Transaccion, DirectivoID, ParticipanteID, Tabla)
		SELECT @RegistroID :=(@RegistroID +Entero_Uno), Aud_NumTransaccion, DirectivoID,
			CASE WHEN RelacionadoID =  Entero_Cero AND GaranteRelacion =  Entero_Cero AND AvalRelacion =  Entero_Cero THEN
					Entero_Cero
				 WHEN RelacionadoID <> Entero_Cero AND GaranteRelacion =  Entero_Cero AND AvalRelacion =  Entero_Cero THEN
					RelacionadoID
				 WHEN RelacionadoID =  Entero_Cero AND GaranteRelacion <> Entero_Cero AND AvalRelacion =  Entero_Cero THEN
					GaranteRelacion
				 WHEN RelacionadoID <> Entero_Cero AND GaranteRelacion =  Entero_Cero AND AvalRelacion <> Entero_Cero THEN
					AvalRelacion
				 ELSE DirectivoID
			END,
			CASE WHEN RelacionadoID =  Entero_Cero AND GaranteRelacion =  Entero_Cero AND AvalRelacion =  Entero_Cero THEN
					Tabla_Directivo
				 WHEN RelacionadoID <> Entero_Cero AND GaranteRelacion =  Entero_Cero AND AvalRelacion =  Entero_Cero THEN
					Tabla_Cliente
				 WHEN RelacionadoID =  Entero_Cero AND GaranteRelacion <> Entero_Cero AND AvalRelacion =  Entero_Cero THEN
					Tabla_Garante
				 WHEN RelacionadoID =  Entero_Cero AND GaranteRelacion =  Entero_Cero AND AvalRelacion <> Entero_Cero THEN
					Tabla_Aval
				 ELSE Tabla_Directivo
			END
		FROM DIRECTIVOS
		WHERE ClienteID = Var_ClienteID AND EsAccionista = Con_SI;

		-- Se ingresan los Avales
		SET @RegistroID := Entero_Cero;
		DELETE FROM TMP_AVALREPORTECIRCULOCREDITO WHERE Transaccion = Aud_NumTransaccion;

		INSERT INTO TMP_AVALREPORTECIRCULOCREDITO(
			RegistroID, Transaccion, ParticipanteID, Tabla)
		SELECT	@RegistroID :=(@RegistroID +Entero_Uno), Aud_NumTransaccion,
			CASE WHEN AvalID <> Entero_Cero AND ClienteID =  Entero_Cero AND ProspectoID =  Entero_Cero THEN
					AvalID
				 WHEN AvalID =  Entero_Cero AND ClienteID <> Entero_Cero AND ProspectoID =  Entero_Cero THEN
					ClienteID
				 WHEN AvalID =  Entero_Cero AND ClienteID =  Entero_Cero AND ProspectoID <> Entero_Cero THEN
					ProspectoID
				 ELSE ClienteID
			END,
			CASE WHEN AvalID <> Entero_Cero AND ClienteID =  Entero_Cero AND ProspectoID =  Entero_Cero THEN
					Tabla_Aval
				 WHEN AvalID =  Entero_Cero AND ClienteID <> Entero_Cero AND ProspectoID =  Entero_Cero THEN
					Tabla_Cliente
				 WHEN AvalID =  Entero_Cero AND ClienteID =  Entero_Cero AND ProspectoID <> Entero_Cero THEN
					Tabla_Prospecto
				 ELSE Tabla_Cliente
			END
		FROM AVALESPORSOLICI
		WHERE SolicitudCreditoID = Var_SolicitudCreditoID
		  AND Estatus = Sol_Autorizada;

		IF( Var_NumeroRegistros = Entero_Cero ) THEN
			SET Var_NumeroRegistros := Entero_Uno;
		END IF;
		SET Var_IteracionCreditos := Entero_Uno;

		SELECT COUNT(*)
		INTO Var_RegistroDirectivo
		FROM TMP_DIRECTIVOREPORTECIRCULOCREDITO
		WHERE Transaccion = Aud_NumTransaccion;

		SELECT COUNT(*)
		INTO Var_RegistroAval
		FROM TMP_AVALREPORTECIRCULOCREDITO
		WHERE Transaccion = Aud_NumTransaccion;

		SET Var_ContadorDirectivo := Entero_Cero;
		SET Var_ContadorAval 	  := Entero_Cero;

		WHILE ( Var_IteracionCreditos <= Var_NumeroRegistros) DO

			INSERT INTO TMP_REGISTROTABLA_ERROR VALUES
			 (Var_Contador,Var_IteracionCreditos,Var_RegistroID,Var_ClienteID,Var_CreditoID,Var_SolicitudCreditoID,Aud_NumTransaccion);

			INSERT INTO TMPREPCIRCULOPM(
				RegistroID,				Transaccion,			CreditoID,
				RFC,					CURP,					RazonSocial,			PrimerNombre,			SegundoNombre,
				ApellidoPaterno,		ApellidoMaterno,		Nacionalidad,			ClasificacionCartera,	ClaveBanxico1,
				ClaveBanxico2,			ClaveBanxico3,			Direccion1,				Direccion2,				Colonia,
				Municipio,				Ciudad,					Estado,					CodigoPostal,			Telefono,
				Extension,				Fax,					TipoCliente,			EdoExtranjero,			Pais,
				TelefonoCelular,		Correo,					Monto,					FechaIngreso,

				RFCAccionista,			CURPAccionista,			RazonSocAccionista,		PrimerNomAccionista,	SegundoNomAccionista,
				ApePaternoAccionista,	ApeMaternoAccionista,	Porcentaje,				DireccionAccionista1,	DireccionAccionista2,
				ColoniaAccionista,		MunicipioAccionista,	CiudadAccionista,		EstadoAccionista,		CPAccionista,
				TelefonoAccionista,		ExtAccionista,			FaxAccionista,			TipClieAccionista,		EdoExtAccionista,
				PaisAccionista,

				NumeroContratoAnt,		FechaApertura,			PlazoCredito,			TipoCredito,			SaldoInicial,
				Moneda,					NumeroPagos,			FrecuenciaPago,			ImportePago,			FechaUltimoPago,
				FechaRestructura,		PagoCredito,			FechaLiquidacion,		Quita,					Dacion,
				Castigo,				ClaveObservacion,		Especiales,				FechaIncumplimiento,	SaldoInsoluto,
				CreditoMaximo,			FechaCartVencida,		DiasVencidos,			SaldoTotal,				Interes,

				RFCAval,				CURPAval,				RazonSocAval,			PrimerNomAval,			SegundoNomAval,
				ApePaternoAval,			ApeMaternoAval,			DireccionAval1,			DireccionAval2,			ColoniaAval,
				MunicipioAval,			CiudadAval,				EstadoAval,				CPAval,					TelefonoAval,
				ExtAval,				FaxAval,				TipClieAval,			EdoExtAval,				PaisAval)
			SELECT
				Var_RegistroID,	Aud_NumTransaccion,	Var_CreditoID,

				LEFT(RFCOficial,13) AS RFC,
				CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
					 WHEN TipoPersona = Persona_Actividad THEN  LEFT(CURP,18)
					 ELSE Cadena_Vacia
				END AS CURP,
				CASE WHEN TipoPersona = Persona_Moral THEN LEFT(UPPER(IFNULL(RazonSocial, Cadena_Vacia)), 150)
					 WHEN TipoPersona = Persona_Actividad THEN Cadena_Vacia
					 ELSE Cadena_Vacia
				END AS RazonSocial,
				CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
					 WHEN TipoPersona = Persona_Actividad THEN LEFT(UPPER(IFNULL(PrimerNombre,Cadena_Vacia)),30)
					 ELSE Cadena_Vacia
				END AS PrimerNombre,
				CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
					 WHEN TipoPersona = Persona_Actividad THEN
						CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
								LEFT(UPPER(CONCAT(IFNULL(SegundoNombre, Cadena_Vacia),' ',IFNULL(TercerNombre, Cadena_Vacia))), 30)
							 WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia)  = Cadena_Vacia THEN
								LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
							 WHEN IFNULL(SegundoNombre, Cadena_Vacia) =  Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
								LEFT(UPPER(IFNULL(TercerNombre, Cadena_Vacia)), 30)
							 ELSE LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
						END
				END AS SegundoNombre,
				CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
					 WHEN TipoPersona = Persona_Actividad THEN LEFT(UPPER(IFNULL(ApellidoPaterno, Cadena_Vacia)), 25)
					 ELSE Cadena_Vacia
				END AS ApellidoPaterno,
				CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
					 WHEN TipoPersona = Persona_Actividad THEN LEFT(UPPER(IFNULL(ApellidoMaterno, Cadena_Vacia)), 25)
					 ELSE Cadena_Vacia
				END AS ApellidoMaterno,
				Domicilio_MX,		Grado_A1 AS ClasificacionCartera,
				LEFT(IFNULL(Cli.ActividadBancoMX, CodigoNABanxico),11) AS ActividadBancoMX,

				LEFT(IFNULL(Cli.ActividadBancoMX, CodigoNABanxico),11),	LEFT(IFNULL(Cli.ActividadBancoMX, CodigoNABanxico),11),
				Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,

				Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
				LEFT(IFNULL(Telefono, Cadena_Vacia), 11) AS Telefono,

				LEFT(IFNULL(ExtTelefonoPart, Cadena_Vacia),8) AS ExtTelefonoPart,
				LEFT(IFNULL(Fax, Cadena_Vacia),11) AS Fax,
				CASE WHEN TipoPersona = Persona_Moral THEN Cliente_Moral
					 WHEN TipoPersona = Persona_Actividad THEN Cliente_Fisico
					 ELSE Cliente_Moral
				END,
				Cadena_Vacia,		Domicilio_MX,

				LEFT(IFNULL(TelefonoCelular, Cadena_Vacia), 11) AS TelefonoCelular,
				LEFT(IFNULL(UPPER(Correo), Cadena_Vacia), 100) AS Correo,
                Entero_Cero,
                Fecha_Vacia,

				RPAD(Cadena_Vacia, 13, ' '),  RPAD(Cadena_Vacia, 18, ' '),   RPAD(Cadena_Vacia, 150, ' '), RPAD(Cadena_Vacia, 30, ' '),  RPAD(Cadena_Vacia, 30, ' '),
				RPAD(Cadena_Vacia, 25, ' '),  RPAD(Cadena_Vacia, 25, ' '),   RPAD(Cadena_Vacia, 2, ' '),   RPAD(Cadena_Vacia, 40, ' '),  RPAD(Cadena_Vacia, 40, ' '),
				RPAD(Cadena_Vacia, 60, ' '),  RPAD(Cadena_Vacia, 40, ' '),   RPAD(Cadena_Vacia, 40, ' '),  RPAD(Cadena_Vacia, 4, ' '),   RPAD(Cadena_Vacia, 10, ' '),
				RPAD(Cadena_Vacia, 11, ' '),  RPAD(Cadena_Vacia, 8, ' '),    RPAD(Cadena_Vacia, 11, ' '),  RPAD(Cadena_Vacia, 1, ' '),   RPAD(Cadena_Vacia, 40, ' '),
				RPAD(Cadena_Vacia, 2, ' '),

				Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,		Entero_Cero,
				Cadena_Vacia,			Entero_Cero,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,
				Cadena_Vacia,			Entero_Cero,		Cadena_Vacia,		Entero_Cero,		Entero_Cero,
				Entero_Cero,			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,
				Entero_Cero,			Cadena_Vacia,		Entero_Cero,		Entero_Cero,		Entero_Cero,

				RPAD(Cadena_Vacia, 13, ' '),  RPAD(Cadena_Vacia, 25, ' '),   RPAD(Cadena_Vacia, 150, ' '), RPAD(Cadena_Vacia, 30, ' '),  RPAD(Cadena_Vacia, 30, ' '),
				RPAD(Cadena_Vacia, 25, ' '),  RPAD(Cadena_Vacia, 25, ' '),   RPAD(Cadena_Vacia, 40, ' '),  RPAD(Cadena_Vacia, 40, ' '),  RPAD(Cadena_Vacia, 60, ' '),
				RPAD(Cadena_Vacia, 40, ' '),  RPAD(Cadena_Vacia, 40, ' '),   RPAD(Cadena_Vacia, 4, ' '),   RPAD(Cadena_Vacia, 10, ' '),  RPAD(Cadena_Vacia, 11, ' '),
				RPAD(Cadena_Vacia, 8, ' '),	  RPAD(Cadena_Vacia, 11, ' '),   RPAD(Cadena_Vacia, 1, ' '),   RPAD(Cadena_Vacia, 40, ' '),  RPAD(Cadena_Vacia, 2, ' ')
			FROM CLIENTES Cli
			WHERE ClienteID = Var_ClienteID;

			SELECT LEFT(CONCAT(LTRIM(RTRIM((Dir.Calle))),
					CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumeroCasa, 'SN'))) IN ('', ' SN ', '0')   THEN ' SN ' ELSE CONCAT(" NUM ", LTRIM(RTRIM(IFNULL(Dir.NumeroCasa, 'SN')))) END,
					CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumInterior, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" INT ", LTRIM(RTRIM(Dir.NumInterior))) END,
					CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Manzana, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" MZ ", LTRIM(RTRIM(Dir.Manzana))) END,
					CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Lote, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" LT ", LTRIM(RTRIM(Dir.Lote))) END,
					CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Piso, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" PISO ", LTRIM(RTRIM(Dir.Piso))) END
					),40) AS Direcion,
					LEFT(Dir.Colonia, 60) AS Colonia,
					LEFT(Mun.Nombre, 40) AS Municipio,
					LEFT(Loc.NombreLocalidad, 40) AS Ciudad,
					LEFT(Est.EqCirCre, 4) AS Estado,
					LEFT(Dir.CP, 10) AS CodigoPostal
			INTO	Var_Direccion,Var_Colonia, Var_Municipio, Var_Ciudad, Var_Estado,  Var_CodigoPostal
			FROM DIRECCLIENTE Dir
            LEFT JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Dir.LocalidadID  AND Dir.MunicipioID = Loc.MunicipioID AND Dir.EstadoID = Loc.EstadoID
			LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
			LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Dir.EstadoID
			WHERE Dir.ClienteID = Var_ClienteID
			  AND IFNULL(Dir.Oficial, Con_NO) = Con_SI;

			SET Var_Direccion		:= IFNULL(Var_Direccion , Con_Domicilio);
			SET Var_Colonia			:= IFNULL(Var_Colonia , Cadena_Vacia);
			SET Var_Municipio		:= IFNULL(Var_Municipio , Cadena_Vacia);
			SET Var_Estado			:= IFNULL(Var_Estado , Cadena_Vacia);
			SET Var_Ciudad			:= IFNULL(Var_Ciudad , Cadena_Vacia);
			SET Var_CodigoPostal	:= IFNULL(Var_CodigoPostal , Cadena_Vacia);

			SELECT 	IFNULL(DATE_FORMAT(FechaInicio,FormatoBuro), Fecha_Cadena),
					Relacionado,		PlazoID,				MontoCredito,		MonedaID,
					NumAmortizacion,	FrecuenciaCap,			IFNULL(DATE_FORMAT(FechTerminacion,FormatoBuro), Fecha_Cadena),
					PeriodicidadCap,	IFNULL(DATE_FORMAT(FechTraspasVenc,FormatoBuro), Fecha_Cadena),
					TipoCredito,		Estatus
			INTO 	Var_FechaInicioCre,	Var_Relacionado,		Var_PlazoID,	Var_MontoCredito,	Var_MonedaID,
					Var_NumPagos,		Var_Frecuencia,			Var_FechaTerminacion,
					Var_PeriodicidadCap,Var_FechaTraspasoVenc, 	Var_TipoCredito,	Var_EstatusCredito
			FROM CREDITOS
			WHERE CreditoID = Var_CreditoID;

			SELECT TRUNCATE( Pla.Dias / 30, Entero_Cero)
			INTO Var_PlazoCredito
			FROM CREDITOSPLAZOS Pla
			WHERE Pla.PlazoID = Var_PlazoID;

			SELECT MAX(IFNULL(MontoCredito, Entero_Cero))
			INTO Var_CreditoMaximo
			FROM CREDITOS
			WHERE ClienteID = Var_ClienteID;

			SET Var_NumeroContratoAnt := Cadena_Vacia;
			SET Var_FechaRestructura	:= Fecha_Cadena;

			IF( Var_TipoCredito = Tipo_Reestructura ) THEN
				SET Var_NumeroContratoAnt := Var_Relacionado;
				SELECT IFNULL(DATE_FORMAT(FechaRegistro,FormatoBuro), Fecha_Cadena)
				INTO Var_FechaRestructura
				FROM REESTRUCCREDITO
				WHERE CreditoOrigenID = Var_CreditoID
				  AND Origen = Tipo_Reestructura;

			END IF;

			SELECT EqBuroCredPM
			INTO Var_EqBuroCred
			FROM MONEDAS
			WHERE MonedaId = Var_MonedaID;

			-- Obtengo la maxima fecha de pago de un credito
			SELECT IFNULL(MAX(FechaPago), Fecha_Vacia)
			INTO Var_FechaPago
			FROM DETALLEPAGCRE
			WHERE CreditoID = Var_CreditoID
			  AND FechaPago <= Par_Fecha;

			-- Obtengo el Maximo Numero de Transaccion
			SELECT IFNULL(MAX(Transaccion), Entero_Cero)
			INTO Var_NumTransaccion
			FROM DETALLEPAGCRE
			WHERE CreditoID = Var_CreditoID
			  AND FechaPago = Var_FechaPago;

			SET Var_MontoTotalPago := Entero_Cero;
			IF( Var_EstatusCredito = CreditoPagado ) THEN

				SELECT IFNULL(COUNT(CreditoID), Entero_Cero)
				INTO Var_Intereses
				FROM DETALLEPAGCRE
				WHERE CreditoID = Var_CreditoID
				  AND FechaPago = Var_FechaCorte
				  AND MontoIntMora > Entero_Cero;

				IF( Var_Intereses > Entero_Cero ) THEN
					-- Se obtiene el monto del ultimo pago
					SELECT IFNULL(SUM(MontoTotPago), Entero_Cero)
					INTO Var_MontoTotalPago
					FROM DETALLEPAGCRE
					WHERE CreditoID = Var_CreditoID
					  AND FechaPago = Var_FechaPago;
				END IF;
			END IF;
			-- Se mensualiza El Monto de Pagos (ImportePago)

			SELECT IFNULL(Capital, Entero_Cero) + IFNULL(Interes, Entero_Cero) + IFNULL(IVAInteres, Entero_Cero)
			INTO 	Var_MontoPago
			FROM PAGARECREDITO
			WHERE AmortizacionID = Entero_Uno
			  AND CreditoID = Var_CreditoID;

			IF( Var_Frecuencia = FrecLibre ) THEN
				SELECT IFNULL(COUNT(*) , Entero_Uno)
				INTO Var_NumPagos
				FROM AMORTICREDITO
				WHERE CreditoID = Var_CreditoID;

				SELECT IFNULL(Capital, Entero_Cero) + IFNULL(Interes, Entero_Cero) + IFNULL(IVAInteres, Entero_Cero)
				INTO Var_MontoPago
				FROM AMORTICREDITO
				WHERE AmortizacionID = Entero_Uno
				  AND CreditoID = Var_CreditoID;
			END IF;

			SET Var_ImportePago := (CASE Var_Frecuencia WHEN FrecSemanal 		THEN (Var_MontoPago * 4)
														WHEN FrecDecimal 		THEN (Var_MontoPago * 10)
														WHEN FrecCatorcenal		THEN (Var_MontoPago * 2)
														WHEN FrecQuincenal 		THEN (Var_MontoPago * 2)
														WHEN FrecMensual		THEN  Var_MontoPago
														WHEN FrecPeriodo		THEN  Var_MontoPago
														WHEN FrecUnica			THEN  Var_MontoPago
														WHEN FrecLibre			THEN  Var_MontoPago
														WHEN FrecBimestral		THEN ROUND(Var_MontoPago / 2)
														WHEN FrecTrimestral		THEN ROUND(Var_MontoPago / 2)
														WHEN FrecSemestral		THEN ROUND(Var_MontoPago / 6)
														WHEN FrecTetraMestral	THEN ROUND(Var_MontoPago / 4)
														WHEN FrecAnual			THEN ROUND(Var_MontoPago / 12) END);

			SELECT IFNULL(MIN(DATE_FORMAT(FechaLiquida,FormatoBuro)), Fecha_Cadena)
			INTO Var_FechaIncumplimiento
			FROM AMORTICREDITO
			WHERE CreditoID = Var_CreditoID
			  AND FechaLiquida > FechaExigible;

			SELECT IFNULL(SUM(MontoComisiones + MontoMoratorios + MontoInteres + MontoCapital), Entero_Cero)
			INTO Var_Condonaciones
			FROM CREQUITAS
			WHERE CreditoID = Var_CreditoID
			  AND FechaRegistro BETWEEN Var_FechaInicio AND Par_Fecha;

			SELECT IFNULL(SUM(TotalCastigo), Entero_Cero)
			INTO Var_MontoCastigo
			FROM CRECASTIGOS
			WHERE CreditoID = Var_CreditoID
			  AND Fecha BETWEEN Var_FechaInicio AND Par_Fecha;

			SELECT (IFNULL(SalCapVigente, Entero_Cero) + IFNULL(SalCapAtrasado, Entero_Cero) + IFNULL(SalCapVencido, Entero_Cero) + IFNULL(SalCapVenNoExi, Entero_Cero)),
				   (IFNULL(SalIntAtrasado, Entero_Cero) + IFNULL(SalIntVencido, Entero_Cero) + IFNULL(SalIntProvision, Entero_Cero) + IFNULL(SalIntNoConta, Entero_Cero)),
					DiasAtraso
			INTO Var_SaldoInsoluto, Var_SaldoInteres, Var_DiasAtraso
			FROM SALDOSCREDITOS
			WHERE CreditoID = Var_CreditoID
			  AND FechaCorte = Var_FechaCorte;

			UPDATE TMPREPCIRCULOPM SET
				RFC					= RPAD(RFC , 13, ' '),
				CURP				= RPAD(CURP, 18, ' '),
				RazonSocial			= RPAD(
											CASE WHEN RazonSocial REGEXP ExpresionRegular THEN RazonSocial
												 ELSE FNLIMPIACARACTBUROCRED(RazonSocial,LimpiaAlfaNumerico) END
										  , 150, ' '),
				PrimerNombre		= RPAD(PrimerNombre, 30, ' '),
				SegundoNombre		= RPAD(SegundoNombre, 30, ' '),

				ApellidoPaterno		= RPAD(ApellidoPaterno, 25, ' '),
				ApellidoMaterno		= RPAD(ApellidoMaterno, 25, ' '),
				ClaveBanxico1		= RPAD(ClaveBanxico1, 11, ' '),
				Direccion1			= RPAD(
											CASE WHEN Var_Direccion REGEXP ExpresionRegular THEN Var_Direccion
												 ELSE FNLIMPIACARACTBUROCRED(Var_Direccion,LimpiaAlfaNumerico) END
										  , 40, ' '),
				Direccion2			= RPAD(Direccion2, 40, ' '),

				Colonia				= RPAD(
											CASE WHEN Var_Colonia REGEXP ExpresionRegular THEN Var_Colonia
												 ELSE FNLIMPIACARACTBUROCRED(Var_Colonia,LimpiaAlfaNumerico) END
										  , 60, ' '),
				Municipio			= RPAD(
											CASE WHEN Var_Municipio REGEXP ExpresionRegular THEN Var_Municipio
												 ELSE FNLIMPIACARACTBUROCRED(Var_Municipio,LimpiaAlfaNumerico) END
										  , 40, ' '),
				Ciudad				= RPAD(
											CASE WHEN Var_Ciudad REGEXP ExpresionRegular THEN Var_Ciudad
												 ELSE FNLIMPIACARACTBUROCRED(Var_Ciudad,LimpiaAlfaNumerico) END
										  , 40, ' '),
				Estado				= RPAD(Var_Estado, 4, ' '),
				CodigoPostal		= RPAD(Var_CodigoPostal, 10, ' '),

				Telefono			= LTRIM(RTRIM(
									  CASE WHEN IFNULL(Telefono, Cadena_Vacia) = Cadena_Vacia THEN LPAD(IFNULL(Telefono, Cadena_Vacia), 11, ' ')
										   ELSE LPAD(IFNULL(Telefono, Cadena_Vacia), 11, '0') END)),
				Extension			= CASE WHEN IFNULL(Extension, Cadena_Vacia) = Cadena_Vacia THEN LPAD(IFNULL(Extension, Cadena_Vacia), 8, ' ')
										   ELSE LPAD(IFNULL(Extension, Cadena_Vacia), 8, '0') END,
				Fax					= CASE WHEN IFNULL(Fax, Cadena_Vacia) = Cadena_Vacia THEN LPAD(IFNULL(Fax, Cadena_Vacia), 11, ' ')
										   ELSE LPAD(IFNULL(Fax, Cadena_Vacia), 11, '0') END,
				EdoExtranjero		= RPAD(EdoExtranjero, 40, ' '),

				TelefonoCelular 	= LTRIM(RTRIM(
									  CASE WHEN LTRIM(RTRIM(TelefonoCelular)) = Cadena_Vacia THEN LPAD(TelefonoCelular, 15, ' ')
										   ELSE LPAD(TelefonoCelular, 15, '0') END)),
				Correo 				= RPAD(Correo , 100, ' '),
				Monto 				= Entero_Cero,
				FechaIngreso		= Fecha_Vacia,

				NumeroContratoAnt 	= Var_NumeroContratoAnt,
				FechaApertura		= Var_FechaInicioCre,
				PlazoCredito 		= Var_PlazoCredito,
				SaldoInicial 		= LPAD(Var_MontoCredito, 20, 0),
				Moneda 				= Var_EqBuroCred,
				CreditoMaximo 		= Var_CreditoMaximo,
				NumeroPagos 		= LPAD(Var_NumPagos, 4, 0),
				FechaUltimoPago 	= CASE WHEN IFNULL(DATE_FORMAT(Var_FechaPago,FormatoBuro), Fecha_Cadena) = Fecha_Cadena THEN RPAD(FechaUltimoPago, 8, ' ')
										   ELSE IFNULL(DATE_FORMAT(Var_FechaPago,FormatoBuro), Fecha_Cadena) END,
				FechaRestructura 	= CASE WHEN Var_FechaRestructura = Fecha_Cadena THEN RPAD(FechaRestructura, 8, ' ') ELSE Var_FechaRestructura END,
				FechaLiquidacion 	= CASE WHEN Var_FechaTerminacion = Fecha_Cadena THEN RPAD(FechaLiquidacion, 8, ' ') ELSE Var_FechaTerminacion END,
				PagoCredito			= LPAD(Var_MontoTotalPago, 20, 0),
				ImportePago 		= LPAD(Var_ImportePago, 20, 0),
				FrecuenciaPago 		= LPAD(Var_PeriodicidadCap, 5, 0),
				FechaIncumplimiento = CASE WHEN Var_FechaIncumplimiento = Fecha_Cadena THEN RPAD(FechaIncumplimiento, 8, ' ') ELSE Var_FechaIncumplimiento END,
				Quita 				= LPAD(Var_Condonaciones, 20, 0),
				Castigo 			= LPAD(Var_MontoCastigo, 20, 0),
				SaldoInsoluto 		= LPAD(Var_SaldoInsoluto, 8, 0),
				Dacion 				= LPAD(Entero_Cero, 20, 0),
				ClaveObservacion 	= RPAD(ClaveObservacion, 4, ' '),
				Interes 			= LPAD(Var_SaldoInteres, 20, 0),
				SaldoTotal 			= LPAD(Var_SaldoInsoluto + Var_SaldoInteres + Var_MontoCastigo, 20, 0),
				FechaCartVencida 	= CASE WHEN Var_FechaTraspasoVenc = Fecha_Cadena THEN RPAD(FechaCartVencida, 8, ' ') ELSE Var_FechaTraspasoVenc END,
				DiasVencidos 		= Var_DiasAtraso,
				Especiales 			= ' '
			WHERE RegistroID = Var_RegistroID
			  AND Transaccion = Aud_NumTransaccion;
              
		INSERT INTO TMPDATOSCLI 
		SELECT 
			Sal.CreditoID,
			IFNULL(MAX(CliEco.Monto), Entero_Cero) AS Monto,
			IFNULL(MAX(NomiEmp.FechaIngreso), Fecha_Vacia) AS FechaIngreso
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre ON Cre.CreditoID = Sal.CreditoID
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Sal.ClienteID
		LEFT JOIN CLIDATSOCIOE CliEco ON CliEco.ClienteID = Cli.ClienteID
		LEFT JOIN NOMINAEMPLEADOS NomiEmp ON NomiEmp.ClienteID = Cli.ClienteID
        WHERE Sal.FechaCorte = Par_Fecha
		  AND Cli.TipoPersona IN (Persona_Moral, Persona_Actividad )
		  AND Cre.Estatus <> CreditoCancela
		GROUP BY Sal.CreditoID;
        
		UPDATE TMPREPCIRCULOPM AS TEMPCIRPM
        INNER JOIN TMPDATOSCLI AS TEMPDCLI ON TEMPCIRPM.CreditoID = TEMPDCLI.CreditoID
        SET TEMPCIRPM.Monto = TEMPDCLI.Monto,
        TEMPCIRPM.FechaIngreso = TEMPDCLI.FechaIngreso
        WHERE TEMPCIRPM.CreditoID = TEMPDCLI.CreditoID;

			-- Se obtienen los valores del directivo
			SELECT 	DirectivoID,	 ParticipanteID,	 Tabla
			INTO 	Var_DirectivoID, Var_ParticipanteID, Var_Tabla
			FROM TMP_DIRECTIVOREPORTECIRCULOCREDITO
			WHERE RegistroID = Var_IteracionCreditos
			  AND Transaccion = Aud_NumTransaccion;

			SET Var_DirectivoID	   := IFNULL(Var_DirectivoID, Entero_Cero);
			SET Var_ParticipanteID := IFNULL(Var_ParticipanteID, Entero_Cero);
			SET Var_Tabla 		   := IFNULL(Var_Tabla, Entero_Cero);

			IF( Var_RegistroDirectivo > Entero_Cero AND Var_ContadorDirectivo < Var_RegistroDirectivo) THEN

				IF( Var_Tabla = Tabla_Directivo ) THEN
					SELECT	RFC, 						CURP,						NombreCompania,			PrimerNombre,
							CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
									CONCAT(IFNULL(SegundoNombre, Cadena_Vacia),' ',IFNULL(TercerNombre, Cadena_Vacia))
								 WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia)  = Cadena_Vacia THEN
									IFNULL(SegundoNombre, Cadena_Vacia)
								 WHEN IFNULL(SegundoNombre, Cadena_Vacia) =  Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
									IFNULL(TercerNombre, Cadena_Vacia)
								ELSE IFNULL(SegundoNombre, Cadena_Vacia)
							END,
							ApellidoPaterno,			ApellidoMaterno,			CONVERT(CONVERT(PorcentajeAcciones, UNSIGNED), CHAR(2)),
							Direccion1, 				Direccion2,
							ColoniaID, 					MunNacimiento,				NombreCiudad,			EdoNacimiento,			 CodigoPostal,
							TelefonoCasa,				ExtTelefonoPart,			Fax,
							CASE WHEN TipoAccionista = Persona_Fisica 	 THEN 2
								 WHEN TipoAccionista = Persona_Moral 	 THEN 1
								 WHEN TipoAccionista = Persona_Actividad THEN 2
								 WHEN TipoAccionista = Persona_Gobierno  THEN 4
								 ELSE 1
							END AS TipClieAccionista,	EdoExtranjero,
							TipoAccionista
					INTO 	Var_RFCAccionista,			Var_CURPAccionista,			Var_RazonSocAccionista,	Var_PrimerNomAccionista, Var_SegundoNomAccionista,
							Var_ApePaternoAccionista,	Var_ApeMaternoAccionista,	Var_Porcentaje,			Var_DireccionAccionista1,Var_DireccionAccionista2,
							Var_ColoniaAccionistaID,	Var_MunicipioID,			Var_CiudadAccionista,	Var_EstadoID,			 Var_CPAccionista,
							Var_TelefonoAccionista,		Var_ExtAccionista,			Var_FaxAccionista,		Var_TipClieAccionista,	 Var_EdoExtAccionista,
							Var_TipoAccionista
					FROM DIRECTIVOS
					WHERE ClienteID = Var_ClienteID AND DirectivoID = Var_DirectivoID;

					SELECT EqCirCre
					INTO Var_EstadoAccionista
					FROM ESTADOSREPUB
					WHERE EstadoID = Var_EstadoID;

					SELECT Nombre
					INTO Var_MunicipioAccionista
					FROM MUNICIPIOSREPUB
					WHERE EstadoID = Var_EstadoID AND MunicipioID = Var_MunicipioID;

					SELECT Asentamiento
					INTO Var_ColoniaAccionista
					FROM COLONIASREPUB Col
					WHERE Col.EstadoID = Var_EstadoID
					  AND Col.MunicipioID = Var_MunicipioID
					  AND Col.ColoniaID = Var_ColoniaAccionistaID;
				END IF;

				IF( Var_Tabla = Tabla_Cliente ) THEN
					SELECT LEFT(RFCOficial,13) AS RFC,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN  LEFT(CURP,18)
								 ELSE Cadena_Vacia
							END AS CURP,
							CASE WHEN TipoPersona = Persona_Moral THEN LEFT(UPPER(IFNULL(RazonSocial, Cadena_Vacia)), 150)
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN Cadena_Vacia
								 ELSE Cadena_Vacia
							END AS RazonSocial,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(PrimerNombre,Cadena_Vacia)),30)
								 ELSE Cadena_Vacia
							END AS PrimerNombre,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN
									CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
											LEFT(UPPER(CONCAT(IFNULL(SegundoNombre, Cadena_Vacia),' ',IFNULL(TercerNombre, Cadena_Vacia))), 30)
										 WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia)  = Cadena_Vacia THEN
											LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
										 WHEN IFNULL(SegundoNombre, Cadena_Vacia) =  Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
											LEFT(UPPER(IFNULL(TercerNombre, Cadena_Vacia)), 30)
										 ELSE LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
									END
							END AS SegundoNombre,

							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(ApellidoPaterno, Cadena_Vacia)), 25)
								 ELSE Cadena_Vacia
							END AS ApellidoPaterno,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(ApellidoMaterno, Cadena_Vacia)), 25)
								 ELSE Cadena_Vacia
							END AS ApellidoMaterno,
							LEFT(IFNULL(Telefono, Cadena_Vacia), 11) AS Telefono,
							LEFT(IFNULL(ExtTelefonoPart, Cadena_Vacia),8) AS ExtTelefonoPart,
							LEFT(IFNULL(Fax, Cadena_Vacia),11) AS Fax
					INTO 	Var_RFCAccionista,			Var_CURPAccionista,			Var_RazonSocAccionista,	Var_PrimerNomAccionista, Var_SegundoNomAccionista,
							Var_ApePaternoAccionista,	Var_ApeMaternoAccionista,	Var_TelefonoAccionista,	Var_ExtAccionista,		 Var_FaxAccionista
					FROM CLIENTES
					WHERE ClienteID = Var_ParticipanteID;
                    
					SELECT  CASE WHEN TipoAccionista = Persona_Fisica 	 THEN '2'
								 WHEN TipoAccionista = Persona_Moral 	 THEN '1'
								 WHEN TipoAccionista = Persona_Actividad THEN '2'
								 WHEN TipoAccionista = Persona_Gobierno  THEN '4'
								 ELSE '2'
							END AS TipClieAccionista,	 CONVERT(CONVERT(PorcentajeAcciones, UNSIGNED), CHAR(2)),
							TipoAccionista
					INTO 	Var_TipClieAccionista,		Var_Porcentaje,		Var_TipoAccionista
					FROM DIRECTIVOS
					WHERE ClienteID = Var_ClienteID AND DirectivoID = Var_DirectivoID;


					SELECT LEFT(CONCAT(LTRIM(RTRIM((Dir.Calle))),
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumeroCasa, 'SN'))) IN ('', ' SN ', '0')   THEN ' SN ' ELSE CONCAT(" NUM ", LTRIM(RTRIM(IFNULL(Dir.NumeroCasa, 'SN')))) END,
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumInterior, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" INT ", LTRIM(RTRIM(Dir.NumInterior))) END,
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Manzana, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" MZ ", LTRIM(RTRIM(Dir.Manzana))) END,
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Lote, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" LT ", LTRIM(RTRIM(Dir.Lote))) END,
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Piso, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" PISO ", LTRIM(RTRIM(Dir.Piso))) END
							),40) AS Direcion,
							LEFT(Dir.Colonia, 60) AS Colonia,
							LEFT(Mun.Nombre, 40) AS Municipio,
							LEFT(Loc.NombreLocalidad, 40) AS Ciudad,
							LEFT(Est.EqCirCre, 4) AS Estado,
							LEFT(Dir.CP, 10) AS CodigoPostal
					INTO	Var_DireccionAccionista1,Var_ColoniaAccionista, Var_MunicipioAccionista, Var_CiudadAccionista, Var_EstadoAccionista,  Var_CPAccionista
					FROM DIRECCLIENTE Dir
					LEFT JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Dir.LocalidadID  AND Dir.MunicipioID = Loc.MunicipioID AND Dir.EstadoID = Loc.EstadoID
					LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
					LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Dir.EstadoID
					WHERE Dir.ClienteID = Var_ParticipanteID
					  AND IFNULL(Dir.Oficial, Con_NO) = Con_SI;

					SET Var_EdoExtAccionista 	 := Cadena_Vacia;
					SET Var_DireccionAccionista2 := Cadena_Vacia;
				END IF;


				SET Var_TipoAccionista := IFNULL( Var_TipoAccionista,Persona_Fisica );

				-- Persona_Actividad Persona_Moral
				IF( Var_TipoAccionista = Persona_Moral ) THEN
					SET Var_PrimerNomAccionista	 := Cadena_Vacia;
					SET Var_SegundoNomAccionista := Cadena_Vacia;
					SET Var_ApePaternoAccionista := Cadena_Vacia;
					SET Var_ApeMaternoAccionista := Cadena_Vacia;
				ELSE
					SET Var_RazonSocAccionista	 := Cadena_Vacia;
				END IF;

				-- Actualizo Accionista
				UPDATE TMPREPCIRCULOPM SET
					RFCAccionista			= RPAD(IFNULL(Var_RFCAccionista,Cadena_Vacia) , 13, ' '),
					CURPAccionista			= RPAD(IFNULL( Var_CURPAccionista,Cadena_Vacia), 18, ' '),
					RazonSocAccionista		= RPAD(
												CASE WHEN IFNULL(Var_RazonSocAccionista, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_RazonSocAccionista, Cadena_Vacia)
													 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_RazonSocAccionista, Cadena_Vacia),LimpiaAlfaNumerico) END
											  , 150, ' '),
					PrimerNomAccionista		= RPAD(IFNULL(Var_PrimerNomAccionista, Cadena_Vacia), 30, ' '),
					SegundoNomAccionista	= RPAD(IFNULL(Var_SegundoNomAccionista, Cadena_Vacia), 30, ' '),

					ApePaternoAccionista 	= RPAD(IFNULL(Var_ApePaternoAccionista, Cadena_Vacia), 25, ' '),
					ApeMaternoAccionista	= RPAD(IFNULL(Var_ApeMaternoAccionista, Cadena_Vacia), 25, ' '),
					Porcentaje				= LPAD(IFNULL(Var_Porcentaje, Cadena_Vacia), 2, '0'),
					DireccionAccionista1	= RPAD(
												CASE WHEN IFNULL(Var_DireccionAccionista1, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_DireccionAccionista1, Cadena_Vacia)
													 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_DireccionAccionista1, Cadena_Vacia),LimpiaAlfaNumerico) END
											  , 40, ' '),
					DireccionAccionista2	= RPAD(IFNULL(Var_DireccionAccionista2, Cadena_Vacia), 40, ' '),

					ColoniaAccionista		= RPAD(
												CASE WHEN IFNULL(Var_ColoniaAccionista, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_ColoniaAccionista, Cadena_Vacia)
													 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_ColoniaAccionista, Cadena_Vacia),LimpiaAlfaNumerico) END
											  , 60, ' '),
					MunicipioAccionista		= RPAD(
												CASE WHEN IFNULL(Var_MunicipioAccionista, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_MunicipioAccionista, Cadena_Vacia)
													 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_MunicipioAccionista, Cadena_Vacia),LimpiaAlfaNumerico) END
											  , 40, ' '),
					CiudadAccionista		= RPAD(
												CASE WHEN IFNULL(Var_CiudadAccionista, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_CiudadAccionista, Cadena_Vacia)
													 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_CiudadAccionista, Cadena_Vacia),LimpiaAlfaNumerico) END
											  , 40, ' '),
					EstadoAccionista		= RPAD(IFNULL(Var_EstadoAccionista, Cadena_Vacia), 4, ' '),
					CPAccionista			= RPAD(IFNULL(Var_CPAccionista, Cadena_Vacia), 10, ' '),

					TelefonoAccionista		= CASE WHEN LTRIM(RTRIM(Var_TelefonoAccionista)) = Cadena_Vacia THEN LPAD(LTRIM(RTRIM(Var_TelefonoAccionista)), 11, ' ')
												   ELSE LPAD(LTRIM(RTRIM(Var_TelefonoAccionista)), 11, '0') END,

					ExtAccionista			= CASE WHEN IFNULL(Var_ExtAccionista, Cadena_Vacia) = Cadena_Vacia THEN LPAD(IFNULL(Var_ExtAccionista, Cadena_Vacia), 8, ' ')
												   ELSE LPAD(IFNULL(Var_ExtAccionista, Cadena_Vacia), 8, '0') END,
					FaxAccionista			= CASE WHEN IFNULL(Var_FaxAccionista, Cadena_Vacia) = Cadena_Vacia THEN LPAD(IFNULL(Var_FaxAccionista, Cadena_Vacia), 11, ' ')
												   ELSE LPAD(IFNULL(Var_FaxAccionista, Cadena_Vacia), 11, '0') END,
					TipClieAccionista		= IFNULL(Var_TipClieAccionista, Cadena_Vacia),
					EdoExtAccionista 		= RPAD(IFNULL(Var_EdoExtAccionista, Cadena_Vacia), 40, ' '),

					PaisAccionista 			= Domicilio_MX
				WHERE RegistroID = Var_RegistroID
				  AND Transaccion = Aud_NumTransaccion;

				SET Var_ContadorDirectivo := Var_ContadorDirectivo + Entero_Uno;
			END IF;

			IF( Var_RegistroAval > Entero_Cero AND Var_ContadorAval < Var_RegistroAval ) THEN

				SELECT 	ParticipanteID,		Tabla
				INTO 	Var_ParticipanteID,	Var_Tabla
				FROM TMP_AVALREPORTECIRCULOCREDITO
				WHERE RegistroID = Var_IteracionCreditos
				  AND Transaccion = Aud_NumTransaccion;

				IF( Var_Tabla = Tabla_Aval ) THEN

					SELECT 	CASE WHEN TipoPersona = Persona_Moral THEN LEFT(IFNULL(RFCpm, Cadena_Vacia),13)
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN  LEFT(IFNULL(RFC, Cadena_Vacia),13)
								 ELSE Cadena_Vacia
							END AS RFC,
							Cadena_Vacia AS CURP,
							CASE WHEN TipoPersona = Persona_Moral THEN LEFT(UPPER(IFNULL(RazonSocial, Cadena_Vacia)), 150)
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN Cadena_Vacia
								 ELSE Cadena_Vacia
							END AS RazonSocial,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(PrimerNombre,Cadena_Vacia)),30)
								 ELSE Cadena_Vacia
							END AS PrimerNombre,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN
									CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
											LEFT(UPPER(CONCAT(IFNULL(SegundoNombre, Cadena_Vacia),' ',IFNULL(TercerNombre, Cadena_Vacia))), 30)
										 WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia)  = Cadena_Vacia THEN
											LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
										 WHEN IFNULL(SegundoNombre, Cadena_Vacia) =  Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
											LEFT(UPPER(IFNULL(TercerNombre, Cadena_Vacia)), 30)
										 ELSE LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
									END
							END AS SegundoNombre,

							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(ApellidoPaterno, Cadena_Vacia)), 25)
								 ELSE Cadena_Vacia
							END AS ApellidoPaterno,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(ApellidoMaterno, Cadena_Vacia)), 25)
								 ELSE Cadena_Vacia
							END AS ApellidoMaterno,
							LEFT(CONCAT(LTRIM(RTRIM((Calle))),
								CASE WHEN RTRIM(LTRIM(IFNULL(NumExterior, 'SN'))) IN ('', ' SN ', '0')   THEN ' SN ' ELSE CONCAT(" NUM ", LTRIM(RTRIM(IFNULL(NumExterior, 'SN')))) END,
								CASE WHEN RTRIM(LTRIM(IFNULL(NumInterior, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" INT ", LTRIM(RTRIM(NumInterior))) END,
								CASE WHEN RTRIM(LTRIM(IFNULL(Manzana, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" MZ ", LTRIM(RTRIM(Manzana))) END,
								CASE WHEN RTRIM(LTRIM(IFNULL(Lote, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" LT ", LTRIM(RTRIM(Lote))) END
								),40) AS Direcion,
							LEFT(Colonia, 60) AS Colonia,
							LEFT(Mun.Nombre, 40) AS Municipio,
							LEFT(Loc.NombreLocalidad, 40) AS Ciudad,
							LEFT(Est.EqCirCre, 4) AS Estado,
							LEFT(CP, 10) AS CodigoPostal,
							LEFT(IFNULL(Telefono, Cadena_Vacia), 11) AS Telefono,
							LEFT(IFNULL(ExtTelefonoPart, Cadena_Vacia),8) AS ExtTelefonoPart,
							CASE WHEN TipoPersona = Persona_Moral THEN Cliente_Moral
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN Cliente_Fisico
								 ELSE Cliente_Fisico
							END AS TipoCliente
					INTO 	Var_RFCAval,		Var_CURPAval,		Var_RazonSocAval,	Var_PrimerNomAval,	Var_SegundoNomAval,
							Var_ApePaternoAval,	Var_ApeMaternoAval,	Var_DireccionAval1,	Var_ColoniaAval,	Var_MunicipioAval,
							Var_CiudadAval, 	Var_EstadoAval,		Var_CPAval,			Var_TelefonoAval,	Var_ExtAval,
							Var_TipClieAval

					FROM AVALES Aval
					INNER JOIN ESTADOSREPUB Est ON Est.EstadoID = Aval.EstadoID
					INNER JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Aval.EstadoID AND Mun.MunicipioID = Aval.MunicipioID
					LEFT JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Aval.LocalidadID  AND Aval.MunicipioID = Loc.MunicipioID AND Aval.EstadoID = Loc.EstadoID
					WHERE AvalID = Var_ParticipanteID;


					SET Var_EdoExtAccionista := Cadena_Vacia;
					SET Var_DireccionAval2   := Cadena_Vacia;
					SET Var_FaxAval 		 := Cadena_Vacia;

				END IF;

				IF( Var_Tabla = Tabla_Cliente ) THEN

					SELECT LEFT(RFCOficial,13) AS RFC,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN  LEFT(CURP,18)
								 ELSE Cadena_Vacia
							END AS CURP,
							CASE WHEN TipoPersona = Persona_Moral THEN LEFT(UPPER(IFNULL(RazonSocial, Cadena_Vacia)), 150)
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN Cadena_Vacia
								 ELSE Cadena_Vacia
							END AS RazonSocial,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(PrimerNombre,Cadena_Vacia)),30)
								 ELSE Cadena_Vacia
							END AS PrimerNombre,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN
									CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
											LEFT(UPPER(CONCAT(IFNULL(SegundoNombre, Cadena_Vacia),' ',IFNULL(TercerNombre, Cadena_Vacia))), 30)
										 WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia)  = Cadena_Vacia THEN
											LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
										 WHEN IFNULL(SegundoNombre, Cadena_Vacia) =  Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
											LEFT(UPPER(IFNULL(TercerNombre, Cadena_Vacia)), 30)
										 ELSE LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
									END
							END AS SegundoNombre,

							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(ApellidoPaterno, Cadena_Vacia)), 25)
								 ELSE Cadena_Vacia
							END AS ApellidoPaterno,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(ApellidoMaterno, Cadena_Vacia)), 25)
								 ELSE Cadena_Vacia
							END AS ApellidoMaterno,
							LEFT(IFNULL(Telefono, Cadena_Vacia), 11) AS Telefono,
							LEFT(IFNULL(ExtTelefonoPart, Cadena_Vacia),8) AS ExtTelefonoPart,
							LEFT(IFNULL(Fax, Cadena_Vacia),11) AS Fax,
							CASE WHEN TipoPersona = Persona_Moral THEN Cliente_Moral
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN Cliente_Fisico
								 ELSE Cliente_Fisico
							END AS TipoCliente
					INTO 	Var_RFCAval,		Var_CURPAval,		Var_RazonSocAval,		Var_PrimerNomAval,	Var_SegundoNomAval,
							Var_ApePaternoAval,	Var_ApeMaternoAval,	Var_TelefonoAval,		Var_ExtAccionista,	 Var_FaxAccionista,
							Var_TipClieAval
					FROM CLIENTES
					WHERE ClienteID = Var_ParticipanteID;

					SELECT LEFT(CONCAT(LTRIM(RTRIM((Dir.Calle))),
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumeroCasa, 'SN'))) IN ('', ' SN ', '0')   THEN ' SN ' ELSE CONCAT(" NUM ", LTRIM(RTRIM(IFNULL(Dir.NumeroCasa, 'SN')))) END,
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.NumInterior, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" INT ", LTRIM(RTRIM(Dir.NumInterior))) END,
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Manzana, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" MZ ", LTRIM(RTRIM(Dir.Manzana))) END,
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Lote, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" LT ", LTRIM(RTRIM(Dir.Lote))) END,
							CASE WHEN RTRIM(LTRIM(IFNULL(Dir.Piso, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" PISO ", LTRIM(RTRIM(Dir.Piso))) END
							),40) AS Direcion,
							LEFT(Dir.Colonia, 60) AS Colonia,
							LEFT(Mun.Nombre, 40) AS Municipio,
							LEFT(Loc.NombreLocalidad, 40) AS Ciudad,
							LEFT(Est.EqCirCre, 4) AS Estado,
							LEFT(Dir.CP, 10) AS CodigoPostal
					INTO	Var_DireccionAval1, Var_ColoniaAval, Var_MunicipioAval, Var_CiudadAval, Var_EstadoAval, Var_CPAval
					FROM DIRECCLIENTE Dir
					LEFT JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Dir.LocalidadID  AND Dir.MunicipioID = Loc.MunicipioID AND Dir.EstadoID = Loc.EstadoID
					LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
					LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Dir.EstadoID
					WHERE Dir.ClienteID = Var_ParticipanteID
					  AND IFNULL(Dir.Oficial, Con_NO) = Con_SI;

					SET Var_EdoExtAccionista 	 := Cadena_Vacia;
					SET Var_DireccionAccionista2 := Cadena_Vacia;

				END IF;

				--
				IF( Var_Tabla = Tabla_Prospecto ) THEN

					SELECT 	LEFT(RFC,13) AS RFC,
							Cadena_Vacia AS CURP,
							CASE WHEN TipoPersona = Persona_Moral THEN LEFT(UPPER(IFNULL(RazonSocial, Cadena_Vacia)), 150)
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN Cadena_Vacia
								 ELSE Cadena_Vacia
							END AS RazonSocial,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(PrimerNombre,Cadena_Vacia)),30)
								 ELSE Cadena_Vacia
							END AS PrimerNombre,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN
									CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
											LEFT(UPPER(CONCAT(IFNULL(SegundoNombre, Cadena_Vacia),' ',IFNULL(TercerNombre, Cadena_Vacia))), 30)
										 WHEN IFNULL(SegundoNombre, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia)  = Cadena_Vacia THEN
											LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
										 WHEN IFNULL(SegundoNombre, Cadena_Vacia) =  Cadena_Vacia AND IFNULL(TercerNombre, Cadena_Vacia) <> Cadena_Vacia THEN
											LEFT(UPPER(IFNULL(TercerNombre, Cadena_Vacia)), 30)
										 ELSE LEFT(UPPER(IFNULL(SegundoNombre, Cadena_Vacia)), 30)
									END
							END AS SegundoNombre,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(ApellidoPaterno, Cadena_Vacia)), 25)
								 ELSE Cadena_Vacia
							END AS ApellidoPaterno,
							CASE WHEN TipoPersona = Persona_Moral THEN Cadena_Vacia
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN LEFT(UPPER(IFNULL(ApellidoMaterno, Cadena_Vacia)), 25)
								 ELSE Cadena_Vacia
							END AS ApellidoMaterno,
							LEFT(IFNULL(Telefono, Cadena_Vacia), 11) AS Telefono,
							LEFT(IFNULL(ExtTelefonoPart, Cadena_Vacia),8) AS ExtTelefonoPart,
							LEFT(Cadena_Vacia,11) AS Fax,
							CASE WHEN TipoPersona = Persona_Moral THEN Cliente_Moral
								 WHEN TipoPersona IN (Persona_Actividad, Persona_Fisica) THEN Cliente_Fisico
								 ELSE Cliente_Fisico
							END AS TipoCliente,
							LEFT(CONCAT(LTRIM(RTRIM((Calle))),
								CASE WHEN RTRIM(LTRIM(IFNULL(NumExterior, 'SN'))) IN ('', ' SN ', '0')   THEN ' SN ' ELSE CONCAT(" NUM ", LTRIM(RTRIM(IFNULL(NumExterior, 'SN')))) END,
								CASE WHEN RTRIM(LTRIM(IFNULL(NumInterior, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" INT ", LTRIM(RTRIM(NumInterior))) END,
								CASE WHEN RTRIM(LTRIM(IFNULL(Manzana, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" MZ ", LTRIM(RTRIM(Manzana))) END,
								CASE WHEN RTRIM(LTRIM(IFNULL(Lote, ''))) IN ('', 'NA', 'SN', '0')   THEN '' ELSE CONCAT(" LT ", LTRIM(RTRIM(Lote))) END
								),40) AS Direcion,
							LEFT(Colonia, 60) AS Colonia,
							LEFT(Mun.Nombre, 40) AS Municipio,

							LEFT(Loc.NombreLocalidad, 40) AS Ciudad,
							LEFT(Est.EqCirCre, 4) AS Estado,
							LEFT(CP, 10) AS CodigoPostal
					INTO 	Var_RFCAval,		Var_CURPAval,		Var_RazonSocAval,		Var_PrimerNomAval,	Var_SegundoNomAval,
							Var_ApePaternoAval,	Var_ApeMaternoAval,	Var_TelefonoAval,		Var_ExtAccionista,	Var_FaxAccionista,
							Var_TipClieAval,	Var_DireccionAval1,	Var_ColoniaAval,		Var_MunicipioAval, 	Var_CiudadAval,
							Var_EstadoAval,		Var_CPAval
					FROM PROSPECTOS Pro
					INNER JOIN ESTADOSREPUB Est ON Est.EstadoID = Pro.EstadoID
					INNER JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Pro.EstadoID AND Mun.MunicipioID = Pro.MunicipioID
					LEFT JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Pro.LocalidadID  AND Pro.MunicipioID = Loc.MunicipioID AND Pro.EstadoID = Loc.EstadoID
					WHERE ProspectoID = Var_ParticipanteID;

					SET Var_EdoExtAccionista 	 := Cadena_Vacia;
					SET Var_DireccionAccionista2 := Cadena_Vacia;

				END IF;

				-- Actualizo Aval
				UPDATE TMPREPCIRCULOPM SET
					RFCAval			= RPAD(IFNULL(Var_RFCAval,Cadena_Vacia) , 13, ' '),
					CURPAval		= RPAD(IFNULL( Var_CURPAval,Cadena_Vacia), 18, ' '),
					RazonSocAval	= RPAD(
										CASE WHEN IFNULL(Var_RazonSocAval, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_RazonSocAval, Cadena_Vacia)
											 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_RazonSocAval, Cadena_Vacia),LimpiaAlfaNumerico) END
											  , 150, ' '),
					PrimerNomAval	= RPAD(IFNULL(Var_PrimerNomAval, Cadena_Vacia), 30, ' '),
					SegundoNomAval	= RPAD(IFNULL(Var_SegundoNomAval, Cadena_Vacia), 30, ' '),

					ApePaternoAval 	= RPAD(IFNULL(Var_ApePaternoAval, Cadena_Vacia), 25, ' '),
					ApeMaternoAval	= RPAD(IFNULL(Var_ApeMaternoAval, Cadena_Vacia), 25, ' '),
					DireccionAval1	= RPAD(
										CASE WHEN IFNULL(Var_DireccionAval1, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_DireccionAval1, Cadena_Vacia)
											 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_DireccionAval1, Cadena_Vacia),LimpiaAlfaNumerico) END
										  , 40, ' '),
					DireccionAval2	= RPAD(IFNULL(Var_DireccionAval2, Cadena_Vacia), 40, ' '),

					ColoniaAval		= RPAD(
										CASE WHEN IFNULL(Var_ColoniaAval, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_ColoniaAval, Cadena_Vacia)
											 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_ColoniaAval, Cadena_Vacia),LimpiaAlfaNumerico) END
										  , 60, ' '),

					MunicipioAval	= RPAD(
										CASE WHEN IFNULL(Var_MunicipioAval, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_MunicipioAval, Cadena_Vacia)
											 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_MunicipioAval, Cadena_Vacia),LimpiaAlfaNumerico) END
									  , 40, ' '),
					CiudadAval		= RPAD(
										CASE WHEN IFNULL(Var_CiudadAval, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Var_CiudadAval, Cadena_Vacia)
											 ELSE FNLIMPIACARACTBUROCRED(IFNULL(Var_CiudadAval, Cadena_Vacia),LimpiaAlfaNumerico) END
									  , 40, ' '),
					EstadoAval		= RPAD(IFNULL(Var_EstadoAval, Cadena_Vacia), 4, ' '),
					CPAval			= RPAD(IFNULL(Var_CPAval, Cadena_Vacia), 10, ' '),
					TelefonoAval	= CASE WHEN LTRIM(RTRIM(Var_TelefonoAval)) = Cadena_Vacia THEN LPAD(LTRIM(RTRIM(Var_TelefonoAval)), 11, ' ')
												   ELSE LPAD(LTRIM(RTRIM(Var_TelefonoAval)), 11, '0') END,
					ExtAval			= CASE WHEN IFNULL(Var_ExtAval, Cadena_Vacia) = Cadena_Vacia THEN LPAD(IFNULL(Var_ExtAval, Cadena_Vacia), 8, ' ')
												   ELSE LPAD(IFNULL(Var_ExtAval, Cadena_Vacia), 8, '0') END,
					FaxAval			= CASE WHEN IFNULL(Var_FaxAval, Cadena_Vacia) = Cadena_Vacia THEN LPAD(IFNULL(Var_FaxAval, Cadena_Vacia), 11, ' ')
												   ELSE LPAD(IFNULL(Var_ExtAval, Cadena_Vacia), 11, '0') END,
					TipClieAval		= IFNULL(Var_TipClieAval, Cadena_Vacia),
					EdoExtAval 		= RPAD(IFNULL(Var_EdoExtAval, Cadena_Vacia), 40, ' '),
					PaisAval		= Domicilio_MX
				WHERE RegistroID = Var_RegistroID
				  AND Transaccion = Aud_NumTransaccion;

				SET Var_ContadorAval := Var_ContadorAval + Entero_Uno;
			END IF;

			SET Var_IteracionCreditos := Var_IteracionCreditos + Entero_Uno;
			SET Var_RegistroID 		:= Var_RegistroID + Entero_Uno;

			-- Seteo de Clientes
			SET Var_Direccion		:= Cadena_Vacia;
			SET Var_Colonia			:= Cadena_Vacia;
			SET Var_Municipio		:= Cadena_Vacia;
			SET Var_Estado			:= Cadena_Vacia;
			SET Var_Ciudad			:= Cadena_Vacia;

			SET Var_CodigoPostal	:= Cadena_Vacia;


			SET Var_FechaInicioCre	:= Fecha_Cadena;
			SET Var_Relacionado 	:= Cadena_Vacia;
			SET Var_PlazoID 		:= Entero_Cero;
			SET Var_MontoCredito 	:= Entero_Cero;
			SET Var_MonedaID 		:= Entero_Cero;

			SET Var_NumPagos		:= Entero_Cero;
			SET Var_Frecuencia 		:= Cadena_Vacia;
			SET Var_FechaTerminacion := Fecha_Cadena;
			SET Var_PeriodicidadCap := Entero_Cero;
			SET Var_FechaTraspasoVenc := Fecha_Cadena;
			SET Var_CreditoMaximo 	:= Entero_Cero;
			SET Var_TipoCredito		:= Cadena_Vacia;
			SET Var_FechaRestructura := Fecha_Cadena;
			SET Var_EqBuroCred 		:= Cadena_Vacia;
			SET Var_FechaPago 		:= Fecha_Vacia;
			SET Var_NumTransaccion  := Entero_Cero;
			SET Var_MontoTotalPago 	:= Entero_Cero;
			SET Var_MontoPago 		:= Entero_Cero;
			SET Var_ImportePago		:= Entero_Cero;
			SET Var_FechaIncumplimiento := Fecha_Cadena;
			SET Var_Condonaciones	:= Entero_Cero;
			SET Var_MontoCastigo	:= Entero_Cero;
			SET Var_SaldoInsoluto	:= Entero_Cero;
			SET Var_SaldoInteres	:= Entero_Cero;
			SET Var_DiasAtraso		:= Entero_Cero;


			-- Seteo de Directivos
			SET Var_RFCAccionista	:= Cadena_Vacia;
			SET Var_CURPAccionista	:= Cadena_Vacia;
			SET Var_RazonSocAccionista	:= Cadena_Vacia;
			SET Var_PrimerNomAccionista	:= Cadena_Vacia;

			SET Var_SegundoNomAccionista := Cadena_Vacia;
			SET Var_ApePaternoAccionista := Cadena_Vacia;
			SET Var_ApeMaternoAccionista := Cadena_Vacia;
			SET Var_Porcentaje 			 := Cadena_Vacia;
			SET Var_DireccionAccionista1 := Cadena_Vacia;

			SET Var_DireccionAccionista2 := Cadena_Vacia;
			SET Var_ColoniaAccionista 	:= Cadena_Vacia;
			SET Var_ColoniaAccionistaID := Entero_Cero;
			SET Var_MunicipioID 		:= Entero_Cero;
			SET Var_CiudadAccionista 	:= Cadena_Vacia;
			SET Var_EstadoID			:= Entero_Cero;

			SET Var_CPAccionista 		:= Cadena_Vacia;
			SET Var_TelefonoAccionista	:= Cadena_Vacia;
			SET Var_ExtAccionista		:= Cadena_Vacia;
			SET Var_FaxAccionista		:= Cadena_Vacia;
			SET Var_TipClieAccionista	:= Cadena_Vacia;

			SET Var_EdoExtAccionista	:= Cadena_Vacia;
			SET Var_TipoAccionista 		:= Cadena_Vacia;
			SET Var_EstadoAccionista 	:= Cadena_Vacia;
			SET Var_MunicipioAccionista := Cadena_Vacia;

			-- Seteo de Avales
			SET Var_RFCAval			:= Cadena_Vacia;
			SET Var_CURPAval		:= Cadena_Vacia;
			SET Var_RazonSocAval	:= Cadena_Vacia;
			SET Var_PrimerNomAval	:= Cadena_Vacia;
			SET Var_SegundoNomAval	:= Cadena_Vacia;

			SET Var_ApePaternoAval	:= Cadena_Vacia;
			SET Var_ApeMaternoAval	:= Cadena_Vacia;
			SET Var_DireccionAval1	:= Cadena_Vacia;
			SET Var_DireccionAval2	:= Cadena_Vacia;
			SET Var_ColoniaAval 	:= Cadena_Vacia;

			SET Var_MunicipioID 	:= Entero_Cero;
			SET Var_CiudadAval 		:= Cadena_Vacia;
			SET Var_EstadoID		:= Entero_Cero;
			SET Var_CPAval 			:= Cadena_Vacia;
			SET Var_TelefonoAval	:= Cadena_Vacia;

			SET Var_ExtAval			:= Cadena_Vacia;
			SET Var_FaxAval			:= Cadena_Vacia;
			SET Var_TipClieAval		:= Cadena_Vacia;

			SET Var_EdoExtAval		:= Cadena_Vacia;


		END WHILE;
		SET Var_Contador := Var_Contador + Entero_Uno;
		SET Var_RegistroDirectivo := Entero_Cero;
		SET Var_RegistroAval 	:= Entero_Cero;
	END WHILE;

	SELECT
		CreditoID,
		RFC,					CURP,					RazonSocial,			PrimerNombre,			SegundoNombre,
		ApellidoPaterno,		ApellidoMaterno,		Nacionalidad,			ClasificacionCartera,	ClaveBanxico1,
		ClaveBanxico2,			ClaveBanxico3,			Direccion1,				Direccion2,				Colonia,
		Municipio,				Ciudad,					Estado,					CodigoPostal,			Telefono,
		Extension,				Fax,					TipoCliente,			EdoExtranjero,			Pais,
		TelefonoCelular,		Correo AS CorreoElectronico, Monto AS SalarioMensual, FechaIngreso,

		RFCAccionista,			CURPAccionista,			RazonSocAccionista,		PrimerNomAccionista,	SegundoNomAccionista,
		ApePaternoAccionista,	ApeMaternoAccionista,	Porcentaje,				DireccionAccionista1,	DireccionAccionista2,
		ColoniaAccionista,		MunicipioAccionista,	CiudadAccionista,		EstadoAccionista,		CPAccionista,
		TelefonoAccionista,		ExtAccionista,			FaxAccionista,			TipClieAccionista,		EdoExtAccionista,
		PaisAccionista,

		NumeroContratoAnt,		FechaApertura,			PlazoCredito,			TipoCredito,			SaldoInicial,
		Moneda,					NumeroPagos,			FrecuenciaPago,			ImportePago,			FechaUltimoPago,
		FechaRestructura,		PagoCredito,			FechaLiquidacion,		Quita,					Dacion,
		Castigo,				ClaveObservacion,		Especiales,				FechaIncumplimiento,	SaldoInsoluto,
		CreditoMaximo,			FechaCartVencida,		DiasVencidos,			SaldoTotal,				Interes,

		RFCAval,				CURPAval,				RazonSocAval,			PrimerNomAval,			SegundoNomAval,
		ApePaternoAval,			ApeMaternoAval,			DireccionAval1,			DireccionAval2,			ColoniaAval,
		MunicipioAval,			CiudadAval,				EstadoAval,				CPAval,					TelefonoAval,
		ExtAval,				FaxAval,				TipClieAval,			EdoExtAval,				PaisAval
	FROM TMPREPCIRCULOPM
	WHERE Transaccion = Aud_NumTransaccion;

	DELETE FROM TMPREPCIRCULOPM
		WHERE Transaccion = Aud_NumTransaccion;

END TerminaStore$$