DELIMITER ;
DROP PROCEDURE IF EXISTS `VALCARGAMASIVADISPALT`;

DELIMITER $$
CREATE PROCEDURE `VALCARGAMASIVADISPALT`(
	Par_DispMasivaID 		INT(11),			-- Identificador de la Tabla CARGAMASIVADISP
	Par_Fila				INT(11),			-- Numero de fila del archivo
	Par_CatDispMasivaID		INT(11),			-- Numero de error

	Par_Salida            	CHAR(1),      		-- Indica si requiere salida
	INOUT Par_NumErr      	INT(11),        	-- Numero de error
	INOUT Par_ErrMen      	VARCHAR(400),   	-- Mensaje de error

  /* Parametros de Auditoria */
  	Par_EmpresaID           INT(11),        	
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,

	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(50);
	DECLARE Var_ValDispMasivaID INT(11);

	-- Declaracion de constantes
	DECLARE Salida_SI		CHAR(1);
	DECLARE Salida_NO		CHAR(1);
	DECLARE Entero_Cero		INT(11);

	-- seteo de valores
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Entero_Cero			:= 0;
	SET Aud_FechaActual 	:= NOW();

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr   := 999;
				SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					'esto le ocasiona. Ref: SP-VALCARGAMASIVADISPALT');
				SET Var_Control  := 'SQLEXCEPTION';
			END;


		SELECT IFNULL(MAX(ValDispMasivaID),Entero_Cero)+1 INTO Var_ValDispMasivaID
		FROM VALCARGAMASIVADISP;

		INSERT INTO VALCARGAMASIVADISP(ValDispMasivaID,		DispMasivaID,	Fila,			CatDispMasivaID,	EmpresaID,
										Usuario,			FechaActual,	DireccionIP,	ProgramaID, 		Sucursal,
										NumTransaccion)
		VALUES(	Var_ValDispMasivaID,	Par_DispMasivaID,	Par_Fila, 			Par_CatDispMasivaID, 	Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Validacion Agregada Exitosamente.');
		SET Var_Control := 'institucionID';
			
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_ValDispMasivaID AS Consecutivo;
	END IF;

END TerminaStore$$