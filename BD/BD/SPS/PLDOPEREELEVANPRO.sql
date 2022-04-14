-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEREELEVANPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEREELEVANPRO`;
DELIMITER $$


CREATE PROCEDURE `PLDOPEREELEVANPRO`(
/* STORE DE PROCESOS QUE HACE LA DETECCION DE OP. FRACCIONADAS POR LIM. DE OP. RELEVANTES. */
	Par_FechaCarga        DATETIME,           -- Fecha de Deteccion
	Par_Salida            CHAR(1),            -- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr      INT(11),            -- Numero de Error
	INOUT Par_ErrMen      VARCHAR(400),       -- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID         INT(11),

	Aud_Usuario           INT(11),
	Aud_FechaActual       DATETIME,
	Aud_DireccionIP       VARCHAR(15),
	Aud_ProgramaID        VARCHAR(50),
	Aud_Sucursal          INT(11),

	Aud_NumTransaccion    BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Var_OpeReelevanteID		INT(11);      -- Id consecutivo
	DECLARE Var_SucursalOpe			INT(11);      -- Numero de la sucursal de operacion
	DECLARE Var_FechaOperacion		DATE;         -- Fecha de Operacion
	DECLARE Var_HoraOperacion		TIME;         -- Hora de Operacion
	DECLARE Var_LocalidadSucursal	VARCHAR(10);  -- Localidad
	DECLARE Var_ClienteID			INT(11);      -- Numero del Cliente involucrado
	DECLARE Var_PrimerNom			VARCHAR(50);  -- Perimer nombre del cliente
	DECLARE Var_SegundoNom			VARCHAR(50);  -- Segundo nombre del cliente
	DECLARE Var_TercerNom			VARCHAR(50);  -- Tercer nombre del cliente
	DECLARE Var_ApPat				VARCHAR(50);  -- Ap. Paterno del cliente
	DECLARE Var_ApMat				VARCHAR(50);  -- Ap. Materno del cliente
	DECLARE Var_RfcCliente			CHAR(13);     -- RFC del cliente
	DECLARE Var_Domicilio			VARCHAR(100); -- Domicilio del cliente
	DECLARE Var_ColoniaID			INT;		  -- Colonia del Cliente
	DECLARE Var_Colonia				VARCHAR(100); -- Colonia del Cliente
	DECLARE Var_Localidad			VARCHAR(45);  -- Localidad del cliente
	DECLARE Var_CPCliente			CHAR(5);      -- Codigo postal del cliente
	DECLARE Var_MunicipioCte		INT(11);      -- Municipio del Cliente
	DECLARE Var_EstadoCte			INT(11);      -- Estdo del cliente
	DECLARE Var_Calle				VARCHAR(50);  -- Nombre de la calle

	DECLARE Var_NumCasa             CHAR(10);   -- Numero de casa
	DECLARE Var_NumInterior         CHAR(10);   -- Numero interior
	DECLARE Var_Piso                CHAR(10);   -- Numero de Piso
	DECLARE Var_ClaveSuc            CHAR(10);   -- Clave de la sucursal (puede ser el CP o la clave proporcionada de la CNBV
	DECLARE Var_TipoInstitID        INT(11);    -- Tipo de institucion financiera
	DECLARE Var_NombreCorto         VARCHAR(45);-- Nombre corto del tipo de institucion financiera
	DECLARE Var_EmpresaDefault      INT(11);    -- Empresa DEFAULT (1)
	DECLARE Var_Institucion         INT(11);    -- Id de la institucion
	DECLARE Var_NombreInstitucion   VARCHAR(150);-- Nombre corto de la institucion
	DECLARE Var_LimiteInfOPR		DECIMAL(16,2);	-- Límite de op. relevantes.
	DECLARE Var_MonedaLimOPR		INT(11);		-- Moneda de op. relevantes.

	-- variables concatenar direccionx
	DECLARE Conversion              DECIMAL(12,2);
	DECLARE FolioCar                BIGINT(17);
	DECLARE CuenAho                 BIGINT(12);
	DECLARE FechaCar                DATE;
	DECLARE FechaApl                DATE;
	DECLARE MonMov                  DECIMAL(12,2);
	DECLARE TipDep                  VARCHAR(3);
	DECLARE TipoAhoMov                  INT(11);
	DECLARE MonedaTip               INT(11);
	DECLARE EqMoneda                VARCHAR(3);
	DECLARE EqTipCan                VARCHAR(3);
	DECLARE RefMov                  VARCHAR(50);
	DECLARE Var_FechaSis            DATE;           --  Fecha del sistema
	DECLARE Un_DiaHabil             INT(1);         --  Almacena el valor 1
	DECLARE Var_FechaSig            DATE;           --  Almacena la fecha de un dia habil siguiente a la fecha actual del sistema
	DECLARE Es_DiaHabil             CHAR(1);        --  Almacensa S= Si, N=No es dia habil
	DECLARE Var_FecIniMes           DATE;           --  Almacena la fecha con el primer dia del mes actual
	DECLARE Var_FecFinMes           DATE;           --  Almacena la fehca con el ultimo dia del mes actual
	DECLARE DiaUnoDelMes            CHAR(2);        --  Almaceba una constante con los digitos el dia 1 del mes
	DECLARE Contador                INT(2);         --  Sirve de contador en el ciclo WHILE
	DECLARE NumDiasEvalua           INT(2);         --  Numero de dias buscados en el mes para evaluar ope. relevantes
	DECLARE Var_EvaluaMes           CHAR(1);        --  Guarda si se ejecutara el proceso de ope. relevantes de depositos de efect mas altos del mes
	DECLARE EvaluaOpeAcumulaMes     CHAR(1);        --  SI
	DECLARE Var_MontoEvalua         DECIMAL(16,2);  --  Monto parametrizado a evaluar
	DECLARE EsDirecOFicial          CHAR(1);        --  Indica una constante que es una direccion oficial
	DECLARE OperRelevante           VARCHAR(100);   --  Descripcion de una operacion relevante
	DECLARE TranRelevante           VARCHAR(100);   --  Descripcion de una transaccion relevante
	DECLARE FracTranRelevante       VARCHAR(100);   --  Descripcion de operaciones fraccionadas
	DECLARE TmpTipoCambioBase       DECIMAL(12,2);
	DECLARE TmpTipoCambioExt        DECIMAL(12,2);
	DECLARE TmpTipoCambio           DECIMAL(12,2);
	DECLARE TmpConversionPeso       DECIMAL(12,2);
	DECLARE TmpConversionDolar      DECIMAL(12,2);
	DECLARE TmpFolioCar             BIGINT(17);
	DECLARE TmpCuenAho              BIGINT(12);
	DECLARE TmpFechaCar             DATE;
	DECLARE TmpMonMov               DECIMAL(12,2);
	DECLARE TmpTipDep               VARCHAR(3);
	DECLARE TmpMonedaTip            INT(11);
	DECLARE TmpMonedaBase           INT(11);
	DECLARE TmpMonedaExtrangera     INT(11);
	DECLARE Var_TipoMovAhoID            INT(11);
	DECLARE TmpFechaMov				DATE;
	DECLARE TmpHoraMov				TIME;
	DECLARE FecHisPesos             DATETIME;
	DECLARE FecHisDll               DATETIME;
	DECLARE TmpReferenciaMov        VARCHAR(50);
	DECLARE Cadena_Vacia            VARCHAR(1) DEFAULT '';
	DECLARE Fecha_Vacia             DATE;
	DECLARE Entero_Cero             INT(11) DEFAULT 0;
	DECLARE Decimal_Cero            DECIMAL(12,2) DEFAULT 0.0;
	DECLARE tipoIns                 VARCHAR(3);
	DECLARE TipoInsConver           VARCHAR(3);
	DECLARE Var_TipoDeposito        CHAR(1) DEFAULT 'E';
	DECLARE SiDirecOFicial          CHAR(1);
	DECLARE Var_CuentaCte           BIGINT(12);
	DECLARE CanalCred               INT(11);
	DECLARE CanalCta                INT(11);
	DECLARE CanalCte                INT(11);
	DECLARE CtaPrincipal            CHAR(1);
	DECLARE DepVentanilla           INT(11) DEFAULT 10;
	DECLARE DepRefere               INT(11) DEFAULT 14;
	DECLARE Var_DepRetiro     INT(11) DEFAULT 11;
	DECLARE DesPagoCreVen           VARCHAR(45);
	DECLARE DesAbonoCtaVen          VARCHAR(45);
	DECLARE DesAbonoCteVen          VARCHAR(45);
	DECLARE DesPagoCreDR            VARCHAR(45);
	DECLARE DesAbonoCtaDR           VARCHAR(45);
	DECLARE DesAbonoCteDR           VARCHAR(45);
	DECLARE Var_DesRetiroCta    VARCHAR(45);
	DECLARE DescripcionMovimiento   VARCHAR(45);
	DECLARE CanalPagCre             VARCHAR(3);
	DECLARE CanalCtaCte             VARCHAR(3);
	DECLARE Var_CanalRetCta         VARCHAR(3);
	DECLARE TipoEfectivo            CHAR(1);
	DECLARE StatusAplicado          CHAR(1) DEFAULT 'A';
	DECLARE VarTipCanal             INT(11);
	DECLARE Var_FechaMontoMax       DATE;
	DECLARE TipoSocap               INT(11);
	DECLARE TipoSofipo              INT(11);
	DECLARE TipoSofom               INT(11);
	DECLARE Str_Si                  CHAR(1);
	DECLARE Str_No                  CHAR(1);
	DECLARE CatMotivFracciona       VARCHAR(15);
	DECLARE ClaveRegistraSis        CHAR(2);
	DECLARE CatProcedAut            VARCHAR(10);
	DECLARE EstatusCapturada        CHAR(1);
	DECLARE NatAbono                CHAR(1);
	DECLARE TipoOperDep             CHAR(2);
	DECLARE TipoOperRet             CHAR(2);
	DECLARE NombreDefaultSistema    VARCHAR(4);
	DECLARE EsCliente               VARCHAR(3);
	DECLARE Var_Mayusculas      CHAR(2);
	DECLARE Var_Control       CHAR(30);
	DECLARE Var_NombreCompleto    VARCHAR(200);
	DECLARE Var_SucursalOp    INT(11);
	DECLARE Var_SucursalRelPLD		VARCHAR(200);
	DECLARE Var_DetectCargos		CHAR(1);
	DECLARE Nat_Abono				CHAR(1);

	-- Asignacion de constantes
	SET TipoEfectivo            :='E';              -- Tipo de Deposito en Efectivo
	SET CanalCred               := 1;               -- Tipo de Canal para creditos
	SET CanalCta                := 2;               -- Tipo de Canal para cuentas
	SET CanalCte                := 3;               -- Tipo de Canal para clientes
	SET Entero_Cero             := 0;               -- Entero cero

	SET Cadena_Vacia            := '';              -- Cadena Vacia
	SET Fecha_Vacia             := '1900-01-01';    -- Fecha Vacia
	SET TipoInsConver           := '01';            -- Tipo de Instrumento monetario
	SET SiDirecOFicial          := 'S';             -- Si es direccion oficial
	SET EvaluaOpeAcumulaMes     := 'S';             -- Si evalua el acumulado en el mes
	SET CtaPrincipal            := 'S';             -- Si es cuenta principal
	SET DepVentanilla           := 10;
	SET Var_DepRetiro			:= 11;
	SET DepRefere               := 14;
	SET DesPagoCreVen           :='DEPOSITO PAGO DE CREDITO';
	SET DesAbonoCtaVen          :='ABONO DE EFECTIVO EN CUENTA';
	SET DesAbonoCteVen          :='ABONO DE EFECTIVO EN CUENTA';
	SET DesPagoCreDR            :='DEPOSITO A CREDITO';
	SET DesAbonoCtaDR           :='DEPOSITO A CUENTA';
	SET DesAbonoCteDR           :='DEPOSITO A CUENTA CLIENTE';
	SET Var_DesRetiroCta        :='RETIRO DE EFECTIVO EN CUENTA';
	SET CanalPagCre             :='09';
	SET CanalCtaCte             :='01';
	SET Var_CanalRetCta         :='02';
	SET OperRelevante           :='EXCEDE MONTO MENSUAL DEL PARAMETRO DE OPERACION RELEVANTE';
	SET TranRelevante           :='EXCEDE MONTO DE TRANSACCION DEL PARAMETRO DE OPERACION RELEVANTE';
	SET FracTranRelevante       :='OPERACIONES FRACCIONADAS SUPERAN EL LIMITE DE PARAMETROS OPERACIONES RELEVANTES.';

	SET TipoSocap               := 6;   -- Tipo SOCAP, corresponde a la tabla TIPOSINSTITUCION
	SET TipoSofipo              := 3;   -- Tipo SOFIPO, corresponde a la tabla TIPOSINSTITUCION
	SET TipoSofom               := 4;   -- Tipo SOFOM, corresponde a la tabla TIPOSINSTITUCION
	SET Str_Si                  := 'S'; -- Constante SI
	SET Str_No                  := 'N'; -- Constante NO
	SET CatMotivFracciona       := 'FRACCIONA'; -- Corresponde al ID de PLDCATMOTIVINU
	SET ClaveRegistraSis        := '3';         -- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
	SET CatProcedAut            := 'PR-SIS-000';-- Corresponde al ID de PLDCATPROCEDINT: PROCEDIMIENTOS AUTOMATICO DE ALERTAS
	SET EstatusCapturada        := '1';     -- Estatus de Operacion inusual detectada y capturada (1.- Capturada  2.- En Seguimiento  3.-Reportada  4.- No Reportada)
	SET NatAbono                := 'A';     -- Naturaleza de la operacion: Abono
	SET Un_DiaHabil             := 1;       -- NUMERO DE DIAS HABILES: 1 DIA
	SET TipoOperDep             := '01';    -- Tipo de operacion de deposito segun la CNBV
	SET TipoOperRet             := '02';    -- Tipo de operacion de retiro segun la CNBV
	SET NombreDefaultSistema    := 'SAFI';  -- Nombre DEFAULT del sistema
	SET EsCliente               := 'CTE';   -- Tipo de persona Cliente
	SET Var_Mayusculas      	:= 'MA';  -- Obtener el resultado en Mayusculas
	SET Nat_Abono				:= 'A';

	SET Var_FechaSis := Par_FechaCarga;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEREELEVANPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		-- Obtener Valores de la Institucion
		SELECT MAX(EmpresaDefault)
			INTO Var_EmpresaDefault
			FROM PARAMETROSSIS;

		SELECT InstitucionID,		MonedaBaseID
			INTO Var_Institucion,	TmpMonedaBase
				FROM PARAMETROSSIS
				WHERE  EmpresaID = Var_EmpresaDefault;

		SELECT NombreCorto
			INTO Var_NombreInstitucion
				FROM INSTITUCIONES
				WHERE InstitucionID = Var_Institucion;

		SET Var_NombreInstitucion	:= IFNULL(Var_NombreInstitucion, NombreDefaultSistema);
		SET Var_SucursalRelPLD		:= FNPARAMGENERALES('SucursalRelPLD');
		SET Var_SucursalRelPLD		:= IFNULL(Var_SucursalRelPLD, Cadena_Vacia);
		SET Var_DetectCargos		:= FNPARAMGENERALES('EvaluaCargosFracPLD');
		SET Var_DetectCargos		:= IFNULL(Var_DetectCargos, Str_No);

		-- Se obtiene el tipo de institucion financiera
		SELECT IFNULL(Ins.TipoInstitID,Entero_Cero),    Tip.NombreCorto
			INTO Var_TipoInstitID,                        Var_NombreCorto
			FROM PARAMETROSSIS Par
			INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
			INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID;

		/* === VALIDA EL ACUMULADO MENSUAL DE OPERACIONES (ABONOS) EN EFECTIVO QUE SUPEREN EL LIMITE DE OP. RELEVANTE === */

		# Calcula el dia habil siguiente para verificar si el dia actual es cierre de mes.
		CALL DIASFESTIVOSCAL(
			Var_FechaSis,   Un_DiaHabil,    Var_FechaSig,     Es_DiaHabil,    Par_EmpresaID,
			Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
			Aud_NumTransaccion);

		SELECT IFNULL(EvaluaOpeAcumMes,Str_Si) INTO Var_EvaluaMes
			FROM PARAMETROSOPREL LIMIT 1;

		/* Si es fin de mes ejecutara el proceso de validacion para operaciones relevantes con las condiciones:
		* - Obtiene todas aquellas transacciones con las cantidades que no rebasen el limite de las operaciones relevantes durante el mes
		* - Si la suma de esas transacciones supera el monto parametrizado, se considera una operacion inusual
		* Siempre va a estar prendida la opcion en PARAMETROSOPREL
		* El siguiente bloque se ejecuta solo cuando es cierre de mes */
		IF(MONTH(Var_FechaSis) != MONTH(Var_FechaSig) AND Var_EvaluaMes = EvaluaOpeAcumulaMes)THEN
			# Calcular la Fecha de Inicio y Fin del Mes en curso a partir de la Fecha de sistema
			SET DiaUnoDelMes    := '01';
			SET EsDirecOFicial  := 'S';
			SET Contador        := 0;
			SET NumDiasEvalua   := 5;

			SET Var_FecIniMes     := DATE(CONCAT(CAST(EXTRACT(YEAR FROM Var_FechaSis) AS CHAR),'-',CAST(EXTRACT(MONTH FROM Var_FechaSis) AS CHAR),'-',DiaUnoDelMes ));
			SET Var_FecFinMes     := DATE_ADD(Var_FecIniMes,INTERVAL 1 MONTH);
			SET Var_FecFinMes     := DATE_ADD(Var_FecFinMes,INTERVAL -1 DAY);

			# Tabla Temporal que guarda todos los Abonos en Efectivo
			DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVO;
			CREATE TEMPORARY TABLE TMP_PLDDEPEFECTIVO (
				RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
				NumeroMov   	BIGINT(20),
				ClienteID   	INT(11),
				CuentaAhoID 	BIGINT(12),
				Monto       	DECIMAL(18,2),
				NatMovimiento	CHAR(1),
				Fecha       	DATE,
				INDEX(NumeroMov,ClienteID,CuentaAhoID)
			);

			# Tabla Temporal de paso que guarda el total de las transacciones que no rebasen el limite de op relevantes
			DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVOPASO;
			CREATE TEMPORARY TABLE TMP_PLDDEPEFECTIVOPASO (
				RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
				NumeroMov   	BIGINT(20),
				ClienteID   	INT(11),
				Monto       	DECIMAL(18,2),
				NatMovimiento	CHAR(1),
				Fecha       	DATE,
				INDEX(NumeroMov,ClienteID)
			);

			# Tabla Temporal de paso, que guarda el total por cliente cuyas transacciones si superan el limite de op relevantes
			DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVOMES;
			CREATE TEMPORARY TABLE TMP_PLDDEPEFECTIVOMES (
				RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
				NumeroMov   	BIGINT(20),
				ClienteID   	INT(11),
				Monto       	DECIMAL(18,2),
				NatMovimiento	CHAR(1),
				Fecha       	DATE,
				INDEX(NumeroMov,ClienteID)
			);

			/* Tabla Temporal de resultados, en esta se guardaran temporalmente los clientes que se encontraron por rebasa
			 * el limite de  op. relevantes */
			DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVORESUL;
			CREATE TEMPORARY TABLE TMP_PLDDEPEFECTIVORESUL (
				RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
				ClienteID       INT(11),
				Monto           DECIMAL(18,2),
				NatMovimiento	CHAR(1),
				Calle           VARCHAR(100),
				Colonia         VARCHAR(200),
				LocalidadSuc    VARCHAR(10),
				LocalidadCli    VARCHAR(10),
				MunicipioID     INT(11),
				CP              CHAR(5),
				INDEX(ClienteID)
			);

			# Obtener el monto a evaluar parametrizado
			SET Var_MonedaLimOPR	:= (SELECT MonedaLimOPR FROM PARAMETROSOPREL);
			SET Var_LimiteInfOPR	:= (SELECT LimiteInferior FROM PARAMETROSOPREL);
			SET Var_LimiteInfOPR	:= ROUND((Var_LimiteInfOPR * FNGETTIPOCAMBIO(Var_MonedaLimOPR, 1, Var_FecFinMes)),2);
			SET Var_MontoEvalua		:= IFNULL(Var_LimiteInfOPR, Decimal_Cero);

			# Se obtienen todos los Abonos que se realizaron en Efectivo durante el mes en curso, por transaccion, por cliente
			IF(Var_DetectCargos =  Str_Si) THEN
				INSERT INTO TMP_PLDDEPEFECTIVO (
					NumeroMov,      ClienteID,      CuentaAhoID,    Fecha,
					Monto,			NatMovimiento)
				SELECT
					CM.NumeroMov,  C.ClienteID,  C.CuentaAhoID,   CM.Fecha,
						ROUND((IFNULL(IF(H.TipCamDof IS NULL, M.TipCamDof, H.TipCamDof),1) * CM.CantidadMov),2),
					CM.NatMovimiento
				FROM CUENTASAHO C
					INNER JOIN `CUENTASAHOMOV` CM ON C.CuentaAhoID=CM.CuentaAhoID
					LEFT JOIN TIPOSMOVSAHO T ON CM.TipoMovAhoID=T.TipoMovAhoID
					LEFT JOIN `HIS-MONEDAS` AS H ON CM.MonedaID=H.MonedaID
					LEFT JOIN MONEDAS AS M ON CM.MonedaID= M.MonedaID
					WHERE CM.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
						AND T.EsEfectivo = Str_Si
							GROUP BY CM.NumeroMov,		C.ClienteID,	C.CuentaAhoID,	CM.Fecha,
										M.TipCamDof,	H.TipCamDof,	CM.CantidadMov,	CM.NatMovimiento;
			ELSE
				INSERT INTO TMP_PLDDEPEFECTIVO (
					NumeroMov,      ClienteID,      CuentaAhoID,    Fecha,
					Monto,			NatMovimiento)
				SELECT
					CM.NumeroMov,  C.ClienteID,  C.CuentaAhoID,   CM.Fecha,
						ROUND((IFNULL(IF(H.TipCamDof IS NULL, M.TipCamDof, H.TipCamDof),1) * CM.CantidadMov),2),
					CM.NatMovimiento
				FROM CUENTASAHO C
					INNER JOIN `CUENTASAHOMOV` CM ON C.CuentaAhoID=CM.CuentaAhoID
					LEFT JOIN TIPOSMOVSAHO T ON CM.TipoMovAhoID=T.TipoMovAhoID
					LEFT JOIN `HIS-MONEDAS` AS H ON CM.MonedaID=H.MonedaID
					LEFT JOIN MONEDAS AS M ON CM.MonedaID= M.MonedaID
					WHERE CM.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
						AND T.EsEfectivo = Str_Si
						AND CM.NatMovimiento = Nat_Abono
							GROUP BY CM.NumeroMov,		C.ClienteID,	C.CuentaAhoID,	CM.Fecha,
										M.TipCamDof,	H.TipCamDof,	CM.CantidadMov,	CM.NatMovimiento;
			END IF;

			# Se obtiene la sumatoria por cliente de aquellas transacciones que no rebasen el limite de operaciones relevantes
			INSERT INTO TMP_PLDDEPEFECTIVOPASO (
					NumeroMov,		ClienteID,	Monto,			Fecha,		NatMovimiento)
				SELECT
					MAX(NumeroMov),	ClienteID,	SUM(Monto),		MAX(Fecha),	NatMovimiento
				FROM TMP_PLDDEPEFECTIVO
				WHERE Monto <= Var_MontoEvalua
				GROUP BY ClienteID, NatMovimiento;

			# Del total por cliente se obtienen aquellos clientes que si rebasan el limite de operaciones relevantes
			INSERT INTO TMP_PLDDEPEFECTIVOMES (
				NumeroMov, ClienteID, Monto,    Fecha,	NatMovimiento)
			SELECT
				NumeroMov, ClienteID, Monto,    Fecha,	NatMovimiento
				FROM TMP_PLDDEPEFECTIVOPASO
				WHERE Monto > Var_MontoEvalua;

			# Guarda los clientes con la suma total de sus depositos en efectivo durante el mes
			INSERT INTO TMP_PLDDEPEFECTIVORESUL (
				ClienteID,          Monto,          Calle,			Colonia,		CP,
				MunicipioID,        LocalidadCli,   LocalidadSuc,	NatMovimiento)
			SELECT
				Tmp.ClienteID,      Tmp.Monto,      Dir.Calle,		Colonia,		Dir.CP,
				Dir.MunicipioID,    Mun.Localidad,  Cadena_Vacia,	NatMovimiento
				FROM TMP_PLDDEPEFECTIVOMES Tmp,
				DIRECCLIENTE Dir,
				MUNICIPIOSREPUB Mun
				WHERE Tmp.ClienteID = Dir.ClienteID
					AND Dir.EstadoID = Mun.EstadoID
					AND Dir.MunicipioID = Mun.MunicipioID
					AND Dir.Oficial = EsDirecOFicial
					ORDER BY Tmp.ClienteID;

			SET Var_FechaOperacion := Par_FechaCarga;
			SET Aud_FechaActual := NOW();
			SELECT IFNULL(MAX(OpeInusualID),Entero_Cero)
				INTO @id
				FROM PLDOPEINUSUALES;

			/* Se registra los clientes detectados como operacion inusual para quienes hayan superado el monto limite
			 * parametrizado de operaciones relevantes */
			INSERT INTO PLDOPEINUSUALES (
				Fecha,              OpeInusualID,           ClaveRegistra,      NombreReg,              CatProcedIntID,
				CatMotivInuID,      FechaDeteccion,         SucursalID,         ClavePersonaInv,        NomPersonaInv,
				EmpInvolucrado,     Frecuencia,             DesFrecuencia,      DesOperacion,           Estatus,
				ComentarioOC,       FechaCierre,            CreditoID,          CuentaAhoID,            TransaccionOpe,
				NaturaOperacion,    MontoOperacion,         MonedaID,           FolioInterno,           TipoOpeCNBV,
				FormaPago,          TipoPersonaSAFI,        NombresPersonaInv,  ApPaternoPersonaInv,    ApMaternoPersonaInv,
				EmpresaID,          Usuario,                FechaActual,        DireccionIP,            ProgramaID,
				Sucursal,           NumTransaccion)
			SELECT
				Var_FechaOperacion, @id := @id +1,          ClaveRegistraSis,   Var_NombreInstitucion,  CatProcedAut,
				CatMotivFracciona,  Var_FechaOperacion,     Suc.SucursalID,     Tmp.ClienteID,          Cli.NombreCompleto,
				Cadena_Vacia,       Str_No,                 Cadena_Vacia,       FracTranRelevante,      EstatusCapturada,
				Cadena_Vacia,       Fecha_Vacia,            Entero_Cero,        Entero_Cero,            Entero_Cero,
				Tmp.NatMovimiento,	Tmp.Monto,              TmpMonedaBase,      Entero_Cero,            IF(Tmp.NatMovimiento=Nat_Abono,TipoOperDep,TipoOperRet),
				TipoEfectivo,       EsCliente,
				FNGENNOMBRECOMPLETO(Cli.PrimerNombre,Cli.SegundoNombre,Cli.TercerNombre, '', '') AS NombresPersonaInv,
				Cli.ApellidoPaterno,Cli.ApellidoMaterno,        Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion
				FROM TMP_PLDDEPEFECTIVORESUL Tmp,
				CLIENTES Cli,
				SUCURSALES Suc
				WHERE Tmp.ClienteID = Cli.ClienteID
					AND Cli.SucursalOrigen = Suc.SucursalID;

			DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVO;
			DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVOPASO;
			DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVOMES;
			DROP TABLE IF EXISTS TMP_PLDDEPEFECTIVORESUL;
		END IF;  # fin de bloque cierre de mes

		SET Par_NumErr    := Entero_Cero;
		SET Par_ErrMen    := 'Proceso de Deteccion Op. Relevantes Finalizado Exitosamente.';
		SET Var_Control    := 'opeInusualID';
	END ManejoErrores;

	IF (Par_Salida = Str_Si) THEN
		SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_FechaCarga AS Consecutivo;
	END IF;

END TerminaStore$$
