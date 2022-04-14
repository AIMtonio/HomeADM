-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMPREGSECRETASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMPREGSECRETASALT`;DELIMITER $$

CREATE PROCEDURE `BAMPREGSECRETASALT`(
-- Store para dar de alta una pregunta  secreta
	Par_Redaccion       			VARCHAR(200),			-- Redaccion de la pregunta secreta

    Par_Salida          			CHAR(1),				-- Indica si el SP genera una salida
    INOUT Par_NumErr    			INT(11),					-- Parametro de salida con el num. de error.
    INOUT Par_ErrMen    			VARCHAR(400),			-- Parametro de salida con el mensaje de error

    Par_EmpresaID       			INT(11),				-- Auditoria
    Aud_Usuario         			INT(11),				-- Auditoria
    Aud_FechaActual     			DATETIME,				-- Auditoria
    Aud_DireccionIP     			VARCHAR(15),			-- Auditoria
    Aud_ProgramaID      			VARCHAR(50),			-- Auditoria
    Aud_Sucursal        			INT(11),				-- Auditoria
    Aud_NumTransaccion  			BIGINT(20)				-- Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_PreguntaSecretaID   BIGINT;      -- Consecutivo
    DECLARE Var_Control     		VARCHAR(50); -- Variable de control

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);     -- Cadena vacia
	DECLARE Entero_Cero     		INT;         -- Entero cero
	DECLARE SalidaSI        		CHAR(1);	 -- Genera una salida

	-- Asignacion  de constantes
	SET Cadena_Vacia    := '';              	-- Cadena o string vacio
	SET Entero_Cero     := 0;               	-- Entero en cero
	SET SalidaSI        := 'S';             	-- El Store SI genera una Salida



	ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMPREGSECRETASALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		IF(IFNULL(Par_Redaccion, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'La Redaccion esta Vacia';
				SET Var_Control := 'redaccion';
				LEAVE ManejoErrores;
		END IF;

		 -- Consecutivo
			CALL FOLIOSAPLICAACT('BAMPREGSECRETAS', Var_PreguntaSecretaID);

			SET Aud_FechaActual := NOW();

			INSERT INTO BAMPREGSECRETAS (
				PreguntaSecretaID,		Redaccion,			EmpresaID,		Usuario,		FechaActual,
                DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
			VALUES (
				Var_PreguntaSecretaID,  Par_Redaccion,		Par_EmpresaID,	Aud_Usuario,
                Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := 'Pregunta Secreta Agregada Exitosamente';
			SET Var_Control := 'preguntaSecretaID';

		END ManejoErrores;  -- END del Handler de Manejo Errores

		IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					IFNULL(Var_PreguntaSecretaID, Entero_Cero) AS consecutivo;
		END IF;

END TerminaStore$$