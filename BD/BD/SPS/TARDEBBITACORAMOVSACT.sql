-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBBITACORAMOVSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBBITACORAMOVSACT`;
DELIMITER $$


CREATE PROCEDURE `TARDEBBITACORAMOVSACT`(
	Par_NumMovID		int,
	Par_FolioCargaID	int,
	Par_DetalleID		int,
	Par_NumTrans		int,

	Par_Salida         	char(1),
inout	Par_NumErr		int,
inout	Par_ErrMen		varchar(400),

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
DECLARE Act_Procesado   INT(11);
DECLARE ActPosFraude	int;
DECLARE EstConciliado	char(1);
DECLARE EstPosFraude	char(1);
DECLARE Var_Control		varchar(20);
DECLARE Est_Procesado	CHAR(1);		-- Estatus procesado

-- VARIABLES
DECLARE Var_TarDebMovID	INT(11);	-- Numero de Movimiento de la Tarjeta

Set Entero_Cero		:= 0;
Set Cadena_Vacia	:= '';
Set Salida_SI		:= 'S';
Set ActConciliado	:= 1;
Set ActPosFraude	:= 2;
SET Act_Procesado	:= 3;
Set EstConciliado	:= 'C';
Set EstPosFraude	:= 'F';
SET Est_Procesado   := 'P';

	ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-TARDEBBITACORAMOVSACT');
		END;

		SET Par_NumMovID := IFNULL(Par_NumMovID, Entero_Cero);

		IF( Par_NumMovID = Entero_Cero) THEN
			SET Par_NumErr:= 001;
			SET Par_ErrMen:= 'El Numero de Movimiento de Tarjeta de Debito esta Vacio';
			LEAVE ManejoErrores;
		END IF;

		SELECT TarDebMovID
		INTO Var_TarDebMovID
		FROM TARDEBBITACORAMOVS
		WHERE TarDebMovID = Par_NumMovID;

		SET Var_TarDebMovID := IFNULL(Var_TarDebMovID, Entero_Cero);

		IF( Var_TarDebMovID = Entero_Cero) THEN
			SET Par_NumErr:= 001;
			SET Par_ErrMen:= 'El Numero de Movimiento de Tarjeta de Debito No Existe';
			LEAVE ManejoErrores;
		END IF;

		if (Par_NumTrans = ActConciliado) then
			UPDATE TARDEBBITACORAMOVS SET
				FolioConcilia	= Par_FolioCargaID,
				DetalleConciliaID= Par_DetalleID,
				EstatusConcilia	= EstConciliado
			WHERE TarDebMovID	= Var_TarDebMovID;
		end if;

		if (Par_NumTrans = ActPosFraude) then
			UPDATE TARDEBBITACORAMOVS SET
				EstatusConcilia	= EstPosFraude
			WHERE TarDebMovID 	= Var_TarDebMovID;
		end if;

		-- ACTUALIZACION DE ESTATUS A PROCESADO
		IF(Par_NumTrans = Act_Procesado)THEN
			UPDATE TARDEBBITACORAMOVS
				SET
					Estatus			= Est_Procesado,
					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID		= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
			WHERE TarDebMovID = Var_TarDebMovID;
		END IF;

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
