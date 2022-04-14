-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFPAGOSXINSTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `REFPAGOSXINSTBAJ`;
DELIMITER $$


CREATE PROCEDURE `REFPAGOSXINSTBAJ`(
/* SP DE BAJA PARA REFERENCIAS DE PAGO POR TIPO DE CANAL E INSTRUMENTO */
	Par_TipoCanalID				INT(11), 		-- ID del tipo de canal sólo para ctas y creditos. Corresponde a TIPOCANAL
	Par_InstrumentoID			BIGINT(20), 	-- ID del instrumento (CuentaAhoID, CreditoID).
	Par_TipoReferencia			CHAR(1),		-- Tipo de Referencias A = automatica, M = manual
    Par_InstitucionID			INT(11),			-- Numero de institucion	
    Par_NumOpe         			TINYINT UNSIGNED,	-- Numero de operacion

    Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT(11),		-- Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Error

    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     CHAR(15);
DECLARE	Var_Consecutivo INT(11);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

DECLARE Cons_OpeGral	INT(11);
DECLARE Cons_OpeInst	INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET Aud_FechaActual 	:= NOW();
SET Cons_OpeGral		:= 1;
SET Cons_OpeInst		:= 2;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-REFPAGOSXINSTBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

    -- Tipo de operacion que borra todas las referencias.
    IF(Par_NumOpe = Cons_OpeGral) THEN
	DELETE
      FROM REFPAGOSXINST
		WHERE TipoCanalID = IFNULL(Par_TipoCanalID,Entero_Cero)
			AND InstrumentoID = IFNULL(Par_InstrumentoID,Entero_Cero)
			AND TipoReferencia = Par_TipoReferencia;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Referencias Dadas de Baja Exitosamente.';
	SET Var_Control:= 'instrumentoID' ;
	END IF;
		-- TIpo de operacion que borra las referencias de una determinada institucion
      IF(Par_NumOpe = Cons_OpeInst) THEN
		DELETE 
		  FROM REFPAGOSXINST
			WHERE TipoCanalID = IFNULL(Par_TipoCanalID,Entero_Cero)
				AND InstrumentoID = IFNULL(Par_InstrumentoID,Entero_Cero)
				AND TipoReferencia = Par_TipoReferencia
                AND InstitucionID = Par_InstitucionID;

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Referencias Dadas de Baja Exitosamente.';
		SET Var_Control:= 'instrumentoID' ;
	END IF;
END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$