-- OPERACIONBASICAUNIDADREP
DELIMITER ;
DROP PROCEDURE IF EXISTS OPERACIONBASICAUNIDADREP;
DELIMITER $$

CREATE PROCEDURE OPERACIONBASICAUNIDADREP(
	-- Descripcion: Proceso para generar reporte con informacion basica de la operacion de cada asesor en un dia o en un periodo de tiempo especifico
	-- Modulo: Cartera(Operacion Basica de Unidad)
	Par_FechaInicio				DATE,			-- Fecha de inicio no mayor a la del sistema
	Par_FechaFin				DATE,			-- Fecha fin no mayor a la del sistema ni menor a la fecha de Inicio
	Par_SucursalID				INT(11),		-- Sucursal si es igual a cero indica todas las sucursales
	Par_CoodinadorID			INT(11),		-- Parametro que indica el coordinador que es el rol 14 de usuarios
	Par_PromotorID				INT(11),		-- Parametro para el promotor

	Par_TipoReporte				INT(11),		-- Tipo del reporte 1.- Formato Excel

	Par_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia		VARCHAR(9000); 	-- Sentencia a Ejecutar
	DECLARE Var_ResReporte		CHAR(1);		-- Variable que indica si se restringe o no un reporte
	DECLARE Var_Dependencia		VARCHAR(1000);	-- Variable para almacenar los usuarios que tienen dependencia
	DECLARE Var_FechaInicio		DATETIME;		-- Variable para almacenar la fecha de inicio
	DECLARE Var_FechaFin		DATETIME;		-- Variable para almacenar la fecha de fin
	DECLARE Var_FechaSistema	DATE;			-- Almacena la fecha actual del sistema
	DECLARE Var_Consecutivo		BIGINT(20);		-- Consecutivo general

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante cadena vacia ''
	DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Con_SI				CHAR(1);		-- Constante SI
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno			INT(11);		-- Constantes de entero uno
	DECLARE Fecha_Vacia 		DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cien			INT(11);		-- Constante de entero cien
	DECLARE Entero_Mil			INT(11);		-- Constante de entero mil
	DECLARE Con_Todos			VARCHAR(5);		-- Constante de todos
	DECLARE Est_Pagado			CHAR(1);		-- Estatus pagado
	DECLARE Tipo_Renovacion		CHAR(1);		-- Tipo de credito renovado
	DECLARE Tipo_Nuevo			CHAR(1);		-- Tipo de creditos nuevos
	DECLARE Tipo_Promotor		CHAR(1);		-- Tipo Promotor
	DECLARE Tipo_Coordinador	CHAR(1);		-- Tipo coordinador
	DECLARE Caja_Publico		CHAR(2);		-- Caja publico
	DECLARE Caja_Principal		CHAR(2);		-- Caja principal
	DECLARE GastosComprobar		INT(11);		-- Operacion de gastos y anticipos
	DECLARE Entero_Dos			INT(11);		-- Entero dos
	DECLARE Est_Atrasado		CHAR(1);		-- Estatus atrasado
	DECLARE	Est_Vigente			CHAR(1);		-- Estatus vigente
	DECLARE	Est_Vencido			CHAR(1);		-- Estatus vencido
	DECLARE Est_Cancelado		CHAR(1);		-- Estatus cancelado

	-- DECLARACION DE TIPOS DE REPORTES
	DECLARE Rep_Excel			INT(11);		-- Tipo de reporte en formato excel

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';
	SET Con_NO					:= 'N';
	SET Con_SI					:= 'S';
	SET Fecha_Vacia	 			:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Entero_Cien				:= 100;
	SET Entero_Mil				:= 1000;
	SET Var_Sentencia			:= '';
	SET Con_Todos				:= 'Todos';
	SET Est_Pagado				:= 'P';
	SET Tipo_Renovacion			:= 'O';
	SET Tipo_Nuevo				:= 'N';
	SET Tipo_Promotor			:= 'P';
	SET Tipo_Coordinador		:= 'C';
	SET Caja_Publico			:= 'CA';
	SET Caja_Principal			:= 'CP';
	SET GastosComprobar			:= 122;
	SET Entero_Dos				:= 2;
	SET Est_Vigente				:= 'V';
	SET Est_Vencido				:= 'B';
	SET Est_Atrasado			:= 'A';
	SET Est_Cancelado			:= 'C';

	-- ASIGNACION DE TIPOS DE REPORTES
	SET Rep_Excel				:= 1;

	-- VALIDACION DE DATOS NULOS
	SET Par_FechaInicio			:= IFNULL(Par_FechaInicio, Fecha_Vacia);
	SET Par_FechaFin			:= IFNULL(Par_FechaFin, Fecha_Vacia);
	SET Par_SucursalID			:= IFNULL(Par_SucursalID, Entero_Cero);
	SET Par_CoodinadorID		:= IFNULL(Par_CoodinadorID, Entero_Cero);
	SET Par_PromotorID			:= IFNULL(Par_PromotorID, Entero_Cero);
	SET Var_Dependencia			:= IFNULL(Var_Dependencia, Entero_Cero);
	SET Aud_FechaActual			:= NOW();

	-- 1.- REPORTE EN FORMATO EXCEL
	IF(Par_TipoReporte = Rep_Excel)THEN
		-- SE GENERA UN NUMERO DE TRANSACION PARA EL REPORTE
		CALL TRANSACCIONESPRO(Aud_NumTransaccion);

		-- Si se indica un coordinador el filtro Sucursal no tendra efecto.
		IF(Par_CoodinadorID > Entero_Cero)THEN
			SET Par_SucursalID := Entero_Cero;
		END IF;

		-- SE OBTIENE LA BANDERA SI RESTRINGE O NO EL REPORTE
		SELECT	RestringeReporte,	FechaSistema
		INTO	Var_ResReporte,		Var_FechaSistema
		FROM PARAMETROSSIS LIMIT 1;

		SET Var_ResReporte	:= IFNULL(Var_ResReporte,Con_NO);

		-- TABLA TEMPORAL PARA LAS FECHAS DE ACCESO
		DROP TEMPORARY TABLE IF EXISTS TMPFECHAACCESOPROM;
		CREATE TEMPORARY TABLE TMPFECHAACCESOPROM(
			PromotorID		INT(11),
			FechaInicio		DATETIME,
			FechaFin		DATETIME,
			PRIMARY KEY(PromotorID)
		);

		-- TABLA TEMPORAL PARA LOS SALDOS DE CARTERA ESPERADO
		DROP TEMPORARY TABLE IF EXISTS TMPSALDOSCARTERAPROM;
		CREATE TEMPORARY TABLE TMPSALDOSCARTERAPROM(
			PromotorID				INT(11),
			TotalClientes			INT(11),
			SaldoEsperadoCartera	DECIMAL(16,2),
			CreditoID				BIGINT(12),
			PRIMARY KEY(PromotorID),
			KEY INDEX_1(CreditoID)
		);

		-- CREDITOS NUEVOS
		DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSNUEVOSPROM;
		CREATE TEMPORARY TABLE TMPCREDITOSNUEVOSPROM(
			PromotorID				INT(11),
			TipoCredito				CHAR(1),
			TotalCreNuevos			INT(11),
			TotalCreRenovacion		INT(11),
			PRIMARY KEY(PromotorID)
		);

		-- CREDITOS RENOVADOS
		DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSRENPROM;
		CREATE TEMPORARY TABLE TMPCREDITOSRENPROM(
			PromotorID				INT(11),
			TipoCredito				CHAR(1),
			TotalCreNuevos			INT(11),
			TotalCreRenovacion		INT(11),
			PRIMARY KEY(PromotorID)
		);

		-- TABLA TEMPORAL PARA ALMACENAR LOS SALDOS
		DROP TEMPORARY TABLE IF EXISTS TMPSALDOSPAGADOSPROM;
		CREATE TEMPORARY TABLE TMPSALDOSPAGADOSPROM(
			PromotorID				INT(11),
			TotalCtesPagos			INT(11),
			SaldoCartera			DECIMAL(16,2),
			PRIMARY KEY(PromotorID)
		);

		-- TABLA TEMPORAL PARA OBTENER EL TOTAL DE CLIENTES Y MONTOS QUE REALIZARON PREPAGOS
		DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSPREPAGOSPROM;
		CREATE TEMPORARY TABLE TMPCREDITOSPREPAGOSPROM(
			PromotorID				INT(11),
			TotalCtesPrepagos		INT(11),
			SaldoRecaudoPrepago		DECIMAL(16,2),
			PRIMARY KEY(PromotorID)
		);

		-- TABLA TEMPORAL PARA EL SALDO INICIAL DE LA CAJA
		DROP TEMPORARY TABLE IF EXISTS TMPSALDOCAJASPROM;
		CREATE TEMPORARY TABLE TMPSALDOCAJASPROM(
			PromotorID				INT(11),
			CajaID					INT(11),
			TipoCaja				CHAR(2),
			SaldoInicialCaja		DECIMAL(16,2),
			PRIMARY KEY(PromotorID)
		);

		-- TABLA TEMPORAL PARA EL SALDO DE LOS SALDO AL DIA
		DROP TEMPORARY TABLE IF EXISTS TMPGASTOSPROMOTORES;
		CREATE TEMPORARY TABLE TMPGASTOSPROMOTORES(
			PromotorID				INT(11),
			SaldoGastosDia			DECIMAL(16,2),
			PRIMARY KEY(PromotorID)
		);

		-- TABLA TEMPORAL PARA EL SALDO DE LOS CREDITOS OTORGADOS AL DIA
		DROP TEMPORARY TABLE IF EXISTS TMPTOTALCREDITOS;
		CREATE TEMPORARY TABLE TMPTOTALCREDITOS(
			PromotorID				INT(11),
			SaldoTotalCreditos		DECIMAL(16,2),
			PRIMARY KEY(PromotorID)
		);

		-- TABLA PARA ALMACENAR LOS CLIENTES CON CREDITOS MINISTRADO
		DROP TEMPORARY TABLE IF EXISTS TMPPERIODOMINISTRADO;
		CREATE TEMPORARY TABLE TMPPERIODOMINISTRADO(
			ClienteID 			INT(11),
			NumCreAnteriores	INT(11),
			NumCrePeriodo		INT(11),
		PRIMARY KEY(ClienteID)
		);

		-- TABLA AUXILIAR PARA LOS CLIENTES MINISTRADO
		DROP TEMPORARY TABLE IF EXISTS TMPAUXILIARPERIODO;
		CREATE TEMPORARY TABLE TMPAUXILIARPERIODO(
			ClienteID 			INT(11),
			NumCreAnteriores	INT(11),
		PRIMARY KEY(ClienteID)
		);

		-- TABLA PARA ALMACENAR LA TRANSACCION MINIMA DE LAS CAJAS
		DROP TEMPORARY TABLE IF EXISTS TMP_MINIMOOPERACIONCAJA;
		CREATE TEMPORARY TABLE TMP_MINIMOOPERACIONCAJA(
			Transaccion 		BIGINT(20),
			PromotorID			INT(11),
			CajaID				INT(11),
			Consecutivo			INT(11),
		PRIMARY KEY(Transaccion),
		KEY INDEX_1(CajaID)
		);

		-- TABLA PARA GUARDAR LOS CREDITOS QUE SE PAGARON ANTES DE LA FECHA DE INICIO
		DROP TEMPORARY TABLE IF EXISTS TMPCREDPAGOSANTICIPADO;
		CREATE TEMPORARY TABLE TMPCREDPAGOSANTICIPADO(
			SaldoAnticipado		DECIMAL(16,2),
			CreditoID			BIGINT(12),
			PromotorID			INT(11),
			PRIMARY KEY(CreditoID),
			KEY INDEX_1(PromotorID)
		);

		-- TABLA TEMPORAL PARA ALMACENAR LOS SALDOS
		DROP TEMPORARY TABLE IF EXISTS TMPSALDORECAUDOVENT;
		CREATE TEMPORARY TABLE TMPSALDORECAUDOVENT(
			PromotorID				INT(11),
			TotalCtesPagos			INT(11),
			SaldoRecaudo			DECIMAL(16,2),
			PRIMARY KEY(PromotorID)
		);

		-- TABLA TEMPORAL PARA LOS CREDITOS EXIGIBLES
		DROP TEMPORARY TABLE IF EXISTS TMPSALDOSEXIGIBLE;
		CREATE TEMPORARY TABLE TMPSALDOSEXIGIBLE(
			PromotorID				INT(11),
			TotalClientes			INT(11),
			SaldoEsperadoCartera	DECIMAL(16,2),
			CreditoID				BIGINT(12),
			AmortizacionID			INT(11),
			PRIMARY KEY(CreditoID, AmortizacionID)
		);

		-- TABLA TEMPORAL PARA LOS CREDITOS EXIGIBLES
		DROP TEMPORARY TABLE IF EXISTS TMPSALDOEXIGIBLEREAL;
		CREATE TEMPORARY TABLE TMPSALDOEXIGIBLEREAL(
			PromotorID				INT(11),
			TotalClientes			INT(11),
			SaldoEsperadoCartera	DECIMAL(16,2),
			CreditoID				BIGINT(12),
			AmortizacionID			INT(11),
			KEY INDEX_1(CreditoID, AmortizacionID)
		);

		-- Variable para el pk
		SET @Var_Registro := Entero_Cero;
		SET @Var_Registro := (SELECT IFNULL(MAX(RegistroID),Entero_Cero) FROM TMPOPERACIONBASICA);
		SET @Var_Registro := IFNULL(@Var_Registro,Entero_Cero);
		-- SETENCIA DINAMICA
		SET Var_Sentencia := ('INSERT INTO TMPOPERACIONBASICA( ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	RegistroID,				PromotorID,				NombrePromotor,			FechaInicio,			FechaFin, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	TotalClientes,			TotalCtesNuevos,		TotalCtesRenovacion,	TotalCtesCorte,			TotalCtesPagos, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	TotalCtesNoPagos,		TotalCtesPrepagos,		SaldoInicialCaja,		SaldoEsperadoCartera,	SaldoCartera, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	SaldoRecaudoPrepago,	PorcentajeRecaudo,		PorcentajePretendido,	SaldoTotalCreditos,		SaldoGastosDia, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	CreditoID,				TipoUsuario,			TotalCteCreditos,		NumTransaccion,			EmpresaID, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal ) ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'SELECT ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	(@Var_Registro := @Var_Registro + 1), ');
		SET Var_Sentencia := CONCAT(Var_Sentencia ,'	CASE WHEN (Prom.PromotorID > ',Entero_Cero,') ');
		SET Var_Sentencia := CONCAT(Var_Sentencia ,'			THEN Prom.PromotorID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia ,'		ELSE "',Entero_Cero,'" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia ,'	END AS PromotorID, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia ,'	CASE WHEN (Prom.PromotorID > ',Entero_Cero,') ');
		SET Var_Sentencia := CONCAT(Var_Sentencia ,'			THEN MAX(Prom.NombrePromotor) ');
		SET Var_Sentencia := CONCAT(Var_Sentencia ,'		ELSE "',Con_Todos,'" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia ,'	END AS NombrePromotor, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia ,'	"',Par_FechaInicio,'", "',Par_FechaFin,'", 		',Entero_Cero,' AS TotalClientes, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	',Entero_Cero,',	',	Entero_Cero,',			',Entero_Cero,',		',Entero_Cero,',		',Entero_Cero,', ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	',Entero_Cero,',	',	Entero_Cero,',			',Entero_Cero,',		',Entero_Cero,',		',Entero_Cero,', ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	',Entero_Cero,',	',	Entero_Cero,',			',Entero_Cero,',		',Entero_Cero,',		IFNULL(MAX(Cre.CreditoID),0), ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	"',Tipo_Promotor,'",',	Entero_Cero,',			',Aud_NumTransaccion,',	',Par_EmpresaID,', ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, '	',Aud_Usuario,',	"',	Aud_FechaActual,'",		"',Aud_DireccionIP,'",	"',Aud_ProgramaID,'",	',Aud_Sucursal,' ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'FROM PROMOTORES Prom ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN USUARIOS Users ON Prom.UsuarioID = Users.UsuarioID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'LEFT OUTER JOIN SOLICITUDCREDITO Sol ON Prom.PromotorID = Sol.PromotorID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'LEFT OUTER JOIN CREDITOS Cre ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID ');

		-- Se obtiene los usuarios dependientes del promotor
		SET Var_Dependencia := (SELECT FNDEPBASICOUNIDAD(Aud_Usuario));

		-- Validacion cuando la bandera de restrincion reporte esta activo y es un usuario coordinador
		IF(Var_ResReporte = Con_SI )THEN
			IF(Aud_Usuario = Par_CoodinadorID OR Aud_Usuario = Par_PromotorID)THEN
				-- SI ES UN PROMOTOR EL QUE GENERA EL REPORTE Y NO SE TIENE NINGUNA DEPENDENCIA
				IF(FIND_IN_SET(Entero_Cero,Var_Dependencia) > Entero_Cero AND Par_PromotorID > Entero_Cero)THEN
					SET Var_Dependencia := Par_PromotorID;
				END IF;
			END IF;

			SET Var_Sentencia := CONCAT(Var_Sentencia,'WHERE Prom.PromotorID IN (',Var_Dependencia,') ');
		END IF;
		-- Cuando no se tiene restriccion
		IF(Var_ResReporte = Con_NO )THEN
			-- Cuando el promotor sea mayor a cero
			IF(Par_PromotorID > Entero_Cero)THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,'WHERE Prom.PromotorID IN (',Par_PromotorID,') ');
			END IF;
			-- Cuando el coordinador sea mayor a cero
			IF(Par_CoodinadorID > Entero_Cero)THEN
				-- Se condiciona la setencia dinamica
				SET Var_Sentencia := IF(Par_PromotorID > Entero_Cero,
											CONCAT(Var_Sentencia,'AND Prom.UsuarioID IN (',Par_CoodinadorID,') '),
												CONCAT(Var_Sentencia,'WHERE Prom.UsuarioID IN (',Par_CoodinadorID,') ')
										);
			END IF;
		END IF;

		-- VALIDACION PARA EL ID DE LA SUCURSAL
		IF(Par_SucursalID <> Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'	AND Prom.SucursalID = ', Par_SucursalID,' ');
		END IF;

		-- SE REALIZA EL AGRUPAMIENTO POR PROMOTOR
		SET Var_Sentencia := CONCAT(Var_Sentencia,'	GROUP BY Prom.PromotorID ');

		-- SE EJECUTA LA SENTENCIA DINAMICA
		SET @SentenciaOperacion	= (Var_Sentencia);
		PREPARE OPERACIONREP FROM @SentenciaOperacion;
		EXECUTE OPERACIONREP;
		DEALLOCATE PREPARE OPERACIONREP;

		-- SE OBTIENE LA FECHA DE INICIO Y FECHA FIN
		INSERT INTO TMPFECHAACCESOPROM
		SELECT	Tmp.PromotorID,
				CONCAT(MIN(Fecha),' ',MIN(Hora)),		CONCAT(MAX(Fecha),' ',MAX(Hora))
		FROM BITACORAACCESO Bita
		INNER JOIN USUARIOS Users ON Bita.UsuarioID = Users.UsuarioID
		INNER JOIN PROMOTORES Prom ON Users.UsuarioID = Prom.UsuarioID
		INNER JOIN TMPOPERACIONBASICA Tmp ON Prom.PromotorID = Tmp.PromotorID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Bita.Fecha >= Par_FechaInicio
			AND Bita.Fecha <= Par_FechaFin
		GROUP BY Tmp.PromotorID;

		-- SE OBTIENE CREDITOS POR PROMOTOR Y EL MONTO TOTAL DEL PROMOTOR
		INSERT INTO TMPSALDOSCARTERAPROM
		SELECT	Tmp.PromotorID,		COUNT(DISTINCT(Amo.ClienteID)),
				SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres + Amo.MontoOtrasComisiones + Amo.MontoIVAOtrasComisiones),
				MAX(Cre.CreditoID)
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN AMORTICREDITO Amo ON Cre.CreditoID = Amo.CreditoID
		INNER JOIN TMPOPERACIONBASICA Tmp ON Sol.PromotorID = Tmp.PromotorID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Amo.FechaExigible <= Par_FechaInicio
			AND (Amo.FechaLiquida >= Par_FechaInicio OR Amo.FechaLiquida = Fecha_Vacia)
		GROUP BY Tmp.PromotorID;

		-- SE OBTIENE CREDITOS Y SUS AMORTIZACIONES QUE ENTRAN EN EL RANGO DE CREDITOS EXIGIBLES
		INSERT INTO TMPSALDOSEXIGIBLE
		SELECT	Entero_Cero,		Entero_Cero,
				SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres + Amo.MontoOtrasComisiones + Amo.MontoIVAOtrasComisiones),
				Cre.CreditoID,		Amo.AmortizacionID
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN TMPOPERACIONBASICA Tmp ON Sol.PromotorID = Tmp.PromotorID
		INNER JOIN AMORTICREDITO Amo ON Cre.CreditoID = Amo.CreditoID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Amo.FechaExigible <= Par_FechaInicio
			AND (Amo.FechaLiquida >= Par_FechaInicio OR Amo.FechaLiquida = Fecha_Vacia)
			AND Amo.Estatus <> Est_Cancelado
		GROUP BY Cre.CreditoID, Amo.AmortizacionID;

		-- Se obtienen creditos que se pagaron anteriormente
		INSERT INTO TMPCREDPAGOSANTICIPADO
		SELECT	SUM(Det.MontoTotPago),
				MAX(Saldo.CreditoID),
				Tmp.PromotorID
		FROM SOLICITUDCREDITO Sol
		INNER JOIN TMPOPERACIONBASICA Tmp ON Sol.PromotorID = Tmp.PromotorID
		INNER JOIN TMPSALDOSEXIGIBLE Saldo ON Sol.CreditoID = Saldo.CreditoID
		INNER JOIN DETALLEPAGCRE Det ON Saldo.CreditoID = Det.CreditoID AND Det.AmortizacionID = Saldo.AmortizacionID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Det.FechaPago < Par_FechaFin
		GROUP BY Tmp.PromotorID;

		-- SALDO EXIGIBLE REAL RESTANDO LOS PREPAGOS
		INSERT INTO TMPSALDOEXIGIBLEREAL
		SELECT	Oper.PromotorID,			Entero_Cero,
				SUM(Tmp.SaldoEsperadoCartera),
				Entero_Cero,				Entero_Cero
		FROM TMPSALDOSEXIGIBLE Tmp
		INNER JOIN SOLICITUDCREDITO Sol ON Tmp.CreditoID = Sol.CreditoID
		INNER JOIN TMPOPERACIONBASICA Oper ON Sol.PromotorID = Oper.PromotorID
		WHERE Oper.NumTransaccion = Aud_NumTransaccion
		GROUP BY Oper.PromotorID;

		-- Se actualiza el saldo esperado de cartera-el saldo de prepago
		UPDATE TMPSALDOSCARTERAPROM Saldo
		INNER JOIN TMPCREDPAGOSANTICIPADO Ant ON Saldo.PromotorID = Ant.PromotorID
		INNER JOIN TMPSALDOEXIGIBLEREAL Ex ON Ant.PromotorID = Ex.PromotorID
			SET Saldo.SaldoEsperadoCartera = (Ex.SaldoEsperadoCartera - Ant.SaldoAnticipado);

		-- Se obtiene todos los creditos ministrado
		INSERT INTO TMPPERIODOMINISTRADO
		SELECT Cre.ClienteID,	Entero_Cero,	COUNT(DISTINCT(Cre.ClienteID))
		FROM CREDITOS Cre
		WHERE Cre.FechaMinistrado
		BETWEEN Par_FechaInicio AND Par_FechaFin
		GROUP BY Cre.ClienteID;

		INSERT INTO TMPAUXILIARPERIODO
		SELECT Cre.ClienteID,	COUNT(DISTINCT(Cre.ClienteID))
		FROM CREDITOS Cre
		WHERE Cre.FechaMinistrado < Par_FechaInicio
		GROUP BY Cre.ClienteID;

		-- SE VACIAN LOS REGISTROS
		UPDATE TMPPERIODOMINISTRADO Per
		INNER JOIN TMPAUXILIARPERIODO Aux ON Per.ClienteID = Aux.ClienteID
			SET Per.NumCreAnteriores = Aux.NumCreAnteriores;

		-- SE OBTIENE CREDITOS RENOVADOS
		INSERT INTO TMPCREDITOSRENPROM
		SELECT	Tmp.PromotorID,	Tipo_Renovacion,	Entero_Cero,
				COUNT(DISTINCT(Per.ClienteID))
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN TMPOPERACIONBASICA Tmp ON Sol.PromotorID = Tmp.PromotorID
		INNER JOIN TMPPERIODOMINISTRADO Per ON Sol.ClienteID = Per.ClienteID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Per.NumCreAnteriores > Entero_Cero
		GROUP BY Tmp.PromotorID;

		-- SE OBTIENE CREDITOS NUEVOS
		INSERT INTO TMPCREDITOSNUEVOSPROM
		SELECT	Tmp.PromotorID,	Tipo_Nuevo,		COUNT(DISTINCT(Per.ClienteID)),
				Entero_Cero
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN TMPOPERACIONBASICA Tmp ON Sol.PromotorID = Tmp.PromotorID
		INNER JOIN TMPPERIODOMINISTRADO Per ON Sol.ClienteID = Per.ClienteID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Per.NumCreAnteriores = Entero_Cero
		GROUP BY Tmp.PromotorID;

		-- SE OBTIENE EL TOTAL DE CLIENTES QUE REALIZARON SU PAGO Y EL MONTO DEL PAGO
		INSERT INTO TMPSALDOSPAGADOSPROM
		SELECT	Tmp.PromotorID,
				COUNT(DISTINCT(Cre.ClienteID)),	Entero_Cero
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN AMORTICREDITO Amo ON Cre.CreditoID = Amo.CreditoID
		INNER JOIN DETALLEPAGCRE Det ON Cre.CreditoID = Det.CreditoID AND Det.AmortizacionID = Amo.AmortizacionID
		INNER JOIN TMPOPERACIONBASICA Tmp ON Sol.PromotorID = Tmp.PromotorID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Amo.Estatus = Est_Pagado
			AND Amo.FechaLiquida >= Par_FechaInicio
			AND Amo.FechaLiquida <= Par_FechaFin
			AND Amo.FechaLiquida >= Amo.FechaExigible
		GROUP BY Tmp.PromotorID;

		-- CLIENTES Y CREDITOS QUE REALIZARON PREPAGOS
		INSERT INTO TMPCREDITOSPREPAGOSPROM
		SELECT	Tmp.PromotorID,
				COUNT(DISTINCT(Cre.ClienteID)),
				SUM(Det.MontoTotPago)
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN TMPOPERACIONBASICA Tmp ON Sol.PromotorID = Tmp.PromotorID
		INNER JOIN AMORTICREDITO Amo ON Cre.CreditoID = Amo.CreditoID
		INNER JOIN DETALLEPAGCRE Det ON Cre.CreditoID = Det.CreditoID AND Det.AmortizacionID = Amo.AmortizacionID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND (Det.FechaPago >= Par_FechaInicio AND Det.FechaPago <= Par_FechaFin)
			AND	Det.FechaPago < Amo.FechaExigible
		GROUP BY Tmp.PromotorID;

		-- Cuando la fecha de inicio es igual a la del sistema
		-- Los saldos se obtienen en la tabla actuales
		IF(Par_FechaInicio = Var_FechaSistema)THEN
			-- Cuando el promotor esta relacionado de atencion publico
			INSERT INTO TMP_MINIMOOPERACIONCAJA
			SELECT	MIN(Movs.Transaccion),
					Tmp.PromotorID,
					MAX(Cajas.CajaID),
					MAX(Movs.Consecutivo)
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN PROMOTORES Prom ON Tmp.PromotorID = Prom.PromotorID
			INNER JOIN USUARIOS Users ON Prom.UsuarioID = Users.UsuarioID
			INNER JOIN CAJASVENTANILLA Cajas ON Users.UsuarioID = Cajas.UsuarioID
			INNER JOIN CAJASMOVS Movs ON Cajas.CajaID = Movs.CajaID
			INNER JOIN CAJATIPOSOPERA Tipo ON Movs.TipoOperacion = Tipo.Numero
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
				AND Movs.Fecha = Par_FechaInicio
				AND Cajas.TipoCaja = Caja_Publico
				AND Tipo.Naturaleza = Entero_Dos -- El dos cuando es entrada de efectivo
				AND Tipo.EsEfectivo = Con_NO -- Se cuenta cuando no es por efectivo
				AND Movs.TipoOperacion = 39
			GROUP BY Tmp.PromotorID;

			-- CUANDO ES UNA CAJA PRINCIPAL
			INSERT INTO TMPSALDOCAJASPROM
			SELECT	Tmp.PromotorID,
					MAX(Cajas.CajaID),
					Caja_Principal,
					MIN(Cajas.SaldoEfecMN)
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN PROMOTORES Prom ON Tmp.PromotorID = Prom.PromotorID
			INNER JOIN USUARIOS Users ON Prom.UsuarioID = Users.UsuarioID
			INNER JOIN CAJASVENTANILLA Cajas ON Users.UsuarioID = Cajas.UsuarioID
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
				AND Cajas.TipoCaja = Caja_Principal
			GROUP BY Tmp.PromotorID;

			-- SE REALIZA EL INSERT DEL SALDO DE LA PRIMERA TRANSFERENCIA RECIBIDA
			INSERT INTO TMPSALDOCAJASPROM
			SELECT	Tmp.PromotorID,
					MAX(TmpCaja.CajaID),
					Cadena_Vacia,
					SUM(MontoEnFirme)
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN PROMOTORES Prom ON Tmp.PromotorID = Prom.PromotorID
			INNER JOIN TMP_MINIMOOPERACIONCAJA TmpCaja ON Tmp.PromotorID = TmpCaja.PromotorID
			INNER JOIN CAJASMOVS Movs ON TmpCaja.Transaccion = Movs.Transaccion AND TmpCaja.Consecutivo = Movs.Consecutivo
			GROUP BY Tmp.PromotorID;

			-- TOTAL DE SALDO ENTRADO POR VENTANILLA DE UN PAGO DE CREDITO CONSIDERANDO ACCESORIOS
			INSERT INTO TMPSALDORECAUDOVENT
			SELECT	Tmp.PromotorID,
					Entero_Cero,
					SUM(Movs.MontoEnFirme)
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN PROMOTORES Prom ON Tmp.PromotorID = Prom.PromotorID
			INNER JOIN USUARIOS Users ON Prom.UsuarioID = Users.UsuarioID
			INNER JOIN CAJASVENTANILLA Cajas ON Users.UsuarioID = Cajas.UsuarioID
			INNER JOIN CAJASMOVS Movs ON Cajas.CajaID = Movs.CajaID
			INNER JOIN CAJATIPOSOPERA Tipo ON Movs.TipoOperacion = Tipo.Numero
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
				AND Movs.Fecha = Par_FechaInicio
				AND Movs.TipoOperacion IN(28,134) -- PAGO DE CREDITO Y COBRO DE ACCESORIOS
			GROUP BY Tmp.PromotorID;
		END IF;

		-- CUANDO FECHA DE INICIO ES MENOR A LA DEL SISTEMA LOS SALDOS SE OBTIENEN EN LA HISTORICA
		IF(Par_FechaInicio < Var_FechaSistema)THEN
			-- CAJA DE ATENCION PUBLICO
			INSERT INTO TMP_MINIMOOPERACIONCAJA
			SELECT	MIN(Movs.Transaccion),
					Tmp.PromotorID,
					MAX(Cajas.CajaID),
					MAX(Movs.Consecutivo)
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN PROMOTORES Prom ON Tmp.PromotorID = Prom.PromotorID
			INNER JOIN USUARIOS Users ON Prom.UsuarioID = Users.UsuarioID
			INNER JOIN CAJASVENTANILLA Cajas ON Users.UsuarioID = Cajas.UsuarioID
			INNER JOIN `HIS-CAJASMOVS` Movs ON Cajas.CajaID = Movs.CajaID
			INNER JOIN CAJATIPOSOPERA Tipo ON Movs.TipoOperacion = Tipo.Numero
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
				AND Movs.FechaCorte = Par_FechaInicio
				AND Cajas.TipoCaja = Caja_Publico
				AND Tipo.Naturaleza = Entero_Dos -- El Uno cuando es entrada de efectivo
				AND Tipo.EsEfectivo = Con_NO -- Se cuenta cuando es por efectivo
				AND Movs.TipoOperacion = 39
			GROUP BY Tmp.PromotorID;

			-- CAJA PRINCIPAL
			INSERT INTO TMPSALDOCAJASPROM
			SELECT	Tmp.PromotorID,
					MAX(Cajas.CajaID),
					Caja_Principal,
					SUM(Movs.MontoEnFirme)
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN PROMOTORES Prom ON Tmp.PromotorID = Prom.PromotorID
			INNER JOIN USUARIOS Users ON Prom.UsuarioID = Users.UsuarioID
			INNER JOIN CAJASVENTANILLA Cajas ON Users.UsuarioID = Cajas.UsuarioID
			INNER JOIN `HIS-CAJASMOVS` Movs ON Cajas.CajaID = Movs.CajaID
			INNER JOIN CAJATIPOSOPERA Tipo ON Movs.TipoOperacion = Tipo.Numero
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
				AND Movs.FechaCorte = Par_FechaInicio
				AND Cajas.TipoCaja = Caja_Principal
				AND Tipo.Naturaleza = Entero_Dos -- El Uno cuando es entrada de efectivo
				AND Tipo.EsEfectivo = Con_SI -- Se cuenta cuando es por efectivo
			GROUP BY Tmp.PromotorID;

			-- SE REALIZA EL INSERT DEL SALDO DE LA PRIMERA TRANSFERENCIA RECIBIDA
			INSERT INTO TMPSALDOCAJASPROM
			SELECT	Tmp.PromotorID,
					MAX(TmpCaja.CajaID),
					Cadena_Vacia,
					SUM(MontoEnFirme)
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN PROMOTORES Prom ON Tmp.PromotorID = Prom.PromotorID
			INNER JOIN TMP_MINIMOOPERACIONCAJA TmpCaja ON Tmp.PromotorID = TmpCaja.PromotorID
			INNER JOIN `HIS-CAJASMOVS` Movs ON TmpCaja.Transaccion = Movs.Transaccion AND TmpCaja.Consecutivo = Movs.Consecutivo
			GROUP BY Tmp.PromotorID;

			-- TOTAL DE SALDO ENTRADO POR VENTANILLA DE UN PAGO DE CREDITO CONSIDERANDO ACCESORIOS
			INSERT INTO TMPSALDORECAUDOVENT
			SELECT	Tmp.PromotorID,
					Entero_Cero,
					SUM(Movs.MontoEnFirme)
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN PROMOTORES Prom ON Tmp.PromotorID = Prom.PromotorID
			INNER JOIN CAJASVENTANILLA Cajas ON Prom.UsuarioID = Cajas.UsuarioID
			INNER JOIN `HIS-CAJASMOVS` Movs ON Cajas.CajaID = Movs.CajaID
			INNER JOIN CAJATIPOSOPERA Tipo ON Movs.TipoOperacion = Tipo.Numero
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
				AND Movs.Fecha = Par_FechaInicio
				AND Movs.TipoOperacion IN(28,134) -- PAGO DE CREDITO Y COBRO DE ACCESORIOS
			GROUP BY Tmp.PromotorID;
		END IF;

		-- Se actualiza el monto entrado por ventanilla por pagos de creditos y cobro de accesorios
		UPDATE TMPSALDOSPAGADOSPROM Tmp
		INNER JOIN TMPSALDORECAUDOVENT Vent ON Tmp.PromotorID = Vent.PromotorID
			SET Tmp.SaldoCartera = Vent.SaldoRecaudo;


		-- GASTOS DE CADA PROMOTOR CUANDO ES AL dia
		INSERT INTO TMPGASTOSPROMOTORES
		SELECT	Tmp.PromotorID,
				SUM(MontoOpe)
		FROM TMPOPERACIONBASICA Tmp
		INNER JOIN PROMOTORES Prom ON Tmp.PromotorID = Prom.PromotorID
		INNER JOIN USUARIOS Users ON Prom.UsuarioID = Users.UsuarioID
		INNER JOIN MOVSANTGASTOS Mov ON Users.EmpleadoID = Mov.EmpleadoID
		WHERE Mov.Fecha = Par_FechaInicio
			AND Tmp.NumTransaccion = Aud_NumTransaccion
		GROUP BY Tmp.PromotorID;

		-- SALDO TOTAL DE CREDITOS OTORGADOS AL DIA
		INSERT INTO TMPTOTALCREDITOS
		SELECT	Tmp.PromotorID,
				SUM(MontoCredito)
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
		INNER JOIN TMPOPERACIONBASICA Tmp ON Sol.PromotorID = Tmp.PromotorID
		WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			AND Cre.FechaInicio >= Par_FechaInicio
			AND Cre.FechaInicio <= Par_FechaFin
		GROUP BY Tmp.PromotorID;

		-- SE REALIZA EL UPDATE A LA TEMPORAL
		UPDATE TMPOPERACIONBASICA TmpOper
		INNER JOIN TMPFECHAACCESOPROM TmpFecha ON TmpOper.PromotorID = TmpFecha.PromotorID
			SET
				TmpOper.FechaInicio		= TmpFecha.FechaInicio,
				TmpOper.FechaFin		= TmpFecha.FechaFin
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- SE REALIZA EL UPDATE A LA TEMPORAL
		UPDATE TMPOPERACIONBASICA TmpOper
		INNER JOIN TMPSALDOSCARTERAPROM TmpSal ON TmpOper.PromotorID = TmpSal.PromotorID
			SET
				TmpOper.TotalClientes			= TmpSal.TotalClientes,
				TmpOper.SaldoEsperadoCartera	= TmpSal.SaldoEsperadoCartera
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- SE REALIZA EL UPDATE A LA TEMPORAL CON CREDITOS NUEVOS
		UPDATE TMPOPERACIONBASICA TmpOper
		INNER JOIN TMPCREDITOSNUEVOSPROM TmpCre ON TmpOper.PromotorID = TmpCre.PromotorID
			SET
				TmpOper.TotalCtesNuevos			= TmpCre.TotalCreNuevos
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- SE REALIZA EL UPDATE A LA TEMPORAL CON CREDITOS RENOVADOS
		UPDATE TMPOPERACIONBASICA TmpOper
		INNER JOIN TMPCREDITOSRENPROM TmpCre ON TmpOper.PromotorID = TmpCre.PromotorID
			SET
				TmpOper.TotalCtesRenovacion		= TmpCre.TotalCreRenovacion
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- SE REALIZA EL UPDATE A LA TEMPORAL
		UPDATE TMPOPERACIONBASICA TmpOper
		INNER JOIN TMPSALDOSPAGADOSPROM TmpSaldo ON TmpOper.PromotorID = TmpSaldo.PromotorID
			SET
				TmpOper.TotalCtesPagos			= TmpSaldo.TotalCtesPagos,
				TmpOper.SaldoCartera			= TmpSaldo.SaldoCartera
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- SE REALIZA EL UPDATE A LA TEMPORAL
		UPDATE TMPOPERACIONBASICA TmpOper
		INNER JOIN TMPCREDITOSPREPAGOSPROM TmpPreg ON TmpOper.PromotorID = TmpPreg.PromotorID
			SET
				TmpOper.TotalCtesPrepagos	= TmpPreg.TotalCtesPrepagos,
				TmpOper.SaldoRecaudoPrepago	= TmpPreg.SaldoRecaudoPrepago
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- SE REALIZA UPDATE PARA RESTARLE EL SALDO RECAUDO MENOS EL SALDO DE CUOTAS EXTRAS
		UPDATE TMPOPERACIONBASICA TmpOper
			SET
				TmpOper.SaldoCartera = (TmpOper.SaldoCartera - TmpOper.SaldoRecaudoPrepago)
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- SE REALIZA EL UPATE A LA TABLA PIVOTE CON LOS SALDOS DE LA CAJA
		UPDATE TMPOPERACIONBASICA TmpOper
		INNER JOIN TMPSALDOCAJASPROM TmpCaja ON TmpOper.PromotorID = TmpCaja.PromotorID
			SET
				TmpOper.SaldoInicialCaja = TmpCaja.SaldoInicialCaja
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- ACTUALIZACION DE LOS GATOS POR PROMOTORES
		UPDATE TMPOPERACIONBASICA TmpOper
		INNER JOIN TMPGASTOSPROMOTORES TmpGat ON TmpOper.PromotorID = TmpGat.PromotorID
			SET
				TmpOper.SaldoGastosDia = TmpGat.SaldoGastosDia
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- SE ACTUALIZA EL SALDO DE LOS CREDITOS OTORGADOS
		UPDATE TMPOPERACIONBASICA TmpOper
		INNER JOIN TMPTOTALCREDITOS TmpSal ON TmpOper.PromotorID = TmpSal.PromotorID
			SET
				TmpOper.SaldoTotalCreditos = TmpSal.SaldoTotalCreditos
		WHERE TmpOper.NumTransaccion = Aud_NumTransaccion;

		-- SE REALIZA EL UPDATE PARA LOS PORCENTAJOS
		-- LA DIVISION SOLO SE DEBE DE HACER CUANDO EL DIVIDENDO O DIVIDOR SEA MAYOR A CERO
		UPDATE TMPOPERACIONBASICA
			SET
				PorcentajeRecaudo		= IF(SaldoEsperadoCartera > Entero_Cero, (SaldoCartera/SaldoEsperadoCartera) * Entero_Cien, Entero_Cero),
				PorcentajePretendido	= IF(TotalClientes > Entero_Cero, (TotalCtesPagos/TotalClientes ) * Entero_Cien, Entero_Cero),
				TotalCteCreditos		= (TotalCtesNuevos + TotalCtesRenovacion)
		WHERE NumTransaccion = Aud_NumTransaccion;

		-- SE DEBE DE INSERTAR UN NUEVO REGISTROS CUANDO EL COORDINADOR SEA DIFERENTE DE CERO
		IF(Par_CoodinadorID > Entero_Cero)THEN
			-- Se obtiene el consecutivo a insertar
			SET Var_Consecutivo := (SELECT IFNULL(MAX(RegistroID),Entero_Cero) + Entero_Uno FROM TMPOPERACIONBASICA);
			-- Se realiza el insert
			INSERT INTO TMPOPERACIONBASICA(
				RegistroID,				PromotorID,				NombrePromotor,			FechaInicio,			FechaFin,
				TotalClientes,			TotalCtesNuevos,		TotalCtesRenovacion,	TotalCtesCorte,			TotalCtesPagos,
				TotalCtesNoPagos,		TotalCtesPrepagos,		SaldoInicialCaja,		SaldoEsperadoCartera,	SaldoCartera,
				SaldoRecaudoPrepago,	PorcentajeRecaudo,		PorcentajePretendido,	SaldoTotalCreditos,		SaldoGastosDia,
				CreditoID,				TipoUsuario,			TotalCteCreditos,		NumTransaccion,			EmpresaID,
				Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal
			)
			SELECT
				Var_Consecutivo,			MAX(Prom.PromotorID ),		MAX(Users.NombreCompleto),	MAX(FechaInicio),			MAX(FechaFin),
				SUM(TotalClientes),			SUM(TotalCtesNuevos),		SUM(TotalCtesRenovacion),	SUM(TotalCtesCorte),		SUM(TotalCtesPagos),
				SUM(TotalCtesNoPagos),		SUM(TotalCtesPrepagos),		SUM(SaldoInicialCaja),		SUM(SaldoEsperadoCartera),	SUM(SaldoCartera),
				SUM(SaldoRecaudoPrepago),	SUM(PorcentajeRecaudo),		SUM(PorcentajePretendido),	SUM(SaldoTotalCreditos),	SUM(SaldoGastosDia),
				MAX(CreditoID),				Tipo_Coordinador,			SUM(TotalCteCreditos),		Tmp.NumTransaccion,			Par_EmpresaID,
				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN USUARIOS Users ON Users.UsuarioID = Par_CoodinadorID
			INNER JOIN PROMOTORES Prom ON Users.UsuarioID = Prom.UsuarioID
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			GROUP BY Tmp.NumTransaccion;
		ELSE
			-- CUANDO SE FILTRA TODOS LOS COORDINADORES
			-- SE MARCAN LOS COORDINADORES
			UPDATE TMPOPERACIONBASICA
				SET
					Usuario		= FNDEPENDENCIAJEFE(PromotorID)
			WHERE NumTransaccion = Aud_NumTransaccion;

			-- Se obtiene el consecutivo a insertar
			SET @Var_RegistroID := (SELECT IFNULL(MAX(RegistroID),Entero_Cero) + Entero_Uno FROM TMPOPERACIONBASICA);
			-- SE REALIZA LA INSERCCION PARA EL COORDINADOR
			INSERT INTO TMPOPERACIONBASICA(
				RegistroID,				PromotorID,				NombrePromotor,			FechaInicio,			FechaFin,
				TotalClientes,			TotalCtesNuevos,		TotalCtesRenovacion,	TotalCtesCorte,			TotalCtesPagos,
				TotalCtesNoPagos,		TotalCtesPrepagos,		SaldoInicialCaja,		SaldoEsperadoCartera,	SaldoCartera,
				SaldoRecaudoPrepago,	PorcentajeRecaudo,		PorcentajePretendido,	SaldoTotalCreditos,		SaldoGastosDia,
				CreditoID,				TipoUsuario,			TotalCteCreditos,		NumTransaccion,			EmpresaID,
				Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal
			)
			SELECT
				(@Var_RegistroID := @Var_RegistroID + 1),
				MAX(Prom.PromotorID ),		MAX(Users.NombreCompleto),	MAX(FechaInicio),			MAX(FechaFin),
				SUM(TotalClientes),			SUM(TotalCtesNuevos),		SUM(TotalCtesRenovacion),	SUM(TotalCtesCorte),		SUM(TotalCtesPagos),
				SUM(TotalCtesNoPagos),		SUM(TotalCtesPrepagos),		SUM(SaldoInicialCaja),		SUM(SaldoEsperadoCartera),	SUM(SaldoCartera),
				SUM(SaldoRecaudoPrepago),	SUM(PorcentajeRecaudo),		SUM(PorcentajePretendido),	SUM(SaldoTotalCreditos),	SUM(SaldoGastosDia),
				MAX(CreditoID),				Tipo_Coordinador,			SUM(TotalCteCreditos),		Aud_NumTransaccion,			Par_EmpresaID,
				Tmp.Usuario,				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal
			FROM TMPOPERACIONBASICA Tmp
			INNER JOIN USUARIOS Users ON Users.UsuarioID = Tmp.Usuario
			INNER JOIN PROMOTORES Prom ON Users.UsuarioID = Prom.UsuarioID
			WHERE Tmp.NumTransaccion = Aud_NumTransaccion
			GROUP BY Tmp.Usuario;
		END IF;

		-- RESULTADOS A RETORNAR
		SELECT
			NombrePromotor,
			IF(FechaInicio <= Fecha_Vacia, 'SIN LOGING', FechaInicio) AS FechaInicio,
			IF(FechaFin <= Fecha_Vacia, 'SIN LOGIN', FechaFin) AS FechaFin,
			TotalClientes,			CONCAT(TotalCtesNuevos, ' Nuevos ',' / ',TotalCtesRenovacion,' renovacion') AS TotalCtesNuevos,
			Cadena_Vacia AS TotalCtesCorte,					TotalCtesPagos,			TotalCteCreditos,		Cadena_Vacia AS TotalCtesNoPagos,
			TotalCtesPrepagos,		SaldoInicialCaja,		SaldoEsperadoCartera,	SaldoCartera,			SaldoRecaudoPrepago,
			CONCAT(PorcentajeRecaudo, '%') AS PorcentajeRecaudo,					CONCAT(PorcentajePretendido, '%') AS PorcentajePretendido,
			SaldoTotalCreditos,		SaldoGastosDia,			CreditoID,				PromotorID,				TipoUsuario
		FROM TMPOPERACIONBASICA
		WHERE
			NumTransaccion = Aud_NumTransaccion
		ORDER BY TipoUsuario ASC;

		-- SE BORRA EL REGISTRO DE LA TEMPORAL FISICA
		DELETE FROM TMPOPERACIONBASICA WHERE NumTransaccion = Aud_NumTransaccion;
	END IF;
END TerminaStore$$