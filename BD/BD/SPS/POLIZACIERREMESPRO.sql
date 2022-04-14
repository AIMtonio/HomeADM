-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZACIERREMESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZACIERREMESPRO`;
DELIMITER $$


CREATE PROCEDURE `POLIZACIERREMESPRO`(

	Par_Poliza			bigint,
	Par_Empresa			int,
	Par_Movimiento		varchar(5),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN


DECLARE	Var_TipoPersona		char(1);
DECLARE	Var_TipoCuenta		int;
DECLARE	Var_GeneraInteres	char(1);
DECLARE	Var_NomComple		varchar(100);
DECLARE	Var_Instrumento		varchar(20);
DECLARE Var_Cuenta			varchar(50);
DECLARE Var_CenCosto		int;
DECLARE Var_CuentaComple	char(25);
DECLARE Var_Nomenclatura	varchar(30);
DECLARE Var_NomenclaturaCR	varchar(3);
DECLARE Var_CuentaMayor		varchar(4);
DECLARE	Var_SubCuentaTP		char(6);
DECLARE	Var_SubCuentaTC		char(2);
DECLARE	Var_SubCuentaTR		char(2);
DECLARE	Var_SubCuentaTM		char(2);
DECLARE	Var_SubCuentaCL		varchar(6);
DECLARE	Var_NomenclaturaSO	char(2);
DECLARE	Var_NomenclaturaSC	char(2);
DECLARE	Var_ClasifCta		char(1);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Cuenta_Vacia		char(25);
DECLARE	Per_Fisica			char(1);
DECLARE	Per_Moral			char(1);
DECLARE	Ren_Si				char(1);
DECLARE	Ren_No				char(1);
DECLARE	Procedimiento		varchar(20);
DECLARE	For_CueMayor		char(3);
DECLARE	For_TipProduc		char(3);
DECLARE	For_TipRend			char(3);
DECLARE	For_TipCliente		char(3);
DECLARE	For_Moneda			char(3);
DECLARE	For_Clasif			char(3);
DECLARE	For_SucOrigen		char(3);
DECLARE	For_SucCliente		char(3);
DECLARE	Salida_NO			char(1);


DECLARE Var_MovComAper		varchar(4);
DECLARE Var_MovComAniv		varchar(4);
DECLARE Var_MovComDisS		varchar(4);
DECLARE Var_MovComManC		varchar(4);
DECLARE Var_MovComFalC		varchar(4);
DECLARE Var_MovRendGra		varchar(4);
DECLARE Var_MovRendExc		varchar(4);
DECLARE Var_MovIDE			varchar(4);

DECLARE Var_MovIvaAper		varchar(4);
DECLARE Var_MovIvaAniv		varchar(4);
DECLARE Var_MovIvaDisS		varchar(4);
DECLARE Var_MovIvaManC		varchar(4);
DECLARE Var_MovIvaFalC		varchar(4);
DECLARE Var_MovRetISR		varchar(4);


DECLARE ConAhoComApe		int;
DECLARE ConAhoComAnual		int;
DECLARE ConAhoComManCta		int;
DECLARE ConAhoComFalCob		int;
DECLARE ConAhoComDisSeg		int;

DECLARE ConAhoIvaApe		int;
DECLARE ConAhoIvaAnual		int;
DECLARE ConAhoIvaManCta		int;
DECLARE ConAhoIvaFalCob		int;
DECLARE ConAhoIvaDisSeg		int;

DECLARE ConAhoIntGravad		int;
DECLARE ConAhoIntExento		int;
DECLARE ConAhoIDE			int;
DECLARE ConAhoISR			int;
DECLARE ConAhoPasivo		int;
DECLARE VarTipoInstruCta	int(11);
DECLARE Var_MovComSalProm	varchar(4);
DECLARE Var_MovIvaSalProm	varchar(4);
DECLARE ConAhoComSalProm	int;
DECLARE ConAhoIvaSalProm	int;


Set	Salida_NO		:= 'N';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Cuenta_Vacia	:= '0000000000000000000000000';
Set	Entero_Cero		:= 0;
Set	Per_Fisica		:= 'F';
Set	Per_Moral		:= 'M';
Set	Ren_Si			:= 'S';
Set	Ren_No			:= 'N';
Set	For_CueMayor	:= '&CM';
Set	For_TipProduc	:= '&TP';
Set	For_TipRend		:= '&TR';
Set	For_TipCliente	:= '&TC';
Set	For_Moneda		:= '&TM';
Set	For_Clasif		:= '&CL';

Set	For_SucOrigen	:= '&SO';
Set	For_SucCliente	:= '&SC';

Set	Procedimiento	:= 'POLIZACIERREMESPRO';


Set	Var_MovComAper	:= '206';
Set	Var_MovComAniv	:= '208';
Set	Var_MovComDisS	:= '214';
Set	Var_MovComManC	:= '202';
Set	Var_MovComFalC	:= '204';
Set	Var_MovRendGra	:= '200';
Set	Var_MovRendExc	:= '201';
Set	Var_MovIDE		:= '221';

Set	Var_MovIvaAper	:= '207';
Set	Var_MovIvaAniv	:= '209';
Set	Var_MovIvaDisS	:= '215';
Set	Var_MovIvaManC	:= '203';
Set	Var_MovIvaFalC	:= '205';
Set	Var_MovRetISR	:= '220';
SET Var_MovComSalProm := '230';
SET Var_MovIvaSalProm := '231';

Set ConAhoComApe 		:= 5;
Set ConAhoComAnual		:= 9;
Set ConAhoComManCta		:= 7;
Set ConAhoComFalCob		:= 11;
Set ConAhoComDisSeg		:= 15;

Set ConAhoIvaApe		:= 6;
Set ConAhoIvaAnual		:= 10;
Set ConAhoIvaManCta		:= 8;
Set ConAhoIvaFalCob		:= 12;
Set ConAhoIvaDisSeg		:= 16;

Set ConAhoIntGravad		:= 2;
Set ConAhoIntExento		:= 3;
Set ConAhoIDE			:= 21;
Set ConAhoISR			:= 4;
Set ConAhoPasivo		:= 1;

Set VarTipoInstruCta	:=	2;
set ConAhoComSalProm	:= 35;
Set ConAhoIvaSalProm	:= 36;

Set Var_CenCosto	:= 0;


CASE Par_Movimiento

	WHEN Var_MovComAper
	THEN
		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoComApe;
		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComAper;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoComApe
				and movs.TipoMovAhoID = Var_MovComAper;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoComApe
				and movs.TipoMovAhoID = Var_MovComAper
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoComApe
				and movs.TipoMovAhoID = Var_MovComAper;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComApe
				and movs.TipoMovAhoID = Var_MovComAper;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComApe
				and movs.TipoMovAhoID = Var_MovComAper;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComAper;


		insert into DETALLEPOLIZA (
			EmpresaID,			PolizaID, 			Fecha, 				CentroCostoID,		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
 			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID,		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
 			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComAper;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;
		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComAper;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComAper;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComAper
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComAper;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComAper;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComAper;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComAper;


		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 			CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 				Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 				FechaActual,
 			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 			CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 				Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 				FechaActual,
 			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComAper;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoIvaApe;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaAper;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoIvaApe
				and movs.TipoMovAhoID = Var_MovIvaAper;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoIvaApe
				and movs.TipoMovAhoID = Var_MovIvaAper;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoIvaApe
				and movs.TipoMovAhoID = Var_MovIvaAper
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaApe
				and movs.TipoMovAhoID = Var_MovIvaAper;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaApe
				and movs.TipoMovAhoID = Var_MovIvaAper;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaAper;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 			CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 				Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 				FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaAper;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaAper;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaAper;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovIvaAper
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaAper;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaAper;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaAper;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaAper;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaAper;


	WHEN Var_MovComAniv
	THEN
		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoComAnual;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComAniv;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoComAnual
				and movs.TipoMovAhoID = Var_MovComAniv;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoComAnual
				and movs.TipoMovAhoID	= Var_MovComAniv
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoComAnual
				and movs.TipoMovAhoID = Var_MovComAniv;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComAnual
				and movs.TipoMovAhoID = Var_MovComAniv;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComAnual
				and movs.TipoMovAhoID = Var_MovComAniv;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComAniv;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComAniv;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComAniv;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComAniv;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovComAniv
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComAniv;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComAniv;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComAniv;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComAniv;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComAniv;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoIvaAnual;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaAniv;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoIvaAnual
				and movs.TipoMovAhoID = Var_MovIvaAniv;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoIvaAnual
				and movs.TipoMovAhoID	= Var_MovIvaAniv
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoIvaAnual
				and movs.TipoMovAhoID = Var_MovIvaAniv;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaAnual
				and movs.TipoMovAhoID = Var_MovIvaAniv;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaAnual
				and movs.TipoMovAhoID = Var_MovIvaAniv;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaAniv;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaAniv;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaAniv;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaAniv;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovIvaAniv
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaAniv;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaAniv;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaAniv;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaAniv;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaAniv;



	WHEN Var_MovComDisS
	THEN
		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoComDisSeg;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComDisS;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoComDisSeg
				and movs.TipoMovAhoID = Var_MovComDisS;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoComDisSeg
				and movs.TipoMovAhoID	= Var_MovComDisS
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoComDisSeg
				and movs.TipoMovAhoID = Var_MovComDisS;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComDisSeg
				and movs.TipoMovAhoID = Var_MovComDisS;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComDisSeg
				and movs.TipoMovAhoID = Var_MovComDisS;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComDisS;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComDisS;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComDisS;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComDisS;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovComDisS
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComDisS;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComDisS;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComDisS;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComDisS;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario,	 		FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComDisS;



		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoIvaDisSeg;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaDisS;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoIvaDisSeg
				and movs.TipoMovAhoID = Var_MovIvaDisS;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoIvaDisSeg
				and movs.TipoMovAhoID	= Var_MovIvaDisS
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoIvaDisSeg
				and movs.TipoMovAhoID = Var_MovIvaDisS;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaDisSeg
				and movs.TipoMovAhoID = Var_MovIvaDisS;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaDisSeg
				and movs.TipoMovAhoID = Var_MovIvaDisS;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaDisS;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaDisS;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaDisS;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaDisS;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovIvaDisS
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaDisS;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaDisS;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaDisS;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaDisS;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 		FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaDisS;


	WHEN Var_MovComManC
	THEN

		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoComManCta;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComManC;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoComManCta
				and movs.TipoMovAhoID = Var_MovComManC;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoComManCta
				and movs.TipoMovAhoID	= Var_MovComManC
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoComManCta
				and movs.TipoMovAhoID = Var_MovComManC;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComManCta
				and movs.TipoMovAhoID = Var_MovComManC;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComManCta
				and movs.TipoMovAhoID = Var_MovComManC;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComManC;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComManC;



		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComManC;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComManC;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovComManC
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComManC;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComManC;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComManC;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComManC;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComManC;



		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoIvaManCta;

		update TMPCONTAMOVS movs set
			movs.Nomenclatura = ifnull(Var_Nomenclatura, Cadena_Vacia)
		where movs.TipoMovAhoID = Var_MovIvaManC;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaManC;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoIvaManCta
				and movs.TipoMovAhoID = Var_MovIvaManC;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoIvaManCta
				and movs.TipoMovAhoID	= Var_MovIvaManC
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoIvaManCta
				and movs.TipoMovAhoID = Var_MovIvaManC;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaManCta
				and movs.TipoMovAhoID = Var_MovIvaManC;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaManCta
				and movs.TipoMovAhoID = Var_MovIvaManC;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaManC;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaManC;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta,
				movs.Nomenclatura	= Var_Nomenclatura
			where movs.TipoMovAhoID = Var_MovIvaManC;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaManC;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovIvaManC
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaManC;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaManC;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaManC;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaManC;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaManC;


	WHEN Var_MovComFalC
	THEN
		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoComFalCob;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComFalC;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoComFalCob
				and movs.TipoMovAhoID = Var_MovComFalC;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoComFalCob
				and movs.TipoMovAhoID	= Var_MovComFalC
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoComFalCob
				and movs.TipoMovAhoID = Var_MovComFalC;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComFalCob
				and movs.TipoMovAhoID = Var_MovComFalC;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComFalCob
				and movs.TipoMovAhoID = Var_MovComFalC;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComFalC;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComFalC;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComFalC;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComFalC;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovComFalC
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComFalC;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComFalC;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComFalC;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComFalC;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComFalC;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoIvaFalCob;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaFalC;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoIvaFalCob
				and movs.TipoMovAhoID = Var_MovIvaFalC;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoIvaFalCob
				and movs.TipoMovAhoID	= Var_MovIvaFalC
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoIvaFalCob
				and movs.TipoMovAhoID = Var_MovIvaFalC;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaFalCob
				and movs.TipoMovAhoID = Var_MovIvaFalC;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaFalCob
				and movs.TipoMovAhoID = Var_MovIvaFalC;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaFalC;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaFalC;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaFalC;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaFalC;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovIvaFalC
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaFalC;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaFalC;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaFalC;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaFalC;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaFalC;


	WHEN Var_MovRendGra
	THEN

		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoIntGravad;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovRendGra;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoIntGravad
				and movs.TipoMovAhoID = Var_MovRendGra;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoIntGravad
				and movs.TipoMovAhoID	= Var_MovRendGra
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoIntGravad
				and movs.TipoMovAhoID = Var_MovRendGra;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIntGravad
				and movs.TipoMovAhoID = Var_MovRendGra;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIntGravad
				and movs.TipoMovAhoID = Var_MovRendGra;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovRendGra;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovRendGra;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovRendGra;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRendGra;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovRendGra
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRendGra;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRendGra;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRendGra;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovRendGra;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovRendGra;



	WHEN Var_MovRendExc
	THEN

		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoIntExento;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovRendExc;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoIntExento
				and movs.TipoMovAhoID = Var_MovRendExc;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoIntExento
				and movs.TipoMovAhoID	= Var_MovRendExc
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoIntExento
				and movs.TipoMovAhoID = Var_MovRendExc;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIntExento
				and movs.TipoMovAhoID = Var_MovRendExc;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIntExento
				and movs.TipoMovAhoID = Var_MovRendExc;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovRendExc;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovRendExc;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovRendExc;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRendExc;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovRendExc
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRendExc;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRendExc;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRendExc;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovRendExc;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovRendExc;


	WHEN Var_MovIDE
	THEN

		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoIDE;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIDE;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoIDE
				and movs.TipoMovAhoID = Var_MovIDE;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoIDE
				and movs.TipoMovAhoID	= Var_MovIDE
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoIDE
				and movs.TipoMovAhoID = Var_MovIDE;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIDE
				and movs.TipoMovAhoID = Var_MovIDE;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIDE
				and movs.TipoMovAhoID = Var_MovIDE;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIDE;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos,	 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIDE;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIDE;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIDE;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovIDE
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIDE;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIDE;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIDE;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIDE;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 		FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIDE;



	WHEN  Var_MovRetISR
	THEN
		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoISR;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovRetISR;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoISR
				and movs.TipoMovAhoID = Var_MovRetISR;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoISR
				and movs.TipoMovAhoID	= Var_MovRetISR
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoISR
				and movs.TipoMovAhoID = Var_MovRetISR;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoISR
				and movs.TipoMovAhoID = Var_MovRetISR;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoISR
				and movs.TipoMovAhoID = Var_MovRetISR;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovRetISR;


		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovRetISR;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovRetISR;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRetISR;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovRetISR
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRetISR;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRetISR;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovRetISR;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovRetISR;


		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovRetISR;

	WHEN Var_MovComSalProm	THEN
		-- Seccion de Comision por Saldo de Promedio
		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoComSalProm;
		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComSalProm;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoComSalProm
				and movs.TipoMovAhoID = Var_MovComSalProm;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoComSalProm
				and movs.TipoMovAhoID = Var_MovComSalProm
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoComSalProm
				and movs.TipoMovAhoID = Var_MovComSalProm;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComSalProm
				and movs.TipoMovAhoID = Var_MovComSalProm;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoComSalProm
				and movs.TipoMovAhoID = Var_MovComSalProm;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComSalProm;


		insert into DETALLEPOLIZA (
			EmpresaID,			PolizaID, 			Fecha, 				CentroCostoID,		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
 			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID,		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
 			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComSalProm;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;
		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovComSalProm;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComSalProm;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComSalProm
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComSalProm;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComSalProm;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovComSalProm;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovComSalProm;


		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 			CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 				Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 				FechaActual,
 			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 			CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 				Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 				FechaActual,
 			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovComSalProm;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoIvaSalProm;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaSalProm;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoIvaSalProm
				and movs.TipoMovAhoID = Var_MovIvaSalProm;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoIvaSalProm
				and movs.TipoMovAhoID = Var_MovIvaSalProm;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoIvaSalProm
				and movs.TipoMovAhoID = Var_MovIvaSalProm
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaSalProm
				and movs.TipoMovAhoID = Var_MovIvaSalProm;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoIvaSalProm
				and movs.TipoMovAhoID = Var_MovIvaSalProm;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaSalProm;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 			CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 				Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 				FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Abonos, 			Cargos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaSalProm;


		select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
			from  CUENTASMAYORAHO Ctm
			where Ctm.ConceptoAhoID	= ConAhoPasivo;

		Set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
		Set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);
		if(Var_Nomenclatura = Cadena_Vacia) then
			Set Var_Cuenta := Cuenta_Vacia;
		else
			Set Var_Cuenta	:= Var_Nomenclatura;
			if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
				Set Var_Cuenta := REPLACE(Var_Cuenta , For_CueMayor, Var_CuentaMayor);
			end if;

			update TMPCONTAMOVS movs Set
				movs.CuentaCompleta = Var_Cuenta
			where movs.TipoMovAhoID = Var_MovIvaSalProm;

			if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPROAHO Sub Set
					movs.SubCtaTipProAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipProduc, Sub.SubCuenta)
				where Sub.TipoProductoID	= movs.TipoCuentaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaSalProm;
			end if;


			if LOCATE(For_Clasif, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTACLASIFAHO Sub Set
					movs.SubCtaClasifAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta , For_Clasif, Sub.SubCuenta)
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID	= Var_MovIvaSalProm
				and Sub.Clasificacion	= movs.ClasificacionConta;
			end if;

			if LOCATE(For_Moneda, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTAMONEDAAHO Sub Set
					movs.SubCtaMonAho = ifnull(Sub.SubCuenta, Cadena_Vacia),
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_Moneda, Sub.SubCuenta)
				where Sub.MonedaID	= movs.MonedaID
				and	Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaSalProm;
			end if;

			if LOCATE(For_TipRend, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTARENDIAHO Sub Set
					movs.SubCtaTipRenAho = case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipRend, case when movs.GeneraInteres = Ren_Si then
										ifnull(Sub.Paga, Cadena_Vacia)	else
										ifnull(Sub.NoPaga, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaSalProm;
			end if;

			if LOCATE(For_TipCliente, Var_Cuenta) > 0 then
				update TMPCONTAMOVS movs,
					SUBCTATIPERAHO Sub Set
					movs.SubCtaTipPerAho = case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end ,
					movs.CuentaCompleta = REPLACE(movs.CuentaCompleta, For_TipCliente, case when movs.TipoPersona = Per_Fisica then
										ifnull(Sub.Fisica, Cadena_Vacia)	else
										ifnull(Sub.Moral, Cadena_Vacia) end )
				where Sub.ConceptoAhoID	= ConAhoPasivo
				and movs.TipoMovAhoID = Var_MovIvaSalProm;
			end if;
		end if;

		update TMPCONTAMOVS Set
			CentroCostoID = case when LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0
									then SucursalCta
									else case when LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0
											then SucursalOrigen end end,
			CuentaCompleta = REPLACE(CuentaCompleta , '-', Cadena_Vacia)
		where TipoMovAhoID = Var_MovIvaSalProm;

		insert into DETALLEPOLIZA (
			EmpresaID, 			PolizaID, 			Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento, 		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont,	TipoInstrumentoID,	Usuario, 			FechaActual,
			DireccionIP,		ProgramaID, 		Sucursal, 			NumTransaccion)
		select
			EmpresaID, 			Par_Poliza, 		Fecha, 				CentroCostoID, 		CuentaCompleta,
			Instrumento,		MonedaID, 			Cargos, 			Abonos, 			Descripcion,
			Referencia, 		ProcedimientoCont, 	VarTipoInstruCta,	Usuario, 			FechaActual,
			DireccionIP, 		ProgramaID, 		Sucursal, 			NumTransaccion
		from TMPCONTAMOVS
		where TipoMovAhoID = Var_MovIvaSalProm;



END CASE;

END TerminaStore$$