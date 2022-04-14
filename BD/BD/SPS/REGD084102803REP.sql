-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGD084102803REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGD084102803REP`;

DELIMITER $$
CREATE PROCEDURE `REGD084102803REP`(
	# ============================================================================================================
	# ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE R0841 -----------------------
	# ============================================================================================================
	Par_Fecha           DATETIME,				# Fecha de generacion del reporte
	Par_NumReporte      TINYINT UNSIGNED,		# Tipo de reporte 1: Excel 2: CVS
	Par_NumDecimales    INT,					# Numero de Decimales en Cantidades o Montos

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
	)
TerminaStore: BEGIN

	-- Declaracion de Variables.
	DECLARE Var_FechaHis		DATE;
	DECLARE	Var_MtoMinAporta	INT;			-- Monto de aportacion (minimo) del sistema
	DECLARE	Var_MonedaBase		INT;			-- Moneda base del sistema
	DECLARE Var_IniMes			DATE;			-- Fecha de Inicio del mes
	DECLARE	Var_ClaveEntidad	VARCHAR(300);	-- Clave de la Entidad de la Institucion
	DECLARE Var_Periodo			CHAR(6);		-- Periodo en el que se genera el reporte
	DECLARE Var_FecBitaco   	DATETIME;
	DECLARE Var_MinutosBit  	INT;
    DECLARE Var_MtoFondoPro		DECIMAL(21,2); -- Monto del Fondo de Proteccion
    DECLARE Var_ValorUDI		DECIMAL(21,2); --  Valor de la UDI en el Periodo
    DECLARE Var_FechaUDI		DATE;
    DECLARE Var_FechaHisUDI		DATETIME;
    DECLARE Var_NumErr			INT;
    DECLARE Var_ErrMen			VARCHAR(150);

	DECLARE Var_FechIniPeriodo DATE;
    DECLARE Var_FechaRepAnt DATE;
    DECLARE Var_FechaIniRepAnt DATE;
    DECLARE Var_FechaHisAnt   DATE;



    DECLARE Salida_NO			CHAR(1);
	DECLARE Rep_Excel       	INT;
	DECLARE Rep_Csv				INT;
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);

    DECLARE Fecha_Vacia			DATE;
	DECLARE Cue_Activa			CHAR(1);
	DECLARE Cue_Bloqueada		CHAR(1);
	DECLARE Ins_CueAhorro   	CHAR(1);
	DECLARE Ins_InvPlazo   		CHAR(1);

    DECLARE Cons_BloqGarLiq		INT;
	DECLARE For_0841			CHAR(4);
	DECLARE SI 					CHAR(1);
	DECLARE Con_NO				CHAR(1);
	DECLARE Fisica				CHAR(1);

    DECLARE Moral				CHAR(1);
	DECLARE Fisica_empre		CHAR(1);
	DECLARE Masculino			CHAR(1);
	DECLARE Femenino    		CHAR(1);
    DECLARE Apellido_Vacio		CHAR(1);

    DECLARE Clave_CertBursatil	INT;
	DECLARE Clave_DepVista		INT;
	DECLARE CLave_Periodicidad	INT;
	DECLARE Clave_Ahorrador		INT;
	DECLARE Clave_AhoradorCred	INT;

    DECLARE Clave_TipoTasa		INT;
	DECLARE Clave_TasaRefe		INT;
	DECLARE Clave_OpeDiferen	INT;
	DECLARE Clave_FrecPlazo		INT;
	DECLARE No_RetAntici		INT;

    DECLARE Si_RetAntici		INT;
	DECLARE Tip_MovAbono		CHAR(1);
	DECLARE Dep_ConInteres		VARCHAR(20);
	DECLARE Dep_ConIntCre		VARCHAR(20);
	DECLARE Dep_SinInteres		VARCHAR(20);

    DECLARE Dep_SinIntCre		VARCHAR(20);
	DECLARE Dep_AhoLibGrav		VARCHAR(20);
	DECLARE Dep_AhoAmpCre		VARCHAR(20);
	DECLARE Dep_PlaLibGrav		VARCHAR(20);
	DECLARE Dep_PlaLibAmpCre	VARCHAR(20);
	DECLARE Dep_RetLibGrav		VARCHAR(20);


    DECLARE Cuen_SinMovimiento	VARCHAR(20);
	DECLARE Codigo_Mexico		INT;
    DECLARE Cadena_Cero			CHAR(1);
    DECLARE Fecha_Nula			VARCHAR(8);
    DECLARE Tipo_GarLiq			VARCHAR(2);

    DECLARE Tipo_DepVis			VARCHAR(2);
    DECLARE Est_Cancelado		CHAR(1);
    DECLARE Est_Inactivo		CHAR(1);
    DECLARE Tipo_Nacional		CHAR(1);
    DECLARE Tipo_Extranj		CHAR(1);

    DECLARE Clave_NacFis		INT;
    DECLARE Clave_NacMor		INT;
    DECLARE Clave_ExtFis		INT;
    DECLARE Clave_ExtMor		INT;
    DECLARE Riesgo_Bajo 		CHAR(1);

    DECLARE Riesgo_Medio 		CHAR(1);
    DECLARE Riesgo_Alto			CHAR(1);
    DECLARE Clave_RiesBajo 		INT;
    DECLARE Clave_RiesMedio 	INT;
    DECLARE Clave_RiesAlto 		INT;

    DECLARE Per_Masculino		INT;
	DECLARE Per_Femenino		INT;
	DECLARE Per_NoAplica		INT;
	DECLARE No_Aplica			VARCHAR(20);
	DECLARE Dep_Vista			CHAR(1);

    DECLARE Dep_Ahorro			CHAR(1);
	DECLARE Moneda_Nacional		INT;
	DECLARE Moneda_Extran		INT;
	DECLARE Nat_Bloqueo			CHAR(1);
	DECLARE Est_Pagado			CHAR(1);

    DECLARE Clave_OtraActiv		INT;
	DECLARE Rango_Uno			INT;
	DECLARE Rango_Dos			INT;
	DECLARE Rango_Tres			INT;
	DECLARE Rango_Cuatro		INT;

    DECLARE Rango_Cinco			INT;
	DECLARE Rango_Seis			INT;
	DECLARE Rango_Siete			INT;
	DECLARE Dep_VisCnInt		INT;
	DECLARE Dep_VisIntCre		INT;

    DECLARE Dep_VisSnInt		INT;
	DECLARE Dep_VisSnIntCre		INT;
	DECLARE Dep_AhoInte			INT;
	DECLARE Dep_AhoCre			INT;
	DECLARE Dep_Plazo			INT;

    DECLARE Dep_PlazoAmpCre		INT;
    DECLARE CaseMayus			VARCHAR(3);
    DECLARE Cliente_Inst      	INT;
    DECLARE Var_FechaCieInv		DATE;
    DECLARE Var_FechaCieCed 	DATE;
    DECLARE Prog_Cierre			VARCHAR(20);
    DECLARE Var_FecMesAnt		DATE;
    DECLARE Monto_UDIS			INT;
    DECLARE Dias_Periodo		INT;
    DECLARE Var_Cien			DECIMAL(16,6);
	DECLARE Clave_PerOtro		INT;
	DECLARE Clave_PerMes		INT;
    DECLARE Dep_Cedes			INT;

	-- Asignacion de Constantes
	SET Rep_Excel       	:= 1;		           	-- Opcion de reporte para excel
	SET Rep_Csv				:= 2;  					-- Opcion de reporte para CVS
	SET Entero_Cero     	:= 0;
	SET Cadena_Vacia    	:= '';
	SET Decimal_Cero    	:= 0.00;

    SET Fecha_Vacia     	:= '1900-01-01';
    SET Fecha_Nula			:= '01011900';			-- Formato dd-mm-aaaa
	SET Cue_Activa      	:= 'A';
	SET Cue_Bloqueada   	:= 'B';
	SET Ins_CueAhorro  		:= '1';   				-- Tipo de Instrumento: Cuenta de Ahorro

    SET Ins_InvPlazo   		:= '2';   				-- Tipo de Instrumento: Inversiones Plazo
	SET Cons_BloqGarLiq		:= 8;					-- Tipo de Bloqueo: Por Gtia Liquida
	SET For_0841			:= '0841';				-- Clave del Formulario o Reporte
	SET SI 					:=	'S';				-- SI
	SET Con_NO				:=	'N'; 				-- NO

    SET Fisica				:=	'F';			-- Tipo de persona fisica
	SET Moral				:=	'M';			-- Tipo de persona moral
	SET Fisica_empre		:=	'A';			-- Persona Fisica Con Actividad Empresarial
	SET Masculino			:=	'M';			-- Sexo masculino
	SET Femenino			:=	'F';			-- Sexo femenino

    SET Apellido_Vacio		:=  'X';
    SET Clave_CertBursatil 	:= 21250201;		-- Clave de registro del certificado bursatil
    SET Clave_DepVista		:= 100;				-- Clave para Dep a la Vista
    SET Clave_Periodicidad 	:= 7;		-- Clave para Mensual
    SET Clave_TipoTasa 		:= 101;		-- Clave Tipo de Tasa - Fija

    SET Clave_TasaRefe		:= 102;		-- Clave de sin tasa de referencia
    SET Clave_OpeDiferen 	:= 101; 	-- Suma del Diferencial
    SET Clave_FrecPlazo		:= 30;		-- Frecuencua Mensual
    SET No_RetAntici		:= 102;		-- Clave No Retiro Anticipado
    SET Si_RetAntici		:= 101;		-- Clave Si Retiro Anticipado

    SET Tip_MovAbono		:= 'A';				-- Tipo de movimiento para abono a cuenta
    SET Dep_ConInteres		:= '210101020100';	-- Depositos a la vista con interes libres de gravamen
	SET Dep_ConIntCre		:= '210101020200';	-- Depositos a la vista con interes libres de gravamen que amparan creditos
	SET Dep_SinInteres		:= '210101010100';	-- Depositos a la vista sin interes libres de gravamen
	SET Dep_SinIntCre		:= '210101010200';	-- Depositos a la vista sin interes libres de gravamen que amparan creditos

    SET Dep_AhoLibGrav		:= '210102010000';	-- Depositos de ahorro libres de gravamen
	SET Dep_AhoAmpCre		:= '210102020000';	-- Depositos de ahorro que amparan creditos
	SET Cuen_SinMovimiento	:= '240120000000';	-- Cuentas sin movimiento
	SET Clave_Ahorrador		:= 1;
	SET Clave_AhoradorCred	:= 3;

    SET Codigo_Mexico		:= 484;  			-- Pais Mexico CNBV
	SET Dep_PlaLibGrav		:= '211190100000'; 	-- Depositos a plazo libres de gravamen
	SET Dep_PlaLibAmpCre 	:= '211190200000'; 	-- Depositos a plazo libres de gravamen que amparan creditos
    SET Dep_RetLibGrav		:= '211104010000';	-- DEPOSITOS RETIRABLES EN DIAS PREESTABLECIDOS
    SET Cadena_Cero			:= '0';
    SET Tipo_GarLiq			:= 'GL';			-- Dep Garantia liquida

    SET Tipo_DepVis			:= 'DV'; 			-- Dep a la Vista
    SET Est_Cancelado		:= 'C'; 			-- Estatus cancelado
    SET Est_Inactivo		:= 'I'; 			-- Estatus Activo
    SET Tipo_Nacional		:= 'N'; 			-- Cliente nacional
    SET Tipo_Extranj		:= 'E'; 			-- Cliente Extranjero

    SET Riesgo_Bajo			:= 'B'; 			-- Nivel riesgo Bajo
    SET Riesgo_Medio		:= 'M'; 			-- Nivel Riesgo Medio
    SET Riesgo_Alto			:= 'A'; 			-- Nivel Riesgo Alto
    SET Clave_RiesBajo		:= 1; 				-- Clave de Nivel Bajo
    SET Clave_RiesMedio		:= 2; 				-- Clave de Nivel Medio

    SET Clave_RiesAlto		:= 3; 				-- Clave de Nivel Alto
    SET Clave_NacFis		:= 1; 				-- Persona Fisica Nacional
    SET Clave_NacMor		:= 2; 				-- Persona Moral Nacional
    SET Clave_ExtFis		:= 3; 				-- Persona Fisica Extranjera
    SET Clave_ExtMor		:= 4; 				-- Persona Moral Estranjera

    SET Per_Masculino		:= 3; 				-- Persona Masculina
	SET Per_Femenino		:= 2;  				-- Persona Femenina
	SET Per_NoAplica		:= 1; 				-- No Aplica - Morales
	SET No_Aplica			:= 'No aplica'; 	--  DESC. No Aplica
	SET Dep_Vista			:= 'V'; 			--  Deposito a la vista

    SET Dep_Ahorro			:= 'A'; 			-- deposito de Ahorro
	SET Moneda_Nacional 	:= 14;			-- Moneda Nacional
	SET Moneda_Extran		:= 4;			-- Moneda Extranjera
	SET Nat_Bloqueo			:= 'B';			-- Naturaleza Bloqueado
	SET Est_Pagado			:= 'P'; 		-- Estatus Pagado

    SET Clave_OtraActiv		:= 81299;		-- Clave Otra Actividad
	SET Rango_Uno			:= 101; 		-- 1 a 7 Dias
	SET Rango_Dos			:= 102; 		-- 8 a 30 Dias
	SET Rango_Tres			:= 103; 		-- 31 a 90 Dias
	SET Rango_Cuatro		:= 104; 		-- 91 a 180 dias

    SET Rango_Cinco			:= 105; 		-- 181 - 365 dias
	SET Rango_Seis			:= 106; 		-- 366 - 730 dias
	SET Rango_Siete			:= 107; 		-- > 730 dias
	SET Dep_VisCnInt		:= 3;			-- deposito a la vista con intereses
	SET Dep_VisIntCre 		:= 4;			-- deposito a la vista con inte ampara credito

    SET Dep_VisSnInt 		:= 1; 			-- eposito a la vista sin intereses
	SET Dep_VisSnIntCre 	:= 2;			-- Deposito a la vista sin interes ampara credito
	SET Dep_AhoInte			:= 5;   		-- Deposito de Ahorro
	SET Dep_AhoCre 			:= 6;			-- Deposito de ahorro que ampara credito
	SET Dep_Plazo 			:= 9; 			-- depositos a plazo

    SET Dep_PlazoAmpCre 	:= 10; 			-- depositos a plazo que amparan creditos
    SET CaseMayus			:= 'MA';		-- Convertir a Mayusculas
    SET Prog_Cierre			:= 'CIERREMESAHORRO';
    SET Monto_UDIS			:= 25000;		-- Fondo de proteccion
    SET Salida_NO			:= 'N';

    SET Var_Cien 			:= 100.000000;  -- Valor de 100 por ciento
    SET Clave_PerOtro		:= 7;
	SET Clave_PerMes		:= 3;
    SET Dep_Cedes			:= 11;


	SET Var_Periodo := CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),1,4),
							  SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),5,2));

	SET Var_ClaveEntidad	:= IFNULL((SELECT Par.ClaveEntidad
										FROM PARAMETROSSIS Par
										WHERE Par.EmpresaID = Par_EmpresaID), Cadena_Vacia);

	SET Cliente_Inst    := (SELECT ClienteInstitucion FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);
    SET Var_FechaCieInv := (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Par_Fecha);
	SET Var_FechaCieCed	:= (SELECT MAX(FechaCorte) FROM SALDOSCEDES WHERE FechaCorte <= Par_Fecha);

	SELECT IFNULL(DATE(FechaActual),Fecha_Vacia), ROUND(IFNULL(TipCamDof,Decimal_Cero),2)
			INTO Var_FechaUDI,Var_ValorUDI FROM MONEDAS
    WHERE MonedaID = 4 AND DATE(FechaActual) <= Par_Fecha;

    -- Actualiza el Primer deposito en la cuenta, para las que fueron creadas durante el periodo
   	CALL PRIMERDEPCTAHOPRO(Entero_Cero,		Par_Fecha,		Salida_NO,			Var_NumErr,			Var_ErrMen,
							Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
                            Aud_Sucursal,	Aud_NumTransaccion);


	IF IFNULL(Var_FechaUDI,Fecha_Vacia) = Fecha_Vacia AND IFNULL(Var_ValorUDI,Decimal_Cero) = Decimal_Cero THEN
		SELECT MAX(FechaActual) INTO Var_FechaHisUDI FROM `HIS-MONEDAS`
        WHERE MonedaID = 4 AND DATE(FechaActual) <= Par_Fecha;

        SELECT ROUND(TipCamDof,2) INTO Var_ValorUDI FROM  `HIS-MONEDAS`
        WHERE MonedaID = 4 AND FechaActual = Var_FechaHisUDI LIMIT 1 ;
    END IF;

    SET Var_MtoFondoPro = Monto_UDIS * IFNULL(Var_ValorUDI,Decimal_Cero);


	DROP TABLE IF EXISTS TMPREGB0841;

	CREATE TABLE TMPREGB0841(
		ClienteID		INT,
		Nombre			VARCHAR(200),
		ApellidoPat		VARCHAR(200),
		ApellidoMat		VARCHAR(200),
		PersJuridica	INT,
		GradoRiesgo		CHAR(1),

		ActividadBmx	VARCHAR(20),
		ActividadEco	VARCHAR(10),
		Nacionalidad	INT,
		FechaNac		VARCHAR(20),
		RFC				VARCHAR(20),
		CURP			VARCHAR(18),

		Genero			INT,
		Calle			VARCHAR(250),
		NumeroExt		VARCHAR(50),
		ColoniaID		INT,
		ColoniaDes		VARCHAR(250),
		CodigoPostal	VARCHAR(20),

		Localidad		VARCHAR(20),
		EstadoID		INT,
		EstadoClave		VARCHAR(20),
		MunicipioID		INT,
		MunicipioClave	VARCHAR(20),

		CodigoPais		VARCHAR(20),
		ClaveSucursal	VARCHAR(10),
		NumeroCuenta	VARCHAR(20),
		NumContrato		VARCHAR(20),
		TipoCliente		INT,
		ClasfContable	VARCHAR(20),

		ClasfBursatil	VARCHAR(20),
		TipoInstrumento	INT,
        TipoProducto	VARCHAR(10),
		FechaApertura	VARCHAR(20),
		FechaDepoIni	VARCHAR(10),
		MontoDepoIniOri	DECIMAL(16,2),

		MontoDepoIniPes	DECIMAL(16,2),
		FechaDepoVenc	VARCHAR(10),
		PlazoAlVencimi	INT,
		RangoPlazo		INT,
		Periodicidad	INT,

		TipoTasa		INT,
		TasaInteres		DECIMAL(16,6),
		TasaPeriodo		DECIMAL(16,6),
		TasaReferencia	INT,
		DiferencialTasa DECIMAL(16,6),

		OpeDiferencial	INT,
		Plazo			INT,
		Moneda			CHAR(2),
		SaldoIniPer		DECIMAL(21,2),
		MtoDepositos	DECIMAL(21,2),

		MtoRetiros		DECIMAL(21,2),
		IntDevNoPago	DECIMAL(21,2),
		SaldoFinal		DECIMAL(21,2),
		InteresMes		DECIMAL(21,2),
		ComisionMes		DECIMAL(21,2),
		FecUltMov		VARCHAR(20),

		MontoUltMov		DECIMAL(21,2),
		SaldoProm		DECIMAL(21,2),
		RetiroAnt		INT,
		MontoFondPro	DECIMAL(21,2),
		PorcFondoPro	DECIMAL(16,6),

		PorcGarantia	DECIMAL(16,6),
		InstrumentoID	BIGINT,

        NumDias			INT,
        SaldoFinInv		DECIMAL(21,2),
        FechaAper		DATE,
        ClaveAmpCed		VARCHAR(10),

		INDEX TMPREGB0841_idx1(ClienteID),
		INDEX TMPREGB0841_idx2(InstrumentoID),
		INDEX TMPREGB0841_idx3(EstadoID, MunicipioID, ColoniaID),
		INDEX TMPREGB0841_idx4(NumDias, TipoInstrumento)

		)ENGINE=INNODB DEFAULT CHARSET=LATIN1;

        DROP TABLE IF EXISTS TMP_FACTSALDO;
        CREATE TEMPORARY TABLE TMP_FACTSALDO(
			NumDias INT PRIMARY KEY,
            NumFactor INT);

		INSERT INTO TMP_FACTSALDO VALUES
        (0,0),(1,1),(2,3),(3,6),(4,10),
		(5,15),(6,21),(7,28),(8,36),(9,45),
		(10,55),(11,66),(12,78),(13,91),(14,105),
		(15,120),(16,136),(17,153),(18,171),(19,190),
		(20,210),(21,231),(22,253),(23,276),(24,300),
		(25,325),(26,351),(27,378),(28,406),(29,435),
		(30,465),(31,496),(32,528);


	SET Var_FechaHis := (SELECT MAX(Fecha)
							FROM `HIS-CUENTASAHO` WHERE Fecha <= Par_Fecha);

	SET Var_FechaHis := IFNULL(Var_FechaHis, Fecha_Vacia);

	SELECT MontoAportacion, MonedaBaseID INTO Var_MtoMinAporta, Var_MonedaBase
		FROM PARAMETROSSIS;

	SET Var_MtoMinAporta := IFNULL(Var_MtoMinAporta, Entero_Cero);
	SET Var_IniMes := DATE_ADD(Par_Fecha, INTERVAL ((DAY(Par_Fecha)*-1) + 1) DAY);
	SET Var_FecMesAnt :=  DATE_SUB(Var_IniMes, INTERVAL 1 DAY);

    SET Var_FechIniPeriodo  := Var_IniMes;

    SET Var_FechaHisAnt := (SELECT MAX(Fecha)
              FROM `HIS-CUENTASAHO` WHERE Fecha <= Var_IniMes);


	SET	Var_FecBitaco	:= NOW();

	-- Clientes que tienen Credito
	DROP TABLE IF EXISTS TMPCLIENTAHOCRED;
	CREATE TEMPORARY TABLE TMPCLIENTAHOCRED
		SELECT DISTINCT(ClienteID) AS ClienteID FROM
			CREDITOS WHERE
			FechaInicio <= Par_Fecha
			AND FechaVencimien >= Var_IniMes
			AND Estatus NOT IN(Est_Cancelado,Est_Inactivo);

	CREATE INDEX idx_TMPCLIENTAHOCRED_1 ON TMPCLIENTAHOCRED(ClienteID);

	-- Valor de Monedas
	DROP TABLE IF EXISTS TMPHISMONEDAS;
	CREATE TEMPORARY TABLE TMPHISMONEDAS
		SELECT MonedaId,MAX(FechaRegistro)AS Fecha, ROUND(MAX(TipCamDof),2) AS Valor
			FROM `HIS-MONEDAS`
			WHERE FechaRegistro < Var_IniMes
			GROUP BY MonedaID;

	CREATE INDEX idx_TMPHISMONEDAS_1 ON TMPHISMONEDAS(MonedaID);

	UPDATE TMPHISMONEDAS Tem, `HIS-MONEDAS` His
		SET Tem.Valor = ROUND(His.TipCamDof,2)
		WHERE Tem.MonedaID = His.MonedaId
		AND Tem.Fecha = His.FechaRegistro;

	INSERT INTO TMPREGB0841
				-- Cliente ID
		SELECT  His.ClienteID,
				-- Nombre / Razon Social
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						SUBSTRING(CONCAT(IFNULL(PrimerNombre, Cadena_Vacia),
									CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(" ", SegundoNombre) ELSE Cadena_Vacia
									END,
									CASE WHEN IFNULL(TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(" ", TercerNombre) ELSE Cadena_Vacia
									END),  1, 200)
					 ELSE UPPER(Cli.RazonSocial)
				END,
				-- Apellido Paterno
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   CASE WHEN IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = Cadena_Vacia
									OR IFNULL(Cli.ApellidoPaterno,Apellido_Vacio) = '.' THEN
								Apellido_Vacio
							ELSE
								UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END ,
				-- Apellido Materno
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Apellido_Vacio) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END,
				-- Personalidad Juridica
				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
					 END,
				-- Grado de Riesgo
				CASE WHEN Cli.NivelRiesgo = Riesgo_Alto THEN Clave_RiesAlto
					 WHEN Cli.NivelRiesgo = Riesgo_Medio THEN Clave_RiesMedio
					 WHEN Cli.NivelRiesgo = Riesgo_Bajo THEN Clave_RiesBajo
					 END,
				-- Actividad Economica
				Cli.ActividadBancoMX,
				Cadena_Vacia,
				-- Pais de Nacimiento
				Cli.LugarNacimiento,
				-- Fecha de Nacimiento
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						DATE_FORMAT(IFNULL(Cli.FechaNacimiento,Fecha_Vacia) ,'%d%m%Y')
					 ELSE
						DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%d%m%Y')
					END,

				-- RFC
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.RFCOficial
					 ELSE CONCAT("_", IFNULL(Cli.RFCOficial,Cadena_Vacia))
				END,
				-- CURP
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.CURP
					 ELSE Cadena_Cero
				END,
				-- Genero
				CASE WHEN Cli.TipoPersona = Moral THEN Per_NoAplica
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Masculino THEN Per_Masculino
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Femenino THEN Per_Femenino
				END,
				-- Calle
				IFNULL(Dir.Calle,Cadena_Vacia),
				-- Numero Ext
				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),
				-- Colonia ID
				IFNULL(Dir.ColoniaID,Entero_Cero),
				Cadena_Vacia,
				-- Codigo Postal
				IFNULL(Dir.CP,Entero_Cero),
				-- Localidad
				IFNULL(Dir.LocalidadID, Entero_Cero),
				-- Estado
				IFNULL(Dir.EstadoID, Entero_Cero),
				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,
				-- Municipio
				IFNULL(Dir.MunicipioID, Entero_Cero),
				Cadena_Vacia AS MunicipioClave,
				-- Pais
				Codigo_Mexico,
				-- Sucursal
				IFNULL(Suc.ClaveSucOpeCred,Cadena_Vacia),
				-- Numero Cuenta
				CONVERT(His.CuentaAhoID, CHAR),
				-- Numero Contrato
				CONVERT(His.CuentaAhoID, CHAR),
				-- Tipo Cliente
				Clave_Ahorrador,
				-- Clasificacion contable
				CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
					 Dep_ConInteres	-- a la vista, con intereses, libres de gravamen.
					 WHEN Tip.GeneraInteres = Con_NO AND ClasificacionConta = Dep_Vista  THEN
					 Dep_SinInteres -- a la vista, sin intereses, libres de gravamen
					 WHEN ClasificacionConta = Dep_Ahorro  THEN
					 Dep_AhoLibGrav -- depoitos de ahorro, libres de gravamen
				END,
				-- Clasificacion Bursatil
				Clave_CertBursatil,
				-- Tipo de Producto
                CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisCnInt	-- a la vista, con intereses, libres de gravamen.
					 WHEN Tip.GeneraInteres = Con_NO AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisSnInt -- a la vista, sin intereses, libres de gravamen
					 WHEN ClasificacionConta = Dep_Ahorro THEN
					 Dep_AhoInte	-- depoitos de ahorro, libres de gravamen
				END,
				Tip.ClaveCNBV,
				-- Fecha Contratacion
				IFNULL(DATE_FORMAT(His.FechaApertura,'%d%m%Y'),Fecha_Nula),
				-- Fecha Inicial
                CASE WHEN Cue.FechaDepInicial = Fecha_Vacia THEN
							IFNULL(DATE_FORMAT(His.FechaApertura,'%d%m%Y'),Fecha_Nula)
					 ELSE
						IFNULL(DATE_FORMAT(Cue.FechaDepInicial,'%d%m%Y'),Fecha_Nula)
					 END,
				-- Monto deposito inicial
				IFNULL(Cue.MontoDepInicial,Decimal_Cero),
				-- Monto en Pesos inicial
				IFNULL(Cue.MontoDepInicial,Decimal_Cero),
				-- Fecha Vencimiento del Deposito
				Entero_Cero,
				-- Plazo al Vencimiento
				Entero_Cero,
				-- Rango de plazo
				Clave_DepVista,
				-- Periodicidad
                CASE WHEN Tip.GeneraInteres = 'S' AND  Tip.TipoInteres = 'M' THEN
                Clave_PerMes ELSE Clave_PerOtro END,
				-- Tipo de Tasa
				Clave_TipoTasa,
				-- Valor Tasa
				ROUND(His.TasaInteres,6),
				-- Valor Periodo Tasa
				ROUND(His.TasaInteres,6),
				-- Tasa de Refencia
				Clave_TasaRefe,
				-- Diferencias sobre tasa
				Entero_Cero,
				-- Operacion Diferencial
				Clave_OpeDiferen,
				-- Frecuencia Revision Tasa
				Entero_Cero,
				-- Tipo de Moneda
				Mon.MonedaCNBV,
				-- Saldo Cuenta Inicio Periodo
				IFNULL(His.SaldoIniMes,Decimal_Cero),
				-- Importe Depositos
				His.AbonosMes,
				-- Importe Retiros
				His.CargosMes,
				-- INT. devengados no pagados
				Entero_Cero AS IntDevNoPago,
				-- Saldo Cuenta al Final del Periodo
				IFNULL(His.Saldo,Decimal_Cero),
				-- Intereses del mes
				His.InteresesGen,
				-- Comisiones del mes
				His.Comisiones,
				-- Fecha ultimo Movimiento
				IFNULL(DATE_FORMAT(Fecha_Vacia,'%d%m%Y'),Fecha_Nula),
				-- Monto Ultimo Movimiento
				Decimal_Cero,
				-- Saldo promedio
				His.SaldoProm,
				-- Retiro Anticipado
				No_RetAntici,
				-- Monto Fondo de Proteccion
				Decimal_Cero,
				-- Porcentaje Fondo Pro
				Decimal_Cero,
				-- Porcentaje Garantia
				Decimal_Cero,

				His.CuentaAhoID	,

                Entero_Cero,
                Entero_Cero,
                Fecha_Vacia,
                Tip.ClaveCNBVAmpCred

			FROM `HIS-CUENTASAHO` His,
				  CUENTASAHO Cue,
				 TIPOSCUENTAS Tip,
                 MONEDAS Mon,
				 SUCURSALES Suc,
				 CLIENTES Cli
                 LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, Con_NO) = SI


			WHERE His.Fecha = Var_FechaHis
			  AND His.Estatus IN (Cue_Activa, Cue_Bloqueada,Est_Cancelado)
              AND His.CuentaAhoID = Cue.CuentaAhoID
			  AND His.ClienteID = Cli.ClienteID
              AND His.MonedaId = Mon.MonedaID
              AND His.ClienteID <>Cliente_Inst
              AND Tip.EsBancaria = Con_NO
			  AND His.TipoCuentaID = Tip.TipoCuentaID
			  AND His.SucursalID = Suc.SucursalID
              ;

-- -------------------------------------------------------------- --
	-- Fecha de Ultimo Movimiento
    DROP TABLE IF EXISTS TMPREGDESCAPTULTABONO;
	CREATE TEMPORARY TABLE TMPREGDESCAPTULTABONO(
		CuentaAhoID		BIGINT,
		FechaUltMov		DATE,
		MontoUltMov		DECIMAL(21,2),
		INDEX TMPREGDESCAPTULTABONO_idx1(CuentaAhoID));


	INSERT INTO TMPREGDESCAPTULTABONO
		SELECT	Mov.CuentaAhoID,
				IFNULL(MAX(Fecha), Fecha_Vacia),

				Decimal_Cero
			FROM `HIS-CUENAHOMOV` Mov,
				 TMPREGB0841 Tem
			WHERE Mov.CuentaAhoID = Tem.InstrumentoID
			  AND Mov.Fecha  <= Par_Fecha
			  AND Mov.ProgramaID != Prog_Cierre
			GROUP BY Mov.CuentaAhoID;

    UPDATE TMPREGDESCAPTULTABONO Tem, `HIS-CUENAHOMOV` His
    		SET  MontoUltMov = His.CantidadMov
    		WHERE Tem.CuentaAhoID = His.CuentaAhoID
    		AND His.Fecha = Tem.FechaUltMov;


	UPDATE TMPREGB0841 Tem, TMPREGDESCAPTULTABONO Mov SET
		Tem.FecUltMov = DATE_FORMAT(Mov.FechaUltMov,'%d%m%Y'),
		Tem.MontoUltMov = Mov.MontoUltMov
		WHERE Tem.InstrumentoID = Mov.CuentaAhoID;

	DROP TABLE IF EXISTS TMPREGDESCAPTULTABONO;

-- --------------------------------------------------------- --
	-- --------------------------------------
	-- SALDOS BLOQUEADOS POR GTI LIQUIDA ----
	-- --------------------------------------
	-- Saldo Actual
	DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;
	CREATE TEMPORARY TABLE TMP_GTIALIQ_AHORRO(
		Cuenta 	BIGINT,
		Saldo	DECIMAL(18,2),
		PRIMARY KEY(Cuenta));

	INSERT INTO TMP_GTIALIQ_AHORRO
		SELECT CuentaAhoID, SUM(CASE WHEN NatMovimiento = Nat_Bloqueo THEN  MontoBloq
									 ELSE MontoBloq *-1
								END) AS Saldo
		FROM BLOQUEOS
		WHERE DATE(FechaMov) <= Par_Fecha
		 AND TiposBloqID = Cons_BloqGarLiq
		GROUP BY CuentaAhoID;



  DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;
  CREATE TABLE TMP_GTIALIQ_AHORRO(
    Cuenta          BIGINT,
    Saldo                DECIMAL(18,2),
    FechaUltMov     DATE,
    MontoUltMov		DECIMAL(16,2),
    SaldoInicial    DECIMAL(18,2),
    Depositos       DECIMAL(18,2),
    Retiros         DECIMAL(18,2),
    PRIMARY KEY(Cuenta));


       INSERT INTO TMP_GTIALIQ_AHORRO
      SELECT CuentaAhoID, SUM(CASE WHEN NatMovimiento = 'B' THEN  MontoBloq
                   ELSE MontoBloq *-1
                END) AS Saldo,
               Max(date(FechaMov)) as UltMov,0 as MontoUltMov,
            SUM(CASE WHEN  NatMovimiento = 'B' AND DATE(FechaMov) < Var_FechIniPeriodo THEN MontoBloq
                          WHEN  NatMovimiento = 'D' AND DATE(FechaMov) < Var_FechIniPeriodo THEN MontoBloq * -1
                          ELSE 0 END ) AS InicialMes,
            SUM(CASE WHEN  NatMovimiento = 'B' AND DATE(FechaMov) >= Var_FechIniPeriodo THEN MontoBloq
                          ELSE 0 END ) AS Depositos,
               SUM(CASE WHEN  NatMovimiento = 'D' AND DATE(FechaMov) >= Var_FechIniPeriodo THEN MontoBloq
                          ELSE 0 END ) AS Retiros
    FROM BLOQUEOS
    WHERE DATE(FechaMov) <= Par_Fecha
     AND TiposBloqID = Cons_BloqGarLiq
    GROUP BY CuentaAhoID;

	update TMP_GTIALIQ_AHORRO aho,BLOQUEOS  blo
		set aho.MontoUltMov = blo.MontoBloq
	where aho.Cuenta = blo.CuentaAhoID
    and aho.FechaUltMov = DATE(blo.FechaMov);


  UPDATE TMPREGB0841 Tem, TMP_GTIALIQ_AHORRO Gar SET

    Tem.SaldoIniPer   =  Tem.SaldoIniPer - Gar.SaldoInicial,
    Tem.MtoDepositos  =  Tem.MtoDepositos +  Gar.Retiros,
    Tem.MtoRetiros    =  Tem.MtoRetiros  + Gar.Depositos,
    Tem.SaldoFinal    =  Tem.SaldoFinal - Gar.Saldo
    WHERE Tem.InstrumentoID = Gar.Cuenta;




   INSERT INTO TMPREGB0841
     SELECT
		 tem.ClienteID, 		tem.Nombre, 		tem.ApellidoPat, 	tem.ApellidoMat, 	tem.PersJuridica,
         tem.GradoRiesgo, 		tem.ActividadBmx, 	tem.ActividadEco, 	tem.Nacionalidad,	tem.FechaNac,
         tem.RFC, 				tem.CURP, 			tem.Genero, 		tem.Calle, 			tem.NumeroExt,
         tem.ColoniaID, 		tem.ColoniaDes, 	tem.CodigoPostal, 	tem.Localidad, 		tem.EstadoID,
         tem.EstadoClave, 		tem.MunicipioID, 	tem.MunicipioClave, tem.CodigoPais, 	tem.ClaveSucursal,
         tem.NumeroCuenta, 		tem.NumContrato, 	tem.TipoCliente,
         CASE WHEN tem.ClasfContable  = Dep_ConInteres THEN Dep_ConIntCre
							WHEN tem.ClasfContable  = Dep_SinInteres THEN Dep_SinIntCre
							WHEN tem.ClasfContable  = Dep_AhoLibGrav THEN Dep_AhoAmpCre
		 END,
         tem.ClasfBursatil,
         CASE WHEN tem.TipoInstrumento  = Dep_VisSnInt THEN Dep_VisSnIntCre
							WHEN tem.TipoInstrumento  = Dep_VisCnInt THEN Dep_VisIntCre
							WHEN tem.TipoInstrumento  = Dep_AhoInte THEN Dep_AhoCre
		 END,
         tem.ClaveAmpCed,
          tem.FechaApertura, 	tem.FechaDepoIni, 	tem.MontoDepoIniOri,
         tem.MontoDepoIniPes, 	tem.FechaDepoVenc, 	tem.PlazoAlVencimi, tem.RangoPlazo, 	tem.Periodicidad,
         tem.TipoTasa, 			tem.TasaInteres, 	tem.TasaPeriodo, 	tem.TasaReferencia, tem.DiferencialTasa,
         tem.OpeDiferencial, 	tem.Plazo, 			tem.Moneda, 		Gar.SaldoInicial, 	Gar.Depositos,
         Gar.Retiros, 			Entero_Cero, 		Gar.Saldo, 			0, 					0,
         Gar.FechaUltMov, 		Gar.MontoUltMov, 	Gar.SaldoInicial, 		tem.RetiroAnt, 		0,
         0, 					100, 				tem.InstrumentoID, 	tem.NumDias, 		tem.SaldoFinInv,
         tem.FechaAper, 		tem.ClaveAmpCed
    FROM TMPREGB0841 tem, TMP_GTIALIQ_AHORRO Gar
    WHERE  tem.InstrumentoID = Gar.Cuenta;


  DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;




  SET Var_FechaHis := (SELECT MAX(FechaCorte)
              FROM HISINVERSIONES WHERE FechaCorte <= Par_Fecha);

  SET Var_FechaHis := IFNULL(Var_FechaHis, Fecha_Vacia);

  SET Var_FechaHisAnt := (SELECT MAX(FechaCorte)
              FROM HISINVERSIONES WHERE FechaCorte <= Var_IniMes );



set Var_FechaRepAnt := Var_FechaHisAnt;
  set Var_FechaIniRepAnt := date_sub(Var_FechaRepAnt, INTERVAL  3 month);
  set Var_FechaIniRepAnt := last_day(Var_FechaIniRepAnt);
  SET Var_FechaIniRepAnt  := date_add(Var_FechaIniRepAnt, interval 1 day);

	-- -----------------------------------------
	-- INVERSIONES A PLAZO ---------------------
	-- -----------------------------------------


	INSERT INTO TMPREGB0841

				-- Cliente ID
		SELECT	Inv.ClienteID,
				-- Nombre / Razon Social
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						SUBSTRING(CONCAT(IFNULL(PrimerNombre, Cadena_Vacia),
									CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(" ", SegundoNombre) ELSE Cadena_Vacia
									END,
									CASE WHEN IFNULL(TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(" ", TercerNombre) ELSE Cadena_Vacia
									END),  1, 200)
					 ELSE UPPER(Cli.RazonSocial)
				END,

				-- Apellido Paterno
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						    CASE WHEN IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = Cadena_Vacia
									OR IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
								UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END ,

				-- Apellido Materno
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
                           CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END,

				-- Personalidad Juridica
				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
					 END,
				-- Grado de Riesgo
				CASE WHEN Cli.NivelRiesgo = Riesgo_Alto THEN Clave_RiesAlto
					 WHEN Cli.NivelRiesgo = Riesgo_Medio THEN Clave_RiesMedio
					 WHEN Cli.NivelRiesgo = Riesgo_Bajo THEN Clave_RiesBajo
					 END,
				-- Actividad Economica
				Cli.ActividadBancoMX,
				Cadena_Vacia,
				-- Pais de Nacimiento
				Cli.LugarNacimiento,
				-- Fecha de Nacimiento
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						DATE_FORMAT(Cli.FechaNacimiento ,'%d%m%Y')
					 ELSE
						DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%d%m%Y')
					END,
				-- RFC
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.RFCOficial
					 ELSE CONCAT("_", IFNULL(Cli.RFCOficial,Cadena_Vacia))
				END,
				-- CURP
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.CURP
					 ELSE Cadena_Cero
				END,
				-- Genero
				CASE WHEN Cli.TipoPersona = Moral THEN Per_NoAplica
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Masculino THEN Per_Masculino
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Femenino THEN Per_Femenino
				END,
				-- Calle
				IFNULL(Dir.Calle,Cadena_Vacia),
				-- Numero Ext
				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),
				-- Colonia ID
				IFNULL(Dir.ColoniaID,Entero_Cero),
				Cadena_Vacia,
				-- Codigo Postal
				IFNULL(Dir.CP,Entero_Cero),
				-- Localidad
				IFNULL(Dir.LocalidadID, Entero_Cero),
				-- Estado
				IFNULL(Dir.EstadoID, Entero_Cero),
				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,
				-- Municipio
				IFNULL(Dir.MunicipioID, Entero_Cero),
				Cadena_Vacia AS MunicipioClave,
				-- Pais
				Codigo_Mexico,
				-- Sucursal
				IFNULL(Suc.ClaveSucOpeCred,Cadena_Vacia),

				-- Numero Cuenta
				Inv.CuentaAhoID,

				-- Numero Contrato
				Inv.InversionID,

				-- Tipo Cliente
				Clave_Ahorrador,

				-- Clasificacion contable
				Dep_PlaLibGrav,

				-- Clasificacion Bursatil
				Clave_CertBursatil,

				-- Tipo de Producto
                Dep_Plazo AS TipoProducto,
				Cat.ClaveCNBV,

				-- Fecha Contratacion
				IFNULL(DATE_FORMAT(Inv.FechaInicio ,'%d%m%Y'),Fecha_Nula),

				-- Fecha Inicial
                IFNULL(DATE_FORMAT(Inv.FechaInicio ,'%d%m%Y'),Fecha_Nula),

				-- Monto deposito inicial
                IFNULL(Inv.Monto,Decimal_Cero),

				-- Monto en Pesos inicial
                IFNULL(Inv.Monto,Decimal_Cero),

				-- Fecha Vencimiento del Deposito
                IFNULL(DATE_FORMAT(Inv.FechaVencimiento ,'%d%m%Y'),Fecha_Nula),


				-- Plazo al Vencimiento
				Inv.Plazo,

				-- Rango de plazo
				CASE WHEN Inv.Plazo BETWEEN 1 AND 7 THEN Rango_Uno
					 WHEN Inv.Plazo BETWEEN 8 AND 30 THEN Rango_Dos
					 WHEN Inv.Plazo BETWEEN 31 AND 90 THEN Rango_Tres
					 WHEN Inv.Plazo BETWEEN 91 AND 180 THEN Rango_Cuatro
					 WHEN Inv.Plazo BETWEEN 181 AND 365 THEN Rango_Cinco
					 WHEN Inv.Plazo BETWEEN 366 AND 730 THEN Rango_Seis
					 WHEN Inv.Plazo > 730 THEN Rango_Siete END,

				-- Periodicidad
				Clave_PerOtro,
				-- Tipo de tasa
				Clave_TipoTasa,
				-- Valor Tasa
				ROUND(Inv.Tasa,6),
				-- Valor Periodo Tasa
				ROUND(Inv.Tasa,6),
				-- Tasa de Refencia
				Clave_TasaRefe,
				-- Diferencias sobre tasa
				Entero_Cero,
				-- Operacion Diferencial
				Clave_OpeDiferen,
				-- Frecuencia Revision Tasa
				Entero_Cero,

				-- Tipo de Moneda
				Mon.MonedaCNBV,

				-- Saldo Cuenta Inicio Periodo
                CASE WHEN  Inv.FechaInicio < Var_IniMes THEN Inv.Monto
                ELSE Decimal_Cero END,

				-- Importe Depositos
                CASE WHEN  Inv.FechaInicio BETWEEN Var_IniMes AND Par_Fecha THEN Inv.Monto
                ELSE Decimal_Cero END,

				-- Importe Retiros

                CASE WHEN Inv.Estatus IN (Est_Pagado,Est_Cancelado) AND Inv.FechaVencimiento BETWEEN Var_IniMes AND Par_Fecha  THEN (Inv.Monto + Inv.SaldoProvision)
                ELSE Decimal_Cero END,

				-- INT. devengados no pagados
                CASE WHEN Inv.Estatus IN (Est_Pagado,Est_Cancelado)  THEN Decimal_Cero
						ELSE Inv.SaldoProvision  END AS IntDevNoPago,

				-- Saldo Cuenta al Final del Periodo
                CASE WHEN Inv.Estatus IN(Est_Pagado,Est_Cancelado) THEN Decimal_Cero ELSE
				(Inv.Monto + Inv.SaldoProvision) END AS SaldoFinal,

				-- Intereses del mes
               	CASE WHEN  Inv.Estatus IN (Est_Pagado,Est_Cancelado) THEN
				Inv.SaldoProvision ELSE Decimal_Cero END,

				-- Comisiones del mes
				Entero_Cero,

				-- Fecha ultimo Movimiento
                 CASE WHEN Inv.Estatus = Est_Pagado THEN
					IFNULL(DATE_FORMAT(Inv.FechaVencimiento,'%d%m%Y'),Fecha_Nula)
                     WHEN Inv.Estatus = Est_Cancelado THEN
					IFNULL(DATE_FORMAT(Inv.FechaVenAnt,'%d%m%Y'),Fecha_Nula)
				 ELSE
				IFNULL(DATE_FORMAT(Inv.FechaInicio,'%d%m%Y'),Fecha_Nula) END  AS FecUltMov,

				-- Monto Ultimo Movimiento
                  CASE WHEN Inv.Estatus IN(Est_Pagado,Est_Cancelado) THEN (Inv.Monto + Inv.SaldoProvision)
							ELSE Inv.Monto END AS SaldoFinal,

				-- Saldo promedio
				Decimal_Cero,

				-- Retiro Anticipado
				CASE WHEN Inv.Estatus = Est_Cancelado AND Inv.FechaVenAnt <= Par_Fecha THEN Si_RetAntici
					 ELSE No_RetAntici END,

				-- Monto Fondo de Proteccion
				Entero_Cero,

				-- Porcentaje Fondo Pro
				Decimal_Cero,

				-- Porcentaje Garantia
				Decimal_Cero,


				Inv.InversionID,

                -- Num Dias
                CASE WHEN Inv.Estatus = Est_Pagado THEN
						(DATEDIFF(Inv.FechaVencimiento, CASE WHEN  Inv.FechaInicio >= Var_IniMes THEN Inv.FechaInicio ELSE  Var_IniMes END) + 1 )
					 WHEN Inv.Estatus = Est_Cancelado THEN
						(DATEDIFF(Inv.FechaVenAnt, CASE WHEN  Inv.FechaInicio >= Var_IniMes THEN Inv.FechaInicio ELSE  Var_IniMes END ) + 1 )
					ELSE
						(DATEDIFF(Par_Fecha, CASE WHEN  Inv.FechaInicio >= Var_IniMes THEN Inv.FechaInicio ELSE  Var_IniMes END ) + 1 ) END,

				-- Slado total
                (Inv.Monto + Inv.SaldoProvision),

                Inv.FechaInicio,

                Cat.ClaveCNBVAmpCred

		FROM HISINVERSIONES Inv,
			  CATINVERSION Cat,
              MONEDAS Mon,
			 SUCURSALES Suc,
			 CLIENTES Cli

		LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, Con_NO) = SI

		WHERE  Inv.ClienteID = Cli.ClienteID
          AND  Inv.ClienteID <> Cliente_Inst
          AND Inv.MonedaID = Mon.MonedaId
		  AND  Inv.FechaCorte  = Var_FechaCieInv
          AND 	(Inv.Estatus = Con_NO OR
				( Inv.Estatus = Est_Pagado AND Inv.FechaVencimiento BETWEEN Var_IniMes AND Var_FechaCieInv)
                OR
                ( Inv.Estatus =  Est_Cancelado AND Inv.FechaVenAnt BETWEEN Var_IniMes AND Var_FechaCieInv )
                )
          AND Inv.TipoInversionID = Cat.TipoInversionID
		  AND Cli.SucursalOrigen = Suc.SucursalID
		ORDER BY Suc.SucursalID, Inv.InversionID;




	-- --------------------------------------
	-- SALDO INICIAL MES
	-- --------------------------------------
    DROP TABLE IF EXISTS TMP_SALDOINVER;
    CREATE TEMPORARY TABLE TMP_SALDOINVER
    SELECT InversionID,(Monto+SaldoProvision) AS SaldoFinal,SaldoProvision FROM HISINVERSIONES
	WHERE FechaCorte = Var_FecMesAnt;

    CREATE INDEX idx_TMP_SALDOINVER_1 ON TMP_SALDOINVER(InversionID);

    UPDATE TMPREGB0841 Inv, TMP_SALDOINVER Tem
		SET Inv.SaldoIniPer = Tem.SaldoFinal


	WHERE Inv.InstrumentoID = Tem.InversionID
     AND Inv.TipoInstrumento = Dep_Plazo;


        -- --------------------------------------
	-- SALDO Promedio Inversion MES
	-- --------------------------------------
        UPDATE TMPREGB0841 Inv, TMP_FACTSALDO Tem
			SET Inv.SaldoProm = (( (((Inv.InteresMes / Inv.NumDias)* Tem.NumFactor) +
									(Inv.NumDias * CASE WHEN Inv.SaldoIniPer = Decimal_Cero THEN Inv.MontoDepoIniPes ELSE Inv.SaldoIniPer END))
				  ) / (DATEDIFF(Par_Fecha, Var_IniMes)+1))
		WHERE (Inv.NumDias-1) = Tem.NumDias
        AND Inv.TipoInstrumento = Dep_Plazo;



        UPDATE TMPREGB0841 Inv
		SET	Inv.MontoFondPro   =  CASE WHEN Inv.SaldoFinal = Decimal_Cero THEN Decimal_Cero
								   WHEN Inv.SaldoFinal <= Var_MtoFondoPro THEN Inv.SaldoFinal
                                   ELSE Var_MtoFondoPro END,
			Inv.PorcFondoPro   = CASE WHEN Inv.SaldoFinal = Decimal_Cero THEN Decimal_Cero
								   WHEN Inv.SaldoFinal <= Var_MtoFondoPro THEN Var_Cien
								   ELSE (ROUND(Var_MtoFondoPro/Inv.SaldoFinal,6)*100) END

			;

	-- --------------------------------------
	-- INVERSIONES EN GARANTIA
	-- --------------------------------------
	DROP TABLE IF EXISTS TMP_INVGAR;
	CREATE TABLE TMP_INVGAR (
		InversionID	BIGINT,
		Saldo       DECIMAL(21,2));
	CREATE INDEX idx1_TMP_INVGAR ON TMP_INVGAR (InversionID);


	INSERT INTO TMP_INVGAR
		SELECT Gar.InversionID,Gar.MontoEnGar
			FROM CREDITOINVGAR Gar
			WHERE FechaAsignaGar <= Par_Fecha;


	INSERT INTO TMP_INVGAR
		SELECT Gar.InversionID, Gar.MontoEnGar
			FROM HISCREDITOINVGAR Gar
			WHERE Gar.Fecha > Par_Fecha
			  AND Gar.FechaAsignaGar <= Par_Fecha
			  AND Gar.ProgramaID NOT IN ('CIERREGENERALPRO');


	DROP TABLE IF EXISTS TMP_INVGAR;










  DROP TABLE IF EXISTS TMP_INVGAR;

  CREATE TABLE TMP_INVGAR (
    InversionID BIGINT,
    MontoEnGar  decimal(16,2),
    FechaMov   DATE,
    CreditoID BIGINT
);

DROP TABLE IF EXISTS TMP_INVGAR_ANT;

  CREATE TABLE TMP_INVGAR_ANT (
    InversionID BIGINT,
    MontoEnGar  decimal(16,2),
    FechaMov   DATE,
    CreditoID BIGINT
    );


CREATE INDEX idx1_TMP_INVGAR ON TMP_INVGAR (InversionID);
CREATE INDEX idx2_TMP_INVGAR ON TMP_INVGAR (CreditoID);


CREATE INDEX idx1_TMP_INVGAR_ANT ON TMP_INVGAR_ANT (InversionID);
CREATE INDEX idx2_TMP_INVGAR_ANT ON TMP_INVGAR_ANT (CreditoID);


  INSERT INTO TMP_INVGAR
    SELECT Gar.InversionID, Gar.MontoEnGar, Gar.FechaAsignaGar,Gar.CreditoID
      FROM CREDITOINVGAR Gar, SALDOSCREDITOS Sal, INVERSIONES inv
       where FechaAsignaGar <= Par_Fecha
       and Gar.CreditoID = Sal.CreditoID
       and Gar.InversionID = inv.InversionID
       and Sal.FechaCorte = Par_Fecha
       and inv.FechaInicio <= Par_Fecha
       and Sal.EstatusCredito in ('V','B');

  INSERT INTO TMP_INVGAR
    SELECT Gar.InversionID,Gar.MontoEnGar,
				Gar.FechaAsignaGar
                ,Gar.CreditoID
      FROM HISCREDITOINVGAR Gar, SALDOSCREDITOS Sal,INVERSIONES inv
      where Gar.Fecha >= Par_Fecha
        AND Gar.FechaAsignaGar <= Par_Fecha
        and Gar.CreditoID = Sal.CreditoID
        and Gar.InversionID = inv.InversionID
       and Sal.FechaCorte = Par_Fecha
       and inv.FechaInicio <= Par_Fecha
       and Sal.EstatusCredito in ('V','B');



   DROP TABLE IF EXISTS TMP_INVGAR_SAL;

  CREATE TABLE TMP_INVGAR_SAL (
    InversionID BIGINT,
    MontoEnGar  decimal(16,2),
    FechaMov   DATE,
    MontoUltMov Decimal(16,2),
    SaldoInicial DECIMAL(16,2),
    Depositos   DECIMAL(16,2),
    Retiros          DECIMAL(16,2)
    );

    INSERT INTO TMP_INVGAR_SAL
    select Gar.InversionID, sum(Gar.MontoEnGar) as Saldo,
    max(Gar.FechaMov) as UltMov, 0 as MontoUltMov,
    0 as SaldoInicial,
    0 as Depositos,
     Entero_Cero as Retiros
    FROM TMP_INVGAR Gar, INVERSIONES Inv
    where Gar.InversionID = Inv.InversionID
    group by InversionID;


  INSERT INTO TMP_INVGAR_ANT
    SELECT Gar.InversionID, Gar.MontoEnGar, Gar.FechaAsignaGar,Gar.CreditoID
      FROM CREDITOINVGAR Gar, SALDOSCREDITOS Sal,INVERSIONES inv
       where FechaAsignaGar <= Var_FechaRepAnt
       and Gar.CreditoID = Sal.CreditoID
       and Sal.FechaCorte = Var_FechaRepAnt
       and Gar.InversionID = inv.InversionID
       and inv.FechaInicio <= Var_FechaRepAnt
       and Sal.EstatusCredito in ('V','B');

  INSERT INTO TMP_INVGAR_ANT
    SELECT Gar.InversionID,Gar.MontoEnGar, Gar.FechaAsignaGar,Gar.CreditoID
      FROM HISCREDITOINVGAR Gar, SALDOSCREDITOS Sal,INVERSIONES inv
      where Gar.Fecha >= Var_FechaRepAnt
        AND Gar.FechaAsignaGar <= Var_FechaRepAnt
        and Gar.CreditoID = Sal.CreditoID
       and Sal.FechaCorte = Var_FechaRepAnt
        and Gar.InversionID = inv.InversionID
       and inv.FechaInicio <= Var_FechaRepAnt
       and Sal.EstatusCredito in ('V','B');


   DROP TABLE IF EXISTS TMP_INVGAR_SAL_ANT;

  CREATE TABLE TMP_INVGAR_SAL_ANT (
    InversionID BIGINT,
    MontoEnGar  decimal(16,2),
    FechaMov   DATE,
    SaldoInicial DECIMAL(16,2),
    Depositos   DECIMAL(16,2),
    Retiros          DECIMAL(16,2)
    );

    INSERT INTO TMP_INVGAR_SAL_ANT
    select Gar.InversionID, sum(Gar.MontoEnGar) as Saldo,
    max(Gar.FechaMov) as UltMov,
    sum( case when Gar.FechaMov < Var_FechaIniRepAnt AND Inv.FechaInicio <= Var_FechaIniRepAnt then Gar.MontoEnGar
              when Gar.FechaMov < Var_FechaIniRepAnt AND Inv.FechaInicio >  Var_FechaIniRepAnt then 0
               else 0 end) as SaldoInicial,
    sum( case when Gar.FechaMov >= Var_FechaIniRepAnt then Gar.MontoEnGar
               when Gar.FechaMov < Var_FechaIniRepAnt AND Inv.FechaInicio > Var_FechaIniRepAnt then Gar.MontoEnGar
               else 0 end) as Depositos,
     Entero_Cero as Retiros
    FROM TMP_INVGAR_ANT Gar, INVERSIONES Inv
    where Gar.InversionID = Inv.InversionID
    group by InversionID;


	update TMP_INVGAR_SAL sal, TMP_INVGAR_SAL_ANT ant
        set sal.SaldoInicial = ant.MontoEnGar,
            sal.Depositos = case when sal.MontoEnGar - ant.MontoEnGar > 0 then sal.MontoEnGar - ant.MontoEnGar else 0 end,
            sal.Retiros = case when sal.MontoEnGar - ant.MontoEnGar < 0 then ant.MontoEnGar - sal.MontoEnGar else 0 end
    where sal.InversionID = ant.InversionID;

    update TMP_INVGAR_SAL
    set  Depositos = MontoEnGar
    where SaldoInicial = 0
    and Depositos = 0
    and Retiros = 0
    and MontoEnGar > 0;


    insert into TMP_INVGAR_SAL
    select InversionID,0 as Monto,FechaMov as FechaMov, 0 as UltiMov,
           MontoEnGar as SaldoInicial, 0 as Depositos,
           MontoEnGar as Retiros
     from TMP_INVGAR_SAL_ANT
    where InversionID not in
    (select InversionID from TMP_INVGAR_SAL);


  update TMP_INVGAR_SAL tem, CREDITOINVGAR inv
	set tem.MontoUltMov = inv.MontoEnGar
  where tem.InversionID = inv.InversionID
  and tem.FechaMov = inv.FechaAsignaGar;

    update TMP_INVGAR_SAL tem, HISCREDITOINVGAR inv
	set tem.MontoUltMov = inv.MontoEnGar,
		tem.FechaMov = case when inv.Fecha >= Var_FechaIniRepAnt then inv.Fecha else tem.FechaMov end
  where tem.InversionID = inv.InversionID
  and  tem.FechaMov = inv.FechaAsignaGar;



  UPDATE TMPREGB0841 Tem, TMP_INVGAR_SAL Gar SET

        Tem.SaldoIniPer   =  Tem.SaldoIniPer - Gar.SaldoInicial,
          Tem.MtoDepositos  =  Tem.MtoDepositos + Gar.Retiros,
          Tem.MtoRetiros    =  Tem.MtoRetiros  + Gar.Depositos,
          Tem.SaldoFinal    =  Tem.SaldoFinal - Gar.MontoEnGar
    WHERE Tem.InstrumentoID = Gar.InversionID
      AND Tem.TipoInstrumento = Dep_Plazo;


   INSERT INTO TMPREGB0841
     SELECT

		tem.ClienteID, 		tem.Nombre, 		tem.ApellidoPat, 	tem.ApellidoMat, 	tem.PersJuridica,
         tem.GradoRiesgo, 		tem.ActividadBmx, 	tem.ActividadEco, 	tem.Nacionalidad,	tem.FechaNac,
         tem.RFC, 				tem.CURP, 			tem.Genero, 		tem.Calle, 			tem.NumeroExt,
         tem.ColoniaID, 		tem.ColoniaDes, 	tem.CodigoPostal, 	tem.Localidad, 		tem.EstadoID,
         tem.EstadoClave, 		tem.MunicipioID, 	tem.MunicipioClave, tem.CodigoPais, 	tem.ClaveSucursal,
         tem.NumeroCuenta, 		tem.NumContrato, 	tem.TipoCliente,
         CASE WHEN tem.TipoInstrumento  = Dep_Plazo THEN Dep_PlaLibAmpCre
					   ELSE tem.ClasfContable END,
         tem.ClasfBursatil,
         CASE WHEN tem.TipoInstrumento  = Dep_Plazo THEN Dep_PlazoAmpCre
					   ELSE tem.TipoInstrumento END,
         tem.ClaveAmpCed,

         tem.FechaApertura, 	tem.FechaDepoIni, 	tem.MontoDepoIniOri,
         tem.MontoDepoIniPes, 	tem.FechaDepoVenc, 	tem.PlazoAlVencimi, tem.RangoPlazo, 	tem.Periodicidad,
         tem.TipoTasa, 			tem.TasaInteres, 	tem.TasaPeriodo, 	tem.TasaReferencia, tem.DiferencialTasa,
         tem.OpeDiferencial, 	tem.Plazo, 			tem.Moneda, 		Gar.SaldoInicial, 	Gar.Depositos,
         Gar.Retiros, 			Entero_Cero, 		Gar.MontoEnGar, 		Entero_Cero, 		Entero_Cero,
         REPLACE(CONVERT(Gar.FechaMov, CHAR),'-',Cadena_Vacia), 	Gar.MontoUltMov, 	Gar.SaldoInicial, 		No_RetAntici, 		 0,
          0, 		 100, 	tem.InstrumentoID, 	tem.NumDias, 		tem.SaldoFinInv,
         tem.FechaAper, 		tem.ClaveAmpCed
    FROM TMPREGB0841 tem, TMP_INVGAR_SAL Gar
    WHERE tem.InstrumentoID = Gar.InversionID
      AND tem.TipoInstrumento = Dep_Plazo;


  DROP TABLE IF EXISTS TMP_INVGAR;







	-- -----------------------------------------
	-- CEDES---------------------
	-- -----------------------------------------


	INSERT INTO TMPREGB0841

				-- Cliente ID
		SELECT	Ced.ClienteID,
				-- Nombre / Razon Social
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						SUBSTRING(CONCAT(IFNULL(PrimerNombre, Cadena_Vacia),
									CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(" ", SegundoNombre) ELSE Cadena_Vacia
									END,
									CASE WHEN IFNULL(TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(" ", TercerNombre) ELSE Cadena_Vacia
									END),  1, 200)
					 ELSE UPPER(Cli.RazonSocial)
				END,

				-- Apellido Paterno
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						    CASE WHEN IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = Cadena_Vacia
									OR IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
								UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END ,

				-- Apellido Materno
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
                           CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END,

				-- Personalidad Juridica
				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
					 END,
				-- Grado de Riesgo
				CASE WHEN Cli.NivelRiesgo = Riesgo_Alto THEN Clave_RiesAlto
					 WHEN Cli.NivelRiesgo = Riesgo_Medio THEN Clave_RiesMedio
					 WHEN Cli.NivelRiesgo = Riesgo_Bajo THEN Clave_RiesBajo
					 END,
				-- Actividad Economica
				Cli.ActividadBancoMX,
				Cadena_Vacia,
				-- Pais de Nacimiento
				Cli.LugarNacimiento,
				-- Fecha de Nacimiento
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						DATE_FORMAT(Cli.FechaNacimiento ,'%d%m%Y')
					 ELSE
						DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%d%m%Y')
					END,
				-- RFC
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.RFCOficial
					 ELSE CONCAT("_", IFNULL(Cli.RFCOficial,Cadena_Vacia))
				END,
				-- CURP
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.CURP
					 ELSE Cadena_Cero
				END,
				-- Genero
				CASE WHEN Cli.TipoPersona = Moral THEN Per_NoAplica
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Masculino THEN Per_Masculino
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Femenino THEN Per_Femenino
				END,
				-- Calle
				IFNULL(Dir.Calle,Cadena_Vacia),
				-- Numero Ext
				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),
				-- Colonia ID
				IFNULL(Dir.ColoniaID,Entero_Cero),
				Cadena_Vacia,
				-- Codigo Postal
				IFNULL(Dir.CP,Entero_Cero),
				-- Localidad
				IFNULL(Dir.LocalidadID, Entero_Cero),
				-- Estado
				IFNULL(Dir.EstadoID, Entero_Cero),
				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,
				-- Municipio
				IFNULL(Dir.MunicipioID, Entero_Cero),
				Cadena_Vacia AS MunicipioClave,
				-- Pais
				Codigo_Mexico,
				-- Sucursal
				IFNULL(Suc.ClaveSucOpeCred,Cadena_Vacia),

				-- Numero Cuenta
				Ced.CuentaAhoID,

				-- Numero Contrato
				Ced.CedeID,

				-- Tipo Cliente
				Clave_Ahorrador,

				-- Clasificacion contable
				Dep_RetLibGrav,

				-- Clasificacion Bursatil
				Clave_CertBursatil,

				-- Tipo de Producto
                Dep_Cedes AS TipoProducto,
				Cat.ClaveCNBV,

				-- Fecha Contratacion
				IFNULL(DATE_FORMAT(Ced.FechaInicio ,'%d%m%Y'),Fecha_Nula),

				-- Fecha Inicial
                IFNULL(DATE_FORMAT(Ced.FechaInicio ,'%d%m%Y'),Fecha_Nula),

				-- Monto deposito inicial
                IFNULL(Ced.Monto,Decimal_Cero),

				-- Monto en Pesos inicial
                IFNULL(Ced.Monto,Decimal_Cero),

				-- Fecha Vencimiento del Deposito
                IFNULL(DATE_FORMAT(Ced.FechaVencimiento ,'%d%m%Y'),Fecha_Nula),


				-- Plazo al Vencimiento
				Ced.Plazo,

				-- Rango de plazo
				CASE WHEN Ced.Plazo BETWEEN 1 AND 7 THEN Rango_Uno
					 WHEN Ced.Plazo BETWEEN 8 AND 30 THEN Rango_Dos
					 WHEN Ced.Plazo BETWEEN 31 AND 90 THEN Rango_Tres
					 WHEN Ced.Plazo BETWEEN 91 AND 180 THEN Rango_Cuatro
					 WHEN Ced.Plazo BETWEEN 181 AND 365 THEN Rango_Cinco
					 WHEN Ced.Plazo BETWEEN 366 AND 730 THEN Rango_Seis
					 WHEN Ced.Plazo > 730 THEN Rango_Siete END,

				-- Periodicidad
				Clave_PerOtro,
				-- Tipo de tasa
				Clave_TipoTasa,
				-- Valor Tasa
				ROUND(Ced.TasaFija,6),
				-- Valor Periodo Tasa
				ROUND(Ced.TasaFija,6),
				-- Tasa de Refencia
				Clave_TasaRefe,
				-- Diferencias sobre tasa
				Entero_Cero,
				-- Operacion Diferencial
				Clave_OpeDiferen,
				-- Frecuencia Revision Tasa
				Entero_Cero,

				-- Tipo de Moneda
				Mon.MonedaCNBV,

				-- Saldo Cuenta Inicio Periodo
                CASE WHEN  Ced.FechaInicio < Var_IniMes THEN Ced.Monto
                ELSE Decimal_Cero END,

				-- Importe Depositos
                CASE WHEN  Ced.FechaInicio BETWEEN Var_IniMes AND Par_Fecha THEN Ced.Monto
                ELSE Decimal_Cero END,

				-- Importe Retiros

                CASE WHEN Ced.Estatus IN (Est_Pagado,Est_Cancelado) AND Ced.FechaVencimiento BETWEEN Var_IniMes AND Par_Fecha  THEN (Ced.Monto + Ced.SaldoProvision)
                ELSE Decimal_Cero END,

				-- INT. devengados no pagados
                Decimal_Cero AS IntDevNoPago,

				-- Saldo Cuenta al Final del Periodo
                IFNULL(Sal.SaldoCapital,Decimal_Cero),

				-- Intereses del mes
               Decimal_Cero ,

				-- Comisiones del mes
				Entero_Cero,

				-- Fecha ultimo Movimiento
                CASE WHEN Ced.Estatus = Est_Pagado THEN
					IFNULL(DATE_FORMAT(Ced.FechaVencimiento,'%d%m%Y'),Fecha_Nula)
                     WHEN Ced.Estatus = Est_Cancelado THEN
					IFNULL(DATE_FORMAT(Ced.FechaVenAnt,'%d%m%Y'),Fecha_Nula)
				 ELSE
				IFNULL(DATE_FORMAT(Ced.FechaInicio,'%d%m%Y'),Fecha_Nula) END  AS FecUltMov,

				-- Monto Ultimo Movimiento
                CASE WHEN Ced.Estatus IN(Est_Pagado,Est_Cancelado) THEN (Ced.Monto + Ced.SaldoProvision)
							ELSE Ced.Monto END AS SaldoFinal,

				-- Saldo promedio
				Decimal_Cero,

				-- Retiro Anticipado
				CASE WHEN Ced.Estatus = Est_Cancelado AND Ced.FechaVenAnt <= Par_Fecha THEN Si_RetAntici
					 ELSE No_RetAntici END,

				-- Monto Fondo de Proteccion
				Entero_Cero,

				-- Porcentaje Fondo Pro
				Decimal_Cero,

				-- Porcentaje Garantia
				Decimal_Cero,


				Ced.CedeID,

                -- Num Dias
                CASE WHEN Ced.Estatus = Est_Pagado THEN
						(DATEDIFF(Ced.FechaVencimiento, CASE WHEN  Ced.FechaInicio >= Var_IniMes THEN Ced.FechaInicio ELSE  Var_IniMes END) + 1 )
					 WHEN Ced.Estatus = Est_Cancelado THEN
						(DATEDIFF(Ced.FechaVenAnt, CASE WHEN  Ced.FechaInicio >= Var_IniMes THEN Ced.FechaInicio ELSE  Var_IniMes END ) + 1 )
					ELSE
						(DATEDIFF(Par_Fecha, CASE WHEN  Ced.FechaInicio >= Var_IniMes THEN Ced.FechaInicio ELSE  Var_IniMes END ) + 1 ) END,

				-- Slado total
                IFNULL(Sal.SaldoCapital,Decimal_Cero),

                Ced.FechaInicio,

                Cat.ClaveCNBVAmpCred

		FROM CEDES Ced
		LEFT OUTER JOIN SALDOSCEDES Sal ON Ced.CedeID = Sal.CedeID AND Sal.FechaCorte = Var_FechaCieCed,
			 TIPOSCEDES Cat,
             MONEDAS Mon,
			 SUCURSALES Suc,
			 CLIENTES Cli
		LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, Con_NO) = SI
		WHERE  Ced.ClienteID = Cli.ClienteID
          AND  Ced.ClienteID <> Cliente_Inst
          AND  Ced.MonedaID = Mon.MonedaId
          AND (	(Ced.Estatus = Con_NO AND FechaInicio <=Var_FechaCieCed) OR
				( Ced.Estatus = Est_Pagado AND Ced.FechaVencimiento >= Var_IniMes)
                OR
                ( Ced.Estatus =  Est_Cancelado AND Ced.FechaVenAnt >= Var_IniMes )
                )
          AND Ced.TipoCedeID = Cat.TipoCedeID
		  AND Cli.SucursalOrigen = Suc.SucursalID
		ORDER BY Suc.SucursalID, Ced.TipoCedeID;



    update TMPREGB0841 Reg,CEDES Ced set
		SaldoFinal=0
	where Reg.InstrumentoID=Ced.CedeID
    and Ced.Estatus='P'
    and Ced.FechaVencimiento=LAST_DAY(Par_Fecha);


	drop table if exists TMP_CARGOABONOCEDE;
	create temporary table TMP_CARGOABONOCEDE
	SELECT CedeID, sum(Case when NatMovimiento = 'A' then Monto else 0 end) as InteresPagado,
	sum(Case when NatMovimiento = 'C' then Monto else 0 end) as InteresProvisionado
	 FROM CEDESMOV where CedeID in(
		select CedeID from SALDOSCEDES where FechaCorte = Var_FecMesAnt
	 ) and Fecha <= Var_FecMesAnt
	 group by CedeID;

	UPDATE TMPREGB0841 Ced,TMP_CARGOABONOCEDE Res
		SET Ced.SaldoIniPer = Ced.SaldoIniPer + (Res.InteresProvisionado - Res.InteresPagado)
	where Ced.InstrumentoID = Res.CedeID
    and Ced.TipoInstrumento = Dep_Cedes;





	drop table if exists TMP_CARGOABONOCEDE;
	create temporary table TMP_CARGOABONOCEDE
	SELECT CedeID, sum(Case when NatMovimiento = 'A' then Monto else 0 end) as InteresPagado,
	sum(Case when NatMovimiento = 'C' then Monto else 0 end) as InteresProvisionado
	 FROM CEDESMOV where CedeID in(
		select CedeID from SALDOSCEDES where FechaCorte = Var_FechaCieCed
	 ) and Fecha <= Var_FechaCieCed
	 group by CedeID;


	UPDATE TMPREGB0841 Ced,TMP_CARGOABONOCEDE Res
		SET Ced.IntDevNoPago = Res.InteresProvisionado - Res.InteresPagado,
			Ced.SaldoFinal = Ced.SaldoFinal + (Res.InteresProvisionado - Res.InteresPagado)
	where Ced.InstrumentoID = Res.CedeID
    and Ced.TipoInstrumento = Dep_Cedes;




	drop table if exists TMP_CARGOABONOCEDE;
	create temporary table TMP_CARGOABONOCEDE
	SELECT CedeID, sum(Case when NatMovimiento = 'A' then Monto else 0 end) as InteresPagado,
	sum(Case when NatMovimiento = 'C' then Monto else 0 end) as InteresProvisionado
	 FROM CEDESMOV where CedeID in(
		select InstrumentoID from TMPREGB0841 where TipoInstrumento = Dep_Cedes
	 ) and Fecha between Var_IniMes and Var_FechaCieCed
	 group by CedeID;


	UPDATE TMPREGB0841 Ced,TMP_CARGOABONOCEDE Res
		SET Ced.InteresMes = Res.InteresPagado,

			Ced.MtoRetiros = case when Ced.SaldoFinal = 0 then  Ced.SaldoIniPer +  Res.InteresPagado else 0 end
	where Ced.InstrumentoID = Res.CedeID
    and Ced.TipoInstrumento = Dep_Cedes;

    if Var_FechaCieCed <= '2018-04-30' then
		UPDATE TMPREGB0841 Ced,TMP_SALDOCEDEINICIAL Res
			SET Ced.SaldoFinal = Ced.SaldoFinal + Res.MontoAjuste,
				Ced.SaldoIniPer = Ced.SaldoIniPer +  Res.MontoAjuste,
                Ced.IntDevNoPago = Ced.IntDevNoPago +  Res.MontoAjuste
		where Ced.InstrumentoID = Res.CedeID
		and Ced.TipoInstrumento = Dep_Cedes;
	end if;


    UPDATE TMPREGB0841 Ced
		SET Ced.IntDevNoPago = 0
	where Ced.TipoInstrumento = Dep_Cedes
    AND Ced.SaldoFinal = 0;


    UPDATE TMPREGB0841 Ced, TMP_FACTSALDO Tem
		SET Ced.SaldoProm = (( (((Ced.InteresMes / Ced.NumDias)* Tem.NumFactor) +
								(Ced.NumDias * CASE WHEN Ced.SaldoIniPer = Decimal_Cero THEN Ced.MontoDepoIniPes ELSE Ced.SaldoIniPer END))
			  ) / (DATEDIFF(Par_Fecha, Var_IniMes)+1))
	WHERE (Ced.NumDias-1) = Tem.NumDias
    AND Ced.TipoInstrumento = Dep_Cedes;

    -- vmartinez - Cuentas sin Movimiento
    INSERT INTO TMPREGB0841

		SELECT  His.ClienteID,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						SUBSTRING(CONCAT(IFNULL(PrimerNombre, Cadena_Vacia),
									CASE WHEN IFNULL(SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(" ", SegundoNombre) ELSE Cadena_Vacia
									END,
									CASE WHEN IFNULL(TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(" ", TercerNombre) ELSE Cadena_Vacia
									END),  1, 200)
					 ELSE UPPER(Cli.RazonSocial)
				END,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   CASE WHEN IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = Cadena_Vacia
									OR IFNULL(Cli.ApellidoPaterno,Apellido_Vacio) = '.' THEN
								Apellido_Vacio
							ELSE
								UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END ,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Apellido_Vacio) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END,

				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
					 END,

				CASE WHEN Cli.NivelRiesgo = Riesgo_Alto THEN Clave_RiesAlto
					 WHEN Cli.NivelRiesgo = Riesgo_Medio THEN Clave_RiesMedio
					 WHEN Cli.NivelRiesgo = Riesgo_Bajo THEN Clave_RiesBajo
					 END,

				Cli.ActividadBancoMX,
				Cadena_Vacia,

				Cli.LugarNacimiento,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						DATE_FORMAT(IFNULL(Cli.FechaNacimiento,Fecha_Vacia) ,'%d%m%Y')
					 ELSE
						DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%d%m%Y')
					END,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.RFCOficial
					 ELSE CONCAT("_", IFNULL(Cli.RFCOficial,Cadena_Vacia))
				END,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.CURP
					 ELSE Cadena_Cero
				END,

				CASE WHEN Cli.TipoPersona = Moral THEN Per_NoAplica
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Masculino THEN Per_Masculino
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Femenino THEN Per_Femenino
				END,

				IFNULL(Dir.Calle,Cadena_Vacia),

				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),

				IFNULL(Dir.ColoniaID,Entero_Cero),
				Cadena_Vacia,

				IFNULL(Dir.CP,Entero_Cero),

				IFNULL(Dir.LocalidadID, Entero_Cero),

				IFNULL(Dir.EstadoID, Entero_Cero),
				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,

				IFNULL(Dir.MunicipioID, Entero_Cero),
				Cadena_Vacia AS MunicipioClave,

				Codigo_Mexico,

				IFNULL(Suc.ClaveSucOpeCred,Cadena_Vacia),

				CONVERT(His.CuentaAhoID, CHAR),

				CONVERT(His.CuentaAhoID, CHAR),

				Clave_Ahorrador,

				'240120000000',

				Clave_CertBursatil,

                CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisCnInt
					 WHEN Tip.GeneraInteres = Con_NO AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisSnInt
					 WHEN ClasificacionConta = Dep_Ahorro THEN
					 Dep_AhoInte
				END,
				Tip.ClaveCNBV,

				IFNULL(DATE_FORMAT(His.FechaCancela,'%d%m%Y'),Fecha_Nula),

                His.FechaCancela,

				ifnull(His.SaldoAhorro,0),

				ifnull(His.SaldoAhorro,0),

				Entero_Cero,

				Entero_Cero,

				Clave_DepVista,

                Clave_PerOtro,

				Clave_TipoTasa,

				Entero_Cero, -- Tasa pactada

				Entero_Cero,

				101,	-- No Aplica

				Entero_Cero,

				Clave_OpeDiferen,

				Entero_Cero,

				Mon.MonedaCNBV,

				case when His.FechaCancela < Var_IniMes
					then  ifnull(His.SaldoAhorro,0)
					else Entero_Cero end,

				case when His.FechaCancela >= Var_IniMes then
							His.SaldoAhorro
					else Entero_Cero end,

				case when His.FechaRetiro between Var_IniMes and Par_Fecha then
							His.SaldoAhorro
					else Entero_Cero end,

				Entero_Cero AS IntDevNoPago,

				case when His.FechaRetiro between Var_IniMes and Par_Fecha then
							Entero_Cero
				else His.SaldoAhorro end,

				Entero_Cero, -- interes generado

				Entero_Cero, -- Comisiones

				IFNULL(DATE_FORMAT(Fecha_Vacia,'%d%m%Y'),Fecha_Nula),

				Decimal_Cero,

				His.SaldoAhorro,

				No_RetAntici,

				Decimal_Cero,

				Decimal_Cero,

				Decimal_Cero,

				His.CuentaAhoID	,

                Entero_Cero,
                Entero_Cero,
                Fecha_Vacia,
                Tip.ClaveCNBVAmpCred

			FROM CANCSOCMENORCTA His,
				  CUENTASAHO Cue,
				 TIPOSCUENTAS Tip,
                 MONEDAS Mon,
				 SUCURSALES Suc,
				 CLIENTES Cli
                 LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, Con_NO) = SI


			WHERE His.FechaCancela <= Var_FechaHis
			  AND (His.Aplicado ='N' OR (Aplicado = 'R' and FechaRetiro >= Var_IniMes ))
              AND His.CuentaAhoID = Cue.CuentaAhoID
			  AND His.ClienteID = Cli.ClienteID
              AND Cue.MonedaId = Mon.MonedaID
              AND His.ClienteID <>Cliente_Inst
              AND Tip.EsBancaria = Con_NO
			  AND Cue.TipoCuentaID = Tip.TipoCuentaID
			  AND Cue.SucursalID = Suc.SucursalID
              ;
    -- vmartinez - fin cuentas sin movimiento

	UPDATE TMPREGB0841 Tem, COLONIASREPUB Col SET
		Tem.ColoniaDes		= Col.Asentamiento
		WHERE Tem.EstadoID = Col.EstadoID
		  AND Tem.MunicipioID = Col.MunicipioID
		  AND Tem.ColoniaID = Col.ColoniaID;


    UPDATE TMPREGB0841 Tem SET
		Tem.Localidad = 1
	WHERE Tem.Localidad = 999999999;



	UPDATE TMPREGB0841 Tem, LOCALIDADREPUB Loc SET
		Tem.Localidad		= Loc.LocalidadCNBV
		WHERE Tem.EstadoID = Loc.EstadoID
		  AND Tem.MunicipioID = Loc.MunicipioID
		  AND Tem.Localidad = Loc.LocalidadID;

	-- validacion de localidades SITI
	UPDATE TMPREGB0841 Tem
		LEFT OUTER JOIN FABLOCALIDADESREPUB Fab
        ON Tem.Localidad = Fab.LocalidadCNBV
		SET Tem.Localidad = 1
	WHERE Fab.LocalidadCNBV is null;


    UPDATE TMPREGB0841 Tem, LOCALIDADREPUB Loc SET
		Tem.Localidad		= Loc.LocalidadCNBV
	WHERE Tem.EstadoID = Loc.EstadoID
	  AND Tem.MunicipioID = Loc.MunicipioID
	  AND Tem.Localidad = Loc.LocalidadID
      AND Tem.Localidad = 1;

	-- --------------------------------------
	-- CLIENTES ACREDITADOS Y AHORRADORES ---
	-- --------------------------------------
	UPDATE TMPREGB0841 Tem,TMPCLIENTAHOCRED Cre
		SET  Tem.TipoCliente = Clave_AhoradorCred
		WHERE Tem.ClienteID = Cre.ClienteID;




	-- --------------------------------------
	-- CLAVE PAIS NACIONALIDAD CNBV     ---
	-- --------------------------------------
	UPDATE TMPREGB0841 Tem, PAISES Pai
	SET	Tem.Nacionalidad = Pai.PaisRegSITI
	WHERE Tem.Nacionalidad = Pai.PaisID;





    UPDATE TMPREGB0841 Tem, ACTIVIDADESBMX Bmx
		SET Tem.ActividadEco = IFNULL(Bmx.ActividadSCIANID,Clave_OtraActiv)
	WHERE Tem.ActividadBmx = Bmx.ActividadBMXID;


	IF( Par_NumReporte = Rep_Excel) THEN
		SELECT 	Var_Periodo,
				Var_ClaveEntidad,
				For_0841 AS Formulario,
				ClienteID,
                FNLIMPIACARACTERESGEN(Nombre,CaseMayus) AS Nombre,

                FNLIMPIACARACTERESGEN(ApellidoPat,CaseMayus) AS ApellidoPat,
                FNLIMPIACARACTERESGEN(ApellidoMat,CaseMayus) AS ApellidoMat,
                PersJuridica,
				GradoRiesgo,
                ActividadEco,

                Nacionalidad,
                FechaNac,
                IFNULL(RFC,'') AS RFC,
				FNLIMPIACARACTERESGEN(CURP,CaseMayus) AS CURP,
                Genero,

                FNLIMPIACARACTERESGEN(Calle,CaseMayus) AS Calle,
                FNLIMPIACARACTERESGEN(NumeroExt,CaseMayus) AS NumeroExt,
                FNLIMPIACARACTERESGEN(ColoniaDes,CaseMayus) AS ColoniaDes,
				CodigoPostal,
                Localidad,

                EstadoID,
                MunicipioID,
                CodigoPais,
				ClaveSucursal,
                NumeroCuenta,

                NumContrato,
                TipoCliente,
                ClasfContable,
				ClasfBursatil,
                TipoProducto AS TipoInstrumento,

                FechaApertura,
                FechaDepoIni,
                MontoDepoIniOri,
				MontoDepoIniPes,
                FechaDepoVenc,

                PlazoAlVencimi,
                RangoPlazo,
                Periodicidad,
				TipoTasa,
                TasaInteres,

                TasaPeriodo,
                TasaReferencia,
                DiferencialTasa,
				OpeDiferencial,
                Plazo AS FrecRevTasa,

                Moneda,
                SaldoIniPer,
                MtoDepositos,
				MtoRetiros,
                IntDevNoPago,

                SaldoFinal,
                InteresMes,
                ComisionMes,
				FecUltMov,
                MontoUltMov,

                SaldoProm,
                RetiroAnt,
                MontoFondPro,
				PorcFondoPro,
                PorcGarantia


		FROM TMPREGB0841;

	END IF;

	IF( Par_NumReporte = Rep_Csv) THEN
			SELECT  CONCAT(
		IFNULL(For_0841,Cadena_Vacia),';',
        IFNULL(ClienteID,Cadena_Vacia),';',
        IFNULL(FNLIMPIACARACTERESGEN(Nombre,CaseMayus),Cadena_Vacia),';',

        IFNULL(FNLIMPIACARACTERESGEN(ApellidoPat,CaseMayus),Cadena_Vacia),';',
        IFNULL(FNLIMPIACARACTERESGEN(ApellidoMat,CaseMayus),Cadena_Vacia),';',
        IFNULL(PersJuridica,Cadena_Vacia),';',
        IFNULL(GradoRiesgo,Cadena_Vacia),';',
        IFNULL(ActividadEco,Cadena_Vacia),';',

        IFNULL(Nacionalidad,Cadena_Vacia),';',
        IFNULL(FechaNac,Cadena_Vacia),';',
        IFNULL(RFC,Cadena_Vacia),';',
        IFNULL(FNLIMPIACARACTERESGEN(CURP,CaseMayus),Cadena_Vacia),';',
        IFNULL(Genero,Cadena_Vacia),';',

        IFNULL(FNLIMPIACARACTERESGEN(Calle,CaseMayus),Cadena_Vacia),';',
        IFNULL(FNLIMPIACARACTERESGEN(NumeroExt,CaseMayus),Cadena_Vacia),';',
        IFNULL(FNLIMPIACARACTERESGEN(ColoniaDes,CaseMayus),Cadena_Vacia),';',
        IFNULL(CodigoPostal,Cadena_Vacia),';',
        IFNULL(Localidad,Cadena_Vacia),';',

        IFNULL(EstadoID,Cadena_Vacia),';',
        IFNULL(MunicipioID,Cadena_Vacia),';',
        IFNULL(CodigoPais,Cadena_Vacia),';',
        IFNULL(ClaveSucursal,Cadena_Vacia),';',
        IFNULL(NumeroCuenta,Cadena_Vacia),';',

        IFNULL(NumContrato,Cadena_Cero),';',
        IFNULL(TipoCliente,Cadena_Vacia),';',
        IFNULL(ClasfContable,Cadena_Vacia),';',
        IFNULL(ClasfBursatil,Cadena_Vacia),';',
        IFNULL(TipoProducto,Cadena_Vacia),';',

        IFNULL(FechaApertura,Cadena_Vacia),';',
        IFNULL(FechaDepoIni,Cadena_Vacia),';',
        IFNULL(MontoDepoIniOri,Cadena_Vacia),';',
        IFNULL(MontoDepoIniPes,Cadena_Vacia),';',
        IFNULL(FechaDepoVenc,Cadena_Vacia),';',

        IFNULL(PlazoAlVencimi,Cadena_Cero),';',
        IFNULL(RangoPlazo,Cadena_Cero),';',
        IFNULL(Periodicidad,Cadena_Cero),';',
        IFNULL(TipoTasa,Cadena_Cero),';',
        IFNULL(TasaInteres,Cadena_Cero),';',

        IFNULL(TasaPeriodo,Cadena_Cero),';',
        IFNULL(TasaReferencia,Cadena_Cero),';',
        IFNULL(DiferencialTasa,Cadena_Cero),';',
        IFNULL(OpeDiferencial,Cadena_Cero),';',
        IFNULL(Plazo,Cadena_Cero),';',

        IFNULL(Moneda,Cadena_Cero),';',
        IFNULL(SaldoIniPer,Cadena_Cero),';',
        IFNULL(MtoDepositos,Cadena_Cero),';',
        IFNULL(MtoRetiros,Cadena_Cero),';',
        IFNULL(IntDevNoPago,Cadena_Cero),';',

        IFNULL(SaldoFinal,Cadena_Cero),';',
        IFNULL(InteresMes,Cadena_Cero),';',
        IFNULL(ComisionMes,Cadena_Cero),';',
        IFNULL(FecUltMov,Cadena_Vacia),';',
        IFNULL(MontoUltMov,Cadena_Vacia),';',

        IFNULL(SaldoProm,Cadena_Cero),';',
        IFNULL(RetiroAnt,Cadena_Cero),';',
        IFNULL(MontoFondPro,Cadena_Cero),';',
        IFNULL(PorcFondoPro,Cadena_Cero),';',
        IFNULL(PorcGarantia,Cadena_Cero)) AS Valor
			FROM TMPREGB0841;
    END IF;




END TerminaStore$$