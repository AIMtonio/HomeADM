-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREGENERALVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREGENERALVAL`;
DELIMITER $$

CREATE PROCEDURE `CIERREGENERALVAL`(
# ===========================================================
# --------- SP PARA LA VALIDACION DEL CIERRE GENERAL---------
# ===========================================================
	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema		DATETIME;
	DECLARE Var_FechaOper			DATE;
	DECLARE Var_FecSiguie			DATE;
	DECLARE Es_DiaHabil				CHAR(1);
	DECLARE Var_Frecuencia			VARCHAR(200);
	DECLARE Var_ProductoCreditoID	INT(11);
	DECLARE Var_NumInversion		INT(11);
	DECLARE Var_FecFinMesAnt 		DATE;
	DECLARE Var_FecIniMesAnt		DATE;
	DECLARE Var_TasaBaseID			INT(11);
	DECLARE Var_NumCreditos			INT(11);
	DECLARE Var_NombreTasa			VARCHAR(100);
	DECLARE Var_ClienteEspecifico	VARCHAR(10);
	DECLARE Var_ProductosDias		INT(11);
	DECLARE Var_Productos			INT(11);

	-- Declaracion de Constantes
	DECLARE SalidaSI				CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE EstatusAlta				CHAR(1);
	DECLARE EstatusActiva			CHAR(1);
	DECLARE SiCobra					CHAR(1);
	DECLARE SiGeneraInteres			CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Un_DiaHabil				INT(11);
	DECLARE Inactivo				CHAR(1);
	DECLARE Autorizado				CHAR(1);
	DECLARE Vigente					CHAR(1);
	DECLARE Vencido					CHAR(1);
	DECLARE Castigado				CHAR(1);
	DECLARE SiGarantizado			CHAR(1);
	DECLARE EstatusVigente			CHAR(1);
	DECLARE PagoUnico				CHAR(1);
	DECLARE PagoPeriodico			CHAR(1);
	DECLARE Var_CtasBloq 			INT(11);
	DECLARE CliConfiadora			INT(11);
	DECLARE SalidaNO				CHAR(1);

	-- Asignacion de Constantes
	SET SalidaSI					:= 'S';		-- Salida SI
	SET SalidaNO					:= 'N';		-- Salida No
	SET Entero_Cero					:= 0;		-- Entero Cero
	SET Cadena_Vacia				:= '';		-- Caden Vacia
	SET EstatusAlta					:= 'A';		-- Estatus de la transferencia (Alta)
	SET EstatusActiva				:= 'A';		-- Estatus Activa
	SET SiCobra						:= 'S';		-- Si cobra comision por falso cobro
	SET SiGeneraInteres				:= 'S';		-- si Genera Interes
	SET Decimal_Cero				:= 0.0;		-- DECIMAL Cero
	SET Un_DiaHabil					:= 1;		-- Un Dia habil
	SET Inactivo					:= 'I';		-- Inactivo
	SET Autorizado					:= 'A';		-- autorizado
	SET Vigente						:= 'V';		-- Vigente
	SET Vencido						:= 'B';		-- Vencido
	SET Castigado					:= 'K';		-- Kastigado
	SET SiGarantizado				:= 'S';		-- especifica si el producto de credito requiere garantia liquida
	SET EstatusVigente				:= 'V';
	SET PagoUnico					:= 'U';
	SET PagoPeriodico				:= 'I';
	SET CliConfiadora				:= 46;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CIERREGENERALVAL');
			END;

		SELECT FechaSistema INTO Var_FechaSistema
			FROM PARAMETROSSIS
			LIMIT 1;
		SET Var_FechaOper	:= Var_FechaSistema;

		SELECT ValorParametro
		INTO Var_ClienteEspecifico
		FROM PARAMGENERALES
		WHERE LlaveParametro = 'PermiteValidaCajas';
	--  Calculamos la Fecha de Operacion
		CALL DIASFESTIVOSCAL(
			Var_FechaOper,		Un_DiaHabil,		Var_FecSiguie,		Es_DiaHabil,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		-- VAlidacion de Cajas Abiertas y Transferencias Pendientes para caja CONFIADORA
		IF(Var_ClienteEspecifico = SalidaSI) THEN
			CALL VALIDACAJASPRO (	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion );
		END IF;
		-- Se valida que las Cajas CA Y CP no tengan transferencias pendientes.
		IF EXISTS(SELECT CajaDestino
					FROM 	CAJASTRANSFER CT
					WHERE 	CT.Estatus 	= EstatusAlta
					AND 	CT.Fecha	= Var_FechaSistema)THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen 	:= 'Existen Transferencias de Efectivo entre Cajas Pendientes de Recibir, por tal Motivo el Cierre General no ha sido Realizado';
			LEAVE ManejoErrores;
		END IF;

		-- Se valida que no exista una caja abierta en el sistema
		IF EXISTS(SELECT CajaID
						FROM CAJASVENTANILLA
						WHERE Estatus 		=	EstatusAlta
						AND EstatusOpera	=	EstatusActiva)THEN
			SET Par_NumErr	:=2;
			SET Par_ErrMen := 'Existen Cajas en Sucursal que  no han Sido Cerradas o Finalizado Operaciones, por tal Motivo el Cierre General no ha sido Realizado';
			LEAVE ManejoErrores;
		END IF;

		DROP TABLE IF EXISTS TMPFRECUENCIASPROD;
			CREATE TEMPORARY TABLE TMPFRECUENCIASPROD(	`RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                                        ProductoCreditoID		INT(11) ,
														Frecuencia				VARCHAR(200));

		INSERT INTO TMPFRECUENCIASPROD (`ProductoCreditoID`, `Frecuencia`)
			SELECT C.ProductoCreditoID,C.FrecuenciaCap
				FROM 	CREDITOS C
				WHERE 	Estatus IN (Inactivo,Autorizado,Vigente,Vencido,Castigado)
				GROUP BY C.ProductoCreditoID,C.FrecuenciaCap;

		SELECT COUNT(P.ProductoCreditoID)
			INTO	Var_ProductosDias
			FROM  TMPFRECUENCIASPROD P
				WHERE  NOT EXISTS(SELECT D.ProducCreditoID,D.Frecuencia
									FROM 	DIASPASOVENCIDO D
									WHERE 	D.ProducCreditoID	= P.ProductoCreditoID
									AND 	D.Frecuencia		= P.Frecuencia);

		SET Var_ProductosDias := IFNULL(Var_ProductosDias,Entero_Cero);

		 IF(Var_ProductosDias > Entero_Cero)THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen 	:= 'Existen productos de Credito sin Parametrizacion de los Dias de Paso a Vencido del Credito, por tal Motivo el Cierre General no ha sido Realizado';
			LEAVE ManejoErrores;
		END IF;

		-- Validamos el esquema de Comision por falta de Pago si el producto asi lo requiere
		IF EXISTS(SELECT 	ProducCreditoID
					FROM 	PRODUCTOSCREDITO  P
					WHERE 	P.CobraFaltaPago = SiCobra
					AND NOT EXISTS(SELECT ProducCreditoID
										FROM 	ESQUEMACOMISCRE E
										WHERE 	E.ProducCreditoID	= P.ProducCreditoID))THEN
			SET Par_NumErr	:=4;
			SET Par_ErrMen := 'Existen Productos de Credito con cobro de Comision por Falta de Pago que NO tienen un Esquema de Cobro Parametrizado, por tal Motivo el Cierre General no ha sido Realizado ';
			LEAVE ManejoErrores;
		END IF ;

		-- validamos que si cobra Moratorios exista un tipo Cobro de Moratorios.
		IF EXISTS(SELECT CobraMora,FactorMora, TipCobComMorato
					FROM 	PRODUCTOSCREDITO
					WHERE 	CobraMora 			= SiCobra
					AND 	(FactorMora  		<= Decimal_Cero
					OR 		(TipCobComMorato 	= Cadena_Vacia
					OR 		TipCobComMorato 	= NULL)))THEN
			SET Par_NumErr	:=5;
			SET Par_ErrMen 	:= 'Existen Productos de Credito con cobro de Moratorios sin un Tipo o Monto de Cobro Capturados, por tal Motivo el Cierre General no ha sido Realizado';
			LEAVE ManejoErrores;
		END IF;

		--  Validamos que las Cuentas que si generan interes tengan parametrizada una Tasa de Ahorro
		IF (MONTH(Var_FechaOper) != MONTH(Var_FecSiguie))THEN
			DROP TABLE IF EXISTS TMPTASAAHORRO;
			CREATE TEMPORARY TABLE TMPTASAAHORRO(RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
												TipoCuentaID	INT(11) ,
												TipoPersona		CHAR(1));

			 INSERT INTO TMPTASAAHORRO (TipoCuentaID,		TipoPersona)
				SELECT  TC.TipoCuentaID,C.TipoPersona
					FROM 	CLIENTES C,TIPOSCUENTAS TC, CUENTASAHO CA
					 WHERE 	TC.GeneraInteres	= SiGeneraInteres
					 AND 	CA.Estatus			= EstatusActiva
					 AND 	TC.TipoCuentaID		= CA.TipoCuentaID
					 AND 	CA.ClienteID		= C.ClienteID
					 GROUP BY   TC.TipoCuentaID, C.TipoPersona;


			IF EXISTS(SELECT TC.TipoCuentaID, TC.TipoPersona
						FROM TMPTASAAHORRO TC,TASASAHORRO TA
						WHERE NOT EXISTS(SELECT TA.TipoCuentaID
											FROM 	TASASAHORRO TA
											WHERE 	TA.TipoCuentaID = TC.TipoCuentaID
											AND  	TA.TipoPersona	= TC.TipoPersona))THEN
				SET Par_NumErr	:=6;
				SET Par_ErrMen := 'Existen Tipos de Cuentas que Generan Interes y no tienen parametrizada una Tasa de Ahorro, por tal Motivo el Cierre General no ha sido Realizado';
				LEAVE ManejoErrores;
			END IF;
			DROP TABLE IF EXISTS TMPTASAAHORRO;
		END IF;

		/* Validacion para la parametrizacion de Garantia Liquida en los Productos de credito */
		IF EXISTS (SELECT ProducCreditoID
					FROM 	PRODUCTOSCREDITO
					WHERE 	(Garantizado IS NULL OR Garantizado = Cadena_Vacia)
					LIMIT 	1)THEN
			SET Par_NumErr	:= 7;
			SET Par_ErrMen  := 'Existen Productos de Credito sin parametrizacion de Garantia Liquida';
			LEAVE ManejoErrores;
		END IF;

		IF EXISTS (SELECT ProducCreditoID
					FROM 	PRODUCTOSCREDITO Pro
					WHERE 	Garantizado = SiGarantizado
					AND NOT EXISTS(SELECT ProducCreditoID
									FROM 	ESQUEMAGARANTIALIQ Esq
									WHERE 	Pro.ProducCreditoID	= Esq.ProducCreditoID)
									LIMIT 	1) THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen 	:= 'Existen Productos de Credito que requieren Garantia Liquida y No tienen un esquema parametrizado';
			LEAVE ManejoErrores;
		END IF;

		--  Validacion Inversiones
		SET Var_NumInversion := (SELECT COUNT(InversionID)
									FROM 	INVERSIONES
									WHERE 	Estatus		= 'A'
                                    AND 	FechaInicio	= Var_FechaSistema);

		IF (IFNULL(Var_NumInversion, Entero_Cero) > Entero_Cero ) THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= 'Existen Inversiones que no han sido Autorizadas o Canceladas, por tal Motivo el Cierre General no ha sido Realizado';
			LEAVE ManejoErrores;
		END IF;

		 --  Validacion Existencia de una tasabase de el mes anterior para creditos con calculo de interes tipo 4
		SET	Var_FecFinMesAnt	:= LAST_DAY(DATE_SUB(Var_FechaOper, INTERVAL 1 MONTH));
		SET Var_FecIniMesAnt    := DATE_SUB(Var_FecFinMesAnt, INTERVAL DAYOFMONTH(Var_FecFinMesAnt)-1 DAY);


		IF EXISTS (SELECT CreditoID
					FROM 	CREDITOS cre
					WHERE 	CalcInteresID = 4
					AND   (Estatus = Vigente OR Estatus = Vencido OR Estatus = Castigado)
					AND NOT EXISTS(SELECT Fecha
									FROM 	`HIS-TASASBASE` his
									WHERE 	cre.TasaBase	= his.TasaBaseID
									AND		Fecha	 		>= Var_FecIniMesAnt
									AND		Fecha	 		<= Var_FecFinMesAnt)
									LIMIT 	1) THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen 	:= 'Existen Creditos con Calculo de Interes Tasa Base Mes Anterior + Puntos, que no tienen una tasa base registrada en el mes anterior';
			LEAVE ManejoErrores;
		END IF;

		IF(NOT EXISTS(SELECT FolioID
						FROM 	PARAMPLDOPEEFEC
						WHERE 	Estatus = EstatusVigente))THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := CONCAT('No Existen Parametros Vigentes en Parametros Operaciones Operaciones en Efectivo,
								por tal Motivo el Cierre General no ha sido Realizado.');
			LEAVE ManejoErrores;
		END IF;

		SELECT 	TasaBaseID, 	Tas.Nombre
				INTO Var_TasaBaseID, Var_NombreTasa
			FROM 	CREDITOS Cre
					INNER JOIN TASASBASE AS Tas
			WHERE 	CalcInteresID != 1
            AND 	CalcInteresID != 4
			AND  	(Estatus = Vigente OR Estatus = Vencido OR Estatus = Castigado)
			AND 	Tas.Valor IS NULL
            LIMIT 	1;

		IF(IFNULL(Var_TasaBaseID,Entero_Cero) != Entero_Cero) THEN
			SET Var_NumCreditos := (SELECT COUNT(CreditoID) FROM CREDITOS WHERE CalcInteresID =Var_TasaBaseID);
			SET Var_NumCreditos := IFNULL(Var_NumCreditos,Entero_Cero);
			SET Var_NombreTasa 	:= IFNULL(Var_NombreTasa, Cadena_Vacia);
			SET Par_NumErr 		:= 12;
			SET Par_ErrMen 		:= CONCAT('No existe Tasa ',Var_NombreTasa,' Capturada para el Calculo de Intereses de ',Var_NumCreditos,' Credito(s) Vigente(s).');
		END IF;

		-- Se valida si existen creditos de Pago Unico de Capital y Periodico de Intereses

		DROP TABLE IF EXISTS TMPFRECUENCIASPROD;
			CREATE TEMPORARY TABLE TMPFRECUENCIASPROD(	`RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                                                        ProductoCreditoID	INT(11) ,
														Frecuencia			VARCHAR(200),
														FrecuenciaInt		CHAR(1));

		INSERT INTO TMPFRECUENCIASPROD (`ProductoCreditoID`,              `Frecuencia`,                 `FrecuenciaInt`)
			SELECT C.ProductoCreditoID,C.FrecuenciaCap, C.FrecuenciaInt
				FROM 	CREDITOS C
				WHERE 	Estatus IN (Inactivo,Autorizado,Vigente,Vencido,Castigado)
				AND 	C.FrecuenciaCap 	= PagoUnico
				AND 	C.FrecuenciaInt  	!= PagoUnico
				GROUP BY C.ProductoCreditoID,C.FrecuenciaCap, C.FrecuenciaInt;

		SELECT COUNT(P.ProductoCreditoID)
			INTO Var_Productos
					FROM  TMPFRECUENCIASPROD P
					WHERE NOT  EXISTS(SELECT D.ProducCreditoID
										FROM 	DIASPASOVENCIDO  D
										WHERE	P.ProductoCreditoID = D.ProducCreditoID
										AND 	D.Frecuencia IN(PagoPeriodico))
										GROUP BY P.ProductoCreditoID;

		SET Var_Productos := IFNULL(Var_Productos,Entero_Cero);

		 IF(Var_Productos > Entero_Cero) THEN
			SET Par_NumErr	:=13;
			SET Par_ErrMen 	:=CONCAT('Existen Productos de Credito que no tienen parametrizado la frecuencia PAGO UNICO/INT. PERIODICO
									  y corresponden a creditos con pago unico de capital y periodico de intereses,
									  por tal motivo el Cierre General no ha sido realizado');
			LEAVE ManejoErrores;
		END IF;

		-- Validacion de CEDES por Autorizar
		IF EXISTS(SELECT CedeID
					FROM 	CEDES
					WHERE 	Estatus		= EstatusAlta
                    AND 	FechaInicio	= Var_FechaSistema)THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= CONCAT('Existen CEDES Pendientes por Autorizar, ',
									  'por tal Motivo el Cierre General no ha sido Realizado.');
			LEAVE ManejoErrores;
		END IF;

		TRUNCATE TABLE TMPCTASBLOQUEADAS;

		INSERT INTO TMPCTASBLOQUEADAS
		SELECT CTA.CuentaAhoID,CTE.ClienteID,INV.InversionID
			FROM CUENTASAHO CTA
				INNER JOIN CLIENTES CTE ON CTA.ClienteID = CTE.ClienteID
				INNER JOIN INVERSIONES INV ON CTE.ClienteID = INV.ClienteID AND CTA.CuentaAhoID = INV.CuentaAhoID
			WHERE CTA.Estatus = 'B'
				AND INV.FechaVencimiento = Var_FechaSistema;

		SET Var_CtasBloq := (SELECT COUNT(*) FROM  TMPCTASBLOQUEADAS);

		IF(Var_CtasBloq > Entero_Cero) THEN
			SET Par_NumErr	:=15;
			SET Par_ErrMen 	:= 'Existen cuentas bloqueadas asociadas a Inversiones que vencen hoy';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen 	:= 'Validacion Realizada Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Cadena_Vacia	AS control,
				Entero_Cero 	AS consecutivo;
	END IF;

END TerminaStore$$
