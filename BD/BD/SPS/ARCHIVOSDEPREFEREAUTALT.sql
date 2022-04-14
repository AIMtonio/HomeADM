-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOSDEPREFEREAUTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOSDEPREFEREAUTALT`;DELIMITER $$

CREATE PROCEDURE `ARCHIVOSDEPREFEREAUTALT`(
	/*
		SP QUE GUARDA EN LA TABLA ARCHIVOSDEPREFEREAUT
		LOS ARCHIVOS NUEVOS QUE SE LEEN DESDE EL KTR
	*/
	Par_NombreArchivo		VARCHAR(80),			-- Nombre del archivo a guardar
	Par_RutaArchivo			VARCHAR(300),			-- Ruta completa de donde esta el archivo
	Par_FechaCarga			DATETIME,					-- Fecha en que se realiza la carga
	Par_Estatus				CHAR(1),				-- Estatus del Archivo cuando se crea es N
	Par_Salida				CHAR(1),				-- Indicar si requiere salida S = Si N = No
	INOUT Par_NumErr		INT(11),				-- Parametro de salida del error o exito
	INOUT Par_ErrMen		VARCHAR(150),			-- Parametro de salida del mensaje de error o exito
	Par_EmpresaID			INT(11),				-- Parametro de auditoria
	Aud_Usuario				INT(11),				-- Parametro de auditoria
	Aud_FechaActual			DATE,					-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal			INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_NombreArchivo	VARCHAR(80);	-- Nombre del archivo en la BD
	DECLARE Var_Control			VARCHAR(50);	-- Variable de control
	DECLARE Var_Consecutivo		VARCHAR(50);	-- Variable para el valor consecutivo generado
	-- Declaracion de constantes
	DECLARE	Entero_Cero 	INT(11); 		-- Constante Entero Cero
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia		DATE;			-- Constante Fecha Vacia
	DECLARE SalidaSI		CHAR(1);		-- Constante Salida SI

	-- Seteo de valores
	SET Entero_Cero		:= 0;
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET SalidaSI		:= 'S';
	SET Aud_FechaActual := NOW();
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciones. Ref: SP-ARCHIVOSDEPREFEREAUTALT');
			SET Var_Control	:='SQLEXCEPTION';
		END;

		IF IFNULL(Par_NombreArchivo,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El nombre del archivo esta vacio';
			SET Var_Control := 'nombreArchivo';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_RutaArchivo,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'La ruta del archivo esta vacia';
			SET Var_Control := 'rutaArchivo';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_FechaCarga,Fecha_Vacia) = Fecha_Vacia THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'La fecha de carga esta vacia';
			SET Var_Control := 'fechaCarga';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Estatus,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El Estatus del archivo esta vacio';
			SET Var_Control := 'estatus';
			LEAVE ManejoErrores;
		END IF;

		SELECT NombreArchivo INTO Var_NombreArchivo
		FROM ARCHIVOSDEPREFEREAUT
		WHERE NombreArchivo = Par_NombreArchivo;

		IF IFNULL(Var_NombreArchivo,Cadena_Vacia) != Cadena_Vacia THEN
			SET Par_NumErr :=0; -- es un erro pero es necesario para continuar en el ktr
			SET Par_ErrMen := 'El Archivo ya se encuentra registrado';
			SET Var_Control := 'nombreArchivo';
			LEAVE ManejoErrores;
		END IF;
	
		SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero)+1 INTO Var_Consecutivo
		FROM ARCHIVOSDEPREFEREAUT;
        
		INSERT INTO ARCHIVOSDEPREFEREAUT
		(ConsecutivoID,NombreArchivo,	RutaArchivo,	FechaCarga,		Estatus,	EmpresaID,
		Usuario,		FechaActual,	DireccionIP,	ProgramaID,	Sucursal,
		NumTransaccion)
		VALUES
		(Var_Consecutivo,Par_NombreArchivo,	Par_RutaArchivo,	Par_FechaCarga,		Par_Estatus,	Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion);

		

		SET Par_NumErr :=0;
		SET Par_ErrMen := 'Archivo Agregado Correctamente';
		SET Var_Control := Cadena_Vacia;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS Control,
				Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$