-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCARGAMOVSHEADALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCARGAMOVSHEADALT`;
DELIMITER $$


CREATE PROCEDURE `PLDCARGAMOVSHEADALT`(
	-- Procedimiento almacenado para cargar los archivos contenedores de los movimientos de los clientes externos
	Par_CheckSum				VARCHAR(50),	-- Numero indicador del checksum del archivo cargado
	Par_FechaIni				DATE,			-- Fecha de inicio de los movimientos a cargar
	Par_FechaFin				DATE,			-- Fecha de finalizacion de los movimientos a cargar

	Par_Salida					CHAR(1),		-- Parametro indicador de salida
	INOUT Par_NumErr			INT(11),		-- Parametro indicador del numero de error
	INOUT Par_ErrMen			VARCHAR(400),	-- Parametro indicador del mensaje de error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria
	Aud_Usuario					INT(11),		-- Parametro de auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal				INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria
)

TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);		-- Constante entero cero
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante de cadena vacia
	DECLARE Salida_SI				CHAR(1);		-- Constante salida si
	DECLARE Fecha_Vacia				DATE;			-- Constante de fecha vacia
	DECLARE Var_Fecha_Actual		DATE;			-- Variable de fecha actual
	DECLARE Var_Control				VARCHAR(20);	-- Variable de control
	DECLARE Var_CargaID				BIGINT(20);		-- Variable contenedora del numero de carga
	DECLARE Var_Anio				INT(4);			-- Variable contenedora del año
	DECLARE Var_Mes					INT(2);			-- Variable contenedora del mes
	DECLARE Var_Dia					INT(2);			-- Variable contenedora del dia
	DECLARE Var_Tiempo				INT(6);			-- Variable contenedora del tiempo
	DECLARE Var_NombreArchivo		VARCHAR(50);	-- Variable contenedora del nombre del archivo
	DECLARE Var_ExistArchivo		VARCHAR(50);	-- Variable para verificar la existencia del archivo
	DECLARE Var_CheckSum			VARCHAR(50);	-- Variable contenedora del checksum del archivo
	DECLARE Var_Consecutivo			VARCHAR(50);	-- Varibale consecutiva


	-- Asignacion de constantes
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET Salida_SI					:= 'S';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Var_Fecha_Actual			:= NOW();
	SET Var_Anio					:= YEAR(NOW());
	SET Var_Mes						:= LPAD(MONTH(NOW()),2,0);
	SET Var_Dia						:= LPAD(DAY(NOW()),2,0);
	SET Var_Tiempo					:= REPLACE(TIME(NOW()),':','');
	SET Var_CargaID					:= CONCAT(Var_Anio,Var_Mes,Var_Dia,Var_Tiempo);
	SET Var_NombreArchivo			:= CONCAT('PLDMOVS',REPLACE(Par_FechaIni,'-',''),REPLACE(Par_FechaFin,'-',''),'.txt');

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-PLDCARGAMOVSHEADALT');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

	SET Par_CheckSum				:= TRIM(IFNULL(Par_CheckSum,Cadena_Vacia));
	SET Par_FechaIni				:= IFNULL(Par_FechaIni,Fecha_Vacia);
	SET Par_FechaFin				:= IFNULL(Par_FechaFin,Fecha_Vacia);


	IF(Par_CheckSum = Cadena_Vacia) THEN
		SET Par_NumErr		:= 001;
		SET Par_ErrMen		:= 'El valor del CheckSum se encuentra vacio';
		SET Var_Control		:= 'Par_CheckSum';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_FechaIni = Fecha_Vacia) THEN
		SET Par_NumErr		:= 002;
		SET Par_ErrMen		:= 'La Fecha de inicio se encuentra vacio';
		SET Var_Control		:= 'Par_FechaIni';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_FechaFin = Fecha_Vacia) THEN
		SET Par_NumErr		:= 003;
		SET Par_ErrMen		:= 'La fecha de fin se encuentra vacio';
		SET Var_Control		:= 'Par_FechaFin';
		LEAVE ManejoErrores;
	END IF;

	SELECT CheckSum
	INTO Var_CheckSum
	FROM PLDCARGAMOVSHEAD
	WHERE CheckSum = Par_CheckSum;

	SET Var_CheckSum := IFNULL(Var_CheckSum,Cadena_Vacia);

	IF(Par_CheckSum = Var_CheckSum) THEN
		SET Par_NumErr		:= 004;
		SET Par_ErrMen		:= 'La CheckSum ya se encuentra agregado';
		SET Var_Control		:= 'Par_CheckSum';
		LEAVE ManejoErrores;
	END IF;


	INSERT INTO PLDCARGAMOVSHEAD (
		CargaID,			PIDTarea,			Estatus,			NombreArchivo,			CheckSum,
		FechaCarga,			FechaIni,			FechaFin,			MensajeError,			EmpresaID,
		Usuario,			FechaActual,		DireccionIP,		ProgramaID,				Sucursal,
		NumTransaccion
	) VALUES (
		Var_CargaID,		Cadena_Vacia,		Cadena_Vacia,		Var_NombreArchivo,		Par_CheckSum,
		Var_Fecha_Actual,	Par_FechaIni,		Par_FechaFin,		Cadena_Vacia,			Aud_EmpresaID,
		Aud_Usuario,		Var_Fecha_Actual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion
	);

	SET	Par_NumErr 	:= 000;
	SET	Par_ErrMen 	:= CONCAT("Los Movimientos han sido cargados exitosamente: ", CONVERT(Var_CargaID, CHAR));
	SET Var_Control := 'CargaID';
	SET Var_Consecutivo := Var_NombreArchivo;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$
