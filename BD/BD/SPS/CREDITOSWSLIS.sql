-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSWSLIS`;DELIMITER $$

CREATE PROCEDURE `CREDITOSWSLIS`(
	Par_SegmentoID		int(10),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)

)
TerminaStore: BEGIN

#Declaracion de Variables
DECLARE Var_AdeudoTot		decimal(14,2);
DECLARE Var_CreditoID 		BIGINT(12);
DECLARE Var_ClienteID		int(11);
DECLARE Var_Saldo			decimal(14,2);
DECLARE Var_PagoMin			decimal(14,2);
DECLARE Var_TotAdeudo       varchar(20);
DECLARE Var_MontoExigible	varchar(30);
DECLARE Var_FechaExigible	varchar(20);
DECLARE VarCuentaAhoID		bigint(12);
DECLARE VarClienteID		int(11);
DECLARE VarCreditoID		BIGINT(12);
DECLARE VarProducCreditoID	int(11);
DECLARE VarSaldo			decimal(14,2);
DECLARE VarPagoMinimo		decimal(14,2);
DECLARE VarPagoMensual		decimal(14,2);
DECLARE VarGastosCobranza	decimal(14,2);
DECLARE VarFechaUltAbono	date;
DECLARE VarEstatus			varchar(10);
DECLARE VarInteresOrd		decimal(14,2);
DECLARE VarIvaIntOrd		decimal(14,2);
DECLARE VarInteresMor		decimal(14,2);
DECLARE VarIvaIntMor		decimal(14,2);
DECLARE VarTasa				decimal(12,4);

#Declaracion de constantes
DECLARE  Entero_Cero	int;
DECLARE  Cadena_Vacia	char(1);
DECLARE  Var_NO			char(1);
DECLARE  NumConProxPag	int;
DECLARE  Fecha_Vacia	date;

DECLARE Lis_CreditosWS  int;


/*DECLARACION DE CURSORES */
DECLARE CURSORCRE CURSOR FOR

 SELECT	CRE.CuentaID,	CLI.ClienteID AS Num_Socio,	CRE.CreditoID AS Num_Cta,	CRE.ProductoCreditoID AS Id_Cuenta,
		FUNCIONTOTDEUDACRE(CRE.CreditoID) AS Saldo,
		FUNCIONCREPROXPAGO(CRE.CreditoID,Var_NO) AS PagoMensual,
		(CRE.SaldComFaltPago+CRE.SalIVAComFalPag) AS GastosCobranza,
        CONCAT(IFNULL(max(DP.FechaPago),Fecha_Vacia), 'T',CURRENT_TIME) AS FechaUltAbono,
		CASE CRE.Estatus WHEN 'V' THEN 1
						 WHEN 'B' THEN 2
		ELSE 0 END AS Estatus, TasaFija as TasaInteres
			FROM CLIENTES CLI
				INNER JOIN PROMOTORES PRO ON PRO.PromotorID = CLI.PromotorActual
				INNER JOIN CREDITOS CRE ON CLI.ClienteID = CRE.ClienteID
                AND (CRE.Estatus	='V' or CRE.Estatus='B' )
				LEFT OUTER JOIN DETALLEPAGCRE DP	ON CRE.CreditoID=DP.CreditoID
				AND CLI.ClienteID	= DP.ClienteID
				WHERE PRO.PromotorID = Par_SegmentoID
				GROUP BY CRE.CreditoID,	CRE.CuentaID,	CLI.ClienteID,	CRE.ProductoCreditoID,
						 CRE.Estatus,	CRE.TasaFija
				ORDER BY DP.FechaPago DESC;


#Asignacion de constantes
SET Entero_Cero		:=  0;
SET Cadena_Vacia	:= '';
SET Var_NO			:= 'N';
SET NumConProxPag := 9 ;
SET Fecha_Vacia		:= '1900-01-01';
SET Lis_CreditosWS  := 1;



drop table if exists TMPCONCEPTOSCREWS;
Create Temporary Table TMPCONCEPTOSCREWS(
	CuentaAhoID		bigint(12),
	ClienteID		int(11),
	CreditoID		BIGINT(12),
	ProducCreditoID	int(11),
	Saldo			decimal(14,2),
	PagoMinimo		decimal(14,2),
	PagoMensual		decimal(14,2),
	GastosCobranza	decimal(14,2),
	FechaUltAbono	date,
	Estatus			varchar(10),
	InteresOrd		decimal(14,2),
	IvaIntOrd		decimal(14,2),
	InteresMor		decimal(14,2),
	IvaIntMor		decimal(14,2),
	Tasa			decimal(12,4),
    INDEX(CuentaAhoID,ClienteID,CreditoID)
	);

Open  CURSORCRE;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	Loop
		Fetch CURSORCRE  Into
			VarCuentaAhoID,		VarClienteID,		VarCreditoID,		VarProducCreditoID,		VarSaldo,
			VarPagoMensual,		VarGastosCobranza,	VarFechaUltAbono,	VarEstatus,				VarTasa;

			/* so que devuelve conceptos que se necesitan de un credito especifico.*/
		call CRECONCEPTOSCON(
			VarCreditoID,	VarPagoMinimo,	VarInteresOrd,		VarIvaIntOrd,		VarInteresMor,
			VarIvaIntMor,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		insert into TMPCONCEPTOSCREWS values (
			VarCuentaAhoID,	VarClienteID,	VarCreditoID,			VarProducCreditoID,	VarSaldo,
			VarPagoMinimo,	VarPagoMensual,	VarGastosCobranza,		VarFechaUltAbono,	VarEstatus,
			VarInteresOrd,	VarIvaIntOrd,	VarInteresMor,			VarIvaIntMor,		VarTasa
		);
	End Loop;
END;
Close CURSORCRE;

 IF(Par_NumLis = Lis_CreditosWS)THEN

select 	CuentaAhoID as CuentaID,	ClienteID as Num_Socio,		CreditoID as Num_Cta,	ProducCreditoID as Id_Cuenta,	Saldo,
		PagoMinimo,					PagoMensual,				GastosCobranza,			FechaUltAbono,					Estatus,
		InteresOrd,					IvaIntOrd as IvaIntNor,		InteresMor,				IvaIntMor,						Tasa as TasaInteres
	from TMPCONCEPTOSCREWS;

drop table TMPCONCEPTOSCREWS;
 END IF;
END TerminaStore$$