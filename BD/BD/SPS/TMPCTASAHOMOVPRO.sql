-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCTASAHOMOVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCTASAHOMOVPRO`;DELIMITER $$

CREATE PROCEDURE `TMPCTASAHOMOVPRO`(	)
TerminaStore: BEGIN

DECLARE	Var_NumCuenta		int;
DECLARE	Fecha			date;
DECLARE	NatMov			char(1);
DECLARE	TipoMov			int;
DECLARE	NumError			int;
DECLARE	ErrorMen			char(100);
DECLARE	Var_Rand			int;
DECLARE	Var_RandCant		decimal(12,2);
DECLARE	Terminado		int DEFAULT 0;
DECLARE	i				int DEFAULT 0;
DECLARE Entero_Cero		int;

DECLARE	Var_RandNatMov	int;

DECLARE	CursorCta Cursor FOR (
					SELECT CuentaAhoID FROM CUENTASAHO
					WHERE ClienteID > 0 and ClienteID<100);
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET Terminado = 1;


Set Entero_Cero := 0;



	Open CursorCta;


			WHILE (Terminado = 0) DO
				Fetch CursorCta Into	Var_NumCuenta;

				Set Fecha := '2011-10-31';


				Set Var_RandCant	 = 100 + FLOOR(RAND() * (10000 - 100 + 1));
				Set TipoMov := 10;
				Set NatMov  := 'A';


				call TMPCUENAHOMOVALT(Var_NumCuenta,1, Fecha, NatMov, Var_RandCant,
									'MOVIMIENTO EN VENTANILLA', 'REF VEN', TipoMov,
									1, 10, Fecha, '0.0.0.0', ' ', 1, 1,
									NumError, ErrorMen);

				if(NumError = Entero_Cero) then

					WHILE (i <= 2) DO

						Set Var_Rand := 1 + FLOOR(RAND() * (80 - 1 + 1));

						Set Var_RandCant := 100 + FLOOR(RAND() * (10000 - 100 + 1));

						Set Fecha := convert(DATE_ADD(
							Fecha, INTERVAL Var_Rand DAY) ,char);
						Set TipoMov := 10 + FLOOR(RAND() * (11 - 10 + 1));

						if(TipoMov = 10) then
							Set NatMov := 'A';
						end if;

						if(TipoMov = 11) then
							Set NatMov := 'C';
						end if;

						call TMPCUENAHOMOVALT(Var_NumCuenta,1, Fecha, NatMov, Var_RandCant,
									'MOVIMIENTO EN VENTANILLA', 'REF VEN', TipoMov,
									1, 10, Fecha, '0.0.0.0', ' ', 1, 1,
									NumError, ErrorMen);

						if (NumError != Entero_Cero) then
							insert into BITACORACAHOMOV Values(Var_NumCuenta,1, Fecha, NatMov, Var_RandCant,
									'MOVIMIENTO EN VENTANILLA', 'REF VEN', TipoMov, 1,
									1, 10, Fecha, '0.0.0.0', ' ', 1, 1,
									NumError, ErrorMen);
						END if;

						set i := i + 1;
						END WHILE;

						Set i := 0;

				else insert into BITACORACAHOMOV Values(Var_NumCuenta,1, '2011-10-31', NatMov, Var_RandCant,
									'MOVIMIENTO EN VENTANILLA', 'REF VEN', TipoMov, 1,
									1, 10, '2011-10-31', '0.0.0.0', ' ', 1, 1,
									NumError, ErrorMen);

				end if;



			End While;


	Close CursorCta;

END TerminaStore$$