-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSAHORROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPSALDOSAHORROCON`;DELIMITER $$

CREATE PROCEDURE `TMPSALDOSAHORROCON`(
	out Cliente		int,
	out Saldo 		decimal(12, 2),
	out Moneda 		int,
	out EstatusC	char(1),
	Par_CuentaAhoID 	bigint(12)
		)
BEGIN
	SELECT 	ClienteID, 	SaldoDispon, 	MonedaID, 	Estatus
		into 	Cliente, 	Saldo,		Moneda,	EstatusC
		from 	CUENTASAHO
		where	CuentaAhoID	  =	Par_CuentaAhoID;
END$$