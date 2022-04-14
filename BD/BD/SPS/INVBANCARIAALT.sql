-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVBANCARIAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVBANCARIAALT`;
DELIMITER $$


CREATE PROCEDURE `INVBANCARIAALT`(

	Par_InstitucionID		int,
	Par_NumCtaInstit		varchar(20),
	Par_TipoInversion		varchar(150),
	Par_FechaInicio			DateTime,
	Par_FechaVencim			DateTime,

	Par_Monto				decimal(14,2),
	Par_Plazo				int,
	Par_Tasa				decimal(12,4),
	Par_TasaISR				decimal(12,4),
	Par_TasaNeta			decimal(12,4),

	Par_InteresGenerado		decimal(12,4),
	Par_InteresRecibir		decimal(12,4),
	Par_InteresRetener		decimal(12,4),
	Par_totalRecibir		decimal(14,2),
	Par_UsuarioID			int,

	Par_MonedaID			int,
	Par_DiasBase			int,
	Par_ClasificacionInver	char(1),
	Par_TipoTitulo			char(1),
	Par_TipoRestriccion		char(1),

	Par_TipoDeuda			char(1),
	Par_Salida				char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(400),
	out Par_Consecutivo		int,

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),

	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

		)

TerminaStore: BEGIN


	DECLARE Var_Consecutivo		int;
	DECLARE Var_NumInver		varchar(15);
	DECLARE Int_NumErr			int;
	DECLARE Err_Consecutivo		bigint;
	DECLARE Var_Poliza			bigint;
	DECLARE Var_CuentaAhoID		bigint(12);
	DECLARE Var_CentroCostoID	int(11);
	DECLARE Var_Control			varchar(20);


	DECLARE Entero_Cero			int;
	DECLARE Cadena_Vacia		char(1);
	DECLARE Var_Estatus			char(1);

	DECLARE Nat_Cargo			char(1);
	DECLARE Nat_Abono			char(1);
	DECLARE Salida_NO			char(1);
	DECLARE Salida_SI			char(1);
	DECLARE Sin_Error			char(3);
	DECLARE Des_Movimi			varchar(100);
	DECLARE AltaPoliza_SI		char(1);
	DECLARE AltaPoliza_NO		char(1);
	DECLARE AltaMovAho_NO		char(1);
	DECLARE Str_SinError		char(3);
	DECLARE Int_SinError		int;
	DECLARE Con_AltaInvBan		int;
	DECLARE Teso_AltaInvBan		int;
	DECLARE Inversion_Valores	char(1);
	DECLARE Reportos			char(1);
	DECLARE Titulos				char(25);
	DECLARE Restricciones		char(25);
	DECLARE TiposDeuda			char(25);


	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET Var_Estatus				:= 'A';

	SET Nat_Cargo				:= 'C';
	SET Nat_Abono				:= 'A';


	SET Salida_NO				:= 'N';
	SET Salida_SI				:= 'S';
	SET Sin_Error				:= '000';
	SET AltaPoliza_SI			:= 'S';
	SET AltaPoliza_NO			:= 'N';
	SET AltaMovAho_NO			:= 'N';
	SET Str_SinError			:= '000';
	SET Int_SinError			:= 0;
	SET Con_AltaInvBan			:= 73;
	SET Teso_AltaInvBan			:= 1;
	SET Inversion_Valores		:='I';
	SET Reportos				:='R';
	SET Titulos					:='N,D,C';
	SET Restricciones			:='C,S';
	SET TiposDeuda				:='G,B,O';
	SET Des_Movimi				:= 'CARGO PARA INV.BANCARIA';
	SET Var_Control				:= 'inversionID';
	Set Aud_FechaActual := CURRENT_TIMESTAMP();



		ManejoErrores:BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
										 "estamos trabajando para resolverla. Disculpe las molestias que ",
										 "esto le ocasiona. Ref: SP-INVBANCARIAALT");
			END;

			SET Par_TipoTitulo 		:= ifnull(Par_TipoTitulo, Cadena_Vacia);
			SET Par_TipoRestriccion	:= ifnull(Par_TipoRestriccion, Cadena_Vacia);
			SET Par_TipoDeuda		:= ifnull(Par_TipoDeuda, Cadena_Vacia);
			select CuentaAhoID, CentroCostoID
					into Var_CuentaAhoID, Var_CentroCostoID
				from CUENTASAHOTESO
				where InstitucionID = Par_InstitucionID
				  and NumCtaInstit  = Par_NumCtaInstit;
			SET Var_CentroCostoID :=ifnull(Var_CentroCostoID,Entero_Cero );

			if(ifnull(Par_InstitucionID, Entero_Cero)) = Entero_Cero then
					SET Par_NumErr	  := 1;
					SET Par_ErrMen	  := 'La Intitucion esta Vacia.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'institucionID';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Var_CuentaAhoID, Entero_Cero)) = Entero_Cero then
					SET Par_NumErr	  := 2;
					SET Par_ErrMen	  := 'La Cuenta esta Vacia';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'numCtaInstit';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_TipoInversion, Cadena_Vacia)) = Cadena_Vacia then
					SET Par_NumErr	  := 3;
					SET Par_ErrMen	  := 'La Referencia de la Inversion esta Vacia.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'tipoInversion';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_FechaInicio, Cadena_Vacia)) = Cadena_Vacia then
					SET Par_NumErr	  := 4;
					SET Par_ErrMen	  := 'La Fecha de Inicio esta Vacia.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'fechaInicio';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_FechaVencim, Cadena_Vacia)) = Cadena_Vacia then
					SET Par_NumErr	  := 5;
					SET Par_ErrMen	  := 'La Fecha vencimiento esta Vacia.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'fechaVencimiento';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_Monto, Cadena_Vacia)) = Cadena_Vacia then
					SET Par_NumErr	  := 6;
					SET Par_ErrMen	  := 'El Monto esta Vacio.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'monto';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_Plazo,Entero_Cero)) = Entero_Cero then
					SET Par_NumErr	  := 7;
					SET Par_ErrMen	  := 'El Plazo esta Vacio.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'plazo';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_Tasa, Entero_Cero)) <= Entero_Cero then
					SET Par_NumErr	  := 8;
					SET Par_ErrMen	  := 'Tasa Bruta Incorrecta.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'tasa';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_TasaISR, Entero_Cero))  < Entero_Cero then
					SET Par_NumErr	  := 9;
					SET Par_ErrMen	  := 'Tasa ISR Incorrecta.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'tasaISR';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_TasaNeta,Entero_Cero)) <= Entero_Cero then
					SET Par_NumErr	  := 10;
					SET Par_ErrMen	  := 'Tasa Neta Incorrecta.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'agrega';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_InteresGenerado, Entero_Cero)) <= Entero_Cero then
					SET Par_NumErr	  := 11;
					SET Par_ErrMen	  := 'Interes Generado Incorrecto.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'agrega';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_InteresRecibir,Entero_Cero)) = Entero_Cero then
					SET Par_NumErr	  := 12;
					SET Par_ErrMen	  := 'Interes a Recibir Incorrecto.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'agrega';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_InteresRetener,Entero_Cero)) < Entero_Cero then
					SET Par_NumErr	  := 13;
					SET Par_ErrMen	  := 'Interes a Retener Incorrecto.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'agrega';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_totalRecibir,Entero_Cero)) = Entero_Cero then
					SET Par_NumErr	  := 14;
					SET Par_ErrMen	  := 'Total a Recibir Incorrecto.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'agrega';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_MonedaID,Entero_Cero)) = Entero_Cero then
					SET Par_NumErr	  := 15;
					SET Par_ErrMen	  := 'El Tipo de Moneda esta Vacio.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'agrega';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_NumCtaInstit, Cadena_Vacia)) = Cadena_Vacia then
					SET Par_NumErr	  := 16;
					SET Par_ErrMen	  := 'Cuenta Bancaria Incorrecta.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'numCtaInstit';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_DiasBase, Entero_Cero)) = Entero_Cero then
					SET Par_NumErr	  := 17;
					SET Par_ErrMen	  := 'El Anio Bancario en Dias Viene Vacio.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'diasBase';
				LEAVE ManejoErrores;
			end if;

			if(ifnull(Par_ClasificacionInver, Cadena_Vacia)) = Cadena_Vacia then
					SET Par_NumErr	  := 18;
					SET Par_ErrMen	  := 'La Clasificacion de la Inversion viene Vacia.';
					SET Par_Consecutivo := Entero_Cero;
					SET Var_Control		:= 'clasificacionInver';
				LEAVE ManejoErrores;
				else
				if(Par_ClasificacionInver=Inversion_Valores) then
					if(ifnull(Par_TipoTitulo,Cadena_Vacia))=Cadena_Vacia then
						SET Par_NumErr	  := 19;
						SET Par_ErrMen	  := 'El Tipo de Titulo viene Vacio.';
						SET Par_Consecutivo := Entero_Cero;
						SET Var_Control		:= 'ttN';
						LEAVE ManejoErrores;
					end if;
					if(LOCATE(Par_TipoTitulo, Titulos)=0) then
						SET Par_NumErr	  := 20;
						SET Par_ErrMen	  := 'La opcion para el Tipo de Titulo no es Valida.';
						SET Par_Consecutivo := Entero_Cero;
						SET Var_Control		:= 'ttN';
						LEAVE ManejoErrores;
					end if;
					if(ifnull(Par_TipoRestriccion, Cadena_Vacia))=Cadena_Vacia then
						SET Par_NumErr	  := 21;
						SET Par_ErrMen	  := 'El Tipo de Restriccion viene Vacio.';
						SET Par_Consecutivo := Entero_Cero;
						SET Var_Control		:= 'resC';
						LEAVE ManejoErrores;
					end if;
					if(LOCATE(Par_TipoRestriccion, Restricciones)=0) then
						SET Par_NumErr	  := 22;
						SET Par_ErrMen	  := 'La opcion para el Tipo de Restriccion no es Valida.';
						SET Par_Consecutivo := Entero_Cero;
						SET Var_Control		:= 'resC';
						LEAVE ManejoErrores;
					end if;
					if(ifnull(Par_TipoDeuda, Cadena_Vacia))=Cadena_Vacia then
						SET Par_NumErr	  := 23;
						SET Par_ErrMen	  := 'El Tipo de Deuda viene Vacia.';
						SET Par_Consecutivo := Entero_Cero;
						SET Var_Control		:= 'tdG';
						LEAVE ManejoErrores;
					end if;
					if(LOCATE(Par_TipoDeuda, TiposDeuda)=0) then
						SET Par_NumErr	  := 24;
						SET Par_ErrMen	  := 'La opcion para el Tipo de Deuda no es Valida.';
						SET Par_Consecutivo := Entero_Cero;
						SET Var_Control		:= 'tdG';
						LEAVE ManejoErrores;
					end if;
				else
					if(Par_ClasificacionInver=Reportos) then
						if(ifnull(Par_TipoDeuda, Cadena_Vacia))=Cadena_Vacia then
							SET Par_NumErr	  := 25;
							SET Par_ErrMen	  := 'El Tipo de Deuda viene Vacia.';
							SET Par_Consecutivo := Entero_Cero;
							SET Var_Control		:= 'tdG';
							LEAVE ManejoErrores;
						end if;
						if(LOCATE(Par_TipoDeuda, TiposDeuda)=0) then
							SET Par_NumErr	  := 26;
							SET Par_ErrMen	  := 'La opcion para el Tipo de Deuda no es Valida.';
							SET Par_Consecutivo := Entero_Cero;
							SET Var_Control		:= 'tdG';
							LEAVE ManejoErrores;
						end if;

					else
						SET Par_NumErr	  := 27;
						SET Par_ErrMen	  := 'La opcion para el Tipo de Restriccion no es Valida.';
						SET Par_Consecutivo := Entero_Cero;
						SET Var_Control		:= 'resC';
						LEAVE ManejoErrores;
					end if;
				end if;
			end if;


			SET Var_Consecutivo = (select ifnull(Max(InversionID),Entero_Cero)+1 from INVBANCARIA);

			INSERT INTO INVBANCARIA(
				InversionID,		InstitucionID,		NumCtaInstit,		TipoInversion,		FechaInicio,
				FechaVencimiento,	Monto,				Plazo,				Tasa,				TasaISR,
				TasaNeta,			InteresGenerado,	InteresRecibir,		InteresRetener,		TotalRecibir,
				Estatus,			MonedaID,			SalIntProvision,	DiasBase,			ClasificacionInver,
				TipoTitulo,			TipoRestriccion,	TipoDeuda,			UsuarioID,			EmpresaID,
				Usuario,			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
				NumTransaccion)
				VALUES(
				Var_Consecutivo,	Par_InstitucionID,		Par_NumCtaInstit,		Par_TipoInversion,		Par_FechaInicio,
				Par_FechaVencim,	Par_Monto,				Par_Plazo,				Par_Tasa,				Par_TasaISR,
				Par_TasaNeta,		Par_InteresGenerado,	Par_InteresRecibir,		Par_InteresRetener,		Par_totalRecibir,
				Var_Estatus,		Par_MonedaID,			Entero_Cero,			Par_DiasBase,			Par_ClasificacionInver,
				Par_TipoTitulo,		Par_TipoRestriccion,	Par_TipoDeuda,			Par_UsuarioID,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);
				set	 Par_NumErr := 0;
				set	 Par_ErrMen := concat("Inversion Agregada Exitosamente: ",  convert(Var_Consecutivo, CHAR));
				set	 Var_Control:= 'inversionID';


	END ManejoErrores;

	 IF(Par_Salida =Salida_SI) THEN
	select  convert(Par_NumErr, char(3)) as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Var_Consecutivo as consecutivo;
	 END IF;
END TerminaStore$$