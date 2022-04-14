-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREGRUPOSNOSOLLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREGRUPOSNOSOLLIS`;DELIMITER $$

CREATE PROCEDURE `CREGRUPOSNOSOLLIS`(
Par_SegmentoID		BIGINT(12), -- ID del Grupo No Solidario
Par_EmpresaID		INT(11),
Aud_Usuario			INT(11),
Aud_FechaActual		DATETIME,
Aud_DireccionIP		VARCHAR(15),

Aud_ProgramaID		VARCHAR(50),
Aud_Sucursal		INT(11),
Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
#Declaracion de Variables
DECLARE Var_AdeudoTot		DECIMAL(14,2);
DECLARE Var_CuentaID		BIGINT(12);
DECLARE Var_CreditoID 		BIGINT(12);
DECLARE Var_ClienteID		INT(11);
DECLARE Var_Saldo			DECIMAL(14,2);
DECLARE Var_PagoMin			DECIMAL(14,2);
DECLARE Var_TotAdeudo       VARCHAR(20);
DECLARE Var_MontoExigible	VARCHAR(30);
DECLARE Var_FechaExigible	VARCHAR(20);
DECLARE VarCuentaAhoID		BIGINT(12);
DECLARE VarClienteID		INT(11);
DECLARE VarCreditoID		BIGINT(12);
DECLARE VarProducCreditoID	INT(11);
DECLARE VarSaldo			DECIMAL(14,2);
DECLARE VarPagoMinimo		DECIMAL(14,2);
DECLARE VarPagoMensual		DECIMAL(14,2);
DECLARE VarGastosCobranza	DECIMAL(14,2);
DECLARE VarFechaUltAbono	DATE;
DECLARE VarEstatus			VARCHAR(10);
DECLARE VarInteresOrd		DECIMAL(14,2);
DECLARE VarIvaIntOrd		DECIMAL(14,2);
DECLARE VarInteresMor		DECIMAL(14,2);
DECLARE VarIvaIntMor		DECIMAL(14,2);
DECLARE VarTasa				DECIMAL(12,4);

#Declaracion de constantes
DECLARE  Entero_Cero	INT;
DECLARE  Cadena_Vacia	CHAR(1);
DECLARE  Var_NO			CHAR(1);
DECLARE  NumConProxPag	INT;
DECLARE  Fecha_Vacia	DATE;

/*DECLARACION DE CURSORES */
DECLARE CURSORCRE CURSOR FOR

 SELECT	MAX(CON.CuentaID) AS CuentaID,	MAX(CON.ClienteID) AS Num_Socio,	CON.CreditoID AS Num_Cta, MAX(CON.ProductoCreditoID) AS Id_Cuenta,
		FUNCIONTOTDEUDACRE(CON.CreditoID) AS Saldo,
		FUNCIONCREPROXPAGO(CON.CreditoID,Var_NO) AS PagoMensual,
		MAX(CON.GastosCobranza) AS GastosCobranza,
		CONCAT(IFNULL(MAX(CON.FechaPago),Fecha_Vacia), 'T',CURRENT_TIME) AS FechaUltAbono,
		MAX(CON.Estatus) AS Estatus,
		SUM(TasaFija) AS TasaInteres
	FROM(SELECT IFNULL(MAX(DP.FechaPago),Fecha_Vacia) AS FechaPago, MAX(IGN.ClienteID) AS ClienteID,
				CRE.CreditoID, MAX(CRE.CuentaID) AS CuentaID, MAX(CRE.ProductoCreditoID) AS ProductoCreditoID,
				SUM(CRE.SaldComFaltPago+CRE.SalIVAComFalPag) AS GastosCobranza,
				CASE MAX(CRE.Estatus) WHEN 'V' THEN 1
									  WHEN 'B' THEN 2
				ELSE 0 END AS Estatus, SUM(CRE.TasaFija) AS TasaFija
			FROM INTEGRAGRUPONOSOL IGN
				INNER JOIN GRUPOSNOSOLIDARIOS GN ON GN.GrupoID=IGN.GrupoID
				INNER JOIN CREDITOS CRE ON IGN.ClienteID=CRE.ClienteID AND (CRE.Estatus	='V' OR CRE.Estatus='B' )
				LEFT OUTER JOIN DETALLEPAGCRE DP	ON CRE.CreditoID=DP.CreditoID
				AND IGN.ClienteID		= DP.ClienteID
				GROUP BY CRE.CreditoID, DP.FechaPago
				ORDER BY DP.FechaPago DESC) AS CON,
		INTEGRAGRUPONOSOL IGN,
		GRUPOSNOSOLIDARIOS GN
	WHERE	GN.GrupoID		= Par_SegmentoID
		AND GN.GrupoID		= IGN.GrupoID
		AND IGN.ClienteID	= CON.ClienteID
		GROUP BY CON.CreditoID;

#Asignacion de constantes
SET Entero_Cero		:=  0;
SET Cadena_Vacia	:= '';
SET Var_NO			:= 'N';
SET NumConProxPag := 9 ;
SET Fecha_Vacia		:= '1900-01-01';

DROP TABLE IF EXISTS TMPCONCEPTOSCREWS;
CREATE TEMPORARY TABLE TMPCONCEPTOSCREWS(
	CuentaAhoID		BIGINT(12),
	ClienteID		INT(11),
	CreditoID		BIGINT(12),
	ProducCreditoID	INT(11),
	Saldo			DECIMAL(14,2),
	PagoMinimo		DECIMAL(14,2),
	PagoMensual		DECIMAL(14,2),
	GastosCobranza	DECIMAL(14,2),
	FechaUltAbono	DATE,
	Estatus			VARCHAR(10),
	InteresOrd		DECIMAL(14,2),
	IvaIntOrd		DECIMAL(14,2),
	InteresMor		DECIMAL(14,2),
	IvaIntMor		DECIMAL(14,2),
	Tasa			DECIMAL(12,4),
    INDEX(CuentaAhoID,ClienteID,CreditoID)
	);

OPEN  CURSORCRE;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP
		FETCH CURSORCRE  INTO
			VarCuentaAhoID,		VarClienteID,		VarCreditoID,		VarProducCreditoID,		VarSaldo,
			VarPagoMensual,		VarGastosCobranza,	VarFechaUltAbono,	VarEstatus,				VarTasa;

			/* so que devuelve conceptos que se necesitan de un credito especifico.*/
		CALL CRECONCEPTOSCON(
			VarCreditoID,	VarPagoMinimo,	VarInteresOrd,		VarIvaIntOrd,		VarInteresMor,
			VarIvaIntMor,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		INSERT INTO TMPCONCEPTOSCREWS VALUES (
			VarCuentaAhoID,	VarClienteID,	VarCreditoID,			VarProducCreditoID,	VarSaldo,
			VarPagoMinimo,	VarPagoMensual,	VarGastosCobranza,		VarFechaUltAbono,	VarEstatus,
			VarInteresOrd,	VarIvaIntOrd,	VarInteresMor,			VarIvaIntMor,		VarTasa
		);
	END LOOP;
END;
CLOSE CURSORCRE;

SELECT 	CuentaAhoID AS CuentaID,	ClienteID AS Num_Socio,		CreditoID AS Num_Cta,	ProducCreditoID AS Id_Cuenta,	Saldo,
		PagoMinimo,					PagoMensual,				GastosCobranza,			FechaUltAbono,					Estatus,
		InteresOrd,					IvaIntOrd AS IvaIntNor,		InteresMor,				IvaIntMor,						Tasa AS TasaInteres
	FROM TMPCONCEPTOSCREWS;

DROP TABLE TMPCONCEPTOSCREWS;

END TerminaStore$$