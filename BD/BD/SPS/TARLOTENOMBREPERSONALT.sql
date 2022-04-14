-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOTENOMBREPERSONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARLOTENOMBREPERSONALT`;
DELIMITER $$


CREATE PROCEDURE `TARLOTENOMBREPERSONALT`(

	Par_LoteDebitoID		INT(11),
	Par_NombrePerso			VARCHAR(21),
	Par_TipoTarjetaDebID	INT(11),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr    	INT,
    INOUT Par_ErrMen    	VARCHAR(400),
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore:BEGIN

DECLARE Var_Control			VARCHAR(50);
DECLARE Var_Consecutivo		INT;
DECLARE	Cadena_Vacia	 CHAR(1);
DECLARE	Entero_Cero		 INT;
DECLARE Entero_Uno		 INT;
DECLARE	DecimalCero		 DECIMAL(12,2);
DECLARE Salida_NO 		 CHAR(1);
DECLARE	SalidaSI	 	 CHAR(1);
DECLARE Var_LoteDebitoID INT;


SET	Cadena_Vacia	:= '';
SET	Entero_Cero		:= 0;
SET	Entero_Uno		:= 1;
SET	DecimalCero		:= 0.00;
SET	Salida_NO		:= 'N';
SET	SalidaSI		:= 'S';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARLOTENOMBREPERSONALT');
    END;

    IF(IFNULL(Par_LoteDebitoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := CONCAT('El id de lote se encuentra Vacio.');
		SET Var_Control := 'tipoTarjetaDebID';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_NombrePerso, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := CONCAT('El nombre personalizado esta Vacia.');
		SET Var_Control := 'sucursalSolicita';
		LEAVE ManejoErrores;
	END IF;

SET Var_LoteDebitoID := (SELECT IFNULL(MAX(NombrePerID),Entero_Cero) + 1 FROM LOTENOMBREPERSON);

INSERT INTO  LOTENOMBREPERSON(
	NombrePerID,    LoteDebID, 		NombrePerso, 		TipoTarjetaDebID,  EmpresaID,		Usuario,
    FechaActual,	DireccionIP,		ProgramaID,		   Sucursal,		NumTransaccion)
VALUES(
	Var_LoteDebitoID,    Par_LoteDebitoID, 	Par_NombrePerso, 	Par_TipoTarjetaDebID, 	Par_EmpresaID,		Aud_Usuario,
    Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

    SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Nombre de Tarjeta Personalizada Agregado Exitosamente: ',Par_LoteDebitoID);
	SET Var_Control := 'TipoTarjetaDebID';
    SET Var_Consecutivo	:= Par_LoteDebitoID;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'TipoTarjetaDebID' AS control,
            Var_Consecutivo AS consecutivo;
end IF;


END TerminaStore$$
