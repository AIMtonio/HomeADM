-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA041700006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA041700006REP`;DELIMITER $$

CREATE PROCEDURE `REGA041700006REP`(
	/* -- Genera el reporte 417 para el formato SOCAP ---- */
	Par_Fecha           DATETIME,
	Par_NumReporte      TINYINT UNSIGNED,

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN

	DECLARE	Var_ClaveEntidad	VARCHAR(300);
	DECLARE Var_Periodo			CHAR(6);
	DECLARE Var_UltFecEPRC 		DATE;


	DECLARE Rep_Excel       	INT;
	DECLARE Rep_Csv				INT;
	DECLARE tipomoneda			INT;
	DECLARE Tipo_Cartera		INT;
	DECLARE Tipo_EPRC			INT;
	DECLARE folio_form			CHAR(4);
	DECLARE Tipo_Saldo			CHAR(1);
	DECLARE Tipo_EPRC_CAL		CHAR(3);
	DECLARE Tipo_EPRC_ADI   	CHAR(3);
	DECLARE Nivel_D				CHAR(1);
	DECLARE Nivel_Encabezado	CHAR(1);
	DECLARE ESTCRE_VENCIDO		CHAR(1);
	DECLARE CLASIF_REEST		CHAR(1);
	DECLARE Rest_ORI_NA			CHAR(3);
	DECLARE CADENA_VACIA		CHAR(1);
	DECLARE Cla_Comercial   	CHAR(1);
	DECLARE Cla_Consumo     	CHAR(1);
	DECLARE Cla_Vivienda    	CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Res_NO				CHAR(1);
	DECLARE Res_SI				CHAR(1);
	DECLARE Fecha_Vacia			DATE;

	SET Rep_Excel       	:=  1;          -- Reporte tipo Excel
	SET Rep_Csv         	:=  2;  		-- Reporte tipo csv
	SET tipomoneda      	:=  14;         -- clave de moneda pesos
	SET folio_form     		:=  '417';      -- Clave del formulario
	SET Tipo_Saldo      	:=  '1';        -- Clave tipo de saldo

    SET Tipo_Cartera    	:=  9; 			-- Clave saldo cartera
	SET Tipo_EPRC       	:=  10; 		-- Clave saldo eprc
	SET Tipo_EPRC_CAL   	:=  'CAL';     -- Tipo eprc de calificacion
	SET Tipo_EPRC_ADI   	:=  'ADI';     -- Tipo eprc adicional
	SET Nivel_D			       :=  'D';       -- Nivel detalle

    SET Nivel_Encabezado    :=  'E';       -- Nivel Encabezado
	SET ESTCRE_VENCIDO  	:=  'B';       -- Creditos vencidos
 	SET CLASIF_REEST    	:=  'R';       -- Credtios reestructurados
	SET Rest_ORI_NA     	:=  'na';      -- Origen No Aplica
	SET CADENA_VACIA    	:=  '';        -- Cadena vacia

	SET Cla_Comercial   	:= 'C';        -- Clasificacion comercial
	SET Cla_Consumo     	:= 'O';        -- Clasificacion consumo
	SET Cla_Vivienda    	:= 'H';        -- Clasificacion vivienda
	SET Fecha_Vacia     	:= '1900-01-01'; -- Fecha vacia
	SET Res_NO         		:= 'N';        -- Respuesta NO
	SET Res_SI				:= 'S';			-- Respuesta SI
	SET Fecha_Vacia			:= '1900-01-01'; -- Fecha vacia
	SET Entero_Cero			:= 0;

	SELECT  MAX(Fecha) INTO Var_UltFecEPRC
		FROM  CALRESCREDITOS
		WHERE  Fecha <= Par_Fecha;

	SET Var_UltFecEPRC := IFNULL(Var_UltFecEPRC,  Fecha_Vacia);

	SET Var_Periodo = CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),1,4),
							  SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),5,2));

	SET Var_ClaveEntidad	:= IFNULL((SELECT Ins.ClaveEntidad
										FROM PARAMETROSSIS Par,
											 INSTITUCIONES Ins
										WHERE Par.InstitucionID = Ins.InstitucionID), CADENA_VACIA);




	DROP TABLE IF EXISTS TMP_REG417;

	CREATE temporary TABLE TMP_REG417(
		Clasificacion	CHAR(2),
		TipoCredito		CHAR(1),
		DiasAtraso		INT,
		MontoCartera	DECIMAL(16,2),
		MontoEPRC		DECIMAL(16,2),
		TipoEPRC		VARCHAR(3),

		INDEX TMP_REG417_idx1 (Clasificacion, TipoCredito, DiasAtraso));




	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, Res_NO,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido),
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido), Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		GROUP BY Des.Clasificacion;







	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, Res_NO,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido) * -1,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido) * -1, Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND Des.Clasificacion = Cla_Vivienda
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) = Entero_Cero
		GROUP BY Des.Clasificacion;


	INSERT INTO TMP_REG417
		SELECT	Cla_Consumo, Res_NO,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido),
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido), Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND Des.Clasificacion = Cla_Vivienda
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) = Entero_Cero
		GROUP BY Des.Clasificacion;






	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, Res_NO,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido) * -1,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido) * -1, Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND Des.Clasificacion = Cla_Consumo
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) > Entero_Cero
		GROUP BY Des.Clasificacion;

	INSERT INTO TMP_REG417
		SELECT	Cla_Vivienda, Res_NO,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido),
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido), Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND Des.Clasificacion = Cla_Consumo
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) > Entero_Cero
		GROUP BY Des.Clasificacion;



	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, CLASIF_REEST,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido),
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido), Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		GROUP BY Des.Clasificacion;







	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, CLASIF_REEST,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido) * -1,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido) * -1, Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND Des.Clasificacion = Cla_Vivienda
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) = Entero_Cero
		GROUP BY Des.Clasificacion;


	INSERT INTO TMP_REG417
		SELECT	Cla_Consumo, CLASIF_REEST,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido),
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido), Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND Des.Clasificacion = Cla_Vivienda
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) = Entero_Cero
		GROUP BY Des.Clasificacion;






	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, CLASIF_REEST,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido) * -1,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido) * -1, Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND Des.Clasificacion = Cla_Consumo
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) > Entero_Cero
		GROUP BY Des.Clasificacion;

	INSERT INTO TMP_REG417
		SELECT	Cla_Vivienda, CLASIF_REEST,
				Entero_Cero,
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido),
				SUM(Sal.SalIntVencido + Sal.SalIntProvision + Sal.SaldoMoraVencido), Tipo_EPRC_ADI

		FROM DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Sal.FechaCorte  = Par_Fecha
		  AND Sal.EstatusCredito = ESTCRE_VENCIDO
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND Des.Clasificacion = Cla_Consumo
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) > Entero_Cero
		GROUP BY Des.Clasificacion;







	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, Res_NO,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes),
				SUM(Res.Reserva), Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.DestinoCreID = Des.DestinoCreID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;



	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, CLASIF_REEST,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes),
				SUM(Res.Reserva), Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;







	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, Res_NO,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes) * -1,
				SUM(Res.Reserva) * -1, Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.DestinoCreID = Des.DestinoCreID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		  AND Des.Clasificacion = Cla_Vivienda
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) = Entero_Cero
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;


	INSERT INTO TMP_REG417
		SELECT	Cla_Consumo, Res_NO,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes),
				SUM(Res.Reserva), Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.DestinoCreID = Des.DestinoCreID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		  AND Des.Clasificacion = Cla_Vivienda
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) = Entero_Cero
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;






	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, Res_NO,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes) * -1,
				SUM(Res.Reserva) *-1, Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.DestinoCreID = Des.DestinoCreID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		  AND Des.Clasificacion = Cla_Consumo
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) > Entero_Cero
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;

	INSERT INTO TMP_REG417
		SELECT	Cla_Vivienda, Res_NO,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes),
				SUM(Res.Reserva), Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.DestinoCreID = Des.DestinoCreID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) = Rest_ORI_NA
		  AND Des.Clasificacion = Cla_Consumo
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) > Entero_Cero
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;








	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, CLASIF_REEST,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes) * -1,
				SUM(Res.Reserva) * -1, Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.DestinoCreID = Des.DestinoCreID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		  AND Des.Clasificacion = Cla_Vivienda
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) = Entero_Cero
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;



	INSERT INTO TMP_REG417
		SELECT	Cla_Consumo, CLASIF_REEST,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes),
				SUM(Res.Reserva), Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.DestinoCreID = Des.DestinoCreID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		  AND Des.Clasificacion = Cla_Vivienda
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) = Entero_Cero
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;






	INSERT INTO TMP_REG417
		SELECT	Des.Clasificacion, CLASIF_REEST,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes) * -1,
				SUM(Res.Reserva) *-1, Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.DestinoCreID = Des.DestinoCreID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		  AND Des.Clasificacion = Cla_Consumo
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) > Entero_Cero
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;

	INSERT INTO TMP_REG417
		SELECT	Cla_Vivienda, CLASIF_REEST,
				Sal.DiasAtraso,
				SUM(Res.Capital + Res.Interes),
				SUM(Res.Reserva), Tipo_EPRC_CAL

		FROM CALRESCREDITOS Res,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre,
			 SALDOSCREDITOS Sal

		LEFT OUTER JOIN REESTRUCCREDITO Rest ON Sal.CreditoID = Rest.CreditoDestinoID
		LEFT OUTER JOIN CREGARPRENHIPO Gar ON Gar.CreditoID = Sal.CreditoID AND Gar.GarHipotecaria > Entero_Cero

		WHERE Res.Fecha = Par_Fecha
		  AND Res.Fecha = Sal.FechaCorte
		  AND Res.CreditoID = Sal.CreditoID
		  AND Sal.DestinoCreID = Des.DestinoCreID
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cre.DestinoCreID = Des.DestinoCreID
		  AND IFNULL(Rest.Origen, Rest_ORI_NA) != Rest_ORI_NA
		  AND Des.Clasificacion = Cla_Consumo
		  AND IFNULL(Gar.GarHipotecaria, Entero_Cero) > Entero_Cero
		GROUP BY Des.Clasificacion, Sal.DiasAtraso;



	DROP TABLE IF EXISTS TMP_CATCONCREGULA417;

	CREATE temporary TABLE TMP_CATCONCREGULA417(
	  ConceptoID 		INT(11),
	  CuentaMayor 		VARCHAR(45),
	  ClaveConcepto 	VARCHAR(45),
	  Descripcion 		VARCHAR(400),
	  TipoCartera 		INT(11),
	  Clasificacion 	CHAR(2),
	  MinDiasAtraso 	INT(11),
	  MaxDiasAtraso 	INT(11),
	  Nivel 			CHAR(1),
	  Orden 			INT(11),
	  TipoCredito 		CHAR(1),
	  Monto 			DECIMAL(16,2),
	  TipoEPRC 			VARCHAR(3),
	  OrdenExcell		INT,

	INDEX TMP_CATCONCREGULA417_idx1 (ClaveConcepto));


	DROP TABLE IF EXISTS TMP_CTASMAYORREG;

	CREATE temporary TABLE TMP_CTASMAYORREG(
	  ConceptoID		INT(11),
	  CuentaMayor 		VARCHAR(45),
	  ClaveConcepto 	VARCHAR(45),
	  Descripcion 		VARCHAR(400),
	  TipoCartera 		INT(11),
	  Clasificacion 	CHAR(2),
	  MinDiasAtraso 	INT(11),
	  MaxDiasAtraso 	INT(11),
	  Nivel 			CHAR(1),
	  Orden 			INT(11),
	  TipoCredito 		CHAR(1),
	  Monto 			DECIMAL(16,2),
	  TipoEPRC 			VARCHAR(3),

	  INDEX TMP_CTASMAYORREG_idx1 (ClaveConcepto));

	INSERT INTO TMP_CATCONCREGULA417
		SELECT 	ConceptoID, 	CuentaMayor,
				ClaveConcepto, 	Descripcion, 	TipoCartera,
				Clasificacion, 	MinDiasAtraso,	MaxDiasAtraso,	Nivel,
				Orden,			TipoCredito,
				Entero_Cero AS Monto,		trim(TipoEPRC),
				OrdenExcell
		FROM  CATCONCREGULA417
        WHERE TipoInstitID = 6;


	UPDATE TMP_CATCONCREGULA417 Reg  SET
		Reg.Monto = (SELECT  IFNULL(SUM(Tem.MontoCartera), Entero_Cero)
						FROM  TMP_REG417 Tem
						WHERE Reg.TipoCredito = Tem.TipoCredito
						  AND Reg.Clasificacion = Tem.Clasificacion
						  AND Reg.MaxDiasAtraso != -1
						  AND Reg.MinDiasAtraso != -1
						  AND Reg.Nivel = Nivel_D
						  AND Reg.TipoCartera = Tipo_Cartera
						  AND Reg.TipoEPRC = Tipo_EPRC_CAL
						  AND Tem.TipoEPRC = Tipo_EPRC_CAL
						  AND Reg.TipoEPRC = Tem.TipoEPRC
						  AND Tem.DiasAtraso BETWEEN Reg.MinDiasAtraso AND Reg.MaxDiasAtraso )
		WHERE  Reg.TipoCartera = Tipo_Cartera
		  AND Reg.TipoEPRC = Tipo_EPRC_CAL;

	UPDATE TMP_CATCONCREGULA417 Reg  SET
		Reg.Monto = (SELECT  IFNULL(SUM(Tem.MontoEPRC), Entero_Cero)
						FROM  TMP_REG417 Tem
						WHERE  Reg.TipoCredito = Tem.TipoCredito
						  AND Reg.Clasificacion = Tem.Clasificacion
						  AND Reg.MaxDiasAtraso != -1
						  AND Reg.MinDiasAtraso != -1
						  AND Reg.Nivel = Nivel_D
						  AND Reg.TipoCartera = Tipo_EPRC
						  AND Reg.TipoEPRC = Tipo_EPRC_CAL
						  AND Tem.TipoEPRC = Tipo_EPRC_CAL
						  AND Reg.TipoEPRC = Tem.TipoEPRC
						  AND Tem.DiasAtraso BETWEEN Reg.MinDiasAtraso AND Reg.MaxDiasAtraso )
		WHERE  Reg.TipoCartera = Tipo_EPRC
		  AND Reg.TipoEPRC = Tipo_EPRC_CAL;




	UPDATE TMP_CATCONCREGULA417 Reg  SET
		Reg.Monto = (SELECT  IFNULL(SUM(Tem.MontoCartera), Entero_Cero)
						FROM  TMP_REG417 Tem
						WHERE  Reg.TipoCredito = Tem.TipoCredito
						  AND Reg.Clasificacion = Tem.Clasificacion
						  AND Reg.MaxDiasAtraso = -1
						  AND Reg.MinDiasAtraso = -1
						  AND Reg.Nivel = Nivel_D
						  AND Reg.TipoCartera = Tipo_Cartera
						  AND trim(Reg.TipoEPRC) = Tipo_EPRC_ADI
						  AND trim(Tem.TipoEPRC) = Tipo_EPRC_ADI
						  AND trim(Reg.TipoEPRC) = trim(Tem.TipoEPRC) )
		WHERE  Reg.TipoCartera = Tipo_Cartera
		  AND trim(Reg.TipoEPRC) = Tipo_EPRC_ADI;

	UPDATE TMP_CATCONCREGULA417 Reg  SET
		Reg.Monto = (SELECT  IFNULL(SUM(Tem.MontoEPRC), Entero_Cero)
						FROM  TMP_REG417 Tem
						WHERE  Reg.TipoCredito = Tem.TipoCredito
						  AND Reg.Clasificacion = Tem.Clasificacion
						  AND Reg.MaxDiasAtraso = -1
						  AND Reg.MinDiasAtraso = -1
						  AND Reg.Nivel = Nivel_D
						  AND Reg.TipoCartera = Tipo_EPRC
						  AND Reg.TipoEPRC = Tipo_EPRC_ADI
						  AND Tem.TipoEPRC = Tipo_EPRC_ADI
						  AND Reg.TipoEPRC = Tem.TipoEPRC )
		WHERE  Reg.TipoCartera = Tipo_EPRC
		  AND Reg.TipoEPRC = Tipo_EPRC_ADI;


	INSERT INTO TMP_CTASMAYORREG
		SELECT	ConceptoID,		CuentaMayor,	ClaveConcepto,	Descripcion,	TipoCartera,
				Clasificacion,	MinDiasAtraso,	MaxDiasAtraso,	Nivel,			Orden,
				TipoCredito,	Monto,			TipoEPRC

			FROM TMP_CATCONCREGULA417
			WHERE Nivel = Nivel_D;


	UPDATE TMP_CATCONCREGULA417 Reg SET
		Reg.Monto = (SELECT SUM(Det.Monto)
						FROM TMP_CTASMAYORREG Det
						WHERE Det.Nivel = Nivel_D
						  AND CONCAT(CONVERT(Det.TipoCartera, CHAR), Det.ClaveConcepto) LIKE CONCAT(Reg.CuentaMayor, '%')
						  AND Reg.TipoCartera = Det.TipoCartera )

		WHERE Reg.Nivel = Nivel_Encabezado;


	IF( Par_NumReporte = Rep_Excel) THEN

		DROP TABLE IF EXISTS TMP_EXCELLREG417;

		CREATE temporary TABLE TMP_EXCELLREG417(
			ClaveConcepto 	VARCHAR(45),
			Descripcion 	VARCHAR(400),
			MontoCartera	DECIMAL(16,2),
			MontoEPRC		DECIMAL(16,2),
			OrdenExcell		INT,

		INDEX TMP_EXCELLREG417_idx1 (ClaveConcepto));


		INSERT INTO TMP_EXCELLREG417
			SELECT ClaveConcepto, MAX(Descripcion), Entero_Cero, Entero_Cero, MIN(OrdenExcell)
				FROM TMP_CATCONCREGULA417
				GROUP BY ClaveConcepto;

		UPDATE TMP_EXCELLREG417 Tmp, TMP_CATCONCREGULA417 Reg SET
			Tmp.MontoCartera = ROUND(Reg.Monto,Entero_Cero)

			WHERE Tmp.ClaveConcepto = Reg.ClaveConcepto
			  AND Reg.TipoCartera = Tipo_Cartera;

		UPDATE TMP_EXCELLREG417 Tmp, TMP_CATCONCREGULA417 Reg SET
			Tmp.MontoEPRC = ROUND(Reg.Monto * -1,Entero_Cero)

			WHERE Tmp.ClaveConcepto = Reg.ClaveConcepto
			  AND Reg.TipoCartera = Tipo_EPRC;

		SELECT 	ClaveConcepto, 	Descripcion, MontoCartera, MontoEPRC
			FROM  TMP_EXCELLREG417
			ORDER BY OrdenExcell;

		DROP TABLE IF EXISTS TMP_EXCELLREG417;

	ELSE
			IF( Par_NumReporte = Rep_Csv) THEN
				SELECT  CONCAT(ClaveConcepto,';',
								folio_form,';',
                                tipomoneda,';',
								TipoCartera,';',Tipo_Saldo,';',
								CASE WHEN TipoCartera = Tipo_Cartera THEN ROUND(Monto,Entero_Cero)
									ELSE ROUND(Monto * -1,Entero_Cero)
								END) AS Valor
				FROM  TMP_CATCONCREGULA417
				ORDER BY Orden;
			END IF;
	END IF;

DROP TABLE IF EXISTS TMP_CATCONCREGULA417;
DROP TABLE IF EXISTS TMP_REG417;

END TerminaStore$$