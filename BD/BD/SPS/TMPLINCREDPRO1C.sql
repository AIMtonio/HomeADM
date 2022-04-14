-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPLINCREDPRO1C
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPLINCREDPRO1C`;DELIMITER $$

CREATE PROCEDURE `TMPLINCREDPRO1C`(

	Par_ClienteID 			int,

	Par_FechaInicio		date,
	Par_FechaVencimiento 	date,
	Par_ProductoCreditoID int,
	Par_MontoLinea		decimal(12,2),
	Par_CuentaID			bigint(12),

	out Var_LinCredID		char(12),
	out Var_FechaFin		date,
	out NumErr			int,
	out ErrMen			varchar(100)
	)
TerminaStore: BEGIN

DECLARE 	Var_ClienteID		int;
DECLARE	Var_CuentaID		bigint(12);

DECLARE	Var_Sucursal		int(11);
DECLARE	Var_MonedaID			int;
DECLARE	Var_FechaIni		date;
DECLARE	Var_FechaFin		date;
DECLARE	Var_RandFech		int;
DECLARE	Var_RandCant		decimal(12,2);
DECLARE	Var_FolioConsec	int;
DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero	int;
DECLARE	NumError		int;
DECLARE	ErrorMen		varchar(200);
DECLARE CursorCuenta CURSOR FOR(
				Select	 CuentaAhoID, ClienteID, Sucursal,
						 MonedaID
					From CUENTASAHO
					Where ClienteID = Par_ClienteID and CuentaAhoID = Par_CuentaID
					limit 1);

Set Entero_Cero := 0;
Set Cadena_Vacia := ' ';
Set Var_FolioConsec := 1;
Set Var_FolioConsec :=  (select ifnull(Max(FolioContrato),Entero_Cero) + 1
from LINEASCREDITO);


	Open CursorCuenta;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				Loop
				Fetch CursorCuenta Into	Var_CuentaID, Var_ClienteID,
										Var_Sucursal, Var_MonedaID;

				Set Var_LinCredID := '00000000000';
				Set Var_FechaIni := '2012-03-21';

				Set Var_RandFech := (FLOOR(6 + RAND() * (6)) * 2);
				Set Var_FechaFin := DATE_ADD(Var_FechaIni, INTERVAL Var_RandFech MONTH);




				call  TMPLINEASCREDALT(Var_ClienteID,	Var_CuentaID,		Var_MonedaID,			 Var_Sucursal,		Var_FolioConsec,
									 Var_FechaIni,	Var_FechaFin, 	Par_ProductoCreditoID, Par_MontoLinea, 		' ',
									 10, 			Var_FechaIni, 	'0.0.0.0', 			'Insercion Credito Masiva',  1,
									 123,			Var_LinCredID, 	NumError, 			 ErrorMen);



				if( NumError = Entero_Cero) then
					Set Var_RandCant :=  20000 + FLOOR(RAND() * 500000 - 20000);
					call TMPLINEASCREDACT(
								Var_LinCredID, Par_MontoLinea,'2011-07-28', 10,
								' ', ' ', 10, '2011-07-28', '0.0.0.0', 'Insercion Masiva',123,123,
								NumError, ErrorMen);

					if(NumError != Entero_Cero )then

						Insert Into BITACORALINCRED Values(
												Var_LinCredID,	Var_ClienteID,	Var_CuentaID,
												Var_MonedaID,		Var_Sucursal,		Var_FolioConsec,
												Var_FechaIni,		Var_FechaFin,		Par_ProductoCreditoID,
												Par_MontoLinea,	Par_MontoLinea,		' ', ' ', 10,
												' ', 10, Var_FechaIni, 'Insercion Masiva', '0.0.0.0', 123,123,
												NumError, ErrorMen);
					end if;

				else 	Insert Into BITACORALINCRED Values(
												Var_LinCredID,	Var_ClienteID,	Var_CuentaID,
												Var_MonedaID,		Var_Sucursal,		Var_FolioConsec,
												Var_FechaIni,		Var_FechaFin,		Par_ProductoCreditoID,
												Par_MontoLinea,	0.0,				' ', ' ', 10,
												' ', 10, Var_FechaIni, 'Insercion Masiva', '0.0.0.0', 123,123,
												NumError, ErrorMen);
				end if;
				End Loop;

		END;
	Close CursorCuenta;




END TerminaStore$$