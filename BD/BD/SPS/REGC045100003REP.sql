-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGC045100003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGC045100003REP`;
DELIMITER $$

CREATE PROCEDURE `REGC045100003REP`(
-- ============================================================================================================
-- ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE C0451 Version SOFIPO -----------------------
-- ============================================================================================================
	Par_Fecha           DATE,					-- Fecha del reporte
	Par_NumReporte      TINYINT UNSIGNED,		-- Tipo de reporte 1: Excel 2: CVS
	Par_NumDecimales    INT(11),				-- Numero de Decimales en Cantidades o Montos

    Par_EmpresaID       INT(11),				-- Auditoria
    Aud_Usuario         INT(11),				-- Auditoria
    Aud_FechaActual     DATETIME,				-- Auditoria
    Aud_DireccionIP     VARCHAR(15),			-- Auditoria
    Aud_ProgramaID      VARCHAR(50),			-- Auditoria
    Aud_Sucursal        INT(11),				-- Auditoria
    Aud_NumTransaccion  BIGINT(20)				-- Auditoria
		)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_ClaveEntidad	VARCHAR(300);	-- Clave de la Entidad de la institucion
	DECLARE Var_Periodo			CHAR(6);		-- Periodo al que pertenece el reporte ano+mes
	DECLARE Var_TipoSIC			CHAR(1);		-- Tipo de Clave SIC
	DECLARE Var_TipoRepActEco	CHAR(1);		-- Tipo de reporte de actividad Economica
	-- Declaracion de Constantes
	DECLARE Rep_Excel       	INT(11); 		-- Reporte en Excel
	DECLARE Rep_Csv				INT(11); 		-- Report en Csv
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE Cadena_Cero			CHAR(1);		-- Fecha Vacia
	DECLARE Fecha_Vacia			DATE;			-- Cadena cero

    DECLARE Valor_SI 			CHAR(1);		-- Respuesta SI
	DECLARE Valor_NO 			CHAR(1);		-- Respuesta NO
	DECLARE Per_Fisica			CHAR(1);		-- Persona fisica
	DECLARE Per_Moral			CHAR(1);		-- Persona Moral
	DECLARE Fisica_empre		CHAR(1);		-- Persona fisica con actividad empresarial

    DECLARE Gen_Masculino		CHAR(1);		-- Genero masculino
	DECLARE Gen_Femenino    	CHAR(1);		-- Genero femenino
	DECLARE Es_Nacional 		CHAR(1);		-- Es Persona nacional
	DECLARE Entero_Cero			INT(11);		-- Entero Cero
    DECLARE Apellido_Vacio		VARCHAR(20);  	-- Cuando no tiene apellido se coloca X

    DECLARE Tipo_Consanguineo	CHAR(1);		-- Tipo de relacion consanguinea
	DECLARE Tipo_Afinidad		CHAR(1);		-- Tipo de Afinidad
	DECLARE Rel_GradoUno		INT(11);		-- Relacion de grado 1
	DECLARE Rel_GradoDos		INT(11);		-- Relacion de grado 2
	DECLARE Tipo_Cliente		INT(11); 		-- Tipo de cliente

    DECLARE Tipo_Empleado		INT(11);    	-- Tipo de empleado
    DECLARE	Cla_SinRelacion		VARCHAR(2);		-- Clasificacion sin relacion
	DECLARE Cla_ConsejoAdmon	VARCHAR(2);		-- Relacion con el consejo administrativo
	DECLARE Cla_ConsejoVigil	VARCHAR(2);		-- Realcion con el consejo de vigilacia
	DECLARE Cla_ComiteCredito	VARCHAR(2);		-- Realcion con el comite de credito

    DECLARE Cla_DirGeneral		VARCHAR(2);		-- Con el director general
    DECLARE	Cla_FamFuncionario	VARCHAR(2);		-- familiar que es funcionario
    DECLARE Var_FechaIniMesSis  DATE;			-- Fecha de incio del mes actual
	DECLARE Cla_PaisMexico      INT(11);        -- Clave del pais mexico cnbv
	DECLARE Cla_Reporte451      INT(11);        -- Clave para el reporte 451

    DECLARE Cast_Mayuscula	  	VARCHAR(2);		-- Poner en mayusculas
    DECLARE Fecha_Nula		  	VARCHAR(8);		-- Fecha nula con el formato SITI
    DECLARE No_Aplica		  	VARCHAR(15);	-- No aplica
    DECLARE Clave_SIP		  	VARCHAR(15);	-- Clase de consulta SIP
    DECLARE Decimal_Cero	  	DECIMAL(8,2);	-- DECIMAL Cero

    DECLARE Cred_Comercial	  	CHAR(1);		-- Credito comercial
    DECLARE Cred_Consumo	  	CHAR(1);		-- credito de consumo
    DECLARE Cred_Vivienda	  	CHAR(1);		-- credito de vivienda
    DECLARE Clave_Comercial	  	SMALLINT;		-- clave para cred comerciales
    DECLARE Clave_Consumo	  	SMALLINT;		-- clave cred de consumo

    DECLARE Clave_Vivienda	  	SMALLINT;		-- Clave para cred vivienda
    DECLARE Cred_Nuevo		  	CHAR(1);		-- Credito tipo Nuevo
    DECLARE Cred_Restructura  	CHAR(1);		-- Credito reestructurado
    DECLARE Cred_Renovado	  	CHAR(1);		-- credito renovado
    DECLARE Linea_Inactiva	  	CHAR(1);    	-- Linea de credito activa

	DECLARE Cla_CreNuevo        INT(11);        -- Clasificacion de credito nuevo
	DECLARE Cla_CreRestru       INT(11);        -- Clasif. Cred. Reestructurado
	DECLARE Cla_CreRenova       INT(11);        -- Clasif. Cred. Renovado
    DECLARE Cred_Vigente	  	CHAR(1);		-- Credito Vigente
    DECLARE Cred_Vencido	  	CHAR(1);		-- Credito Vencido

    DECLARE Cred_Pagado	  		CHAR(1);		-- Credito Pagado
    DECLARE Cred_Castigado	  	CHAR(1);		-- Credito Castigado
    DECLARE Cli_AcreyAhorro  	SMALLINT;		-- Cliente ahorrador y acreditado
    DECLARE Clave_MoralNac 	  	SMALLINT;		-- Clave para personas morales nacionales
    DECLARE Clave_MoralExt 		SMALLINT;		-- Clave para personas morales extranjeras

    DECLARE Clave_FisicaNac	  	SMALLINT;		-- Clave personas fisicas nacionales
    DECLARE Clave_FisicaExt  	SMALLINT;		-- clave personas fisicas extranjeras
    DECLARE Micro_Empresa	  	SMALLINT;		-- Micro empresa
    DECLARE Calc_TasaFija	  	SMALLINT;		-- Calculo de tasa fija
    DECLARE Clave_TasaFija	  	SMALLINT;		-- Clave para tasa fija

    DECLARE Clave_SinAjuste	  	SMALLINT;		-- Clave sin ajuste de tasa
    DECLARE Sin_ClaveRefere	  	SMALLINT;		-- Sin clave de referencia
    DECLARE Moneda_Pesos	  	SMALLINT;		-- Clave SITI para Pesos
    DECLARE Clave_PesosCC	  	SMALLINT;		-- Clave Pesos CC
    DECLARE Clave_DolarCC	  	SMALLINT;		-- Clave dolares CC

    DECLARE Periodo_FactOtro	SMALLINT;		-- Periodo de facturacion
    DECLARE Periodo_CapOtra		SMALLINT;		-- Periodo de capital
    DECLARE Periodo_IntOtra		SMALLINT;		-- periodo de interes
	DECLARE Rel_FuncEmpleado    INT(11);        -- Relacion con funcionario o empleado
	DECLARE Rel_AccionistasdSoc INT(11);        -- Relacion con Accionistas
	DECLARE Rel_ConsejoSoc      INT(11);        -- Relacion con el consejo de sociedad
	DECLARE Rel_Familiar        INT(11);        -- Relacion familiar
	DECLARE Clave_FuncEmpleado  INT(11);        -- Clave de funcionario o empleado
	DECLARE	SIC_BuroCredito		CHAR(1);		-- Clave SIC de consulta Buro
	DECLARE	SIC_CirculoCredito	CHAR(1);		-- Clave SIC circulo de credito
	DECLARE	Rep_ActDestinos		CHAR(1);

	DECLARE Dis_NoRevUnaDisp    INT(11);        -- Una disposicion
	DECLARE Dis_NoRevMultDisp   INT(11);        -- Multiples disposiciones
	DECLARE Dis_Revolvente      INT(11);        -- Es revolvente
	DECLARE	SI_ManejaLinea		CHAR(1);		-- Maneja linea de credito

	DECLARE Com_Porcentaje		CHAR(1);		-- Comision por apertura  - Porcentaje
	DECLARE Com_Monto			CHAR(1);		-- Comision por apertura  - Monto
	DECLARE Param_ID            INT(11);        -- ID de los parametros
	DECLARE Con_PeriodoFactura  INT(11);        -- ID de los parametros
	DECLARE Cla_CredCovid       INT(11);
	DECLARE Entero_Uno			INT(11);		-- Entero Uno

	-- Asignacion de Constantes
	SET Rep_Excel       	:= 	1;      		-- Opcion para generar los datos para el excel
	SET Rep_Csv				:=	2;				-- Opcion para generar datos para el CVS
	SET Cadena_Vacia		:= 	'';				-- Cadena vacia
	SET Fecha_Vacia			:= 	'1900-01-01';	-- Fecha vacia
	SET Valor_SI 			:=	'S';			-- SI

    SET Valor_NO 			:=	'N'; 			-- NO
	SET Per_Fisica			:=	'F';			-- Tipo de persona fisica
	SET Per_Moral			:=	'M';			-- Tipo de persona moral
	SET Fisica_empre		:=	'A';			-- Persona Fisica Con Actividad Empresarial
	SET Gen_Masculino		:=	'M';			-- Sexo masculino

    SET Gen_Femenino		:=	'F';			-- Sexo femenino
	SET Es_Nacional			:= 	'N';			-- Nacionalidad del cliente 'N' = Nacional
	SET Entero_Cero			:= 0;
	SET Par_NumDecimales	:= 0;			-- EL reporte se presenta con montos a 0 decimales
	SET Apellido_Vacio 		:= 'NO APLICA';

    SET Tipo_Consanguineo	:= "C";			-- Tipo de Relacion: Consanguinea
	SET Tipo_Afinidad		:= "A";			-- Tipo de Relacion: Afinidad
	SET Rel_GradoUno		:= 1;			-- Nivel de la Relacion: UNO
	SET Rel_GradoDos		:= 2;			-- Nivel de la Relacion: DOS
	SET Tipo_Cliente		:= 1;			-- Tipo de Relacionado: Cliente

    SET Tipo_Empleado		:= 2;			-- Tipo de Relacionado: Empleado
	SET Cla_SinRelacion		:= '1';			-- Tipo de Relacionado: Sin Relacion
	SET Cla_ConsejoAdmon	:= '2';			-- Tipo de Relacionado: Familiar de Funcionario
	SET Cla_ConsejoVigil	:= '3';			-- Tipo de Relacionado: Familiar de Funcionario
	SET Cla_ComiteCredito	:= '4';			-- Tipo de Relacionado: Familiar de Funcionario

    SET Cla_DirGeneral		:= '7';			-- Tipo de Relacionado: Familiar de Funcionario
	SET Cla_FamFuncionario	:= '6';			-- Tipo de Relacionado: Familiar de Funcionario
    SET Cla_CreNuevo		:=132;
    SET Cla_CreRestru		:=133;
    SET Cla_CreRenova		:=134;
	SET Cla_CredCovid       := 160;         -- Tipo de Credito Diferido

    SET Cadena_Cero			:= '0';
    SET Cla_PaisMexico		:= 484;
    SET Cla_Reporte451		:= 451;
    SET Cast_Mayuscula		:= 'MA';
    SET Fecha_Nula			:= '01011900';

    SET Decimal_Cero		:= 0.0;
    SET Cred_Comercial		:= 'C';
    SET Cred_Consumo		:= 'O';
	SET	Cred_Vivienda		:= 'H';
	SET Clave_Comercial		:= 2;

    SET Clave_Consumo		:= 3;
	SET	Clave_Vivienda		:= 1;
    SET Cred_Nuevo			:= 'N';
	SET Cred_Restructura	:= 'R';
	SET Cred_Renovado		:= 'O';

    SET No_Aplica			:= 'NO APLICA';
	SET Clave_SIP			:= 'XXXX010101AAA';
	SET Cred_Vigente		:= 'V';
	SET Cred_Vencido		:= 'B';
	SET Cred_Pagado			:= 'P';

    SET Cred_Castigado		:= 'K';
	SET Linea_Inactiva		:= 'I';
	SET Cli_AcreyAhorro		:= 1;
	SET Clave_MoralNac		:= 2;
	SET Clave_MoralExt		:= 4;

    SET Clave_FisicaNac		:= 1;
	SET Clave_FisicaExt		:= 3;
	SET Micro_Empresa		:= 1;
	SET Calc_TasaFija		:= 1;
	SET Clave_TasaFija		:= 150;

    SET Sin_ClaveRefere		:= 600; -- Tasa Fija
	SET Clave_SinAjuste		:= 110;
	SET Moneda_Pesos		:= 1;
	SET Clave_PesosCC		:= 0;
	SET Clave_DolarCC		:= 1;

    SET Periodo_FactOtro	:= 6;
	SET Periodo_CapOtra		:= 10;
	SET Periodo_IntOtra		:= 13;
	SET Rel_FuncEmpleado	:= 101;				-- Relacion: Funcionario o Empleado
	SET Rel_AccionistasdSoc	:= 2;				-- Relacion: Personas con titulos de una SOFIPO
	SET Rel_ConsejoSoc		:= 3;				-- Relacion: Personas del Consejo de Admon de una SOFIPO
	SET Rel_Familiar		:= 5;				-- Relacion: Personas Familiar con Parenteso grado 1 y 2
	SET Clave_FuncEmpleado	:= 4;				-- Relacion: Clave de la CNBV para Empleado y Funcionario con Credito Comercial
	SET SIC_BuroCredito		:= 'B';				-- Tipo de Servicios de Informacion Crediticia: Buro de Credito
	SET SIC_CirculoCredito	:= 'C';				-- Tipo de Servicios de Informacion Crediticia: Circulo de Credito
	SET Rep_ActDestinos		:= 'D';				-- Reportar actividad de creditos por destino
	SET	Dis_NoRevUnaDisp	:= 101;				-- No Revolvente una sola Disposicion
	SET	Dis_NoRevMultDisp	:= 102;				-- No Revolvente multiples Disposiciones
	SET	Dis_Revolvente		:= 103;				-- Linea Revolvente
	SET	SI_ManejaLinea		:= 'S';				-- Si maneja Linea de Credito
	SET Com_Porcentaje 		:= 'P';
	SET Com_Monto 			:= 'M';
    SET Param_ID			:= 1;
	SET Con_PeriodoFactura	:= 5;
	SET Entero_Uno			:= 1;


	SET Var_Periodo = CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),1,4),
							  SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',Cadena_Vacia),5,2));

	SELECT ClaveEntidad,TipoRepActEco
    INTO Var_ClaveEntidad,Var_TipoRepActEco
	FROM PARAMREGULATORIOS
	WHERE ParametrosID = Param_ID;

	SET Var_FechaIniMesSis := DATE_ADD(Par_Fecha, INTERVAL -1*(DAY(Par_Fecha))+1 DAY);



	DROP TABLE IF EXISTS TMPREG0451REG;
	CREATE TEMPORARY TABLE TMPREG0451REG(
		ClienteID		BIGINT,
		TipoCliente     INT(11),
		TipoPersona		CHAR(1),
		Nombre			VARCHAR(250),
		ApellidoPaterno VARCHAR(100),
		ApellidoMaterno VARCHAR(100),

		PersoJuridica   INT(11),
		GrupoRiesgo		VARCHAR(250),
		ActividadBMX	BIGINT,
		ActividadEco	VARCHAR(8),
		Nacionalidad	INT,

        FechaNacimiento VARCHAR(8),
		RFC				VARCHAR(13),
		CURP 			VARCHAR(18),
		Genero          INT(11),
		Calle			VARCHAR(100),

        NumeroExt		VARCHAR(50),
		ColoniaID       INT(11),
		Colonia			VARCHAR(100),
		CodigoPostal	VARCHAR(5),
		Localidad		VARCHAR(14),

		Estado          INT(11),
		Municipio       INT(11),
		Pais            INT(11),
		TipoRelacionado INT(11),
		NumConsultaSIC	VARCHAR(18),

        IngresosMes		DECIMAL(16,2),
		TamanioAcred	INT,
		IdenCreditoCNBV	VARCHAR(29),
		IdenGrupalCNBV	VARCHAR(250),
		FechaOtorga		VARCHAR(8),

		TipoAlta        INT(11),
		TipoCartera     INT(11),
		TipoProducto    VARCHAR(10),
		DestinoCred     INT(11),
		ClaveSucursal	VARCHAR(10),

        NumeroCuenta	VARCHAR(20),
		NumContrato		VARCHAR(20),
		NombreFacto		VARCHAR(200),
		RFCFactorado	VARCHAR(13),
		MontoLineaPes	DECIMAL(21,2),

        MontoLineaOri	DECIMAL(21,2),
		FechaMaxima		VARCHAR(8),
		FechaVencimien	VARCHAR(8),
		FormaDisposi    INT(11),
		TasaReferencia  INT(11),

		Diferencial     INT(11),
		OpeDiferencial  INT(11),
		TipoMoneda      INT(11),
		PeriodicidadCap INT(11),
		PeriodicidadInt INT(11),

		PeriodoFactura  INT(11),
		ComisionAper	DECIMAL(6,2),
		MontoComAper	DECIMAL(21,2),
		ComisionDispo	DECIMAL(6,2),
		MontoComDispo	DECIMAL(21,2),

        ValorVivienda	DECIMAL(21,2),
		ValoAvaluo		DECIMAL(21,2),
		NumeroAvaluo	VARCHAR(17),
		LTV				DECIMAL(6,2),
		LocalidadCred	VARCHAR(14),

		MunicipioCred   INT(11),
		EstadoCred      INT(11),
		ActividadEcoCred VARCHAR(8),
        FechaConsulSIC  DATE,
		CreditoID       BIGINT(12),

		LineaCreditoID  BIGINT(20),
		TasaBase        INT(11),
		CalcInteresID   INT(11),
        TasaFija		DECIMAL(12,4),
		SobreTasa		DECIMAL(12,2),
		FechaInicio		DATE,
        SucursalOrigen	VARCHAR(10)
	);

	CREATE INDEX IDX_REG451_1 ON TMPREG0451REG(ClienteID);
	CREATE INDEX IDX_REG451_2 ON TMPREG0451REG(IdenCreditoCNBV);
	CREATE INDEX IDX_REG451_3 ON TMPREG0451REG(ColoniaID);
	CREATE INDEX IDX_REG451_4 ON TMPREG0451REG(RFC);
	CREATE INDEX IDX_REG451_5 ON TMPREG0451REG(Estado, Municipio, ColoniaID);
	CREATE INDEX IDX_REG451_6 ON TMPREG0451REG(CreditoID);
	CREATE INDEX IDX_REG451_7 ON TMPREG0451REG(SucursalOrigen);

-- ==================== Poblar Credito Con y sin Linea ====================================================

	INSERT INTO TMPREG0451REG
	-- ==== DATOS CLIENTE ===============================================================================
	-- Numero de Cliente
	SELECT Cli.ClienteID,
	-- TIpo de Cliente
	Cli_AcreyAhorro AS TipoCliente, -- Acreditado y Ahorrador,
	Cli.TipoPersona,
	-- Nombre o Razon
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							UPPER(
								SUBSTRING(CONCAT(IFNULL(Cli.PrimerNombre, Cadena_Vacia),
									CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(' ', Cli.SegundoNombre) ELSE Cadena_Vacia
									END,
									CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(' ', Cli.TercerNombre) ELSE Cadena_Vacia
									END), 1, 200)
							)
						 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(Cli.RazonSocial, 'S.A. DE C.V.', ''),
															'SA DE CV', ''),
														'SA. DE C.V', ''),
													'S. A. de CV.', ''),
											'sa de cv', ''),
									's.a. de c.v.', ''))

	END,
	-- Apellido Paterno
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
			CASE WHEN IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = Cadena_Vacia
					OR IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = '.' THEN
				Apellido_Vacio
			ELSE
				UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
			END
		ELSE Entero_Cero
	END ,
	-- Apellido Materno
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
			CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
				OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
					Apellido_Vacio
			ELSE
			 UPPER(IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
			END
		 ELSE Entero_Cero
	END,
	-- Personalidad Juridica
	CASE 	WHEN Cli.Nacion = 	Es_Nacional AND Cli.TipoPersona = 	Per_Moral THEN Clave_MoralNac 	-- Moral Nacional
			WHEN Cli.Nacion = 	Es_Nacional AND Cli.TipoPersona <> 	Per_Moral THEN Clave_FisicaNac 	-- Fisica Nacional
			WHEN Cli.Nacion <> 	Es_Nacional AND Cli.TipoPersona = 	Per_Moral THEN Clave_MoralExt 	-- Moral Extranjera
			WHEN Cli.Nacion <> 	Es_Nacional AND Cli.TipoPersona <> 	Per_Moral THEN Clave_FisicaExt 	-- Fisica Extranjera
		END,
	-- Grupo de RIesgo. Se actualiza mas Adelante
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							UPPER(Cli.NombreCompleto)
		ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(Cli.NombreCompleto, 'S.A. DE C.V.', ''),
															'SA DE CV', ''),
														'SA. DE C.V', ''),
													'S. A. de CV.', ''),
											'sa de cv', ''),
									's.a. de c.v.', ''))
	END AS GrupoRiesgo,
	-- Actividad economica
	Cli.ActividadBancoMX,
	Cadena_Vacia,
	-- Nacionalidad. Se actualiza mas adelante con la CLAVE PAIS NACIONALIDAD CNBV
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
				Cli.PaisNacionalidad
			 ELSE Cli.PaisConstitucionID
		END,
	-- Fecha Nacimiento
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							REPLACE(CONVERT(Cli.FechaNacimiento, CHAR),'-',Cadena_Vacia)
						 ELSE DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%Y%m%d')
					END,
	-- RFC
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							 Cli.RFCOficial
						 ELSE CONCAT("_", SUBSTR(Cli.RFCOficial,1,12))
					END,
	-- CURP
	CASE WHEN Cli.Nacion = Es_Nacional AND ( Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre )THEN
							 Cli.CURP
						 ELSE Cadena_Cero
					END,
	-- Genero
	CASE WHEN Cli.TipoPersona = Per_Moral THEN Cadena_Cero
						 WHEN Cli.TipoPersona IN (Fisica_empre, Per_Fisica) AND Cli.Sexo = Gen_Masculino THEN '2'
						 WHEN Cli.TipoPersona IN (Fisica_empre,Per_Fisica) 	AND Cli.Sexo = Gen_Femenino THEN '1'
					END,
	-- Calle
	IFNULL(Dir.Calle,Cadena_Vacia),
	-- Numero
	CONCAT(IFNULL(NumeroCasa,Cadena_Vacia),IFNULL(NumInterior,Cadena_Vacia)),
	-- Colonia
	IFNULL(Dir.ColoniaID,Entero_Cero),
	IFNULL(Dir.Colonia,Cadena_Vacia) AS NombreColonia,
	-- Codigo postal
	IFNULL(Dir.CP,Cadena_Vacia),
	-- Localidad
	IFNULL(Dir.LocalidadID,Entero_Cero) AS Localidad,
	-- Estado
	IFNULL(Dir.EstadoID,Entero_Cero),
	-- Municipio
	IFNULL(Dir.MunicipioID,Entero_Cero),
	-- Pais
	Cla_PaisMexico AS Pais, 		-- Mexico
	-- Tipo Acreditado
	Cla_SinRelacion, 				-- Se actualiza posteriormente
	-- Clave SIC(NumConsultaSIC)
    CASE WHEN IFNULL(Cre.TipoConsultaSIC,Cadena_Vacia) = 'BC' THEN IFNULL(Cre.FolioConsultaBC,Entero_Cero)
		 WHEN IFNULL(Cre.TipoConsultaSIC,Cadena_Vacia) = 'CC' THEN IFNULL(Cre.FolioConsultaCC,Entero_Cero)
		 ELSE Entero_Cero END AS ClaveSIC,		-- Se actualiza mas Delante
	-- Ingresos Mensuales
	Entero_Cero AS IngMensuales,	-- Actualizar con Consulta a CLIDATSOCIOE
	-- Tamano Acreditado
	CASE WHEN Cre.ClasiDestinCred = Cred_Comercial AND
			Cli.TipoPersona BETWEEN Fisica_empre AND Per_Moral THEN Micro_Empresa
		WHEN IFNULL(Cli.TamanioAcreditado,Entero_Cero) != Entero_Cero THEN Cli.TamanioAcreditado
		 ELSE Entero_Cero
	END AS TamAcredit,-- se deja en cero si es de COnsumo o Vivienda

	-- ==== DATOS CREDITO ===============================================================================

	-- Identificador del Credito
	Cre.IdenCreditoCNBV,
	-- Identificadro Grupal
	Entero_Cero , -- No aplica
	-- Fecha Otorgamiento
	DATE_FORMAT(Cre.FechaInicio,'%Y%m%d'),
	-- Tipo de Alta
	CASE WHEN Cre.TipoCredito = Cred_Nuevo 			THEN Cla_CreNuevo -- Nuevo
		 WHEN Cre.TipoCredito = Cred_Restructura 	THEN Cla_CreRestru -- restructurado
		 WHEN Cre.TipoCredito = Cred_Renovado 		THEN Cla_CreRenova -- Renovado
	END,
	-- Tipo Cartera
	CASE WHEN Cre.ClasiDestinCred = Cred_Comercial	THEN Clave_Comercial
		 WHEN Cre.ClasiDestinCred = Cred_Consumo 	THEN Clave_Consumo
		 WHEN Cre.ClasiDestinCred = Cred_Vivienda 	THEN Clave_Vivienda
	END, -- para relacionar con destino
	-- Tipo Producto
	Pro.ClaveCNBV,
	-- Destino Credito
	Cre.DestinoCreID, -- Vincular condestinos
	-- Clave Sucursal
	Cli.SucursalOrigen,
	-- Numero Cuenta
	CONVERT(Cre.CreditoID, CHAR),
	-- Numero Contrato
	CONVERT(Cre.CreditoID, CHAR),
	-- Nombre del Factorado
	No_Aplica,
	-- RFC factorado
	Clave_SIP,


	-- ==== CONDICIONES FINANCIERAS ===============================================================================


	-- Monto linea o credito
	Cre.MontoCredito,
	-- Monto moneda Origen
	Cre.MontoCredito,
	-- Fecha Maxima DisponRecurso
	DATE_FORMAT(Cre.FechaInicio,'%Y%m%d'),
	-- Fecha de Vencimiento
	DATE_FORMAT(Cre.FechaVencimien,'%Y%m%d'),
	-- Forma Disposicion
	CASE WHEN Pro.ManejaLinea != SI_ManejaLinea THEN Dis_NoRevUnaDisp
		 WHEN Pro.ManejaLinea = SI_ManejaLinea AND Pro.EsRevolvente = Valor_NO THEN Dis_NoRevMultDisp
		 WHEN Pro.ManejaLinea = SI_ManejaLinea AND Pro.EsRevolvente = Valor_SI THEN Dis_Revolvente
		 ELSE Dis_NoRevUnaDisp
	END,

	-- Clave Referencia
	CASE WHEN Cre.CalcInteresID = Calc_TasaFija THEN Sin_ClaveRefere -- Tasa Fija,
		 ELSE Entero_Cero END, -- TOmar el ID de la Tasa de Referencia (TASASBASE)
	-- Diferencial
	CASE WHEN Cre.CalcInteresID = Calc_TasaFija THEN Entero_Cero -- Tasa Fija,
		 ELSE Entero_Cero END,-- restarle el valor de la tasa actual
	-- Operacion
	CASE WHEN Cre.CalcInteresID = Calc_TasaFija THEN Clave_SinAjuste -- Sin AJuste,
		 ELSE Clave_SinAjuste END,
	-- Tipo Moneda
	CASE WHEN Cre.MonedaID = Moneda_Pesos THEN Clave_PesosCC -- pesos
			 ELSE Clave_DolarCC END, -- dolar
	-- Periodicidad Capital
	CASE	WHEN Cre.FrecuenciaCap = 'U' THEN 1 -- Unico
			WHEN Cre.FrecuenciaCap = 'S' THEN 2 -- semanales
			WHEN Cre.FrecuenciaCap = 'Q' THEN 4 -- quincenales
			WHEN Cre.FrecuenciaCap = 'M' THEN 5 -- mensuales
			WHEN Cre.FrecuenciaCap = 'B' THEN 6 -- bimenstrales
			WHEN Cre.FrecuenciaCap = 'T' THEN 7 -- trimestrales
			WHEN Cre.FrecuenciaCap = 'E' THEN 8 -- semestrales
			WHEN Cre.FrecuenciaCap = 'A' THEN 9 -- anuales
			ELSE Periodo_CapOtra END, -- OTRA
	-- Periodicidad Interes
	CASE
			WHEN Cre.FrecuenciaInt = 'U' THEN 1 -- Unico
			WHEN Cre.FrecuenciaInt = 'S' THEN 2 -- semanales
			WHEN Cre.FrecuenciaInt = 'Q' THEN 4 -- quincenales
			WHEN Cre.FrecuenciaInt = 'M' THEN 5 -- mensuales
			WHEN Cre.FrecuenciaInt = 'B' THEN 6 -- bimenstrales
			WHEN Cre.FrecuenciaInt = 'T' THEN 7 -- trimestrales
			WHEN Cre.FrecuenciaInt = 'E' THEN 8 -- semestrales
			WHEN Cre.FrecuenciaInt = 'A' THEN 9 -- anuales
			WHEN Cre.TipoPagoCapital = 'L' THEN 11 -- irregulares
			ELSE Periodo_IntOtra END, -- OTRA

	-- Periodo Facturacion
	Con_PeriodoFactura AS PeriodoFac, -- Mensual
	-- Tipo de Comision por Apertura(Base o Monto)
	CASE WHEN Cre.TipoComXApertura = Com_Porcentaje THEN TRUNCATE(Cre.MontoComApert / Cre.MontoCredito * 100, 2)
	 ELSE Entero_Cero
	END,
	-- Comision Apertura, El cobro es un Monto
	CASE WHEN Cre.TipoComXApertura = Com_Monto THEN Cre.MontoComApert
	 ELSE Entero_Cero
	END,
	-- comision por disposicion, expresado en Porcentaje
	Entero_Cero ,
	-- comision por disposicion, expresado en Monto
	Entero_Cero,

	-- ==== SECCION V .- DATOS DE LA VIVIENDA ===============================================================================

	-- valor vivienda
	Entero_Cero,
	-- valor avaluo
	Entero_Cero,
	-- numero avaluo
	Entero_Cero,
	-- ltv
	Entero_Cero,

	-- ==== DESTINO CREDITO ===============================================================================

	-- Localidad Cred
	IFNULL(Dir.LocalidadID,Entero_Cero) AS Localidad,
	-- Municipio
	IFNULL(Dir.MunicipioID,Entero_Cero),
    -- Estado
	IFNULL(Dir.EstadoID,Entero_Cero),
	-- Actividad Eco Cred
	Entero_Cero,
	Fecha_Vacia,			-- Fecha de Consulta a SIC's se actualiza mas delante
	Cre.CreditoID,
	Cre.LineaCreditoID,
	Cre.TasaBase,
	Cre.CalcInteresID,
	Cre.TasaFija, Cre.SobreTasa, Cre.FechaInicio, Cli.SucursalOrigen

	FROM CREDITOS Cre
	INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
	INNER JOIN SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID
	INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
	LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
									 AND IFNULL(Dir.Oficial, Valor_NO) = Valor_SI
	WHERE Cre.FechaInicio BETWEEN Var_FechaIniMesSis AND  Par_Fecha
	  AND Cre.Estatus IN (Cred_Vigente, Cred_Vencido, Cred_Pagado, Cred_Castigado);


	-- ================ CREDITOS DIFERIDOS QUE NO ESTAN EN LA PRIMER CONSULTA  ==========================

	INSERT INTO TMPREG0451REG
	-- ==== DATOS CLIENTE ===============================================================================
	-- Numero de Cliente
	SELECT Cli.ClienteID,
	-- TIpo de Cliente
	Cli_AcreyAhorro AS TipoCliente, -- Acreditado y Ahorrador,
	Cli.TipoPersona,
	-- Nombre o Razon
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							UPPER(
								SUBSTRING(CONCAT(IFNULL(Cli.PrimerNombre, Cadena_Vacia),
									CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(' ', Cli.SegundoNombre) ELSE Cadena_Vacia
									END,
									CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(' ', Cli.TercerNombre) ELSE Cadena_Vacia
									END), 1, 200)
							)
						 ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(Cli.RazonSocial, 'S.A. DE C.V.', ''),
															'SA DE CV', ''),
														'SA. DE C.V', ''),
													'S. A. de CV.', ''),
											'sa de cv', ''),
									's.a. de c.v.', ''))

	END,
	-- Apellido Paterno
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
			CASE WHEN IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = Cadena_Vacia
					OR IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = '.' THEN
				Apellido_Vacio
			ELSE
				UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
			END
		ELSE Entero_Cero
	END ,
	-- Apellido Materno
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
			CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
				OR  IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
					Apellido_Vacio
			ELSE
			 UPPER(IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
			END
		 ELSE Entero_Cero
	END,
	-- Personalidad Juridica
	CASE    WHEN Cli.Nacion =   Es_Nacional AND Cli.TipoPersona =   Per_Moral THEN Clave_MoralNac   -- Moral Nacional
			WHEN Cli.Nacion =   Es_Nacional AND Cli.TipoPersona <>  Per_Moral THEN Clave_FisicaNac  -- Fisica Nacional
			WHEN Cli.Nacion <>  Es_Nacional AND Cli.TipoPersona =   Per_Moral THEN Clave_MoralExt   -- Moral Extranjera
			WHEN Cli.Nacion <>  Es_Nacional AND Cli.TipoPersona <>  Per_Moral THEN Clave_FisicaExt  -- Fisica Extranjera
		END,
	-- Grupo de RIesgo. Se actualiza mas Adelante
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							UPPER(Cli.NombreCompleto)
		ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(Cli.NombreCompleto, 'S.A. DE C.V.', ''),
															'SA DE CV', ''),
														'SA. DE C.V', ''),
													'S. A. de CV.', ''),
											'sa de cv', ''),
									's.a. de c.v.', ''))
	END AS GrupoRiesgo,
	-- Actividad economica
	Cli.ActividadBancoMX,
	Cadena_Vacia,
	-- Nacionalidad. Se actualiza mas adelante con la CLAVE PAIS NACIONALIDAD CNBV
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
				Cli.PaisNacionalidad
			 ELSE Cli.PaisConstitucionID
		END,
	-- Fecha Nacimiento
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							REPLACE(CONVERT(Cli.FechaNacimiento, CHAR),'-',Cadena_Vacia)
						 ELSE DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%Y%m%d')
					END,
	-- RFC
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							 Cli.RFCOficial
						 ELSE CONCAT("_", SUBSTR(Cli.RFCOficial,1,12))
					END,
	-- CURP
	CASE WHEN Cli.Nacion = Es_Nacional AND ( Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre )THEN
							 Cli.CURP
						 ELSE Cadena_Cero
					END,
	-- Genero
	CASE WHEN Cli.TipoPersona = Per_Moral THEN Cadena_Cero
						 WHEN Cli.TipoPersona IN (Fisica_empre, Per_Fisica) AND Cli.Sexo = Gen_Masculino THEN '2'
						 WHEN Cli.TipoPersona IN (Fisica_empre,Per_Fisica)  AND Cli.Sexo = Gen_Femenino THEN '1'
					END,
	-- Calle
	IFNULL(Dir.Calle,Cadena_Vacia),
	-- Numero
	CONCAT(IFNULL(NumeroCasa,Cadena_Vacia),IFNULL(NumInterior,Cadena_Vacia)),
	-- Colonia
	IFNULL(Dir.ColoniaID,Entero_Cero),
	IFNULL(Dir.Colonia,Cadena_Vacia) AS NombreColonia,
	-- Codigo postal
	IFNULL(Dir.CP,Cadena_Vacia),
	-- Localidad
	IFNULL(Dir.LocalidadID,Entero_Cero) AS Localidad,
	-- Estado
	IFNULL(Dir.EstadoID,Entero_Cero),
	-- Municipio
	IFNULL(Dir.MunicipioID,Entero_Cero),
	-- Pais
	Cla_PaisMexico AS Pais,         -- Mexico
	-- Tipo Acreditado
	Cla_SinRelacion,                -- Se actualiza posteriormente
	-- Clave SIC(NumConsultaSIC)
	CASE WHEN IFNULL(Cre.TipoConsultaSIC,Cadena_Vacia) = 'BC' THEN IFNULL(Cre.FolioConsultaBC,Entero_Cero)
		 WHEN IFNULL(Cre.TipoConsultaSIC,Cadena_Vacia) = 'CC' THEN IFNULL(Cre.FolioConsultaCC,Entero_Cero)
		 ELSE Entero_Cero END AS ClaveSIC,      -- Se actualiza mas Delante
	-- Ingresos Mensuales
	Entero_Cero AS IngMensuales,    -- Actualizar con Consulta a CLIDATSOCIOE
	-- Tamano Acreditado
	CASE WHEN Cre.ClasiDestinCred = Cred_Comercial AND
			Cli.TipoPersona BETWEEN Fisica_empre AND Per_Moral THEN Micro_Empresa
		WHEN IFNULL(Cli.TamanioAcreditado,Entero_Cero) != Entero_Cero THEN Cli.TamanioAcreditado
		 ELSE Entero_Cero
	END AS TamAcredit,-- se deja en cero si es de COnsumo o Vivienda

	-- ==== DATOS CREDITO ===============================================================================

	-- Identificador del Credito
	Cre.IdenCreditoCNBV,
	-- Identificadro Grupal
	Entero_Cero , -- No aplica
	-- Fecha Otorgamiento
	DATE_FORMAT(Dif.FechaAplicacion,'%Y%m%d'),
	-- Tipo de Alta
	Cla_CredCovid, -- Nuevo
	-- Tipo Cartera
	CASE WHEN Cre.ClasiDestinCred = Cred_Comercial  THEN Clave_Comercial
		 WHEN Cre.ClasiDestinCred = Cred_Consumo    THEN Clave_Consumo
		 WHEN Cre.ClasiDestinCred = Cred_Vivienda   THEN Clave_Vivienda
	END, -- para relacionar con destino
	-- Tipo Producto
	Pro.ClaveCNBV,
	-- Destino Credito
	Cre.DestinoCreID, -- Vincular condestinos
	-- Clave Sucursal
	Cli.SucursalOrigen,
	-- Numero Cuenta
	CONVERT(Cre.CreditoID, CHAR),
	-- Numero Contrato
	CONVERT(Cre.CreditoID, CHAR),
	-- Nombre del Factorado
	No_Aplica,
	-- RFC factorado
	Clave_SIP,


	-- ==== CONDICIONES FINANCIERAS ===============================================================================


	-- Monto linea o credito
	Cre.MontoCredito,
	-- Monto moneda Origen
	Cre.MontoCredito,
	-- Fecha Maxima DisponRecurso
	DATE_FORMAT(Dif.FechaAplicacion,'%Y%m%d'),
	-- Fecha de Vencimiento
	DATE_FORMAT(Cre.FechaVencimien,'%Y%m%d'),
	-- Forma Disposicion
	CASE WHEN Pro.ManejaLinea != SI_ManejaLinea THEN Dis_NoRevUnaDisp
		 WHEN Pro.ManejaLinea = SI_ManejaLinea AND Pro.EsRevolvente = Valor_NO THEN Dis_NoRevMultDisp
		 WHEN Pro.ManejaLinea = SI_ManejaLinea AND Pro.EsRevolvente = Valor_SI THEN Dis_Revolvente
		 ELSE Dis_NoRevUnaDisp
	END,

	-- Clave Referencia
	CASE WHEN Cre.CalcInteresID = Calc_TasaFija THEN Sin_ClaveRefere -- Tasa Fija,
		 ELSE Entero_Cero END, -- TOmar el ID de la Tasa de Referencia (TASASBASE)
	-- Diferencial
	CASE WHEN Cre.CalcInteresID = Calc_TasaFija THEN Entero_Cero -- Tasa Fija,
		 ELSE Entero_Cero END,-- restarle el valor de la tasa actual
	-- Operacion
	CASE WHEN Cre.CalcInteresID = Calc_TasaFija THEN Clave_SinAjuste -- Sin AJuste,
		 ELSE Clave_SinAjuste END,
	-- Tipo Moneda
	CASE WHEN Cre.MonedaID = Moneda_Pesos THEN Clave_PesosCC -- pesos
			 ELSE Clave_DolarCC END, -- dolar
	-- Periodicidad Capital
	CASE    WHEN Cre.FrecuenciaCap = 'U' THEN 1 -- Unico
			WHEN Cre.FrecuenciaCap = 'S' THEN 2 -- semanales
			WHEN Cre.FrecuenciaCap = 'Q' THEN 4 -- quincenales
			WHEN Cre.FrecuenciaCap = 'M' THEN 5 -- mensuales
			WHEN Cre.FrecuenciaCap = 'B' THEN 6 -- bimenstrales
			WHEN Cre.FrecuenciaCap = 'T' THEN 7 -- trimestrales
			WHEN Cre.FrecuenciaCap = 'E' THEN 8 -- semestrales
			WHEN Cre.FrecuenciaCap = 'A' THEN 9 -- anuales
			ELSE Periodo_CapOtra END, -- OTRA
	-- Periodicidad Interes
	CASE
			WHEN Cre.FrecuenciaInt = 'U' THEN 1 -- Unico
			WHEN Cre.FrecuenciaInt = 'S' THEN 2 -- semanales
			WHEN Cre.FrecuenciaInt = 'Q' THEN 4 -- quincenales
			WHEN Cre.FrecuenciaInt = 'M' THEN 5 -- mensuales
			WHEN Cre.FrecuenciaInt = 'B' THEN 6 -- bimenstrales
			WHEN Cre.FrecuenciaInt = 'T' THEN 7 -- trimestrales
			WHEN Cre.FrecuenciaInt = 'E' THEN 8 -- semestrales
			WHEN Cre.FrecuenciaInt = 'A' THEN 9 -- anuales
			WHEN Cre.TipoPagoCapital = 'L' THEN 11 -- irregulares
			ELSE Periodo_IntOtra END, -- OTRA

	-- Periodo Facturacion
	Con_PeriodoFactura AS PeriodoFac, -- Mensual
	-- Tipo de Comision por Apertura(Base o Monto)
	CASE WHEN Cre.TipoComXApertura = Com_Porcentaje THEN TRUNCATE(Cre.MontoComApert / Cre.MontoCredito * 100, 2)
	 ELSE Entero_Cero
	END,
	-- Comision Apertura, El cobro es un Monto
	CASE WHEN Cre.TipoComXApertura = Com_Monto THEN Cre.MontoComApert
	 ELSE Entero_Cero
	END,
	-- comision por disposicion, expresado en Porcentaje
	Entero_Cero ,
	-- comision por disposicion, expresado en Monto
	Entero_Cero,

	-- ==== SECCION V .- DATOS DE LA VIVIENDA ===============================================================================

	-- valor vivienda
	Entero_Cero,
	-- valor avaluo
	Entero_Cero,
	-- numero avaluo
	Entero_Cero,
	-- ltv
	Entero_Cero,

	-- ==== DESTINO CREDITO ===============================================================================

	-- Localidad Cred
	IFNULL(Dir.LocalidadID,Entero_Cero) AS Localidad,
	-- Municipio
	IFNULL(Dir.MunicipioID,Entero_Cero),
	-- Estado
	IFNULL(Dir.EstadoID,Entero_Cero),
	-- Actividad Eco Cred
	Entero_Cero,
	Fecha_Vacia,            -- Fecha de Consulta a SIC's se actualiza mas delante
	Cre.CreditoID,
	Cre.LineaCreditoID,
	Cre.TasaBase,
	Cre.CalcInteresID,
	Cre.TasaFija, Cre.SobreTasa, Cre.FechaInicio, Cli.SucursalOrigen

	FROM CREDITOS Cre
	INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
	INNER JOIN SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID
	INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
	LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
									 AND IFNULL(Dir.Oficial, Valor_NO) = Valor_SI
	RIGHT JOIN CREDITOSDIFERIDOS Dif ON Cre.CreditoID = Dif.CreditoID
	WHERE Dif.FechaAplicacion BETWEEN Var_FechaIniMesSis AND Par_Fecha
	  AND Dif.NumeroDiferimientos = Entero_Uno
	  AND Cre.Estatus IN (Cred_Vigente, Cred_Vencido, Cred_Pagado, Cred_Castigado);



	INSERT INTO TMPREG0451REG
	-- ==== DATOS CLIENTE ===============================================================================
	-- Numero de Cliente
	SELECT Cli.ClienteID,
	-- TIpo de Cliente
	Cli_AcreyAhorro AS TipoCliente, -- Acreditado y Ahorrador,
	Cli.TipoPersona,
	-- Nombre o Razon
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							UPPER(
								SUBSTRING(CONCAT(IFNULL(Cli.PrimerNombre, Cadena_Vacia),
									CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(' ', Cli.SegundoNombre) ELSE Cadena_Vacia
									END,
									CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
										CONCAT(' ', Cli.TercerNombre) ELSE Cadena_Vacia
									END), 1, 200)
							)
						ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(Cli.RazonSocial, 'S.A. DE C.V.', ''),
															'SA DE CV', ''),
														'SA. DE C.V', ''),
													'S. A. de CV.', ''),
											'sa de cv', ''),
									's.a. de c.v.', ''))

	END,
	-- Apellido Paterno
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
			CASE WHEN IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = Cadena_Vacia
					OR IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = '.' THEN
				Apellido_Vacio
			ELSE
				UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
			END
		ELSE Entero_Cero
	END ,
	-- Apellido Materno
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
			CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
				OR  IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
					Apellido_Vacio
			ELSE
			 UPPER(IFNULL(Cli.ApellidoMaterno,Cadena_Vacia))
			END
		 ELSE Entero_Cero
	END,
	-- Personalidad Juridica
	CASE    WHEN Cli.Nacion =   Es_Nacional AND Cli.TipoPersona =   Per_Moral THEN Clave_MoralNac   -- Moral Nacional
			WHEN Cli.Nacion =   Es_Nacional AND Cli.TipoPersona <>  Per_Moral THEN Clave_FisicaNac  -- Fisica Nacional
			WHEN Cli.Nacion <>  Es_Nacional AND Cli.TipoPersona =   Per_Moral THEN Clave_MoralExt   -- Moral Extranjera
			WHEN Cli.Nacion <>  Es_Nacional AND Cli.TipoPersona <>  Per_Moral THEN Clave_FisicaExt  -- Fisica Extranjera
		END,
	-- Grupo de RIesgo. Se actualiza mas Adelante
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							UPPER(Cli.NombreCompleto)
		ELSE UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(Cli.NombreCompleto, 'S.A. DE C.V.', ''),
															'SA DE CV', ''),
														'SA. DE C.V', ''),
													'S. A. de CV.', ''),
											'sa de cv', ''),
									's.a. de c.v.', ''))
	END AS GrupoRiesgo,
	-- Actividad economica
	Cli.ActividadBancoMX,
	Cadena_Vacia,
	-- Nacionalidad. Se actualiza mas adelante con la CLAVE PAIS NACIONALIDAD CNBV
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
				Cli.PaisNacionalidad
			 ELSE Cli.PaisConstitucionID
		END,
	-- Fecha Nacimiento
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							REPLACE(CONVERT(Cli.FechaNacimiento, CHAR),'-',Cadena_Vacia)
						 ELSE DATE_FORMAT(IFNULL(Cli.FechaConstitucion,Fecha_Vacia) ,'%Y%m%d')
					END,
	-- RFC
	CASE WHEN Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre THEN
							 Cli.RFCOficial
						 ELSE CONCAT("_", SUBSTR(Cli.RFCOficial,1,12))
					END,
	-- CURP
	CASE WHEN Cli.Nacion = Es_Nacional AND ( Cli.TipoPersona = Per_Fisica OR Cli.TipoPersona = Fisica_empre )THEN
							 Cli.CURP
						 ELSE Cadena_Cero
					END,
	-- Genero
	CASE WHEN Cli.TipoPersona = Per_Moral THEN Cadena_Cero
						 WHEN Cli.TipoPersona IN (Fisica_empre, Per_Fisica) AND Cli.Sexo = Gen_Masculino THEN '2'
						 WHEN Cli.TipoPersona IN (Fisica_empre,Per_Fisica)  AND Cli.Sexo = Gen_Femenino THEN '1'
					END,
	-- Calle
	IFNULL(Dir.Calle,Cadena_Vacia),
	-- Numero
	CONCAT(IFNULL(NumeroCasa,Cadena_Vacia),IFNULL(NumInterior,Cadena_Vacia)),
	-- Colonia
	IFNULL(Dir.ColoniaID,Entero_Cero),
	IFNULL(Dir.Colonia,Cadena_Vacia) AS NombreColonia,
	-- Codigo postal
	IFNULL(Dir.CP,Cadena_Vacia),
	-- Localidad
	IFNULL(Dir.LocalidadID,Entero_Cero) AS Localidad,
	-- Estado
	IFNULL(Dir.EstadoID,Entero_Cero),
	-- Municipio
	IFNULL(Dir.MunicipioID,Entero_Cero),
	-- Pais
	Cla_PaisMexico AS Pais,         -- Mexico
	-- Tipo Acreditado
	Cla_SinRelacion,                -- Se actualiza posteriormente
	-- Clave SIC(NumConsultaSIC)
	CASE WHEN IFNULL(Cre.TipoConsultaSIC,Cadena_Vacia) = 'BC' THEN IFNULL(Cre.FolioConsultaBC,Entero_Cero)
		 WHEN IFNULL(Cre.TipoConsultaSIC,Cadena_Vacia) = 'CC' THEN IFNULL(Cre.FolioConsultaCC,Entero_Cero)
		 ELSE Entero_Cero END AS ClaveSIC,      -- Se actualiza mas Delante
	-- Ingresos Mensuales
	Entero_Cero AS IngMensuales,    -- Actualizar con Consulta a CLIDATSOCIOE
	-- Tamano Acreditado
	CASE WHEN Cre.ClasiDestinCred = Cred_Comercial AND
			Cli.TipoPersona BETWEEN Fisica_empre AND Per_Moral THEN Micro_Empresa
		WHEN IFNULL(Cli.TamanioAcreditado,Entero_Cero) != Entero_Cero THEN Cli.TamanioAcreditado
		 ELSE Entero_Cero
	END AS TamAcredit,-- se deja en cero si es de COnsumo o Vivienda

	-- ==== DATOS CREDITO ===============================================================================

	-- Identificador del Credito
	Cre.IdenCreditoCNBV,
	-- Identificadro Grupal
	Entero_Cero , -- No aplica
	-- Fecha Otorgamiento
	DATE_FORMAT(Dif.FechaAplicacion,'%Y%m%d'),
	-- Tipo de Alta
	Cla_CredCovid, -- Nuevo
	-- Tipo Cartera
	CASE WHEN Cre.ClasiDestinCred = Cred_Comercial  THEN Clave_Comercial
		 WHEN Cre.ClasiDestinCred = Cred_Consumo    THEN Clave_Consumo
		 WHEN Cre.ClasiDestinCred = Cred_Vivienda   THEN Clave_Vivienda
	END, -- para relacionar con destino
	-- Tipo Producto
	Pro.ClaveCNBV,
	-- Destino Credito
	Cre.DestinoCreID, -- Vincular condestinos
	-- Clave Sucursal
	Cli.SucursalOrigen,
	-- Numero Cuenta
	CONVERT(Cre.CreditoID, CHAR),
	-- Numero Contrato
	CONVERT(Cre.CreditoID, CHAR),
	-- Nombre del Factorado
	No_Aplica,
	-- RFC factorado
	Clave_SIP,


	-- ==== CONDICIONES FINANCIERAS ===============================================================================


	-- Monto linea o credito
	Cre.MontoCredito,
	-- Monto moneda Origen
	Cre.MontoCredito,
	-- Fecha Maxima DisponRecurso
	DATE_FORMAT(Dif.FechaAplicacion,'%Y%m%d'),
	-- Fecha de Vencimiento
	DATE_FORMAT(Cre.FechaVencimien,'%Y%m%d'),
	-- Forma Disposicion
	CASE WHEN Pro.ManejaLinea != SI_ManejaLinea THEN Dis_NoRevUnaDisp
		 WHEN Pro.ManejaLinea = SI_ManejaLinea AND Pro.EsRevolvente = Valor_NO THEN Dis_NoRevMultDisp
		 WHEN Pro.ManejaLinea = SI_ManejaLinea AND Pro.EsRevolvente = Valor_SI THEN Dis_Revolvente
		 ELSE Dis_NoRevUnaDisp
	END,

	-- Clave Referencia
	CASE WHEN Cre.CalcInteresID = Calc_TasaFija THEN Sin_ClaveRefere -- Tasa Fija,
		 ELSE Entero_Cero END, -- TOmar el ID de la Tasa de Referencia (TASASBASE)
	-- Diferencial
	CASE WHEN Cre.CalcInteresID = Calc_TasaFija THEN Entero_Cero -- Tasa Fija,
		 ELSE Entero_Cero END,-- restarle el valor de la tasa actual
	-- Operacion
	CASE WHEN Cre.CalcInteresID = Calc_TasaFija THEN Clave_SinAjuste -- Sin AJuste,
		 ELSE Clave_SinAjuste END,
	-- Tipo Moneda
	CASE WHEN Cre.MonedaID = Moneda_Pesos THEN Clave_PesosCC -- pesos
			 ELSE Clave_DolarCC END, -- dolar
	-- Periodicidad Capital
	CASE    WHEN Cre.FrecuenciaCap = 'U' THEN 1 -- Unico
			WHEN Cre.FrecuenciaCap = 'S' THEN 2 -- semanales
			WHEN Cre.FrecuenciaCap = 'Q' THEN 4 -- quincenales
			WHEN Cre.FrecuenciaCap = 'M' THEN 5 -- mensuales
			WHEN Cre.FrecuenciaCap = 'B' THEN 6 -- bimenstrales
			WHEN Cre.FrecuenciaCap = 'T' THEN 7 -- trimestrales
			WHEN Cre.FrecuenciaCap = 'E' THEN 8 -- semestrales
			WHEN Cre.FrecuenciaCap = 'A' THEN 9 -- anuales
			ELSE Periodo_CapOtra END, -- OTRA
	-- Periodicidad Interes
	CASE
			WHEN Cre.FrecuenciaInt = 'U' THEN 1 -- Unico
			WHEN Cre.FrecuenciaInt = 'S' THEN 2 -- semanales
			WHEN Cre.FrecuenciaInt = 'Q' THEN 4 -- quincenales
			WHEN Cre.FrecuenciaInt = 'M' THEN 5 -- mensuales
			WHEN Cre.FrecuenciaInt = 'B' THEN 6 -- bimenstrales
			WHEN Cre.FrecuenciaInt = 'T' THEN 7 -- trimestrales
			WHEN Cre.FrecuenciaInt = 'E' THEN 8 -- semestrales
			WHEN Cre.FrecuenciaInt = 'A' THEN 9 -- anuales
			WHEN Cre.TipoPagoCapital = 'L' THEN 11 -- irregulares
			ELSE Periodo_IntOtra END, -- OTRA

	-- Periodo Facturacion
	Con_PeriodoFactura AS PeriodoFac, -- Mensual
	-- Tipo de Comision por Apertura(Base o Monto)
	CASE WHEN Cre.TipoComXApertura = Com_Porcentaje THEN TRUNCATE(Cre.MontoComApert / Cre.MontoCredito * 100, 2)
	 ELSE Entero_Cero
	END,
	-- Comision Apertura, El cobro es un Monto
	CASE WHEN Cre.TipoComXApertura = Com_Monto THEN Cre.MontoComApert
	 ELSE Entero_Cero
	END,
	-- comision por disposicion, expresado en Porcentaje
	Entero_Cero ,
	-- comision por disposicion, expresado en Monto
	Entero_Cero,

	-- ==== SECCION V .- DATOS DE LA VIVIENDA ===============================================================================

	-- valor vivienda
	Entero_Cero,
	-- valor avaluo
	Entero_Cero,
	-- numero avaluo
	Entero_Cero,
	-- ltv
	Entero_Cero,

	-- ==== DESTINO CREDITO ===============================================================================

	-- Localidad Cred
	IFNULL(Dir.LocalidadID,Entero_Cero) AS Localidad,
	-- Municipio
	IFNULL(Dir.MunicipioID,Entero_Cero),
	-- Estado
	IFNULL(Dir.EstadoID,Entero_Cero),
	-- Actividad Eco Cred
	Entero_Cero,
	Fecha_Vacia,            -- Fecha de Consulta a SIC's se actualiza mas delante
	Cre.CreditoID,
	Cre.LineaCreditoID,
	Cre.TasaBase,
	Cre.CalcInteresID,
	Cre.TasaFija, Cre.SobreTasa, Cre.FechaInicio, Cli.SucursalOrigen

	FROM CREDITOS Cre
	INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
	INNER JOIN SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID
	INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
	LEFT OUTER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID
									 AND IFNULL(Dir.Oficial, Valor_NO) = Valor_SI
	RIGHT JOIN CREDITOSDIFERIDOS Dif ON Cre.CreditoID = Dif.CreditoOrigenID
	WHERE Dif.FechaAplicacion BETWEEN Var_FechaIniMesSis AND  Par_Fecha
	  AND Dif.NumeroDiferimientos = Entero_Uno
	  AND Cre.Estatus IN (Cred_Vigente, Cred_Vencido, Cred_Pagado, Cred_Castigado)
	  AND Dif.TipoDiferimiento = 'R';

	DELETE Tem.* FROM TMPREG0451REG Tem
	INNER JOIN CREDITOSDIFERIDOS Dif ON Tem.CreditoID = Dif.CreditoID
	AND Tem.TipoAlta = Cla_CreNuevo;


	-- ==================== Actualizar Datos de Linea de Credito =========== --

	UPDATE TMPREG0451REG Tem, LINEASCREDITO Lin SET
		Tem.MontoLineaPes	=	Lin.Autorizado,
		Tem.MontoLineaOri	=	Lin.Autorizado,
		Tem.FechaMaxima		=	DATE_FORMAT(Lin.FechaVencimiento,'%Y%m%d'),
		Tem.FechaVencimien	=	DATE_FORMAT(Lin.FechaVencimiento,'%Y%m%d'),
		Tem.NumContrato		= 	Lin.FolioContrato

	WHERE Tem.LineaCreditoID = Lin.LineaCreditoID
	 AND IFNULL(Tem.LineaCreditoID, Entero_Cero) <> Entero_Cero;

-- ==================== Actualizar Datos de la Consulta a la SIC's ========================
	DROP TABLE IF EXISTS TMPCONSULTASIC;
	CREATE TEMPORARY TABLE TMPCONSULTASIC(
		CreditoID		BIGINT,
		FolioConsulta	VARCHAR(18),
		FechaConsulta	DATE
	);

	CREATE INDEX IDX_TMPCONSULTASIC_1 ON TMPCONSULTASIC(CreditoID);

	-- Considerar si consulta en Buro o en Circulo de Credito
	SELECT ConBuroCreDefaut INTO Var_TipoSIC
		FROM PARAMETROSSIS;

	SET Var_TipoSIC := IFNULL(Var_TipoSIC, SIC_BuroCredito);

	IF(Var_TipoSIC = SIC_BuroCredito) THEN

		INSERT INTO TMPCONSULTASIC
			SELECT Tem.CreditoID, MAX(Fol.FOL_BUR), MAX(Sob.FechaConsulta)
				FROM TMPREG0451REG Tem,
					 SOLBUROCREDITO Sob,
					 bur_fol Fol
				WHERE Tem.RFC = Sob.RFC
				 AND Sob.FolioConsulta = Fol.BUR_SOLNUM
				 AND DATE(Sob.FechaConsulta) <= Tem.FechaInicio
				GROUP BY Tem.CreditoID;

	ELSE

		INSERT INTO TMPCONSULTASIC
			SELECT Tem.CreditoID, MAX(CiS.FolioConsulta), MAX(Sob.FechaConsulta)
				FROM TMPREG0451REG Tem,
					 SOLBUROCREDITO Sob,
					 CIRCULOCRESOL CiS
				WHERE Tem.RFC = Sob.RFC
				 AND Sob.FolioConsultaC = CiS.SolicitudID
				 AND DATE(Sob.FechaConsulta) <= Tem.FechaInicio
				GROUP BY Tem.CreditoID;

	END IF;

	UPDATE TMPREG0451REG Tem, TMPCONSULTASIC Sic SET
		Tem.NumConsultaSIC	= FolioConsulta,
		Tem.FechaConsulSIC	= FechaConsulta

		WHERE Tem.CreditoID = Sic.CreditoID;

	DROP TABLE IF EXISTS TMPCONSULTASIC;

	-- ------------------------------------------------------------------------
	-- GARANTIAS HIPOTECARIAS, SOLO PARA CREDITOS DE VIVIENDA -----------------
	-- ------------------------------------------------------------------------
	UPDATE TMPREG0451REG Tem, CREGARPRENHIPO Gah SET
			Tem.ValorVivienda = IFNULL(Gah.GarHipotecaria, Entero_Cero),
			Tem.ValoAvaluo	 = IFNULL(Gah.MontoAvaluo, Entero_Cero),
			Tem.NumeroAvaluo = Gah.NumeroAvaluo,
			Tem.LTV			 = TRUNCATE( Tem.MontoLineaPes / Gah.GarHipotecaria, 2)

		WHERE Tem.TipoCartera = Clave_Vivienda
		 AND Tem.CreditoID = Gah.CreditoID
		 AND IFNULL(Gah.CreditoID, Entero_Cero) != Entero_Cero
		 AND IFNULL(Gah.GarHipotecaria, Entero_Cero) > Entero_Cero;

	-- ---------------------------------------------------------------------------------------------------------------------
	-- PERSONAS RELACIONADAS -----------------------------------------------------------------------------------------------
	-- ---------------------------------------------------------------------------------------------------------------------

	-- Actualizamos al Titular que tiene la Relacion, cuando el titular con el puesto es Cliente

	UPDATE TMPREG0451REG Tem, PERSONARELACIONADA Per SET
		Tem.TipoRelacionado = CASE WHEN Per.ClaveCNBV != Rel_FuncEmpleado THEN CONVERT(Per.ClaveCNBV, CHAR)

								 	WHEN Per.ClaveCNBV = Rel_FuncEmpleado AND TipoCartera = Clave_Comercial
										THEN Clave_FuncEmpleado

									ELSE Tem.TipoRelacionado
							 END
		WHERE Tem.ClienteID = Per.ClienteID;


	-- Parientes de una Persona Relacionada, cuando la Persona Relacionada es un Cliente de la Sociedad.
	DROP TABLE IF EXISTS TMPRELPERSONAS;

	CREATE TEMPORARY TABLE TMPRELPERSONAS(
		ClienteID		BIGINT,
		ClaveCNVB		VARCHAR(2),
		TipoRelacion	CHAR(1),
		GradoRelacion	INT,

		INDEX TMPRELPERSONAS_idx1(ClienteID)
	);

	INSERT INTO TMPRELPERSONAS
		SELECT Tem.ClienteID, MAX(Per.ClaveCNBV), MAX(Tip.Tipo), MAX(Tip.Grado)

			FROM TMPREG0451REG Tem,
				 RELACIONCLIEMPLEADO Rel,
				 PERSONARELACIONADA Per,
				 TIPORELACIONES Tip

			WHERE Tem.ClienteID = Rel.ClienteID
			 AND Rel.TipoRelacion = Tipo_Cliente
			 AND Rel.RelacionadoID = Per.ClienteID
			 AND Rel.ParentescoID = Tip.TipoRelacionID
		GROUP BY Tem.ClienteID;

	UPDATE TMPREG0451REG Tem, TMPRELPERSONAS Rel SET
		 Tem.TipoRelacionado = CASE Rel.ClaveCNVB
								WHEN Rel_FuncEmpleado THEN Rel_Familiar
								WHEN Rel_AccionistasdSoc THEN Rel_Familiar
								WHEN Rel_ConsejoSoc THEN Rel_Familiar
								ELSE Tem.TipoRelacionado
							END

		WHERE Tem.ClienteID = Rel.ClienteID
		 AND Tem.TipoRelacionado = Cla_SinRelacion
		 AND ( (	Rel.TipoRelacion = Tipo_Afinidad
				AND Rel.GradoRelacion = Rel_GradoUno )
			OR (	Rel.TipoRelacion = Tipo_Consanguineo
				AND Rel.GradoRelacion BETWEEN Rel_GradoUno AND Rel_GradoDos )
			);

	-- Parientes de una Persona Relacionada, cuando la Persona Relacionada es un Empleado de la Sociedad.
	DELETE FROM TMPRELPERSONAS;

	INSERT INTO TMPRELPERSONAS
		SELECT Tem.ClienteID, MAX(Per.ClaveCNBV), MAX(Tip.Tipo), MAX(Tip.Grado)

			FROM TMPREG0451REG Tem,
				 RELACIONCLIEMPLEADO Rel,
				 PERSONARELACIONADA Per,
				 TIPORELACIONES Tip

			WHERE Tem.ClienteID = Rel.ClienteID
			 AND Rel.TipoRelacion = Tipo_Empleado
			 AND Rel.RelacionadoID = Per.EmpleadoID
			 AND Rel.ParentescoID = Tip.TipoRelacionID
			GROUP BY Tem.ClienteID;

	UPDATE TMPREG0451REG Tem, TMPRELPERSONAS Rel SET

		 Tem.TipoRelacionado = CASE Rel.ClaveCNVB
								WHEN Rel_FuncEmpleado THEN Rel_Familiar
								WHEN Rel_AccionistasdSoc THEN Rel_Familiar
								WHEN Rel_ConsejoSoc THEN Rel_Familiar
								ELSE Tem.TipoRelacionado
							END

		WHERE Tem.ClienteID = Rel.ClienteID
		 AND Tem.TipoRelacionado = Cla_SinRelacion

		 AND ( (	Rel.TipoRelacion = Tipo_Afinidad
				AND Rel.GradoRelacion = Rel_GradoUno )
			OR (	Rel.TipoRelacion = Tipo_Consanguineo
				AND Rel.GradoRelacion BETWEEN Rel_GradoUno AND Rel_GradoDos )
			);

	DROP TABLE IF EXISTS TMPRELPERSONAS;


	-- FIN DE PERSONAS RELACIONADAS ----------

	-- ------------------------------------
	-- DESTINOS DEL CREDITO ----------
	-- -------------------------------------
	UPDATE TMPREG0451REG Tem, DESTINOSCREDITO Des
		SET Tem.DestinoCred = Des.DestinoRegCar,
			Tem.ActividadEcoCred = Des.ActividadDestino
	WHERE Tem.DestinoCred = Des.DestinoCreID;


	-- ------------------------------------------------------------------------
	-- INGRESOS  DEL CLIENTE - Actualizar consulta con la ultima
    -- Captura de informacion del Cliente  --
	-- -------------------------------------------------------------------------
		DROP TABLE IF EXISTS TMP_CLIREPORTE;
        CREATE TEMPORARY TABLE TMP_CLIREPORTE(
			ClienteID BIGINT PRIMARY KEY
        );

        INSERT INTO TMP_CLIREPORTE
        SELECT DISTINCT (ClienteID) FROM TMPREG0451REG;

		DROP TABLE IF EXISTS TMP_MONTOCLIENTE;

		CREATE TEMPORARY TABLE TMP_MONTOCLIENTE
			SELECT Dat.ClienteID, SUM(Dat.Monto) AS Total
				FROM CLIDATSOCIOE Dat,
					 TMP_CLIREPORTE Reg
				WHERE Reg.ClienteID = Dat.ClienteID
				 AND Dat.CatSocioEID IN (
					SELECT CatSocioEID FROM
						CATDATSOCIOE WHERE Tipo = 'I'
                        AND Estatus = 'A'
                  )
				GROUP BY Reg.ClienteID;

		CREATE INDEX idx_oncre1 ON TMP_MONTOCLIENTE(ClienteID);

        UPDATE TMPREG0451REG Tem,TMP_MONTOCLIENTE Aho
			SET Tem.IngresosMes = Aho.Total
			WHERE Tem.ClienteID = Aho.ClienteID;

		DROP TABLE IF EXISTS TMP_MONTOCLIENTE;

	-- --------------------------------------
	-- CLAVE PAIS NACIONALIDAD CNBV ---
	-- --------------------------------------
	UPDATE TMPREG0451REG Tem, PAISES Pai SET
		Tem.Nacionalidad = Pai.PaisRegSITI
		WHERE Tem.Nacionalidad = Pai.PaisID;


    -- --------------------------------------
	-- CLAVE ACTIVIDADES SCIAN     ---
	-- --------------------------------------
    UPDATE TMPREG0451REG Tem, ACTIVIDADESBMX Bmx
		SET Tem.ActividadEco = IFNULL(Bmx.ActividadSCIANID,Cadena_Vacia),
			Tem.ActividadEcoCred =CASE WHEN Var_TipoRepActEco = Rep_ActDestinos
										THEN Tem.ActividadEcoCred
                                        ELSE IFNULL(Bmx.ActividadSCIANID,Cadena_Vacia) END
	WHERE Tem.ActividadBmx = Bmx.ActividadBMXID;

	-- --------------------------------------
	-- ESTADOS Y MUNICIPIOS -----------------
	-- --------------------------------------

	UPDATE TMPREG0451REG Tem, LOCALIDADREPUB Col SET
		Tem.Localidad = Col.LocalidadCNBV,
        Tem.LocalidadCred = Col.LocalidadCNBV
		WHERE Tem.Estado = Col.EstadoID
		 AND Tem.Municipio = Col.MunicipioID
		 AND Tem.Localidad = Col.LocalidadID;

	UPDATE TMPREG0451REG Tem, MAPEOLOCALIDADESCNBV Col SET
		Tem.Localidad = Col.LocalidadCNBV,
 		Tem.LocalidadCred = Col.LocalidadCNBV
		WHERE Tem.Localidad = Col.LocalidadSAFI;

 -- --------------------------------------------------------------------------------------------------------------------------------
 -- Tamano del Cliente |micro|pequena|mediana|grande
 -- --------------------------------------------------------------------------------------------------------------------------------

	DROP TABLE IF EXISTS TMPTOPECLIENTE;

	CREATE TEMPORARY TABLE TMPTOPECLIENTE(
		ClienteID INT(11) PRIMARY KEY,
		TopeCombinado VARCHAR(25)
	);

	CREATE INDEX IDX_TMPTOPECLIENTE_1 ON TMPTOPECLIENTE(ClienteID);

    -- Se aplica la formula de Tope Combinado  = ( Num_Empleados * 10%) + ( Ventas_Anuales * 90%)
	INSERT INTO TMPTOPECLIENTE
		SELECT Con.ClienteID,  ROUND(	(	(	(IFNULL(Con.NoEmpleados, Entero_Cero) * 0.1)	+
												(IFNULL(Con.ImporteVta ,Entero_Cero) * 0.9)
											 ) / 1000000
										 )
									 ,2) AS TopeCombinado

		FROM CONOCIMIENTOCTE Con,
			 TMPREG0451REG Tem
		WHERE Con.ClienteID  = Tem.ClienteID
		  AND Tem.TipoCartera =  Clave_Comercial
		  AND Tem.TipoPersona BETWEEN Fisica_empre AND Per_Moral
          GROUP BY Con.ClienteID;


	-- Asignar el Tamano del Cliente, de acuerdo al Puntaje Obtenido
    UPDATE TMPREG0451REG Tem, TMPTOPECLIENTE Ope, CATESTRATIFICACION Cat SET
		Tem.TamanioAcred = Cat.ClaveID
		WHERE Tem.ClienteID = Ope.ClienteID
		  AND Ope.TopeCombinado BETWEEN Cat.TopeMinimo AND Cat.TopeMaximo
		  AND Tem.TamanioAcred = Entero_Cero;


	DROP TABLE IF EXISTS TMPTOPECLIENTE;

-- =========> FIN Tamano del Cliente <==============================================================================================


-- --------------------------------------------------------------------------------------------------------------------------------
-- Tasa Base y Diferencial -- Cuando la tasa es variable
-- --------------------------------------------------------------------------------------------------------------------------------
	UPDATE TMPREG0451REG Tem, TASASBASE Tas SET
			Tem.TasaReferencia = Tas.ClaveCNBV,
			Tem.Diferencial = Tem.SobreTasa,
			Tem.OpeDiferencial = Clave_SinAjuste
	WHERE Tem.TasaBase = Tas.TasaBaseID
 AND Tem.CalcInteresID > Calc_TasaFija;			-- Que no sea la Tasa Fija


-- =========> FIN Tasa Base y Diferencial <==============================================================================================

	-- Actualizacion de la clave de sucursal
    UPDATE TMPREG0451REG Reg, SUCURSALES Suc SET
        Reg.ClaveSucursal = Suc.ClaveSucOpeCred
        WHERE Reg.SucursalOrigen = Suc.SucursalID;

    -- Actualiza el Nombre y GrupoRiesgo sin el Tipo de Empresa para Personas Morales
	UPDATE TMPREG0451REG
    SET Nombre = FNLIMPIATIPOEMPRESA(Nombre),
        GrupoRiesgo = FNLIMPIATIPOEMPRESA(Nombre)
	WHERE TipoPersona = Per_Moral;

    -- Actualizacion de la fecha de Otorgamiento para Creditos Renovados
    UPDATE TMPREG0451REG Tem, CREDITOS Cre SET
		Tem.FechaOtorga	= DATE_FORMAT(FNFECHAOTORGACRERENOVA(Tem.IdenCreditoCNBV),'%Y%m%d')
	WHERE Tem.CreditoID = Cre.CreditoID
    AND Tem.TipoAlta = Cla_CreRenova;

    DROP TABLE IF EXISTS TMPFECHAOTORGAREES;
	CREATE TEMPORARY TABLE TMPFECHAOTORGAREES(
		CreditoID		BIGINT(12),
		FechaOtorga		DATE
        );

	CREATE INDEX IDX_TMPFECHAOTORGAREES_1 ON TMPFECHAOTORGAREES(CreditoID);

	INSERT INTO TMPFECHAOTORGAREES(
		CreditoID,		FechaOtorga)
	SELECT Tem.CreditoID, MIN(Cre.FechaOperacion)
		FROM TMPREG0451REG Tem,
			 CREDITOSMOVS Cre
		WHERE Tem.CreditoID = Cre.CreditoID
		AND Tem.TipoAlta = Cla_CreRestru
		GROUP BY Tem.CreditoID;

	UPDATE TMPREG0451REG Tem, TMPFECHAOTORGAREES Tmp SET
		Tem.FechaOtorga	= DATE_FORMAT(Tmp.FechaOtorga,'%Y%m%d')
	WHERE Tem.CreditoID = Tmp.CreditoID;

	DROP TABLE IF EXISTS TMPFECHAOTORGAREES;

	IF(Par_NumReporte = Rep_Excel) THEN
		SELECT
			Var_Periodo AS Periodo,
			Var_ClaveEntidad AS ClaveEntidad,
			Cla_Reporte451 AS Reporte,
			IFNULL(ClienteID,0) AS ClienteID,
			IFNULL(TipoCliente,0) AS TipoCliente,
			FNLIMPIACARACTERESGEN(Nombre,Cast_Mayuscula) AS Nombre		,
			FNLIMPIACARACTERESGEN(ApellidoPaterno,Cast_Mayuscula) AS ApellidoPaterno ,
			FNLIMPIACARACTERESGEN(ApellidoMaterno,Cast_Mayuscula) AS ApellidoMaterno,
			IFNULL(PersoJuridica, '')	AS PersoJuridica,
			FNLIMPIACARACTERESGEN(IFNULL(GrupoRiesgo,''),Cast_Mayuscula) AS GrupoRiesgo	,
			IFNULL(ActividadEco,'')	AS ActividadEco,
			IFNULL(Nacionalidad, '0') AS Nacionalidad	,
			IFNULL(FechaNacimiento,'') AS FechaNacimiento,
			IFNULL(RFC,'')	AS RFC			,
			IFNULL(CURP,'' )	AS CURP		,
			IFNULL(Genero,'') AS Genero			,
			FNLIMPIACARACTERESGEN(IFNULL(Calle,''),Cast_Mayuscula) AS Calle		,
			FNLIMPIACARACTERESGEN(IFNULL(NumeroExt,''),Cast_Mayuscula) AS NumeroExt	,
			FNLIMPIACARACTERESGEN(IFNULL(Colonia,''),Cast_Mayuscula) AS Colonia		,
			IFNULL(CodigoPostal,'')	AS CodigoPostal,
			IFNULL(Localidad,'')	AS Localidad	,
			IFNULL(Estado,'')		AS Estado	,
			IFNULL(Municipio,'')	AS Municipio	,
			IFNULL(Pais,'')			AS Pais,
			IFNULL(TipoRelacionado,'')	AS TipoRelacionado,
			IFNULL(NumConsultaSIC,'')	AS NumConsultaSIC,
			IFNULL(IngresosMes,0)	AS IngresosMes	,
			IFNULL(TamanioAcred,0)	AS TamanioAcred,

			IFNULL(IdenCreditoCNBV,Cadena_Cero) AS IdenCreditoCNBV,
			IFNULL(IdenGrupalCNBV,0)	AS IdenGrupalCNBV,
			IFNULL(FechaOtorga,'')	AS FechaOtorga	,
			IFNULL(TipoAlta,0)		AS TipoAlta,
			IFNULL(TipoCartera,0)	AS TipoCartera	,
			IFNULL(TipoProducto,'')	AS TipoProducto,
			IFNULL(DestinoCred,'')	AS DestinoCred	,
			IFNULL(ClaveSucursal,'') AS ClaveSucursal	,
			IFNULL(NumeroCuenta,'')	AS NumeroCuenta,
			IFNULL(NumContrato,'')	AS NumContrato	,
			IFNULL(NombreFacto,'')	AS NombreFacto	,
			IFNULL(RFCFactorado,'')	AS RFCFactorado,

			IFNULL(MontoLineaPes,0)	AS MontoLineaPes,
			IFNULL(MontoLineaOri,0)	AS MontoLineaOri,
			IFNULL(FechaMaxima,'')	AS FechaMaxima	,
			IFNULL(FechaVencimien,'') AS FechaVencimien	,
			IFNULL(FormaDisposi,0)	AS FormaDisposi,
			IFNULL(TasaReferencia,0)	AS TasaReferencia,
			IFNULL(Diferencial,0)	AS Diferencial	,
			IFNULL(OpeDiferencial,0) AS OpeDiferencial	,
			IFNULL(TipoMoneda,0)	AS TipoMoneda	,
			IFNULL(PeriodicidadCap,0) AS PeriodicidadCap	,
			IFNULL(PeriodicidadInt,0) AS PeriodicidadInt	,
			IFNULL(PeriodoFactura,0) AS PeriodoFactura	,
			IFNULL(ComisionAper,'')	AS ComisionAper,
			IFNULL(MontoComAper,0)	AS MontoComAper,
			IFNULL(ComisionDispo,0)	AS ComisionDispo,
			IFNULL(MontoComDispo,0)	AS MontoComDispo,

			IFNULL(ValorVivienda,0)	AS ValorVivienda,
			IFNULL(ValoAvaluo,0)	AS ValoAvaluo	,
			IFNULL(NumeroAvaluo,Cadena_Cero) AS NumeroAvaluo,
			IFNULL(LTV,0)	AS LTV			,

			IFNULL(LocalidadCred,0)	AS LocalidadCred,
			IFNULL(MunicipioCred,0)	AS MunicipioCred,
			IFNULL(EstadoCred,0) AS EstadoCred		,
			IFNULL(ActividadEcoCred,0) AS ActividadEcoCred
			FROM TMPREG0451REG;
	ELSE
		IF(Par_NumReporte = Rep_Csv) THEN
			SELECT CONCAT(
				IFNULL(Cla_Reporte451,Cadena_Cero),';',
				IFNULL(ClienteID,''), ';',
				IFNULL(TipoCliente,'') ,';',
				FNLIMPIACARACTERESGEN(Nombre,Cast_Mayuscula),';',
				FNLIMPIACARACTERESGEN(ApellidoPaterno,Cast_Mayuscula) ,';',
				FNLIMPIACARACTERESGEN(ApellidoMaterno,Cast_Mayuscula),';',
				IFNULL(PersoJuridica, ''),';',
				FNLIMPIACARACTERESGEN(GrupoRiesgo,Cast_Mayuscula),';',
				IFNULL(ActividadEco,Cadena_Cero),';',
				IFNULL(Nacionalidad,''),';',
				IFNULL(FechaNacimiento,'') ,';',
				IFNULL(RFC,''),';',
				IFNULL(CURP,''),';',
				IFNULL(Genero,''),';',
				FNLIMPIACARACTERESGEN(Calle,Cast_Mayuscula) 	,';',
				FNLIMPIACARACTERESGEN(NumeroExt,Cast_Mayuscula) ,';',
				FNLIMPIACARACTERESGEN(Colonia,Cast_Mayuscula) 	,';',
				IFNULL(CodigoPostal,Cadena_Cero),';',
				IFNULL(Localidad,Cadena_Cero)			,';',
				IFNULL(Estado,Cadena_Cero)				,';',
				IFNULL(Municipio,Cadena_Cero)			,';',
				IFNULL(Pais,Cadena_Cero)				,';',
				IFNULL(TipoRelacionado,Cadena_Cero)		,';',
				IFNULL(NumConsultaSIC,Cadena_Cero)		,';',
				IFNULL(IngresosMes,Cadena_Cero)			,';',
				IFNULL(TamanioAcred,Cadena_Cero)		,';',

				IFNULL(IdenCreditoCNBV,Cadena_Cero)		,';',
				IFNULL(IdenGrupalCNBV,Cadena_Cero)		,';',
				IFNULL(FechaOtorga,Fecha_Nula)			,';',
				IFNULL(TipoAlta,Cadena_Cero)			,';',
				IFNULL(TipoCartera,Cadena_Cero)			,';',
				IFNULL(TipoProducto,Cadena_Cero)		,';',
				IFNULL(DestinoCred,Cadena_Cero)			,';',
				IFNULL(ClaveSucursal,Cadena_Cero)		,';',
				IFNULL(NumeroCuenta,Cadena_Cero)		,';',
				IFNULL(NumContrato,Cadena_Cero)			,';',
				IFNULL(NombreFacto,Cadena_Cero)			,';',
				IFNULL(RFCFactorado,Cadena_Cero)		,';',

				IFNULL(MontoLineaPes,Decimal_Cero)		,';',
				IFNULL(MontoLineaOri,Decimal_Cero)		,';',
				IFNULL(FechaMaxima,Fecha_Nula)			,';',
				IFNULL(FechaVencimien,Fecha_Nula)		,';',
				IFNULL(FormaDisposi,Cadena_Cero)		,';',
				IFNULL(TasaReferencia,Cadena_Cero)		,';',
				IFNULL(Diferencial,Cadena_Cero)			,';',
				IFNULL(OpeDiferencial,Cadena_Cero)		,';',
				IFNULL(TipoMoneda,Cadena_Cero)			,';',
				IFNULL(PeriodicidadCap,Cadena_Cero)		,';',
				IFNULL(PeriodicidadInt,Cadena_Cero)		,';',
				IFNULL(PeriodoFactura,Cadena_Cero)		,';',
				IFNULL(ComisionAper,Cadena_Cero)		,';',
				IFNULL(MontoComAper,Decimal_Cero)		,';',
				IFNULL(ComisionDispo,Cadena_Cero)		,';',
				IFNULL(MontoComDispo,Decimal_Cero)		,';',

				IFNULL(ValorVivienda,Decimal_Cero)		,';',
				IFNULL(ValoAvaluo,Decimal_Cero)			,';',
				IFNULL(NumeroAvaluo,Cadena_Cero)		,';',
				IFNULL(LTV,Cadena_Cero)					,';',

				IFNULL(LocalidadCred,Cadena_Cero)		,';',
				IFNULL(MunicipioCred,Cadena_Cero)							,';',
				IFNULL(EstadoCred,Cadena_Cero)								,';',
				IFNULL(ActividadEcoCred,Cadena_Cero)
				) AS Valor FROM TMPREG0451REG;
		END IF;
	END IF;

	DELETE FROM TMPREGR04C0451
		WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$