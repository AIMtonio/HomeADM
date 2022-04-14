DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2PARAMSEJECUCIONALT;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2PARAMSEJECUCIONALT (
	-- SP para dar de alta registros de parametros de ejecucion
	Par_TipoEjecucion		CHAR(1),
	Par_EjecucionJobPdf		CHAR(1),
	Par_EjecucionJobTim		CHAR(1),
	Par_Instrumentos		TEXT,
	Par_EjecucionSPPrin		CHAR(1),
	Par_Salida          	CHAR(1),
	INOUT   Par_NumErr      INT(11),
	INOUT   Par_ErrMen      VARCHAR(400),
	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)

TerminaStore: BEGIN
	DECLARE CadenaVacia			CHAR(1);
	DECLARE EnteroUno			INT(11);
	DECLARE LETRA_S				CHAR(1);
	DECLARE LETRA_N				CHAR(1);
	DECLARE LETRA_C				CHAR(1);
	DECLARE SalidaSI			CHAR(1);

	-- Asignacion de constantes
	SET CadenaVacia				:='';
	SET EnteroUno				:= 1;
	SET LETRA_S					:= 'S';
	SET LETRA_N					:= 'N';
	SET LETRA_C					:= 'C';
	SET SalidaSI				:= 'S';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									'esto le ocasiona. Ref: SP-EDOCTAV2PARAMSEJECUCIONALT');

		END;

	SET Par_TipoEjecucion = 	IFNULL(Par_TipoEjecucion,CadenaVacia);
	SET Par_EjecucionJobPdf =	IFNULL(Par_EjecucionJobPdf,CadenaVacia);
	SET Par_EjecucionJobTim =	IFNULL(Par_EjecucionJobTim,CadenaVacia);
	SET Par_EjecucionSPPrin =	IFNULL(Par_EjecucionSPPrin,CadenaVacia);

	IF(Par_TipoEjecucion != LETRA_S AND Par_TipoEjecucion != LETRA_C) THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := CONCAT('Valor invalido para el parametro[Par_TipoEjecucion]');
		LEAVE ManejoErrores;
	END IF;

	IF(Par_EjecucionJobPdf != LETRA_S AND Par_EjecucionJobPdf != LETRA_N) THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := CONCAT('Valor invalido para el parametro[Par_EjecucionJobPdf]');
		LEAVE ManejoErrores;
	END IF;

	IF(Par_EjecucionJobTim != LETRA_S AND Par_EjecucionJobTim != LETRA_N) THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := CONCAT('Valor invalido para el parametro[Par_EjecucionJobTim]');
		LEAVE ManejoErrores;
	END IF;

	IF(Par_EjecucionSPPrin != LETRA_S AND Par_EjecucionSPPrin != LETRA_N) THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := CONCAT('Valor invalido para el parametro[Par_EjecucionSPPrin] ',Par_EjecucionSPPrin,'');
		LEAVE ManejoErrores;
	END IF;

	INSERT INTO EDOCTAV2PARAMSEJECUCIONHIS

	SELECT
		EjecucionID,	TipoEjecucion,	EjecucionJobPdf,	EjecucionJobTim,	EjecucionSPPrin,
		Instrumentos,	FechaEjecucion,	Usuario,			FechaActual,		DireccionIP,
		ProgramaID,		Sucursal,		NumTransaccion
	FROM EDOCTAV2PARAMSEJECUCION;

	DELETE FROM EDOCTAV2PARAMSEJECUCION;

	INSERT INTO EDOCTAV2PARAMSEJECUCION(
		TipoEjecucion,		EjecucionJobPdf,		EjecucionJobTim,		EjecucionSPPrin,	Instrumentos,
		FechaEjecucion,		Usuario,				FechaActual,			DireccionIP,		ProgramaID,
		Sucursal,			NumTransaccion)
	VALUES(
		Par_TipoEjecucion,	Par_EjecucionJobPdf,	Par_EjecucionJobTim,	Par_EjecucionSPPrin,Par_Instrumentos,
		NOW(),				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);


	SET Par_NumErr  := 000;
	SET Par_ErrMen  := CONCAT('Parametros agregados correctamente');

	END ManejoErrores;
	-- fin del manejador de errores.

	IF(Par_Salida = SalidaSI) THEN
	 	SELECT 	CONCAT(unhex('a'),'Par_NumErr=',Par_NumErr,unhex('a'),'Par_ErrMen=',Par_ErrMen,unhex('a')) AS Respuesta;

	END IF;


END TerminaStore$$
