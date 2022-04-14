-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCTASAHOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCTASAHOACT`;DELIMITER $$

CREATE PROCEDURE `TMPCTASAHOACT`(


		)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE Decimal_Cero    DECIMAL;


	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.00;

	UPDATE 	CUENTASAHO CA,TMPCUENTASAHOCI TCA SET
		CA.CargosDia		= 	Entero_Cero	,
		CA.CargosMes		= 	Entero_Cero	,
		CA.AbonosMes		= 	Entero_Cero	,
		CA.AbonosDia		= 	Entero_Cero	,
		CA.Comisiones		= 	Entero_Cero	,
		CA.SaldoProm		=  	TCA.SaldoProm	,
		CA.Saldo			=  	TCA.Saldo,
		CA.SaldoDispon		=  	TCA.SaldoDispon,
		CA.Gat				=  	TCA.Gat,
		CA.GatReal			=  	TCA.GatReal,
		CA.SaldoIniMes		=  	TCA.Saldo,
		CA.ISRReal			=	Decimal_Cero
		WHERE 	CA.CuentaAhoID 	= 	TCA.CuentaAhoID;


END TerminaStore$$