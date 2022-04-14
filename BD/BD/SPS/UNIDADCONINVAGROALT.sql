-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- UNIDADCONINVAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `UNIDADCONINVAGROALT`;DELIMITER $$

CREATE PROCEDURE `UNIDADCONINVAGROALT`(
# =====================================================================================
# ------- STORE PARA  DAR DE ALTA UNIDAD  DE INVERSION---------
# =====================================================================================
	Par_UniConceptoInvID		BIGINT(20),			    -- ID de la Unidad de Inversion
    Par_Unidad		            VARCHAR(100),				-- Descripcion
	Par_Clave		            VARCHAR(45),

    Par_Salida		            CHAR(1),				    -- indica una salida
    INOUT Par_NumErr		    INT(11),				    -- numero de error
    INOUT Par_ErrMen 		    VARCHAR(400),				-- mensaje de error

    Aud_EmpresaID   		    INT(11),    		        -- parametros de auditoria
    Aud_Usuario     		    INT(11),
    Aud_FechaActual   		    DATETIME,
    Aud_DireccionIP   		    VARCHAR(15),
    Aud_ProgramaID    		    VARCHAR(50),
    Aud_Sucursal       		    INT(11),
    Aud_NumTransaccion  		BIGINT(20)
    )
TerminaStore: BEGIN

    -- Declacion de Variables
    DECLARE Var_Control         VARCHAR(100); 			   -- Variable de control
    DECLARE Var_Consecutivo     BIGINT(20);

    -- consecutivo

    -- Declaracion de constantes
    DECLARE Entero_Cero         INT(11);				-- entero cero
    DECLARE Entero_Uno			INT(11);				-- entero uno
    DECLARE Cadena_Vacia        CHAR(1);				-- cadena vacia
    DECLARE Salida_SI           CHAR(1);    			-- salida si
    DECLARE Salida_NO           CHAR(1);    			-- salida no
    DECLARE Decimal_Cero        DECIMAL(14,2);			-- DECIMAL cero
	DECLARE Fecha_Vacia  		DATE;					-- fecha vacia
    DECLARE Descripcion  		VARCHAR(100);			-- descripcion del novimiento en caso de que venga vacio
	DECLARE Valida_Clave    	CHAR(13);               -- claveInv en caso de que venga vacio

    -- Asignacion de constantes
    SET Valida_Clave		:= Cadena_Vacia;
    SET Entero_Cero         := 0;               -- Entero Cero
    SET Entero_Uno			:= 1;				-- Entero Uno
    SET Cadena_Vacia        := '';              -- Cadena Vacia
    SET Salida_SI           := 'S';             -- Salida en Pantalla SI
    SET Salida_NO           := 'N';             -- Salida en Pantalla NO
    SET Decimal_Cero        := 0.00;            -- DECIMAL Cero
	SET Fecha_Vacia     	:= '1900-01-01';



    ManejoErrores:BEGIN


		DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  := 999;
                SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-UNIDADCONINVAGROALT');
                SET Var_Control := 'SQLEXCEPTION';
            END;

		-- Asignamos valor por defaul a varibles
		SET Aud_FechaActual  	:=  NOW();
SELECT
    (MAX(UniConceptoInvID) + Entero_Uno)
INTO Var_Consecutivo FROM
    UNIDADCONINVAGRO;

        IF(IFNULL(Par_Unidad, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 2;
            SET Par_ErrMen := 'La Unidad del Registro esta Vacia.';
            SET Var_Control:= 'Par_descripcion' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Clave, Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 3;
            SET Par_ErrMen := 'La Clave de Registro esta Vacia.';
            SET Var_Control:= 'Par_ClaveInv' ;
            LEAVE ManejoErrores;
        END IF;

	    IF (Par_Clave = Cadena_Vacia)THEN
		    SET Valida_Clave:=Cadena_Vacia;
		ELSE
		    SET Valida_Clave:=(SELECT Clave FROM UNIDADCONINVAGRO WHERE Clave = Par_Clave);
			IF (Valida_Clave = Par_Clave)THEN
			SET	Par_NumErr := 4;
			SET	Par_ErrMen := 'Clave ya existente';
			SET Var_Control := 'Clave de Unidad';
			LEAVE ManejoErrores;
		END IF;

	END IF;




		SET Var_Consecutivo := IFNULL(Var_Consecutivo,Entero_Uno);

        INSERT INTO UNIDADCONINVAGRO(
			UniConceptoInvID, 		Unidad,		           Clave, 	     	EmpresaID, 		Usuario,
            FechaActual, 		DireccionIP, 		   ProgramaID, 	    Sucursal, 		NumTransaccion)
		VALUES(
			Var_Consecutivo,  	Par_Unidad,		         Par_Clave, 	  Aud_EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,	    Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);

		SET     Par_NumErr 		:= 0;
		SET     Par_ErrMen 		:= CONCAT('Unidad Agregada Exitosamente : ', CONVERT(Var_Consecutivo, CHAR));
		SET     Var_Control 	:= 'uniConceptoInvID';
        SET     Var_Consecutivo := Var_Consecutivo;

    END ManejoErrores;

       IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr 		AS NumErr,
					Par_ErrMen 		AS ErrMen,
					Var_Control 	AS control,
					Var_Consecutivo AS consecutivo;
		END IF;
END TerminaStore$$