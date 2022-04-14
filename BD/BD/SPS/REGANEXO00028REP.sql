
DELIMITER ;
DROP PROCEDURE IF EXISTS REGANEXO00028REP;
DELIMITER $$
CREATE PROCEDURE `REGANEXO00028REP`(



	Par_Fecha           DATE,
	Par_NumReporte      INT,
	Par_NumDecimales    INT,

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
	)
TerminaStore: BEGIN


	DECLARE Var_FechaHis		DATE;
	DECLARE	Var_MtoMinAporta	INT;
	DECLARE	Var_MonedaBase		INT;
	DECLARE Var_IniMes			DATE;
	DECLARE	Var_ClaveEntidad	VARCHAR(300);
	DECLARE Var_Periodo			CHAR(6);
	DECLARE Var_FecBitaco   	DATETIME;
	DECLARE Var_MinutosBit  	INT;
    DECLARE Var_MtoFondoPro		DECIMAL(21,2);
    DECLARE Var_ValorUDI		DECIMAL(21,2);
    DECLARE Var_FechaUDI		DATE;
    DECLARE Var_FechaHisUDI		DATETIME;
    DECLARE Var_NumErr			INT;
    DECLARE Var_ErrMen			VARCHAR(150);

	DECLARE Var_NumCliente		INT;
    DECLARE Var_FechaHisDet		DATE;
	DECLARE Var_SucursalOrigen	CHAR(1);
    DECLARE Var_FechaCieCed		DATE;
    DECLARE Var_TipoCede		INT;


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
	DECLARE Tip_MovAbono		CHAR(1);
    DECLARE Tip_MovCargo		CHAR(1);
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
   	DECLARE Var_FechIniPeriodo 	DATE;
    DECLARE Var_FechaRepAnt 	DATE;
    DECLARE Var_FechaIniRepAnt 	DATE;
    DECLARE Var_FechaHisAnt   	DATE;



	SET Rep_Excel       	:= 1;
	SET Rep_Csv				:= 2;
	SET Entero_Cero     	:= 0;
	SET Cadena_Vacia    	:= '';
	SET Decimal_Cero    	:= 0.00;

    SET Fecha_Vacia     	:= '1900-01-01';
    SET Fecha_Nula			:= '01011900';
	SET Cue_Activa      	:= 'A';
	SET Cue_Bloqueada   	:= 'B';
	SET Ins_CueAhorro  		:= '1';

    SET Ins_InvPlazo   		:= '2';
	SET Cons_BloqGarLiq		:= 8;
	SET SI 					:=	'S';
	SET Con_NO				:=	'N';

    SET Fisica				:=	'F';
	SET Moral				:=	'M';
	SET Fisica_empre		:=	'A';
	SET Masculino			:=	'M';
	SET Femenino			:=	'F';

    SET Apellido_Vacio		:=  'ND';
    SET Clave_CertBursatil 	:= 21250201;
    SET Clave_DepVista		:= 100;
    SET Clave_Periodicidad 	:= 7;
    SET Clave_TipoTasa 		:= 101;

    SET Clave_TasaRefe		:= 102;
    SET Clave_OpeDiferen 	:= 101;
    SET Clave_FrecPlazo		:= 30;
    SET No_RetAntici		:= 102;
    SET Si_RetAntici		:= 101;

    SET Tip_MovAbono		:= 'A';
    SET Tip_MovCargo		:= 'C';
    SET Dep_ConInteres		:= '210101020100';
	SET Dep_ConIntCre		:= '210101020200';
	SET Dep_SinInteres		:= '210101010100';
	SET Dep_SinIntCre		:= '210101010200';

    SET Dep_AhoLibGrav		:= '210102010000';
	SET Dep_AhoAmpCre		:= '210102020000';
	SET Cuen_SinMovimiento	:= '240120000002';

    SET Codigo_Mexico		:= 484;
	SET Dep_PlaLibGrav		:= '211190100000';
	SET Dep_PlaLibAmpCre 	:= '211190200000';
	SET Dep_RetLibGrav		:= '211104010000';
    SET Cadena_Cero			:= '0';
    SET Tipo_GarLiq			:= 'GL';

    SET Tipo_DepVis			:= 'DV';
    SET Est_Cancelado		:= 'C';
    SET Est_Inactivo		:= 'I';
    SET Tipo_Nacional		:= 'N';
    SET Tipo_Extranj		:= 'E';

    SET Riesgo_Bajo			:= 'B';
    SET Riesgo_Medio		:= 'M';
    SET Riesgo_Alto			:= 'A';
    SET Clave_RiesBajo		:= 1;
    SET Clave_RiesMedio		:= 2;

    SET Clave_RiesAlto		:= 3;
    SET Clave_NacFis		:= 1;
    SET Clave_NacMor		:= 2;
    SET Clave_ExtFis		:= 3;
    SET Clave_ExtMor		:= 4;

    SET Per_Masculino		:= 3;
	SET Per_Femenino		:= 2;
	SET Per_NoAplica		:= 1;
	SET No_Aplica			:= 'No aplica';
	SET Dep_Vista			:= 'V';

    SET Dep_Ahorro			:= 'A';
	SET Moneda_Extran		:= 4;
	SET Nat_Bloqueo			:= 'B';
	SET Est_Pagado			:= 'P';

    SET Clave_OtraActiv		:= 81299;
	SET Rango_Uno			:= 101;
	SET Rango_Dos			:= 102;
	SET Rango_Tres			:= 103;
	SET Rango_Cuatro		:= 104;

    SET Rango_Cinco			:= 105;
	SET Rango_Seis			:= 106;
	SET Rango_Siete			:= 107;
	SET Dep_VisCnInt		:= 3;
	SET Dep_VisIntCre 		:= 4;

    SET Dep_VisSnInt 		:= 1;
	SET Dep_VisSnIntCre 	:= 2;
	SET Dep_AhoInte			:= 5;
	SET Dep_AhoCre 			:= 6;
	SET Dep_Plazo 			:= 9;

    SET Dep_PlazoAmpCre 	:= 10;
    SET CaseMayus			:= 'MA';
    SET Prog_Cierre			:= 'CIERREMESAHORRO';
    SET Monto_UDIS			:= 25000;
    SET Salida_NO			:= 'N';

    SET Var_Cien 			:= 100.000000;
    SET Clave_PerOtro		:= 7;
	SET Clave_PerMes		:= 3;
	SET Var_DireccionTrabajo := 3;
	SET Var_TipoCede 		:= 11;

	SET Con_Registrado		:= 'R';
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

	CREATE TABLE TMPREGANEXO(
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
	SET Var_FechaHisAnt := (SELECT MAX(Fecha) FROM `HIS-CUENTASAHO` WHERE Fecha <= Var_IniMes);

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
					 ELSE Entero_Cero
				END ,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Apellido_Vacio) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Entero_Cero
				END,


                His.ClienteID,


				CONVERT(His.CuentaAhoID, CHAR),


				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
				END,


				Cli.ActividadBancoMX,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.LugarNacimiento
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS LugarNacimiento,


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


				IFNULL(Dir.Calle,Cadena_Vacia),


				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),


				IFNULL(Dir.ColoniaID,Entero_Cero),


				IFNULL(Dir.CP,Entero_Cero),


				IFNULL(Dir.LocalidadID, Entero_Cero),


				IFNULL(Dir.MunicipioID, Entero_Cero) AS MunicipioClave,


				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,


				CASE WHEN Cli.TipoPersona = Fisica OR  Cli.TipoPersona = Fisica_empre THEN Cli.PaisResidencia
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS PaisResidencia,


                IFNULL(Dir.DireccionCompleta,Cadena_Vacia),


				CASE WHEN CHAR_LENGTH(Cli.Telefono) = 10 THEN
						Cli.Telefono
					  WHEN CHAR_LENGTH(Cli.Telefono) > 10 THEN
						SUBSTRING(Cli.Telefono,1,10)
					  ELSE
						LPAD(Cli.Telefono,10,'0')
				END,


				Cli.TelTrabajo,


				CASE WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) = 10 THEN
						Cli.TelefonoCelular
					  WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) > 10 THEN
						SUBSTRING(Cli.TelefonoCelular,1,10)
					  ELSE
						LPAD(Cli.TelefonoCelular,10,'0')
				END,


				IFNULL(Cadena_Vacia,Cadena_Vacia),


                IFNULL(Cadena_Vacia,Cadena_Vacia),


                Cli.Correo,


                CASE WHEN Var_SucursalOrigen = SI THEN Cli.SucursalOrigen
					 ELSE Suc.ClaveSucOpeCred END,


                IFNULL(Suc.NombreSucurs,Cadena_Vacia),


                IFNULL(Suc.DirecCompleta,Cadena_Vacia),


				CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
					 Dep_ConInteres
					 WHEN Tip.GeneraInteres = Con_NO AND ClasificacionConta = Dep_Vista  THEN
					 Dep_SinInteres
					 WHEN ClasificacionConta = Dep_Ahorro  THEN
					 Dep_AhoLibGrav
				END,


                'INDIVIDUALES',


                CONVERT(His.CuentaAhoID, CHAR),


                IFNULL(DATE_FORMAT(His.FechaApertura,'%d%m%Y'),Fecha_Nula),


				Cadena_Vacia AS FechaVencimiento, -- IALDANA T_14639 Se cambia Fecha_Nula por Cadena_Vacia


                Entero_Cero,


				CASE WHEN Tip.GeneraInteres = SI AND Tip.TipoInteres = 'D' THEN Clave_PerOtro
					 WHEN Tip.GeneraInteres = Con_NO AND Tip.TipoInteres = 'D' THEN Clave_PerMes
                     ELSE Clave_PerOtro END,


                His.TipoCuentaID,


				CASE WHEN Cue.FechaDepInicial = Fecha_Vacia THEN
							IFNULL(DATE_FORMAT(His.FechaApertura,'%d%m%Y'),Fecha_Nula)
					 ELSE
						IFNULL(DATE_FORMAT(Cue.FechaDepInicial,'%d%m%Y'),Fecha_Nula)
					 END,


				Cue.MontoDepInicial,


				Decimal_Cero,


				His.Saldo,


				Entero_Cero AS IntDevNoPago,


				IFNULL(His.Saldo,Entero_Cero) AS SaldoFinal ,


                CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisCnInt
					 WHEN Tip.GeneraInteres = Con_NO AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisSnInt
					 WHEN ClasificacionConta = Dep_Ahorro THEN
					 Dep_AhoInte
				END,


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
			  AND Cue.Estatus <> Con_Registrado;

	IF(Var_NumCliente = 15) THEN

		DROP TABLE IF EXISTS TMP_CUENTASAHOGENINTERES;
        CREATE TEMPORARY TABLE TMP_CUENTASAHOGENINTERES
        SELECT CuentaAhoID FROM CUENTASAHO WHERE TipoCuentaID = 6;
        CREATE INDEX idx_1 ON TMP_CUENTASAHOGENINTERES(CuentaAhoID);

		UPDATE TMPREGANEXO Temp, TMP_CUENTASAHOGENINTERES Cue SET
			periodicidad = Clave_PerMes
		WHERE Temp.InstrumentoID = Cue.CuentaAhoID;

	END IF;


	UPDATE TMPREGANEXO Tem, TASASAHORRO Tap SET
		Tem.TasaPactada	= ROUND(Tap.Tasa,6)
	WHERE Tem.TasaPactada = Tap.TipoCuentaID;




	DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;
	CREATE TABLE TMP_GTIALIQ_AHORRO(
		Cuenta          BIGINT,
		Saldo           DECIMAL(18,2),
	PRIMARY KEY(Cuenta));


	INSERT INTO TMP_GTIALIQ_AHORRO
	SELECT 	CuentaAhoID, SUM(CASE WHEN NatMovimiento = 'B' THEN  MontoBloq
								  ELSE MontoBloq *-1
			END) AS Saldo
	FROM BLOQUEOS
	WHERE DATE(FechaMov) <= Par_Fecha
	AND TiposBloqID = Cons_BloqGarLiq
	GROUP BY CuentaAhoID;

	UPDATE TMPREGANEXO Tem, TMP_GTIALIQ_AHORRO Gar SET
		Tem.SaldoFinal    =  Tem.SaldoFinal - Gar.Saldo
    WHERE Tem.InstrumentoID = Gar.Cuenta;


	INSERT INTO TMPREGANEXO
	SELECT
		tem.Nombre, 			tem.ApellidoPat, 		tem.ApellidoMat, 		tem.ClienteID,				tem.NumeroCuenta,
		tem.TipoPersona, 		tem.ActividadEconomica, tem.Nacionalidad, 		tem.FechaNac,				tem.RFC,
		tem.CURP, 				tem.Calle, 				tem.NumeroExt, 			tem.ColoniaID, 				tem.CodigoPostal,
		tem.Localidad, 			tem.MunicipioID, 		tem.EstadoID, 			tem.CodigoPais, 			tem.Direccion,
		tem.TelefonoCasa, 		tem.TelefonoCelular, 	tem.TelefonoOficina,	tem.TelefonoLocalizacion, 	tem.RelacionLocalizacion,
		tem.Correo, 			tem.ClaveSucursal, 		tem.NombreSucursal,		tem.DireccionSucursal,
		CASE WHEN tem.ClasfContable = Dep_ConInteres THEN Dep_ConIntCre
			 WHEN tem.ClasfContable = Dep_SinInteres THEN Dep_SinIntCre
			 WHEN tem.ClasfContable = Dep_AhoLibGrav THEN Dep_AhoAmpCre
		END,
		tem.TipoCuenta, 		tem.NumContrato, 		tem.FechaContrato, 			tem.FechaVencimiento, 		tem.PlazoDeposito,
		tem.periodicidad, 		tem.TasaPactada, 		tem.FechaUltimoDeposito, 	tem.SaldoUltimoDepostito, 	tem.PorcFondoPro,
		tem.SaldoCapital, 		tem.IntDevNoPago, 		Gar.Saldo, 					tem.TipoInstrumento, 		tem.InstrumentoID
	FROM TMPREGANEXO tem, TMP_GTIALIQ_AHORRO Gar
	WHERE  tem.InstrumentoID = Gar.Cuenta;


	DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;
	SET Var_FechaHisAnt := (SELECT MAX(FechaCorte)  FROM HISINVERSIONES WHERE FechaCorte <= Var_IniMes );
	set Var_FechaRepAnt := Var_FechaHisAnt;
	set Var_FechaIniRepAnt := date_sub(Var_FechaRepAnt, INTERVAL  3 month);
	set Var_FechaIniRepAnt := last_day(Var_FechaIniRepAnt);
	SET Var_FechaIniRepAnt  := date_add(Var_FechaIniRepAnt, interval 1 day);


	INSERT INTO TMPREGANEXO

		SELECT

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
									OR IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
								UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
							END
					 ELSE Entero_Cero
				END ,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
                           CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Entero_Cero
				END,


				Inv.ClienteID,


				Inv.CuentaAhoID,


				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
				END,


				Cli.ActividadBancoMX,


				CASE WHEN Cli.TipoPersona = Fisica OR  Cli.TipoPersona = Fisica_empre THEN Cli.LugarNacimiento
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS LugarNacimiento,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						DATE_FORMAT(Cli.FechaNacimiento ,'%d%m%Y')
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


				IFNULL(Dir.Calle,Cadena_Vacia),


				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),


				IFNULL(Dir.ColoniaID,Entero_Cero),


				IFNULL(Dir.CP,Entero_Cero),


				IFNULL(Dir.LocalidadID, Entero_Cero),


				IFNULL(Dir.MunicipioID, Entero_Cero) AS MunicipioClave,


				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.PaisResidencia
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS PaisResidencia,


                IFNULL(Dir.DireccionCompleta,Cadena_Vacia),


				CASE WHEN CHAR_LENGTH(Cli.Telefono) = 10 THEN
						Cli.Telefono
					  WHEN CHAR_LENGTH(Cli.Telefono) > 10 THEN
						SUBSTRING(Cli.Telefono,1,10)
					  ELSE
						LPAD(Cli.Telefono,10,'0')
				END,


				IFNULL(Cli.TelTrabajo,Cadena_Vacia),


				CASE WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) = 10 THEN
						Cli.TelefonoCelular
					  WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) > 10 THEN
						SUBSTRING(Cli.TelefonoCelular,1,10)
					  ELSE
						LPAD(Cli.TelefonoCelular,10,'0')
				END,


				IFNULL(Cadena_Vacia,Cadena_Vacia),


                IFNULL(Cadena_Vacia,Cadena_Vacia),


                Cli.Correo,


				CASE WHEN Var_SucursalOrigen = SI THEN Cli.SucursalOrigen
					 ELSE Suc.ClaveSucOpeCred END,


                IFNULL(Suc.NombreSucurs,Cadena_Vacia),


                IFNULL(Suc.DirecCompleta,Cadena_Vacia),


                Dep_PlaLibGrav,


                'INDIVIDUALES',


                Inv.InversionID,


                IFNULL(DATE_FORMAT(Inv.FechaInicio ,'%d%m%Y'),Fecha_Nula),


				IFNULL(DATE_FORMAT(Inv.FechaVencimiento ,'%d%m%Y'),Fecha_Nula),


                Inv.Plazo,


                Clave_PerOtro,


				Inv.Tasa,


                IFNULL(DATE_FORMAT(Inv.FechaInicio ,'%d%m%Y'),Fecha_Nula),


                IFNULL(Inv.Monto,Decimal_Cero),


				Decimal_Cero,


				Inv.Monto,


                CASE WHEN Inv.Estatus IN (Est_Pagado,Est_Cancelado)  THEN Decimal_Cero
						ELSE Inv.SaldoProvision  END AS IntDevNoPago,


                CASE WHEN Inv.Estatus IN(Est_Pagado,Est_Cancelado) THEN Decimal_Cero ELSE
				(Inv.Monto + Inv.SaldoProvision) END AS SaldoFinal,


                Dep_Plazo AS TipoProducto,


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
          AND 	(Inv.Estatus = NO OR
				( Inv.Estatus = Est_Pagado AND Inv.FechaVencimiento BETWEEN Var_IniMes AND Var_FechaCieInv)
                OR
                ( Inv.Estatus =  Est_Cancelado AND Inv.FechaVenAnt BETWEEN Var_IniMes AND Var_FechaCieInv )
                )
          AND Inv.TipoInversionID = Cat.TipoInversionID
		  AND Cli.SucursalOrigen = Suc.SucursalID
		ORDER BY Suc.SucursalID, Inv.InversionID;




	-- Segmento de Inversiones que garantizan creditos
	DROP TABLE IF EXISTS TMP_INVGAR;
	CREATE TABLE TMP_INVGAR (
		InversionID BIGINT,
		MontoEnGar  decimal(16,2),
		FechaMov   DATE,
		CreditoID BIGINT);

	DROP TABLE IF EXISTS TMP_INVGAR_ANT;
	CREATE TABLE TMP_INVGAR_ANT (
	InversionID BIGINT,
	MontoEnGar  decimal(16,2),
	FechaMov   DATE,
	CreditoID BIGINT );


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
	SELECT 	Gar.InversionID,Gar.MontoEnGar,
			Gar.FechaAsignaGar ,Gar.CreditoID
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
		InversionID 	BIGINT,
		MontoEnGar  	decimal(16,2),
		FechaMov   		DATE,
		MontoUltMov 	Decimal(16,2),
		SaldoInicial	DECIMAL(16,2),
		Depositos   	DECIMAL(16,2),
		Retiros         DECIMAL(16,2));

	INSERT INTO TMP_INVGAR_SAL
	select 	Gar.InversionID, sum(Gar.MontoEnGar) as Saldo,
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
		InversionID 	BIGINT,
		MontoEnGar  	decimal(16,2),
		FechaMov   		DATE,
		SaldoInicial 	DECIMAL(16,2),
		Depositos   	DECIMAL(16,2),
		Retiros         DECIMAL(16,2));

	INSERT INTO TMP_INVGAR_SAL_ANT
	select 	Gar.InversionID, sum(Gar.MontoEnGar) as Saldo,
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

	update TMP_INVGAR_SAL tem, CREDITOINVGAR inv set
		tem.MontoUltMov = inv.MontoEnGar
	where tem.InversionID = inv.InversionID
	and tem.FechaMov = inv.FechaAsignaGar;

	update TMP_INVGAR_SAL tem, HISCREDITOINVGAR inv set
	tem.MontoUltMov = inv.MontoEnGar,
	tem.FechaMov = case when inv.Fecha >= Var_FechaIniRepAnt then inv.Fecha else tem.FechaMov end
	where tem.InversionID = inv.InversionID
	  and tem.FechaMov = inv.FechaAsignaGar;

	UPDATE TMPREGANEXO Tem, TMP_INVGAR_SAL Gar SET
		Tem.SaldoFinal    =  Tem.SaldoFinal - Gar.MontoEnGar
	WHERE Tem.InstrumentoID = Gar.InversionID
	  AND Tem.TipoInstrumento = Dep_Plazo;

	INSERT INTO TMPREGANEXO
	SELECT
		tem.Nombre, 			tem.ApellidoPat, 		tem.ApellidoMat, 		tem.ClienteID,				tem.NumeroCuenta,
		tem.TipoPersona, 		tem.ActividadEconomica, tem.Nacionalidad, 		tem.FechaNac,				tem.RFC,
		tem.CURP, 				tem.Calle, 				tem.NumeroExt, 			tem.ColoniaID, 				tem.CodigoPostal,
		tem.Localidad, 			tem.MunicipioID, 		tem.EstadoID, 			tem.CodigoPais, 			tem.Direccion,
		tem.TelefonoCasa, 		tem.TelefonoCelular, 	tem.TelefonoOficina,	tem.TelefonoLocalizacion, 	tem.RelacionLocalizacion,
		tem.Correo, 			tem.ClaveSucursal, 		tem.NombreSucursal,		tem.DireccionSucursal,
		CASE WHEN tem.TipoInstrumento = Dep_Plazo THEN Dep_PlaLibAmpCre
			 ELSE tem.ClasfContable
		END,
		tem.TipoCuenta, 		tem.NumContrato, 		tem.FechaContrato, 			tem.FechaVencimiento, 		tem.PlazoDeposito,
		tem.periodicidad, 		tem.TasaPactada, 		tem.FechaUltimoDeposito, 	tem.SaldoUltimoDepostito, 	tem.PorcFondoPro,
		Gar.SaldoInicial, 		tem.IntDevNoPago, 		Gar.MontoEnGar, 			tem.TipoInstrumento, 		tem.InstrumentoID
	FROM TMPREGANEXO tem, TMP_INVGAR_SAL Gar
    WHERE tem.InstrumentoID = Gar.InversionID
      AND tem.TipoInstrumento = Dep_Plazo;
	DROP TABLE IF EXISTS TMP_INVGAR;
	-- Segmento de Inversiones que garantizan creditos


	INSERT INTO TMPREGANEXO

		SELECT

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
									OR IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
								UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
							END
					 ELSE Entero_Cero
				END ,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
                           CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Entero_Cero
				END,


				Ced.ClienteID,


				Ced.CuentaAhoID,


				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
				END,


				Cli.ActividadBancoMX,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.LugarNacimiento
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END  AS LugarNacimiento,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						DATE_FORMAT(Cli.FechaNacimiento ,'%d%m%Y')
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


				IFNULL(Dir.Calle,Cadena_Vacia),


				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),


				IFNULL(Dir.ColoniaID,Entero_Cero),


				IFNULL(Dir.CP,Entero_Cero),


				IFNULL(Dir.LocalidadID, Entero_Cero),


				IFNULL(Dir.MunicipioID, Entero_Cero) AS MunicipioClave,


				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.PaisResidencia
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS PaisResidencia,


                IFNULL(Dir.DireccionCompleta,Cadena_Vacia),


				CASE WHEN CHAR_LENGTH(Cli.Telefono) = 10 THEN
						Cli.Telefono
					  WHEN CHAR_LENGTH(Cli.Telefono) > 10 THEN
						SUBSTRING(Cli.Telefono,1,10)
					  ELSE
						LPAD(Cli.Telefono,10,'0')
				END,


				IFNULL(Cli.TelTrabajo,Cadena_Vacia),


				CASE WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) = 10 THEN
						Cli.TelefonoCelular
					  WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) > 10 THEN
						SUBSTRING(Cli.TelefonoCelular,1,10)
					  ELSE
						LPAD(Cli.TelefonoCelular,10,'0')
				END,


				IFNULL(Cadena_Vacia,Cadena_Vacia),


                IFNULL(Cadena_Vacia,Cadena_Vacia),


                Cli.Correo,


				CASE WHEN Var_SucursalOrigen = SI THEN Cli.SucursalOrigen
					 ELSE Suc.ClaveSucOpeCred END,


                IFNULL(Suc.NombreSucurs,Cadena_Vacia),


                IFNULL(Suc.DirecCompleta,Cadena_Vacia),


                Dep_RetLibGrav,


                'INDIVIDUALES',


                Ced.CedeID,


                IFNULL(DATE_FORMAT(Ced.FechaInicio ,'%d%m%Y'),Fecha_Nula),


				IFNULL(DATE_FORMAT(Ced.FechaVencimiento ,'%d%m%Y'),Fecha_Nula),


                Ced.Plazo,


                Clave_PerOtro,


				Ced.TasaFija,


                IFNULL(DATE_FORMAT(Ced.FechaInicio ,'%d%m%Y'),Fecha_Nula),


                IFNULL(His.SaldoCapital,Decimal_Cero),


				Decimal_Cero,


				His.SaldoCapital,


                Decimal_Cero AS IntDevNoPago,


                His.SaldoCapital  AS SaldoFinal,


                Var_TipoCede AS TipoProducto,


                Ced.CedeID

		FROM CEDES Ced
				left outer join SALDOSCEDES His
                on Ced.CedeID = His.CedeID
                and His.FechaCorte = Var_FechaCieCed,
			 TIPOSCEDES Cat,
             MONEDAS Mon,
			 SUCURSALES Suc,
			 CLIENTES Cli
		LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, NO) = SI
		WHERE  Ced.ClienteID = Cli.ClienteID
          AND  Ced.ClienteID <> Cliente_Inst
          AND  Ced.MonedaID = Mon.MonedaId
          AND (	(Ced.Estatus = NO and FechaInicio <=Var_FechaCieCed) OR
				( Ced.Estatus = Est_Pagado AND Ced.FechaVencimiento >= Var_IniMes)
                OR
                ( Ced.Estatus =  Est_Cancelado AND Ced.FechaVenAnt >= Var_IniMes )
                )
          AND Ced.TipoCedeID = Cat.TipoCedeID
		  AND Cli.SucursalOrigen = Suc.SucursalID
		ORDER BY Suc.SucursalID, Ced.TipoCedeID;

		UPDATE TMPREGANEXO Reg,CEDES Ced SET
			SaldoFinal=0
		WHERE Reg.InstrumentoID=Ced.CedeID
	    		AND Ced.Estatus='P'
	    		AND Ced.FechaVencimiento=LAST_DAY(Par_Fecha);

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


	    -- JPALMA - Cuentas sin Movimiento
		INSERT INTO TMPREGANEXO

		SELECT

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
					 ELSE Entero_Cero
				END ,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Apellido_Vacio) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Entero_Cero
				END,


                His.ClienteID,


				CONVERT(His.CuentaAhoID, CHAR),


				CASE WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Nacional THEN Clave_NacMor
					 WHEN Cli.TipoPersona = Moral AND Nacion = Tipo_Extranj THEN Clave_ExtMor
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Nacional THEN Clave_NacFis
					 WHEN Cli.TipoPersona IN (Fisica,Fisica_empre) AND Nacion = Tipo_Extranj THEN Clave_ExtFis
				END,


				Cli.ActividadBancoMX,


				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN Cli.LugarNacimiento
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS LugarNacimiento,


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


				IFNULL(Dir.Calle,Cadena_Vacia),


				SUBSTR(IFNULL(Dir.NumeroCasa,Cadena_Vacia),1,5),


				IFNULL(Dir.ColoniaID,Entero_Cero),


				IFNULL(Dir.CP,Entero_Cero),


				IFNULL(Dir.LocalidadID, Entero_Cero),


				IFNULL(Dir.MunicipioID, Entero_Cero) AS MunicipioClave,


				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,


				CASE WHEN Cli.TipoPersona = Fisica OR  Cli.TipoPersona = Fisica_empre THEN Cli.PaisResidencia
					 WHEN Cli.TipoPersona = Moral THEN Cli.PaisConstitucionID END AS PaisResidencia,


                IFNULL(Dir.DireccionCompleta,Cadena_Vacia),


				CASE WHEN CHAR_LENGTH(Cli.Telefono) = 10 THEN
						Cli.Telefono
					  WHEN CHAR_LENGTH(Cli.Telefono) > 10 THEN
						SUBSTRING(Cli.Telefono,1,10)
					  ELSE
						LPAD(Cli.Telefono,10,'0')
				END,


				Cli.TelTrabajo,


				CASE WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) = 10 THEN
						Cli.TelefonoCelular
					  WHEN CHAR_LENGTH(IFNULL(Cli.TelefonoCelular,Entero_Cero)) > 10 THEN
						SUBSTRING(Cli.TelefonoCelular,1,10)
					  ELSE
						LPAD(Cli.TelefonoCelular,10,'0')
				END,


				IFNULL(Cadena_Vacia,Cadena_Vacia),


                IFNULL(Cadena_Vacia,Cadena_Vacia),


                Cli.Correo,


                CASE WHEN Var_SucursalOrigen = SI THEN Cli.SucursalOrigen
					 ELSE Suc.ClaveSucOpeCred END,


                IFNULL(Suc.NombreSucurs,Cadena_Vacia),


                IFNULL(Suc.DirecCompleta,Cadena_Vacia),


				Cuen_SinMovimiento,


                'INDIVIDUALES',


                CONVERT(His.CuentaAhoID, CHAR),


                IFNULL(DATE_FORMAT(His.FechaCancela,'%d%m%Y'),Fecha_Nula),


				Cadena_Vacia AS FechaVencimiento, -- IALDANA T_14639 Se cambia Fecha_Nula por Cadena_Vacia


                Entero_Cero,


				CASE WHEN Tip.GeneraInteres = SI AND Tip.TipoInteres = 'D' THEN Clave_PerOtro
					 WHEN Tip.GeneraInteres = NO AND Tip.TipoInteres = 'D' THEN Clave_PerMes
                     ELSE Clave_PerOtro END,


                Decimal_Cero,


				IFNULL(DATE_FORMAT(His.FechaCancela,'%d%m%Y'),Fecha_Nula),

				IFNULL(His.SaldoAhorro,Entero_Cero),


				Decimal_Cero,


				IFNULL(His.SaldoAhorro,Entero_Cero),


				Entero_Cero AS IntDevNoPago,


				case when His.FechaRetiro between Var_IniMes and Par_Fecha then
							Entero_Cero
				else His.SaldoAhorro end AS SaldoFinal ,


                CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisCnInt
					 WHEN Tip.GeneraInteres = NO AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisSnInt
					 WHEN ClasificacionConta = Dep_Ahorro THEN
					 Dep_AhoInte
				END,


                His.CuentaAhoID

			FROM CANCSOCMENORCTA His,
				 CUENTASAHO Cue,
				 TIPOSCUENTAS Tip,
				 SUCURSALES Suc,
				 CLIENTES Cli
                 LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, NO) = SI

			WHERE His.FechaCancela <= Var_FechaHis
			  AND (His.Aplicado ='N' OR (Aplicado = 'R' and FechaRetiro >= Var_IniMes ))
              AND His.CuentaAhoID = Cue.CuentaAhoID
			  AND His.ClienteID = Cli.ClienteID
              AND His.ClienteID <>Cliente_Inst
              AND Tip.EsBancaria = NO
			  AND Cue.TipoCuentaID = Tip.TipoCuentaID
			  AND Cue.SucursalID = Suc.SucursalID;
	    -- JPALMA - Fin Cuentas sin Movimiento






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


	UPDATE TMPREGANEXO Tem, MAPEOLOCALIDADESCNBV Col SET
		Tem.Localidad = Col.LocalidadCNBV
		WHERE Tem.Localidad = Col.LocalidadSAFI;


	UPDATE TMPREGANEXO Tem, MAPEOCODIGOPOSTALCNBV Cod SET
		Tem.CodigoPostal = Cod.CPCNBV
		WHERE Tem.CodigoPostal = Cod.CPSAFI;






	UPDATE TMPREGANEXO Tem, PAISES Pai
		SET	Tem.Nacionalidad = Pai.PaisRegSITI
	WHERE Tem.Nacionalidad = Pai.PaisID;


    UPDATE TMPREGANEXO Tem, PAISES Pai SET
		Tem.CodigoPais   = Pai.PaisRegSITI
	WHERE Tem.CodigoPais   = Pai.PaisID;


    IF(Var_SucursalOrigen = SI) THEN

		UPDATE TMPREGANEXO Tem, SUCURSALES suc SET
			Tem.ClaveSucursal = suc.ClaveSucOpeCred
		WHERE Tem.ClaveSucursal = suc.SucursalID;

    END IF;



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
		SELECT
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

	-- DROP TABLE IF EXISTS TMPREGANEXO;
    DROP TABLE IF EXISTS TMP_FACTSALDO;
    DROP TABLE IF EXISTS TMP_CARGOABONOCEDE;
    DROP TABLE IF EXISTS TMP_SALDOPROTECCION;

END TerminaStore$$