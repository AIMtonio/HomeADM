-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCRECARTALIQINTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS PAGOCRECARTALIQINTPRO;

DELIMITER $$
CREATE PROCEDURE PAGOCRECARTALIQINTPRO(
# ==============================================================================================
#------------- REALIZA EL DESEMBOLSO LOGICO DE UN CREDITO --------------------------------------
# ==============================================================================================
	Par_SoliciCredID		BIGINT(12),		# ID de la solicitud de credito a desembolsar
	Par_CuentaAhoID			BIGINT(12),
	Par_MonedaID			INT(11),
	Par_EsPrePago			CHAR(1),
	Par_Finiquito			CHAR(1),

	INOUT Par_MontoPago		DECIMAL(12,2),
	INOUT Par_Poliza		BIGINT,
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo 	BIGINT,

	Par_ModoPago			CHAR(1),
	Par_Origen				CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_RespaldaCred		CHAR(1),		-- Bandera que indica si se realizara el proceso de Respaldo de la informacion del Credito (S = Si se respalda, N = No se respalda)
	Par_Salida				CHAR(1),
	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE Fecha_Vacia			DATE;
    DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Estatus_Inactivo	CHAR(1);
	DECLARE Con_TipoCarta		CHAR(1);
	DECLARE Con_EstatusCarta	CHAR(1);
	DECLARE SalidaNo			CHAR(1);
	DECLARE Var_MontoCredito	DECIMAL(14,2);
	DECLARE AltaPoliza_NO		CHAR(1);
	DECLARE Var_PagoAplica		DECIMAL(14,2);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE n					INT;			-- N numero de cartas externas
	DECLARE i					INT;			-- Incremental para barrer la tabla de cartas externas
	DECLARE Var_CreditoID		BIGINT(12);		-- ID del crédito relacionado con la carta de liquidación
	DECLARE Salida_SI			CHAR(1);
	DECLARE Var_FechaSistema	DATE;			-- Almacena la fecha del sistema
	DECLARE Var_NCreditoID		BIGINT(12);		-- Credito nuevo
	DECLARE Var_MontoLiquidaHoy	DECIMAL(14,2);	-- Variable para liquidar al dia de hoy FECHA SITEMA
	DECLARE Var_FechaVencimiento	DATE;
	DECLARE Var_MontoLiquidar	DECIMAL(16,2);
	DECLARE Var_DevengaInteres	CHAR(1);
	DECLARE Var_DiferCondona	DECIMAL(16,2);
	DECLARE Var_SaldoInteres	DECIMAL(16,2);
	DECLARE Var_SaldoMora		DECIMAL(16,2);
	DECLARE Var_SaldoAccesorio  DECIMAL(16,2);
	DECLARE Var_SaldoNotCargo	DECIMAL(16,2);
	DECLARE Var_SaldoCapital	DECIMAL(16,2);
	DECLARE Var_PuestoCondona	VARCHAR(30);
	DECLARE Var_Porc_Cien		DECIMAL(8,2);
	DECLARE Con_NO				CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- String Vacio
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero en Cero
	SET Decimal_Cero		:= 0.00;			-- DECIMAL Cero
	SET Estatus_Activo		:= 'A';				-- Estatus Activo
	SET Estatus_Inactivo	:= 'I';				-- Estatus Inactivo

	SET Con_TipoCarta		:= 'I';				-- Tipo cart interna
	SET Con_EstatusCarta	:= 'A';				-- Estatus de la carta Autorizada
	SET SalidaNo			:= 'N';				-- Salida NO
	SET Var_MontoCredito	:= 0.00;			-- Monto del crédito relacionado con la cart de liquidación
	SET AltaPoliza_NO		:= 'N';				-- Alta Poliza NO
	SET i					:= 0;
	SET Salida_SI			:= 'S';
	SET Var_DevengaInteres	:= 'S';
	SET Var_Porc_Cien		:= 100.00;
	SET Con_NO				:= 'N';

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  			'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCRECARTALIQINTPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;

			SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
			SET Var_FechaSistema := IFNULL(Var_FechaSistema,Fecha_Vacia);

			SELECT 	IFNULL(Sol.CreditoID, Entero_Cero)
			INTO 	Var_NCreditoID
			FROM 	SOLICITUDCREDITO Sol
			WHERE 	SolicitudCreditoID = Par_SoliciCredID;

			SELECT COUNT(CLIQ.CartaLiquidaID) INTO n
			  FROM CONSOLIDACIONCARTALIQ		AS CONS
			 INNER JOIN CONSOLIDACARTALIQDET	AS DET	ON CONS.ConsolidaCartaID	= DET.ConsolidaCartaID	AND DET.TipoCarta	= Con_TipoCarta
			 INNER JOIN CARTALIQUIDACION		AS CLIQ	ON DET.CartaLiquidaID		= CLIQ.CartaLiquidaID	AND CLIQ.Estatus	= Con_EstatusCarta
			 INNER JOIN CREDITOS				AS CRE	ON CLIQ.CreditoID			= CRE.CreditoID
			 WHERE CONS.SolicitudCreditoID = Par_SoliciCredID;

			WHILE i < n DO

				SELECT	CRE.CreditoID,		 CDET.MontoLiquidar,	FUNCIONTOTDEUDACRE(CRE.CreditoID),	CLIQ.FechaVencimiento
				  INTO	Var_CreditoID,		Var_MontoCredito,		Var_MontoLiquidaHoy,				Var_FechaVencimiento

				  FROM CONSOLIDACIONCARTALIQ		AS CONS
				 INNER JOIN CONSOLIDACARTALIQDET	AS DET	ON CONS.ConsolidaCartaID	= DET.ConsolidaCartaID	AND DET.TipoCarta	= Con_TipoCarta
				 INNER JOIN CARTALIQUIDACION		AS CLIQ	ON DET.CartaLiquidaID		= CLIQ.CartaLiquidaID	AND CLIQ.Estatus	= Con_EstatusCarta
				 INNER JOIN CREDITOS				AS CRE	ON CLIQ.CreditoID			= CRE.CreditoID
				 INNER JOIN CARTALIQUIDACIONDET CDET ON CLIQ.CartaLiquidaID = CDET.CartaLiquidaID
				 WHERE CONS.SolicitudCreditoID = Par_SoliciCredID
				 ORDER BY DET.CartaLiquidaID
				 LIMIT i,1;

				 -- Se realiza condonacion de los intereses y moras
				 SELECT
					(SaldoInterAtras+SaldoInterVenc+SaldoInterProvi+SaldoIntNoConta) as Interes,
					(SaldoMoratorios+SaldoMoraVencido+SaldoMoraCarVen) as Moratorio
					INTO
					Var_SaldoInteres,
                    Var_SaldoMora
					FROM CREDITOS WHERE CreditoID = Var_CreditoID;

				SELECT SUM(SaldoOtrasComis)
				INTO Var_SaldoAccesorio
				FROM AMORTICREDITO
				WHERE CreditoID = Var_CreditoID
					AND Estatus <> 'P';

				IF (Var_SaldoInteres+Var_SaldoMora + Var_SaldoAccesorio) > Entero_Cero THEN
					SET Var_PuestoCondona := (SELECT ClavePuestoID FROM USUARIOS WHERE UsuarioID = Aud_Usuario);
					SET Var_PuestoCondona := IFNULL(Var_PuestoCondona,Cadena_Vacia);


					CALL CREQUITASPRO(Var_CreditoID, 	Aud_Usuario, 		Var_PuestoCondona, 		Var_FechaSistema, 		Var_SaldoAccesorio,
									 CASE WHEN Var_SaldoAccesorio > Entero_Cero THEN 100 ELSE Entero_Cero END,
									 Var_SaldoMora,		Var_Porc_Cien,			Var_SaldoInteres, 		Var_Porc_Cien,
									 Entero_Cero,	 	Entero_Cero,		Entero_Cero,			Var_Porc_Cien,			Par_Poliza,
									 Con_NO,		 	SalidaNo,			Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,
									 Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
									 Aud_NumTransaccion);


					IF Par_NumErr <> Entero_Cero THEN
							LEAVE ManejoErrores;
					END IF;

				END IF;



				SET Var_MontoLiquidaHoy := FUNCIONTOTDEUDACRE(Var_CreditoID);

				IF Var_MontoCredito > Var_MontoLiquidaHoy THEN
					SET Var_MontoCredito := Var_MontoLiquidaHoy;
				END IF;

				CALL PAGOCREDITOPRO(
					Var_CreditoID,		Par_CuentaAhoID,	Var_MontoCredito,	Par_MonedaID,		Par_EsPrePago,
					Par_Finiquito,		Aud_EmpresaID,		SalidaNo,			AltaPoliza_NO,		Var_PagoAplica,
					Par_Poliza,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_ModoPago,
					Par_Origen,			Par_RespaldaCred,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


					IF (Par_NumErr > Entero_Cero) THEN
						SET Par_NumErr := Par_NumErr;
						SET Par_ErrMen := Par_ErrMen;
						SET Var_Control:= 'creditoID';

						LEAVE ManejoErrores;
					END IF;

				SET Par_MontoPago = Par_MontoPago + Var_PagoAplica;
				SET i = i + 1;

			END WHILE;

			-- Si se trata de un credito consolidado actulizamos la fechalimite de reporte

			UPDATE CONSOLIDACIONCARTALIQ SET
				FechaLimiteReporte	= FNFECHAREPORTADIASATRASO(Var_NCreditoID, Var_FechaSistema)
			WHERE CreditoID = Var_NCreditoID;


	END ManejoErrores;	-- END del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
				'creditoID' 	AS control,
				Var_CreditoID 	AS consecutivo;
	END IF;

END TerminaStore$$