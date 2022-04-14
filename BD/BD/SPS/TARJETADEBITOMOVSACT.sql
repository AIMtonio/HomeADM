-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETADEBITOMOVSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETADEBITOMOVSACT`;DELIMITER $$

CREATE PROCEDURE `TARJETADEBITOMOVSACT`(
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
DECLARE Entero_Cero		int;
DECLARE Cadena_Vacia	char(1);
DECLARE Salida_SI		char(1);
DECLARE ActConciliado	int;
DECLARE ActPosFraude	int;
DECLARE EstConciliado	char(1);
DECLARE EstPosFraude	char(1);
DECLARE Var_Control		varchar(20);

Set Entero_Cero		:= 0;
Set Cadena_Vacia	:= '';
Set Salida_SI		:= 'S';
Set ActConciliado	:= 1;
Set ActPosFraude	:= 2;
Set EstConciliado	:= 'C';
Set EstPosFraude	:= 'F';

	ManejoErrores:BEGIN


		if (Par_NumTrans = ActConciliado) then
			UPDATE TARJETADEBITOMOVS	SET
				FolioConcilia 	= Par_FolioCargaID,
				DetalleConciliaID= Par_DetalleID,
				EstatusConcilia	= EstConciliado
			WHERE TarDebMovID 	= Par_NumMovID;
		end if;

		if (Par_NumTrans = ActPosFraude) then
			UPDATE TARJETADEBITOMOVS	SET
				EstatusConcilia	= EstPosFraude
			WHERE TarDebMovID 	= Par_NumMovID;
		end if;

		Set	Par_NumErr	:= Entero_Cero ;
		Set Par_ErrMen	:= 'Movimiento Actualizado';
		Set Var_Control := Cadena_Vacia;
	END ManejoErrores;

	if (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			Var_Control as control,
			Entero_Cero as consecutivo;
	end if;

END TerminaStore$$