-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIDATSOCIOEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIDATSOCIOEALT`;DELIMITER $$

CREATE PROCEDURE `CLIDATSOCIOEALT`(

	Par_LinNegID     	INT(11),
    Par_ProspectoID     INT(11),
    Par_ClienteID       INT(11),
	Par_SolicCreID		INT(11),
	Par_CatSocioEID		INT(11),

	Par_Monto			DECIMAL(14,2),
	Par_FechaReg		DATE,
    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),


    Par_EmpresaID       INT(11),
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),

    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
	)
TerminaStore: BEGIN


DECLARE VarNumSocioID   	INT;
DECLARE Var_Control			VARCHAR(15);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATETIME;
DECLARE Entero_Cero         INT(11);
DECLARE Entero_Uno		    INT(11);
DECLARE Str_SI              CHAR(1);
DECLARE Str_NO              CHAR(1);
DECLARE MenorEdad			CHAR(1);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Entero_Uno	        := 1;
SET Str_SI              := 'S';
SET Str_NO              := 'N';
SET MenorEdad			:= 'S';

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := '999';
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIDATSOCIOEALT');
			SET Var_Control := 'sqlException' ;
		END;


	SET Aud_FechaActual := NOW();


	SET	Par_FechaReg	:=	(SELECT FechaSistema FROM PARAMETROSSIS);


	SET VarNumSocioID 	:= (SELECT IFNULL(MAX(SocioEID),Entero_Cero) + Entero_Uno FROM CLIDATSOCIOE);

	INSERT INTO CLIDATSOCIOE (
		SocioEID,			LinNegID,		ProspectoID,		ClienteID,		SolicitudCreditoID,
		CatSocioEID,		Monto,      	FechaRegistro,		EmpresaID,		Usuario,
		FechaActual,    	DireccionIP,    ProgramaID,     	Sucursal,		NumTransaccion)
	VALUES (
		VarNumSocioID,		Par_LinNegID,	Par_ProspectoID,	Par_ClienteID,	Par_SolicCreID,
		Par_CatSocioEID,  	Par_Monto,		Par_FechaReg,		Par_EmpresaID,  Aud_Usuario,
		Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID,     Aud_Sucursal,	Aud_NumTransaccion);


	SET	Par_NumErr		:= Entero_Cero;
	SET	Par_ErrMen		:= 'Datos Socioeconomicos Agregados Exitosamente' ;
	SET Var_Control 	:= 'clienteID' ;
	SET VarNumSocioID 	:= Par_ClienteID;

END ManejoErrores;

IF(Par_Salida = Str_SI) THEN
    SELECT 	Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            VarNumSocioID AS consecutivo;
END IF;

END TerminaStore$$