-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGD084100003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGD084100003REP`;

DELIMITER $$
CREATE PROCEDURE `REGD084100003REP`(
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
	DECLARE Var_IniInversion	DATE;
	DECLARE Var_DiasMes			INT;
	DECLARE Var_AjusteCargoAbono	    CHAR(1);
	DECLARE Var_AjusteRFCMenor		CHAR(1);
    DECLARE Var_RFCREG			VARCHAR(15);
    DECLARE Var_AmparaCredito	CHAR(1);

	-- Declaracion de Constantes
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
    DECLARE Apellido_Vacio		CHAR(2);

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
    DECLARE Cadena_Cero			VARCHAR(10);
    DECLARE Cadena_DecimalCero	VARCHAR(12);
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
    DECLARE Var_FechaHisDet		DATE;
    DECLARE Var_FechaCieCed 	DATE;
    DECLARE Prog_Cierre			VARCHAR(20);
    DECLARE Var_FecMesAnt		DATE;
    DECLARE Monto_UDIS			INT;
    DECLARE Dias_Periodo		INT;
    DECLARE Var_Cien			DECIMAL(16,6);
	DECLARE Clave_PerOtro		INT;
	DECLARE Clave_PerMes		INT;
	DECLARE Var_NumCliente		INT;
	DECLARE Con_Registrado		CHAR(1);
	DECLARE Con_Vigente			CHAR(1);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Var_SucursalOrigen	CHAR(1);
    DECLARE Dep_Cedes			INT;
    DECLARE Var_ClienteEspecifico INT(11);

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

    SET Apellido_Vacio		:= 'ND';
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
	SET Var_DiasMes			:= DAY(LAST_DAY(Par_Fecha));
	SET Con_Registrado		:= 'R';
	SET Con_Vigente			:= 'V';
	SET Nat_Cargo			:= 'C';
    SET Dep_Cedes			:= 11;
    SET Cadena_DecimalCero  := '0.000000';


	SET Var_Periodo := CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),1,4),
							  SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),5,2));

	SELECT ClaveEntidad,		AjusteCargoAbono,		AjusteRFCMenor
		INTO Var_ClaveEntidad,	Var_AjusteCargoAbono,	Var_AjusteRFCMenor
	 FROM PARAMREGULATORIOS WHERE ParametrosID = 1;

	SET Var_AjusteCargoAbono := IFNULL(Var_AjusteCargoAbono, Salida_NO);
	SET Var_AjusteRFCMenor	 := IFNULL(Var_AjusteRFCMenor, Salida_NO);

	SET Cliente_Inst    	:= (SELECT ClienteInstitucion FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);
    SET Var_NumCliente    	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico' LIMIT 1);
    SET Var_FechaCieInv 	:= (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Par_Fecha);
   	SET Var_FechaCieCed	:= (SELECT MAX(FechaCorte) FROM SALDOSCEDES WHERE FechaCorte <= Par_Fecha);
    SET Var_IniInversion  	:= DATE_ADD(Par_Fecha, INTERVAL ((DAY(Par_Fecha)*-1)) DAY);
    SET Var_DiasMes			:= DAY(LAST_DAY(Par_Fecha));
    SET Var_AmparaCredito	:= IFNULL((SELECT AmparaCredito FROM TMP_PARAMETROSREGULATORIOS), Con_NO);
    SET Var_SucursalOrigen  := SI;

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

	CREATE  TABLE TMPREGB0841(
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
        Estatus 		CHAR(1),

		INDEX TMPREGB0841_idx1(ClienteID),
		INDEX TMPREGB0841_idx2(InstrumentoID),
		INDEX TMPREGB0841_idx3(EstadoID, MunicipioID, ColoniaID),
		INDEX TMPREGB0841_idx4(NumDias, TipoInstrumento),
		INDEX TMPREGB0841_idx5(Estatus)

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

	SET Var_MtoMinAporta 	:= IFNULL(Var_MtoMinAporta, Entero_Cero);
	SET Var_IniMes 			:= DATE_ADD(Par_Fecha, INTERVAL ((DAY(Par_Fecha)*-1) + 1) DAY);
	SET Var_IniInversion  	:= DATE_ADD(Par_Fecha, INTERVAL ((DAY(Par_Fecha)*-1)) DAY);
	SET Var_FecMesAnt 		:= DATE_SUB(Var_IniMes, INTERVAL 1 DAY);

	SET	Var_FecBitaco		:= NOW();

	-- Clientes que tienen Credito
	DROP TABLE IF EXISTS TMPCLIENTAHOCRED;
	CREATE TEMPORARY TABLE TMPCLIENTAHOCRED
	SELECT sal.EstatusCredito AS Estatus, cre.ClienteID AS ClienteID
		FROM SALDOSCREDITOS sal, CREDITOS cre
		WHERE sal.FechaCorte = DATE(Par_Fecha) AND
			  sal.CreditoID  = cre.CreditoID AND
			  sal.EstatusCredito IN ('V','B');
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
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.LugarNacimiento
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END  AS LugarNacimiento,
				-- Fecha de Nacimiento
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						DATE_FORMAT(IFNULL(Cli.FechaNacimiento,Fecha_Vacia) ,'%d%m%Y')
					 ELSE
						DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%d%m%Y')
					END,

				-- RFC
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						 CASE WHEN Cli.EsMenorEdad = 'S' AND Cli.RFCOficial = '' AND Var_AjusteRFCMenor = 'S' THEN
								   CONCAT(FNCALRFCMENOR(CONCAT(Cli.PrimerNombre,' ',Cli.SegundoNombre,' ',Cli.TercerNombre),Cli.ApellidoPaterno,Cli.ApellidoMaterno,Cli.FechaNacimiento,'OR'),'')
							  ELSE Cli.RFCOficial
						 END
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
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.PaisResidencia
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS PaisResidencia,
				-- Sucursal
				CASE WHEN Var_SucursalOrigen = SI THEN Cli.SucursalOrigen
					 ELSE Suc.ClaveSucOpeCred END,
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
				IFNULL(DATE_FORMAT(Cue.FechaApertura,'%d%m%Y'),Fecha_Nula),
				-- Fecha Inicial
                CASE WHEN IFNULL(Cue.FechaDepInicial,Fecha_Vacia) = Fecha_Vacia THEN
							IFNULL(DATE_FORMAT(Cue.FechaApertura,'%d%m%Y'),Fecha_Nula)
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
                CASE WHEN Tip.GeneraInteres = 'S' AND Tip.TipoInteres = 'D' THEN Clave_PerOtro
					 WHEN Tip.GeneraInteres = 'S' AND Tip.TipoInteres = 'M' THEN Clave_PerMes
					 WHEN Tip.GeneraInteres = 'N' THEN Clave_PerMes
                     ELSE Clave_PerOtro END,
				-- Tipo de Tasa
				Clave_TipoTasa,
				-- Valor Tasa
				CASE WHEN IFNULL(Cue.TasaPactada,Entero_Cero) = Entero_Cero THEN ROUND(His.TasaInteres,6)
				 	ELSE ROUND(Cue.TasaPactada,6) END,
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
                Tip.ClaveCNBVAmpCred,
                His.Estatus

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
			  AND Cli.SucursalOrigen = Suc.SucursalID
			  AND Cue.Estatus <> Con_Registrado;



	IF(Var_NumCliente = 15) THEN
		DROP TABLE IF EXISTS TMP_CUENTASAHOGENINTERES;
        CREATE TEMPORARY TABLE TMP_CUENTASAHOGENINTERES
        SELECT CuentaAhoID FROM CUENTASAHO WHERE TipoCuentaID = 6;

		UPDATE TMPREGB0841 Temp, TMP_CUENTASAHOGENINTERES Cue SET
			Periodicidad = 3
		WHERE Temp.InstrumentoID = Cue.CuentaAhoID
        AND Temp.InstrumentoID NOT IN (100031001,100031221);

	END IF;


	UPDATE TMPREGB0841 Tem, TASASAHORRO Tap SET
		Tem.TasaInteres	= ROUND(Tap.Tasa,6),
		Tem.TasaPeriodo	= ROUND(Tap.Tasa,6)
		WHERE Tem.TasaInteres = Tap.TipoCuentaID;


-- -------------------------------------------------------------- --
	-- Fecha de Ultimo Movimiento
    DROP TABLE IF EXISTS TMPREGDESCAPTULTABONO;
	CREATE TEMPORARY TABLE TMPREGDESCAPTULTABONO(
		CuentaAhoID		BIGINT,
		FechaUltMov		DATETIME,
		MontoUltMov		DECIMAL(21,2),
        NumTansaccion   BIGINT,
		INDEX TMPREGDESCAPTULTABONO_idx1(CuentaAhoID));

	DROP TABLE IF EXISTS TMPREGFECHA;
	CREATE TEMPORARY TABLE TMPREGFECHA(
		CuentaAhoID		BIGINT,
        NumTansaccion   BIGINT,
		INDEX TMPREGDESCAPTULTABONO_idx1(CuentaAhoID));


	DROP TABLE IF EXISTS tmp_movsaho;
	CREATE TABLE tmp_movsaho(
		Consecutivo INT AUTO_INCREMENT PRIMARY KEY,
		CuentaAhoID BIGINT,
		Fecha		DATE,
		MontoMov	DECIMAL(16,2)
	);

	INSERT INTO tmp_movsaho(CuentaAhoID,Fecha,MontoMov)
	SELECT His.CuentaAhoID,His.Fecha,His.CantidadMov
	FROM `HIS-CUENAHOMOV` His, TMPREGB0841 Tem
	WHERE His.CuentaAhoID = Tem.InstrumentoID
	AND  His.ProgramaID != Prog_Cierre
    ORDER BY FechaActual ASC,Fecha ASC;

	DROP TABLE IF EXISTS tmp_numMovsCue;
	CREATE TABLE tmp_numMovsCue
	SELECT MAX(Consecutivo) AS Movimiento, CuentaAhoID
	FROM tmp_movsaho GROUP BY CuentaAhoID;

	UPDATE TMPREGB0841 Tem, tmp_movsaho Mov, tmp_numMovsCue Num  SET
			Tem.FecUltMov = DATE_FORMAT(Mov.Fecha,'%d%m%Y'),
			Tem.MontoUltMov = Mov.MontoMov
	WHERE Tem.InstrumentoID = Mov.CuentaAhoID
	AND   Mov.CuentaAhoID = Num.CuentaAhoID
	AND   Mov.Consecutivo = Num.Movimiento;


	DROP TABLE IF EXISTS TMPREGDESCAPTULTABONO;






	DROP TABLE IF EXISTS TMP_CREDITOSAMPARADOS;
	CREATE TEMPORARY TABLE TMP_CREDITOSAMPARADOS
		SELECT CreditoID,EstatusCredito FROM SALDOSCREDITOS WHERE FechaCorte = Par_Fecha;

	DROP TABLE IF EXISTS TMP_CREDAMPAVIG;
	CREATE TEMPORARY TABLE TMP_CREDAMPAVIG
		SELECT CuentaID FROM CREDITOS
        WHERE CreditoID IN (SELECT CreditoID FROM TMP_CREDITOSAMPARADOS)
        GROUP BY CuentaID;

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
		SELECT Blo.CuentaAhoID, SUM(CASE WHEN Blo.NatMovimiento = Nat_Bloqueo THEN Blo.MontoBloq
									 ELSE Blo.MontoBloq *-1
								END) AS Saldo
		FROM BLOQUEOS Blo, CREDITOS Cre
		WHERE Blo.Referencia = Cre.CreditoID
        AND (Cre.FechTerminacion = '1900-01-01' OR Cre.FechTerminacion > Par_Fecha)
        AND DATE(Blo.FechaMov) <= Par_Fecha
		 AND Blo.TiposBloqID = Cons_BloqGarLiq
         AND Blo.CuentaAhoID IN (SELECT CuentaID FROM TMP_CREDAMPAVIG)
		GROUP BY CuentaAhoID;

	UPDATE TMPREGB0841 Tem, TMP_GTIALIQ_AHORRO Gar SET
		TipoInstrumento = CASE WHEN TipoInstrumento  = Dep_VisSnInt THEN Dep_VisSnIntCre
							   WHEN TipoInstrumento  = Dep_VisCnInt THEN Dep_VisIntCre
							   WHEN TipoInstrumento  = Dep_AhoInte THEN Dep_AhoCre
						END,




		Tem.TipoProducto = Tem.ClaveAmpCed,
		PorcGarantia = ROUND((Gar.Saldo/Tem.SaldoFinal),6) * 100
		WHERE Tem.InstrumentoID = Gar.Cuenta
        AND Gar.Saldo > Entero_Cero;

	IF(Var_AmparaCredito = SI) THEN
		UPDATE TMPREGB0841 Tem SET
			ClasfContable = CASE WHEN ClasfContable  = Dep_ConInteres THEN Dep_ConIntCre
								 WHEN ClasfContable  = Dep_SinInteres THEN Dep_SinIntCre
								 WHEN ClasfContable  = Dep_AhoLibGrav THEN Dep_AhoAmpCre
						END
		WHERE PorcGarantia = Var_Cien;

        UPDATE TMPREGB0841 Tem SET
			TipoInstrumento = CASE  WHEN TipoInstrumento  = Dep_VisSnIntCre THEN Dep_VisSnInt
									WHEN TipoInstrumento  = Dep_VisIntCre 	THEN Dep_VisCnInt
									WHEN TipoInstrumento  = Dep_AhoCre 		THEN Dep_AhoInte
						END
		WHERE PorcGarantia < Var_Cien;
    END IF;

	DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;


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
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.LugarNacimiento
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS LugarNacimiento,
				-- Fecha de Nacimiento
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						DATE_FORMAT(Cli.FechaNacimiento ,'%d%m%Y')
					 ELSE
						DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%d%m%Y')
					END,
				-- RFC
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						 CASE WHEN Cli.EsMenorEdad = 'S' AND Cli.RFCOficial = '' AND Var_AjusteRFCMenor = 'S' THEN
								   CONCAT(FNCALRFCMENOR(CONCAT(Cli.PrimerNombre,' ',Cli.SegundoNombre,' ',Cli.TercerNombre),Cli.ApellidoPaterno,Cli.ApellidoMaterno,Cli.FechaNacimiento,'OR'),'')
							  ELSE Cli.RFCOficial
						 END
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
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.PaisResidencia
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS PaisResidencia,
				-- Sucursal
				CASE WHEN Var_SucursalOrigen = SI THEN Cli.SucursalOrigen
					 ELSE Suc.ClaveSucOpeCred END,
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
                CASE WHEN Inv.FechaInicio = Var_IniMes THEN Decimal_Cero
					 WHEN Inv.FechaInicio <= Var_IniMes THEN Inv.Monto
					 ELSE Decimal_Cero
				END,

				-- Importe Depositos
                CASE WHEN  Inv.FechaInicio BETWEEN Var_IniMes AND Par_Fecha THEN Inv.Monto
                ELSE Decimal_Cero END,

				-- Importe Retiros

                CASE WHEN Inv.Estatus IN (Est_Pagado,Est_Cancelado)  THEN (Inv.Monto + Inv.SaldoProvision)
                ELSE Decimal_Cero END,

				-- INT. devengados no pagados
                CASE WHEN Inv.Estatus IN (Est_Pagado,Est_Cancelado)  THEN Decimal_Cero
						ELSE Inv.SaldoProvision  END AS IntDevNoPago,

				-- Saldo Cuenta al Final del Periodo
                CASE WHEN Inv.Estatus IN(Est_Pagado,Est_Cancelado) THEN Decimal_Cero ELSE
				(Inv.Monto + Inv.SaldoProvision) END AS SaldoFinal,

				-- Intereses del mes
               	CASE WHEN Inv.Estatus IN(Est_Pagado,Est_Cancelado) THEN Inv.SaldoProvision ELSE
				Decimal_Cero END AS InteresMes,

				-- Comisiones del mes
				Entero_Cero,

				-- Fecha ultimo Movimiento
                CASE WHEN Inv.Estatus = Est_Pagado THEN
						IFNULL(DATE_FORMAT(Inv.FechaVencimiento,'%d%m%Y'),Fecha_Nula)
                     WHEN Inv.Estatus = Est_Cancelado AND Inv.FechaVenAnt <> Fecha_Vacia THEN
						IFNULL(DATE_FORMAT(Inv.FechaVenAnt,'%d%m%Y'),Fecha_Nula)
					 WHEN Inv.Estatus = Est_Cancelado AND Inv.FechaVenAnt = Fecha_Vacia  THEN
						IFNULL(DATE_FORMAT(Dat.FechaActual,'%d%m%Y'),Fecha_Nula)
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

                Cat.ClaveCNBVAmpCred,
                Inv.Estatus

		FROM HISINVERSIONES Inv,
			 INVERSIONES Dat,
			 CATINVERSION Cat,
             MONEDAS Mon,
			 SUCURSALES Suc,
			 CLIENTES Cli

		LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, Con_NO) = SI

		WHERE Inv.ClienteID = Cli.ClienteID
		  AND Inv.InversionID = Dat.InversionID
          AND Inv.ClienteID <> Cliente_Inst
          AND Inv.MonedaID = Mon.MonedaId
		  AND Inv.FechaCorte  = Var_FechaCieInv
          AND (Inv.Estatus = Con_NO OR
			  (Inv.Estatus = Est_Pagado AND Inv.FechaVencimiento BETWEEN Var_IniMes AND Var_FechaCieInv)
			   OR
			  (Inv.Estatus = Est_Cancelado AND Inv.FechaVenAnt BETWEEN Var_IniMes AND Var_FechaCieInv)
			   OR
              (Dat.Estatus = Est_Cancelado AND DATE(Dat.FechaActual) BETWEEN Var_IniMes AND Var_FechaCieInv AND Dat.ProgramaID LIKE '%cancelaInversiones%'))
         AND Inv.TipoInversionID = Cat.TipoInversionID
	AND Cli.SucursalOrigen = Suc.SucursalID
	ORDER BY Suc.SucursalID, Inv.InversionID;


	DROP TABLE IF EXISTS TMP_INVERSIONESCANCELADAS;
    CREATE TEMPORARY TABLE TMP_INVERSIONESCANCELADAS
	    SELECT InversionID, NumTransaccion
	    FROM INVERSIONES WHERE Estatus = Est_Cancelado AND DATE(FechaActual) BETWEEN Var_IniMes AND Var_FechaCieInv AND ProgramaID LIKE '%cancelaInversiones%';
    CREATE INDEX idx1 ON TMP_INVERSIONESCANCELADAS(InversionID);
    CREATE INDEX idx2 ON TMP_INVERSIONESCANCELADAS(NumTransaccion);


    SELECT MAX(Fecha) INTO Var_FechaHisDet FROM `HIS-DETALLEPOL`;


    IF( DATE(Par_Fecha) <=  Var_FechaHisDet ) THEN


    	DROP TABLE IF EXISTS TMP_INVERSIONESCONTABLES;
	    CREATE TEMPORARY TABLE TMP_INVERSIONESCONTABLES
		    SELECT det.Instrumento AS InversionID , MAX(det.NumTransaccion ) AS NumTransaccion
            FROM `HIS-DETALLEPOL`  det,
				TMP_INVERSIONESCANCELADAS tmp
                WHERE det.Fecha BETWEEN Var_IniMes AND Var_FechaCieInv
                AND det.Instrumento REGEXP '^[0-9]*$' >= 1
                AND det.Instrumento = tmp.InversionID AND det.NumTransaccion = tmp.NumTransaccion
			GROUP BY det.Instrumento;

	ELSE


		DROP TABLE IF EXISTS TMP_INVERSIONESCONTABLES;
	    CREATE TEMPORARY TABLE TMP_INVERSIONESCONTABLES
	    	SELECT det.Instrumento AS InversionID , MAX(det.NumTransaccion ) AS NumTransaccion
            FROM DETALLEPOLIZA  det,
				TMP_INVERSIONESCANCELADAS tmp
                WHERE det.Fecha BETWEEN Var_IniMes AND Var_FechaCieInv
                AND det.Instrumento REGEXP '^[0-9]*$' >= 1
                AND det.Instrumento = tmp.InversionID AND det.NumTransaccion = tmp.NumTransaccion
			GROUP BY det.Instrumento;


    END IF;


    DELETE FROM TMP_INVERSIONESCANCELADAS WHERE InversionID IN (SELECT InversionID FROM TMP_INVERSIONESCONTABLES);


   	DELETE FROM TMPREGB0841
	WHERE  InstrumentoID IN (SELECT InversionID FROM TMP_INVERSIONESCANCELADAS) AND
			  TipoInstrumento = Dep_Plazo;



	-- --------------------------------------
	-- SALDO INICIAL MES
	-- --------------------------------------
    DROP TABLE IF EXISTS TMP_SALDOINVER;
    CREATE TEMPORARY TABLE TMP_SALDOINVER
    SELECT InversionID,(Monto+SaldoProvision) AS SaldoFinal,SaldoProvision FROM HISINVERSIONES
	WHERE FechaCorte = Var_IniInversion;

    CREATE INDEX idx_TMP_SALDOINVER_1 ON TMP_SALDOINVER(InversionID);

    UPDATE TMPREGB0841 Inv, TMP_SALDOINVER Tem
		SET	Inv.SaldoIniPer = Tem.SaldoFinal,
			Inv.SaldoProm = Tem.SaldoFinal,
            Inv.MtoRetiros = CASE WHEN Inv.SaldoFinal > 0 AND Var_AjusteCargoAbono = 'S'
            					THEN Inv.MtoRetiros + Tem.SaldoProvision ELSE Inv.MtoRetiros END
	WHERE Inv.InstrumentoID = Tem.InversionID
     AND Inv.TipoInstrumento = Dep_Plazo;


	UPDATE TMPREGB0841 Inv
		SET	Inv.MtoDepositos =  CASE WHEN Inv.SaldoFinal = 0 AND Var_AjusteCargoAbono = 'S'
								THEN Inv.MtoRetiros - Inv.SaldoIniPer ELSE Inv.MtoDepositos END
	WHERE Inv.TipoInstrumento = Dep_Plazo;

        -- --------------------------------------
	-- SALDO Promedio Inversion MES
	-- --------------------------------------
    DROP TABLE IF EXISTS TMP_MOVINVER;
	CREATE TEMPORARY TABLE TMP_MOVINVER(
		InversionID   INT PRIMARY KEY,
        SaldoPromedio DECIMAL(18,2)
    );

    INSERT INTO TMP_MOVINVER(InversionID, SaldoPromedio)
    SELECT Inv.InversionID, SUM(Inv.CantidadMov)/Var_DiasMes AS SaldoPromedio
		FROM(
			SELECT InversionID, Fecha, NatMovimiento,  CASE WHEN (NatMovimiento = Nat_Cargo)
																THEN (Monto*(DATEDIFF(Var_FechaCieInv,Fecha)))
																ELSE ((Monto*(DATEDIFF(Var_FechaCieInv,Fecha)))*-1) END AS CantidadMov
					FROM INVERSIONESMOV
                    WHERE Fecha >= DATE_ADD(Var_FechaCieInv, INTERVAL -1*(DAY(Var_FechaCieInv))+1 DAY)
					AND   Fecha <= LAST_DAY(Var_FechaCieInv)

        ) AS Inv
	GROUP BY Inv.InversionID;

	UPDATE TMPREGB0841 Inv, TMP_MOVINVER Tem
		SET Inv.SaldoProm = Inv.SaldoIniPer + Tem.SaldoPromedio
	WHERE Inv.TipoInstrumento = Dep_Plazo
	AND Inv.InstrumentoID = Tem.InversionID;


	-- --------------------------------------
	-- INVERSIONES EN GARANTIA
	-- --------------------------------------
	DROP TABLE IF EXISTS TMP_INVGAR;
	CREATE TABLE TMP_INVGAR (
		InversionID	BIGINT,
		Saldo       DECIMAL(21,2),
        CreditoID	BIGINT,
        FechaTermino DATE);
	CREATE INDEX idx1_TMP_INVGAR ON TMP_INVGAR (InversionID);
	CREATE INDEX idx1_TMP_INVGAR_1 ON TMP_INVGAR (CreditoID);


	INSERT INTO TMP_INVGAR
		SELECT Gar.InversionID,Gar.MontoEnGar,Gar.CreditoID,'1900-01-01'
			FROM CREDITOINVGAR Gar
			WHERE FechaAsignaGar <= Par_Fecha;


	INSERT INTO TMP_INVGAR
		SELECT Gar.InversionID, Gar.MontoEnGar,Gar.CreditoID,'1900-01-01'
			FROM HISCREDITOINVGAR Gar
			WHERE Gar.Fecha >= Par_Fecha
			  AND Gar.FechaAsignaGar <= Par_Fecha;


	UPDATE TMP_INVGAR Gar, CREDITOS Cre
		SET Gar.FechaTermino = Cre.FechTerminacion
	WHERE Gar.CreditoID  = Cre.CreditoID;

    DELETE FROM TMP_INVGAR WHERE
		FechaTermino > '1900-01-01' AND FechaTermino<= Par_Fecha;

	UPDATE TMPREGB0841 Tem, TMP_INVGAR Gar SET
		Tem.TipoInstrumento = CASE WHEN Tem.TipoInstrumento  = Dep_Plazo THEN Dep_PlazoAmpCre
								   ELSE Tem.TipoInstrumento END,
		Tem.TipoProducto = Tem.ClaveAmpCed,


	    Tem.PorcGarantia = ROUND((Gar.Saldo/NULLIF(Tem.SaldoFinal,0)),6) * 100
	WHERE Tem.InstrumentoID = Gar.InversionID
	  AND Tem.TipoInstrumento = Dep_Plazo;


	IF(Var_AmparaCredito = SI) THEN
		UPDATE TMPREGB0841 Tem SET
			Tem.ClasfContable = CASE WHEN Tem.TipoInstrumento  = Dep_Plazo THEN Dep_PlaLibAmpCre
								 ELSE Tem.ClasfContable END
		WHERE PorcGarantia = Var_Cien;
    END IF;

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
                CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						  CASE WHEN IFNULL(Cli.PaisNacionalidad,Entero_Cero) = Entero_Cero THEN
						  			Cli.LugarNacimiento
						  	   ELSE Cli.PaisNacionalidad
						  END
					 ELSE
						  Cli.PaisConstitucionID
                END,
				-- Fecha de Nacimiento
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						DATE_FORMAT(Cli.FechaNacimiento ,'%d%m%Y')
					 ELSE
						DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%d%m%Y')
					END,
				-- RFC
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						 CASE WHEN Cli.EsMenorEdad = 'S' AND Cli.RFCOficial = '' AND Var_AjusteRFCMenor = 'S' THEN
								   CONCAT(FNCALRFCMENOR(CONCAT(Cli.PrimerNombre,' ',Cli.SegundoNombre,' ',Cli.TercerNombre),Cli.ApellidoPaterno,Cli.ApellidoMaterno,Cli.FechaNacimiento,'OR'),'333')
							  ELSE Cli.RFCOficial
						 END
					 ELSE CONCAT("_", IFNULL(Cli.RFCOficial,Cadena_Vacia))
				END,
				-- CURP
				CASE WHEN Cli.Nacion = 'N' AND ( Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre) THEN
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
				Clave_PerOtro,  -- Clave Otro
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

                Cat.ClaveCNBVAmpCred,

                IFNULL(Sal.Estatus,'T')

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
				( Ced.Estatus = Est_Pagado AND Ced.FechaVencimiento >= Var_IniMes AND FechaInicio <=Var_FechaCieCed)
                OR
                ( Ced.Estatus =  Est_Cancelado AND Ced.FechaVenAnt >= Var_IniMes AND FechaInicio <=Var_FechaCieCed )
                )
          AND Ced.TipoCedeID = Cat.TipoCedeID
		  AND Cli.SucursalOrigen = Suc.SucursalID
		ORDER BY Suc.SucursalID, Ced.TipoCedeID;



    UPDATE TMPREGB0841 Reg,CEDES Ced SET
		SaldoFinal=Decimal_Cero
	WHERE Reg.InstrumentoID=Ced.CedeID
    AND Ced.Estatus='P'
    AND Ced.FechaVencimiento=LAST_DAY(Par_Fecha);

	-- --------------------------------------
	-- SALDO INICIAL MES CEDES
	-- --------------------------------------


	DROP TABLE IF EXISTS TMP_CARGOABONOCEDE;
	CREATE TEMPORARY TABLE TMP_CARGOABONOCEDE (
		CedeID			INT(11),
		InteresPagado	DECIMAL(21,2),
		InteresProvisionado	DECIMAL(21,2),
		INDEX idx1_TMP_CARGOABONOCEDE(CedeID));



	TRUNCATE TMP_CARGOABONOCEDE;
	INSERT INTO TMP_CARGOABONOCEDE (CedeID, InteresPagado, InteresProvisionado)
	SELECT CedeID, SUM(CASE WHEN NatMovimiento = 'A' THEN Monto ELSE 0 END) AS InteresPagado,
	SUM(CASE WHEN NatMovimiento = 'C' THEN Monto ELSE 0 END) AS InteresProvisionado
	 FROM CEDESMOV WHERE CedeID IN(
		SELECT CedeID FROM SALDOSCEDES WHERE FechaCorte = Var_FecMesAnt
	 ) AND Fecha <= Var_FecMesAnt
	 GROUP BY CedeID;

	UPDATE TMPREGB0841 Ced,TMP_CARGOABONOCEDE Res
		SET Ced.SaldoIniPer = Ced.SaldoIniPer  + (Res.InteresProvisionado - Res.InteresPagado),
			Ced.MtoRetiros = CASE WHEN Var_AjusteCargoAbono = 'S'
							THEN Ced.MtoRetiros + (Res.InteresProvisionado - Res.InteresPagado)
							ELSE Ced.MtoRetiros END
	WHERE Ced.InstrumentoID = Res.CedeID
    AND Ced.TipoInstrumento = Dep_Cedes;

	TRUNCATE TMP_CARGOABONOCEDE;
	INSERT INTO TMP_CARGOABONOCEDE (CedeID, InteresPagado, InteresProvisionado)
	SELECT CedeID, SUM(CASE WHEN NatMovimiento = 'A' THEN Monto ELSE 0 END) AS InteresPagado,
	SUM(CASE WHEN NatMovimiento = 'C' THEN Monto ELSE 0 END) AS InteresProvisionado
	 FROM CEDESMOV WHERE CedeID IN(
		SELECT CedeID FROM SALDOSCEDES WHERE FechaCorte = Var_FechaCieCed
	 ) AND Fecha <= Var_FechaCieCed
	 GROUP BY CedeID;

	UPDATE TMPREGB0841 Ced,TMP_CARGOABONOCEDE Res
		SET Ced.IntDevNoPago = Res.InteresProvisionado - Res.InteresPagado,

			Ced.SaldoFinal = Ced.SaldoFinal + (Res.InteresProvisionado - Res.InteresPagado)
	WHERE Ced.InstrumentoID = Res.CedeID
    AND Ced.TipoInstrumento = Dep_Cedes;


	TRUNCATE TMP_CARGOABONOCEDE;
	INSERT INTO TMP_CARGOABONOCEDE (CedeID, InteresPagado, InteresProvisionado)
	SELECT CedeID, SUM(CASE WHEN NatMovimiento = 'A' THEN Monto ELSE 0 END) AS InteresPagado,
	SUM(CASE WHEN NatMovimiento = 'C' THEN Monto ELSE 0 END) AS InteresProvisionado
	 FROM CEDESMOV WHERE CedeID IN(
		SELECT InstrumentoID FROM TMPREGB0841 WHERE TipoInstrumento = Dep_Cedes
	 ) AND Fecha BETWEEN Var_IniMes AND Var_FechaCieCed
	 GROUP BY CedeID;


	UPDATE TMPREGB0841 Ced,TMP_CARGOABONOCEDE Res
		SET Ced.InteresMes = Res.InteresPagado,
			Ced.MtoRetiros = CASE WHEN Ced.SaldoFinal = 0  AND Var_AjusteCargoAbono = 'S'
								 THEN  Ced.MontoDepoIniPes +  Res.InteresPagado ELSE Ced.MtoRetiros END
	WHERE Ced.InstrumentoID = Res.CedeID
    AND Ced.TipoInstrumento = Dep_Cedes;

    UPDATE TMPREGB0841 Ced,TMP_CARGOABONOCEDE Res
		SET Ced.MtoDepositos = CASE WHEN Ced.SaldoFinal = 0 AND Var_AjusteCargoAbono = 'S'
								 THEN  Ced.MtoRetiros - Ced.SaldoIniPer ELSE Ced.MtoDepositos END
	WHERE Ced.InstrumentoID = Res.CedeID
    AND Ced.TipoInstrumento = Dep_Cedes;
	DROP TABLE IF EXISTS TMP_CARGOABONOCEDE;


    IF Var_FechaCieCed <= '2018-04-30' THEN
		UPDATE TMPREGB0841 Ced,TMP_SALDOCEDEINICIAL Res
			SET Ced.SaldoFinal = Ced.SaldoFinal + Res.MontoAjuste,
				Ced.SaldoIniPer = Ced.SaldoIniPer +  Res.MontoAjuste,
                Ced.IntDevNoPago = Ced.IntDevNoPago +  Res.MontoAjuste
		WHERE Ced.InstrumentoID = Res.CedeID
		AND Ced.TipoInstrumento = Dep_Cedes;
	END IF;


    UPDATE TMPREGB0841 Ced
		SET Ced.IntDevNoPago = 0
	WHERE Ced.TipoInstrumento = Dep_Cedes
    AND Ced.SaldoFinal = 0;



    UPDATE TMPREGB0841 Reg,CEDES Ced SET
		SaldoFinal=Decimal_Cero
	WHERE Reg.InstrumentoID=Ced.CedeID
    AND Ced.Estatus='P'
    AND Ced.FechaVencimiento=LAST_DAY(Par_Fecha);

    -- --------------------------------------
	-- SALDO Promedio CEDES MES
	-- --------------------------------------
    UPDATE TMPREGB0841 Ced, TMP_FACTSALDO Tem
		SET Ced.SaldoProm = (( (((Ced.InteresMes / Ced.NumDias)* Tem.NumFactor) +
								(Ced.NumDias * CASE WHEN Ced.SaldoIniPer = Decimal_Cero THEN Ced.MontoDepoIniPes ELSE Ced.SaldoIniPer END))
			  ) / (DATEDIFF(Par_Fecha, Var_IniMes)+1))
	WHERE (Ced.NumDias-1) = Tem.NumDias
    AND Ced.TipoInstrumento = Dep_Cedes;


	-- --------------------------------------
	-- ESTADOS Y MUNICIPIOS -----------------
	-- --------------------------------------
	UPDATE TMPREGB0841 Tem, COLONIASREPUB Col SET
		Tem.ColoniaDes		  = CONCAT(Col.TipoAsenta,' ', Col.Asentamiento)

		WHERE Tem.EstadoID    = Col.EstadoID
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
	WHERE Fab.LocalidadCNBV IS NULL;


    UPDATE TMPREGB0841 Tem, LOCALIDADREPUB Loc SET
		Tem.Localidad		= Loc.LocalidadCNBV
	WHERE Tem.EstadoID = Loc.EstadoID
	  AND Tem.MunicipioID = Loc.MunicipioID
	  AND Tem.Localidad = Loc.LocalidadID
      AND Tem.Localidad = 1;

	-- --------------------------------------
	-- CLIENTES ACREDITADOS Y AHORRADORES ---
	-- --------------------------------------
	UPDATE TMPREGB0841 Tem, TMPCLIENTAHOCRED Cre
		SET  Tem.TipoCliente =	CASE WHEN Cre.Estatus = Con_Vigente OR Cre.Estatus = Cue_Bloqueada THEN Clave_AhoradorCred
									 ELSE Clave_Ahorrador END

	WHERE Tem.ClienteID = Cre.ClienteID;

	SET Var_ClienteEspecifico := FNPARAMGENERALES('CliProcEspecifico');
	IF(Var_ClienteEspecifico IN (24, 9) )THEN
	    UPDATE TMPREGB0841 Tem,CUENTASAHO Cue
			SET  Tem.TipoCliente = Clave_AhoradorCred
			WHERE Tem.ClienteID = Cue.ClienteID
	        AND TipoCuentaID = 2;
	END IF;
	-- --------------------------------------
	-- CLAVE PAIS NACIONALIDAD CNBV     ---
	-- --------------------------------------
	UPDATE TMPREGB0841 Tem, PAISES Pai
	SET	Tem.Nacionalidad = Pai.PaisRegSITI
	WHERE Tem.Nacionalidad = Pai.PaisID;


    UPDATE TMPREGB0841 Tem, PAISES Pai SET
		Tem.CodigoPais   = Pai.PaisRegSITI
	WHERE Tem.CodigoPais   = Pai.PaisID;

    IF(Var_SucursalOrigen = SI) THEN
		UPDATE TMPREGB0841 Tem, SUCURSALES suc SET
			Tem.ClaveSucursal = suc.ClaveSucOpeCred
		WHERE Tem.ClaveSucursal = suc.SucursalID;
    END IF;

	DROP TABLE IF EXISTS TMP_SALDOFONDO;
	CREATE TEMPORARY TABLE TMP_SALDOFONDO(
		ClienteID 		BIGINT PRIMARY KEY,
		SaldoTotal 		DECIMAL(22,2),
		ProcentajePro 	DECIMAL(12,6));

	INSERT INTO TMP_SALDOFONDO
		SELECT ClienteID, SUM(SaldoFinal),
		CASE WHEN SUM(SaldoFinal) = Decimal_Cero THEN Decimal_Cero
			 WHEN SUM(SaldoFinal) <= Var_MtoFondoPro THEN Var_Cien
				  ELSE ROUND((Var_MtoFondoPro/SUM(SaldoFinal)*100),6) END
	FROM TMPREGB0841
	GROUP BY ClienteID;


	UPDATE TMPREGB0841 Inv, TMP_SALDOFONDO Tmp
	SET	Inv.MontoFondPro   =  ROUND((Inv.SaldoFinal * Tmp.ProcentajePro)/100,2),
		Inv.PorcFondoPro   =  Tmp.ProcentajePro
	WHERE Inv.ClienteID = Tmp.ClienteID AND Inv.Estatus IN('A','B','N');



	-- --------------------------------------
	-- CLAVE ACTIVIDADES SCIAN     ---
	-- --------------------------------------
    UPDATE TMPREGB0841 Tem, ACTIVIDADESBMX Bmx
		SET Tem.ActividadEco = IFNULL(Bmx.ActividadSCIANID,Clave_OtraActiv)
	WHERE Tem.ActividadBmx = Bmx.ActividadBMXID;




    UPDATE TMPREGB0841 SET
		RFC = FNCLIENTERFCREGCAL(Nombre,ApellidoPat,ApellidoMat,STR_TO_DATE(FechaNac,'%d%m%Y'))
	WHERE TRIM(RFC) = '';


    UPDATE TMPREGB0841 Tem, MAPEOCODIGOPOSTALCNBV Sit
		SET Tem.CodigoPostal = Sit.CPCNBV
	WHERE Tem.CodigoPostal = Sit.CPSAFI;

	UPDATE TMPREGB0841 Tem SET
	Tem.FecUltMov = Tem.FechaApertura
	WHERE Tem.FecUltMov = '01011900';

	/*
	 -- --------------------------------------------------------------------------------
	 --  CALCULO DE PORCENTAJE DE GARANTIA
	 -- --------------------------------------------------------------------------------
	*/

	DROP TABLE IF EXISTS TMP_GARCREINV_CLIENTE;
	CREATE TEMPORARY TABLE TMP_GARCREINV_CLIENTE(
		TipoProd		CHAR(1),
        ClienteID		INT,
		Cuenta 			BIGINT,
        CreditoID 		BIGINT,
		SaldoGar		DECIMAL(18,2),
		SaldoCred		DECIMAL(18,2),
        SaldoGloGar 	DECIMAL(18,2),
		SaldoGloCred	DECIMAL(18,2),
        Porcentaje		DECIMAL(18,6),
		PRIMARY KEY(TipoProd,Cuenta,CreditoID),
		KEY IDX_SAL_1 (ClienteID),
		KEY IDX_SAL_2 (ClienteID,CreditoID),
		KEY IDX_SAL_3 (ClienteID,TipoProd,Cuenta)
		);

	INSERT INTO TMP_GARCREINV_CLIENTE
		SELECT 'C',Cre.ClienteID, Blo.CuentaAhoID,Blo.Referencia, SUM(CASE WHEN Blo.NatMovimiento = Nat_Bloqueo THEN Blo.MontoBloq
									 ELSE Blo.MontoBloq *-1
								END) AS Saldo, Entero_Cero,Entero_Cero,Entero_Cero,Entero_Cero
		FROM BLOQUEOS Blo, CREDITOS Cre
		WHERE Blo.Referencia = Cre.CreditoID
        AND (Cre.FechTerminacion = '1900-01-01' OR Cre.FechTerminacion > Par_Fecha)
        AND DATE(Blo.FechaMov) <= Par_Fecha
		 AND Blo.TiposBloqID = Cons_BloqGarLiq
         AND Blo.CuentaAhoID IN (SELECT CuentaID FROM TMP_CREDAMPAVIG)
		GROUP BY Cre.ClienteID, Blo.CuentaAhoID,Blo.Referencia;


	INSERT INTO TMP_GARCREINV_CLIENTE
		SELECT 'I',Entero_Cero,Gar.InversionID,Gar.CreditoID,SUM(Gar.MontoEnGar),Entero_Cero,Entero_Cero,Entero_Cero,Entero_Cero
			FROM CREDITOINVGAR Gar
			WHERE FechaAsignaGar <= Par_Fecha
            GROUP BY Gar.InversionID,Gar.CreditoID;


	INSERT IGNORE TMP_GARCREINV_CLIENTE
		SELECT 'I',Entero_Cero,Gar.InversionID,Gar.CreditoID,SUM(Gar.MontoEnGar),Entero_Cero,Entero_Cero,Entero_Cero,Entero_Cero
			FROM HISCREDITOINVGAR Gar
			WHERE Gar.Fecha >= Par_Fecha
			  AND Gar.FechaAsignaGar <= Par_Fecha
              GROUP BY Gar.InversionID,Gar.CreditoID;


    UPDATE TMP_GARCREINV_CLIENTE cue,INVERSIONES inv
		SET cue.ClienteID = inv.ClienteID
	WHERE cue.TipoProd = 'I'
    AND cue.Cuenta = inv.InversionID;



    UPDATE TMP_GARCREINV_CLIENTE cre,SALDOSCREDITOS sal
		SET cre.SaldoCred = (sal.SalCapVigente+sal.SalCapAtrasado+sal.SalCapVencido+
							 sal.SalCapVenNoExi+sal.SalIntAtrasado+sal.SalIntVencido+
                             sal.SalIntProvision+sal.SalIntNoConta)
	WHERE cre.CreditoID = sal.CreditoID
    AND sal.FechaCorte = Par_Fecha;




    DROP TABLE IF EXISTS TMP_SAL_X_CREDITO;
	CREATE TEMPORARY TABLE TMP_SAL_X_CREDITO(
        ClienteID	INT,
		CreditoID	BIGINT,
        SaldoGar	DECIMAL(18,2),
		PRIMARY KEY(ClienteID,CreditoID));

	INSERT INTO TMP_SAL_X_CREDITO
    SELECT ClienteID,CreditoID,SUM(SaldoGar)
    FROM TMP_GARCREINV_CLIENTE
    GROUP BY ClienteID,CreditoID;

    UPDATE TMP_GARCREINV_CLIENTE cre,TMP_SAL_X_CREDITO sal
		SET cre.SaldoGloGar = sal.SaldoGar
	WHERE cre.CreditoID = sal.CreditoID;

	UPDATE TMP_GARCREINV_CLIENTE
		SET Porcentaje = ROUND(SaldoGloGar/SaldoCred,6)*100
	WHERE SaldoCred > 0;

    DROP TABLE IF EXISTS TMP_SAL_CREDITO_CLI;
	CREATE TEMPORARY TABLE TMP_SAL_CREDITO_CLI(
        ClienteID	INT,
        Cuenta		BIGINT,
        Porcentaje		DECIMAL(18,6),
		PRIMARY KEY(ClienteID,Cuenta));

    INSERT INTO TMP_SAL_CREDITO_CLI
		SELECT ClienteID,Cuenta,SUM(Porcentaje)
	FROM TMP_GARCREINV_CLIENTE
    GROUP BY ClienteID,Cuenta;

    UPDATE TMP_GARCREINV_CLIENTE aho, TMP_SAL_CREDITO_CLI sal
		SET aho.Porcentaje = sal.Porcentaje
	WHERE aho.ClienteID = sal.ClienteID
    AND aho.Cuenta = sal.Cuenta;


    UPDATE TMPREGB0841 tmp,TMP_GARCREINV_CLIENTE cli
    	SET tmp.PorcGarantia = cli.Porcentaje
    WHERE cli.TipoProd = 'I'
    AND cli.Cuenta =tmp.InstrumentoID
    AND tmp.TipoInstrumento IN(9,10);


    UPDATE TMPREGB0841 tmp,TMP_GARCREINV_CLIENTE cli
    	SET tmp.PorcGarantia = cli.Porcentaje
    WHERE cli.TipoProd = 'C'
    AND cli.Cuenta =tmp.InstrumentoID
    AND tmp.TipoInstrumento IN(1,2,3,4,5,6);


	/*
	 -- --------------------------------------------------------------------------------
	 --  FIN CALCULO DE PORCENTAJE DE GARANTIA
	 -- --------------------------------------------------------------------------------
	*/


	UPDATE TMPREGB0841 Tem SET
		MontoDepoIniOri = CASE WHEN IFNULL(MontoDepoIniOri,Decimal_Cero) < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(MontoDepoIniOri,Decimal_Cero) END,
		MontoDepoIniPes = CASE WHEN IFNULL(MontoDepoIniPes,Decimal_Cero) < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(MontoDepoIniPes,Decimal_Cero) END,
		SaldoIniPer 	= CASE WHEN IFNULL(SaldoIniPer,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(SaldoIniPer,Decimal_Cero) 	END,
		MtoDepositos 	= CASE WHEN IFNULL(MtoDepositos,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(MtoDepositos,Decimal_Cero)	END,
		MtoRetiros 		= CASE WHEN IFNULL(MtoRetiros,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(MtoRetiros,Decimal_Cero) 		END,
		IntDevNoPago 	= CASE WHEN IFNULL(IntDevNoPago,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(IntDevNoPago,Decimal_Cero) 	END,
		SaldoFinal 		= CASE WHEN IFNULL(SaldoFinal,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(SaldoFinal,Decimal_Cero) 		END,
		InteresMes 		= CASE WHEN IFNULL(InteresMes,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(InteresMes,Decimal_Cero) 		END,
		ComisionMes 	= CASE WHEN IFNULL(ComisionMes,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(ComisionMes,Decimal_Cero) 	END,
		MontoUltMov 	= CASE WHEN IFNULL(MontoUltMov,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(MontoUltMov,Decimal_Cero)		END,
		MontoFondPro 	= CASE WHEN IFNULL(MontoFondPro,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero ELSE IFNULL(MontoFondPro,Decimal_Cero)	END,
		PorcFondoPro	= CASE WHEN IFNULL(PorcFondoPro,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero WHEN IFNULL(PorcFondoPro,Decimal_Cero) > 100 THEN 100.000000 ELSE IFNULL(PorcFondoPro,Decimal_Cero) END,
		SaldoProm		= ABS(SaldoProm),
		GradoRiesgo		= IFNULL(GradoRiesgo,Clave_RiesBajo),
        Nacionalidad	= IFNULL(Nacionalidad,484),
        NumeroExt		= CASE WHEN NumeroExt = '' THEN 'SN' ELSE NumeroExt END,
		PorcGarantia 	= CASE WHEN IFNULL(PorcGarantia,Decimal_Cero) 	 < Decimal_Cero THEN Decimal_Cero WHEN IFNULL(PorcGarantia,Decimal_Cero) > 100 THEN 100.000000 ELSE IFNULL(PorcGarantia,Decimal_Cero) END;


	IF( Par_NumReporte = Rep_Excel) THEN
		SELECT 	Var_Periodo,
				Var_ClaveEntidad,
				For_0841 AS Formulario,
				ClienteID,
				FNLIMPIACARACTERESGENREG(Nombre,CaseMayus) AS Nombre,

                FNLIMPIACARACTERESGENREG(ApellidoPat,CaseMayus) AS ApellidoPat,
                FNLIMPIACARACTERESGENREG(ApellidoMat,CaseMayus) AS ApellidoMat,
                PersJuridica,
				GradoRiesgo,
                ActividadEco,

                Nacionalidad,
                FechaNac,
                REPLACE(RFC,'Ã‘','N') AS RFC,
				FNLIMPIACARACTERESGENREG(CURP,CaseMayus) AS CURP,
                Genero,

                FNLIMPIACARACTERESGENREG(Calle,CaseMayus) AS Calle,
                FNLIMPIACARACTERESGENREG(NumeroExt,CaseMayus) AS NumeroExt,
                FNLIMPIACARACTERESGENREG(ColoniaDes,CaseMayus) AS ColoniaDes,
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
                ROUND(TipoProducto,Entero_Cero) AS TipoInstrumento,

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
			IFNULL(FNLIMPIACARACTERESGENREG(Nombre,CaseMayus),Cadena_Vacia),';',

			IFNULL(FNLIMPIACARACTERESGENREG(ApellidoPat,CaseMayus),Cadena_Vacia),';',
			IFNULL(FNLIMPIACARACTERESGENREG(ApellidoMat,CaseMayus),Cadena_Vacia),';',
			IFNULL(PersJuridica,Cadena_Vacia),';',
			IFNULL(GradoRiesgo,Cadena_Vacia),';',
			IFNULL(ActividadEco,Cadena_Vacia),';',

			IFNULL(Nacionalidad,Cadena_Vacia),';',
			IFNULL(FechaNac,Cadena_Vacia),';',
        IFNULL(REPLACE(RFC,'Ã‘','N'),Cadena_Vacia),';',
			IFNULL(FNLIMPIACARACTERESGEN(CURP,CaseMayus),Cadena_Vacia),';',
			IFNULL(Genero,Cadena_Vacia),';',

			IFNULL(FNLIMPIACARACTERESGENREG(Calle,CaseMayus),Cadena_Vacia),';',
			IFNULL(FNLIMPIACARACTERESGENREG(NumeroExt,CaseMayus),Cadena_Vacia),';',
			IFNULL(FNLIMPIACARACTERESGENREG(ColoniaDes,CaseMayus),Cadena_Vacia),';',
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
			IFNULL(ROUND(TipoProducto,Entero_Cero),Cadena_Vacia),';',

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