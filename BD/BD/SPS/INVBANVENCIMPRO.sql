-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANVENCIMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVBANVENCIMPRO`;
DELIMITER $$


CREATE PROCEDURE `INVBANVENCIMPRO`(


	Par_Fecha				date,
	Par_EmpresaID			int,
	Par_Salida				char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(400),

	Aud_Usuario			 int,
	Aud_FechaActual		 DateTime,
	Aud_DireccionIP		 varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

)

TerminaStore: BEGIN


	DECLARE Sig_DiaHab			date;
	DECLARE Var_EsHabil			char(1);
	DECLARE Err_Consecutivo		bigint;

	DECLARE Var_InversionID		bigint;
	DECLARE Var_InstitucionID	int;
	DECLARE Var_NumCtaInstit	varchar(20);
	DECLARE Var_TipoInversion	varchar(200);
	DECLARE Var_Monto			decimal(14,2);
	DECLARE Var_MontoCC			decimal(14,2);
	DECLARE Var_Tasa			decimal(12,4);
	DECLARE Var_FechaVencim		date;
	DECLARE Var_MonedaID		int;
	DECLARE Var_SalIntProv		decimal(14,4);
	DECLARE Var_InteresRet		decimal(14,2);
	DECLARE Var_IntProvRed		decimal(14,2);

	DECLARE Var_ContadorInv			int;
	DECLARE Var_Poliza				bigint;
	DECLARE Error_Key				int;
	DECLARE Var_InversionStr		varchar(50);
	DECLARE Var_CuentaAhoID			int;
	DECLARE Var_TotRecibir			decimal(14,4);
	DECLARE Var_CentroCostoID		int(11);
	DECLARE Var_CCDetalle			int(11);
	DECLARE Var_TempInversionID		int(11);
	DECLARE Var_RealizarMovOper		char(1);
	DECLARE Var_SalIntProvisionCC	decimal(14,4);
	DECLARE Var_ISR					decimal(14,4);
	DECLARE Var_Inv 				char(1);


	DECLARE Cadena_Vacia			char(1);
	DECLARE Fecha_Vacia				date;
	DECLARE Entero_Cero				int;
	DECLARE Un_DiaHabil				int;
	DECLARE Pro_VenInvBan			int;
	DECLARE Des_VenCap				varchar(100);
	DECLARE Des_VenInt				varchar(100);
	DECLARE Des_VenRet				varchar(100);
	DECLARE Des_Contable			varchar(100);
	DECLARE AltaPoliza_SI			char(1);
	DECLARE AltaPoliza_NO			char(1);
	DECLARE AltaMovAho_NO			char(1);
	DECLARE Str_SinError			char(3);
	DECLARE Int_SinError			int;
	DECLARE Conciliado_NO			char(1);
	DECLARE Nat_Cargo				char(1);
	DECLARE Nat_Abono				char(1);
	DECLARE Tip_RegAuto				char(1);
	DECLARE Est_Pagada				char(1);
	DECLARE Pol_Automatica			char(1);
	DECLARE Con_VencInver			int;
	DECLARE Salida_NO				char(1);
	DECLARE Salida_SI				char(1);
	DECLARE Tip_VencInver			char(4);
	DECLARE Tip_RendInver			char(4);
	DECLARE Tip_ReteInver			char(4);

	DECLARE Ope_ReteInver			char(3);
	DECLARE Ope_RendInver			char(3);
	DECLARE Ope_VencInver			char(3);

	DECLARE Teso_CapInvBan			int;
	DECLARE Teso_IntInvBan			int;
	DECLARE Teso_RetInvBan			int;

	DECLARE Si_RealizaMovOper		char(1);
	DECLARE No_RealizaMovOper		char(1);
	DECLARE Si_RealizaContaTeso		char(1);
	DECLARE No_RealizaContaTeso		char(1);
	DECLARE Es_Inversion			char(1);
	DECLARE Es_Reporto				char(1);


	DECLARE CURSORVENCIM CURSOR FOR
		SELECT	Inv.InversionID,InstitucionID, NumCtaInstit,	TipoInversion,	dis.Monto as MontoCC, Inv.Monto,	Tasa,
				FechaVencimiento,	MonedaID,	SalIntProvision,		InteresRetener, dis.CentroCosto, SalIntProvisionCC, ISR, ClasificacionInver
			from INVBANCARIA Inv
				inner join DISTCCINVBANCARIA as dis
				on Inv.InversionID=dis.InversionID
			where Estatus	= 'A'
			and (	FechaVencimiento = Par_Fecha
			or		FechaVencimiento < Sig_DiaHab	);


	Set Cadena_Vacia		:= '';
	Set Fecha_Vacia			:= '1900-01-01';
	Set Entero_Cero			:= 0;
	Set Un_DiaHabil			:= 1;
	Set Pro_VenInvBan		:= 602;

	Set AltaPoliza_SI		:= 'S';
	Set AltaPoliza_NO		:= 'N';
	Set AltaMovAho_NO		:= 'N';
	Set Str_SinError		:= '000';
	Set Int_SinError		:= 0;

	Set Conciliado_NO		:= 'N';
	Set Nat_Cargo			:= 'C';
	Set Nat_Abono			:= 'A';
	Set Tip_RegAuto			:= 'A';
	Set Est_Pagada			:= 'P';
	Set Pol_Automatica		:= 'A';
	Set Con_VencInver		:= 74;
	Set Salida_NO			:= 'N';
	Set Salida_SI			:= 'S';

	Set Tip_VencInver		:= '8';
	Set Tip_RendInver		:= '9';
	Set Tip_ReteInver		:= '10';

	Set Ope_VencInver		:= '001';
	Set Ope_RendInver		:= '002';
	Set Ope_ReteInver		:= '003';

	Set Teso_CapInvBan		:= 1;
	Set Teso_IntInvBan		:= 2;
	Set Teso_RetInvBan		:= 4;

	Set Des_VenCap			:= 'VENCIMIENTO DE INVERSION. CAPITAL';
	Set Des_VenInt			:= 'VENCIMIENTO DE INVERSION. RENDIMIENTO';
	Set Des_VenRet			:= 'VENCIMIENTO DE INVERSION. RETENCION';
	Set Des_Contable		:= 'VENCIMIENTO DE INV.BANCARIA';
	SET Si_RealizaMovOper	:= 'S';
	SET No_RealizaMovOper	:= 'N';

	SET Si_RealizaContaTeso := 'S';
	SET No_RealizaContaTeso := 'N';

	set Var_CentroCostoID	:= Entero_Cero;
	SET Var_CCDetalle		:= Entero_Cero;
	SET Es_Inversion		:= 'I';
	SET Es_Reporto			:= 'R';




	call DIASFESTIVOSCAL(
		Par_Fecha,		Un_DiaHabil,		Sig_DiaHab,		Var_EsHabil,	Par_EmpresaID,
		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,
		Aud_NumTransaccion);

	select	count(InversionID) into Var_ContadorInv
			from INVBANCARIA Inv
			where Estatus	= 'A'
			and (	FechaVencimiento = Par_Fecha
			or		FechaVencimiento < Sig_DiaHab	);

	set Var_ContadorInv := ifnull(Var_ContadorInv, Entero_Cero);

	if (Var_ContadorInv > Entero_Cero) then
		call MAESTROPOLIZAALT(
			Var_Poliza,		Par_EmpresaID, Par_Fecha,	Pol_Automatica,	 Con_VencInver,
			Des_Contable,		Salida_NO,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
	end if;


	OPEN CURSORVENCIM;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP

		FETCH CURSORVENCIM into
			Var_InversionID,	Var_InstitucionID,	Var_NumCtaInstit,	Var_TipoInversion,	Var_MontoCC,
			Var_Monto,			Var_Tasa,			Var_FechaVencim,	Var_MonedaID,		Var_SalIntProv,
			Var_InteresRet,	 Var_CCDetalle,		Var_SalIntProvisionCC, Var_ISR, 			Var_Inv;
		START TRANSACTION;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
			DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
			DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
			DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

			set Error_Key	= Entero_Cero;
			set Var_InversionStr = CONCAT(convert(Var_InversionID, char));

			set Var_IntProvRed	= round(Var_SalIntProv, 2);



			IF( Var_InversionID != Var_TempInversionID ) then
				SET Var_TempInversionID := Var_InversionID;
				SET Var_RealizarMovOper := Si_RealizaMovOper;
			ELSE
				SET Var_RealizarMovOper := No_RealizaMovOper;
			END IF;

			if(Var_Inv = Es_Inversion) then
					Set Teso_CapInvBan		:= 1;
					Set Teso_IntInvBan		:= 2;
					Set Teso_RetInvBan		:= 4;
				ELSE
					if(Var_Inv = Es_Reporto) then
						Set Teso_CapInvBan		:= 5;
						Set Teso_IntInvBan		:= 6;
						Set Teso_RetInvBan		:= 8;
					end if;
			END IF;




			set Var_IntProvRed			:= round(Var_SalIntProvisionCC, 2);
			set Var_SalIntProvisionCC	:= ifnull(Var_SalIntProvisionCC, Entero_Cero);



			call CONTAINVBANPRO(
					Var_InversionID,			Var_CCDetalle,				Var_TipoInversion,			Var_MonedaID,				Var_InstitucionID,
					Var_FechaVencim,			Var_MontoCC,				Var_MontoCC,				Var_NumCtaInstit,			AltaPoliza_NO,
					Con_VencInver,				Teso_CapInvBan,			 	Tip_VencInver,				Des_Contable,				Des_VenCap,
					Nat_Abono,					Var_Poliza,					Si_RealizaMovOper,			Si_RealizaContaTeso,		Par_Salida,
					Par_NumErr,					Par_ErrMen,					Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
					Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);


			call CONTAINVBANPRO(
				Var_InversionID,			Var_CCDetalle,				Var_TipoInversion,			Var_MonedaID,				Var_InstitucionID,
				Var_FechaVencim,			Var_SalIntProvisionCC,		Var_SalIntProvisionCC,		Var_NumCtaInstit,			AltaPoliza_NO,
				Con_VencInver,				Teso_IntInvBan,				Tip_RendInver,				Des_Contable,				Des_VenInt,
				Nat_Abono,Var_Poliza,		Si_RealizaMovOper,			Si_RealizaContaTeso,		Par_Salida,					Par_NumErr,
				Par_ErrMen,					Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,
				Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);



			if(Var_InteresRet > Entero_Cero) then
				call CONTAINVBANPRO(
					Var_InversionID,		Var_CCDetalle,				Var_TipoInversion,				Var_MonedaID,				Var_InstitucionID,
					Var_FechaVencim,		Var_ISR,					Var_ISR,						Var_NumCtaInstit,			AltaPoliza_NO,
					Con_VencInver,			Teso_RetInvBan,				Tip_ReteInver,					Des_Contable,				Des_VenRet,
					Nat_Cargo,				Var_Poliza,					Si_RealizaMovOper,				Si_RealizaContaTeso,		Par_Salida,
					Par_NumErr,				Par_ErrMen,					Par_EmpresaID,					Aud_Usuario,				Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,					Aud_NumTransaccion);
			end if;








			update INVBANCARIA set
				Estatus = Est_Pagada
				where InversionID = Var_InversionID;

		END;

		if Error_Key = 0 then
			COMMIT;
		end if;
		if Error_Key = 1 then
			ROLLBACK;
			START TRANSACTION;
				call EXCEPCIONBATCHALT(
					Pro_VenInvBan,	Par_Fecha,		Var_InversionStr,	'ERROR DE SQL GENERAL',
					Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion);
			COMMIT;
		end if;
		if Error_Key = 2 then
			ROLLBACK;
			START TRANSACTION;
				call EXCEPCIONBATCHALT(
					Pro_VenInvBan,	Par_Fecha,			Var_InversionStr,	'ERROR EN ALTA, LLAVE DUPLICADA',
					Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion);
			COMMIT;
		end if;
		if Error_Key = 3 then
			ROLLBACK;
			START TRANSACTION;
				call EXCEPCIONBATCHALT(
				Pro_VenInvBan,	Par_Fecha,		Var_InversionStr,	'ERROR AL LLAMAR A STORE PROCEDURE',
				Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID, Aud_Sucursal,	Aud_NumTransaccion);
			COMMIT;
		end if;
		if Error_Key = 4 then
			ROLLBACK;
			START TRANSACTION;
				call EXCEPCIONBATCHALT(
					Pro_VenInvBan,	Par_Fecha,			Var_InversionStr,	'ERROR VALORES NULOS',
					Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion);
			COMMIT;
		end if;

		End LOOP;
	END;
	CLOSE CURSORVENCIM;

	if (Par_Salida = Salida_SI) then
		select '000' as NumErr ,
				'Proceso Realizado Exitosamente.' as ErrMen,
				'btnProcesar' as control;

	end if;

END TerminaStore$$