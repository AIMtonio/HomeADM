-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBBITACORESPALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBBITACORESPALT`;
DELIMITER $$


CREATE PROCEDURE `TARDEBBITACORESPALT`(

	Par_TarjetaDebID		CHAR(16),
	Par_TipoMensaje			CHAR(4),
	Par_TipoOperacionID		CHAR(2),
	Par_FechaHrOpe 			VARCHAR(20),
	Par_MontoTransac		DECIMAL(12,2),

    Par_TerminalID 			VARCHAR(50),
	Par_Referencia			VARCHAR(12),
	Par_NumTransResp		VARCHAR(6),
	Par_SaldoContableAct 	VARCHAR(13),
	Par_SaldoDispoAct		VARCHAR(13),

    Par_CodigoResp			VARCHAR(3),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(150),
	Par_Salida				CHAR(1),
	Aud_EmpresaID			INT(11),

    Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore:BEGIN


DECLARE Var_RespID			INT(11);
DECLARE Var_Control			VARCHAR(30);
DECLARE Var_FechaRespuesta	DATETIME;


DECLARE Entero_Cero		INT(11);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE SalidaSI		CHAR(1);


SET Entero_Cero	:= 0;
SET Cadena_Vacia:= '';
SET SalidaSI	:= 'S';


SET Var_FechaRespuesta	:= DATE_FORMAT(NOW(), '%Y-%m-%d %h:%i:%s');

	ManejoErrores:BEGIN

	CALL FOLIOSAPLICAACT('TARDEBBITACORESP', Var_RespID);

	INSERT INTO `TARDEBBITACORESP`(
		`RespID`,				`TarjetaDebID`,		`TipoMensaje`,		`TipoOperacionID`,		`FechaOperacion`,
		`MontoTransaccion`,		`TerminalID`,		`Referencia`, 		`FechaHrRespuesta`,		`NumTransResp`,
		`SaldoContableAct`,		`SaldoDisponibleAct`,`CodigoRespuesta`,	MensajeRespuesta,		`EmpresaID`,
		`Usuario`,				`FechaActual`,		`DireccionIP`,		`ProgramaID`,			`Sucursal`,
		`NumTransaccion`)
	VALUES(
		Var_RespID,				Par_TarjetaDebID,	Par_TipoMensaje,	Par_TipoOperacionID, 	Par_FechaHrOpe,
		Par_MontoTransac, 		Par_TerminalID,		Par_Referencia, 	Var_FechaRespuesta,		Par_NumTransResp,
		Par_SaldoContableAct,	Par_SaldoDispoAct,	Par_CodigoResp, 	Cadena_Vacia,			Aud_EmpresaID,
		Aud_Usuario,			Var_FechaRespuesta,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion);

	SET	Par_NumErr	:= 0;
	SET Par_ErrMen	:= 'Registro Guardado Exitosamente';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
			Var_Control AS control,
            Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$