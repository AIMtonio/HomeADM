-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEDENOMOVS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEDENOMOVS`;DELIMITER $$

CREATE PROCEDURE `DETALLEDENOMOVS`(
	Par_CajaID          int,
	Par_Fecha           date,

	Aud_EmpresaID       int,
	Aud_Usuario         int,
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int,
	Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Entero_Cero	int;
DECLARE Var_Vacio		char(1);
DECLARE Tipo_Encabezado char(1);
DECLARE Tipo_Detalle	char(1);
DECLARE Estilo_cursiva	char(1);
DECLARE NatEntrada 	char(1);
DECLARE NatSalida 	char(1);
DECLARE NomUsuario	varchar(50);
-- declaracion de variables
DECLARE Var_Encabezado  	varchar(400);
--	variables para el fetch
DECLARE Var_Fecha			date;
DECLARE Var_Hora			time;
DECLARE Var_Descripcion	varchar(200);
DECLARE Var_Naturaleza		int;
DECLARE Var_Transaccion	int;
DECLARE Var_ValDeno	varchar(10);
DECLARE Var_Cantidad		decimal(14,2);
DECLARE Var_Monto		decimal(14,2);
--	variables para encabezados
DECLARE Var_CFecha		date;
DECLARE Var_CTransaccion	int;
DECLARE Var_CNaturaleza	int;
--	variables para las sumas y cuentas totales
DECLARE Var_Total	decimal(14,2);
DECLARE Var_TotalIni	decimal(14,2);
--	variables para manejo de balanza
DECLARE Var_cmil	decimal(14,2);
DECLARE Var_cqui	decimal(14,2);
DECLARE Var_cdos	decimal(14,2);
DECLARE Var_ccie	decimal(14,2);
DECLARE Var_ccin	decimal(14,2);
DECLARE Var_cvei	decimal(14,2);
DECLARE Var_cmon	decimal(14,2);
DECLARE Var_fechaant DATE;

DECLARE CURSORNENTRADA CURSOR FOR
	(select dm.Transaccion, dm.Naturaleza,dm.FechaActual, de.Valor, dm.Cantidad, dm.Monto
		from DENOMINACIONMOVS dm,DENOMINACIONES de
		where de.DenominacionID = dm.DenominacionID
		and dm.CajaID = Par_CajaID
		and dm.Fecha = Par_Fecha)
	union
	(select his.Transaccion, his.Naturaleza,his.FechaActual, de.Valor, his.Cantidad, his.Monto
		from `HIS-DENOMMOVS` his,DENOMINACIONES de
		where de.DenominacionID = his.DenominacionID
		and his.CajaID = Par_CajaID
		and his.Fecha = Par_Fecha)
	order by Transaccion,Valor DESC;

-- Asignacion de Constantes
set Entero_Cero	:= 0;
set Var_Vacio		:= '';
set Tipo_Encabezado := 'E';
set Tipo_Detalle	:= 'D';
set Estilo_cursiva	:= 'C';
set NatEntrada	:= 1;
set NatSalida		:= 2;
-- inicializacion de variables
SET Var_CFecha		:='1900-01-01';
SET Var_CTransaccion	:=0;
SET Var_CNaturaleza	:=0;
SET Var_Total	:=0;
SET Var_cmil	:=0;
SET Var_cqui	:=0;
SET Var_cdos	:=0;
SET Var_ccie	:=0;
SET Var_ccin	:=0;
SET Var_cvei	:=0;
SET Var_cmon	:=0;
set @Var_fechaant :='1900-01-01';
-- 	declaraciondel cursor
CREATE TEMPORARY TABLE TMPDENOMOVS(
    `Tmp_Descripcion`   varchar(500),
    `Tmp_Tipo`          char(1),
    `Tmp_Estilo`        char(1)
);

 set	Par_CajaID	:= ifnull(Par_CajaID, Entero_Cero);
 set	Par_Fecha	:= ifnull(Par_Fecha, Var_CFecha);


	call DIASHABILANTERCAL(
			Par_Fecha			,
	1,
	@Var_fechaant,
	1,

	0,
	now(),
	"",
	"",
	0,
	1
	);




select Cantidad into Var_cmil from `HIS-BALANZADENO` where DenominacionID = 1 and CajaID = Par_CajaID and Fecha = @Var_fechaant;
select Cantidad into Var_cqui from `HIS-BALANZADENO` where DenominacionID = 2 and CajaID = Par_CajaID and Fecha = @Var_fechaant;
select Cantidad into Var_cdos from `HIS-BALANZADENO` where DenominacionID = 3 and CajaID = Par_CajaID and Fecha = @Var_fechaant;
select Cantidad into Var_ccie from `HIS-BALANZADENO` where DenominacionID = 4 and CajaID = Par_CajaID and Fecha = @Var_fechaant;
select Cantidad into Var_ccin from `HIS-BALANZADENO` where DenominacionID = 5 and CajaID = Par_CajaID and Fecha = @Var_fechaant;
select Cantidad into Var_cvei from `HIS-BALANZADENO` where DenominacionID = 6 and CajaID = Par_CajaID and Fecha = @Var_fechaant;
select Cantidad into Var_cmon from `HIS-BALANZADENO` where DenominacionID = 7 and CajaID = Par_CajaID and Fecha = @Var_fechaant;
SET Var_cmil	:=ifnull(Var_cmil,Entero_Cero);
SET Var_cqui	:=ifnull(Var_cqui,Entero_Cero);
SET Var_cdos	:=ifnull(Var_cdos,Entero_Cero);
SET Var_ccie	:=ifnull(Var_ccie,Entero_Cero);
SET Var_ccin	:=ifnull(Var_ccin,Entero_Cero);
SET Var_cvei	:=ifnull(Var_cvei,Entero_Cero);
SET Var_cmon	:=ifnull(Var_cmon,Entero_Cero);
set Var_Total:=Var_cmil*1000+Var_cqui*500+Var_cdos*200+Var_ccie*100+Var_ccin*50+Var_cvei*20+Var_cmon;
set Var_TotalIni := Var_cmil*1000+Var_cqui*500+Var_cdos*200+Var_ccie*100+Var_ccin*50+Var_cvei*20+Var_cmon;
-- Renglon Vacio al Inicio del Reporte
set Var_Encabezado  := RPAD('', 34, ' ');
insert into TMPDENOMOVS values(Var_Encabezado, Tipo_Detalle,    Var_Vacio  );
insert into TMPDENOMOVS values(Var_Encabezado, Tipo_Detalle,    Var_Vacio  );
insert into TMPDENOMOVS values(
	'-SALDO INICIAL-',
	Tipo_Encabezado, Var_Vacio);
insert into TMPDENOMOVS values(
	concat( RPAD('DENOMINACION', 20, ' '),  LPAD('CANTIDAD', 15, ' '),LPAD('MONTO', 20, ' ') ),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD('1000', 20, ' '),  LPAD(format(Var_cmil,0), 15, ' '),LPAD(format(1000*Var_cmil,2), 20, ' ') ),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD('500', 20, ' '),  LPAD(format(Var_cqui,0), 15, ' '),LPAD(format(500*Var_cqui,2), 20, ' ') ),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD('200', 20, ' '),  LPAD(format(Var_cdos,0), 15, ' '),LPAD(format(200*Var_cdos,2), 20, ' ') ),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD('100', 20, ' '),  LPAD(format(Var_ccie,0), 15, ' '),LPAD(format(100*Var_ccie,2), 20, ' ') ),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD('50', 20, ' '),  LPAD(format(Var_ccin,0), 15, ' '),LPAD(format(50*Var_ccin,2), 20, ' ') ),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD('20', 20, ' '),  LPAD(format(Var_cvei,0), 15, ' '),LPAD(format(20*Var_cvei,2), 20, ' ') ),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD('MONEDAS', 20, ' '),  LPAD(format(Var_cmon,2), 15, ' '),LPAD(format(Var_cmon,2), 20, ' ') ),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	RPAD('-', 55, '-'),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD('TOTAL:', 35, ' '),LPAD(format(Var_Total,2), 20, ' ')),
Tipo_Detalle,    Estilo_cursiva  );


		-- encabezado
insert into TMPDENOMOVS values('',	Tipo_Encabezado, Var_Vacio);
insert into TMPDENOMOVS values(Concat(RPAD('MOVIMIENTOS POR DENOMINACIONES: ', 70,' ' ),'SALDO DESPUES DEL MOVIMIENTO: '),	Tipo_Encabezado, Var_Vacio);
insert into TMPDENOMOVS values(
	concat(
		RPAD('NATURALEZA', 10, ' '),
		LPAD('DENOMINACION', 15, ' '),
		LPAD('CANTIDAD', 12, ' '),
		LPAD('MONTO', 20, ' ') ,
		LPAD('HORA', 10, ' '),

		LPAD('DENOMINACION', 15, ' '),
		LPAD('CANTIDAD', 12, ' '),
		LPAD('MONTO', 20, ' ')
		),
	Tipo_Detalle,    Estilo_cursiva  );

OPEN CURSORNENTRADA;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP
	FETCH CURSORNENTRADA into
		Var_Transaccion,Var_Naturaleza,Var_Hora, Var_ValDeno, Var_Cantidad, Var_Monto;

		if(Var_Transaccion != Var_CTransaccion)then

			set Var_Total:=Var_cmil*1000+Var_cqui*500+Var_cdos*200+Var_ccie*100+Var_ccin*50+Var_cvei*20+Var_cmon;
			if  Var_Total != Var_TotalIni then
				insert into TMPDENOMOVS values(
				RPAD('-', 114, '-'),
				Tipo_Detalle,    Estilo_cursiva  );
				insert into TMPDENOMOVS values(
				concat( RPAD('TOTAL:', 94, ' '),LPAD(format(Var_Total,2), 20, ' ')),
				Tipo_Detalle,    Estilo_cursiva  );

			end if;


			insert into TMPDENOMOVS values(
			'',
			Tipo_Detalle, Var_Vacio
			);
			select min(cto.Descripcion) into Var_Descripcion
				from CAJATIPOSOPERA cto, CAJASMOVS cm
				where cto.Numero = cm.TipoOperacion
				and cm.Transaccion= Var_Transaccion
				and cto.Naturaleza = Var_Naturaleza;
			if(ifnull(Var_Descripcion,Var_Vacio) = Var_Vacio) then
				select min(cto.Descripcion) into Var_Descripcion
				from CAJATIPOSOPERA cto, `HIS-CAJASMOVS` cm
				where cto.Numero = cm.TipoOperacion
				and cm.Transaccion= Var_Transaccion
				and cto.Naturaleza = Var_Naturaleza;
			end if;


			insert into TMPDENOMOVS values(
			concat(concat(LPAD('TRANSACCION',11,' ' ),': '), Var_Transaccion, ' - MOVIMIENTO: ', Var_Descripcion),
			Tipo_Detalle, Var_Vacio
			);
			set Var_CTransaccion := ifnull(Var_Transaccion,Var_Vacio);

		end if;

		if ( Var_Naturaleza = NatEntrada ) then
			CASE Var_ValDeno
			WHEN 1000 THEN set Var_cmil = Var_cmil + Var_Cantidad;
			WHEN 500 THEN set Var_cqui = Var_cqui + Var_Cantidad;
			WHEN 200 THEN set Var_cdos = Var_cdos + Var_Cantidad;
			WHEN 100 THEN set Var_ccie = Var_ccie + Var_Cantidad;
			WHEN 50 THEN set Var_ccin = Var_ccin + Var_Cantidad;
			WHEN 20 THEN set Var_cvei = Var_cvei + Var_Cantidad;
			WHEN 1 THEN set Var_cmon = Var_cmon + Var_Cantidad;
			END CASE;
		else
			CASE Var_ValDeno
			WHEN 1000 THEN set Var_cmil = Var_cmil - Var_Cantidad;
			WHEN 500 THEN set Var_cqui = Var_cqui - Var_Cantidad;
			WHEN 200 THEN set Var_cdos = Var_cdos - Var_Cantidad;
			WHEN 100 THEN set Var_ccie = Var_ccie - Var_Cantidad;
			WHEN 50 THEN set Var_ccin = Var_ccin - Var_Cantidad;
			WHEN 20 THEN set Var_cvei = Var_cvei - Var_Cantidad;
			WHEN 1 THEN set Var_cmon = Var_cmon - Var_Cantidad;
			END CASE;
		end if;
		insert into TMPDENOMOVS
			values(
				concat(
					RPAD(CASE WHEN Var_Naturaleza = 1
							THEN 'ENTRADA'
							ELSE 'SALIDA'
						END, 10, ' '),
					LPAD(CASE WHEN Var_ValDeno = 1
							THEN 'MONEDAS'
							ELSE format(Var_ValDeno, 0)
						END
					, 15, ' '),
					LPAD(
					CASE WHEN Var_ValDeno = 1
						THEN format(Var_Cantidad, 2)
						ELSE format(Var_Cantidad, 0)
					END, 12, ' '),
					LPAD(format(ifnull(Var_Monto	, 0), 2), 20, ' '),
					LPAD(Var_Hora, 10, ' '),
					LPAD(CASE WHEN Var_ValDeno = 1
						THEN 'MONEDAS'
						ELSE format(Var_ValDeno, 0)
					END
					, 15, ' '),
					LPAD(
					CASE Var_ValDeno
						WHEN  1 then format(ifnull(Var_cmon, 0), 2)
						WHEN 1000 THEN  format(ifnull(Var_cmil,0),0)
						WHEN 500 THEN  format(ifnull(Var_cqui,0) ,0)
						WHEN 200 THEN  format(ifnull(Var_cdos,0),0)
						WHEN 100 THEN  format(ifnull(Var_ccie,0),0)
						WHEN 50 THEN  format(ifnull(Var_ccin,0) ,0)
						WHEN 20 THEN  format(ifnull(Var_cvei,0) ,0)
						END
						, 12, ' '),
					LPAD(format(ifnull(
						CASE Var_ValDeno
						WHEN 1000 THEN  Var_cmil*1000
						WHEN 500 THEN  Var_cqui*500
						WHEN 200 THEN  Var_cdos*200
						WHEN 100 THEN  Var_ccie*100
						WHEN 50 THEN  Var_ccin *50
						WHEN 20 THEN  Var_cvei *20
						WHEN 1 THEN  Var_cmon*1
						END
					, 0), 2), 20, ' ')
				),
				Tipo_Detalle, Var_Vacio
			);
	End LOOP;
END;
CLOSE CURSORNENTRADA;

set Var_Total:=Var_cmil*1000+Var_cqui*500+Var_cdos*200+Var_ccie*100+Var_ccin*50+Var_cvei*20+Var_cmon;
insert into TMPDENOMOVS values(
	RPAD('-', 114, '-'),
	Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD('TOTAL:', 94, ' '),LPAD(format(Var_Total,2), 20, ' ')),
	Tipo_Detalle,    Estilo_cursiva  );

select NombreCompleto into NomUsuario from USUARIOS us, CAJASVENTANILLA cv where us.UsuarioID = cv.UsuarioID and CajaID=Par_CajaID;
set NomUsuario = ifnull(NomUsuario,Var_Vacio);
insert into TMPDENOMOVS values(
	'',
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	'',
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	RPAD('_', 50, '_'),
Tipo_Detalle,    Estilo_cursiva  );
insert into TMPDENOMOVS values(
	concat( RPAD(NomUsuario, 50, ' ')),
Tipo_Detalle,    Estilo_cursiva  );



select  Tmp_Descripcion,    Tmp_Tipo,   Tmp_Estilo
    from TMPDENOMOVS;
drop table TMPDENOMOVS;
END TerminaStore$$