-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSAHORROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSAHORROCON`;DELIMITER $$

CREATE PROCEDURE `SALDOSAHORROCON`(
	out Cliente		int,
	out Saldo 		decimal(12, 2),
	out Moneda 		int,
	out EstatusC	char(1),
	Par_CuentaAhoID 	bigint
		)
BEGIN
	SELECT 	ClienteID, 	SaldoDispon, 	MonedaID, 	Estatus
		into 	Cliente, 	Saldo,		Moneda,	EstatusC
		from 	CUENTASAHO
		where	CuentaAhoID	  =	Par_CuentaAhoID;
END$$