-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSAHORROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPSALDOSAHORROACT`;
DELIMITER $$


CREATE PROCEDURE `TMPSALDOSAHORROACT`(

	Par_NatMovimiento 	CHAR(1),
	Par_Movimiento		VARCHAR(4)
			)

TerminaStore: BEGIN


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Entero_Cero		INT;
DECLARE	Decimal_Cero	DECIMAL (12,2);
DECLARE	Nat_Cargo		CHAR(1);
DECLARE	Nat_Abono		CHAR(1);
DECLARE Var_EstatusSI	CHAR(1);
DECLARE Var_EstatusNO	CHAR(1);

DECLARE Var_MovComAper	VARCHAR(4);
DECLARE Var_MovComAniv	VARCHAR(4);
DECLARE Var_MovComDisS	VARCHAR(4);
DECLARE Var_MovComManC	VARCHAR(4);
DECLARE	Var_MovComFalC	VARCHAR(4);
DECLARE Var_MovRendGra	VARCHAR(4);
DECLARE Var_MovRendExc	VARCHAR(4);
DECLARE Var_MovIDE		VARCHAR(4);

DECLARE Var_MovIvaAper	VARCHAR(4);
DECLARE Var_MovIvaAniv	VARCHAR(4);
DECLARE Var_MovIvaDisS	VARCHAR(4);
DECLARE Var_MovIvaManC	VARCHAR(4);
DECLARE Var_MovIvaFalC	VARCHAR(4);
DECLARE Var_MovRetISR	VARCHAR(4);
DECLARE Var_MovComSaldoProm VARCHAR(4);
DECLARE Var_MovIVAComSaldoProm VARCHAR(4);

DECLARE	Var_Si			CHAR(1);
DECLARE	Var_No			CHAR(1);


SET	Cadena_Vacia		:= '';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.0;
SET	Nat_Cargo			:= 'C';
SET	Nat_Abono			:= 'A';
SET	Var_Si				:= 'S';
SET	Var_No				:= 'N';
SET	Var_EstatusSI		:= 'S';
SET	Var_EstatusNO		:= 'N';

SET	Var_MovComAper	:= '206';
SET	Var_MovComAniv	:= '208';
SET	Var_MovComDisS	:= '214';
SET	Var_MovComManC	:= '202';
SET	Var_MovComFalC	:= '204';
SET	Var_MovRendGra	:= '200';
SET	Var_MovRendExc	:= '201';
SET	Var_MovIDE		:= '221';

SET	Var_MovIvaAper	:= '207';
SET	Var_MovIvaAniv	:= '209';
SET	Var_MovIvaDisS	:= '215';
SET	Var_MovIvaManC	:= '203';
SET	Var_MovIvaFalC	:= '205';
SET	Var_MovRetISR	:= '220';
SET Var_MovComSaldoProm := '230';
SET Var_MovIVAComSaldoProm := '231';


IF(Par_NatMovimiento = Nat_Abono) THEN
	CASE Par_Movimiento

		WHEN Var_MovRendGra
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.AbonosDia		=  TCA.AbonosDia		+ 	TCM.CantidadMov ,
				TCA.AbonosMes		=  TCA.AbonosMes		+	TCM.CantidadMov ,
				TCA.SaldoDispon	=  TCA.SaldoDispon	+	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			+	TCM.CantidadMov
			WHERE 	IFNULL(TCA.InteresesGen,Decimal_Cero) 	> 	Decimal_Cero
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovRendGra
				AND PagaISR = Var_Si;


		WHEN Var_MovRendExc
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.AbonosDia		=  TCA.AbonosDia		+ 	TCM.CantidadMov ,
				TCA.AbonosMes		=  TCA.AbonosMes		+	TCM.CantidadMov ,
				TCA.SaldoDispon	=  TCA.SaldoDispon	+	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			+	TCM.CantidadMov
			WHERE 	IFNULL(TCA.InteresesGen,Decimal_Cero) 	> 	Decimal_Cero
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovRendExc
				AND PagaISR = Var_No;

	END CASE;
END IF;

IF(Par_NatMovimiento = Nat_Cargo) THEN

	CASE Par_Movimiento

		WHEN Var_MovComAper
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.Comisiones	=  TCA.Comisiones		+	TCM.CantidadMov,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov,
				TCA.Saldo		=  TCA.Saldo	-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.ComApertura,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 	>=	TCA.ComApertura
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovComAper;


		WHEN Var_MovIvaAper
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo	-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.IvaComApertura,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 		>=	TCA.IvaComApertura
				AND 	TCM.CuentaAhoID 		= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID		=	Var_MovIvaAper;


		WHEN Var_MovComAniv
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.Comisiones	=  TCA.Comisiones		+	TCM.CantidadMov,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.ComAniversario,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 	>=	TCA.ComAniversario
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovComAniv;


		WHEN Var_MovIvaAniv
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.IvaComAniv,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 	>=	TCA.IvaComAniv
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovIvaAniv;


		WHEN Var_MovComDisS
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.Comisiones	=  TCA.Comisiones		+	TCM.CantidadMov,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.ComDispSeg,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 	>=	TCA.ComDispSeg
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovComDisS;


		WHEN Var_MovIvaDisS
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.IvaComDispSeg,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 		>=	TCA.IvaComDispSeg
				AND 	TCM.CuentaAhoID 		= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID		=	Var_MovIvaDisS;


		WHEN Var_MovComManC
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.Comisiones	=  TCA.Comisiones		+	TCM.CantidadMov,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.ComManejoCta,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 	>=	TCA.ComManejoCta
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovComManC;

		WHEN Var_MovIvaManC
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.IvaComManejoCta,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 	>=	TCA.IvaComManejoCta
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovIvaManC;


		WHEN Var_MovComFalC
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.Comisiones	=  TCA.Comisiones		+	TCM.CantidadMov,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo 		=  TCA.Saldo			-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.ComFalsoCobro,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 	>=	TCA.ComFalsoCobro
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovComFalC;


		WHEN Var_MovIvaFalC
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.IvaComFalsoCob,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 	>=	TCA.IvaComFalsoCob
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovIvaFalC;


		WHEN Var_MovRetISR
		THEN
			UPDATE 	TMPCUENTASAHOCI TCA,
					 TMPCTASAHOMOV TCM
			SET
				TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
				TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
				TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
				TCA.Saldo		=  TCA.Saldo			-	TCM.CantidadMov
			WHERE 	IFNULL(TCA.ISR,Decimal_Cero) 	> 	Decimal_Cero
				AND	TCA.SaldoDispon 	>=	TCA.ISR
				AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
				AND 	TCM.TipoMovAhoID	=	Var_MovRetISR;
		WHEN Var_MovComSaldoProm
			THEN
				UPDATE 	TMPCUENTASAHOCI TCA,
						TMPCTASAHOMOV TCM
				SET
					TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
					TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
					TCA.Comisiones	=  TCA.Comisiones		+	TCM.CantidadMov,
					TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov,
					TCA.Saldo		=  TCA.Saldo	-	TCM.CantidadMov
				WHERE 	IFNULL(TCA.ComSalProm,Decimal_Cero) 	> 	Decimal_Cero
					AND	TCA.SaldoDispon 	>=	TCA.ComSalPromCob
					AND 	TCM.CuentaAhoID 	= 	TCA.CuentaAhoID
					AND 	TCM.TipoMovAhoID	=	Var_MovComSaldoProm;
		WHEN Var_MovIVAComSaldoProm
			THEN
				UPDATE 	TMPCUENTASAHOCI TCA,
						TMPCTASAHOMOV TCM
				SET
					TCA.CargosDia		=  TCA.CargosDia		+ 	TCM.CantidadMov ,
					TCA.CargosMes		=  TCA.CargosMes		+	TCM.CantidadMov ,
					TCA.SaldoDispon	=  TCA.SaldoDispon	-	TCM.CantidadMov ,
					TCA.Saldo		=  TCA.Saldo	-	TCM.CantidadMov
				WHERE 	IFNULL(TCA.IVAComSalProm,Decimal_Cero) 	> 	Decimal_Cero
					AND	TCA.SaldoDispon 		>=	TCA.IVAComSalPromCob
					AND 	TCM.CuentaAhoID 		= 	TCA.CuentaAhoID
					AND 	TCM.TipoMovAhoID		=	Var_MovIVAComSaldoProm;


	END CASE;
END IF;

END TerminaStore$$