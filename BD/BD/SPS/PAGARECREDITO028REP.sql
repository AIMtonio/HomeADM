-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGARECREDITO028REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGARECREDITO028REP`;
DELIMITER $$

CREATE PROCEDURE `PAGARECREDITO028REP`(
	/*PAGARÉ DE CREDITOS DE FINANCIERA TAMAZULA */
	Par_CreditoID				BIGINT(12),			# Número del Crédito
	Par_TipoReporte				TINYINT,			# Tipo de reporte
	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN
	# Declaracion de Variables
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_ClienteInstitucion	INT(11);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_NombreRepresentante	VARCHAR(100);
	DECLARE Var_NombreInstitucion	VARCHAR(100);
	DECLARE Var_Direccion			VARCHAR(300);
	DECLARE Var_LugarSucursal		VARCHAR(300);
	DECLARE Var_NombreCliente		VARCHAR(200);
	DECLARE Var_NombreCompleto		VARCHAR(200);
	DECLARE Var_RFC					VARCHAR(20);
	DECLARE Var_NombreRepLegal		VARCHAR(200);
	DECLARE Var_DirRepLegal			VARCHAR(300);
	DECLARE Var_ClientesGarID		VARCHAR(200);
	DECLARE Var_ValorCAT			DECIMAL(16,4);
	DECLARE Var_MontoCredito		DECIMAL(14,2);
	DECLARE Var_Capital				DECIMAL(14,2);
	DECLARE Var_FechaAutoriza		DATE;
	DECLARE Var_FechaVencimien		DATE;
	DECLARE Var_FechaExigible		DATE;
	DECLARE Var_PlazoID				VARCHAR(20);
	DECLARE Var_TasaFija			DECIMAL(14,4);
	DECLARE Var_TasaBase			DECIMAL(14,4);
	DECLARE Var_FactorMora			DECIMAL(12,2);
	DECLARE Var_ProductoCreditoID	INT(11);
	DECLARE Var_TasaBaseID			INT(11);
	DECLARE Var_DestinoCreID		INT(11);
	DECLARE Var_SubClasifID			INT(11);
	DECLARE Var_TipoSociedadID		INT(11);
	DECLARE Var_NomTipoSociedad		VARCHAR(100);
	DECLARE Var_MontoSeguroVida		DECIMAL(14,2);
	DECLARE Var_SeguroVidaPagado	DECIMAL(14,2);
	DECLARE Var_MontoComApert		DECIMAL(14,2);
	DECLARE Var_Descripcion			VARCHAR(100);
	DECLARE Var_RegistroRECA		VARCHAR(100);
	DECLARE Var_PlazoMeses			INT(11);
	DECLARE Var_PlazoDescripcion	VARCHAR(50);
	DECLARE Var_PorcentajeFEGA		DECIMAL(18,2);
	DECLARE Var_TipoPersona			CHAR(1);
	DECLARE Var_PermiteLiqAntici	CHAR(1);
	DECLARE Var_CobraComLiqAntici	CHAR(1);
	DECLARE Var_TipComLiqAntici		CHAR(1);
	DECLARE Var_ComisionLiqAntici	DECIMAL(16,4);
	DECLARE Var_ComisionAdmon		VARCHAR(100);
	DECLARE Var_SaldoInsoluto		DECIMAL(16,4);
	DECLARE Var_CalcInteresID		INT(11);
	DECLARE Var_GarantiaID			INT(11);
	DECLARE Var_GarantiasID			VARCHAR(50);
	DECLARE Var_NombreGarante		TEXT;
	DECLARE Var_NombreAval			TEXT;
	DECLARE Var_SolicitudCreditoID	BIGINT(11);
	DECLARE Var_CuentaAhoID			BIGINT(12);
	DECLARE Var_EscrituraPublic		VARCHAR(50);
	DECLARE Var_NoEscritura			BIGINT;
	DECLARE Var_NoEscrituraD		DECIMAL;
	DECLARE Var_FechaEsc			DATE;
	DECLARE Var_Notaria				INT(11);
	DECLARE Var_EstadoIDEsc			INT(11);
	DECLARE Var_LocalidadEsc		INT(11);
	DECLARE Var_NomNotario			VARCHAR(100);
	DECLARE Var_NomApoderado		VARCHAR(150);
	DECLARE Var_FolioRegPub			VARCHAR(10);
	DECLARE Var_NomMunicipio		VARCHAR(150);
	DECLARE Var_NomEstado			VARCHAR(150);
	DECLARE Var_EscrituraPublicCte	VARCHAR(50);
	DECLARE Var_NoEscrituraCte		BIGINT;
	DECLARE Var_NoEscrituraDCte		DECIMAL;
	DECLARE Var_FechaEscCte			DATE;
	DECLARE Var_NotariaCte			INT(11);
	DECLARE Var_EstadoIDEscCte		INT(11);
	DECLARE Var_LocalidadEscCte		INT(11);
	DECLARE Var_NomNotarioCte		VARCHAR(100);
	DECLARE Var_NomApoderadoCte		VARCHAR(150);
	DECLARE Var_FolioRegPubCte		VARCHAR(10);
	DECLARE Var_NomMunicipioCte		VARCHAR(150);
	DECLARE Var_NomEstadoCte		VARCHAR(150);
	DECLARE Var_NomMunRegPubCte		VARCHAR(150);
	DECLARE Var_NomEstadoRegPubCte	VARCHAR(150);
	DECLARE Var_MontoPrestamo		DECIMAL(16,2);
	DECLARE Var_MontoSolicitante	DECIMAL(16,2);
	DECLARE Var_MontoProyecto		DECIMAL(16,2);
	DECLARE Var_MontoComApProd		DECIMAL(16,2);
	DECLARE Var_TipoComXapert		CHAR(1);
	DECLARE Var_NumAmortizaciones	INT(11);
	DECLARE Var_PeriodicidadCap		INT(11);
	DECLARE Var_PeriodicidadInt		INT(11);
	DECLARE Var_FrecuenciaCap		CHAR(1);
	DECLARE Var_FrecuenciaInt		CHAR(1);
	DECLARE Var_ComApertura			DECIMAL(16,2);
	DECLARE Var_EstadoCivil			VARCHAR(2);
	DECLARE Var_TipoSubClasif		VARCHAR(50);
	DECLARE Var_5toParrafo			VARCHAR(300);
	# Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Cons_No					CHAR(1);
	DECLARE Cons_SI					CHAR(1);
	DECLARE SeccionPrincipal		INT(11);
	DECLARE SeccionAmortizaciones	INT(11);
	DECLARE SeccionAcreditado		INT(11);
	DECLARE SeccionAvales			INT(11);
	DECLARE SeccionObligSol			INT(11);
	DECLARE Por_Porcentaje			CHAR(1);
	DECLARE EstatusAutorizado		CHAR(1);
	DECLARE EstatusVig				CHAR(1);
	DECLARE ConcInvRecPrestamo		CHAR(1);
	DECLARE ConcInvRecSolicitante	CHAR(1);
	DECLARE ConcInvRecOtrasF		CHAR(2);
	DECLARE ComXPorcentaje			CHAR(1);
	DECLARE ComXMonto				CHAR(1);
	DECLARE FrecPagoUnico			CHAR(1);
    DECLARE FrecLibre               CHAR(1);
	DECLARE FrecMensual				CHAR(1);
    DECLARE FrecPeriodo             CHAR(1);
	DECLARE EdoCivilCS				CHAR(2);
	DECLARE EdoCivilCC				CHAR(2);
	DECLARE EdoCivilCM				CHAR(2);
	DECLARE EdoCivilUnion			CHAR(2);
	DECLARE TipoGarantiaPrend		INT(11);
	DECLARE TipoGarantiaHipo		INT(11);
	DECLARE TipoGarantiaGuber		INT(11);
	DECLARE TipoElector				INT(11);
	DECLARE TasaFija				INT(11);
	DECLARE TipoHabilitacionAvio	INT(11);
	DECLARE Frec90Dias				INT(11);
	DECLARE RolObligadoSol			CHAR(1);
	DECLARE RolAval					CHAR(1);
    DECLARE TasaOrdinaria           VARCHAR(100);
    DECLARE Frec30Dias              INT(11);
    DECLARE CompParf5               VARCHAR(500);
    DECLARE Var_Parf6               VARCHAR(1000);

	SET Entero_Cero				:= 0;			-- Entero Cero
	SET Decimal_Cero			:= 0.0;			-- Decimal cero
	SET Cadena_Vacia			:= '';			-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';-- Fecha Vacia
	SET Cons_No					:= 'N';			-- Constantes No
	SET Cons_SI					:= 'S';			-- Constantes Si
	SET SeccionPrincipal		:= 01;			-- Seccion principal
	SET SeccionAmortizaciones	:= 02;			-- Seccion de amortizaciones.
	SET SeccionAcreditado		:= 03;			-- Seccion datos acreditado.
	SET SeccionAvales			:= 04;			-- Seccion datos de avales.
	SET SeccionObligSol			:= 05;			-- Seccion datos de los obligados solidarios.
	SET Por_Porcentaje			:= 'S';			-- Porcentaje de Saldo Insoluto.
	SET EstatusAutorizado		:= 'U';			-- Estatus de la garantía o de los avales: autorizado(a).
	SET EstatusVig				:= 'V';			-- Estatus Vigente.
	SET ConcInvRecPrestamo		:= 'P';			-- Concepto de inversión por Recursos del Prestamo.
	SET ConcInvRecSolicitante	:= 'S';			-- Concepto de inversión por Recursos del Solicitante.
	SET ConcInvRecOtrasF		:= 'OF';		-- Concepto de inversión por Recursos Otras Fuentes.
	SET ComXPorcentaje			:= 'P';			-- Comision por Apertura por Porcentaje.
	SET ComXMonto				:= 'M';			-- Comision por Apertura por Monto.
	SET EdoCivilCS				:= 'CS';		-- Estado Civil Casado Bienes Separados
	SET EdoCivilCC				:= 'CC';		-- Estado Civil Casado Bienes Mancomunados con Capitulacion
	SET EdoCivilCM				:= 'CM';		-- Estado Civil Casado Bienes Mancomunados
	SET EdoCivilUnion			:= 'U';			-- Estado Civil Union Libre
	SET FrecPagoUnico			:= 'U';			-- Frecuencia de pago único
    SET FrecLibre               := 'L';
	SET FrecMensual				:= 'M';			-- Frecuencia de pago mensual
    SET FrecPeriodo             := 'P';
	SET TipoGarantiaPrend		:= 2;			-- Tipo de garantía Mobiliaria
	SET TipoGarantiaHipo		:= 3;			-- Tipo de garantía Inmobiliaria
	SET TipoGarantiaGuber		:= 4;			-- Tipo de garantía Gubernamental
	SET TipoElector				:= 1;			-- Tipo de Identificacion Credencial de elector (TIPOSIDENTI)
	SET TasaFija				:= 1;			-- Tipo de Calculo de Interes: Tasa Fija.
	SET TipoHabilitacionAvio	:= 125;			-- Subclasificación de acuerdo a CLASIFICCREDITO
	SET Frec90Dias				:= 90;			-- Frecuencia de 90 días
    SET Frec30Dias              := 30;
	SET RolObligadoSol			:= 'O';			-- Tipo Rol Obligado Solidario
	SET RolAval					:= 'A';			-- Tipo Rol Aval
    SET CompParf5               := ' ';
    SET Var_Parf6               := ' ';
	SELECT
		UPPER(Par.NombreRepresentante),	UPPER(Inst.Nombre),		Par.FechaSistema,
		ClienteInstitucion
	INTO
		Var_NombreRepresentante,		Var_NombreInstitucion,	Var_FechaSistema,
		Var_ClienteInstitucion
	FROM INSTITUCIONES Inst,PARAMETROSSIS Par
		WHERE Inst.InstitucionID  = Par.InstitucionID;

	-- DATOS DEL CRÉDITO
	SELECT	C.ClienteID,		C.SolicitudCreditoID,	C.MontoCredito,		C.FechaAutoriza,
			C.CalcInteresID,	C.TasaBase,				C.DestinoCreID,		C.CuentaID
	INTO	Var_ClienteID,		Var_SolicitudCreditoID,	Var_MontoCredito,	Var_FechaAutoriza,
			Var_CalcInteresID,	Var_TasaBaseID,			Var_DestinoCreID,	Var_CuentaAhoID
	FROM CREDITOS C
		WHERE C.CreditoID = Par_CreditoID;

	-- Se obtiene el valor de la tasa base
	IF(Var_CalcInteresID != TasaFija)THEN
		SET Var_TasaBase := (SELECT Valor FROM TASASBASE WHERE TasaBaseID = Var_TasaBaseID);
	END IF;
	SET Var_TasaBase := IFNULL(Var_TasaBase,Entero_Cero);

	-- CUADRO INFORMATIVO DEL CRÉDITO (PRIMERA HOJA)
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=SeccionPrincipal)THEN
		-- DATOS DEL CREDITO.
		SELECT
			C.MontoCredito,			C.PlazoID,			C.TasaFija,			C.FactorMora,		C.FechaVencimien,
			C.ProductoCreditoID,	P.Descripcion,		P.RegistroRECA,		C.FrecuenciaCap,	C.FrecuenciaInt,
            C.PeriodicidadCap,      C.PeriodicidadInt,  C.NumAmortizacion,   C.TasaFija
		INTO
			Var_MontoCredito,		Var_PlazoID,		Var_TasaFija,		Var_FactorMora,		Var_FechaVencimien,
			Var_ProductoCreditoID,	Var_Descripcion,	Var_RegistroRECA,	Var_FrecuenciaCap,	Var_FrecuenciaInt,
            Var_PeriodicidadCap,    Var_PeriodicidadInt,Var_NumAmortizaciones, TasaOrdinaria
		FROM CREDITOS C INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID=P.ProducCreditoID
			WHERE C.CreditoID = Par_CreditoID;

		SELECT ROUND(Dias/30),	Descripcion
		INTO Var_PlazoMeses,	Var_PlazoDescripcion
		FROM CREDITOSPLAZOS
			WHERE PlazoID = Var_PlazoID;

		SELECT
			UPPER(CONCAT(TRIM(mr.Nombre),', ',TRIM(er.Nombre)))
		INTO
			Var_LugarSucursal
		FROM SUCURSALES su
			LEFT OUTER JOIN ESTADOSREPUB er ON er.EstadoID = su.EstadoID
			LEFT OUTER JOIN MUNICIPIOSREPUB mr ON mr.EstadoID = su.EstadoID
											AND mr.MunicipioID = su.MunicipioID
		WHERE su.SucursalID = Aud_Sucursal;

		SET Var_LugarSucursal := FNCAPITALIZAPALABRA(Var_LugarSucursal);
		SET Var_LugarSucursal := (IFNULL(Var_LugarSucursal, Cadena_Vacia));
		SET Var_LugarSucursal := REPLACE(Var_LugarSucursal, ' De ', ' de ');
		SET Var_LugarSucursal := REPLACE(Var_LugarSucursal, ' Del ', ' del ');
		SET Var_LugarSucursal := REPLACE(Var_LugarSucursal, ' La ', ' la ');
		SET Var_LugarSucursal := REPLACE(Var_LugarSucursal, '  ', ' ');

		-- se agrego la validacion para que cuando el pago sea unico el pagare lo tome como solo un pago
        IF(Var_FrecuenciaCap = 'U' and Var_FrecuenciaInt = 'M') THEN
            SELECT      MAX(FechaExigible),     MAX(Capital)
                INTO    Var_FechaExigible,      Var_Capital
                FROM AMORTICREDITO
                WHERE CreditoID = Par_CreditoID
                GROUP BY CreditoID;

            SET Var_NumAmortizaciones :=1;
        ELSE
			-- Número de Amortizaciones y fecha de la primer amorización
			SELECT
				FechaExigible,		Capital
			INTO
				Var_FechaExigible,	Var_Capital
				FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
				AND AmortizacionID = 1;
		END IF;

         IF(Var_PeriodicidadCap = 0 AND Var_FrecuenciaCap = FrecLibre) THEN
           SET Var_PeriodicidadCap := (SELECT CEILING(AVG(datediff(FechaVencim,FechaInicio))) FROM AMORTICREDITO WHERE CreditoID=Par_CreditoID);
			END IF;

        SET Var_5toParrafo:=(
             CASE WHEN ((Var_FrecuenciaCap = FrecPagoUnico OR Var_FrecuenciaCap = FrecPeriodo)  AND (Var_FrecuenciaInt = FrecPagoUnico OR Var_FrecuenciaInt = FrecPeriodo)) THEN
            'En caso de que a la fecha de pago establecida no se haya liquidado el mismo, al día siguiente del pago vencido y no cubierto en su totalidad el préstamo se dará por vencido totalmente'
             WHEN (Var_FrecuenciaCap = FrecPagoUnico OR Var_FrecuenciaCap = FrecPeriodo)  THEN
            'En caso de que se acumule el importe de tres amortizaciones de interés no pagadas consecutivamente el préstamo se dará por vencido anticipadamente'
             WHEN (Var_PeriodicidadCap < Frec90Dias AND (Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo)) THEN
            'En caso de que se acumule el importe de tres amortizaciones no pagadas consecutivamente,'
             WHEN (Var_PeriodicidadCap > Frec90Dias AND (Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo) AND Var_FrecuenciaCap != FrecLibre) THEN
            'En caso de que a la fecha de pago establecida de la anualidad no se haya liquidado dicho pago, conforme a la tabla de amortización anexa, al día siguiente de la amortización vencida y no pagada,'
             WHEN (Var_FrecuenciaCap = FrecLibre AND Var_FrecuenciaInt = FrecLibre) THEN
            'En caso de que a la fecha de pago establecida de la amortización no se haya liquidado dicho pago, conforme a la tabla de amortización anexa, al día siguiente de la amortización vencida y no pagada,'
             END );

        SET CompParf5 := ' y se le aplicará el interés moratorio a la tasa pactada sobre el saldo de capital vencido que adeude y podrá exigirse el pago total del préstamo. El cálculo de los intereses moratorios se causarán desde la fecha que se origine el incumplimiento y hasta la fecha de su liquidación total, utilizando el procedimiento de días naturales transcurridos con divisor de 360 (trescientos sesenta) días.';
        SET Var_NumAmortizaciones := IFNULL(Var_NumAmortizaciones,Entero_Cero);
		SELECT
			Par_CreditoID AS CreditoID,
			FORMAT(Var_MontoCredito,2) AS MontoCredito,
			REPLACE(LOWER(CONVPORCANT(Var_MontoCredito,'$C','2' ,'')),'m.n.','M.N.') AS MontoLetra,
			FNFECHACOMPLETA(Var_FechaVencimien,3) AS FechaVencimien,
			CONCAT(TRIM(LOWER(CONVPORCANT(Var_TasaFija,'%','2' ,''))), ' anual sobre saldos insolutos') AS TasaInteres,
            CONCAT(TRIM(LOWER(CONVPORCANT(Var_FactorMora*TasaOrdinaria,'%','2' ,''))), '') AS FactorMora,

			LOWER(CONCAT(DAY(Var_FechaSistema),' (',TRIM(FUNCIONSOLONUMLETRAS(DAY(Var_FechaSistema))),') de ',
				FNFECHACOMPLETA(Var_FechaSistema,8),' ',YEAR(Var_FechaSistema),
                ' (',TRIM(FUNCIONSOLONUMLETRAS(YEAR(Var_FechaSistema))),')')) AS FechaSistema,

			LOWER(CONCAT(DAY(Var_FechaExigible),' (',TRIM(FUNCIONSOLONUMLETRAS(DAY(Var_FechaExigible))),') de ',
				FNFECHACOMPLETA(Var_FechaExigible,8),' ',YEAR(Var_FechaExigible),
                ' (',TRIM(FUNCIONSOLONUMLETRAS(YEAR(Var_FechaExigible))),')')) AS FechaExigible,

			REPLACE(LOWER(CONCAT(Var_NumAmortizaciones,' (',
				TRIM(FUNCIONSOLONUMLETRAS(Var_NumAmortizaciones)),') ',
            IF(
				(Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo) AND Var_FrecuenciaCap !=FrecLibre AND Var_FrecuenciaCap !='A', -- CONDICION A CUMPLIR
					CONCAT(IF(Var_NumAmortizaciones > 1, 'amortizaciones', 'amortización'),' ',
									IF(Var_NumAmortizaciones > 1,'mensuales','mensual'),' '),				-- en	Caso	De	Que	Se	Cumpla
                IF(Var_FrecuenciaCap = FrecLibre OR (Var_FrecuenciaCap = 'A'), CONCAT(IF(Var_NumAmortizaciones > 1, 'amortizaciones', 'amortización'),' ', 	-- en Caso De Que No
                        IF(Var_NumAmortizaciones > 1 AND Var_FrecuenciaCap = 'L', 'libre', 'libres'),' ',
                        IF(Var_FrecuenciaCap = 'A','anuales','anual')
                        ),('pago(s)'))											-- en Caso De Que No
                ),
				' de ', TRIM(REPLACE(CONVPORCANT(Var_Capital,'$C','2' ,'N.'),' PESOS','')))),'m.n.','M.N.') AS Amortizaciones,
			CONCAT(
                IF((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo),
					'Dichas amortizaciones serán ',
					'Dicho pago será '), 'a partir del día ',
				LOWER(CONCAT(DAY(Var_FechaExigible),' (',TRIM(FUNCIONSOLONUMLETRAS(DAY(Var_FechaExigible))),') de ',
					FNFECHACOMPLETA(Var_FechaExigible,8),' ',YEAR(Var_FechaExigible),
	                ' (',TRIM(FUNCIONSOLONUMLETRAS(YEAR(Var_FechaExigible))),')')),
                IF((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo) AND Var_FrecuenciaCap != FrecLibre,
					CONCAT(' fecha de la primera amortización y serán pagaderas ​cada ',Var_PeriodicidadCap,' días, '), ' '),
				'​salvo que el día de pago sea inhábil deberá ser realizado conforme a su tabla de amortizaciones.') AS Periodicidad,

			Var_LugarSucursal AS LugarSucursal,
			TRIM(Var_RegistroRECA) AS RECA,
			Var_FrecuenciaCap AS FrecuenciaCap,
			Var_FrecuenciaInt AS FrecuenciaInt,
			Var_PeriodicidadCap AS PeriodicidadCap,
			Var_PeriodicidadInt AS PeriodicidadInt,
            IF((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo)AND Var_PeriodicidadCap > Frec90Dias,Cons_SI,Cons_No) AS MuestraAmortizaciones,
            CASE WHEN ((Var_FrecuenciaCap = FrecPagoUnico OR Var_FrecuenciaCap = FrecPeriodo) AND Var_PeriodicidadCap != Frec30Dias) THEN
             CONCAT(Var_5toParrafo,' ', CompParf5)
             WHEN (Var_FrecuenciaCap = FrecPagoUnico OR Var_FrecuenciaCap = FrecPeriodo)  THEN
             CONCAT(Var_5toParrafo,' ', CompParf5)
             WHEN (Var_PeriodicidadCap < Frec90Dias AND (Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo)) THEN
             CONCAT(Var_5toParrafo,' el préstamo se dará por vencido anticipadamente', CompParf5)
             WHEN (Var_PeriodicidadCap > Frec90Dias AND (Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo)) THEN
             CONCAT(Var_5toParrafo,' el préstamo se dará por vencido anticipadamente ', CompParf5)
             END  AS 5toParrafo,
            CASE WHEN ((Var_FrecuenciaCap = FrecPagoUnico OR Var_FrecuenciaCap = FrecPeriodo)AND (Var_FrecuenciaInt = FrecPagoUnico OR Var_FrecuenciaInt = FrecPeriodo)) THEN
              REPLACE(CONCAT('Valor que he recibido a mi entera satisfacción, que me obligo a pagar en 1 (un) pago de ',
              TRIM(REPLACE(CONVPORCANT(Var_Capital,'$C','2' ,'N.'),' PESOS','')),' más el interés ordinario a razón del ',
              CONCAT(TRIM(LOWER(CONVPORCANT(Var_TasaFija,'%','2' ,''))), ' anual sobre saldos insolutos'),
              ' dichos intereses se generaran a partir del día siguiente del otorgamiento del crédito, más los impuestos que correspondan cuando así lo dispongan las disposiciones fiscales aplicables.',
               CONCAT(
                IF(Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo,
                    'Dichas amortizaciones serán ',
                    'Dicho pago será '), 'a partir del día ',
                LOWER(CONCAT(DAY(Var_FechaExigible),' (',TRIM(FUNCIONSOLONUMLETRAS(DAY(Var_FechaExigible))),') de ',
                    FNFECHACOMPLETA(Var_FechaExigible,8),' ',YEAR(Var_FechaExigible),
                    ' (',TRIM(FUNCIONSOLONUMLETRAS(YEAR(Var_FechaExigible))),')')),
                IF((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo) AND Var_FrecuenciaCap != FrecLibre,
                    CONCAT(' fecha de la primera amortización y serán pagaderas ​cada ',Var_PeriodicidadCap,' días, '), ' '),
                '​salvo que el día de pago sea inhábil deberá ser realizado conforme a su tabla de amortizaciones.')),'m.n.','M.N.')
            WHEN ((Var_FrecuenciaCap = FrecPagoUnico OR Var_FrecuenciaCap = FrecPeriodo) AND (Var_FrecuenciaInt != FrecPagoUnico AND Var_FrecuenciaInt != FrecPeriodo)) THEN
              REPLACE(CONCAT('Valor que he recibido a mi entera satisfacción, que me obligo a pagar en 1 (un) único pago de capital por la cantidad de ',
              TRIM(REPLACE(CONVPORCANT(Var_MontoCredito,'$C','2' ,'N.'),' PESOS','')),' y ', Var_NumAmortizaciones , ' ',
              '(',TRIM(FUNCIONSOLONUMLETRAS(Var_NumAmortizaciones)),')',
              ' pagos mensuales de interés ordinario a razón del ',
              CONCAT(TRIM(LOWER(CONVPORCANT(Var_TasaFija,'%','2' ,''))), ' anual sobre saldos insolutos, '),
              '​dichos intereses se generarán a partir del día siguiente del otorgamiento del crédito, más los impuestos que correspondan cuando así lo dispongan las disposiciones fiscales aplicables.',
               CONCAT('Dichas amortizaciones serán a partir del día ',
                LOWER(CONCAT(DAY(Var_FechaExigible),' (',TRIM(FUNCIONSOLONUMLETRAS(DAY(Var_FechaExigible))),') de ',
                    FNFECHACOMPLETA(Var_FechaExigible,8),' ',YEAR(Var_FechaExigible)
                    ))),
                CONCAT(' y pagaderos los ', LOWER(CONCAT(DAY(Var_FechaExigible),' (',TRIM(FUNCIONSOLONUMLETRAS(DAY(Var_FechaExigible))))),') ','de cada mes​​ salvo que el día de pago sea inhábil deberá ser realizado conforme a su tabla de amortizaciones.')
            ),'m.n.','M.N.')
            WHEN ((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo) AND Var_PeriodicidadCap > Frec90Dias) THEN
              REPLACE(CONCAT('Valor que he recibido a mi entera satisfacción, que me obligo a pagar en ',
              REPLACE(LOWER(CONCAT(Var_NumAmortizaciones,' (',
                TRIM(FUNCIONSOLONUMLETRAS(Var_NumAmortizaciones)),') ',
                IF((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo) AND Var_FrecuenciaCap !=FrecLibre ,
                    CONCAT(IF(Var_NumAmortizaciones > 1, 'amortizaciones', 'amortización'),' ',
                        IF(Var_NumAmortizaciones > 1,'mensuales','mensual'),' '),
                    IF(Var_FrecuenciaCap = FrecLibre, CONCAT(IF(Var_NumAmortizaciones > 1, 'amortizaciones', 'amortización'),' ',
                    IF(Var_NumAmortizaciones > 1, 'libres', 'libre')),('pago(s)'))),
                    ' de ', TRIM(REPLACE(CONVPORCANT(Var_Capital,'$C','2' ,'N.'),' PESOS','')))),'m.n.','M.N.'), ' más el interés ordinario a razón del ',
                    CONCAT(TRIM(LOWER(CONVPORCANT(Var_TasaFija,'%','2' ,''))), ' anual sobre saldos insolutos'), ', dichos intereses se generaran a partir del día siguiente del otorgamiento del crédito, más los impuestos que correspondan cuando así lo dispongan las disposiciones fiscales aplicables.',  CONCAT(
                IF(Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo,
                    'Dichas amortizaciones serán ',
                    'Dicho pago será '), 'a partir del día ',
                LOWER(CONCAT(DAY(Var_FechaExigible),' (',TRIM(FUNCIONSOLONUMLETRAS(DAY(Var_FechaExigible))),') de ',
                    FNFECHACOMPLETA(Var_FechaExigible,8),' ',YEAR(Var_FechaExigible),
                    ' (',TRIM(FUNCIONSOLONUMLETRAS(YEAR(Var_FechaExigible))),')',' fecha de la primera amortización')),
                IF((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo) AND Var_FrecuenciaCap != FrecLibre,
                    CONCAT(' y serán pagaderas ​cada ',Var_PeriodicidadCap,' días, '), ' '),
                '​, salvo que el día de pago sea inhábil deberá ser realizado conforme a su tabla de amortizaciones.')
                    ),'m.n.','M.N.')

              WHEN ((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo)AND Var_PeriodicidadCap < Frec90Dias) THEN
              REPLACE(CONCAT('Valor que he recibido a mi entera satisfacción, que me obligo a pagar en ',
              REPLACE(LOWER(CONCAT(Var_NumAmortizaciones,' (',
                TRIM(FUNCIONSOLONUMLETRAS(Var_NumAmortizaciones)),') ',
                IF((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo)AND Var_FrecuenciaCap !=FrecLibre ,
                    CONCAT(IF(Var_NumAmortizaciones > 1, 'amortizaciones', 'amortización'),' ',
                        IF(Var_NumAmortizaciones > 1,'mensuales','mensual'),' '),
                    IF(Var_FrecuenciaCap = FrecLibre, CONCAT(IF(Var_NumAmortizaciones > 1, 'amortizaciones', 'amortización'),' ',
                    IF(Var_NumAmortizaciones > 1, 'libres', 'libre')),('pago(s)'))),
                    ' de ', TRIM(REPLACE(CONVPORCANT(Var_Capital,'$C','2' ,'N.'),' PESOS','')))),'m.n.','M.N.'), ' más el interés ordinario a razón del ',
                    CONCAT(TRIM(LOWER(CONVPORCANT(Var_TasaFija,'%','2' ,''))), ' anual sobre saldos insolutos'), ', dichos intereses se generaran a partir del día siguiente del otorgamiento del crédito, más los impuestos que correspondan cuando así lo dispongan las disposiciones fiscales aplicables.',  CONCAT(
                IF(Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo,
                    'Dichas amortizaciones serán ',
                    'Dicho pago será '), 'a partir del día ',
                LOWER(CONCAT(DAY(Var_FechaExigible),' (',TRIM(FUNCIONSOLONUMLETRAS(DAY(Var_FechaExigible))),') de ',
                    FNFECHACOMPLETA(Var_FechaExigible,8),' ',YEAR(Var_FechaExigible),
                    ' (',TRIM(FUNCIONSOLONUMLETRAS(YEAR(Var_FechaExigible))),')',' fecha de la primera amortización')),
                IF((Var_FrecuenciaCap != FrecPagoUnico AND Var_FrecuenciaCap != FrecPeriodo) AND Var_FrecuenciaCap != FrecLibre,
                    CONCAT(' y serán pagaderas ​cada ',Var_PeriodicidadCap,' días, '), ' '),
                '​, salvo que el día de pago sea inhábil deberá ser realizado conforme a su tabla de amortizaciones.')
                    ),'m.n.','M.N.')
             END AS Var_Parf6



			;
	END IF;

	-- TIPO DE REPORTE QUE MUESTRA LAS AMORTIZACIONES DE UN CRÉDITO.
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=SeccionAmortizaciones)THEN
		SELECT
			AmortizacionID,
			FechaExigible AS Fecha,
			FNFECHACOMPLETA(FechaExigible,3) AS FechaCompleta,
			FORMAT(Capital,2) AS Monto,
			CONVPORCANT(Capital,'$C','2' ,'') AS MontoLetra
			FROM AMORTICREDITO
		WHERE CreditoID = Par_CreditoID;
	END IF;

	-- TIPO DE REPORTE DATOS DEL ACREDITADO.
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=SeccionAcreditado)THEN
		-- DATOS DE CLIENTE
		SELECT
			Cli.NombreCompleto,		FNGENDIRECCION(2, Dir.EstadoID, Dir.MunicipioID, Dir.LocalidadID, Dir.ColoniaID,
									Dir.Calle, Dir.NumeroCasa, Dir.NumInterior, Dir.Piso, Dir.PrimeraEntreCalle,
									Dir.SegundaEntreCalle, Dir.CP, Dir.Descripcion, Dir.Lote, Dir.Manzana) AS DireccionCompleta,	Dir.CP,
			UPPER(CONCAT(Col.TipoAsenta,' ',Col.Asentamiento)) AS NomColonia,
			UPPER(Loc.NombreLocalidad) AS NomLocalidad,
			UPPER(Mun.Nombre) AS NomMunicipio,
			UPPER(Est.Nombre) AS NomEstado, 'MÉXICO' AS NomPais
		FROM CLIENTES Cli
			INNER JOIN DIRECCLIENTE		Dir ON Cli.ClienteID = Dir.ClienteID AND Dir.Oficial = Cons_SI
			INNER JOIN ESTADOSREPUB		Est ON Dir.EstadoID = Est.EstadoID
			INNER JOIN MUNICIPIOSREPUB	Mun ON Dir.EstadoID = Mun.EstadoID AND Dir.MunicipioID = Mun.MunicipioID
			INNER JOIN LOCALIDADREPUB	Loc ON Dir.EstadoID = Loc.EstadoID AND Dir.MunicipioID = Loc.MunicipioID
																		   AND Dir.LocalidadID = Loc.LocalidadID
			LEFT OUTER JOIN COLONIASREPUB Col ON Dir.EstadoID = Col.EstadoID AND Dir.MunicipioID = Col.MunicipioID
																		   AND Dir.ColoniaID = Col.ColoniaID
		WHERE Cli.ClienteID = Var_ClienteID;
	END IF;

	-- TIPO DE REPORTE OBLIGADO SOLIDARIO
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=SeccionObligSol)THEN
		DELETE FROM TMPAVALESTAMAZ WHERE CreditoID=Par_CreditoID;

		INSERT INTO TMPAVALESTAMAZ (
			AvalID,		ClienteID,		ProspectoID,	DireccionCompleta, CreditoID,
			Rol)
		SELECT
			IFNULL(ASOL.AvalID, Entero_Cero),	IFNULL(ASOL.ClienteID, Entero_Cero),		IFNULL(ASOL.ProspectoID, Entero_Cero), Cadena_Vacia, Par_CreditoID,	RolAval
			FROM AVALESPORSOLICI ASOL
			WHERE ASOL.SolicitudCreditoID = Var_SolicitudCreditoID
				AND ASOL.Estatus = EstatusAutorizado;

        INSERT INTO TMPAVALESTAMAZ (
            AvalID,     ClienteID,      ProspectoID,    DireccionCompleta, CreditoID,
            Rol)
        SELECT
            IFNULL(OSOL.OblSolidID, Entero_Cero),   IFNULL(OSOL.ClienteID, Entero_Cero),        IFNULL(OSOL.ProspectoID, Entero_Cero), Cadena_Vacia, Par_CreditoID, RolObligadoSol
            FROM OBLSOLIDARIOSPORSOLI OSOL
            WHERE OSOL.SolicitudCreditoID = Var_SolicitudCreditoID
                AND OSOL.Estatus = EstatusAutorizado;
		-- Avales que son clientes
		UPDATE TMPAVALESTAMAZ T INNER JOIN CLIENTES C ON T.ClienteID=C.ClienteID
			LEFT OUTER JOIN DIRECCLIENTE D ON (C.ClienteID=D.ClienteID AND D.Oficial = Cons_SI)
		SET T.DireccionCompleta = FNGENDIRECCION(2, D.EstadoID, D.MunicipioID, D.LocalidadID, D.ColoniaID,
									D.Calle, D.NumeroCasa, D.NumInterior, D.Piso, D.PrimeraEntreCalle,
									D.SegundaEntreCalle, D.CP, D.Descripcion, D.Lote, D.Manzana),
			T.ColoniaID			= D.ColoniaID,
			T.LocalidadID		= D.LocalidadID,
			T.MunicipioID		= D.MunicipioID,
			T.EstadoID			= D.EstadoID,
			T.NombreCompleto	= C.NombreCompleto,
			T.CP				= D.CP
			WHERE T.ClienteID != Entero_Cero
				AND T.CreditoID = Par_CreditoID;


		-- Avales que son sólo prospectos
		UPDATE TMPAVALESTAMAZ T INNER JOIN PROSPECTOS P ON (T.ProspectoID=P.ProspectoID)
		SET T.DireccionCompleta = FNGENDIRECCION(2, P.EstadoID, P.MunicipioID, P.LocalidadID, P.ColoniaID,
									P.Calle, P.NumExterior, P.NumInterior, Cadena_Vacia, Cadena_Vacia,
									Cadena_Vacia, P.CP, Cadena_Vacia, P.Lote, P.Manzana),
			T.ColoniaID			= P.ColoniaID,
			T.LocalidadID		= P.LocalidadID,
			T.MunicipioID		= P.MunicipioID,
			T.EstadoID			= P.EstadoID,
			T.NombreCompleto	= P.NombreCompleto,
			T.CP				= P.CP
			WHERE T.ClienteID = Entero_Cero
				AND T.CreditoID = Par_CreditoID
				AND T.ProspectoID != Entero_Cero
				AND T.AvalID = Entero_Cero;
        UPDATE TMPAVALESTAMAZ T INNER JOIN AVALES A ON (T.AvalID=A.AvalID)
        SET T.DireccionCompleta = FNGENDIRECCION(2, A.EstadoID, A.MunicipioID, A.LocalidadID, A.ColoniaID,
                                    A.Calle, A.NumExterior, A.NumInterior, Cadena_Vacia, Cadena_Vacia,
                                    Cadena_Vacia, A.CP, Cadena_Vacia, A.Lote, A.Manzana),
            T.ColoniaID         = A.ColoniaID,
            T.LocalidadID       = A.LocalidadID,
            T.MunicipioID       = A.MunicipioID,
            T.EstadoID          = A.EstadoID,
            T.NombreCompleto    = A.NombreCompleto,
            T.CP                = A.CP
            WHERE   T.Rol = RolAval
                AND T.AvalID != Entero_Cero
                AND T.CreditoID = Par_CreditoID
                AND T.ClienteID = Entero_Cero
                AND T.ProspectoID = Entero_Cero;
        UPDATE TMPAVALESTAMAZ T INNER JOIN OBLIGADOSSOLIDARIOS Obl ON (T.AvalID=Obl.OblSolidID)
        SET T.DireccionCompleta = FNGENDIRECCION(2, Obl.EstadoID, Obl.MunicipioID, Obl.LocalidadID, Obl.ColoniaID,
                                   Obl.Calle, Obl.NumExterior, Obl.NumInterior, Cadena_Vacia, Cadena_Vacia,
                                    Cadena_Vacia, Obl.CP, Cadena_Vacia, Obl.Lote, Obl.Manzana),
            T.ColoniaID         = Obl.ColoniaID,
            T.LocalidadID       = Obl.LocalidadID,
            T.MunicipioID       = Obl.MunicipioID,
            T.EstadoID          = Obl.EstadoID,
            T.NombreCompleto    = Obl.NombreCompleto,
            T.CP                = Obl.CP
            WHERE   T.Rol = RolObligadoSol
                AND T.AvalID != Entero_Cero
                AND T.CreditoID = Par_CreditoID
                AND T.ClienteID = Entero_Cero
                AND T.ProspectoID = Entero_Cero;

		UPDATE TMPAVALESTAMAZ T
			INNER JOIN ESTADOSREPUB		Est ON T.EstadoID = Est.EstadoID
			INNER JOIN MUNICIPIOSREPUB	Mun ON T.EstadoID = Mun.EstadoID AND T.MunicipioID = Mun.MunicipioID
			INNER JOIN LOCALIDADREPUB	Loc ON T.EstadoID = Loc.EstadoID AND T.MunicipioID = Loc.MunicipioID
																		 AND T.LocalidadID = Loc.LocalidadID
			LEFT OUTER JOIN COLONIASREPUB Col ON T.EstadoID = Col.EstadoID AND T.MunicipioID = Col.MunicipioID
																		 AND T.ColoniaID = Col.ColoniaID
		SET
			T.NomColonia = UPPER(CONCAT(Col.TipoAsenta,' ',Col.Asentamiento)),
			T.NomLocalidad = UPPER(Loc.NombreLocalidad),
			T.NomMunicipio = UPPER(Mun.Nombre),
			T.NomEstado = UPPER(Est.Nombre)
		WHERE T.CreditoID = Par_CreditoID;

		SELECT
			T.NombreCompleto,	T.DireccionCompleta,	T.NomColonia,	T.NomLocalidad,	T.NomMunicipio,
			T.NomEstado,		T.Pais AS NomPais,		T.CP
		FROM TMPAVALESTAMAZ T
			WHERE T.CreditoID = Par_CreditoID
			AND T.Rol = RolObligadoSol;
	END IF;

	-- TIPO DE REPORTE AVALES
	IF(IFNULL(Par_TipoReporte,Entero_Cero)=SeccionAvales)THEN
		SELECT
			T.NombreCompleto,	T.DireccionCompleta,	T.NomColonia,	T.NomLocalidad,	T.NomMunicipio,
			T.NomEstado,		T.Pais AS NomPais,		T.CP
		FROM TMPAVALESTAMAZ T
			WHERE T.CreditoID = Par_CreditoID
			AND T.Rol = RolAval;
	END IF;

END TerminaStore$$