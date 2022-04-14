-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFEREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFEREALT`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOREFEREALT`(
	Par_InstitucionID		int,

	Par_CuentaAhoID		bigint(12),
	Par_FechaOperacion	date,
	Par_ReferenciaMov		varchar(150),
	Par_DescripcionMov	varchar(150),
	Par_NatMovimiento		char(1),
	Par_MontoMov 			decimal(12,2),
	Par_MontoPendApli		decimal(12,2),
	Par_TipoCanal			int,
	Par_TipoDeposito			char(1),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE Var_FolioOperacion	int;
DECLARE Var_Cero int;
DECLARE Var_Vacio	char(1);
DECLARE Var_Status char(1);

Set Aud_FechaActual := CURRENT_TIMESTAMP();
Set Var_Cero 		:= 0;
Set Var_Vacio 	:= '';
Set Var_Status	:= 'N';


set Var_FolioOperacion := (select ifnull(Max(FolioCargaID),Var_Cero)+1 from DEPOSITOREFERE);

	INSERT INTO DEPOSITOREFERE (FolioCargaID,	CuentaAhoID,		NumeroMov,		InstitucionID,	FechaCarga,
							FechaAplica,		NatMovimiento,	MontoMov,		TipoMov,			DescripcionMov,
							ReferenciaMov,	Status,			MontoPendApli,	TipoDeposito,		TipoCanal,
							EmpresaID,		Usuario,			FechaActual,		DireccionIP,		ProgramaID,
							Sucursal,		NumTransaccion)
	VALUES (Var_FolioOperacion,	Par_CuentaAhoID,		Var_Cero,			Par_InstitucionID,	Aud_FechaActual,
			Par_FechaOperacion,	Par_NatMovimiento,	Par_MontoMov,			Var_Vacio,			Par_DescripcionMov,
			Par_ReferenciaMov,	Var_Status,			Par_MontoPendApli,	Par_TipoDeposito,		Par_TipoCanal,
			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);


select '000' as NumErr,
	concat("Dispersion Autorizada Agregada: ",
	convert(Var_FolioOperacion, CHAR))  as ErrMen,
	'cuentaAhoID' as control,
	Var_FolioOperacion as consecutivo;

END TerminaStore$$