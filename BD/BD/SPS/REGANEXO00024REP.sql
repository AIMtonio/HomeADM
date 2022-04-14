-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGANEXO00024REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGANEXO00024REP`;
DELIMITER $$

CREATE PROCEDURE `REGANEXO00024REP`(
	-- ==========================================================================
	-- ----------- SP PARA OBTENER DATOS PARA EL REPORTE DE ANEXOYFAP -----------
	-- ==========================================================================
	Par_Fecha           DATE,				-- Fecha de generacion del reporte
	Par_NumReporte      INT,				-- Tipo de reporte 1: Excel 2: CVS
	Par_NumDecimales    INT,				-- Numero de Decimales en Cantidades o Montos

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
    DECLARE Var_MtoFondoPro		DECIMAL(21,2);  -- Monto del Fondo de Proteccion
    DECLARE Var_ValorUDI		DECIMAL(21,2);  --  Valor de la UDI en el Periodo
    DECLARE Var_FechaUDI		DATE;
    DECLARE Var_FechaHisUDI		DATETIME;
    DECLARE Var_NumErr			INT;
    DECLARE Var_ErrMen			VARCHAR(150);

	DECLARE Var_NumCliente		INT;			-- Numero de Cliente Especifico
    DECLARE Var_FechaHisDet		DATE;			-- Variable para obtener la Fecha historica
	DECLARE Var_SucursalOrigen	CHAR(1);		-- Valor de PARAMREGULATORIOS para mostrar la sucursal origen del cliente.
    DECLARE Var_FechaCieCed		DATE;			-- Fecha de Consulta para las CEDES
    DECLARE Var_TipoCede		INT;			-- Valor para el intrumento en CEDES

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
	DECLARE SI 					CHAR(1);
	DECLARE Con_NO 					CHAR(1);
	DECLARE Fisica				CHAR(1);

    DECLARE Moral				CHAR(1);
	DECLARE Fisica_empre		CHAR(1);
	DECLARE Masculino			CHAR(1);
	DECLARE Femenino    		CHAR(1);
    DECLARE Apellido_Vacio		CHAR(2);

    DECLARE Clave_CertBursatil	INT;
	DECLARE Clave_DepVista		INT;
	DECLARE CLave_Periodicidad	INT;

    DECLARE Clave_TipoTasa		INT;
	DECLARE Clave_TasaRefe		INT;
	DECLARE Clave_OpeDiferen	INT;
	DECLARE Clave_FrecPlazo		INT;
	DECLARE No_RetAntici		INT;

    DECLARE Si_RetAntici		INT;
	DECLARE Tip_MovAbono		CHAR(1);			-- Tipo de movimiento para Abono a cuenta
    DECLARE Tip_MovCargo		CHAR(1);			-- Tipo de movimiento para Cargo a cuenta
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
    DECLARE Fecha_Fort			VARCHAR(10);
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
    DECLARE Prog_Cierre			VARCHAR(20);
    DECLARE Var_FecMesAnt		DATE;
    DECLARE Monto_UDIS			INT;
    DECLARE Dias_Periodo		INT;
    DECLARE Var_Cien			DECIMAL(16,6);
	DECLARE Clave_PerOtro		INT;
	DECLARE Clave_PerMes		INT;
    DECLARE Var_DireccionTrabajo INT;

	DECLARE Con_Registrado		CHAR(1);
    DECLARE Est_Vencido			CHAR(1);

	-- Asignacion de Constantes
	SET Rep_Excel       	:= 1;		       	-- Opcion de reporte para excel
	SET Rep_Csv				:= 2;  				-- Opcion de reporte para CVS
	SET Entero_Cero     	:= 0; 				-- Constante Cero
	SET Cadena_Vacia    	:= '';				-- Constante Vacia
	SET Decimal_Cero    	:= 0.00;   			-- Constante Cero decimales

    SET Fecha_Vacia     	:= '1900-01-01';   	-- Fecha Vacia
    SET Fecha_Nula			:= '01011900';		-- Formato para fecha Vacia en Regulatoriosdd-mm-aaaa
    SET Fecha_Fort			:= '01-01-1900';	-- Fecha vacia en cadena
	SET Cue_Activa      	:= 'A';             -- Cuenta Con Estatus Activo
	SET Cue_Bloqueada   	:= 'B';   			-- Cuenta Con Estatus Bloqueado
	SET Ins_CueAhorro  		:= '1';   			-- Tipo de Instrumento: Cuenta de Ahorro

    SET Ins_InvPlazo   		:= '2';   			-- Tipo de Instrumento: Inversiones Plazo
	SET Cons_BloqGarLiq		:= 8;				-- Tipo de Bloqueo: Por Gtia Liquida
	SET SI 					:=	'S';			-- Constante SI
	SET Con_NO				:=	'N'; 			-- Constante NO

    SET Fisica				:=	'F';			-- Tipo de persona fisica
	SET Moral				:=	'M';			-- Tipo de persona moral
	SET Fisica_empre		:=	'A';			-- Persona Fisica Con Actividad Empresarial
	SET Masculino			:=	'M';			-- Sexo masculino
	SET Femenino			:=	'F';			-- Sexo femenino

    SET Apellido_Vacio		:=  'ND';			-- Clave del apellido materno vacio
    SET Clave_CertBursatil 	:= 21250201;		-- Clave de registro del certificado bursatil
    SET Clave_DepVista		:= 100;				-- Clave para Dep a la Vista
    SET Clave_Periodicidad 	:= 7;				-- Clave para Mensual
    SET Clave_TipoTasa 		:= 101;				-- Clave Tipo de Tasa - Fija

    SET Clave_TasaRefe		:= 102;				-- Clave de sin tasa de referencia
    SET Clave_OpeDiferen 	:= 101; 			-- Suma del Diferencial
    SET Clave_FrecPlazo		:= 30;				-- Frecuencua Mensual
    SET No_RetAntici		:= 102;				-- Clave No Retiro Anticipado
    SET Si_RetAntici		:= 101;				-- Clave Si Retiro Anticipado

    SET Tip_MovAbono		:= 'A';				-- Tipo de movimiento para abono a cuenta
    SET Tip_MovCargo		:= 'C';				-- Tipo de movimiento para Cargo a cuenta
    SET Dep_ConInteres		:= '210101020100';	-- Depositos a la vista con interes libres de gravamen
	SET Dep_ConIntCre		:= '210101020200';	-- Depositos a la vista con interes libres de gravamen que amparan creditos
	SET Dep_SinInteres		:= '210101010100';	-- Depositos a la vista sin interes libres de gravamen
	SET Dep_SinIntCre		:= '210101010200';	-- Depositos a la vista sin interes libres de gravamen que amparan creditos

    SET Dep_AhoLibGrav		:= '210102010000';	-- Depositos de ahorro libres de gravamen
	SET Dep_AhoAmpCre		:= '210102020000';	-- Depositos de ahorro que amparan creditos
	SET Cuen_SinMovimiento	:= '240120000000';	-- Cuentas sin movimiento

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
	SET Moneda_Extran		:= 4;				-- Moneda Extranjera
	SET Nat_Bloqueo			:= 'B';				-- Naturaleza Bloqueado
	SET Est_Pagado			:= 'P'; 			-- Estatus Pagado

    SET Clave_OtraActiv		:= 81299;			-- Clave Otra Actividad
	SET Rango_Uno			:= 101; 			-- 1 a 7 Dias
	SET Rango_Dos			:= 102; 			-- 8 a 30 Dias
	SET Rango_Tres			:= 103; 			-- 31 a 90 Dias
	SET Rango_Cuatro		:= 104; 			-- 91 a 180 dias

    SET Rango_Cinco			:= 105; 			-- 181 - 365 dias
	SET Rango_Seis			:= 106; 			-- 366 - 730 dias
	SET Rango_Siete			:= 107; 			-- > 730 dias
	SET Dep_VisCnInt		:= 3;				-- Deposito a la vista con intereses
	SET Dep_VisIntCre 		:= 4;				-- Deposito a la vista con inte ampara credito

    SET Dep_VisSnInt 		:= 1; 				-- Deposito a la vista sin intereses
	SET Dep_VisSnIntCre 	:= 2;				-- Deposito a la vista sin interes ampara credito
	SET Dep_AhoInte			:= 5;   			-- Deposito de Ahorro
	SET Dep_AhoCre 			:= 6;				-- Deposito de ahorro que ampara credito
	SET Dep_Plazo 			:= 9; 				-- Deposito a plazo

    SET Dep_PlazoAmpCre 	:= 10; 				-- Deposito a plazo que amparan creditos
    SET CaseMayus			:= 'MA';			-- Convertir a Mayusculas
    SET Prog_Cierre			:= 'CIERREMESAHORRO';
    SET Monto_UDIS			:= 25000;			-- Fondo de proteccion
    SET Salida_NO			:= 'N';

    SET Var_Cien 			:= 100.000000;  	-- Valor de 100 por ciento
    SET Clave_PerOtro		:= 7;				-- Periodicidad de pagos Otros
	SET Clave_PerMes		:= 3;				-- Periodicidad de Pagos Mensual
	SET Var_DireccionTrabajo := 3;
	SET Var_TipoCede 		:= 11;				-- Depositos de ahorro libres de gravamen para CEDES

	SET Con_Registrado		:= 'R';							-- Estatus Registrado
    SET Est_Vencido			:= 'V';

	SET Var_Periodo = CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),1,4),
							  SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),5,2));

	SET Var_ClaveEntidad	:= IFNULL((SELECT Par.ClaveEntidad
										FROM PARAMETROSSIS Par
										WHERE Par.EmpresaID = Par_EmpresaID), Cadena_Vacia);

	SELECT IFNULL(MostrarSucursalOrigen, Con_NO) INTO Var_SucursalOrigen
    FROM PARAMREGULATORIOS LIMIT 1;

	SET Cliente_Inst    := (SELECT ClienteInstitucion FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);
    SET Var_FechaCieInv := (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Par_Fecha);
	SET Var_FechaCieCed	:= (SELECT MAX(FechaCorte) FROM SALDOSCEDES WHERE FechaCorte <= Par_Fecha);
	SET Var_NumCliente	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico' LIMIT 1);

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


	DROP TABLE IF EXISTS TMPREGANEXO;

	CREATE TEMPORARY TABLE TMPREGANEXO(
		Nombre					VARCHAR(200),
        ApellidoPat				VARCHAR(200),
		ApellidoMat				VARCHAR(200),
        ClienteID				INT,
		NumeroCuenta			VARCHAR(20),

        TipoPersona 			INT,
		ActividadEconomica		VARCHAR(10),
        Nacionalidad			INT,
		FechaNac				VARCHAR(10),
        RFC						VARCHAR(20),

		CURP					VARCHAR(18),
        Calle					VARCHAR(250),
        NumeroExt				VARCHAR(50),
        ColoniaID				VARCHAR(80),
        CodigoPostal			VARCHAR(20),

        Localidad				VARCHAR(20),
        MunicipioID				INT,
        EstadoID				INT,
        CodigoPais				VARCHAR(20),
        Direccion				VARCHAR(250),

		TelefonoCasa 			VARCHAR(10),
		TelefonoCelular			VARCHAR(20),
		TelefonoOficina			VARCHAR(10),
		TelefonoLocalizacion	VARCHAR(10),
		RelacionLocalizacion	VARCHAR(20),

		Correo 					VARCHAR(50),
        ClaveSucursal 			INT,
		NombreSucursal			VARCHAR(50),
		DireccionSucursal		VARCHAR(250),
		ClasfContable			VARCHAR(20),

		TipoCuenta				VARCHAR(20),
		NumContrato				VARCHAR(20),
		FechaContrato			VARCHAR(20),
		FechaVencimiento		VARCHAR(20),
		PlazoDeposito			INT,

        periodicidad			INT,
        TasaPactada				DECIMAL(16,2),
        FechaUltimoDeposito		VARCHAR(10),
        SaldoUltimoDepostito	DECIMAL(16,2),
		PorcFondoPro			DECIMAL(16,6),

        SaldoCapital			DECIMAL(21,2),
  		IntDevNoPago			DECIMAL(21,2),
		SaldoFinal				DECIMAL(21,2),
		TipoInstrumento			INT,
        InstrumentoID			BIGINT,

		INDEX TMPREGANEXO_idx1(ClienteID),
		INDEX TMPREGANEXO_idx2(EstadoID, MunicipioID, ColoniaID),
		INDEX TMPREGANEXO_idx3(TipoInstrumento),
		INDEX TMPREGANEXO_idx4(InstrumentoID),
		INDEX TMPREGANEXO_idx5(TasaPactada),
		INDEX TMPREGANEXO_idx6(Nacionalidad),
		INDEX TMPREGANEXO_idx7(CodigoPais),
		INDEX TMPREGANEXO_idx8(ClaveSucursal),
		INDEX TMPREGANEXO_idx9(ActividadEconomica),
		INDEX TMPREGANEXO_idx10(NumeroCuenta)
	)ENGINE=INNODB DEFAULT CHARSET=LATIN1;

	DROP TABLE IF EXISTS TMP_FACTSALDO;
	CREATE temporary TABLE TMP_FACTSALDO(
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
	SET Var_IniMes 		 := DATE_ADD(Par_Fecha, INTERVAL ((DAY(Par_Fecha)*-1) + 1) DAY);
	SET Var_FecMesAnt 	 := DATE_SUB(Var_IniMes, INTERVAL 1 DAY);

	SET	Var_FecBitaco	:= NOW();

	-- Valor de Monedas
	DROP TABLE IF EXISTS TMPHISMONEDAS;
	CREATE TEMPORARY TABLE TMPHISMONEDAS
		SELECT MonedaId, MAX(FechaRegistro) AS Fecha, ROUND(MAX(TipCamDof),2) AS Valor
			FROM `HIS-MONEDAS`
			WHERE FechaRegistro < Var_IniMes
			GROUP BY MonedaID;

	CREATE INDEX idx_TMPHISMONEDAS_1 ON TMPHISMONEDAS(MonedaID);

	UPDATE TMPHISMONEDAS Tem, `HIS-MONEDAS` His
		SET Tem.Valor = ROUND(His.TipCamDof,2)
		WHERE Tem.MonedaID = His.MonedaId
		AND Tem.Fecha = His.FechaRegistro;

	INSERT INTO TMPREGANEXO

		SELECT
				-- Nombre(s) / Razon Social
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
					 ELSE Entero_Cero
				END ,

				-- Apellido Materno
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Apellido_Vacio) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Entero_Cero
				END,

                -- ID del cliente
                His.ClienteID,

				-- Numero Cuenta
				CONVERT(His.CuentaAhoID, CHAR),

                -- Tipo de Persona
				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
				END,

                -- Actividad Economica
				Cli.ActividadBancoMX,

                -- Nacionalidad del Ahorrador
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.LugarNacimiento
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS LugarNacimiento,

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

                -- Calle
				IFNULL(Dir.Calle,Cadena_Vacia),

                -- Numero Exterior
				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),

                -- Colonia ID
				IFNULL(Dir.ColoniaID,Entero_Cero),

                -- Codigo Postal
				IFNULL(Dir.CP,Entero_Cero),

                -- Localidad
				IFNULL(Dir.LocalidadID, Entero_Cero),

                -- Municipio
				IFNULL(Dir.MunicipioID, Entero_Cero) AS MunicipioClave,

                -- Estado
				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,

                -- Codigo Pais
				CASE WHEN Cli.TipoPersona = Fisica OR  Cli.TipoPersona = Fisica_empre THEN Cli.PaisResidencia
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS PaisResidencia,

                -- Direccion completa(trabajo)
                IFNULL(Dir.DireccionCompleta,Cadena_Vacia),

                -- Telefono de casa
				CASE WHEN CHAR_LENGTH(Cli.Telefono) = 10 THEN
						Cli.Telefono
					  WHEN CHAR_LENGTH(Cli.Telefono) > 10 THEN
						SUBSTRING(Cli.Telefono,1,10)
					  ELSE
						LPAD(Cli.Telefono,10,'0')
				END,

                -- Telefono de oficina
				Cli.TelTrabajo,

                -- Telefono  Celular
				CASE WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) = 10 THEN
						Cli.TelefonoCelular
					  WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) > 10 THEN
						SUBSTRING(Cli.TelefonoCelular,1,10)
					  ELSE
						LPAD(Cli.TelefonoCelular,10,'0')
				END,

                -- Telefono  de localizacion
				IFNULL(Cadena_Vacia,Cadena_Vacia),

                -- Relacion de la localizacion
                IFNULL(Cadena_Vacia,Cadena_Vacia),

                -- Correo electronico
                Cli.Correo,

                 -- Clave de sucursal
                CASE WHEN Var_SucursalOrigen = SI THEN Cli.SucursalOrigen
					 ELSE Suc.ClaveSucOpeCred END AS ClaveSucursal,

                -- Nombre de sucursal
                IFNULL(Suc.NombreSucurs,Cadena_Vacia),

                -- Direccion de sucursal
                IFNULL(Suc.DirecCompleta,Cadena_Vacia),

                -- Clasficacion Contable
				CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
					 Dep_ConInteres	-- a la vista, con intereses, libres de gravamen.
					 WHEN Tip.GeneraInteres = Con_NO AND ClasificacionConta = Dep_Vista  THEN
					 Dep_SinInteres -- a la vista, sin intereses, libres de gravamen
					 WHEN ClasificacionConta = Dep_Ahorro  THEN
					 Dep_AhoLibGrav -- depoitos de ahorro, libres de gravamen
				END,

                -- Tipo de Cuenta
                'INDIVIDUALES',

                -- Numero Contrato
                CONVERT(His.CuentaAhoID, CHAR),

                -- Fecha de Apertura
                IFNULL(DATE_FORMAT(His.FechaApertura,'%d%m%Y'),Fecha_Nula),

                -- Fecha Vencimiento del Deposito
				Cadena_Vacia,

                -- Plazo del deposito
                Entero_Cero,

                -- Periodicidad
				CASE WHEN Tip.GeneraInteres = SI AND Tip.TipoInteres = 'D' THEN Clave_PerOtro
					 WHEN Tip.GeneraInteres = Con_NO AND Tip.TipoInteres = 'D' THEN Clave_PerMes
                     ELSE Clave_PerOtro END AS Periodicidad,

                -- Valor de la tasa pactada
                His.TasaInteres,

                -- Fecha de registro de la cuenta
				CASE WHEN Cue.FechaDepInicial = Fecha_Vacia THEN
							IFNULL(DATE_FORMAT(His.FechaApertura,'%d%m%Y'),Fecha_Nula)
					 ELSE
						IFNULL(DATE_FORMAT(Cue.FechaDepInicial,'%d%m%Y'),Fecha_Nula)
					 END,

                -- Monto de Apertura de cuenta
				Cue.MontoDepInicial,

                -- Porcentaje Fondo Pro
				Decimal_Cero,

                -- Saldo Capital
				His.Saldo,

                -- INT. devengados no pagados
				Entero_Cero AS IntDevNoPago,

                -- Saldo Cuenta al Final del Periodo
				IFNULL(His.Saldo,Entero_Cero) AS SaldoFinal ,

                -- Tipo de instrumento
                CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisCnInt	-- a la vista, con intereses, libres de gravamen.
					 WHEN Tip.GeneraInteres = Con_NO AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisSnInt -- a la vista, sin intereses, libres de gravamen
					 WHEN ClasificacionConta = Dep_Ahorro THEN
					 Dep_AhoInte	-- depoitos de ahorro, libres de gravamen
				END,

                -- Instrumento
                His.CuentaAhoID

			FROM `HIS-CUENTASAHO` His,
				 CUENTASAHO Cue,
				 TIPOSCUENTAS Tip,
				 SUCURSALES Suc,
				 CLIENTES Cli
                 LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, Con_NO) = SI

			WHERE His.Fecha = Var_FechaHis
			  AND His.Estatus IN (Cue_Activa, Cue_Bloqueada, Est_Cancelado)
              AND His.CuentaAhoID = Cue.CuentaAhoID
			  AND His.ClienteID = Cli.ClienteID
              AND His.ClienteID <> Cliente_Inst
              AND Tip.EsBancaria = Con_NO
			  AND His.TipoCuentaID = Tip.TipoCuentaID
			  AND Cli.SucursalOrigen = Suc.SucursalID
			  AND Cue.Estatus <> Con_Registrado;			-- Se valida que la cuenta de ahorro No tiene un Registo Contable Puesto que la cuenta Se registra y posteriormente se cancela

	-- Actualización de los datos de las cuentas de ahorro

	-- Actualizo las cuentas de tipo 6 a periodicidad Mensual
	IF(Var_NumCliente = 15) THEN

		DROP TABLE IF EXISTS TMP_CUENTASAHOGENINTERES;
        CREATE TEMPORARY TABLE TMP_CUENTASAHOGENINTERES
        SELECT CuentaAhoID FROM CUENTASAHO WHERE TipoCuentaID = 6;
        CREATE INDEX idx_1 ON TMP_CUENTASAHOGENINTERES(CuentaAhoID);

		UPDATE TMPREGANEXO Temp, TMP_CUENTASAHOGENINTERES Cue SET
			periodicidad = Clave_PerMes
		WHERE Temp.InstrumentoID = Cue.CuentaAhoID;

	END IF;

	-- Se actualiza la tasa de interes y de periodo para las cuentas de ahorro
	UPDATE TMPREGANEXO Tem, TASASAHORRO Tap SET
		Tem.TasaPactada	= ROUND(Tap.Tasa,6)
	WHERE Tem.TasaPactada = Tap.TipoCuentaID;

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
		SELECT CuentaAhoID, SUM(CASE WHEN NatMovimiento = Nat_Bloqueo THEN MontoBloq
									 ELSE MontoBloq *-1
								END) AS Saldo
		FROM BLOQUEOS
		WHERE DATE(FechaMov) <= Par_Fecha
		 AND TiposBloqID = Cons_BloqGarLiq
		GROUP BY CuentaAhoID;


	UPDATE TMPREGANEXO Tem, TMP_GTIALIQ_AHORRO Gar SET
        TipoInstrumento = CASE  WHEN TipoInstrumento  = Dep_VisSnInt THEN Dep_VisSnIntCre 	-- a la vista, sin intereses, que amparan credito otorgados.
								WHEN TipoInstrumento  = Dep_VisCnInt THEN Dep_VisIntCre 	-- a la vista, con intereses, que amparan credito otorgados.
								WHEN TipoInstrumento  = Dep_AhoInte  THEN Dep_AhoCre 		-- deposito de ahorro, que amparan credito otorgados.
						  END,
		ClasfContable 	= CASE  WHEN ClasfContable    = Dep_ConInteres THEN Dep_ConIntCre	-- a la vista, sin intereses, que amparan credito otorgados.
								WHEN ClasfContable    = Dep_SinInteres THEN Dep_SinIntCre 	-- a la vista, con intereses, que amparan credito otorgados.
								WHEN ClasfContable    = Dep_AhoLibGrav THEN Dep_AhoAmpCre 	-- deposito de ahorro, que amparan credito otorgados.
						  END
    WHERE Tem.InstrumentoID = Gar.Cuenta
		AND Gar.Saldo > Entero_Cero;

	DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;


    -- -----------------------------------------
	-- INVERSIONES A PLAZO ---------------------
	-- -----------------------------------------

	INSERT INTO TMPREGANEXO

		SELECT
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
					 ELSE Entero_Cero
				END ,

				-- Apellido Materno
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
                           CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Entero_Cero
				END,

                -- ID del cliente
				Inv.ClienteID,

				-- Numero Cuenta
				Inv.CuentaAhoID,

                -- Tipo Persona
				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
				END,

                -- Actividad Economica
				Cli.ActividadBancoMX,

                -- Pais de Nacimiento
				CASE WHEN Cli.TipoPersona = Fisica OR  Cli.TipoPersona = Fisica_empre THEN Cli.LugarNacimiento
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS LugarNacimiento,

                -- Fecha de Nacimient
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

                -- Calle
				IFNULL(Dir.Calle,Cadena_Vacia),

                -- Numero Ext
				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),

                -- Colonia ID
				IFNULL(Dir.ColoniaID,Entero_Cero),

                -- Codigo Postal
				IFNULL(Dir.CP,Entero_Cero),

                -- Localidad
				IFNULL(Dir.LocalidadID, Entero_Cero),

                -- Municipio
				IFNULL(Dir.MunicipioID, Entero_Cero) AS MunicipioClave,

                -- Estado
				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,

				-- Pais
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.PaisResidencia
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS PaisResidencia,

                -- Direccion completa(trabajo)
                IFNULL(Dir.DireccionCompleta,Cadena_Vacia),

                -- Telefono de casa
				CASE WHEN CHAR_LENGTH(Cli.Telefono) = 10 THEN
						Cli.Telefono
					  WHEN CHAR_LENGTH(Cli.Telefono) > 10 THEN
						SUBSTRING(Cli.Telefono,1,10)
					  ELSE
						LPAD(Cli.Telefono,10,'0')
				END,

                -- Telefono de oficina
				IFNULL(Cli.TelTrabajo,Cadena_Vacia),

                -- Telefono  Celular
				CASE WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) = 10 THEN
						Cli.TelefonoCelular
					  WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) > 10 THEN
						SUBSTRING(Cli.TelefonoCelular,1,10)
					  ELSE
						LPAD(Cli.TelefonoCelular,10,'0')
				END,

                -- Telefono  de localizacion
				IFNULL(Cadena_Vacia,Cadena_Vacia),

                -- Relacion de la localizacion
                IFNULL(Cadena_Vacia,Cadena_Vacia),

                -- Correo electronico
                Cli.Correo,

                -- Clave de sucursal
				CASE WHEN Var_SucursalOrigen = SI THEN Cli.SucursalOrigen
					 ELSE Suc.ClaveSucOpeCred END,

                -- Nombre de sucursal
                IFNULL(Suc.NombreSucurs,Cadena_Vacia),

                -- Direccion de sucursal
                IFNULL(Suc.DirecCompleta,Cadena_Vacia),

                -- Clasficacion Contable
                Dep_PlaLibGrav,

                -- Tipo de Cuenta
                'INDIVIDUALES',

                -- Numero Contrato
                Inv.InversionID,

                -- Fecha de Apertura
                IFNULL(DATE_FORMAT(Inv.FechaInicio ,'%d%m%Y'),Fecha_Nula),

                -- Fecha Vencimiento del Deposito
				IFNULL(DATE_FORMAT(Inv.FechaVencimiento ,'%d%m%Y'),Fecha_Nula),

                -- Plazo del deposito
                Inv.Plazo,

                -- Periodicidad
                Clave_PerOtro,

                -- -Valor Tasa pactada
				Inv.Tasa,

                -- Fecha registro de la inversion
                IFNULL(DATE_FORMAT(Inv.FechaInicio ,'%d%m%Y'),Fecha_Nula),

				-- Saldo de resgistro de Inversion
                IFNULL(Inv.Monto,Decimal_Cero),

                -- Porcentaje Fondo Pro
				Decimal_Cero,

                -- Saldo Capital
				Inv.Monto,

                -- INT. devengados no pagados
                CASE WHEN Inv.Estatus IN (Est_Pagado,Est_Cancelado)  THEN Decimal_Cero
						ELSE Inv.SaldoProvision  END AS IntDevNoPago,

				-- Saldo Cuenta al Final del Periodo
                CASE WHEN Inv.Estatus IN(Est_Pagado,Est_Cancelado) THEN Decimal_Cero ELSE
				(Inv.Monto + Inv.SaldoProvision) END AS SaldoFinal,

                -- Tipo de instrumento
                Dep_Plazo AS TipoProducto,

                -- Intrumento ID
                Inv.InversionID

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
				( Inv.Estatus = Est_Vencido AND Inv.FechaVencimiento BETWEEN Var_IniMes AND Var_FechaCieInv)
                )
          AND Inv.TipoInversionID = Cat.TipoInversionID
		  AND Cli.SucursalOrigen = Suc.SucursalID
		ORDER BY Suc.SucursalID, Inv.InversionID;

	-- Actualización de los datos de las Inversiones

	-- Validacion de las Inversiones que Fueron Canceladas pero que Generaron un registro Contable
	-- Se crea la tabla para las Inversiones que nacen y cancelan el el mismo mes
	DROP TABLE IF EXISTS TMP_INVERSIONESCANCELADAS;
    CREATE TEMPORARY TABLE TMP_INVERSIONESCANCELADAS
	    SELECT InversionID, NumTransaccion
	    FROM INVERSIONES WHERE Estatus = Est_Cancelado AND FechaActual BETWEEN Var_IniMes AND Var_FechaCieInv AND ProgramaID LIKE '%cancelaInversiones%';
    CREATE INDEX idx1 ON TMP_INVERSIONESCANCELADAS(InversionID);
    CREATE INDEX idx2 ON TMP_INVERSIONESCANCELADAS(NumTransaccion);

    -- Se obtiene la maxima feche del historico de detalle poliza
    SELECT MAX(Fecha) INTO Var_FechaHisDet FROM `HIS-DETALLEPOL`;

    -- Se valida si se buscara en el historico o actual
    IF( DATE(Par_Fecha) <=  Var_FechaHisDet ) THEN

		-- Consulta de Inversiones en el historico
    	DROP TABLE IF EXISTS TMP_INVERSIONESCONTABLES;
	    CREATE TEMPORARY TABLE TMP_INVERSIONESCONTABLES
		    SELECT det.Instrumento AS InversionID , MAX(det.NumTransaccion ) AS NumTransaccion
            FROM `HIS-DETALLEPOL`  det,
				TMP_INVERSIONESCANCELADAS tmp
                WHERE det.Fecha BETWEEN Var_IniMes AND Var_FechaCieInv AND
				det.Instrumento = tmp.InversionID AND det.NumTransaccion = tmp.NumTransaccion
			GROUP BY det.Instrumento;
		CREATE INDEX idx1 ON TMP_INVERSIONESCONTABLES(InversionID);

	ELSE

		-- Consulta de Inversiones en el actual
		DROP TABLE IF EXISTS TMP_INVERSIONESCONTABLES;
	    CREATE TEMPORARY TABLE TMP_INVERSIONESCONTABLES
	    	SELECT det.Instrumento AS InversionID , MAX(det.NumTransaccion ) AS NumTransaccion
            FROM DETALLEPOLIZA  det,
				TMP_INVERSIONESCANCELADAS tmp
                WHERE det.Fecha BETWEEN Var_IniMes AND Var_FechaCieInv AND
				det.Instrumento = tmp.InversionID AND det.NumTransaccion = tmp.NumTransaccion
			GROUP BY det.Instrumento;
		CREATE INDEX idx1 ON TMP_INVERSIONESCONTABLES(InversionID);

    END IF;

    -- elimino las inversiones que si generaron un movimiento contable(si se deben mostrar en el reporte)
    DELETE FROM TMP_INVERSIONESCANCELADAS WHERE InversionID IN (SELECT InversionID FROM TMP_INVERSIONESCONTABLES);

    -- elimino las inversiones que nacieron y se cancelaron en el mismo dia y que no tiene un movimiento contable
   	DELETE FROM TMPREGANEXO
	WHERE  InstrumentoID IN (SELECT InversionID FROM TMP_INVERSIONESCANCELADAS) AND
			  TipoInstrumento = Dep_Plazo;


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
			  AND Gar.FechaAsignaGar <= Par_Fecha;


	UPDATE TMPREGANEXO Tem, TMP_INVGAR Gar SET
		Tem.TipoInstrumento = CASE WHEN Tem.TipoInstrumento  = Dep_Plazo THEN Dep_PlazoAmpCre -- a la vista, sin intereses, que amparan creditos otorgados.
					   ELSE Tem.TipoInstrumento END,

        Tem.ClasfContable = CASE WHEN Tem.TipoInstrumento  = Dep_Plazo THEN Dep_PlaLibAmpCre -- a la vista, sin intereses, que amparan creditos otorgados.
					   ELSE Tem.ClasfContable END
		WHERE Tem.InstrumentoID = Gar.InversionID
		  AND Tem.TipoInstrumento = Dep_Plazo;


	DROP TABLE IF EXISTS TMP_INVGAR;


	-- -----------------------------------------
	-- CEDES ----------------------------------
	-- -----------------------------------------

	INSERT INTO TMPREGANEXO

		SELECT
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
					 ELSE Entero_Cero
				END ,

				-- Apellido Materno
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
                           CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Entero_Cero
				END,

                -- ID del cliente
				Ced.ClienteID,

				-- Numero Cuenta
				Ced.CuentaAhoID,

                -- Tipo Persona
				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
				END,

                -- Actividad Economica
				Cli.ActividadBancoMX,

                -- Pais de Nacimiento
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.LugarNacimiento
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END  AS LugarNacimiento,

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

                -- Calle
				IFNULL(Dir.Calle,Cadena_Vacia),

                -- Numero Ext
				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),

                -- Colonia ID
				IFNULL(Dir.ColoniaID,Entero_Cero),

                -- Codigo Postal
				IFNULL(Dir.CP,Entero_Cero),

                -- Localidad
				IFNULL(Dir.LocalidadID, Entero_Cero),

                -- Municipio
				IFNULL(Dir.MunicipioID, Entero_Cero) AS MunicipioClave,

                -- Estado
				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,

				-- Pais
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.PaisResidencia
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS PaisResidencia,

                -- Direccion completa(trabajo)
                IFNULL(Dir.DireccionCompleta,Cadena_Vacia),

                -- Telefono de casa
				CASE WHEN CHAR_LENGTH(Cli.Telefono) = 10 THEN
						Cli.Telefono
					  WHEN CHAR_LENGTH(Cli.Telefono) > 10 THEN
						SUBSTRING(Cli.Telefono,1,10)
					  ELSE
						LPAD(Cli.Telefono,10,'0')
				END,

                -- Telefono de oficina
				IFNULL(Cli.TelTrabajo,Cadena_Vacia),

                -- Telefono  Celular
				CASE WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) = 10 THEN
						Cli.TelefonoCelular
					  WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) > 10 THEN
						SUBSTRING(Cli.TelefonoCelular,1,10)
					  ELSE
						LPAD(Cli.TelefonoCelular,10,'0')
				END,

                -- Telefono  de localizacion
				IFNULL(Cadena_Vacia,Cadena_Vacia),

                -- Relacion de la localizacion
                IFNULL(Cadena_Vacia,Cadena_Vacia),

                -- Correo electronico
                Cli.Correo,

                -- Clave de sucursal
				CASE WHEN Var_SucursalOrigen = SI THEN Cli.SucursalOrigen
					 ELSE Suc.ClaveSucOpeCred END,

                -- Nombre de sucursal
                IFNULL(Suc.NombreSucurs,Cadena_Vacia),

                -- Direccion de sucursal
                IFNULL(Suc.DirecCompleta,Cadena_Vacia),

                -- Clasficacion Contable
                Dep_RetLibGrav,

                -- Tipo de Cuenta
                'INDIVIDUALES',

                -- Numero Contrato
                Ced.CedeID,

                -- Fecha de Apertura
                IFNULL(DATE_FORMAT(Ced.FechaInicio ,'%d%m%Y'),Fecha_Nula),

                -- Fecha Vencimiento del Deposito
				IFNULL(DATE_FORMAT(Ced.FechaVencimiento ,'%d%m%Y'),Fecha_Nula),

                -- Plazo del deposito
                Ced.Plazo,

                -- Periodicidad
                Clave_PerOtro,

                -- -Valor Tasa pactada
				Ced.TasaFija,

                -- Fecha registro de la inversion
                IFNULL(DATE_FORMAT(Ced.FechaInicio ,'%d%m%Y'),Fecha_Nula),

				 -- Saldo de resgistro de CEDE
                IFNULL(His.SaldoCapital,Decimal_Cero),

                -- Porcentaje Fondo Pro
				Decimal_Cero,

                -- Saldo Capital
				His.SaldoCapital,

                -- INT. devengados no pagados
                Decimal_Cero AS IntDevNoPago,
				-- Saldo Cuenta al Final del Periodo

                His.SaldoCapital  AS SaldoFinal,

                -- Tipo de instrumento
                Var_TipoCede AS TipoProducto,

                -- Intrumento ID
                Ced.CedeID

		FROM CEDES Ced
				left outer join SALDOSCEDES His
                on Ced.CedeID = His.CedeID
                and His.FechaCorte = Var_FechaCieCed,
			 TIPOSCEDES Cat,-- RLAVIDA TICKET 12481
             MONEDAS Mon,
			 SUCURSALES Suc,
			 CLIENTES Cli
		LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, Con_NO) = SI
		WHERE  Ced.ClienteID = Cli.ClienteID
          AND  Ced.ClienteID <> Cliente_Inst
          AND  Ced.MonedaID = Mon.MonedaId
          AND (	(Ced.Estatus = Con_NO and FechaInicio <=Var_FechaCieCed) OR
				( Ced.Estatus = Est_Pagado AND Ced.FechaVencimiento >= Var_IniMes AND FechaInicio <=Var_FechaCieCed)
                OR
                ( Ced.Estatus =  Est_Cancelado AND Ced.FechaVenAnt >= Var_IniMes AND FechaInicio <=Var_FechaCieCed )
                )
          AND Ced.TipoCedeID = Cat.TipoCedeID
		  AND Cli.SucursalOrigen = Suc.SucursalID
		ORDER BY Suc.SucursalID, Ced.TipoCedeID;

		-- --------------------------------------
		-- SALDO FINAL CEDES (Interes Devengado No Pagado)
		UPDATE TMPREGANEXO Reg,CEDES Ced SET
			SaldoFinal=0
		WHERE Reg.InstrumentoID=Ced.CedeID
	    		AND Ced.Estatus='P'
	    		AND Ced.FechaVencimiento=LAST_DAY(Par_Fecha);
		-- --------------------------------------
		DROP TABLE IF EXISTS TMP_CARGOABONOCEDE;
		CREATE TEMPORARY TABLE TMP_CARGOABONOCEDE(
		CedeID 				BIGINT,
		InteresPagado 		DECIMAL(14,2),
		InteresProvisionado DECIMAL(14,2),
		PRIMARY KEY(CedeID));


        INSERT INTO TMP_CARGOABONOCEDE
		SELECT CedeID, SUM(CASE WHEN NatMovimiento = Tip_MovAbono THEN Monto ELSE Entero_Cero END) AS InteresPagado,
					   SUM(CASE WHEN NatMovimiento = Tip_MovCargo THEN Monto ELSE Entero_Cero END) AS InteresProvisionado
		FROM CEDESMOV where CedeID IN( SELECT CedeID FROM SALDOSCEDES WHERE FechaCorte = Var_FechaCieCed) AND Fecha <= Var_FechaCieCed
		GROUP BY CedeID;

		UPDATE TMPREGANEXO Ced, TMP_CARGOABONOCEDE Res SET
            Ced.IntDevNoPago = Res.InteresProvisionado - Res.InteresPagado,
			Ced.SaldoFinal   = Ced.SaldoFinal + (Res.InteresProvisionado - Res.InteresPagado)
		WHERE Ced.InstrumentoID  = Res.CedeID
		AND Ced.TipoInstrumento  = Var_TipoCede;

	    UPDATE TMPREGANEXO Ced
			SET Ced.IntDevNoPago = 0
		WHERE Ced.TipoInstrumento = Var_TipoCede
    	AND Ced.SaldoFinal = 0;


    -- Actualizaciones a los datos Globales

    -- --------------------------------------
	-- ESTADOS Y MUNICIPIOS -----------------
	-- --------------------------------------
	UPDATE TMPREGANEXO Tem, COLONIASREPUB Col SET
		Tem.ColoniaiD		= Col.Asentamiento
		WHERE Tem.EstadoID = Col.EstadoID
		  AND Tem.MunicipioID = Col.MunicipioID
		  AND Tem.ColoniaID = Col.ColoniaID;

	UPDATE TMPREGANEXO Tem, LOCALIDADREPUB Loc SET
		Tem.Localidad		= Loc.LocalidadCNBV
		WHERE Tem.EstadoID = Loc.EstadoID
		  AND Tem.MunicipioID = Loc.MunicipioID
		  AND Tem.Localidad = Loc.LocalidadID;

	-- Se actualizan los Codigos de las Localidades que no existen en la CNVB y que si existen en SAFI
	UPDATE TMPREGANEXO Tem, MAPEOLOCALIDADESCNBV Col SET
		Tem.Localidad = Col.LocalidadCNBV
		WHERE Tem.Localidad = Col.LocalidadSAFI;

     -- Se actualizan los Codigos Postales que no existen en la CNVB y que si existen en SAFI
	UPDATE TMPREGANEXO Tem, MAPEOCODIGOPOSTALCNBV Cod SET
		Tem.CodigoPostal = Cod.CPCNBV
		WHERE Tem.CodigoPostal = Cod.CPSAFI;

	-- --------------------------------------
	-- CLAVE PAIS NACIONALIDAD CNBV     ---
	-- --------------------------------------

    -- Actualizo la nacionalidad del clientes
	UPDATE TMPREGANEXO Tem, PAISES Pai
		SET	Tem.Nacionalidad = Pai.PaisRegSITI
	WHERE Tem.Nacionalidad = Pai.PaisID;

	-- Actualizo el pais de residencia del cliente.
    UPDATE TMPREGANEXO Tem, PAISES Pai SET
		Tem.CodigoPais   = Pai.PaisRegSITI
	WHERE Tem.CodigoPais   = Pai.PaisID;

	-- Se actualizan los valores para el campo sucursal
    IF(Var_SucursalOrigen = SI) THEN

		UPDATE TMPREGANEXO Tem, SUCURSALES suc SET
			Tem.ClaveSucursal = suc.ClaveSucOpeCred
		WHERE Tem.ClaveSucursal = suc.SucursalID;

    END IF;
    -- --------------------------------------
	-- CLAVE ACTIVIDADES SCIAN     ---
	-- --------------------------------------
    UPDATE TMPREGANEXO Tem, ACTIVIDADESBMX Bmx
		SET Tem.ActividadEconomica = IFNULL(Bmx.ActividadSCIANID,Clave_OtraActiv)
	WHERE Tem.ActividadEconomica = Bmx.ActividadBMXID;

    DROP TABLE IF EXISTS TMP_Direcciones;
	CREATE TEMPORARY TABLE TMP_Direcciones(
		ClienteID 			BIGINT,
		DireccionCompleta 	VARCHAR(500),
		PRIMARY KEY(ClienteID));

	INSERT INTO TMP_Direcciones
		SELECT ClienteID, MAX(DireccionCompleta) AS DireccionCompleta
		FROM   DIRECCLIENTE
        WHERE  TipoDireccionID = Var_DireccionTrabajo
        GROUP BY ClienteID;

    UPDATE TMPREGANEXO Tem, TMP_Direcciones Dir  SET
       Direccion =  Dir.DireccionCompleta
    WHERE Tem.ClienteID = Dir.ClienteID;

    UPDATE  TMPREGANEXO Tem,
			SUCURSALES Suc,
			ESTADOSREPUB Est,
			MUNICIPIOSREPUB Mun,
			COLONIASREPUB Col,
			LOCALIDADREPUB Loc  SET
			DireccionSucursal = CONCAT( IFNULL(Suc.Calle,''),' NO.',
										IFNULL(Suc.Numero,'SN'),', COL. ',
                                        IFNULL(Col.Asentamiento,''),', ',
                                        IFNULL(Loc.NombreLocalidad,''),', ',
                                        IFNULL(Mun.Nombre,''), ', ',
                                        IFNULL(Suc.CP,''),', ',
                                        IFNULL(Est.Nombre,'') )
	WHERE Suc.SucursalID = Tem.ClaveSucursal
    AND Suc.EstadoID 	= Est.EstadoID
	AND Suc.EstadoID 	= Mun.EstadoID
	AND Suc.MunicipioID = Mun.MunicipioID
	AND Suc.EstadoID 	= Col.EstadoID
	AND Suc.MunicipioID = Col.MunicipioID
	AND Suc.ColoniaID 	= Col.ColoniaID
	AND Suc.EstadoID 	= Loc.EstadoID
	AND Suc.MunicipioID = Loc.MunicipioID
	AND Suc.LocalidadID = Loc.LocalidadID;


	DROP TABLE IF EXISTS TMP_SALDOPROTECCION;
	CREATE TEMPORARY TABLE TMP_SALDOPROTECCION(
		ClienteID 		BIGINT PRIMARY KEY,
		ProcentajePro 	DECIMAL(12,6));



	INSERT INTO TMP_SALDOPROTECCION
		SELECT ClienteID,
		CASE WHEN SUM(SaldoFinal) = Decimal_Cero THEN Decimal_Cero
			 WHEN SUM(SaldoFinal) <= Var_MtoFondoPro THEN Var_Cien
				  ELSE round((Var_MtoFondoPro/SUM(SaldoFinal)*100),6) END
		FROM TMPREGANEXO
	GROUP BY ClienteID;

	-- Monto del Fondo de proteccion
	UPDATE TMPREGANEXO TmpAnexo, TMP_SALDOPROTECCION Tmp
		SET		TmpAnexo.PorcFondoPro   =  Tmp.ProcentajePro
	WHERE TmpAnexo.ClienteID = Tmp.ClienteID AND TmpAnexo.SaldoFinal > Decimal_Cero;

	UPDATE TMPREGANEXO SET
	IntDevNoPago 	= case when IFNULL(IntDevNoPago,Decimal_Cero) 	 < Decimal_Cero then
								 Decimal_Cero
							else IFNULL(IntDevNoPago,Decimal_Cero) 	end,
	PorcFondoPro	= case when IFNULL(PorcFondoPro,Decimal_Cero) < Decimal_Cero then
								 Decimal_Cero
							when IFNULL(PorcFondoPro,Decimal_Cero) > 100 then
								 100.000000
							else IFNULL(PorcFondoPro,Decimal_Cero) end,
	SaldoFinal 		= case when IFNULL(SaldoFinal,Decimal_Cero)	< Decimal_Cero then
								Decimal_Cero
							else IFNULL(SaldoFinal,Decimal_Cero) end;




	IF( Par_NumReporte = Rep_Excel) THEN
		SELECT  -- Datos de identificacion del cliente
                FNLIMPIACARACTERESGENREG(Nombre,CaseMayus) AS Nombre,
                FNLIMPIACARACTERESGENREG(ApellidoPat,CaseMayus) AS ApellidoPat,
                FNLIMPIACARACTERESGENREG(ApellidoMat,CaseMayus) AS ApellidoMat,
                ClienteID,
				NumeroCuenta,

                TipoPersona,
				ActividadEconomica,
                Nacionalidad,
                FechaNac,
                IFNULL(RFC,Cadena_Vacia) AS RFC,

                FNLIMPIACARACTERESGENREG(CURP,CaseMayus) AS CURP,
                -- Datos de localizacion del cliente
                FNLIMPIACARACTERESGENREG(Calle,CaseMayus) AS Calle,
                FNLIMPIACARACTERESGENREG(NumeroExt,CaseMayus) AS NumeroExt,
                FNLIMPIACARACTERESGENREG(ColoniaID,CaseMayus) AS ColoniaID,
				CodigoPostal,

                Localidad,
                MunicipioID,
                EstadoID,
                CodigoPais,
                Direccion,

                TelefonoCasa,
                TelefonoOficina,
                TelefonoCelular,
                TelefonoLocalizacion,
                RelacionLocalizacion,

                Correo,
                -- Datos del producto contratado
                ClaveSucursal,
                NombreSucursal,
                DireccionSucursal,
                ClasfContable,

                TipoCuenta,
                NumContrato,
				FechaContrato,
				FechaVencimiento,
				PlazoDeposito,

				periodicidad,
				TasaPactada,
                FechaUltimoDeposito,
				IFNULL(SaldoUltimoDepostito, Entero_Cero) AS SaldoUltimoDepostito,
				IFNULL(PorcFondoPro, Entero_Cero) AS PorcFondoPro,

                IFNULL(SaldoCapital, Entero_Cero) AS SaldoCapital,
				IFNULL(IntDevNoPago, Entero_Cero) AS IntDevNoPago,
                IFNULL(SaldoFinal, Entero_Cero) AS SaldoFinal

		FROM TMPREGANEXO
			 WHERE FechaVencimiento != Fecha_Nula;

	END IF;

	IF( Par_NumReporte = Rep_Csv) THEN
			SELECT  CONCAT(
				-- Datos de identificacion del cliente
                IFNULL(FNLIMPIACARACTERESGENREG(Nombre,CaseMayus),Cadena_Vacia),';',
                IFNULL(FNLIMPIACARACTERESGENREG(ApellidoPat,CaseMayus),Cadena_Vacia),';',
                IFNULL(FNLIMPIACARACTERESGENREG(ApellidoMat,CaseMayus),Cadena_Vacia),';',
                IFNULL(ClienteID,Cadena_Vacia),';',
                IFNULL(NumeroCuenta,Cadena_Vacia),';',

                IFNULL(TipoPersona,Cadena_Vacia),';',
                IFNULL(ActividadEconomica,Cadena_Vacia),';',
                IFNULL(Nacionalidad,Cadena_Vacia),';',
                IFNULL(FechaNac,Cadena_Vacia),';',
				IFNULL(RFC,Cadena_Vacia),';',

                IFNULL(FNLIMPIACARACTERESGENREG(CURP,CaseMayus),Cadena_Vacia),';',
				-- Datos de localizacion del cliente
                IFNULL(FNLIMPIACARACTERESGENREG(Calle,CaseMayus),Cadena_Vacia),';',
                IFNULL(FNLIMPIACARACTERESGENREG(NumeroExt,CaseMayus),Cadena_Vacia),';',
                IFNULL(FNLIMPIACARACTERESGENREG(ColoniaID,CaseMayus),Cadena_Vacia),';',
				IFNULL(CodigoPostal,Cadena_Vacia),';',

                IFNULL(Localidad,Cadena_Vacia),';',
                IFNULL(MunicipioID,Cadena_Vacia),';',
                IFNULL(EstadoID,Cadena_Vacia),';',
                IFNULL(CodigoPais,Cadena_Vacia),';',
                IFNULL(Direccion,Cadena_Vacia),';',

                IFNULL(TelefonoCasa,Cadena_Vacia),';',
                IFNULL(TelefonoOficina,Cadena_Vacia),';',
                IFNULL(TelefonoCelular,Cadena_Vacia),';',
                IFNULL(TelefonoLocalizacion,Cadena_Vacia),';',
                IFNULL(RelacionLocalizacion,Cadena_Vacia),';',

                IFNULL(Correo,Cadena_Vacia),';',
                -- Datos del producto contratado
                IFNULL(ClaveSucursal,Cadena_Vacia),';',
                IFNULL(NombreSucursal,Cadena_Vacia),';',
                IFNULL(DireccionSucursal,Cadena_Vacia),';',
                IFNULL(ClasfContable,Cadena_Vacia),';',

                IFNULL(TipoCuenta,Cadena_Vacia),';',
                IFNULL(NumContrato,Cadena_Vacia),';',
                IFNULL(FechaContrato,Cadena_Vacia),';',
                IFNULL(FechaVencimiento,Cadena_Vacia),';',
                IFNULL(PlazoDeposito,Cadena_Vacia),';',

				IFNULL(TipoCuenta,Cadena_Vacia),';',
                IFNULL(NumContrato,Cadena_Vacia),';',
                IFNULL(FechaContrato,Cadena_Vacia),';',
                IFNULL(FechaVencimiento,Cadena_Vacia),';',
                IFNULL(PlazoDeposito,Cadena_Vacia),';',

				IFNULL(periodicidad,Cadena_Vacia),';',
                IFNULL(TasaPactada,Cadena_Vacia),';',
                IFNULL(FechaUltimoDeposito,Cadena_Vacia),';',
                IFNULL(SaldoUltimoDepostito,Entero_Cero),';',
                IFNULL(PorcFondoPro,Entero_Cero),';',

                IFNULL(SaldoCapital,Entero_Cero),';',
                IFNULL(IntDevNoPago,Entero_Cero),';',
                IFNULL(SaldoFinal,Entero_Cero),';') AS Valor
			FROM TMPREGANEXO
				WHERE FechaVencimiento != Fecha_Nula;

    END IF;

	DROP TABLE IF EXISTS TMPREGANEXO;
    DROP TABLE IF EXISTS TMP_FACTSALDO;
    DROP TABLE IF EXISTS TMP_CARGOABONOCEDE;
    DROP TABLE IF EXISTS TMP_SALDOPROTECCION;

END TerminaStore$$