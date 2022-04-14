-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAINTERECREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERAINTERECREPRO`;

DELIMITER $$
CREATE PROCEDURE `GENERAINTERECREPRO`(
	Par_Fecha               DATE,           -- Fecha de Generacion de Intereses
	-- Parametros de Auditoria
	Par_EmpresaID           INT(11),        -- Parametro de auditoria ID de la empresa
	Aud_Usuario             INT(11),        -- Parametro de auditoria ID del usuario
	Aud_FechaActual         DATETIME,       -- Parametro de auditoria Feha actual
	Aud_DireccionIP         VARCHAR(15),    -- Parametro de auditoria Direccion IP
	Aud_ProgramaID          VARCHAR(50),    -- Parametro de auditoria Programa
	Aud_Sucursal            INT(11),        -- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion      BIGINT(20)      -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_CreditoID       BIGINT(12);                     -- Variables para el Cursor
DECLARE Var_AmortizacionID  INT;
DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_FechaExigible   DATE;
DECLARE Var_EmpresaID       INT;
DECLARE Var_CreCapVig       DECIMAL(14,2);
DECLARE Var_CreCapVNE       DECIMAL(14,2);
DECLARE Var_FormulaID       INT(11);
DECLARE Var_TasaFija        DECIMAL(12,4);
DECLARE Var_MonedaID        INT(11);
DECLARE Var_Estatus         CHAR(1);
DECLARE Var_SucCliente      INT;
DECLARE Var_ProdCreID       INT;
DECLARE Var_ClasifCre       CHAR(1);
DECLARE Var_TipoCalInt      INT;
DECLARE Var_Interes         DECIMAL(14,4);
DECLARE Var_SucursalCred    INT;
DECLARE Var_SalIntNoC       DECIMAL(14,4);
DECLARE Var_SalIntPro       DECIMAL(14,4);
DECLARE Var_SalIntVen       DECIMAL(14,4);

DECLARE Var_UltimoDia       CHAR(1);
DECLARE Var_CreditoStr      VARCHAR(30);
DECLARE Var_ValorTasa       DECIMAL(12,4);
DECLARE Var_DiasCredito     DECIMAL(10,2);
DECLARE Var_Intere          DECIMAL(12,4);
DECLARE Var_FecApl          DATE;
DECLARE Var_EsHabil         CHAR(1);
DECLARE SalCapital          DECIMAL(14,2);
DECLARE Var_CapAju          DECIMAL(14,2);
DECLARE Ref_GenInt          VARCHAR(50);
DECLARE Error_Key           INT;
DECLARE Mov_AboConta        INT;
DECLARE Mov_CarConta        INT;
DECLARE Mov_CarOpera        INT;
DECLARE Var_Poliza          BIGINT;
DECLARE Par_NumErr          INT(11);
DECLARE Par_ErrMen          VARCHAR(100);
DECLARE Par_Consecutivo     BIGINT;
DECLARE Es_DiaHabil         CHAR(1);
DECLARE Var_ContadorCre     INT;
DECLARE Var_SigFecha        DATE;
DECLARE Var_SubClasifID     INT;
DECLARE Var_Refinancia      CHAR(1);        # Indica si el credito refinancia el interes
DECLARE Var_FechaFinMes     DATE;           # Indica el fin de mes de acuerdo a la fecha de inicio de la amortizacion
DECLARE Var_FechaInicioMes  DATE;           # Indica la fecha de inicio de mes de acuerdo a la fecha de fin de mes
DECLARE Var_InteresRef      DECIMAL(14,2);
DECLARE Var_CreditoMigrado  BIGINT(12);     -- Credito Migrado SAFI
DECLARE Var_ExcepAjusteIntCreMigrado CHAR(1);    -- Define si se ajusta o no el interes devengado con lo pactado en las amortizaciones de los creditos migrados , valores: S = Si, N=No
-- DIFERIMIENTO
DECLARE	Var_CreditoDifer	BIGINT(12);
DECLARE	Var_InteresTotal	BIGINT(12);
-- >>>

/* Declaracion de Constantes */
DECLARE Estatus_Vigente     CHAR(1);
DECLARE Estatus_Vencida     CHAR(1);
DECLARE Estatus_Pagada      CHAR(1);
DECLARE Cre_Vencido         CHAR(1);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12, 2);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Dec_Cien            DECIMAL(10,2);
DECLARE Pro_GenIntere       INT;
DECLARE Mov_IntPro          INT;
DECLARE Mov_IntNoConta      INT;
DECLARE Con_IntDeven        INT;
DECLARE Con_IngreInt        INT;
DECLARE Con_CueOrdInt       INT;
DECLARE Con_CorOrdInt       INT;
DECLARE Pol_Automatica      CHAR(1);
DECLARE Con_GenIntere       INT;
DECLARE Par_SalidaNO        CHAR(1);
DECLARE AltaPoliza_NO       CHAR(1);
DECLARE AltaPolCre_SI       CHAR(1);
DECLARE AltaMovCre_SI       CHAR(1);
DECLARE AltaMovCre_NO       CHAR(1);
DECLARE AltaMovAho_NO       CHAR(1);
DECLARE Int_SalInsol        INT;
DECLARE Int_SalGlobal       INT;
DECLARE For_TasaFija        INT;
DECLARE SI_UltimoDia        CHAR(1);
DECLARE NO_UltimoDia        CHAR(1);
DECLARE DiasInteres         DECIMAL(10,2);
DECLARE InterXdia           DECIMAL(12,2);
DECLARE MontoOrig           DECIMAL(12,2);
DECLARE Nuevo_Interes       DECIMAL(14,4);  -- Interes de la amortizacion a ajustar


DECLARE Si_Regulariza       CHAR(1);
DECLARE No_Regulariza       CHAR(1);
DECLARE Des_CieDia          VARCHAR(100);
DECLARE Des_ErrorGral       VARCHAR(100);
DECLARE Des_ErrorLlavDup    VARCHAR(100);
DECLARE Des_ErrorCallSP     VARCHAR(100);
DECLARE Des_ErrorValNulos   VARCHAR(100);
DECLARE Cons_SI             CHAR(1);        # Constante SI
DECLARE Cons_NO             CHAR(1);        # Constante NO
DECLARE LlaveExcepAjusteIntCreMigrado  VARCHAR(50);
DECLARE Var_LlaveParametro	VARCHAR(50);				-- Llave de parametros
DECLARE Var_ManejaConvenio	CHAR(5);					-- MANEJA CONVENIO DE NOMINA
DECLARE Var_EsProducNomina	CHAR(1);					-- Si el producto de Credito es de nomina
DECLARE Var_SI              CHAR(1);    -- SI
DECLARE Var_InteresCal		DECIMAL(14,4);
DECLARE Var_No             	CHAR(1);    -- NO
DECLARE Var_EstEnviado		CHAR(1);			-- Estatus E : Enviado
DECLARE Var_EstNoEnviado	CHAR(1);			-- Estatus N : No Enviado

DECLARE CURSORINTER CURSOR FOR
	SELECT  Cre.CreditoID,          AmortizacionID,         Amo.FechaInicio,        Amo.FechaVencim,
			Amo.FechaExigible,      Cre.EmpresaID,          Cre.SaldoCapVigent,     Cre.SaldCapVenNoExi,
			CalcInteresID,          TasaFija,               Cre.MonedaID,           Cre.Estatus,
			Cli.SucursalOrigen,     Cre.ProductoCreditoID,  Des.Clasificacion,      Cre.TipoCalInteres,
			Amo.Interes,            Des.SubClasifID,        Cre.SucursalID,         Amo.SaldoInteresPro,
			Amo.SaldoIntNoConta,    Amo.SaldoInteresVen,    Cre.Refinancia,         Cre.MontoCredito,
			Cre.InteresRefinanciar
		FROM AMORTICREDITO Amo,
			  CLIENTES Cli,
			  DESTINOSCREDITO Des,
		   CREDITOS Cre
		WHERE Amo.CreditoID         = Cre.CreditoID
		  AND Cre.ClienteID     = Cli.ClienteID
		  AND Cre.DestinoCreID   = Des.DestinoCreID
		  AND Amo.FechaInicio       <= Par_Fecha
		  AND Amo.FechaVencim       >  Par_Fecha
		  AND Amo.FechaExigible >  Par_Fecha
		AND IFNULL(Amo.NumProyInteres, Entero_Cero) = Entero_Cero
		  AND ( Amo.Estatus         =  Estatus_Vigente
		   OR   Amo.Estatus         =  Estatus_Vencida)
		  AND ( Cre.Estatus         =  Estatus_Vigente
		   OR   Cre.Estatus         =  Estatus_Vencida)
		  AND (Cre.EstatusNomina NOT IN (Var_EstEnviado, Var_EstNoEnviado));


/* Asignacion de Constantes */
SET Estatus_Vigente := 'V';                 -- Estatus Amortizacion: Vigente
SET Estatus_Vencida := 'B';                 -- Estatus Amortizacion: Vencido
SET Estatus_Pagada  := 'P';                 -- Estatus Amortizacion: Pagada
SET Cre_Vencido     := 'B';                 -- Estatus Credito: Vencido
SET Cadena_Vacia    := '';                  -- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';        -- Fecha Vacia
SET Entero_Cero     := 0;                   -- Entero en Cero
SET Decimal_Cero    := 0.00;                -- Decimal Cero
SET Nat_Cargo       := 'C';                 -- Naturaleza de Cargo
SET Nat_Abono       := 'A';                 -- Naturaleza de Abono
SET Dec_Cien        := 100.00;              -- Decimal Cien
SET Pro_GenIntere   := 201;                 -- Numero de Proceso Batch: Generacion de Interes
SET Mov_IntPro      := 14;                  -- Tipo de Movimiento de Credito: Interes Provisionado
SET Mov_IntNoConta  := 13;                  -- Tipo de Movimiento de Credito: Interes Provisionado
SET Con_IntDeven    := 19;                  -- Concepto Contable: Interes Devengado
SET Con_IngreInt    := 5;                   -- Concepto Contable: Ingreso por Intereses
SET Con_CueOrdInt   := 11;                  -- Concepto Contable: Orden Intereses
SET Con_CorOrdInt   := 12;                  -- Concepto Contable: Correlativa Intereses
SET Pol_Automatica  := 'A';                 -- Tipo de Poliza: Automatica
SET Con_GenIntere   := 51;                  -- Tipo de Proceso Contable: Generacion de Interes Ordinario
SET Par_SalidaNO    := 'N';                 -- El store no Arroja una Salida
SET AltaPoliza_NO   := 'N';                 -- Alta del Encabezado de la Poliza: NO
SET AltaPolCre_SI   := 'S';                 -- Alta de la Poliza de Credito: SI
SET AltaMovCre_NO   := 'N';                 -- Alta del Movimiento de Credito: NO
SET AltaMovCre_SI   := 'S';                 -- Alta del Movimiento de Credito: SI
SET AltaMovAho_NO   := 'N';                 -- Alta del Movimiento de Ahorro: NO
SET Int_SalInsol    := 1;               -- Calculo de Interes Sobre Saldos Insolutos
SET Int_SalGlobal   := 2;               -- Calculo de Interes Sobre Saldos Globales
SET For_TasaFija    := 1;               -- Formula de Calculo de Interes: Tasa Fija
SET SI_UltimoDia    := 'S';             -- Ultimo Dia del calculo de Interes: SI
SET NO_UltimoDia    := 'N';             -- Ultimo Dia del calculo de Interes: NO
SET DiasInteres     := 1;               -- Dias para el Calculo de Interes: Un Dia
SET Cons_SI         := 'S';             -- Constante: SI
SET Cons_NO         := 'N';             -- Constante: NO
SET LlaveExcepAjusteIntCreMigrado := 'ExcepAjusteIntCreMigrado';

SET Des_CieDia      := 'CIERRE DIARIO CARTERA';
SET Ref_GenInt      := 'GENERACION INTERES';
SET Aud_ProgramaID  := 'GENERAINTERECREPRO';

SET Des_ErrorGral       := 'ERROR DE SQL GENERAL';
SET Des_ErrorLlavDup    := 'ERROR EN ALTA, LLAVE DUPLICADA';
SET Des_ErrorCallSP     := 'ERROR AL LLAMAR A STORE PROCEDURE';
SET Des_ErrorValNulos   := 'ERROR VALORES NULOS';
SET Var_LlaveParametro	:= 'ManejaCovenioNomina'; -- Maneje convenios nomina
SET Var_SI         	    := 'S';
SET Var_No              := 'N';
SET Var_EstEnviado		:= 'E';					-- Estatus E : Enviado
SET Var_EstNoEnviado	:= 'N';					-- Estatus N : No Enviado

SELECT DiasCredito INTO Var_DiasCredito
	FROM PARAMETROSSIS;

SELECT ValorParametro INTO Var_ExcepAjusteIntCreMigrado
FROM PARAMGENERALES
WHERE LlaveParametro = LlaveExcepAjusteIntCreMigrado;

SET Var_ExcepAjusteIntCreMigrado := IFNULL( Var_ExcepAjusteIntCreMigrado , Cons_NO );
SET Var_SigFecha    := DATE_ADD(Par_Fecha, INTERVAL 1 DAY);
SET Var_FecApl      := Par_Fecha;


SELECT ValorParametro INTO Var_ManejaConvenio
	FROM PARAMGENERALES
	WHERE LlaveParametro=Var_LlaveParametro;

SELECT  COUNT(Cre.CreditoID) INTO Var_ContadorCre
	FROM CREDITOS    Cre
	INNER JOIN 	AMORTICREDITO Amo	ON Cre.CreditoID = Amo.CreditoID
	WHERE
	Amo.FechaInicio       <= Par_Fecha
	  AND Amo.FechaVencim       >  Par_Fecha
	  AND Amo.FechaExigible >  Par_Fecha
	  AND IFNULL(Amo.NumProyInteres, Entero_Cero) = Entero_Cero
	  AND (Amo.Estatus          =  Estatus_Vigente
	   OR   Amo.Estatus         =  Estatus_Vencida)
	  AND (Cre.Estatus          =  Estatus_Vigente
	   OR   Cre.Estatus         =  Estatus_Vencida)
	   AND (Cre.EstatusNomina NOT IN (Var_EstEnviado, Var_EstNoEnviado));

SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);

IF (Var_ContadorCre > Entero_Cero) THEN
	CALL MAESTROPOLIZAALT(
		Var_Poliza,     Par_EmpresaID,      Var_FecApl,     Pol_Automatica,     Con_GenIntere,
		Ref_GenInt,     Par_SalidaNO,       Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
END IF;

OPEN CURSORINTER;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORINTER INTO
	Var_CreditoID,  Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,
	Var_EmpresaID,  Var_CreCapVig,      Var_CreCapVNE,      Var_FormulaID,      Var_TasaFija,
	Var_MonedaID,   Var_Estatus,        Var_SucCliente,     Var_ProdCreID,      Var_ClasifCre,
	Var_TipoCalInt, Var_Interes,        Var_SubClasifID,    Var_SucursalCred,   Var_SalIntPro,
	Var_SalIntNoC,  Var_SalIntVen,      Var_Refinancia,     MontoOrig,          Var_InteresRef;

	START TRANSACTION;
	BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
	DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
	DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
	DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

	-- Inicalizacion
	SET Error_Key       := Entero_Cero;
	SET SalCapital      := Entero_Cero;
	SET Var_CapAju      := Entero_Cero;
	SET Var_Intere      := Entero_Cero;
	SET Var_ValorTasa   := Entero_Cero;
	SET Var_SubClasifID := IFNULL(Var_SubClasifID, Entero_Cero);
	SET Var_SucursalCred := IFNULL(Var_SucursalCred, Aud_Sucursal);
	SET Var_SalIntPro   := IFNULL(Var_SalIntPro, Entero_Cero);
	SET Var_SalIntNoC   := IFNULL(Var_SalIntNoC, Entero_Cero);
	SET Var_UltimoDia   := NO_UltimoDia;
	SET Var_InteresRef  := IFNULL(Var_InteresRef, Decimal_Cero);
	SET Nuevo_Interes   := Entero_Cero;

	-- Si Hoy es la Fecha del ultimo calculo de Interes, y es Tasa Fija, entonces el interes
	-- Ya no lo calculamos lo tomamos de la tabla de amortizacion, esto para poder ajustarnos
	-- A calendarios arbitrarios en las migraciones y evitar errores en calculos de centavos
	IF ( (Var_FechaVencim > Var_FechaExigible AND (DATEDIFF(Var_FechaExigible, Var_SigFecha) = Entero_Cero)) OR
		 (Var_FechaExigible >= Var_FechaVencim AND (DATEDIFF(Var_FechaVencim, Var_SigFecha) = Entero_Cero)) ) THEN

		IF(Var_FormulaID = For_TasaFija) THEN

			IF ( Var_ExcepAjusteIntCreMigrado = Cons_SI) THEN
				SET Var_CreditoMigrado := (SELECT CreditoIDSAFI FROM EQU_CREDITOS WHERE CreditoIDSAFI = Var_CreditoID);
			END IF;

			IF ( IFNULL(Var_CreditoMigrado, Entero_Cero ) = Entero_Cero ) THEN
				SET Var_UltimoDia := SI_UltimoDia;
			END IF;
		END IF;

	END IF;

	-- Hacemos el Calculo del Interes
	IF(Var_UltimoDia = NO_UltimoDia) THEN
		# Se verifica si la fecha es Inicio de Mes para aumentar al monto base(Saldo de Capital) el interes acumulado)
		SET Var_FechaFinMes := (SELECT LAST_DAY(Par_Fecha));
		SET Var_FechaFinMes := IFNULL(Var_FechaFinMes, Fecha_Vacia);

		SET SalCapital := Var_CreCapVig + Var_CreCapVNE;

		SET Var_CapAju  := (SELECT IFNULL(SUM(SaldoCapVigente + SaldoCapVenNExi), Decimal_Cero)
							FROM AMORTICREDITO
							WHERE CreditoID         = Var_CreditoID
							  AND AmortizacionID    < Var_AmortizacionID
							  AND Estatus    != Estatus_Pagada
							GROUP BY CreditoID );


		SET Var_CapAju := IFNULL(Var_CapAju, Entero_Cero);

		SET SalCapital := SalCapital- Var_CapAju;

		CALL CRECALCULOTASAPRO(
			Var_CreditoID,      Var_FormulaID,      Var_TasaFija,       Par_Fecha,          Var_FechaInicio,
			Var_EmpresaID,      Var_ValorTasa,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Var_Refinancia = Cons_SI) THEN
				# Si es inicio de una amortizacion, el interes acumulado de inicializa en cero.
			IF(Par_Fecha = Var_FechaInicio) THEN
				# Se inicializa en cero el valor del interes Acumulado e Interes Refinanciar
				UPDATE CREDITOS
				SET InteresAcumulado = Decimal_Cero,
					InteresRefinanciar = Decimal_Cero
				WHERE CreditoID = Var_CreditoID;

				SET Var_InteresRef := Decimal_Cero;

			END IF;

			# Como el credito refinancia al saldo de capital se le suma el interes acumulado de meses anteriores
			SET SalCapital := SalCapital + Var_InteresRef;
		END IF;

		IF (Var_TipoCalInt = Int_SalInsol) THEN  -- Calculo Sobre Saldos Insolutos
			SET Var_Intere :=  ROUND(SalCapital * Var_ValorTasa * DiasInteres / (Var_DiasCredito * Dec_Cien), 2);
			-- SI SE TIENE HABILITADO EL PARAMETRO DE MANEJA CONVENIO
			IF(Var_ManejaConvenio = Var_SI)THEN
		        SET Var_EsProducNomina := (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProdCreID);
       			SET Var_EsProducNomina := IFNULL(Var_EsProducNomina,Var_No);

				IF(Var_EsProducNomina = Var_SI )THEN
					SET Var_InteresCal	:= ROUND (Var_Interes / (CAST(DATEDIFF(Var_FechaVencim, Var_FechaInicio) AS SIGNED)),2);
					SET Var_Intere 		:= Var_InteresCal;
				END IF;

			END IF;
		ELSE

			-- Creditos Globales
			SET InterXdia := ROUND(((MontoOrig*Var_ValorTasa)/ (Var_DiasCredito * Dec_Cien)),2);
			SET Var_Intere :=  ROUND(InterXdia * DiasInteres, 2);
		END IF;

		IF(Var_Interes <
			 (IFNULL(Var_Intere, Entero_Cero) +
			 IFNULL(Var_SalIntPro, Entero_Cero) +
			 IFNULL(Var_SalIntVen,Entero_Cero) +
			 IFNULL(Var_SalIntNoC, Entero_Cero))
			AND Var_FormulaID = For_TasaFija
		)THEN
			SET Var_Intere := ROUND(Var_Interes - IFNULL(Var_SalIntPro, Entero_Cero) -
												  IFNULL(Var_SalIntVen,Entero_Cero) -
												  IFNULL(Var_SalIntNoC, Entero_Cero), 2);

			SET Var_Intere := CASE WHEN Var_Intere < Entero_Cero THEN Entero_Cero ELSE Var_Intere END;

		END IF;


	ELSE    -- else del que es el ultimo dia del calculo del Interes
		-- Var_Interes Es el Interes Original Calculado de la Amortizacion

		SET Var_Intere := ROUND(Var_Interes - IFNULL(Var_SalIntPro, Entero_Cero) -
											  IFNULL(Var_SalIntVen,Entero_Cero) -
											  IFNULL(Var_SalIntNoC, Entero_Cero), 2);
	END IF;

	-- validar la sumatoria Interes
	IF(Var_TipoCalInt = Int_SalGlobal) THEN
		SET Nuevo_Interes := ROUND(Var_Intere + IFNULL(Var_SalIntPro, Entero_Cero) +
												IFNULL(Var_SalIntVen,Entero_Cero) +
												IFNULL(Var_SalIntNoC, Entero_Cero), 2);

		IF( Nuevo_Interes > Var_Interes ) THEN
			SET Nuevo_Interes := ROUND(Var_Interes - IFNULL(Var_SalIntPro, Entero_Cero) -
													IFNULL(Var_SalIntVen,Entero_Cero) -
													IFNULL(Var_SalIntNoC, Entero_Cero), 2);
		ELSE
			IF (Nuevo_Interes = Var_Interes) THEN
				SET Nuevo_Interes := Entero_Cero;
			END IF;

			IF (Nuevo_Interes < Var_Interes) THEN
				SET Nuevo_Interes := Var_Intere;
			END IF;

		END IF;

	/*  Si el Tipo de interes es global, el credito no es migrado y el parametro ajuste de intereses es SI: se ajusta el Interes
		si el parametro de ajuste de intereses esta apagado: se ajusta el interes
		En caso contrario no se ajustan los intereses contra lo pactado en la amortizacion.*/
		IF( (Var_ExcepAjusteIntCreMigrado = Cons_SI AND IFNULL(Var_CreditoMigrado, Entero_Cero ) = Entero_Cero) OR
			 Var_ExcepAjusteIntCreMigrado = Cons_NO) THEN
			SET Var_Intere := Nuevo_Interes;
		END IF;
	END IF;

	IF (Var_Intere > Entero_Cero) THEN

		-- Verifica si el Credito esta Vencido diferenciar Los Asientos Contables del Interes
		IF (Var_Estatus = Cre_Vencido ) THEN

			SET Mov_AboConta    := Con_CorOrdInt;
			SET Mov_CarConta    := Con_CueOrdInt;
			SET Mov_CarOpera    := Mov_IntNoConta;
		ELSE
			SET Mov_AboConta    := Con_IngreInt;
			SET Mov_CarConta    := Con_IntDeven;
			SET Mov_CarOpera    := Mov_IntPro;
		END IF;

		CALL  CONTACREDITOPRO (
		Var_CreditoID,			Var_AmortizacionID,		Entero_Cero,			Entero_Cero,			Par_Fecha,
		Var_FecApl,				Var_Intere,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
		Var_SubClasifID,		Var_SucCliente,			Des_CieDia,				Ref_GenInt,				AltaPoliza_NO,
		Entero_Cero,			Var_Poliza,				AltaPolCre_SI,			AltaMovCre_SI,			Mov_CarConta,
		Mov_CarOpera,			Nat_Cargo,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
		Cadena_Vacia,			/*Par_SalidaNO,*/			Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
		Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,			Var_SucursalCred,		Aud_NumTransaccion);

		CALL  CONTACREDITOPRO (
		Var_CreditoID,			Var_AmortizacionID,		Entero_Cero,			Entero_Cero,			Par_Fecha,
		Var_FecApl,				Var_Intere,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
		Var_SubClasifID,		Var_SucCliente,			Des_CieDia,				Ref_GenInt,				AltaPoliza_NO,
		Entero_Cero,			Var_Poliza,				AltaPolCre_SI,			AltaMovCre_NO,			Mov_AboConta,
		Entero_Cero,			Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
		Cadena_Vacia,			/*Par_SalidaNO,*/			Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
		Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,			Var_SucursalCred,		Aud_NumTransaccion);


		IF(Var_Refinancia = Cons_SI) THEN
			# Se actualiza el campo Interes Acumulado de la tabla de CREDITOS esto con el fin de mantener el interes que se va acumulando diariamente
			UPDATE CREDITOS
			SET InteresAcumulado = InteresAcumulado + Var_Intere
			WHERE CreditoID = Var_CreditoID;


			IF(Par_Fecha = Var_FechaFinMes) THEN
				# Si la fecha es un fin de mes, se actualiza el campo InteresRefinanciar con el valor de InteresAcumulado(lo que se ha ido acumulando hasta el fin de mes
				UPDATE CREDITOS
				SET InteresRefinanciar  = InteresAcumulado
				WHERE CreditoID         = Var_CreditoID;

			END IF;

		END IF;
	END IF;

	END;
	SET Var_CreditoStr = CONCAT(CONVERT(Var_CreditoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR)) ;
	IF Error_Key = 0 THEN
		COMMIT;
	END IF;
	IF Error_Key = 1 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_GenIntere,      Par_Fecha,          Var_CreditoStr,         Des_ErrorGral,
				Var_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
		COMMIT;
	END IF;
	IF Error_Key = 2 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_GenIntere,      Par_Fecha,          Var_CreditoStr,         Des_ErrorLlavDup,
				Var_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
		COMMIT;
	END IF;
	IF Error_Key = 3 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_GenIntere,      Par_Fecha,          Var_CreditoStr,         Des_ErrorCallSP,
				Var_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
		COMMIT;
	END IF;
	IF Error_Key = 4 THEN
		ROLLBACK;
		START TRANSACTION;
			CALL EXCEPCIONBATCHALT(
				Pro_GenIntere,      Par_Fecha,          Var_CreditoStr,         Des_ErrorValNulos,
				Var_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
		COMMIT;
	END IF;

	END LOOP;
END;
CLOSE CURSORINTER;

END TerminaStore$$
