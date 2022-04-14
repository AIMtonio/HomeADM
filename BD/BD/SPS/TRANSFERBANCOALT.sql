-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANSFERBANCOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TRANSFERBANCOALT`;DELIMITER $$

CREATE PROCEDURE `TRANSFERBANCOALT`(
	VarTransferID			BIGINT,
	Par_InstitucionID		INT(11),
	Par_NumCtaInstit		VARCHAR(20),
	Par_SucursalID			INT(11),
	Par_CajaID				INT(11),

	Par_MonedaID			INT(11),
	Par_Cantidad			DECIMAL(14,2),
	Par_PolizaID			BIGINT(20),
	Par_DenominacionID		INT,
	Par_Estatus				CHAR(1),

	Par_Fecha				DATETIME,
	Par_TipoTransaccion		INT,
	Par_Referencia			VARCHAR(50),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr    	INT,
    INOUT Par_ErrMen    	VARCHAR(400),

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
		)
TerminaStore: BEGIN


DECLARE Entero_Cero			INT;
DECLARE Entero_Uno			INT;
DECLARE Var_Consecutivo		BIGINT;
DECLARE SalidaSI			CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE EstatusE			CHAR(1);
DECLARE EstatusR			CHAR(1);
DECLARE	Var_SucursalCaja	INT;
DECLARE VarNumCtaInstit 	VARCHAR(20);
DECLARE VarControl		 	VARCHAR(100);


SET	Entero_Cero		:= 0;
SET	Entero_Uno		:= 1;
SET SalidaSI		:='S';
SET SalidaNO		:='N';
SET	Cadena_Vacia	:='';
SET EstatusE	    :='E';
SET EstatusR	    :='R';
SET Par_NumErr		:= 999;
SET Par_ErrMen		:= concat("El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ",
								"esto le ocasiona. Ref: SP-TRANSFERBANCOALT");
SET VarControl		:= 'institucionID';

SET Aud_FechaActual := CURRENT_TIMESTAMP();

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := concat("El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ",
								"esto le ocasiona. Ref: SP-TRANSFERBANCOALT");
    END;

IF(IFNULL(Par_InstitucionID,Entero_Cero))= Entero_Cero THEN
	SET Par_NumErr	:= 2;
	SET Par_ErrMen	:= 'La Institucion No Fue Seleccionada.';
	SET VarControl	:= 'institucionID';
    LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_NumCtaInstit, Cadena_Vacia))= Cadena_Vacia THEN
	SET Par_NumErr := 3;
	SET Par_ErrMen := 'El Numero de Cuenta Esta Vacio.';
	SET VarControl := 'numCtaInstit';
    LEAVE ManejoErrores;
END IF;

SET VarNumCtaInstit	:= (SELECT	NumCtaInstit
							FROM	CUENTASAHOTESO
								WHERE	InstitucionID	= Par_InstitucionID
								 AND	NumCtaInstit	= Par_NumCtaInstit);
SET VarNumCtaInstit	:= IFNULL(VarNumCtaInstit, Cadena_Vacia );
if(IFNULL(VarNumCtaInstit, Cadena_Vacia) = Cadena_Vacia) THEN
	SET Par_NumErr := 3;
	SET Par_ErrMen := 'La Cuenta Bancaria no existe. #Tr';
	SET VarControl := 'numCtaInstit';
    LEAVE ManejoErrores;
END IF;

IF (Par_TipoTransaccion = Entero_Uno) THEN
	SET Par_Estatus := EstatusE;
    SET Var_Consecutivo:= Par_PolizaID;
ELSE
	SET Par_Estatus := EstatusR;
    SET Var_Consecutivo:= Par_InstitucionID;

END IF;

SELECT SucursalID INTO Var_SucursalCaja
		FROM CAJASVENTANILLA
		WHERE CajaID        =   Par_CajaID;


INSERT INTO TRANSFERBANCO(	TransferBancoID,	InstitucionID,		NumCtaInstit,		SucursalID,			CajaID,
							MonedaID, 			Cantidad, 			PolizaID, 			DenominacionID, 	Estatus,
							Fecha,				Referencia,			EmpresaID,			Usuario,			FechaActual,
							DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
				VALUES(		VarTransferID,		Par_InstitucionID,	Par_NumCtaInstit,	Var_SucursalCaja,	Par_CajaID,
							Par_MonedaID, 		Par_Cantidad,		Par_PolizaID, 		Par_DenominacionID,	Par_Estatus,
							Par_Fecha,			Par_Referencia,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

SET Par_NumErr := 0;
SET Par_ErrMen := concat("Transferencia Realizada Exitosamente");

END ManejoErrores;

IF(Par_Salida = SalidaSI)THEN
	SELECT	Par_NumErr AS NumErr ,
			Par_ErrMen AS ErrMen,
			VarControl AS control,
			Var_Consecutivo AS consecutivo;
END IF;

END TerminaStore$$