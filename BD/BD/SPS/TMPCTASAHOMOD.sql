-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCTASAHOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCTASAHOMOD`;DELIMITER $$

CREATE PROCEDURE `TMPCTASAHOMOD`(


		)
TerminaStore: BEGIN
DECLARE		Cadena_Vacia	char(1);
DECLARE		Entero_Cero		int;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;

	update 	CUENTASAHO CA,
			TMPCUENTASAHOCI TCA
	set

			CA.CargosMes		=  TCA.CargosMes	,
			CA.AbonosMes		=  TCA.AbonosMes	,
			CA.Comisiones		=  Entero_Cero	,
			CA.SaldoProm		=  Entero_Cero	,
			CA.SaldoDispon	=  TCA.SaldoDispon,
			CA.SaldoIniMes	=  Entero_Cero

	WHERE 	CA.CuentaAhoID 	= 	TCA.CuentaAhoID;


END TerminaStore$$