-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOD0842003BAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOD0842003BAJ`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOD0842003BAJ`(
/*=============================================================================
---- SP QUE BORRA LOS REGISTROS DE UN PERIODO DEL REGULATORIO 0842 SOFIPO-----
==============================================================================*/
	Par_IdentificadorID	  	INT(11),			-- Consecutivo que identifica el registro
	Par_Anio                INT(11),            -- Anio en que se reporta
	Par_Mes                 INT(11),            -- mes de generacion del reporte

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
	DECLARE Var_Control		VARCHAR(50);
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
                          concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-REGULATORIOD0842003BAJ');
          SET Var_Control := 'SQLEXCEPTION';
        END;

		IF (Par_Anio=Entero_Cero)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'El Ano del Periodo esta Vacio';
				SET Var_Control  := 'anio' ;
				LEAVE ManejoErrores;
		END IF;

	    IF (Par_Mes=Entero_Cero)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'El Mes del Periodo esta Vacio';
				SET Var_Control  := 'mes' ;
				LEAVE ManejoErrores;
		END IF;


		DELETE FROM REGULATORIOD0842003
			WHERE Consecutivo =  Par_IdentificadorID
				AND Anio	=	Par_Anio
				AND Mes		= 	Par_Mes;

		SET Par_NumErr := Entero_Cero;
        SET Par_ErrMen := CONCAT('Registro Eliminado Correctamente: ', Par_IdentificadorID);
        SET Var_Control:= 'identificadorID';

END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
     SELECT Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
 END IF;
END TerminaStore$$