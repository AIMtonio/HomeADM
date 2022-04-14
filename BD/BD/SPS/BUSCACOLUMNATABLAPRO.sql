-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUSCACOLUMNATABLAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUSCACOLUMNATABLAPRO`;DELIMITER $$

CREATE PROCEDURE `BUSCACOLUMNATABLAPRO`(
# ===============================================================================================
# -- STORED PROCEDURE PARA VERIFICAR QUE EXISTE UNA COLUMNA DE UNA TABLA
# ===============================================================================================
	Par_NomTabla			VARCHAR(20),		-- Nombre de la tabla
	Par_NomColumna			VARCHAR(18),		-- Columna de la tabla

	Par_Salida				CHAR(1),			-- Indica si el SP genera o no una salida
	INOUT Par_NumErr		INT(11),			-- Parametro de salida que indica el num. de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro de salida que indica el mensaje de eror

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_Control     		VARCHAR(50);		-- Variable de Control

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE	Salida_Si				CHAR(1);			-- Indica que si se devuelve un mensaje de salida


	-- Asignacion de constantes
	SET Cadena_Vacia 			:= ''; 					-- Cadena Vacia
	SET	Salida_Si				:= 'S';					-- El SP si genera una salida

	-- Asignacion de variables
	SET Var_Control				:= Cadena_Vacia;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: SP-BUSCACOLUMNATABLAPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

			SET Par_NomTabla	:= IFNULL(Par_NomTabla, Cadena_Vacia);
			SET Par_NomColumna	:= IFNULL(Par_NomColumna, Cadena_Vacia);

			IF(Par_NomTabla = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El nombre de la tabla no ha sido espeficicado';
				SET Var_Control := 'Par_NomTabla';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_NomColumna = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen	:= 'El nombre de la columna no ha sido espeficicado';
				SET Var_Control := 'Par_NomColumna';
				LEAVE ManejoErrores;
			END IF;

			IF(NOT EXISTS(SELECT*FROM INFORMATION_SCHEMA.COLUMNS
							WHERE	TABLE_NAME	= Par_NomTabla
							  AND	COLUMN_NAME	= Par_NomColumna)) THEN
				SET Par_NumErr		:= 003;
				SET Par_ErrMen		:= CONCAT('La columna[',Par_NomColumna,'] NO se encontroen la tabla [',Par_NomTabla,']');
				SET Var_Control		:= 'ConceptoArrendaID';
				LEAVE ManejoErrores;
			END IF;

			-- El registro se actualizo exitosamente.
			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= CONCAT('La columna[',Par_NomColumna,'] se encontro en la tabla [',Par_NomTabla,']');
			SET Var_Control := '';

	END ManejoErrores; -- Fin del bloque manejo de errores

	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$