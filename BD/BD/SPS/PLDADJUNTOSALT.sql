-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDADJUNTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDADJUNTOSALT`;DELIMITER $$

CREATE PROCEDURE `PLDADJUNTOSALT`(
	/*SP para adjuntar los archivos para el proceso de seguimiento de PLD.*/
	Par_AdjuntoID 					INT(11),					# Numero de Archivo Adjunto
	Par_TipoProceso 				INT(11),					# Tipo de Proceso que Adjunto el Archivo. 1.- Segto Ope. Inusuales 2.- Segto Ope. Interna Preocupanes
	Par_OpeInusualID 				BIGINT(20),					# Número de la Operación Inusual
	Par_OpeInterPreoID 				INT(11),					# Número de Operacion Interna Preocupante que adjunto el archivo.

	Par_Observacion 				VARCHAR(200),				# Descripcion breve referente al tipo de documento.
	Par_Recurso 					VARCHAR(500),				# Recurso o Nombre de la Página.

	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_AdjuntoID			INT(11);					-- ID Max de PLDADJUNTOS
	DECLARE Var_RutaArchivosPLD		VARCHAR(200);				-- Ruta del Archivo PLD
	DECLARE Var_Consecutivo 		VARCHAR(200);					-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_FechaRegistro 		DATE;						-- Fecha en la que se digitalizo el Archivo
	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);
	DECLARE TipoProc_Inusual		INT(11);
	DECLARE TipoProc_IntPreo		INT(11);

	-- Asignacion de constantes
	SET Estatus_Activo			:= 'A';							-- Estatus Activo
	SET Entero_Cero				:=0;							-- Entero Cero
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET SalidaSi				:= 'S';							-- Salida Si
	SET TipoProc_Inusual		:= 1;							-- Tipo de Proceso Inusual
	SET TipoProc_IntPreo		:= 2;							-- Tipo de Proceso Int. Preocupante

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDADJUNTOSALT');
			SET Var_Control		:= 'sqlException' ;
		END;

		SET Var_FechaRegistro := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_RutaArchivosPLD := (SELECT RutaArchivosPLD FROM PARAMETROSSIS LIMIT 1);

		IF(IFNULL(Par_TipoProceso,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Tipo de Proceso esta Vacio.';
			SET Var_Control	:= 'tipoProcesoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoProceso = TipoProc_Inusual AND IFNULL(Par_OpeInusualID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La Operacion Inusual esta Vacia.';
			SET Var_Control	:= 'tipoProcesoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoProceso = TipoProc_IntPreo AND IFNULL(Par_OpeInterPreoID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La Operacion Interna Preocupante esta Vacia.';
			SET Var_Control	:= 'tipoProcesoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Recurso,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'El Recurso esta Vacio.';
			SET Var_Control	:= 'ruta';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Observacion,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'La Observacion esta Vacia.';
			SET Var_Control	:= 'observacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_RutaArchivosPLD,Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'La Ruta para los Archivos PLD esta Vacia.';
			SET Var_Control	:= 'tipoProcesoID';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := NOW();
		SET Var_AdjuntoID	:= (SELECT IFNULL(MAX(AdjuntoID),Entero_Cero)+1 FROM PLDADJUNTOS);

		IF(Par_TipoProceso = TipoProc_Inusual AND IFNULL(Par_OpeInusualID,Entero_Cero) > Entero_Cero) THEN
			SET Var_Consecutivo := (SELECT IFNULL(MAX(Consecutivo),Entero_Cero)+1 FROM PLDADJUNTOS WHERE OpeInusualID = Par_OpeInusualID);
			SET Par_Recurso := CONCAT(Var_RutaArchivosPLD,"SEGTO_INUSUALES/",Par_OpeInusualID,"/",Par_Recurso);
		END IF;

		IF(Par_TipoProceso = TipoProc_IntPreo AND IFNULL(Par_OpeInterPreoID,Entero_Cero) > Entero_Cero) THEN
			SET Var_Consecutivo := (SELECT IFNULL(MAX(Consecutivo),Entero_Cero)+1 FROM PLDADJUNTOS WHERE OpeInterPreoID = Par_OpeInterPreoID);
			SET Par_Recurso := CONCAT(Var_RutaArchivosPLD,"SEGTO_INTPREOCUPANTES/",LPAD(Par_OpeInterPreoID,12,"0"),"/",Par_Recurso);
		END IF;

		SET Par_Recurso := REPLACE(Par_Recurso,"//","/");

		INSERT INTO PLDADJUNTOS(
			AdjuntoID,				TipoProceso,			OpeInusualID,			OpeInterPreoID,			Consecutivo,
			Observacion,			Recurso,				FechaRegistro,			EmpresaID,				Usuario,
			FechaActual,			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion
			)VALUES(
			Var_AdjuntoID,			Par_TipoProceso,		Par_OpeInusualID,		Par_OpeInterPreoID,		Var_Consecutivo,
			Par_Observacion,		Par_Recurso,			Var_FechaRegistro,		Aud_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Archivo Adjuntado Exitosamente.');
		SET Var_Control 	:= 'adjuntar' ;
		SET Var_Consecutivo	:= Par_Recurso;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$