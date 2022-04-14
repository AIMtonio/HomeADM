-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAINVBANPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAINVBANPRO`;DELIMITER $$

CREATE PROCEDURE `POLIZAINVBANPRO`(



	Par_InversionID			bigint,
	Par_CentroCosto			int,
	Par_Poliza				bigint,
	Par_Fecha				date,
	Par_ConceptoInvBan		int,

	Par_DescripcionMov		varchar(100),
	Par_Referencia			varchar(50),
	Par_Moneda				int,
	Par_Cargos				decimal(14,4),
	Par_Abonos				decimal(14,4),

	Par_InstitucionID		int,
	Par_Salida				char(1),
	out Par_NumErr			int,
	out Par_ErrMen			varchar(400),
	Par_Empresa				int,

	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,

	Aud_NumTransaccion		bigint


)
TerminaStore: BEGIN


	DECLARE	Var_Instrumento		varchar(20);
	DECLARE	Var_Cuenta			varchar(50);
	DECLARE	Var_CenCosto		int;
	DECLARE	Var_CuentaMayor		varchar(4);
	DECLARE	Var_Nomenclatura 	varchar(30);
	DECLARE	Var_SubCuentaTM		char(6);
	DECLARE	Var_SubCuentaIT		char(6);
	DECLARE	Var_SubCuentaTT		char(6);
	DECLARE	Var_SubCuentaTD		char(6);
	DECLARE	Var_SubCuentaTR		char(6);
	DECLARE	Var_SubCuentaPB		char(6);
	DECLARE Var_Titulo			char(1);
	DECLARE Var_Restriccion		char(1);
	DECLARE Var_Deuda			char(1);
	DECLARE Var_Plazo			int;
	DECLARE Var_Monto			decimal(14,4);

	DECLARE SubTituNegocio		varchar(6);
	DECLARE SubTituDispVenta	varchar(6);
	DECLARE SubTituConsVenc		varchar(6);
	DECLARE SubTipoDeuGuber		varchar(6);
	DECLARE SubTipoDeuBanca 	varchar(6);
	DECLARE SubTipoDeuOtros		varchar(6);
	DECLARE SubRestricionCon	varchar(6);
	DECLARE SubRestricionSin	varchar(6);
	DECLARE SubCuentaPlazo		varchar(6);


	DECLARE	Cadena_Vacia			char(1);
	DECLARE	Fecha_Vacia				date;
	DECLARE	Entero_Cero				int;
	DECLARE	Salida_SI				char(1);
	DECLARE	Cuenta_Vacia			char(25);
	DECLARE	Salida_NO				char(1);
	DECLARE	For_CueMayor			char(3);
	DECLARE	For_TipMoneda			char(3);
	DECLARE	For_Instit				char(3);
	DECLARE	For_TipTitulo			char(3);
	DECLARE	For_Restriccion			char(3);
	DECLARE	For_TipDeuda			char(3);
	DECLARE	For_PlazoBancario		char(3);

	DECLARE	Procedimiento			varchar(20);
	DECLARE TipoInstrumentoID		INT(11);
	DECLARE Decimal_Cero			decimal(14,2);
	DECLARE TipoDeuda_Otros			char(1);
	DECLARE TipoDeuda_Bancaria		char(1);
	DECLARE TipoDeuda_Guber			char(1);
	DECLARE Titulo_Negociar			char(1);
	DECLARE Titulo_Venta			char(1);
	DECLARE Titulo_Conservados		char(1);
	DECLARE RestriccionSin			char(1);
	DECLARE RestriccionCon			char(1);


	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Salida_SI				:= 'S';
	SET Cuenta_Vacia			:= '0000000000000000000000000';
	SET Salida_NO				:= 'N';
	SET For_CueMayor			:= '&CM';
	SET For_TipMoneda			:= '&TM';
	SET For_Instit				:= '&TI';
	SET For_TipTitulo			:= '&TT';
	SET For_Restriccion			:= '&TR';
	SET For_TipDeuda			:= '&TD';
	SET For_PlazoBancario		:= '&PB';
	SET Procedimiento			:= 'POLIZAINVBANPRO';
	SET TipoInstrumentoID 		:= 19;
	SET Par_NumErr				:= Entero_Cero;
	SET Par_ErrMen				:= Cadena_Vacia;
	SET Var_Cuenta				:= '0000000000000000000000000';

	SET Var_CenCosto			:= Entero_Cero;
	SET Decimal_Cero			:= 0.00;
	SET TipoDeuda_Bancaria		:= 'B';
	SET TipoDeuda_Otros			:= 'O';
	SET TipoDeuda_Guber			:= 'G';
	SET Titulo_Negociar			:= 'N';
	SET Titulo_Venta			:= 'D';
	SET Titulo_Conservados		:= 'C';
	SET RestriccionCon			:= 'C';
	SET RestriccionSin			:= 'S';


	set Var_Instrumento := convert(Par_InversionID, CHAR);

	ManejoErrores:BEGIN




			SELECT	Nomenclatura, Cuenta into Var_Nomenclatura, Var_CuentaMayor
				FROM  CUENTASMAYORINVBAN Ctm
					WHERE Ctm.ConceptoInvBanID	= Par_ConceptoInvBan;

			SET Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
			SET Var_CuentaMayor := ifnull(Var_CuentaMayor, Cadena_Vacia);
			if(Var_Nomenclatura = Cadena_Vacia) then
				SET Var_Cuenta := Cuenta_Vacia;
			else

				set Var_Cuenta	:= Var_Nomenclatura;


				if LOCATE(For_CueMayor, Var_Nomenclatura) > 0 then
					if (Var_CuentaMayor != Cadena_Vacia) then
						set Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
					end if;
				end if;

				if LOCATE(For_TipMoneda, Var_Nomenclatura) > 0 then
					SELECT	SubCuenta into Var_SubCuentaTM
						FROM  SUBCTAMONEDAINVBAN Sub
						WHERE	Sub.MonedaID			= Par_Moneda
						 AND	Sub.ConceptoInvBanID	= Par_ConceptoInvBan;
					SET Var_SubCuentaTM := ifnull(Var_SubCuentaTM, Cadena_Vacia);

					if (Var_SubCuentaTM != Cadena_Vacia) then
						set Var_Cuenta := REPLACE(Var_Cuenta, For_TipMoneda, Var_SubCuentaTM);
					end if;
				end if;


				if LOCATE(For_Instit, Var_Cuenta) > Entero_Cero then
					SELECT	SubCuenta into Var_SubCuentaIT
					FROM  SUBCTAINSTINVBAN Sub
					WHERE Sub.InstitucionID	 = Par_InstitucionID
					AND Sub.ConceptoInvBanID	= Par_ConceptoInvBan;

					SET Var_SubCuentaIT := ifnull(Var_SubCuentaIT, Cadena_Vacia);
					if (Var_SubCuentaIT != Cadena_Vacia) then
						SET Var_Cuenta := REPLACE(Var_Cuenta, For_Instit, Var_SubCuentaIT);
					end if;
				end if;

				SELECT Plazo, TipoTitulo, TipoRestriccion, TipoDeuda into
					Var_Plazo, Var_Titulo, Var_Restriccion, Var_Deuda
				FROM INVBANCARIA as inv
				where InversionID=Par_InversionID;

				SET Var_Titulo 		:= ifnull(Var_Titulo, Cadena_Vacia);
				SET Var_Restriccion := ifnull(Var_Restriccion, Cadena_Vacia);
				SET Var_Deuda 		:= ifnull(Var_Deuda, Cadena_Vacia);

				if (LOCATE(For_TipTitulo, Var_Cuenta) > Entero_Cero) then
					if(Var_Titulo!= Cadena_Vacia) then
						SELECT TituNegocio, TituDispVenta, TituConsVenc into
								SubTituNegocio, SubTituDispVenta, SubTituConsVenc
						FROM SUBCTATITUINVBAN
						where ConceptoInvBanID=Par_ConceptoInvBan;

						SET SubTituNegocio	:= ifnull(SubTituNegocio, Cadena_Vacia);
						SET SubTituDispVenta:= ifnull(SubTituDispVenta, Cadena_Vacia);
						SET SubTituConsVenc := ifnull(SubTituConsVenc, Cadena_Vacia);

						if(Var_Titulo = Titulo_Negociar) then
							if(SubTituNegocio != Cadena_Vacia) then
								SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipTitulo, SubTituNegocio);
							end if;
							else if( Var_Titulo = Titulo_Venta) then
										if(SubTituDispVenta != Cadena_Vacia) then
											SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipTitulo, SubTituDispVenta);
										end if;
								else if( Var_Titulo = Titulo_Conservados) then
										if(SubTituConsVenc != Cadena_Vacia) then
											SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipTitulo, SubTituConsVenc);
										end if;
									end if;
								end if;
						end if;
					END IF;
				END IF;


				if (LOCATE(For_Restriccion, Var_Cuenta) > Entero_Cero) then
					if(Var_Restriccion!= Cadena_Vacia) then
						SELECT RestricionCon, RestricionSin into
								SubRestricionCon, SubRestricionSin
						FROM SUBCTARESTINVBAN
						WHERE ConceptoInvBanID=Par_ConceptoInvBan;

						SET SubRestricionCon	:= ifnull(SubRestricionCon, Cadena_Vacia);
						SET SubRestricionSin	:= ifnull(SubRestricionSin, Cadena_Vacia);

						if(Var_Restriccion = RestriccionCon) then
							if(SubRestricionCon != Cadena_Vacia) then
								SET Var_Cuenta := REPLACE(Var_Cuenta, For_Restriccion, SubRestricionCon);
							end if;
							else if(Var_Restriccion = RestriccionSin) then
								if(SubRestricionSin != Cadena_Vacia) then
									SET Var_Cuenta := REPLACE(Var_Cuenta, For_Restriccion, SubRestricionSin);
								end if;
							end if;
						end if;
					end if;
				END IF;


				if (LOCATE(For_TipDeuda, Var_Cuenta) > Entero_Cero) then
					if(Var_Deuda!= Cadena_Vacia) then
						SELECT TipoDeuGuber, TipoDeuBanca, TipoDeuOtros into
							SubTipoDeuGuber, SubTipoDeuBanca, SubTipoDeuOtros
						FROM SUBCTADEUDAINVBAN
						WHERE ConceptoInvBanID=Par_ConceptoInvBan;

						SET SubTipoDeuGuber	:= ifnull(SubTipoDeuGuber, Cadena_Vacia);
						SET SubTipoDeuBanca := ifnull(SubTipoDeuBanca, Cadena_Vacia);
						SET SubTipoDeuOtros := ifnull(SubTipoDeuOtros, Cadena_Vacia);

						if(Var_Deuda = TipoDeuda_Guber) then
							if(SubTipoDeuGuber != Cadena_Vacia) then
								SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipDeuda, SubTipoDeuGuber);
							end if;
							else if( Var_Deuda = TipoDeuda_Bancaria) then
										if(SubTipoDeuBanca != Cadena_Vacia) then
											SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipDeuda, SubTipoDeuBanca);
										end if;
								else if( Var_Deuda = TipoDeuda_Otros) then
										if(SubTipoDeuOtros != Cadena_Vacia) then
											SET Var_Cuenta := REPLACE(Var_Cuenta, For_TipDeuda, SubTipoDeuOtros);
										end if;
									end if;
								end if;
						end if;
					END IF;
				END IF;

				if LOCATE(For_PlazoBancario, Var_Cuenta) > 0 then
					if(Var_Plazo > Entero_Cero) then
						SELECT CASE WHEN Var_Plazo>Plazo THEN SubPlazoMayor ELSE
							CASE WHEN Var_Plazo<=Plazo THEN SubPlazoMenor END END AS SubcuentaPlazo into SubCuentaPlazo
						FROM SUBCTAPLAZOINVBAN
						WHERE ConceptoInvBanID=Par_ConceptoInvBan;

						SET SubCuentaPlazo	:= ifnull(SubCuentaPlazo, Cadena_Vacia);
						if(SubCuentaPlazo != Cadena_Vacia) then
							SET Var_Cuenta := REPLACE(Var_Cuenta, For_PlazoBancario, SubCuentaPlazo);
						end if;
					end if;

				END IF;
			end if;

		set Var_Cuenta := REPLACE(Var_Cuenta, '-', Cadena_Vacia);


						CALL DETALLEPOLIZAALT(
							Par_Empresa,			Par_Poliza,				Par_Fecha, 			Par_CentroCosto,		Var_Cuenta,
							Var_Instrumento,		Par_Moneda,				Par_Cargos,			Par_Abonos,			Par_DescripcionMov,
							Par_Referencia,			Procedimiento,			TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
							Cadena_Vacia,			Salida_NO, 				Par_NumErr,			Par_ErrMen,			Aud_Usuario,
							Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	END ManejoErrores;


	if (Par_Salida = Salida_SI) then
		SELECT  convert(Par_NumErr, char(10)) as NumErr,Par_ErrMen as ErrMen;
	end if;


END TerminaStore$$