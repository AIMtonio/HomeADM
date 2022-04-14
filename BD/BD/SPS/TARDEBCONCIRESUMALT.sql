-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIRESUMALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCIRESUMALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONCIRESUMALT`(
	Par_ConciliaID				int(11),
	Par_NoTotalTransac			int(11),
	Par_NoTotalVentas			int(11),
	Par_ImporteVtas				decimal(13,2),
	Par_NoTotalDisposic			int(11),

	Par_ImporteDisposicion		decimal(13,2),
	Par_NoTotalTransDebito		int(11),
	Par_ImporteTransDebito		decimal(13,2),
	Par_NoTotalPagosInter		int(11),
	Par_ImportePagosInter		decimal(13,2),

	Par_NoTotalDevolucion		int(11),
	Par_ImporteTotalDevol		decimal(13,2),
	Par_NoTotalTransCto			int(11),
	Par_ImporteTransCto			decimal(13,2),
	Par_NoTotalRepresenta		int(11),

	Par_ImporteRepresenta		decimal(13,2),
	Par_NoTotalContracargos		int(11),
	Par_ImporteContracargos		decimal(13,2),
	Par_ImporteComisiones		decimal(13,2),
	Par_Salida			char(1),

	inout Par_NumErr	int(11),
	inout Par_ErrMen	varchar(150),

	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(250),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
	)
TerminaStore:BEGIN

DECLARE Cadena_Vacia	char(1);
DECLARE Entero_Cero		int(11);
DECLARE Salida_SI		char(1);
DECLARE Var_Control		varchar(100);
DECLARE Var_ConciliaID	int(11);
DECLARE Var_ResumID		int(11);
DECLARE Var_FechaSistema	date;

Set Cadena_Vacia	:= '';
Set Entero_Cero		:= 0;
Set Salida_SI		:= 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,'estamos trabajando para resolverla.
									Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-TARDEBCONCILIAHEADALT');
			SET Var_Control = 'sqlException' ;
		END;

		SELECT FechaSistema 	into Var_FechaSistema
			FROM PARAMETROSSIS;
		CALL FOLIOSAPLICAACT('TARDEBCONCIRESUM', Var_ResumID);

		INSERT INTO `TARDEBCONCIRESUM`(
			`ConciliaID`,	`ResumenID`,`NoTotalTransac`,`NoTotalVentas`,`ImporteVtas`,
			`NoTotalDisposic`,`ImporteDisposicion`,`NoTotalTransDebito`,`ImporteTransDebito`,`NoTotalPagosInter`,
			`ImportePagosInter`,`NoTotalDevolucion`,`ImporteTotalDevol`,`NoTotalTransCto`,`ImporteTransCto`,
			`NoTotalRepresenta`,`ImporteRepresenta`,`NoTotalContracargos`,`ImporteContracargos`,`ImporteComisiones`,
			`EmpresaID`,`Usuario`,`FechaActual`,`DireccionIP`,`ProgramaID`,
			`Sucursal`,`NumTransaccion`)
		VALUES(
			Par_ConciliaID,			Var_ResumID,			Par_NoTotalTransac,			Par_NoTotalVentas,			Par_ImporteVtas,
			Par_NoTotalDisposic,	Par_ImporteDisposicion,	Par_NoTotalTransDebito,		Par_ImporteTransDebito,		Par_NoTotalPagosInter,
			Par_ImportePagosInter,	Par_NoTotalDevolucion,	Par_ImporteTotalDevol,		Par_NoTotalTransCto,		Par_ImporteTransCto,
			Par_NoTotalRepresenta,	Par_ImporteRepresenta,	Par_NoTotalContracargos,	Par_ImporteContracargos,	Par_ImporteComisiones,
			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion);

		Set Par_NumErr  := 000;
		Set Par_ErrMen	:= 'Registro Guardado Correctamente';
        Set Var_Control := 'fechaRegistro';

	END ManejoErrores;

	if (Par_Salida = Salida_SI)then
		    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Var_FechaSistema as consecutivo;
	end if;
END TerminaStore$$