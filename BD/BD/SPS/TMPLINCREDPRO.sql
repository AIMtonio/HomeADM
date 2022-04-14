-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPLINCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPLINCREDPRO`;DELIMITER $$

CREATE PROCEDURE `TMPLINCREDPRO`(	)
TerminaStore: BEGIN

DECLARE 	Var_ClienteID		int;
DECLARE	Var_CuentaID		bigint(12);
DECLARE	Var_LinCredID		char(12);
DECLARE	Var_Sucursal		int(11);
DECLARE	Var_MonedaID			int;
DECLARE	Var_FechaIni		date;
DECLARE	Var_FechaFin		date;
DECLARE	Var_RandFech		int;
DECLARE	Var_RandCant		decimal(12,2);
DECLARE	Var_RandProduc	int;
DECLARE	Var_FolioConsec	int;
DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero	int;
DECLARE	NumError		int;
DECLARE	ErrorMen		varchar(200);
DECLARE CursorCuenta CURSOR FOR(
				Select	 CuentaAhoID, ClienteID, Sucursal,
						 MonedaID
					From CUENTASAHO  LIMIT 1);

Set Entero_Cero := 0;
Set Cadena_Vacia := ' ';
Set Var_FolioConsec := 1;


	Open CursorCuenta;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				Loop
				Fetch CursorCuenta Into	Var_CuentaID, Var_ClienteID,
										Var_Sucursal, Var_MonedaID;

				Set Var_LinCredID := '00000000000';
				Set Var_FechaIni := '2010-12-31';
				Set Var_FechaFin := '2013-12-31';

				Set Var_RandFech :=  1 + FLOOR(RAND() * 355 - 1);

				Set Var_FechaIni := convert(DATE_ADD(Var_FechaIni,
									INTERVAL Var_RandFech DAY) ,char);
				Set Var_FechaFin := convert(DATE_ADD(Var_FechaFin,
									INTERVAL Var_RandFech DAY) ,char);

				Set Var_RandProduc := FLOOR(1 + RAND() * (15 -1)) * 100;

				Set Var_RandCant :=  20000 + FLOOR(RAND() * 500000 - 20000);

				call  TMPLINEASCREDALT(Var_ClienteID, Var_CuentaID, Var_MonedaID,
									 Var_Sucursal, Var_FolioConsec, Var_FechaIni,
									 Var_FechaFin, Var_RandProduc, Var_RandCant,
									 ' ', 10, Var_FechaIni, '0.0.0.0', 'Insercion Masiva',
									 123, 123, Var_LinCredID, NumError, ErrorMen);

				if( NumError = Entero_Cero) then
					Set Var_RandCant :=  20000 + FLOOR(RAND() * 500000 - 20000);
					call TMPLINEASCREDACT(
								Var_LinCredID, Var_RandCant,'2011-07-28', 10,
								' ', ' ', 10, '2011-07-28', '0.0.0.0', 'Insercion Masiva',123,123,
								NumError, ErrorMen);

					if(NumError != Entero_Cero )then

						Insert Into BITACORALINCRED Values(
												Var_LinCredID,	Var_ClienteID,	Var_CuentaID,
												Var_MonedaID,		Var_Sucursal,		Var_FolioConsec,
												Var_FechaIni,		Var_FechaFin,		Var_RandProduc,
												Var_RandCant,		Var_RandCant,		' ', ' ', 10,
												' ', 10, Var_FechaIni, 'Insercion Masiva', '0.0.0.0', 123,123,
												NumError, ErrorMen);
					end if;

				else 	Insert Into BITACORALINCRED Values(
												Var_LinCredID,	Var_ClienteID,	Var_CuentaID,
												Var_MonedaID,		Var_Sucursal,		Var_FolioConsec,
												Var_FechaIni,		Var_FechaFin,		Var_RandProduc,
												Var_RandCant,		0.0,				' ', ' ', 10,
												' ', 10, Var_FechaIni, 'Insercion Masiva', '0.0.0.0', 123,123,
												NumError, ErrorMen);
				end if;

				Set Var_FolioConsec := Var_FolioConsec + 1;
				End Loop;

		END;
	Close CursorCuenta;




END TerminaStore$$