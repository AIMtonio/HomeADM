-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOTETARJETAVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOTETARJETAVAL`;DELIMITER $$

CREATE PROCEDURE `LOTETARJETAVAL`(

    Par_LoteDebitoID        INT(11),
	Par_Estatus				INT(11),
    Par_NomArchiGen			VARCHAR(50),

    Par_Salida				CHAR(1),
	INOUT Par_NumErr    	INT,
    INOUT Par_ErrMen    	VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN

DECLARE	Var_LoteTarjetaDebID	INT(11);
DECLARE Var_Control				VARCHAR(50);
DECLARE Var_Consecutivo			INT;


DECLARE Entero_Uno	  		INT;
DECLARE Entero_Cero		 	INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Salida_NO 		 	CHAR(1);
DECLARE	SalidaSI	 	 	CHAR(1);
DECLARE Salto_Linea        	VARCHAR(2);


SET Var_LoteTarjetaDebID	:= 0;


SET Entero_Uno   	:= 1;
SET	Entero_Cero		:= 0;
SET	Cadena_Vacia	:= '';
SET	Salida_NO		:= 'N';
SET	SalidaSI		:= 'S';
SET Salto_Linea     :='\n';

ManejoErrores:BEGIN

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-LOTETARJETAVAL');
    END;

SELECT (MAX(LoteDebitoID)) INTO Var_LoteTarjetaDebID
					FROM LOTETARJETADEB WHERE Estatus=Entero_Uno  AND NomArchiGen=Cadena_Vacia ;

SET Var_LoteTarjetaDebID:= IFNULL( Var_LoteTarjetaDebID, Entero_Cero);

	IF(Var_LoteTarjetaDebID>Entero_Cero)THEN

		CALL LOTETARJETABAJ(Var_LoteTarjetaDebID,Entero_Uno,SalidaSI,Par_NumErr, Par_ErrMen,Par_EmpresaID,
		Aud_Usuario,Aud_FechaActual,Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal,Aud_NumTransaccion);

	END IF;


	IF(Var_LoteTarjetaDebID=Entero_Cero)THEN

			SET Par_NumErr := 0;
			SET Par_ErrMen := CONCAT('Operacion Realizada Exitosamente. ',
									'Error al copiar el archivo generado. Favor de Comunicarse al Area de Sistemas');
			LEAVE ManejoErrores;

	 END IF;


END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'TipoTarjetaDebID' AS control,
            Var_Consecutivo AS Var_LoteTarjetaDebID;
END IF;

END TerminaStore$$