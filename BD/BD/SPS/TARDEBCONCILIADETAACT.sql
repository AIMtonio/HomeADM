-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCILIADETAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCILIADETAACT`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONCILIADETAACT`(
	Par_NumMovID		int,
	Par_FolioCargaID	int,
	Par_DetalleID		int,
	Par_NumTrans		int,

	Par_Salida         	char(1),
inout	Par_NumErr		int,
inout	Par_ErrMen		varchar(100),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN

DECLARE Cadena_Vacia	char(1);
DECLARE Entero_Cero		int;
DECLARE Salida_SI		char(1);
DECLARE ActConciliado	int;
DECLARE EstConciliado	char(1);
DECLARE EstPosFraude	char(1);
DECLARE Var_Control		varchar(20);

Set Entero_Cero		:= 0;
Set Cadena_Vacia	:= '';
Set Salida_SI		:= 'S';
Set ActConciliado	:= 1;
Set EstConciliado	:= 'C';
Set EstPosFraude	:= 'F';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
								'estamos trabajando para resolverla. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-TARJETADEBITOMOVSACT');
			SET Var_Control = 'sqlException';
		END;

		if (Par_NumTrans = ActConciliado) then
			UPDATE TARDEBCONCILIADETA	SET
				FolioConcilia	= Par_NumMovID,
				EstatusConci	= EstConciliado
			WHERE ConciliaID = Par_FolioCargaID	AND Par_DetalleID = DetalleID;
		end if;

	END ManejoErrores;
END TerminaStore$$