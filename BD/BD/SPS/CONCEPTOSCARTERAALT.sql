-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCARTERAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSCARTERAALT`;
DELIMITER $$

CREATE PROCEDURE `CONCEPTOSCARTERAALT`(
	/*SP para dar de alta los Conceptos de Cartera de acuerdo al Accesorio Agregado */
    Par_ConceptoID			INT(11),			# Consecutivo
	Par_Descripcion			VARCHAR(50),		# Descripcion del Concepto

	Par_Salida				CHAR(1),			# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			# Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		# Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11) ,
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1); 		# Constante Cadena Vacía
	DECLARE Salida_SI 			CHAR(1); 		# Constante Salida Si
    DECLARE Entero_Cero			INT(11); 		# Constante Cero
    DECLARE Entero_Mil			INT(11);		# Constante Entero 1000
    DECLARE	Entero_MAYOR		INT(11);		# Constante 999 para manejor de id mayor

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(20); 	# Variable Control en Pantalla
	DECLARE Var_Consecutivo		VARCHAR(50); 	# Variable Consecutivo

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= ''; 			# Constante Cadena Vacía
	SET Salida_SI				:= 'S'; 		# Constante Salida Si
    SET Entero_Cero 			:= 0; 			# Constante Entero Cero
    SET Entero_Mil				:= 1000;		# Constante Entero mil
    SET Entero_MAYOR			:= 999;			# Constante 999 para manejor de id mayor	

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CONCEPTOSCARTERAALT');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		SET Par_ConceptoID		:= IFNULL(Par_ConceptoID, Entero_Cero);
		SET Par_Descripcion		:= IFNULL(Par_Descripcion, Cadena_Vacia);

		IF(Par_Descripcion = Cadena_Vacia) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen		:= 'La Descripcion No Puede Estar Vacia.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'descripcion';
            LEAVE ManejoErrores;
		END IF;

        IF EXISTS(SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE ConceptoCarID = Par_ConceptoID) THEN
			SET Par_NumErr		:= 002;
			SET Par_ErrMen		:= 'El Concepto de Cartera ya Existe.';
			SET Var_Consecutivo	:= Cadena_Vacia;
			SET Var_Control		:= 'conceptoCarteraID';
            LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();

		SET Par_ConceptoID:= (SELECT IFNULL(MAX(ConceptoCarID),Entero_MAYOR) + 1
			                    FROM CONCEPTOSCARTERA
			                    WHERE ConceptoCarID >= Entero_Mil);

		INSERT INTO CONCEPTOSCARTERA(
			ConceptoCarID,		Descripcion,		EmpresaID,		Usuario,		FechaActual,
            DireccionIP,		ProgramaID,			Sucursal,  	 	NumTransaccion)
		VALUES (
			Par_ConceptoID,		Par_Descripcion,	Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		SET	Par_NumErr			:= Entero_Cero;
		SET	Par_ErrMen			:= CONCAT('ConceptoCartera Agregado Exitosamente: ', CONVERT(Par_ConceptoID,CHAR));
		SET Var_Control			:= 'conceptoCarteraID';
		SET Var_Consecutivo		:= Par_ConceptoID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$