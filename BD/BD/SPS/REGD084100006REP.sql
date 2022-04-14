-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGD084100006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGD084100006REP`;
DELIMITER $$


CREATE PROCEDURE `REGD084100006REP`(
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
	DECLARE Var_NumErr			INT;
    DECLARE Var_ErrMen			VARCHAR(150);

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
    DECLARE Apellido_Vacio		CHAR(1);

    DECLARE Fecha_Nula			VARCHAR(12);
	DECLARE Cli_Moral			INT;
	DECLARE Cli_Fisica			INT;
	DECLARE Cli_FisMen			INT;
	DECLARE Cadena_Cero			CHAR(1);

    DECLARE Per_Masculino		INT;
	DECLARE Per_Femenino		INT;
	DECLARE Per_NoAplica		INT;
	DECLARE Tipo_C				CHAR(1);
	DECLARE Codigo_Pais			INT;

    DECLARE Socio_Individual	INT;
	DECLARE Ahorro_Menores		INT;
	DECLARE Moneda_Nacional		INT;
	DECLARE Moneda_Extran		INT;
	DECLARE Tipo_Deposito		CHAR(1);

    DECLARE PLazo_Mes			INT;
	DECLARE No_Aplica			VARCHAR(20);
	DECLARE Tipo_Apertura		INT;
	DECLARE Nat_Bloqueo			CHAR(1);
	DECLARE Dep_Vista			CHAR(1);

    DECLARE Dep_Ahorro			CHAR(1);
	DECLARE Dep_VisConInt		INT;
	DECLARE Dep_VisIntCre		INT;
	DECLARE Dep_VisSinInt		INT;
	DECLARE Dep_VisSinIntCre	INT;

    DECLARE Dep_AhoInte			INT;
	DECLARE Dep_AhoAmpCre		INT;
	DECLARE Dep_Plazo			INT;
	DECLARE Dep_PlazoAmpCre		INT;
    DECLARE Est_Pagado			CHAR(1);

    DECLARE Est_Cancelado		CHAR(1);
    DECLARE Var_FechaCieInv		DATE;
    DECLARE Cliente_Inst      	INT;



	-- Asignacion de Constantes
    SET Est_Pagado		:= 'P'; -- Estatus pagado
    SET Est_Cancelado	:= 'C'; -- Estatus Cancelado
	SET Rep_Excel       := 1;		-- Opcion de reporte para excel
	SET Rep_Csv			:= 2;  		-- Opcion de reporte para CVS
	SET Entero_Cero     := 0;
	SET Cadena_Vacia    := '';
	SET Decimal_Cero    := 0.00;
	SET Fecha_Vacia     := '1900-01-01';
	SET Cue_Activa      := 'A';     -- Cuenta Activa
	SET Cue_Bloqueada   := 'B';   	-- Cuenta bloqueada
	SET Ins_CueAhorro   := '1';   	-- Tipo de Instrumento: Cuenta de Ahorro
	SET Ins_InvPlazo   	:= '2';   	-- Tipo de Instrumento: Inversiones Plazo
	SET Cons_BloqGarLiq	:= 8;		-- Tipo de Bloqueo: Por Gtia Liquida
	SET For_0841		:= '0841';	-- Clave del Formulario o Reporte
	SET SI 				:=	'S';	-- SI
	SET Con_NO			:=	'N'; 	-- NO
	SET Fisica			:=	'F';	-- Tipo de persona fisica
	SET Moral			:=	'M';	-- Tipo de persona moral
	SET Fisica_empre	:=	'A';	-- Persona Fisica Con Actividad Empresarial
	SET Masculino		:=	'M';	-- Sexo masculino
	SET Femenino		:=	'F';	-- Sexo femenino
    SET Apellido_Vacio	:=  'X'; 	-- Apellido Vacio
    SET Fecha_Nula		:= '19000101';

    SET Cli_Moral		:= 2; 	-- Cliente Moral
	SET Cli_Fisica		:= 1;  	-- Cliente Fisica
	SET Cli_FisMen		:= 4; 	-- Cliente Fisica Empresarial
	SET Cadena_Cero		:= '0'; --
	SET Per_Masculino	:= 2; 	-- Persona Masculina
	SET Per_Femenino	:= 1;  	-- Persona Femenina
	SET Per_NoAplica	:= 3; 	-- Perona Moral
	SET Tipo_C			:= 'C'; 	-- Tipo Conciliado
	SET Codigo_Pais		:= 484; -- Mexico
	SET Socio_Individual := 2; 	-- Tipo Soc. Individual
	SET Ahorro_Menores	 := 5; 	-- Tipo Cta. Ahorro Menores

	SET Moneda_Nacional := 14;	-- Moneda Nacional
	SET Moneda_Extran	:= 4;	-- Moneda Extranjera
	SET Tipo_Deposito	:= 'D'; -- Movimiento deposito
	SET PLazo_Mes		:= 30; 	-- Plazo 30 dias mes
	SET No_Aplica		:= 'No aplica';
	SET Tipo_Apertura	:= 1; -- Tipo de Apertura
	SET Nat_Bloqueo		:= 'B'; -- Naturaleza Bloqueo
	SET Dep_Vista		:= 'V'; -- Depositos a la vista
	SET Dep_Ahorro		:= 'A'; -- Depositos de Ahorro

	SET Dep_VisConInt	:= 3;	-- deposito a la vista con intereses
	SET Dep_VisIntCre 	:= 4;	-- deposito a la vista con inte ampara credito
	SET Dep_VisSinInt 	:= 1; 	-- eposito a la vista sin intereses
	SET Dep_VisSinIntCre := 2;	-- Deposito a la vista sin interes ampara credito
	SET Dep_AhoInte		:= 5;   -- Deposito de Ahorro
	SET Dep_AhoAmpCre 	:= 6;	-- Deposito de ahorro que ampara credito
	SET Dep_Plazo 		:= 9; 	-- depositos a plazo
	SET Dep_PlazoAmpCre := 10; 	-- depositos a plazo que amparan creditos
    SET Salida_NO		:= 'N';

	SET Var_Periodo = CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),1,4),
							  SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),5,2));

	SET Var_ClaveEntidad	:= IFNULL((SELECT Par.ClaveEntidad
										FROM PARAMETROSSIS Par
										WHERE Par.EmpresaID = Par_EmpresaID), Cadena_Vacia);

		SET Cliente_Inst    := (SELECT ClienteInstitucion FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);


    SET Var_FechaCieInv := (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Par_Fecha);

	DROP TABLE IF EXISTS TMPREGB0841;

	CREATE TEMPORARY TABLE TMPREGB0841(
		ClienteID		INT,
		TipoPersona		CHAR(1),
		Nombre			VARCHAR(200),
		ApellidoPat		VARCHAR(200),
		ApellidoMat		VARCHAR(200),

        RFC				VARCHAR(20),
		CURP			VARCHAR(18),
		Genero			INT,
		FechaNac		VARCHAR(20),
		DireccionID		INT,

        EstadoID		INT,
		EstadoClave		VARCHAR(20),
		MunicipioID		INT,
		MunicipioClave	VARCHAR(20),
		ColoniaID		INT,

        CodigoPostal	VARCHAR(20),
		Localidad		VARCHAR(20),
		CodigoPais		VARCHAR(20),
		NumAportacion	INT,
		MtoAportacion	DECIMAL(12,2),

        NumAportaVol	INT,
		MtoAportaVol	DECIMAL(12,2),
		NumContrato		VARCHAR(20),
		NumeroCuenta	VARCHAR(20),
		Sucursal		VARCHAR(150),

        FechaApertura	VARCHAR(20),
		TipoModalidad	VARCHAR(1),
		TasaInteres		DECIMAL(14,2),
		Moneda			CHAR(2),
		Plazo			INT,

        FechaVencim		VARCHAR(20),
		SaldoIniPer		DECIMAL(14,2),
		MtoDepositos	DECIMAL(14,2),
		MtoRetiros		DECIMAL(14,2),
		IntDevNoPago	DECIMAL(14,2),

        SaldoFinal		DECIMAL(14,2),
		FecUltMov		VARCHAR(20),
		TipoApertura	VARCHAR(1),
		TipoProducto	INT,

		InstrumentoID 	BIGINT,
		TipoInstrumento	CHAR(1),

		INDEX TMPREGB0841_idx1(ClienteID),
		INDEX TMPREGB0841_idx2(InstrumentoID),
		INDEX TMPREGB0841_idx3(EstadoID, MunicipioID, ColoniaID),
        INDEX TMPREGB0841_idx4(Sucursal)
		);

	SET Var_FechaHis := (SELECT MAX(Fecha)
							FROM `HIS-CUENTASAHO` WHERE Fecha <= Par_Fecha);

	SET Var_FechaHis := IFNULL(Var_FechaHis, Fecha_Vacia);

	SELECT MontoAportacion, MonedaBaseID INTO Var_MtoMinAporta, Var_MonedaBase
		FROM PARAMETROSSIS;

	SET Var_MtoMinAporta := IFNULL(Var_MtoMinAporta, Entero_Cero);
	SET Var_IniMes := DATE_ADD(Par_Fecha, INTERVAL ((DAY(Par_Fecha)*-1) + 1) DAY);

	SET	Var_FecBitaco	:= NOW();

     -- Actualiza el Primer deposito en la cuenta, para las que fueron creadas durante el periodo
    CALL PRIMERDEPCTAHOPRO(Entero_Cero,Par_Fecha,Salida_NO,Var_NumErr,Var_ErrMen, Par_EmpresaID,Aud_Usuario,Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,Aud_Sucursal,Aud_NumTransaccion);


	INSERT INTO TMPREGB0841
		SELECT  His.ClienteID,
				CASE WHEN Cli.TipoPersona = Moral THEN Cli_Moral
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.EsMenorEdad = Con_NO THEN Cli_Fisica
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.EsMenorEdad = SI THEN Cli_FisMen
				END,
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
					 ELSE Cadena_Cero
				END ,
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END,
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						  IFNULL(Cli.RFCOficial,Cadena_Vacia)
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
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						IFNULL(REPLACE(CONVERT(Cli.FechaNacimiento, CHAR),'-',Cadena_Vacia),Fecha_Nula)

					 ELSE
						REPLACE(CONVERT(IFNULL(( SELECT Esc.FechaEsc
											FROM ESCRITURAPUB Esc
											WHERE Esc.ClienteID = Cli.ClienteID
											  AND Esc.Esc_Tipo = Tipo_C
											LIMIT 1 ), Fecha_Nula), CHAR),'-',Cadena_Vacia)
				END,

				IFNULL(Dir.DireccionID, Entero_Cero),
				IFNULL(Dir.EstadoID, Entero_Cero),
				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,
				IFNULL(Dir.MunicipioID, Entero_Cero), Cadena_Vacia AS MunicipioClave,
				Dir.ColoniaID, Dir.CP,
				Cadena_Vacia AS Localidad, Codigo_Pais AS CodigoPais,
				Entero_Cero AS NumAportacion, Entero_Cero AS MontoAportacion,
				Entero_Cero AS NumAportaVol, Entero_Cero AS MtoAportaVol,
				No_Aplica AS NumContrato,
				CONVERT(His.CuentaAhoID, CHAR),
				CONVERT(Suc.NombreSucurs, CHAR),
				IFNULL(REPLACE(CONVERT(CONVERT(His.FechaApertura, DATE), CHAR),'-',Cadena_Vacia),Fecha_Nula),

				CASE WHEN IFNULL(Cli.EsMenorEdad, Con_NO) = Con_NO THEN Socio_Individual -- Socio individual
					 WHEN IFNULL(Cli.EsMenorEdad, Con_NO) = SI THEN Ahorro_Menores -- Ahorro Menores
				END,
				ROUND(His.TasaInteres,2),
				CASE WHEN His.MonedaID = Var_MonedaBase THEN Moneda_Nacional
					 ELSE Moneda_Extran
				END,
				PLazo_Mes AS Plazo,
				Fecha_Nula AS FechaVencim,
				His.SaldoIniMes, 	His.AbonosMes, His.CargosMes,
				Entero_Cero AS IntDevNoPago,	His.Saldo,

				Fecha_Nula AS FecUltMov,

				Tipo_Apertura AS TipoApertura,

				CASE WHEN Tip.GeneraInteres = SI AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisConInt	-- a la vista, con intereses, libres de gravamen.
					 WHEN Tip.GeneraInteres = Con_NO AND ClasificacionConta = Dep_Vista THEN
					 Dep_VisSinInt-- a la vista, sin intereses, libres de gravamen
					 WHEN ClasificacionConta = Dep_Ahorro THEN
					 Dep_AhoInte	-- depositos de ahorro, libres de gravamen

				END ASTipoProducto,

				His.CuentaAhoID,
				Ins_CueAhorro
			FROM `HIS-CUENTASAHO` His,
				 TIPOSCUENTAS Tip,
				 SUCURSALES Suc,
				 CLIENTES Cli

			LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, Con_NO) = SI

			WHERE His.Fecha = Var_FechaHis
			  AND His.Estatus IN (Cue_Activa, Cue_Bloqueada)
			  AND His.ClienteID = Cli.ClienteID
			  AND His.TipoCuentaID = Tip.TipoCuentaID
			  AND Tip.EsBancaria = Con_NO
			  AND His.SucursalID = Suc.SucursalID;
-- -------------------------------------------------------------- --
	-- Fecha de Ultimo Movimiento
	CREATE TEMPORARY TABLE TMPREGDESCAPTULTABONO(
		CuentaAhoID		BIGINT,
		FechaUltMov		DATE,

		INDEX TMPREGDESCAPTULTABONO_idx1(CuentaAhoID));

	INSERT INTO TMPREGDESCAPTULTABONO
		SELECT	Mov.CuentaAhoID,
				REPLACE(CONVERT(IFNULL(MAX(Fecha), Fecha_Vacia), CHAR),'-',Cadena_Vacia)
			FROM `HIS-CUENAHOMOV` Mov,
				 TMPREGB0841 Tem
			WHERE Mov.CuentaAhoID = Tem.InstrumentoID
			  AND Mov.Fecha  <= Par_Fecha
			  AND Mov.ProgramaID != 'CIERREMESAHORRO'
			GROUP BY Mov.CuentaAhoID;

	UPDATE TMPREGB0841 Tem, TMPREGDESCAPTULTABONO Mov SET
		Tem.FecUltMov = Mov.FechaUltMov
		WHERE Tem.InstrumentoID = Mov.CuentaAhoID;

	DROP TABLE IF EXISTS TMPREGDESCAPTULTABONO;

-- --------------------------------------------------------- --
	-- --------------------------------------
	-- SALDOS BLOQUEADOS POR GTI LIQUIDA ----
	-- --------------------------------------

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

	UPDATE TMPREGB0841 Tem, TMP_GTIALIQ_AHORRO Gar SET
		TipoProducto = CASE WHEN TipoProducto  = Dep_VisSinInt THEN Dep_VisSinIntCre -- a la vista, sin intereses, que amparan creditos otorgados.
							WHEN TipoProducto  = Dep_VisConInt THEN Dep_VisIntCre -- a la vista, con intereses, que amparan creditos otorgados.
							WHEN TipoProducto  = Dep_AhoInte THEN Dep_AhoAmpCre -- depositos de ahorro, que amparan creditos otorgados.
						END
		WHERE Tem.InstrumentoID = Gar.Cuenta;

	DROP TABLE IF EXISTS TMP_GTIALIQ_AHORRO;

	-- -----------------------------------------
	-- INVERSIONES A PLAZO ---------------------
	-- -----------------------------------------

	INSERT INTO TMPREGB0841
		SELECT	Inv.ClienteID,
				CASE WHEN Cli.TipoPersona = Moral THEN Cli_Moral
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.EsMenorEdad = Con_NO THEN Cli_Fisica
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.EsMenorEdad = SI THEN Cli_FisMen
				END,
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
					 ELSE Cadena_Cero
				END ,
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
                           CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
							   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Cero
				END,
				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   IFNULL(Cli.RFCOficial,Cadena_Vacia)
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

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						IFNULL(REPLACE(CONVERT(Cli.FechaNacimiento, CHAR),'-',Cadena_Vacia),Fecha_Nula)

					 ELSE REPLACE(CONVERT(IFNULL(( SELECT Esc.FechaEsc
											FROM ESCRITURAPUB Esc
											WHERE Esc.ClienteID = Cli.ClienteID
											  AND Esc.Esc_Tipo = Tipo_C
											LIMIT 1 ), Fecha_Nula), CHAR),'-',Cadena_Vacia)
				END,

				IFNULL(Dir.DireccionID, Entero_Cero),
				IFNULL(Dir.EstadoID, Entero_Cero),
				IFNULL(Dir.EstadoID, Entero_Cero) AS EstadoClave,
				IFNULL(Dir.MunicipioID, Entero_Cero), Cadena_Vacia AS MunicipioClave,
				Dir.ColoniaID, Dir.CP,
				Cadena_Vacia AS Localidad, Codigo_Pais AS CodigoPais,
				Entero_Cero AS NumAportacion, Entero_Cero AS MontoAportacion,
				Entero_Cero AS NumAportaVol, Entero_Cero AS MtoAportaVol,
				No_Aplica AS NumContrato,
				CONVERT(Inv.InversionID, CHAR),
				CONVERT(Suc.NombreSucurs, CHAR),
				IFNULL(REPLACE(CONVERT(CONVERT(Inv.FechaInicio, DATE), CHAR),'-',Cadena_Vacia),Fecha_Nula),

				CASE WHEN IFNULL(Cli.EsMenorEdad, Con_NO) = Con_NO THEN Socio_Individual -- Socio individual
					 WHEN IFNULL(Cli.EsMenorEdad, Con_NO) = SI THEN Ahorro_Menores -- Ahorro Menores
				END,
				ROUND(Inv.Tasa,2),
				CASE WHEN Inv.MonedaID = Var_MonedaBase THEN Moneda_Nacional
					 ELSE Moneda_Extran
				END,
				DATEDIFF(Inv.FechaVencimiento, Inv.FechaInicio) AS Plazo,
				REPLACE(CONVERT(Inv.FechaVencimiento, CHAR),'-',Cadena_Vacia) AS FechaVencimiento,

				CASE WHEN Inv.FechaInicio < Var_IniMes THEN Inv.Monto
					 ELSE Entero_Cero
				END ASSaldoIniMes,

				CASE WHEN Inv.FechaInicio >= Var_IniMes THEN Inv.Monto
					 ELSE Entero_Cero
				END ASAbonosMes,
				Entero_Cero AS CargosMes,

				ROUND(((DATEDIFF(Par_Fecha, Inv.FechaInicio ) + 1 ) * Inv.Monto * Inv.Tasa) /
						(360 * 100), 2) AS IntDevNoPago,

				Inv.Monto AS SaldoFinal,
				IFNULL(DATE_FORMAT(Inv.FechaInicio,'%Y%m%d'),Fecha_Nula) AS FecUltMov,
				Tipo_Apertura AS TipoApertura,
				Dep_Plazo AS TipoProducto, -- otros depositos a plazo, libres de gravamen.
				Inv.InversionID,
				Ins_InvPlazo

		FROM HISINVERSIONES Inv,
			 SUCURSALES Suc,
			 CLIENTES Cli

		LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
											AND IFNULL(Dir.Oficial, Con_NO) = SI


		WHERE Inv.Estatus = Con_NO
        AND  Inv.ClienteID <> Cliente_Inst
		AND  Inv.FechaCorte  = Var_FechaCieInv
	  AND Inv.ClienteID = Cli.ClienteID
	  AND Cli.SucursalOrigen = Suc.SucursalID
		ORDER BY Suc.SucursalID, InversionID;

	-- --------------------------------------
	-- INVERSIONES EN GARANTIA
	-- --------------------------------------
	DROP TABLE IF EXISTS TMP_INVGAR;

	CREATE TABLE TMP_INVGAR (
		InversionID	BIGINT);

	CREATE INDEX idx1_TMP_INVGAR ON TMP_INVGAR (InversionID);

	INSERT INTO TMP_INVGAR
		SELECT Gar.InversionID
			FROM CREDITOINVGAR Gar
			WHERE FechaAsignaGar <= Par_Fecha;

	INSERT INTO TMP_INVGAR
		SELECT Gar.InversionID
			FROM HISCREDITOINVGAR Gar
			WHERE Gar.Fecha > Par_Fecha
			  AND Gar.FechaAsignaGar <= Par_Fecha
			  AND Gar.ProgramaID NOT IN ('CIERREGENERALPRO');

	UPDATE TMPREGB0841 Tem, TMP_INVGAR Gar SET
		TipoProducto = CASE WHEN TipoProducto  = Dep_Plazo THEN Dep_PlazoAmpCre -- a la vista, sin intereses, que amparan creditos otorgados.
					   ELSE TipoProducto END
		WHERE Tem.InstrumentoID = Gar.InversionID
		  AND Tem.TipoInstrumento = Ins_InvPlazo;

	DROP TABLE IF EXISTS TMP_INVGAR;

	-- --------------------------------------
	-- ESTADOS Y MUNICIPIOS -----------------
	-- --------------------------------------

	UPDATE TMPREGB0841 Tem, COLONIASREPUB Col SET
		Tem.MunicipioClave	= Col.CodigoPostal,
		Tem.CodigoPostal 	= Col.CodigoPostal,
		Tem.Localidad		= Col.ClaveINEGI

		WHERE Tem.EstadoID = Col.EstadoID
		  AND Tem.MunicipioID = Col.MunicipioID
		  AND Tem.ColoniaID = Col.ColoniaID;

	UPDATE TMPREGB0841 Tem, COLONIASREPUB Col SET
		Tem.Localidad		= Col.ClaveINEGI
		WHERE Tem.EstadoID = Col.EstadoID
		  AND Tem.CodigoPostal = Col.CodigoPostal
          AND IFNULL(Tem.Localidad,Cadena_Vacia) = Cadena_Vacia;


	-- ---------------------------------------
	-- APORTACION SOCIAL	 -----------------
	-- ---------------------------------------
	DROP TABLE IF EXISTS tmp_MovAportSocial;

	CREATE TABLE tmp_MovAportSocial
		SELECT Mov.ClienteID, SUM(CASE WHEN Mov.Tipo = Tipo_Deposito THEN Mov.Monto ELSE Mov.Monto * -1 END) AS Monto
			FROM APORTACIONSOCIO Apo
			INNER JOIN APORTASOCIOMOV Mov ON Mov.ClienteID = Apo.ClienteID
			WHERE Apo.FechaRegistro <= Par_Fecha
			  AND Mov.Fecha > Par_Fecha
			GROUP BY Mov.ClienteID;

	CREATE INDEX idx_MovAportSoc_Cliente ON tmp_MovAportSocial (ClienteID);


	DROP TABLE IF EXISTS tmp_SaldosAportSocial;

	CREATE TABLE tmp_SaldosAportSocial
		SELECT Apo.ClienteID, (IFNULL(Apo.Saldo, 0.0) + IFNULL(Mov.Monto, 0.00)) AS AportacionSocial
			FROM APORTACIONSOCIO Apo
			LEFT JOIN tmp_MovAportSocial Mov ON Apo.ClienteID = Mov.ClienteID
			WHERE Apo.FechaRegistro <= Par_Fecha;

	CREATE INDEX idx_tmp_SaldosAportSocial_Cliente ON tmp_SaldosAportSocial (ClienteID);

	UPDATE TMPREGB0841 Tem, tmp_SaldosAportSocial Apo SET
		Tem.MtoAportacion = Apo.AportacionSocial,
		Tem.NumAportacion = CASE WHEN Var_MtoMinAporta = Entero_Cero THEN
									  Entero_Cero
								 ELSE ROUND(Apo.AportacionSocial / Var_MtoMinAporta, Entero_Cero) END
		WHERE Apo.ClienteID = Tem.ClienteID;

	DROP TABLE IF EXISTS tmp_SaldosAportSocial;
	DROP TABLE IF EXISTS tmp_MovAportSocial;

	IF( Par_NumReporte = Rep_Excel) THEN
		SELECT 	Var_Periodo,				Var_ClaveEntidad,
				For_0841 AS Formulario,
                CONVERT(ClienteID, CHAR) AS NumIdentificacion,
				TipoPersona,
                FNLIMPIACARACTERESGEN(Nombre,'MA') Nombre,
                FNLIMPIACARACTERESGEN(ApellidoPat,'MA') ApellidoPat,
				FNLIMPIACARACTERESGEN(ApellidoMat,'MA') ApellidoMat,
                RFC,
				FNLIMPIACARACTERESGEN(CURP,'MA') CURP,
                Genero,
				IFNULL(FechaNac,Fecha_Nula) AS FechaNac,
                CodigoPostal,
		        Localidad,
                EstadoClave,
				CodigoPais,
                NumAportacion,
				ROUND(MtoAportacion,Entero_Cero) AS
                MtoAportacion,
		        NumAportaVol,
                ROUND(MtoAportaVol, Entero_Cero) AS MtoAportaVol,
				NumContrato,
                NumeroCuenta,
				FNLIMPIACARACTERESGEN(Sucursal,'MA') Sucursal,
                IFNULL(FechaApertura,Fecha_Nula) AS FechaApertura,
				TipoProducto,
                TipoModalidad,
		        TasaInteres,
                Moneda,
		        Plazo,
                IFNULL(FechaVencim,Fecha_Nula) AS FechaVencim,
				ROUND(SaldoIniPer, Entero_Cero) AS SaldoIniPer,
				ROUND(MtoDepositos, Entero_Cero) AS MtoDepositos,
				ROUND(MtoRetiros, Entero_Cero) AS MtoRetiros,
				ROUND(IntDevNoPago, Entero_Cero) AS IntDevNoPago,
				ROUND(SaldoFinal, Entero_Cero) AS SaldoFinal,
				IFNULL(DATE_FORMAT(FecUltMov,'%Y%m%d'),Fecha_Nula) AS FecUltMov,
                TipoApertura
		FROM TMPREGB0841;
		ELSE
		IF( Par_NumReporte = Rep_Csv) THEN
			SELECT  CONCAT(
				For_0841,';',
                CONVERT(ClienteID, CHAR),';',
				IFNULL(TipoPersona,Cadena_Vacia),';',
                IFNULL(FNLIMPIACARACTERESGEN(Nombre,'MA'),Cadena_Vacia),';',
				IFNULL(FNLIMPIACARACTERESGEN(ApellidoPat,'MA'),Cadena_Vacia),';',
                IFNULL(FNLIMPIACARACTERESGEN(ApellidoMat,'MA'),Cadena_Vacia),';',
				IFNULL(RFC,Cadena_Vacia),';',
                IFNULL(FNLIMPIACARACTERESGEN(CURP,'MA'),Cadena_Vacia),';',
		        IFNULL(Genero,Cadena_Vacia),';',
                IFNULL(FechaNac,Cadena_Vacia),';',
				IFNULL(CodigoPostal,Cadena_Vacia),';',
                TRIM(IFNULL(Localidad,Cadena_Vacia)),';',
				IFNULL(EstadoClave,Cadena_Vacia),';',
                IFNULL(CodigoPais,Cadena_Vacia),';',
				IFNULL(NumAportacion,Entero_Cero),';',
                ROUND(IFNULL(MtoAportacion,Entero_Cero),Entero_Cero),';',
		        IFNULL(NumAportaVol,Cadena_Vacia),';',
                ROUND(IFNULL(MtoAportaVol,Entero_Cero), Entero_Cero),';',
				IFNULL(NumContrato,Cadena_Vacia),';',
                IFNULL(NumeroCuenta,Cadena_Vacia),';',
				IFNULL(Sucursal,Cadena_Vacia),';',
                IFNULL(FechaApertura,Fecha_Nula),';',
				IFNULL(TipoProducto,Cadena_Vacia),';',
                IFNULL(TipoModalidad,Cadena_Vacia),';',
		        IFNULL(TasaInteres,Cadena_Vacia),';',
                IFNULL(Moneda,Cadena_Vacia),';',
		        IFNULL(Plazo,Cadena_Vacia),';',
                IFNULL(FechaVencim,Fecha_Nula),';',
				ROUND(SaldoIniPer, Entero_Cero),';',
				ROUND(IFNULL(MtoDepositos,Entero_Cero), Entero_Cero),';',
				ROUND(IFNULL(MtoRetiros,Entero_Cero), Entero_Cero),';',
				ROUND(IntDevNoPago, Entero_Cero),';',
				ROUND(IFNULL(SaldoFinal,Entero_Cero), Entero_Cero),';',
				IFNULL(DATE_FORMAT(FecUltMov,'%Y%m%d'),Fecha_Nula),';',
		        IFNULL(TipoApertura,Cadena_Vacia)) AS Valor
			FROM TMPREGB0841;
		END IF;
	END IF;


END TerminaStore$$