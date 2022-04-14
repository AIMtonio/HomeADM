
DELIMITER ;
DROP PROCEDURE IF EXISTS `ALGORITMOBANSEFICAL`;
DELIMITER $$

CREATE PROCEDURE `ALGORITMOBANSEFICAL`(
-- SP QUE REALIZA EL CALCULO DEL ALGORITMO BANSEFI
	Par_InstitucionID		INT(11),		-- Id de la institucion
	Par_Referencia			VARCHAR(18),	-- Numero de referencia (Credito)
	INOUT Par_NuevaRefe		VARCHAR(19),	-- Numero de referencia final

	Par_Salida				CHAR(1),		-- Salida   S:SI  N:NO
	INOUT Par_NumErr		INT(11),		-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400)	-- Mensaje de error
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(100);	-- Variable de control
	DECLARE Var_Consecutivo 	VARCHAR(100);	-- Consecutivo
	DECLARE Var_Contador		INT(11);		-- Contador
	DECLARE Var_NumCaracteres	VARCHAR(15);	-- Numero de caracteres
	DECLARE Var_Referencia		VARCHAR(19);    -- Numero de credito
	DECLARE Var_CveEmisor		INT(11);		-- Clave del emisor
    DECLARE Var_NumCredito		CHAR(15);		-- Numero de credito (15 digitos con ceros)
    DECLARE Var_DigitoVerif		INT(11);    	-- Digito verificador
    DECLARE Var_LongCveEmis		INT(11);		-- Longitud de la clave del emisor

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);		-- Constantes Entero Cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Salida_SI			CHAR(1);		-- Constante SI

	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Salida_SI			:='S';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
							  concretar la operacion.Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-ALGORITMOBANSEFICAL');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        IF(IFNULL(Par_InstitucionID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'La Institucion esta Vacia';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Referencia, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'La Referencia esta Vacia';
			SET Var_Control		:= 'referencia';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Var_CveEmisor := (SELECT CveEmision FROM INSTITUCIONES WHERE InstitucionID = Par_InstitucionID);
        SET Var_LongCveEmis := LENGTH(Var_CveEmisor);
        IF(Var_LongCveEmis <> 3) THEN
			SET Par_NumErr 		:= 3;
			SET Par_ErrMen 		:= 'La Clave del Emisor debe ser de 3 digitos';
			SET Var_Control		:= 'referencia';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;
		SET Var_NumCredito := LPAD(Par_Referencia, 15,0);

		SET Var_Referencia := CONCAT(Var_CveEmisor, Var_NumCredito);

        -- Se genera el codigo verificador
        SET Var_DigitoVerif := FNGENERADIGVERIMOD10(Var_Referencia);

        IF(ISNULL(Var_DigitoVerif)) THEN
			SET Par_NumErr 		:= 4;
			SET Par_ErrMen 		:= 'Error al generar el Digito Verificador';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NuevaRefe := CONCAT(Var_Referencia,Var_DigitoVerif);


        SET Var_NumCaracteres := CHAR_LENGTH(Par_NuevaRefe);

        -- Se valida que la longitud de la Referencia sea 19
        IF(Var_NumCaracteres <> 19)THEN
			SET Par_NumErr 		:= 5;
			SET Par_ErrMen 		:= 'Numero de Caracteres incorrecto';
			SET Var_Control		:= 'institucionID';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= Par_NuevaRefe;
		SET Var_Control		:= 'referencia';
		SET Var_Consecutivo	:= Par_NuevaRefe;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;
END TerminaStore$$