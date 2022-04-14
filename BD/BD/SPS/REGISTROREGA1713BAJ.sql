-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROREGA1713BAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGISTROREGA1713BAJ`;DELIMITER $$

CREATE PROCEDURE `REGISTROREGA1713BAJ`(
/*=============================================================================
---- SP QUE BORRA UN REGISTRO DEL REGULATORIO A1713 SOFIPO-----
==============================================================================*/
	Par_RegistroID		  	INT(11),			-- Consecutivo que identifica el registro
	Par_Fecha               DATE,               -- Fecha del Reporte

    Par_Salida          	CHAR(1),			-- Indica Salida
	INOUT Par_NumErr    	INT(11),			-- numero de error
    INOUT Par_ErrMen   		VARCHAR(400),		-- mensaje de error

	Par_EmpresaID       	INT(11),    		-- Empresa Id
    Aud_Usuario         	INT(11),			-- UsuarioID
    Aud_FechaActual     	DATETIME,			-- Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Direccion Ip
    Aud_ProgramaID      	VARCHAR(50),		-- Progama ID
    Aud_Sucursal        	INT(11),			-- Sucursal
	Aud_NumTransaccion  	BIGINT(20)			-- Numero de transaccion

	)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(50);	-- Campo de control
	-- Descripcion de constantes
	DECLARE Cadena_Vacia		CHAR;
	DECLARE Entero_Cero			INT;
	DECLARE SalidaSI			CHAR;
	-- Asignacion de Constantes
	SET Cadena_Vacia			:='';		-- Cadena Vacia
	SET Entero_Cero				:=0;		-- Entero _Cero
	SET SalidaSI				:='S';		-- Salida Si

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          SET Par_NumErr := 999;
          SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
                          concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-REGISTROREGA1713BAJ');
          SET Var_Control := 'SQLEXCEPTION';
        END;


		DELETE FROM REGISTROREGA1713
			WHERE RegistroID =  Par_RegistroID
				AND Fecha	=	Par_Fecha;

		SET Par_NumErr := Entero_Cero;
        SET Par_ErrMen := CONCAT('Registro Eliminado Correctamente: ', Par_RegistroID);
        SET Var_Control:= 'registroID';

END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
     SELECT Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
 END IF;
END TerminaStore$$