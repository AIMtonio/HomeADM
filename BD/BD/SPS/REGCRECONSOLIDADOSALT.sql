-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGCRECONSOLIDADOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGCRECONSOLIDADOSALT`;

DELIMITER $$
CREATE PROCEDURE `REGCRECONSOLIDADOSALT`(
	-- Alta de Credito Consolidado
	-- Modulo Credito: Cartera Agro --> Registro --> Mesa de Control
	Par_CreditoID			BIGINT(12),		-- ID del Credito Consolidado
	INOUT Par_PolizaID		BIGINT(20),		-- Numero de poliza para registrar los detalles contables

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema	DATE;			-- Fecha de Sistema
	DECLARE Var_EstatusCredito	CHAR(1);		-- Maximo estatus de los creditos a consolidar
	DECLARE Var_EstatusCreacion	CHAR(1);		-- Estatus de Creacion de la Consolidacion
	DECLARE Var_FrecuenciaInt	CHAR(1);		-- Almacena la frecuencia de Interes
	DECLARE Var_FrecuenciaCap	CHAR(1);		-- Frecuencia Capital el Credito

	DECLARE Var_CliPagIVA		CHAR(1);		-- Si el cliente Paga IVA
	DECLARE Var_CobraIVAInteres	CHAR(1);		-- Iva de Interes Ordinario
	DECLARE Var_Control			VARCHAR(50);	-- Control de Retorno
	DECLARE Res_PeriodicidadCap		INT(11);	-- Periodicidad del Capital del Credito anterior
	DECLARE Var_PeriodicidadInt		INT(11);	-- Periodicidad del Interes del Credito

	DECLARE Var_NumDetConsolidaID		INT(11);	-- Numero de Consolidaciones
	DECLARE Var_SucursalOrigen			INT(11);	-- ID de la Sucursal Origen del Cliente
	DECLARE Var_NumPagoSostenidos		INT(11);	-- Numero de Pagos Sostenidos
	DECLARE Var_PeriodicidadCap			INT(11);	-- Periodicidad Capital
	DECLARE Var_DiasAtraso				INT(11);	-- Numero de Dias de Atraso
	DECLARE Var_CreditoID				BIGINT(12);	-- ID de Credito

	DECLARE Var_FolioConsolidacionID	BIGINT(12);		-- ID de Consolidacion
	DECLARE Var_Consecutivo				BIGINT(20);		-- Consecutivo
	DECLARE Var_SolicitudCreditoID		BIGINT(20);		-- Numero de Solicitud de Credito
	DECLARE Var_IVASucursal				DECIMAL(8, 4);	-- IVA de sucursal
	DECLARE Var_IVAIntOrdinario			DECIMAL(12,2);	-- IVA Interes Ordinario

	DECLARE Var_ReservaInteres 			DECIMAL(14,2);	-- Monto de Reserva Interes

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Con_SI				CHAR(1);		-- Constante SI
	DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Salida_SI			CHAR(1);		-- Constante Salida SI

	DECLARE Salida_NO			CHAR(1);		-- Constante Salida NO
	DECLARE Est_Inactivo		CHAR(1);		-- Constante Estatus Inactivo
	DECLARE Est_Vigente			CHAR(1);		-- Constante Estatus Vigente
	DECLARE Est_Vencido			CHAR(1);		-- Constante Estatus Vencido
	DECLARE Est_Autorizado		CHAR(1);		-- Constante Estatus Autorizado

	DECLARE Est_Atrasado		CHAR(1);		-- Constante Estatus Atrasado
	DECLARE Con_Origen			CHAR(1);		-- Constante Origen donde se llama el SP
	DECLARE Frec_Unico			CHAR(1);		-- Constante Frecuencia Unica
	DECLARE Frec_Libre			CHAR(1);		-- Constante Frecuencia Libre
	DECLARE Frec_Periodo		CHAR(1);		-- Constante Frecuencia Periodo

	DECLARE AltaPoliza_NO		CHAR(1);		-- Alta de Poliza Contable General: NO
	DECLARE AltaPolCre_SI		CHAR(1);		-- Alta de Poliza Contable de Credito: SI
	DECLARE AltaMovCre_NO		CHAR(1);		-- Alta de Movimiento de Credito: NO
	DECLARE Nat_Abono			CHAR(1);		-- Naturaleza de Abono.
	DECLARE Nat_Cargo			CHAR(1);		-- Naturaleza de Cargo

	DECLARE AltaMovAho_NO		CHAR(1);		-- Alta de Movimiento de Ahorro: NO
	DECLARE Des_Reserva			VARCHAR(100);	-- Constante Descripcion de Reserva
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno			INT(11);		-- Constante Entero Uno
	DECLARE Num_PagRegular		INT(11);		-- Numero de Pagos Para Regularizacion Reestructura: 3

	DECLARE Con_EstBalance		INT(11);		-- Balance. Estimacion Prev. Riesgos Crediticios
	DECLARE Con_EstResultados	INT(11);		-- Resultados. Estimacion Prev. Riesgos Crediticios
	DECLARE Con_ContDesem		INT(11);		-- Constante Concepto Contable Desembolso
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Constante Decimal Vacio

	-- Asignacion de Constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';
	SET Salida_SI				:= 'S';

	SET Salida_NO				:= 'N';
	SET Est_Inactivo			:= 'I';
	SET Est_Vigente				:= 'V';
	SET Est_Vencido				:= 'B';
	SET Est_Autorizado			:= 'A';

	SET Est_Atrasado			:= 'A';
	SET Con_Origen				:= 'E';
	SET Frec_Unico				:= 'U';
	SET Frec_Libre				:= 'L';
	SET Frec_Periodo			:= 'P';

	SET AltaPoliza_NO			:= 'N';
	SET AltaPolCre_SI			:= 'S';
	SET AltaMovCre_NO			:= 'N';
	SET AltaMovAho_NO			:= 'N';
	SET Nat_Abono				:= 'A';

	SET Nat_Cargo				:= 'C';
	SET Des_Reserva				:= 'ESTIMACION CAPITALIZACION INTERES';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Num_PagRegular			:= 3;

	SET Con_EstBalance			:= 17;
	SET Con_EstResultados		:= 18;
	SET Con_ContDesem			:= 50;
	SET Decimal_Cero			:= 0.00;

	-- Inicio del Manejo de Errores
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-REGCRECONSOLIDADOSALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);

		IF( Par_CreditoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Numero de Credito esta Vacio.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CreditoID,	SolicitudCreditoID
		INTO Var_CreditoID,	Var_SolicitudCreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID
		  AND EsAgropecuario = Con_SI
		  AND EsConsolidacionAgro = Con_SI;

		IF( IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Numero de Credito esta Vacio.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FolioConsolida
		INTO Var_FolioConsolidacionID
		FROM CRECONSOLIDAAGROENC
		WHERE SolicitudCreditoID = Var_SolicitudCreditoID
		  AND CreditoID = Par_CreditoID
		  AND Estatus = Est_Autorizado;

		SET Var_FolioConsolidacionID := IFNULL(Var_FolioConsolidacionID, Entero_Cero);

		IF( IFNULL(Var_FolioConsolidacionID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Credito no tiene un Folio de Consolidacion.';
			SET Var_Control	:= 'folioConsolidacionID';
			LEAVE ManejoErrores;
		END IF;


		SELECT IFNULL(COUNT(DetConsolidaID), Entero_Cero)
		INTO Var_NumDetConsolidaID
		FROM CRECONSOLIDAAGRODET
		WHERE FolioConsolida = Var_FolioConsolidacionID
		  AND Estatus = Est_Autorizado;

		IF( IFNULL(Var_NumDetConsolidaID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'El Folio de Consolidacion no tiene Creditos Autorizados.';
			SET Var_Control	:= 'folioConsolidacionID';
			LEAVE ManejoErrores;
		END IF;

		SELECT Cre.Estatus
		INTO Var_EstatusCredito
		FROM CRECONSOLIDAAGROENC Enc
		INNER JOIN CRECONSOLIDAAGRODET Det ON Enc.FolioConsolida = Det.FolioConsolida AND Det.Estatus = Est_Autorizado
		INNER JOIN CREDITOS Cre ON Det.CreditoID = Cre.CreditoID
		WHERE Enc.FolioConsolida = Var_FolioConsolidacionID
		ORDER BY FIELD (Cre.Estatus, Est_Vencido, Est_Vigente)
		LIMIT 1;

		SET Var_EstatusCredito := IFNULL(Var_EstatusCredito, Cadena_Vacia);
		IF( Var_EstatusCredito NOT IN (Est_Vencido, Est_Vigente) ) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'El Estatus de asignacion del credito a consolidar no es valido.';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		SET Var_EstatusCreacion := Est_Vigente;
		IF( Var_EstatusCredito = Est_Vencido ) THEN
			SET Var_EstatusCreacion := Est_Vencido;
		END IF;

		# Inicializacion de variables
		SELECT  Cli.PagaIVA,	Pro.CobraIVAInteres,	Cli.SucursalOrigen
		INTO	Var_CliPagIVA,	Var_CobraIVAInteres,	Var_SucursalOrigen
		FROM CREDITOS Cre
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		INNER JOIN CLIENTES Cli	ON Cre.ClienteID = Cli.ClienteID
		WHERE Cre.CreditoID = Par_CreditoID;

		SET Var_SucursalOrigen := IFNULL(Var_SucursalOrigen, Entero_Cero);

		SELECT IVA
		INTO Var_IVASucursal
		FROM SUCURSALES
		WHERE SucursalID = Var_SucursalOrigen;

		SET Var_IVASucursal 	:= IFNULL(Var_IVASucursal, Decimal_Cero);
		SET Var_CliPagIVA 		:= IFNULL(Var_CliPagIVA, Cadena_Vacia);
		SET Var_CobraIVAInteres	:= IFNULL(Var_CobraIVAInteres, Cadena_Vacia);
		SET Var_IVAIntOrdinario := Decimal_Cero;

		IF( Var_CliPagIVA = Con_SI ) THEN
			IF (Var_CobraIVAInteres = Con_SI) THEN
				SET Var_IVAIntOrdinario := Var_IVASucursal;
			END IF;
		END IF;

		SELECT FechaSistema
		INTO Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT 1;

		SELECT 	SUM(ROUND(	IFNULL(Amo.SaldoInteresOrd, Entero_Cero) + IFNULL(Amo.SaldoInteresAtr, Entero_Cero) +
							IFNULL(Amo.SaldoInteresVen, Entero_Cero) + IFNULL(Amo.SaldoInteresPro, Entero_Cero) + IFNULL(Amo.SaldoIntNoConta, Entero_Cero),2) +
					ROUND(  ROUND(IFNULL(Amo.SaldoInteresOrd, Entero_Cero) * Var_IVAIntOrdinario, 2) +
							ROUND(IFNULL(Amo.SaldoInteresAtr, Entero_Cero) * Var_IVAIntOrdinario, 2) +
							ROUND(IFNULL(Amo.SaldoInteresVen, Entero_Cero) * Var_IVAIntOrdinario, 2) +
							ROUND(IFNULL(Amo.SaldoInteresPro, Entero_Cero) * Var_IVAIntOrdinario, 2) +
							ROUND(IFNULL(Amo.SaldoIntNoConta, Entero_Cero) * Var_IVAIntOrdinario, 2), 2)),
				MAX(
					(SELECT
						(CASE WHEN IFNULL(MIN(FechaExigible), Fecha_Vacia) = Fecha_Vacia THEN Entero_Cero
							ELSE ( DATEDIFF(Var_FechaSistema, MIN(FechaExigible)) + Entero_Uno) END)
						FROM AMORTICREDITO Amo
						WHERE Amo.CreditoID = Cre.CreditoID
						AND Amo.Estatus  IN (Est_Vigente, Est_Atrasado, Est_Vencido)
						AND Amo.FechaExigible <= Var_FechaSistema
						GROUP BY Amo.CreditoID))
		INTO Var_ReservaInteres,	Var_DiasAtraso
		FROM CRECONSOLIDAAGROENC Enc
		INNER JOIN CRECONSOLIDAAGRODET Det ON Enc.FolioConsolida = Det.FolioConsolida AND Det.Estatus = Est_Autorizado
		INNER JOIN CREDITOS Cre ON Det.CreditoID = Cre.CreditoID
		INNER JOIN AMORTICREDITO Amo ON Cre.CreditoID = Amo.CreditoID AND Amo.Estatus IN (Est_Vigente, Est_Atrasado, Est_Vencido)
		WHERE Enc.FolioConsolida = Var_FolioConsolidacionID;

		SET Var_ReservaInteres	:= IFNULL(Var_ReservaInteres, Entero_Cero);
		SET Var_DiasAtraso		:= IFNULL(Var_DiasAtraso, Entero_Cero);

		SELECT 	Cre.FrecuenciaCap,	Cre.PeriodicidadCap,	Cre.FrecuenciaInt,		Cre.PeriodicidadInt
		INTO 	Var_FrecuenciaCap,	Var_PeriodicidadCap,	Var_FrecuenciaInt,		Var_PeriodicidadInt
		FROM CREDITOS Cre
		INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
		WHERE CreditoID = Par_CreditoID;

		SELECT MAX(Cre.PeriodicidadCap)
		INTO Res_PeriodicidadCap
		FROM CRECONSOLIDAAGROENC Enc
		INNER JOIN CRECONSOLIDAAGRODET Det ON Enc.FolioConsolida = Det.FolioConsolida AND Det.Estatus = Est_Autorizado
		INNER JOIN CREDITOS Cre ON Det.CreditoID = Cre.CreditoID
		WHERE Enc.FolioConsolida = Var_FolioConsolidacionID;

		SET Res_PeriodicidadCap := IFNULL(Res_PeriodicidadCap, Entero_Uno);

		IF(Res_PeriodicidadCap = Entero_Cero)THEN
			SET Res_PeriodicidadCap := Entero_Uno;
		END IF;

		-- Revision del Numero de Pagos Sostenidos para ser Regularizado
		-- Se valida si el Tipo Frecuencia es diferente de Unica y Libre
		SET Var_NumPagoSostenidos := Entero_Uno;

		IF( Var_FrecuenciaCap != Frec_Unico ) THEN
			# Si la periodicidad del Capital es mayor a 60 dias el numero de pagos sostenidos sera 1

			IF( Var_PeriodicidadCap > 60 ) THEN
				SET Var_NumPagoSostenidos := Entero_Uno;
			ELSE
				-- Res_PeriodicidadCap: Periodicidad de Capital del Credito Anterior
				-- Var_PeriodicidadCap: Periodicidad de Capital del Credito Nuevo
				IF( Var_FrecuenciaCap != Frec_Libre ) THEN
					SET Var_NumPagoSostenidos := CEILING(( Res_PeriodicidadCap / Var_PeriodicidadCap) * Num_PagRegular);
				ELSE
					SET Var_NumPagoSostenidos := Num_PagRegular;
				END IF;

			END IF;
		ELSE

			IF(Var_FrecuenciaCap = Frec_Unico AND ( Var_FrecuenciaInt IN (Frec_Libre, Frec_Unico))) THEN
				SET Var_NumPagoSostenidos := Entero_Uno;
			ELSE
				-- Var_PeriodInt: Periodicidad de Interes: Credito Nuevo
				IF(Var_FrecuenciaInt != Frec_Periodo ) THEN
					SET Var_NumPagoSostenidos := CEILING((90/Var_PeriodicidadInt));
				ELSE
					SET Var_NumPagoSostenidos := Entero_Uno;
				END IF;
			END IF;
		END IF;

		SET Var_NumPagoSostenidos := IFNULL(Var_NumPagoSostenidos,Entero_Uno);

		IF(Var_NumPagoSostenidos = Entero_Cero) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'El Numero de Pagos Sostenido no puede ser Cero.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO REGCRECONSOLIDADOS (
			FechaRegistro,			CreditoID,			EstatusCredito,		EstatusCreacion,		NumDiasAtraso,
			NumPagoSoste,			NumPagoActual,		Regularizado,		FechaRegularizacion,	FechaLimiteReporte,
			ReservaInteres,
			EmpresaID,				Usuario,			FechaActual,		DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion)
		VALUES (
			Var_FechaSistema,		Par_CreditoID,		Var_EstatusCredito,	Var_EstatusCreacion,	Var_DiasAtraso,
			Var_NumPagoSostenidos,	Entero_Cero,		Con_NO,				Fecha_Vacia,			Fecha_Vacia,
			Var_ReservaInteres,
			Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('El credito ', Par_CreditoID,' se ha Registro Correctamente.');
		SET Var_Control	:= 'creditoID';

	END ManejoErrores;
	-- Fin del Manejo de Errores

	IF ( Par_Salida = Salida_SI ) THEN
		SELECT  Par_ErrMen		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Par_CreditoID	AS consecutivo;
	END IF;

END TerminaStore$$