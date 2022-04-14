-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCUENTAHOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCUENTAHOPRO`;DELIMITER $$

CREATE PROCEDURE `TMPCUENTAHOPRO`(	)
TerminaStore: 	BEGIN

DECLARE Var_NumCuenta		char(11);
DECLARE NumCliente	int;
DECLARE Var_Sucursal	int;
DECLARE FechaActual	datetime;
DECLARE Var_Fecha		date;
DECLARE Con_FechaVacia date;
DECLARE Entero_Cero	int;
DECLARE Var_Rand		int;
DECLARE Var_RandEdoCta int;
DECLARE Var_EdoCta	char(1);
DECLARE NumError		int;
DECLARE ErrorMen		varchar(100);

DECLARE CursorCliente CURSOR FOR (
					SELECT ClienteID, SucursalOrigen, FechaAlta
					FROM CLIENTES
					Where ClienteID>14);

Set Entero_Cero := 0;
Set FechaActual := CURRENT_TIMESTAMP();
Set Con_FechaVacia:= '1900-01-01';


	Open  CursorCliente;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			Loop

				Fetch CursorCliente  Into	NumCliente, Var_Sucursal,
										Var_Fecha;

				Set Var_Rand :=  1 + FLOOR(RAND() * (4 - 1 + 1));
				Set Var_RandEdoCta := 1 + FLOOR(RAND() * (3 - 1 + 1));

				if(Var_RandEdoCta = 1) then
					Set Var_EdoCta = 'D';

					end if;

				if(Var_RandEdoCta = 2) then
					Set Var_EdoCta = 'I';

					end if;

				if(Var_RandEdoCta = 3) then
					Set Var_EdoCta = 'S';

					end if;

				call TMPCUENTASAHOALT(Var_Sucursal, NumCliente, ' ', 1, Var_Rand,
									Var_Fecha, 'Cuenta en Pesos', Var_EdoCta, 1, 10, FechaActual,' ', ' ',1,0,
									Var_NumCuenta, NumError, ErrorMen);

				if(NumError != Entero_Cero) then
					Insert Into BITACORACUENAHO Values(Var_NumCuenta, 1, NumCliente, ' ',
													1, Var_Rand, Var_Fecha, FechaActual,
													10, 'Cuenta en Pesos', 0.0, 0.0,
													0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
													0.0, 0.0, 0.0, 0.0, 0.0,
													'I', Var_EdoCta, 1, 10, FechaActual, '0.0.0.0', '',1,0,
													NumError, ErrorMen);
				END if;

			END Loop;
		END;
	Close CursorCliente;

END TerminaStore$$