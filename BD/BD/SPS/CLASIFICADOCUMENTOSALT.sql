-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICADOCUMENTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICADOCUMENTOSALT`;DELIMITER $$

CREATE PROCEDURE `CLASIFICADOCUMENTOSALT`(
-- =====================================================================================
-- ------- STORED PARA ALTA DE DOCUMENTOS POR SU CLASIFICACION  ---------
-- =====================================================================================
    Par_clasDocID		    INT(11), 		-- Clasificacion de Documento
    Par_tipoDocID			INT(11), 	    -- Tipo de Documento

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_ConsecID     	INT(11);            -- Variable para el Consecutivo
    DECLARE Var_DocID	     	INT(11);            -- Variable para el ID del Documento

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_NO   	    	CHAR(1);      		-- Constante NO

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_NO		          	:= 'N';


	ManejoErrores:BEGIN

	/*	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-CLASIFICADOCUMENTOSALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;
      */

        SET Var_ConsecID := ( SELECT MAX(GrupoDocID) FROM CLASIFICAGRPDOC) + Entero_Uno;
        SET Var_DocID	:= (SELECT GrupoDocID  FROM CLASIFICAGRPDOC WHERE ClasificaTipDocID = Par_clasDocID AND TipoDocumentoID = Par_tipoDocID);
        SET Var_DocID	:= IFNULL(Var_DocID, Entero_Cero);

        IF (Var_DocID = Entero_Cero) THEN

			INSERT INTO CLASIFICAGRPDOC(
				GrupoDocID, 		ClasificaTipDocID,	 	TipoDocumentoID,        EmpresaID, 			Usuario,
				FechaActual, 		DireccionIP, 			ProgramaID,			    Sucursal, 			NumTransaccion)
			VALUES(
				Var_ConsecID,     Par_clasDocID,          	Par_tipoDocID,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,         Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Documento Agregado Exitosamente';
		SET Var_Control		:= 'clasificaTipDocID';
		SET Var_Consecutivo	:= Par_clasDocID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$