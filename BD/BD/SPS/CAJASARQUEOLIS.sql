-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASARQUEOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASARQUEOLIS`;DELIMITER $$

CREATE PROCEDURE `CAJASARQUEOLIS`(
	Par_SucursalID      int,
    Par_CajaID          int,
    Par_Fecha           date,
	Par_Naturaleza		int,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_Encabezado  varchar(400);
DECLARE Var_NumeroMovs  int;
DECLARE Var_MontoMovs   decimal(14,2);
DECLARE Nat_Anterior    int;
DECLARE Var_MontoTotMov decimal(14,2);

DECLARE Var_Numero      int;
DECLARE Var_Descripcion varchar(200);
DECLARE Var_Naturaleza  int;
DECLARE Var_BalActEfe   decimal(14,2);
DECLARE Var_DifEntSal   decimal(14,2);
DECLARE Var_NomCajero   varchar(250);
DECLARE Var_SucursalCaja	int;



DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(14,2);
DECLARE Var_Vacio       char(1);
DECLARE Tipo_Encabezado char(1);
DECLARE Tipo_Detalle    char(1);
DECLARE Estilo_cursiva  char(1);
DECLARE Nat_Entrada     int;
DECLARE Nat_Salida      int;
DECLARE VarEstatus		 char(1);
DECLARE EstatusR		 char(1);
DECLARE EstatusE		 char(1);

DECLARE CURSORTIPOPE CURSOR FOR
	select  Numero, Descripcion, Naturaleza
		from CAJATIPOSOPERA
		where Naturaleza = Par_Naturaleza
       order by Naturaleza,orden;


set Entero_Cero     := 0;
set Decimal_Cero    := 0.0;
set Var_Vacio       := '';
set Tipo_Encabezado := 'E';
set Tipo_Detalle    := 'D';
set Estilo_cursiva  := 'C';
Set Nat_Entrada     := 1;
Set Nat_Salida      := 2;
Set EstatusR		:= 'R';
Set EstatusE		:= 'E';

set Nat_Anterior    := Nat_Entrada;
set Var_MontoTotMov := Entero_Cero;
set Var_DifEntSal   := Entero_Cero;

DROP TABLE IF EXISTS TMPARQUEO;

CREATE TEMPORARY TABLE TMPARQUEO(
    `Descripcion`   varchar(400),
    `NoMovimiento`  char(3),
    `Monto`         varchar(15),
	`Naturaleza`    varchar(50),
	`Numero`		int
);

Set Var_Descripcion := 'MOVIMIENTOS DE ENTREGA / ORIGEN';
Set Var_NumeroMovs	:= Entero_Cero;
Set Var_MontoMovs	:= Decimal_Cero;
Set Var_Naturaleza	:= Entero_Cero;


select SucursalID into Var_SucursalCaja
		from CAJASVENTANILLA
		where CajaID        =   Par_CajaID;

OPEN CURSORTIPOPE;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

    FETCH CURSORTIPOPE into
        Var_Numero, Var_Descripcion, Var_Naturaleza;

		select count(Transaccion), sum(MontoEnFirme + MontoSBC) into Var_NumeroMovs, Var_MontoMovs
			from CAJASMOVS
			where Fecha         = Par_Fecha
			and SucursalID    = Var_SucursalCaja
			and CajaID        = Par_CajaID
			and TipoOperacion = Var_Numero;

		set Var_NumeroMovs  := ifnull(Var_NumeroMovs, Entero_Cero);
		set Var_MontoMovs   := ifnull(Var_MontoMovs, Entero_Cero);

		set Var_MontoTotMov := Var_MontoTotMov + Var_MontoMovs;
		insert TMPARQUEO values(
			Var_Descripcion, Var_NumeroMovs, Var_MontoMovs, Var_Naturaleza, Var_Numero );


	End LOOP;

END;
CLOSE CURSORTIPOPE;
if (Par_Naturaleza = Nat_Entrada)then
			set Var_Descripcion := 'TOTAL ENTRADAS';
		end if;
		if (Par_Naturaleza = Nat_Salida)then
			set Var_Descripcion := 'TOTAL SALIDAS';
		end if;
		insert TMPARQUEO values(
			Var_Descripcion, Var_Vacio, Var_MontoTotMov, Var_Vacio, Entero_Cero);

	select  Descripcion, NoMovimiento, Monto, Naturaleza, Numero
		from TMPARQUEO;

drop table TMPARQUEO;

END TerminaStore$$