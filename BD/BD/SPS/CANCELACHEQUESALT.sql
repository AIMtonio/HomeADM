-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACHEQUESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACHEQUESALT`;DELIMITER $$

CREATE PROCEDURE `CANCELACHEQUESALT`(
	Par_InstitucionID		INT(11),
	Par_NumCtaInstit		VARCHAR(20),
	Par_NumCheque			INT(10),
	Par_Sucursal			INT(11),
    Par_FechaCancela		DATE,

	Par_UsuarioCancela		INT(11),
    Par_NumReqGasID			INT(11),
    Par_ProveedorID    		INT(11),
	Par_NumFactura     		VARCHAR(20),
	Par_Monto				DECIMAL(14,2),

    Par_MotivoCancela		INT(11),
	Par_Comentario			VARCHAR(500),
	Par_TipoCancelacion		INT(11),


	Par_Salida				CHAR(1),
	inout Par_NumErr		INT(11),
	inout Par_ErrMen		VARCHAR(350),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
			)
TerminaStore:BEGIN


DECLARE Entero_Cero 	INT(11);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Decimal_Cero	DECIMAL(14,2);
DECLARE Salida_SI		CHAR(1);



DECLARE VarControl		VARCHAR(45);
DECLARE Var_CanCheqID	INT(11);


SET Entero_Cero			:= 0;
SET Cadena_Vacia		:= '';
SET Decimal_Cero		:= 0.00;
SET Salida_SI			:= 'S';

ManejoErrores : BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											 'esto le ocasiona. Ref: SP-CANCELACHEQUESALT');
				SET VarControl = 'sqlException' ;
			END;



IF(IFNULL(Par_InstitucionID,Entero_Cero)=Entero_Cero)THEN
	SET Par_NumErr	:=01;
	SET Par_ErrMen	:='El Numero de la Institucion esta Vacio';
	SET Varcontrol	:='institucionID';
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_NumCtaInstit,Cadena_Vacia)=Cadena_Vacia)THEN
	SET Par_NumErr	:=02;
	SET Par_ErrMen	:='El Numero de Cuenta Bancaria esta Vacio';
	SET Varcontrol	:='numCtaInstit';
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_NumCheque,Entero_Cero)=Entero_Cero)THEN
	SET Par_NumErr	:=03;
	SET Par_ErrMen	:='El Numero de Cheque Esta Vacio';
	SET Varcontrol	:='numCheque';
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_Sucursal,Entero_Cero)=Entero_Cero)THEN
	SET Par_NumErr	:=04;
	SET Par_ErrMen	:='El Numero de Sucursal Esta Vacio';
	SET Varcontrol	:='sucursalEmision';
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_Monto,Decimal_Cero)=Decimal_Cero)THEN
	SET Par_NumErr	:=05;
	SET Par_ErrMen	:='El Monto Esta Vacio';
	SET Varcontrol	:='monto';
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_MotivoCancela,Entero_Cero)=Entero_Cero)THEN
	SET Par_NumErr	:=06;
	SET Par_ErrMen	:='El Motivo de Cancelacion Esta Vacio';
	SET Varcontrol	:='motivoCancela';
	LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_TipoCancelacion,Entero_Cero)=Entero_Cero)THEN
	SET Par_NumErr	:=07;
	SET Par_ErrMen	:='El Tipo de Cancelacion Esta Vacio';
	SET Varcontrol	:='tipoCancelacion';
	LEAVE ManejoErrores;
END IF;

SET Par_NumReqGasID := IFNULL(Par_NumReqGasID, Entero_Cero);
SET Par_ProveedorID := IFNULL(Par_ProveedorID, Entero_Cero);
SET Par_NumFactura := IFNULL(Par_NumFactura, Cadena_Vacia);
SET Par_Comentario := IFNULL(Par_Comentario, Cadena_Vacia);
SET Aud_FechaActual := CURRENT_TIMESTAMP();


SET Var_CanCheqID := (SELECT IFNULL(MAX(CancelaChequeID),Entero_Cero) + 1
FROM CANCELACHEQUES);


INSERT INTO CANCELACHEQUES(	CancelaChequeID,	 	InstitucionID,		NumCtaInstit,			NumCheque,			SucursalID,
							FechaCancela, 			UsuarioCancelaID,	NumReqGasID,			ProveedorID,		NumFactura,
							Monto,					MotivoID,			Comentario,				TipoCancelacion,	EmpresaID,
							Usuario,				FechaActual,		DireccionIp,			ProgramaID,			Sucursal,
							NumTransaccion)

				    VALUES( Var_CanCheqID,			Par_InstitucionID,	Par_NumCtaInstit,		Par_NumCheque,		Par_Sucursal,
							Par_FechaCancela,		Par_UsuarioCancela,	Par_NumReqGasID,		Par_ProveedorID,	Par_NumFactura,
                            Par_Monto,				Par_MotivoCancela,	Par_Comentario,			Par_TipoCancelacion,Par_EmpresaID,
                            Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
                            Aud_NumTransaccion);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('El Cheque ',Par_NumCheque,' fue  Cancelado Exitosamente.');
		SET VarControl	:= 'tipoCancelacion';

END ManejoErrores ;

IF(Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr  AS NumErr,
			Par_ErrMen	 AS ErrMen,
			VarControl	 AS control,
			Entero_Cero	 AS consecutivo;
END IF;

END TerminaStore$$